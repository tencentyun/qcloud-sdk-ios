//
//  QCloudHTTPRequest.m
//  QCloudNetworking
//
//  Created by tencent on 15/9/25.
//  Copyright © 2015年 QCloudTernimalLab. All rights reserved.
//

#import "QCloudHTTPRequest.h"
#import "QCloudRequestData.h"
#import "QCloudRequestSerializer.h"
#import "QCloudHTTPRetryHanlder.h"
#import "QCloudNetEnv.h"
#import "QCloudHttpDNS.h"
#import "QCloudIntelligenceTimeOutAdapter.h"
#import "QCloudHTTPRequest_RequestID.h"
#import "QCloudHttpMetrics.h"
#import "QCloudLogger.h"
#import "QCloudObjectModel.h"
#import "QCloudSupervisory.h"
#import "QCloudHTTPSessionManager.h"
#import "NSError+QCloudNetworking.h"
#import "QCLOUDRestNet.h"
#import "QCloudService.h"

#import "NSDate+QCLOUD.h"
#import "NSDate+QCloudInternetDateTime.h"
#import "NSObject+HTTPHeadersContainer.h"
@interface QCloudHTTPRequest ()
{
    BOOL _requesting;
}
@property (atomic, assign) BOOL isCancel;
@property (nonatomic, strong, readonly) NSMutableURLRequest* cachedURLRequest;
@property (nonatomic, strong, readonly) NSError* cachedURLRequestBuildError;
@end



@implementation QCloudHTTPRequest
@synthesize httpURLResponse = _httpURLResponse;
@synthesize httpURLError = _httpURLError;

- (void) __baseCommonInit
{
    _requestData = [QCloudRequestData new];
    _requestSerializer = [QCloudRequestSerializer new];
    _responseSerializer = [QCloudResponseSerializer new];
    _requesting = NO;
    _requestSerializer.timeoutInterval = [QCloudIntelligenceTimeOutAdapter recommendTimeOut];
    //if request  is download request ,timeoutInterval = 30
    if (self.downloadingURL) {
        _requestSerializer.timeoutInterval = 30;
    }
    _isCancel = NO;
}

- (NSHTTPURLResponse*) httpURLResponse
{
    return _httpURLResponse;
}
- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    [self __baseCommonInit];
    return self;
}

- (void) notifyError:(NSError *)error
{
    [super notifyError:error];
    [[QCloudSupervisory supervisory] recordRequest:self error:error];

}

- (void) notifySuccess:(id)object
{
    [super notifySuccess:object];
    [[QCloudSupervisory supervisory] recordRequest:self error:nil];
}

- (void) loadConfigureBlock
{

    [self setConfigureBlock:^(QCloudRequestSerializer *requestSerializer, QCloudResponseSerializer *responseSerializer) {
      
        requestSerializer.HTTPMethod = HTTPMethodGET;
        [requestSerializer setSerializerBlocks:@[QCloudURLFuseSimple]];
        //
        [responseSerializer setSerializerBlocks:@[QCloudAcceptRespnseCodeBlock([NSSet setWithObject:@(200)], nil)]];
        
    }];
}

- (QCloudHTTPRequestConfigure) configureBlock
{
    if (!_configureBlock) {
        [self loadConfigureBlock];
    }
    return _configureBlock;
}

- (void) willStart
{
    QCloudLogDebug(@"[%llu] Will Start",self.requestID);
}



- (void) loadRetryPolicy
{
    _retryHandler = [QCloudHTTPRetryHanlder defaultRetryHandler];
}
- (QCloudHTTPRetryHanlder*) retryPolicy
{
    if (!_retryHandler) {
        [self loadRetryPolicy];
    }
    return _retryHandler;
}

- (BOOL) buildRequestData:(NSError *__autoreleasing *)error
{
    __block QCloudRequestSerializer* reqSerializer = self.requestSerializer;
    __block QCloudResponseSerializer* rspSerializer = self.responseSerializer;
    if (self.configureBlock) {
        self.configureBlock(reqSerializer, rspSerializer);
    }
    return YES;
}

- (void) clearBuildCache
{
    _cachedURLRequest = nil;
    _cachedURLRequestBuildError = nil;
}

