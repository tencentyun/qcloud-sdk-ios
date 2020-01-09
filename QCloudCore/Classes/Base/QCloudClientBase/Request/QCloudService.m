//
//  QCloudService.m
//  Pods
//
//  Created by Dong Zhao on 2017/3/13.
//
//

#import "QCloudService.h"
#import "QCloudHTTPSessionManager.h"
#import "QCloudServiceConfiguration_Private.h"
#import "NSError+QCloudNetworking.h"
#import "QCloudLogger.h"
@interface QCloudService ()
{
    NSMutableDictionary* _signatureCache;
    dispatch_queue_t _writeReadQueue;
    NSMutableDictionary* _requestingSignatureFileds;
 
}
@property (nonatomic,strong)NSString *backgroundTransmitIdentifier;
@end

@implementation QCloudService

- (instancetype) initWithConfiguration:(QCloudServiceConfiguration *)configuration
{
    self = [super init];
    if (!self) {
        return self;
    }
    configuration = [configuration copy];
    if (!configuration.endpoint) {
        @throw [NSException exceptionWithName:kQCloudNetworkDomain reason:[NSString stringWithFormat:@"您没有配置EndPoint就使用了服务%@", self.class] userInfo:nil];
    }
    
    if (![configuration.signatureProvider conformsToProtocol:NSProtocolFromString(@"QCloudSignatureProvider")]) {
        @throw [NSException exceptionWithName:kQCloudNetworkDomain reason:[NSString stringWithFormat:@"您没有配置signatureProvider或者没有实现对应的方法就使用了服务%@", self.class] userInfo:nil];
    }
    
   
    _configuration = configuration;
    _signatureCache = [NSMutableDictionary new];
    _requestingSignatureFileds = [NSMutableDictionary new];
    _writeReadQueue = dispatch_queue_create("com.tencent.qcloud.service.lock", DISPATCH_QUEUE_CONCURRENT);
    return self;
}

- (QCloudSignatureFields*) signatureFiledsForRequest:(QCloudBizHTTPRequest*)request
{
    QCloudSignatureFields* fileds = [request signatureFields];
    fileds.appID = self.configuration.appID;
    return fileds;
}

- (QCloudSignature*) authoriztionForFileds:(QCloudSignatureFields*)fields
{
    __block QCloudSignature* auth;
    dispatch_sync(_writeReadQueue, ^{
        auth = self->_signatureCache[fields.filed];
    });
    if ([auth.expiration compare:[NSDate date]] == NSOrderedAscending) {
        auth = nil;
        [self cacheSignature:nil forFields:fields];
    }
    return auth;
}

- (void) cacheSignature:(QCloudSignature*)signature forFields:(QCloudSignatureFields*)fields
{
    if (fields.filed.length == 0) {
        return;
    }

    dispatch_barrier_async(_writeReadQueue, ^{
        if (!signature) {
            [self->_signatureCache removeObjectForKey:fields.filed];
        } else {
            self->_signatureCache[fields.filed] = signature;
        }
    });
}

- (QCloudHTTPSessionManager *)sessionManager {
    return [QCloudHTTPSessionManager shareClient];
}

- (void) loadCOSV4AuthorizationForBiz:(QCloudBizHTTPRequest *)request urlRequest:(NSURLRequest *)urlrequest compelete:(QCloudHTTPAuthentationContinueBlock)cotinueBlock {
    NSAssert([self.configuration.signatureProvider respondsToSelector:@selector(signatureWithFields:request:urlRequest:compelete:)], @"您没有提供用于签名的委托者，请设置后再调用API");
    request.runOnService = self;
    QCloudSignatureFields* fileds = [self signatureFiledsForRequest:request];
    [self.configuration.signatureProvider signatureWithFields:fileds request:request urlRequest:(NSMutableURLRequest*)urlrequest compelete:cotinueBlock];
}

- (void) loadCOSXMLAuthorizationForBiz:(QCloudBizHTTPRequest *)request urlRequest:(NSURLRequest *)urlrequest compelete:(QCloudHTTPAuthentationContinueBlock)cotinueBlock
{
    NSAssert([self.configuration.signatureProvider respondsToSelector:@selector(signatureWithFields:request:urlRequest:compelete:)], @"您没有提供用于签名的委托者，请设置后再调用API");
    request.runOnService = self;
    QCloudSignatureFields* fileds = [self signatureFiledsForRequest:request];
    [self.configuration.signatureProvider signatureWithFields:fileds request:request urlRequest:(NSMutableURLRequest*)urlrequest compelete:cotinueBlock];
}

- (BOOL) fillCommonParamtersForRequest:(QCloudBizHTTPRequest *)request error:(NSError * _Nullable __autoreleasing *)error
{
    request.runOnService = self;
    request.signatureProvider = self.configuration.signatureProvider;
    if (self.configuration.userAgent.length) {
        [request.requestData setValue:self.configuration.userAgent forHTTPHeaderField:HTTPHeaderUserAgent];
    }
    return YES;
}

- (void) loadAuthorizationForBiz:(QCloudBizHTTPRequest*)bizRequest urlRequest:(NSMutableURLRequest*)urlrequest compelete:(QCloudHTTPAuthentationContinueBlock)cotinueBlock
{
    if (cotinueBlock) {
        cotinueBlock(nil, nil);
    }
}
- (int) performRequest:(QCloudBizHTTPRequest*)httpRequst
{
    QCloudLogDebug(@"performRequest begin httpRequst.runOnService :%@",httpRequst.runOnService);
 
    httpRequst.timeoutInterval = self.configuration.timeoutInterval;
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSError* error;
        [self fillCommonParamtersForRequest:httpRequst error:&error];
        if (error) {
            [httpRequst onError:error];
            return ;
        }
       
        [[QCloudHTTPSessionManager shareClient] performRequest:httpRequst];
    });
    
    return (int)httpRequst.requestID;
}

- (int) performRequest:(QCloudBizHTTPRequest *)httpRequst  withFinishBlock:(QCloudRequestFinishBlock)block
{
    httpRequst.timeoutInterval = self.configuration.timeoutInterval;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSError* error;
        [self fillCommonParamtersForRequest:httpRequst error:&error];
        if (error) {
            [httpRequst onError:error];
            return ;
        }
          [[QCloudHTTPSessionManager shareClient] performRequest:httpRequst withFinishBlock:block];
    });
    return (int)httpRequst.requestID;
}

@end
