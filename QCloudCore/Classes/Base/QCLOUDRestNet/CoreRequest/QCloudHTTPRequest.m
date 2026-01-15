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

#pragma mark - 域名切换相关正则表达式

// COS 域名: bucket.cos.region.myqcloud.com
static NSRegularExpression *_cosHostRegex;
// CI 域名: *.ci.region.myqcloud.com 或 ci.region.myqcloud.com
static NSRegularExpression *_ciHostRegex;
// 排除域名: 加速域名和服务域名
static NSRegularExpression *_excludeHostRegex;

@interface QCloudHTTPRequest () {
    BOOL _requesting;
}
@property (atomic, assign) BOOL isCancel;
@property (nonatomic, strong, readonly) NSMutableURLRequest *cachedURLRequest;
@property (nonatomic, strong, readonly) NSError *cachedURLRequestBuildError;
@property (nonatomic, strong) NSURLRequest *_Nullable urlRequest;

@end

@implementation QCloudHTTPRequest
@synthesize httpURLResponse = _httpURLResponse;
@synthesize httpURLError = _httpURLError;

+ (void)load {
    _cosHostRegex = [NSRegularExpression regularExpressionWithPattern:@"^[^.]+\\.cos\\.[^.]+\\.myqcloud\\.com$"
                                                              options:NSRegularExpressionCaseInsensitive
                                                                error:nil];
    _ciHostRegex = [NSRegularExpression regularExpressionWithPattern:@"^([^.]+\\.)?ci\\.[^.]+\\.myqcloud\\.com$"
                                                             options:NSRegularExpressionCaseInsensitive
                                                               error:nil];
    _excludeHostRegex = [NSRegularExpression regularExpressionWithPattern:@"(\\.cos\\.accelerate\\.myqcloud\\.com$|^service\\.cos\\.myqcloud\\.com$)"
                                                                  options:NSRegularExpressionCaseInsensitive
                                                                    error:nil];
}

- (void)__baseCommonInit {
    _requestData = [QCloudRequestData new];
    _requestSerializer = [QCloudRequestSerializer new];
    _responseSerializer = [QCloudResponseSerializer new];
    _requesting = NO;
    _requestSerializer.timeoutInterval = [QCloudIntelligenceTimeOutAdapter recommendTimeOut];
    // if request  is download request ,timeoutInterval = 30
    if (self.downloadingURL) {
        _requestSerializer.timeoutInterval = 30;
    }
    _isCancel = NO;
}

- (NSHTTPURLResponse *)httpURLResponse {
    return _httpURLResponse;
}
- (instancetype)init {
    self = [super init];
    if (!self) {
        return self;
    }
    [self __baseCommonInit];
    return self;
}

- (void)notifyError:(NSError *)error {
    [super notifyError:error];
    [[QCloudSupervisory supervisory] recordRequest:self error:error];
}

- (void)notifySuccess:(id)object {
    [super notifySuccess:object];
    [[QCloudSupervisory supervisory] recordRequest:self error:nil];
}

- (void)loadConfigureBlock {
    [self setConfigureBlock:^(QCloudRequestSerializer *requestSerializer, QCloudResponseSerializer *responseSerializer) {
        requestSerializer.HTTPMethod = HTTPMethodGET;
        [requestSerializer setSerializerBlocks:@[ QCloudURLFuseSimple ]];
        //
        [responseSerializer setSerializerBlocks:@[ QCloudAcceptRespnseCodeBlock([NSSet setWithObject:@(200)], nil) ]];
    }];
}

- (QCloudHTTPRequestConfigure)configureBlock {
    if (!_configureBlock) {
        [self loadConfigureBlock];
    }
    return _configureBlock;
}

- (void)willStart {
    QCloudLogDebugP(@"HTTP",@"[%llu] Will Start", self.requestID);
}

- (void)loadRetryPolicy {
    _retryHandler = [QCloudHTTPRetryHanlder defaultRetryHandler];
}
- (QCloudHTTPRetryHanlder *)retryPolicy {
    if (!_retryHandler) {
        [self loadRetryPolicy];
    }
    return _retryHandler;
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    __block QCloudRequestSerializer *reqSerializer = self.requestSerializer;
    __block QCloudResponseSerializer *rspSerializer = self.responseSerializer;
    if (self.configureBlock) {
        self.configureBlock(reqSerializer, rspSerializer);
    }
    return YES;
}