- (NSURLRequest*) buildURLRequest:(NSError* __autoreleasing*)error
{

    if(![self buildRequestData:error])
    {
        return nil;
    }

    [self.benchMarkMan benginWithKey:kCalculateMD5STookTime];
    NSURLRequest*  request = [self.requestSerializer requestWithData:self.requestData error:error];
    if ([request.allHTTPHeaderFields objectForKey:@"Content-MD5"]) {
         [self.benchMarkMan markFinishWithKey:kCalculateMD5STookTime];
    }
   
    if (*error) {
        QCloudLogError(@"[%@][%lld]序列化失败",self.class, self.requestID);
        return nil;
    }
    QCloudLogDebug(@"SendingRequest [%lld]\n%@\n%@ \nrequest content:%@", self.requestID, request,request.allHTTPHeaderFields,[[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding] );
    return request;
}

- (void) onReviveErrorResponse:(NSURLResponse*)response error:(NSError*)error
{
    _httpURLResponse = (NSHTTPURLResponse*)response;
    _httpURLError  = error;
    if (NSURLErrorCancelled == error.code && [NSURLErrorDomain isEqualToString:error.domain]) {
        error = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeCanceled message:@"UserCancelled:The request is canceled"];
    }
    _httpURLError.__originHTTPURLResponse__ = _httpURLResponse;
    error.__originHTTPURLResponse__ = _httpURLResponse;
    [self onError:error];
}
- (void) onReciveRespone:(NSHTTPURLResponse *)response data:(NSData *)data
{
    _responseData = data;
    _httpURLResponse = response;
    //
    {
        NSUInteger headerLength = 0;
        NSDictionary* allHeaders = nil;
        if ([response respondsToSelector:@selector(allHeaderFields)]) {
            allHeaders = [response allHeaderFields];
        }
        if (allHeaders) {
            if (response.allHeaderFields) {
                NSData* headerData = [NSJSONSerialization dataWithJSONObject:allHeaders options:0 error:0];
                headerLength = headerData.length;
            }
        }

    }
    NSString *dateStr = [[response allHeaderFields] objectForKey:@"Date"];
    NSDate *serverTime = nil;
    NSDate *deviceTime =  [NSDate date];
    if ([dateStr length] > 0) {
        serverTime =  [NSDate qcloud_dateFromRFC822String:dateStr];
    }else {
        // The response header does not have the 'Date' field.
        // This should not happen.
        QCloudLogError(@"Date header does not exist. Not able to fix the time");

    }
    
    NSTimeInterval skewTime = [deviceTime timeIntervalSinceDate:serverTime];
   // If the time difference between the device and the server is large, fix device time
    NSLog(@"skewTime: %f",skewTime);
    if (skewTime >= 1*60) {
        [NSDate qcloud_setTimeDeviation:skewTime];
    }
    NSError* localError;
    id outputObject = [self.responseSerializer decodeWithWithResponse:response data:data error:&localError];
    if (localError) {
        localError.__originHTTPURLResponse__ = response;
        localError.__originHTTPResponseData__ = data;
        QCloudLogError(@"[%@][%lld] %@", [self class], self.requestID, localError);
        if ( [self isFixTime:localError]) {
             [NSDate qcloud_setTimeDeviation:skewTime];
        }
        [self onError:localError];
    } else {
        QCloudLogDebug(@"[%@][%lld] RESPONSE \n%@ ", [self class], self.requestID, [outputObject qcloud_modelToJSONString]);
        [outputObject set__originHTTPURLResponse__:response];
        [outputObject set__originHTTPResponseData__:data];
        [self onSuccess:outputObject];
    }
}

//Error code to be fix
-(BOOL)isFixTime:(NSError *)error{
    if ([error.userInfo[@"Code"] isEqualToString:@"RequestTimeTooSkewed"] ||([error.userInfo[@"Code"] isEqualToString:@"AccessDenied"] || [error.userInfo[@"Message"] isEqualToString:@"Request has expired"])) {
        return YES;
    }
    return NO;
}
- (BOOL) prepareInvokeURLRequest:(NSMutableURLRequest*)urlRequest error:(NSError* __autoreleasing*)error
{
    return YES;
}

- (void) cancel
{
    [super cancel];
     [[QCloudHTTPSessionManager shareClient] cancelRequestWithID:(int)self.requestID];
   
}


- (NSURLSessionResponseDisposition) reciveResponse:(NSURLResponse*)response
{
    return NSURLSessionResponseAllow;
}
@end