- (void)clearBuildCache {
    _cachedURLRequest = nil;
    _cachedURLRequestBuildError = nil;
}

- (NSURL *)downloadingTempURL{
    if(_downloadingURL){
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@.downloading",_downloadingURL.absoluteString]];
    }else{
        return nil;
    }
}

- (NSURLRequest *)buildURLRequest:(NSError *__autoreleasing *)error {
    if (![self buildRequestData:error]) {
        return nil;
    }

    if (self.isRetry) {
        [self.requestData setValue:@"true" forHTTPHeaderField:@"x-cos-sdk-retry"];
    }
    
    [self.benchMarkMan benginWithKey:kCalculateMD5STookTime];
    NSURLRequest *request = [self.requestSerializer requestWithData:self.requestData error:error];
    if ([request.allHTTPHeaderFields objectForKey:@"Content-MD5"]) {
        [self.benchMarkMan markFinishWithKey:kCalculateMD5STookTime];
    }

    if (*error) {
        QCloudLogErrorE(@"",@"[%@][%lld]序列化失败", self.class, self.requestID);
        return nil;
    }
    QCloudLogDebugP(@"HTTP",@"SendingRequest [%lld]\n%@\n%@ \nrequest content:%@", self.requestID, request, request.allHTTPHeaderFields,
                   [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]);
    self.urlRequest = request;
    return request;
}

- (void)onReviveErrorResponse:(NSURLResponse *)response error:(NSError *)error {
    _httpURLResponse = (NSHTTPURLResponse *)response;
    _httpURLError = error;
    if (NSURLErrorCancelled == error.code && [NSURLErrorDomain isEqualToString:error.domain]) {
        error = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeCanceled message:@"UserCancelled:The request is canceled" infos:@{kQCloudErrorDetailCode:@(NSURLErrorCancelled)}];
    }
    _httpURLError.__originHTTPURLResponse__ = _httpURLResponse;
    error.__originHTTPURLResponse__ = _httpURLResponse;
    [self onError:error];
}
- (void)onReciveRespone:(NSHTTPURLResponse *)response data:(NSData *)data {
    _responseData = data;
    _httpURLResponse = response;
    NSString *dateStr = [[response allHeaderFields] objectForKey:@"Date"];
    NSDate *serverTime = nil;
    NSDate *deviceTime = [NSDate date];
    if ([dateStr length] > 0) {
        serverTime = [NSDate qcloud_dateFromRFC822String:dateStr];
    } else {
        // The response header does not have the 'Date' field.
        // This should not happen.
        QCloudLogErrorE(@"",@"Date header does not exist. Not able to fix the time");
    }
    
    NSTimeInterval skewTime = 0;
    if (serverTime) {
        skewTime = [deviceTime timeIntervalSinceDate:serverTime];
    }
    // If the time difference between the device and the server is large, fix device time
    QCloudLogDebugP(@"HTTP",@"skewTime: %f", skewTime);
    if (skewTime >= 1 * 60) {
        [NSDate qcloud_setTimeDeviation:skewTime];
    }
    NSError *localError;
    id outputObject = [self.responseSerializer decodeWithWithResponse:response data:data error:&localError];
    if (localError) {
        localError.__originHTTPURLResponse__ = response;
        localError.__originHTTPResponseData__ = data;
        QCloudLogErrorE(@"HTTP",@"[%@][%lld] %@", [self class], self.requestID, localError);
        if ([self isFixTime:localError]) {
            [NSDate qcloud_setTimeDeviation:skewTime];
        }
        [self onError:localError];
    } else {
        QCloudLogDebugP(@"HTTP",@"[%@][%lld] RESPONSE \n%@ ", [self class], self.requestID, [outputObject qcloud_modelToJSONString]);
        [outputObject set__originHTTPURLResponse__:response];
        [outputObject set__originHTTPResponseData__:data];
        [self onSuccess:outputObject];
    }
}

// Error code to be fix
- (BOOL)isFixTime:(NSError *)error {
    if ([error.userInfo[@"Code"] isEqualToString:@"RequestTimeTooSkewed"]
        || ([error.userInfo[@"Code"] isEqualToString:@"AccessDenied"] || [error.userInfo[@"Message"] isEqualToString:@"Request has expired"])) {
        return YES;
    }
    return NO;
}
- (BOOL)prepareInvokeURLRequest:(NSMutableURLRequest *)urlRequest error:(NSError *__autoreleasing *)error {
    return YES;
}

- (void)cancel {
    [super cancel];
    [[QCloudHTTPSessionManager shareClient] cancelRequestWithID:(int)self.requestID];
}

- (NSURLSessionResponseDisposition)reciveResponse:(NSURLResponse *)response {
    return NSURLSessionResponseAllow;
}

-(BOOL)needChangeHost{
    NSString * host = self.urlRequest.URL.host;
    return [QCloudHTTPRequest needChangeHost:host];
}

/// 判断是否为 CI 域名
- (BOOL)isCIHost {
    NSString * host = self.urlRequest.URL.host;
    return [QCloudHTTPRequest isCIHost:host];
}

/// 判断是否为 COS 域名
- (BOOL)isCOSHost {
    NSString * host = self.urlRequest.URL.host;
    return [QCloudHTTPRequest isCOSHost:host];
}

#pragma mark - 域名切换相关私有类方法

+ (BOOL)isCIHost:(NSString *)host {
    if (!host) {
        return NO;
    }
    NSRange fullRange = NSMakeRange(0, host.length);
    return [_ciHostRegex firstMatchInString:host options:0 range:fullRange] != nil;
}

+ (BOOL)isCOSHost:(NSString *)host {
    if (!host) {
        return NO;
    }
    NSRange fullRange = NSMakeRange(0, host.length);
    
    // 先检查是否在排除列表中
    if ([_excludeHostRegex firstMatchInString:host options:0 range:fullRange]) {
        return NO;
    }
    
    return [_cosHostRegex firstMatchInString:host options:0 range:fullRange] != nil;
}

+ (BOOL)hasValidRequestId:(NSDictionary *)responseHeaders forHost:(NSString *)host {
    if (!responseHeaders || responseHeaders.count == 0) {
        return NO;
    }
    
    // 不区分大小写检查响应头
    // CI 域名检查 x-ci-request-id，COS 域名检查 x-cos-request-id
    NSString *requestIdKey = [self isCIHost:host] ? @"x-ci-request-id" : @"x-cos-request-id";
    
    for (NSString *key in responseHeaders.allKeys) {
        if ([key isEqualToString:requestIdKey]) {
            return YES;
        }
    }
    return NO;
}

+ (NSString *)getBackupHost:(NSString *)host {
    if (!host) {
        return nil;
    }
    
    if ([self isCIHost:host]) {
        // CI 域名: myqcloud.com -> tencentci.cn
        return [host stringByReplacingOccurrencesOfString:@"myqcloud.com" withString:@"tencentci.cn"];
    } else {
        // COS 域名: myqcloud.com -> tencentcos.cn
        return [host stringByReplacingOccurrencesOfString:@"myqcloud.com" withString:@"tencentcos.cn"];
    }
}

+ (BOOL)isBackupHost:(NSString *)host {
    if (!host) {
        return NO;
    }
    return [host rangeOfString:@"tencentcos.cn" options:NSCaseInsensitiveSearch].length > 0 ||
           [host rangeOfString:@"tencentci.cn" options:NSCaseInsensitiveSearch].length > 0;
}

+ (BOOL)needChangeHost:(NSString *)host responseHeaders:(NSDictionary *)responseHeaders {
    if (!host) {
        return NO;
    }
    
    // 如果已经是备用域名，不需要再切换
    if ([self isBackupHost:host]) {
        return NO;
    }
    
    // 检查是否匹配 COS 或 CI 域名格式
    BOOL isSupportedHost = [self isCOSHost:host] || [self isCIHost:host];
    if (!isSupportedHost) {
        return NO;
    }
    
    // 如果响应头中包含有效的 request-id，说明已到达服务端，不需要切换
    if ([self hasValidRequestId:responseHeaders forHost:host]) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)needChangeHost:(NSString *)host {
    return [self needChangeHost:host responseHeaders:nil];
}

- (void)setEndpoint:(QCloudEndPoint *)endpoint{
    super.endpoint = endpoint;
    self.requestData.endpoint = endpoint;
}
@end
