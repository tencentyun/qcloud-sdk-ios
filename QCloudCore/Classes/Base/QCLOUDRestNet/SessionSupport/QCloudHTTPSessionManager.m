//
//  QCloudHTTPSessionManager.m
//  QCloudTernimalLab_CommonLogic
//
//  Created by tencent on 16/3/30.
//  Copyright © 2016年 QCloudTernimalLab. All rights reserved.
//

#import "QCloudHTTPSessionManager.h"
#import "QCloudHTTPRequest.h"
#import "QCloudEnv.h"
#import "QCloudHttpDNS.h"
#import "QCloudHTTPRetryHanlder.h"
#import "QCloudURLSessionTaskData.h"
#import <objc/runtime.h>
#import "QCloudHTTPRequest_RequestID.h"
#import "QCloudHttpMetrics.h"
#import "QCloudNetEnv.h"
#import "QCloudHTTPRequestOperation.h"
#import "QCloudLogger.h"
#import "QCloudNetProfile.h"
#import "QCloudOperationQueue.h"
#import "NSError+QCloudNetworking.h"
#import "QCloudFileUtils.h"
#import "QCloudFileOffsetBody.h"
#import "QCloudRequestData.h"
#import "QCloudService.h"
#import "UIDevice+QCloudFCUUID.h"
#import "QCloudThreadSafeMutableDictionary.h"
#import "QCloudWeakProxy.h"
#import "QCloudLoaderManager.h"

#ifndef __IPHONE_13_0
#define __IPHONE_13_0    130000
#endif

NSString *TaskDataKey(int64_t identifier) {
    return [NSString stringWithFormat:@"data-%lld", identifier];
}

NSString *TaskMapKey(NSURLSessionTask *task) {
    return [NSString stringWithFormat:@"%p", (void *)task];
}
NSString *const kQCloudRestNetURLUsageNotification = @"kQCloudRestNetURLUsageNotification";

QCloudThreadSafeMutableDictionary *cloudBackGroundSessionManagersCache;
QCloudThreadSafeMutableDictionary *QCloudBackgroundSessionManagerCache(void) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cloudBackGroundSessionManagersCache = [QCloudThreadSafeMutableDictionary new];
    });
    return cloudBackGroundSessionManagersCache;
}

@implementation NSDictionary (QCloudRestNetUsage)
- (NSURL *)bdwt_RestNetCoreUsagedURL {
    return self[@"url"];
}

@end

@interface QCloudHTTPSessionManager () <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate> {
    NSMutableDictionary *_taskQueue;
}
@property (nonatomic, strong) NSOperationQueue *sessionTaskQueue;
;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) dispatch_queue_t buildDataQueue;
@property (nonatomic, strong) QCloudOperationQueue *operationQueue;
@property (nonatomic, strong) id quicSession;
@end

@implementation QCloudHTTPSessionManager
@synthesize maxConcurrencyTask = _maxConcurrencyTask;

+ (QCloudHTTPSessionManager *)shareClient {
    static QCloudHTTPSessionManager *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[QCloudHTTPSessionManager alloc] initWithConfigruation:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [QCloudNetEnv shareEnv];
    });
    return client;
}

- (instancetype)initWithConfigruation:(NSURLSessionConfiguration *)configuration {
    self = [super init];
    if (!self) {
        return self;
    }

    // for restful request-response using the default session configuration ,and the most import thing is that you must not set the timeout for
    // session configuration
    _configuration = configuration;
    _sessionTaskQueue = [[NSOperationQueue alloc] init];
    _session = [NSURLSession sessionWithConfiguration:_configuration delegate:self delegateQueue:_sessionTaskQueue];
    Class cls = NSClassFromString(@"QCloudQuicSession");
    if (cls) {
        SEL createQuicSessionSelector = NSSelectorFromString(@"quicSessionDelegate:");
        if ([cls respondsToSelector:createQuicSessionSelector]) {
            IMP imp = [cls methodForSelector:createQuicSessionSelector];
            id (*func)(id, SEL, id) = (void *)imp;
            _quicSession = func(cls, createQuicSessionSelector, self);
        }
    } else {
        QCloudLogDebugE(@"HTTP",@"quicSession is nil");
    }
    
    _buildDataQueue = dispatch_queue_create("com.tencent.qcloud.build.data", NULL);
    _taskQueue = [NSMutableDictionary new];
    _operationQueue = [QCloudOperationQueue new];
    return self;
}

- (void)setCustomConcurrentCount:(int)customConcurrentCount {
    _customConcurrentCount = customConcurrentCount;
    _operationQueue.customConcurrentCount = customConcurrentCount;
}

- (void)setMaxConcurrentCountLimit:(int)maxConcurrentCountLimit{
    _maxConcurrentCountLimit = maxConcurrentCountLimit;
    _operationQueue.maxConcurrentCountLimit = maxConcurrentCountLimit;
}

- (void)setMaxConcurrencyTask:(int32_t)maxConcurrencyTask {
    if (_maxConcurrencyTask != maxConcurrencyTask) {
        _maxConcurrencyTask = maxConcurrencyTask;
        _sessionTaskQueue.maxConcurrentOperationCount = maxConcurrencyTask;
    }
}

- (void)cacheTask:(NSURLSessionTask *)task data:(QCloudURLSessionTaskData *)data forSEQ:(int)seq {
    if (!task) {
        return;
    }
    @synchronized(self) {
        [_taskQueue setObject:@(seq) forKey:TaskMapKey(task)];
        [_taskQueue setObject:task forKey:@(seq)];
        [_taskQueue setObject:data forKey:TaskDataKey(seq)];
    }
}

- (NSURLSessionTask *)taskForSEQ:(int)seq {
    @synchronized(self) {
        return [_taskQueue objectForKey:@(seq)];
    }
}
- (QCloudURLSessionTaskData *)taskDataForTask:(NSURLSessionTask *)task {
    @synchronized(self) {
        int seq = [_taskQueue[TaskMapKey(task)] intValue];
        return [_taskQueue objectForKey:TaskDataKey(seq)];
    }
}
- (int)seqForTask:(NSURLSessionTask *)task {
    @synchronized(self) {
        return [_taskQueue[TaskMapKey(task)] intValue];
    }
}

- (void)removeTaskForSEQ:(int)seq {
    @synchronized(self) {
        NSURLSessionTask *task = _taskQueue[@(seq)];
        [_taskQueue removeObjectForKey:@(seq)];
        [_taskQueue removeObjectForKey:TaskDataKey(seq)];
        if (task) {
            [_taskQueue removeObjectForKey:TaskMapKey(task)];
        }
    }
    [_operationQueue cancelByRequestID:seq];
}

- (void)removeTask:(NSURLSessionTask *)task {
    @synchronized(self) {
        int seq = [_taskQueue[TaskMapKey(task)] intValue];
        [_taskQueue removeObjectForKey:@(seq)];
        [_taskQueue removeObjectForKey:TaskDataKey(seq)];
        [_taskQueue removeObjectForKey:TaskMapKey(task)];
    }
}

- (int)performRequest:(QCloudHTTPRequest *)httpRequst withFinishBlock:(QCloudRequestFinishBlock)block {
    httpRequst.finishBlock = block;
    return [self performRequest:httpRequst];
}

- (int)performRequest:(QCloudHTTPRequest *)request {
    
    QCloudHTTPRequestOperation *operation = [[QCloudHTTPRequestOperation alloc] initWithRequest:request];
    operation.sessionManager = self;
    [_operationQueue addOpreation:operation];
    return (int)request.requestID;
}

- (void)requestOperationFinishWithRequestId:(int64_t)requestID{
    [_operationQueue requestOperationFinishWithRequestId:requestID];
}

#if TARGET_OS_IOS
// only work at iOS 10 and up
- (void)URLSession:(NSURLSession *)session
                          task:(NSURLSessionTask *)task
    didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics API_AVAILABLE(ios(10.0)) {
    QCloudURLSessionTaskData *taskData = [self taskDataForTask:task];
    //        NSAssert(taskData, @"无法获取缓存的TaskData，请检查主动Cache的地方");
    NSURLSessionTaskTransactionMetrics *networkMetrics = nil;
    for (NSURLSessionTaskTransactionMetrics *m in metrics.transactionMetrics) {
        if (m.resourceFetchType == NSURLSessionTaskMetricsResourceFetchTypeNetworkLoad) {
            networkMetrics = m;
        } else if (m.resourceFetchType == NSURLSessionTaskMetricsResourceFetchTypeLocalCache) {
        }
    }

    if (networkMetrics) {
        if (!networkMetrics.reusedConnection) {
            [taskData.httpRequest.benchMarkMan directSetCost:[networkMetrics.connectEndDate timeIntervalSinceDate:networkMetrics.connectStartDate]
                                                      forKey:kConnectTookTime];
            if ([taskData.httpRequest.requestData.serverURL.lowercaseString hasPrefix:@"https"]) {
                [taskData.httpRequest.benchMarkMan
                    directSetCost:[networkMetrics.secureConnectionEndDate timeIntervalSinceDate:networkMetrics.secureConnectionStartDate]
                           forKey:kSecureConnectTookTime];
            }
            [taskData.httpRequest.benchMarkMan
                directSetCost:[networkMetrics.domainLookupEndDate timeIntervalSinceDate:networkMetrics.domainLookupStartDate]
                       forKey:kDnsLookupTookTime];
        }
       #if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0
        if (@available(iOS 13.0, *)) {
            [taskData.httpRequest.benchMarkMan directSetValue:networkMetrics.localPort forKey:kLocalPort];
            [taskData.httpRequest.benchMarkMan directSetValue:networkMetrics.remoteAddress forKey:kRemoteAddress];
            [taskData.httpRequest.benchMarkMan directSetValue:networkMetrics.remotePort forKey:kRemotePort];
        }
        
       #endif
    }
} 

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler{
    
    QCloudURLSessionTaskData *taskData = [self taskDataForTask:task];
    if (!taskData.httpRequest.runOnService.configuration.enableGlobalRedirection) {
        completionHandler(nil);
        return;
    }
    
    NSString *requestHost = request.URL.absoluteURL.host;
    // 检查是否需要允许重定向:
    if(taskData.httpRequest.runOnService.configuration.disableChangeHost == YES ||
       ![QCloudHTTPRequest needChangeHost:requestHost responseHeaders:response.allHeaderFields]){
        completionHandler(request);
    }else{
        completionHandler(nil);
        NSError *error = [NSError errorWithDomain:requestHost code:QCloudNetworkErrorCodeDomainInvalid userInfo:@{NSLocalizedDescriptionKey: @""}];
        [task cancel];
        [self URLSession:session task:task didCompleteWithError:error];
    }
}
#endif
- (void)URLSession:(NSURLSession *)session
              dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveResponse:(NSURLResponse *)response
     completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    QCloudLogDebugR(@"HTTP",@"didReceiveResponse: %@", response);
    QCloudURLSessionTaskData *taskData = [self taskDataForTask:dataTask];
    [taskData.httpRequest.benchMarkMan benginWithKey:kReadResponseHeaderTookTime];
    taskData.response = (NSHTTPURLResponse *)response;
    NSURLSessionResponseDisposition disp = [taskData.httpRequest reciveResponse:response];
    if (taskData.httpRequest.downloadingURL) {
        // if http statue is not found will forbidden write to file
        if (taskData.response.statusCode >= 400) {
            taskData.forbidenWirteToFile = YES;
        }
    }
    if (completionHandler) {
        completionHandler(disp);
    }
}
- (void)URLSession:(NSURLSession *)session
                        task:(NSURLSessionTask *)task
             didSendBodyData:(int64_t)bytesSent
              totalBytesSent:(int64_t)totalBytesSent
    totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    QCloudURLSessionTaskData *taskData = [self taskDataForTask:task];
    if (totalBytesSent <= 32768) {
        [taskData.httpRequest.benchMarkMan benginWithKey:kWriteRequestBodyTookTime];
    }
    if (taskData.httpRequest.sendProcessBlock) {
        [taskData.httpRequest notifySendProgressBytesSend:bytesSent totalBytesSend:totalBytesSent totalBytesExpectedToSend:totalBytesExpectedToSend];
    }
    [[QCloudNetProfile shareProfile] pointUpload:bytesSent];
    if (totalBytesSent == totalBytesExpectedToSend) {
        [taskData.httpRequest.benchMarkMan markFinishWithKey:kWriteRequestBodyTookTime];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    QCloudURLSessionTaskData *taskData = [self taskDataForTask:dataTask];
    if (taskData.totalRecivedLength == 0) {
        [taskData.httpRequest.benchMarkMan markFinishWithKey:kReadResponseHeaderTookTime];
        [taskData.httpRequest.benchMarkMan benginWithKey:kReadResponseBodyTookTime];
    }
    if (taskData.response.statusCode >= 400) {
        // should not write data or callback
        [taskData appendData:data];
        if (taskData.data.length >= [taskData.response.allHeaderFields[@"Content-Length"] longLongValue]) {
            if (taskData.httpRequest.requestData.directBody) {
                // 上传任务
                taskData.isTaskCancelledByStatusCodeCheck = YES;
                [dataTask cancel];
            }
        }
    } else {
        [taskData appendData:data];
        if (taskData.httpRequest) {
            [taskData.httpRequest notifyDownloadProgressBytesDownload:(int64_t)data.length
                                                   totalBytesDownload:(int64_t)taskData.totalRecivedLength
                                         totalBytesExpectedToDownload:(int64_t)[dataTask.response expectedContentLength]
                                                         receivedData:data];
        }
        [[QCloudNetProfile shareProfile] pointDownload:data.length];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    QCloudLogInfoR(@"HTTP",@"任务完成的回调 didCompleteWithError response = %@ error = %@", task.response, error);
    [[NSNotificationCenter defaultCenter]
        postNotificationName:kQCloudRestNetURLUsageNotification
                      object:nil
                    userInfo:@{
                        @"url" : task.originalRequest.URL ? task.originalRequest.URL
                                                          : [NSURL URLWithString:@"https://nullurl.error.com.tencent.qcloud.network"]

                    }];

    QCloudURLSessionTaskData *taskData = [self taskDataForTask:task];
    NSURL *hostURL = [NSURL URLWithString:taskData.httpRequest.requestData.serverURL];
    [taskData.httpRequest.benchMarkMan markFinishWithKey:kReadResponseBodyTookTime];
    if (!taskData) {
        return;
    }

    BOOL needRetryWithDomainChange = [self shouldRetry:taskData error:error];
    
    if (needRetryWithDomainChange) {
        error = [NSError errorWithDomain:hostURL.host code:QCloudNetworkErrorCodeDomainInvalid userInfo:@{NSLocalizedDescriptionKey: @""}];
        taskData.isTaskCancelledByStatusCodeCheck = NO;
    }
    
    int seq = [self seqForTask:task];
    __weak typeof(self) weakSelf = self;
    if (!taskData.isTaskCancelledByStatusCodeCheck && error) {
        QCloudLogErrorE(@"HTTP",@"Network Error %@", error);
        void (^EndRetryFunc)(void) = ^(void) {
            [taskData.httpRequest onReviveErrorResponse:task.response error:error];
            [weakSelf removeTask:task];
        };

        if (!taskData.retryHandler) {
            EndRetryFunc();
        } else {
            if ([taskData.retryHandler.delegate respondsToSelector:@selector(shouldRetry:error:)]) {
                BOOL isRetry = [taskData.retryHandler.delegate shouldRetry:taskData error:error];
                if (!isRetry) {
                    EndRetryFunc();
                    return;
                }
            }
            if (![taskData.retryHandler
                    retryFunction:^{
                        QCloudLogDebugP(@"HTTP",@"[%i] 错误，开始重试", seq);
                        if (error.code == -1003) {
                            [[QCloudHttpDNS shareDNS] findHealthyIpFor:hostURL.host];
                        }

                        QCloudURLSessionTaskData *taskData = [weakSelf taskDataForTask:task];
                        if (taskData.httpRequest.sendProcessBlock) {
                            int64_t countOfBytesSent = 0;
                            if ([task respondsToSelector:@selector(countOfBytesSent)]) {
                                countOfBytesSent = task.countOfBytesSent;
                            }
                            int64_t countOfBytesExpectedToSend = 0;
                            if ([task respondsToSelector:@selector(countOfBytesExpectedToSend)]) {
                                countOfBytesExpectedToSend = task.countOfBytesExpectedToSend;
                            }
                            [taskData.httpRequest notifySendProgressBytesSend:-(countOfBytesSent)
                                                               totalBytesSend:countOfBytesSent
                                                     totalBytesExpectedToSend:countOfBytesExpectedToSend];
                        }
                
                        BOOL needChangeHost = NO;
                        NSInteger statusCodeCategory = taskData.response.statusCode / 100;
                        // 3xx: 第一次失败就换域名
                        if (statusCodeCategory == 3) {
                            needChangeHost = [self shouldSwitchDomain:taskData error:error];
                        }
                        // 5xx 或未收到回包: 最后一次重试时换域名
                        else if (statusCodeCategory != 2 &&
                                 taskData.httpRequest.retryCount == taskData.retryHandler.maxCount - 1) {
                            needChangeHost = [self shouldSwitchDomain:taskData error:error];
                        }
                
                        QCloudHTTPRequest *httpRequset = taskData.httpRequest;
                        [taskData restData];
                        [weakSelf removeTask:task];
                        [httpRequset.requestData clean];
                        if (QCloudFileExist(httpRequset.downloadingTempURL.path)) {
                            httpRequset.localCacheDownloadOffset = QCloudFileSize(httpRequset.downloadingTempURL.path);
                        }
                        httpRequset.requestData.needChangeHost = needChangeHost;
                        [httpRequset setValue:@(YES) forKey:@"isRetry"];
                        httpRequset.retryCount = taskData.httpRequest.retryCount + 1;
                        [weakSelf executeRestHTTPReqeust:httpRequset];
                    }
                        whenError:error]) {
                EndRetryFunc();
            }
        }

    } else {
        NSString *port = [task.currentRequest.URL.scheme isEqualToString:@"https"] ? @"443" : @"8080";
        [[QCloudHttpDNS shareDNS] prepareFetchIPListForHost:hostURL.host port:port];
        [taskData.httpRequest onReciveRespone:task.response data:taskData.data];
        [self removeTask:task];
    }
}

- (void)URLSession:(NSURLSession *_Nonnull)session
                   task:(NSURLSessionTask *_Nonnull)task
    didReceiveChallenge:(NSURLAuthenticationChallenge *_Nonnull)challenge
      completionHandler:(void (^_Nonnull)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *_Nullable credential))completionHandler {
    QCloudURLSessionTaskData *taskData = [self taskDataForTask:task];

    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    NSURLCredential *credential = nil;
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if (!IS_QCloud_NORMAL_ENV || !taskData.httpRequest.requestSerializer.shouldAuthentication || taskData.httpRequest.runOnService.configuration.disableGlobalAuthentication) {
            SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
            credential = [NSURLCredential credentialForTrust:serverTrust];
            disposition = NSURLSessionAuthChallengeUseCredential;
        } else {
            SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
            if ([[QCloudHttpDNS shareDNS] isTrustIP:task.currentRequest.URL.host]) {
                NSMutableArray *policies = [NSMutableArray array];
                [policies addObject:(__bridge_transfer id)SecPolicyCreateBasicX509()];
                SecTrustSetPolicies(serverTrust, (__bridge CFArrayRef)policies);
            }
            SecTrustResultType rType;
            OSStatus status = SecTrustEvaluate(serverTrust, &rType);
            if (status == errSecSuccess && (rType == kSecTrustResultProceed || rType == kSecTrustResultUnspecified)) {
                credential = [NSURLCredential credentialForTrust:serverTrust];
                disposition = NSURLSessionAuthChallengeUseCredential;
            } else {
                disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
            }
        }
    } else if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodClientCertificate]) {
        if (taskData.httpRequest.runOnService.configuration.clientCertificateData) {
            CFDataRef inP12Data = (__bridge CFDataRef)taskData.httpRequest.runOnService.configuration.clientCertificateData;
            SecIdentityRef identity = NULL;
            SecTrustRef trust = NULL;
            OSStatus status = noErr;
            
            const void *keys[] = { kSecImportExportPassphrase };
            const void *values[] = { (__bridge CFStringRef)taskData.httpRequest.runOnService.configuration.password };
            CFDictionaryRef options = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
            
            CFArrayRef items = NULL;
            status = SecPKCS12Import(inP12Data, options, &items);
            
            if (status != errSecSuccess || items == NULL || CFArrayGetCount(items) == 0) {
                NSLog(@"SecPKCS12Import 错误: %d", (int)status);
                if (options) CFRelease(options);
                if (items) CFRelease(items);
                disposition = NSURLSessionAuthChallengePerformDefaultHandling;
                completionHandler(disposition, credential);
                return;
            }
            
            CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
            identity = (SecIdentityRef)CFRetain(CFDictionaryGetValue(identityDict, kSecImportItemIdentity));
            trust = (SecTrustRef)CFRetain(CFDictionaryGetValue(identityDict, kSecImportItemTrust));
            
            if (options) CFRelease(options);
            if (items) CFRelease(items);
            
            if (status == errSecSuccess && identity != NULL) {
                SecCertificateRef certificate = NULL;
                OSStatus certStatus = SecIdentityCopyCertificate(identity, &certificate);
                
                if (certStatus != errSecSuccess || certificate == NULL) {
                    NSLog(@"SecIdentityCopyCertificate 错误: %d", (int)certStatus);
                    disposition = NSURLSessionAuthChallengePerformDefaultHandling;
                    completionHandler(disposition, credential);
                    return;
                }
                
                const void *certs[] = { certificate };
                CFArrayRef certArray = CFArrayCreate(NULL, certs, 1, NULL);
                credential = [NSURLCredential credentialWithIdentity:identity
                                                        certificates:(__bridge NSArray *)certArray
                                                         persistence:NSURLCredentialPersistenceForSession];
                
                if (certArray) CFRelease(certArray);
                if (certificate) CFRelease(certificate);
                if (trust) CFRelease(trust);
                
                disposition = NSURLSessionAuthChallengeUseCredential;
            } else {
                NSLog(@"身份解析失败: %d", (int)status);
                disposition = NSURLSessionAuthChallengePerformDefaultHandling;
            }
        } else {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
    } else {
        disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    }

    if (completionHandler) {
        completionHandler(disposition, credential);
    }
}

- (void)cancelRequestWithID:(int)requestID {
    NSURLSessionTask *task = [self taskForSEQ:requestID];
    [task cancel];
    [self removeTaskForSEQ:requestID];
}

- (void)cancelRequestsWithID:(NSArray<NSNumber *> *)requestIDs {
    [self.operationQueue cancelByRequestIDs:requestIDs];
    for (NSNumber *requestID in requestIDs) {
        [self cancelRequestWithID:[requestID intValue]];
    }
}

- (void)cancelAllRequest {
    [self.operationQueue cancelAllOperation];
//    @synchronized(self) {
//        NSEnumerator *enumertor = [_taskQueue objectEnumerator];
//        NSURLSessionTask *task = nil;
//        while (task = [enumertor nextObject]) {
//            if ([task respondsToSelector:@selector(cancel)]) {
//                [task cancel];
//            }
//
//            if ([task isKindOfClass:[NSNumber class]]) {
//                [self.operationQueue cancelByRequestID:((NSNumber *)task).integerValue];
//            }
//        }
//        [_taskQueue removeAllObjects];
//    }
}

- (void)executeRestHTTPReqeust:(QCloudHTTPRequest *)httpRequest {
    [httpRequest.benchMarkMan benginWithKey:kTaskTookTime];
    [httpRequest willStart];

    NSError *error;
    NSMutableURLRequest *urlRequest = [[httpRequest buildURLRequest:&error] mutableCopy];
    if (httpRequest.timeoutInterval) {
        urlRequest.timeoutInterval = httpRequest.timeoutInterval;
    }
    if (error) {
        [httpRequest onError:error];
        return;
    }
    NSMutableURLRequest *transformRequest = urlRequest;
    if (httpRequest.requestSerializer.HTTPDNSPrefetch && !httpRequest.runOnService.configuration.disableGlobalHTTPDNSPrefetch) {
        transformRequest = [[QCloudHttpDNS shareDNS] resolveURLRequestIfCan:urlRequest];
        if (error) {
            QCloudLogErrorE(@"HTTP",@"DNS转存请求失败%@", error);
        }
    }

    QCloudURLSessionTaskData *taskData = nil;
    if (httpRequest.downloadingTempURL) {
        NSError *localError;
        if (!QCloudFileExist(httpRequest.downloadingTempURL.path)) {
            [[NSFileManager defaultManager] createFileAtPath:httpRequest.downloadingTempURL.path contents:nil attributes:nil];
        }
        NSFileHandle *handler = [NSFileHandle fileHandleForWritingToURL:httpRequest.downloadingTempURL error:&localError];
        if (localError) {
            [httpRequest onError:localError];
            return;
        } else {
            [handler seekToFileOffset:httpRequest.localCacheDownloadOffset];
            taskData = [[QCloudURLSessionTaskData alloc] initWithDowndingFileHandler:handler];
        }
    } else {
        taskData = [[QCloudURLSessionTaskData alloc] init];
    }

    NSError *directError;

    NSURL *uploadFileURL = nil;

    if (httpRequest.requestData.directBody) {
        NSMutableURLRequest *mutableRequest = [transformRequest mutableCopy];
        id body = httpRequest.requestData.directBody;
        if ([body isKindOfClass:[NSData class]]) {
            NSData *data = (NSData *)body;
            [mutableRequest setHTTPBody:data];
            [mutableRequest setValue:[@([data length]) stringValue] forHTTPHeaderField:@"Content-Length"];
            if(data.length == 0 && httpRequest.runOnService.configuration.disableUploadZeroData){
                directError = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                                                    message:[NSString stringWithFormat:@"InvalidArgument:您输入的body（Data）为空并且不允许上传空文件，是否为SDK内部重试：%@",httpRequest.isRetry ? @"是" : @"否"]];
            }
        } else if ([body isKindOfClass:[NSURL class]]) {
            NSURL *fileURL = (NSURL *)body;
            if (![fileURL isFileURL]) {
                directError = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                                                    message:@"InvalidArgument:您输入的body的URL不是本地URL，请检查后使用！！"];
            }
            NSUInteger fileSize = QCloudFileSize(fileURL.path);
            [mutableRequest setValue:[@(fileSize) stringValue] forHTTPHeaderField:@"Content-Length"];
            uploadFileURL = fileURL;
            if(directError == nil && fileSize == 0 && httpRequest.runOnService.configuration.disableUploadZeroData){
                directError = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                                                    message:[NSString stringWithFormat:@"InvalidArgument:您输入的body（NSURL:%@）为空并且不允许上传空文件，是否为SDK内部重试：%@",fileURL, httpRequest.isRetry ? @"是" : @"否"]];
            }
        } else if ([body isKindOfClass:[QCloudFileOffsetBody class]]) {
            QCloudFileOffsetBody *fileBody = (QCloudFileOffsetBody *)body;
            if (![fileBody.fileURL isFileURL]) {
                directError = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                                                    message:@"InvalidArgument:您输入的body的URL不是本地URL，请检查后使用！！"];
            }

            NSFileHandle *handler = [NSFileHandle fileHandleForReadingAtPath:fileBody.fileURL.path];
            [handler seekToFileOffset:fileBody.offset];
            NSData *data = [handler readDataOfLength:fileBody.sliceLength];
            NSString *tempFile = taskData.uploadTempFilePath;
            if ([data writeToFile:tempFile options:0 error:&directError]) {
                [mutableRequest setValue:[@(fileBody.sliceLength) stringValue] forHTTPHeaderField:@"Content-Length"];
                [handler closeFile];
                uploadFileURL = [NSURL fileURLWithPath:tempFile];
                QCloudLogDebugP(@"HTTP",@"uploadTempFilePath length = %lld", QCloudFileSize(tempFile));
            }

        } else {
            @throw [NSException exceptionWithName:kQCloudNetworkDomain
                                           reason:@"不支持设置该类型的body，支持的类型为NSData、QCloudFileOffsetBody、NSURL"
                                         userInfo:@{}];
        }
        transformRequest = mutableRequest;
    }
    if (directError) {
        [httpRequest onError:directError];
        return;
    }

    // 准备发送请求，最后一次机会修改将要发送的HTTP请求
    NSError *parepareError;
    [httpRequest.benchMarkMan benginWithKey:kSignRequestTookTime];
    if (![httpRequest prepareInvokeURLRequest:transformRequest error:&parepareError]) {
        [httpRequest onError:parepareError];
        return;
    }
    [httpRequest.benchMarkMan markFinishWithKey:kSignRequestTookTime];
    if (nil == transformRequest) {
        NSError *error = [NSError qcloud_errorWithCode:QCloudNetworkErrorUnsupportOperationError message:@"构建Request时候出错，出现空的Request"];
        [httpRequest onError:error];
        return;
    }
    NSURLSessionDataTask *task = nil;
    id quicTask = nil;
    id <QCloudCustomLoader> loader = [[QCloudLoaderManager manager] getAvailableLoader:httpRequest];
    if ([QCloudLoaderManager manager].enable && loader) {
        task = [loader.session taskWithRequset:transformRequest fromFile:uploadFileURL];
    }else if (!httpRequest.enableQuic) {
        //如果是文件上传
        if (uploadFileURL) {
            task = [self.session uploadTaskWithRequest:transformRequest fromFile:uploadFileURL];
        } else {
            task = [self.session dataTaskWithRequest:transformRequest];
        }
    } else {
        Class cls = NSClassFromString(@"QCloudQuicDataTask");
        if (!cls) {
            @throw [NSException exceptionWithName:NSArgumentDomain reason:@"No Quic framework is found." userInfo:nil];
        }

        NSString *host = transformRequest.URL.host;
        NSString *ipAddr;
        if ([[QCloudHttpDNS shareDNS] isTrustIP:host]) {
            ipAddr = host;
            host = transformRequest.allHTTPHeaderFields[@"Host"];
        } else {
            ipAddr = [[QCloudHttpDNS shareDNS] queryIPForHost:host];
        }
        if (!ipAddr) {
            // 查询 可用的 ip 地址tc
            [[QCloudHttpDNS shareDNS] prepareFetchIPListForHost:host port:@"443"];
            ipAddr = [[QCloudHttpDNS shareDNS] findHealthyIpFor:host];
        }
//        if (!ipAddr) {
//            @throw [NSException exceptionWithName:NSURLErrorDomain reason:@"No Available IP Address for QUIC." userInfo:nil];
//        }

        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:transformRequest.allHTTPHeaderFields];
  
 
        dic[@"quicHost"] = host;
        if(ipAddr) dic[@"quicIP"] = ipAddr;
        if (uploadFileURL) {
            dic[@"body"] = uploadFileURL;
        } else if (httpRequest.requestData.directBody) {
            dic[@"body"] = httpRequest.requestData.directBody;
        } else {
            dic[@"body"] = [NSNull null];
        }
        
        SEL createQuicTaskSelector = NSSelectorFromString(@"quicDataTaskWithRequst:infos:");
        if ([_quicSession respondsToSelector:createQuicTaskSelector]) {
            IMP imp = [_quicSession methodForSelector:createQuicTaskSelector];
            id (*func)(id, SEL, NSMutableURLRequest *, NSDictionary *) = (void *)imp;
            quicTask = func(_quicSession, createQuicTaskSelector, transformRequest, dic);
        }
    }

    QCloudLogDebugP(@"HTTP",@"transferHttpHeader %@", transformRequest.allHTTPHeaderFields);
    taskData.httpRequest = httpRequest;
    QCloudHTTPRetryHanlder *retryHandler = httpRequest.retryPolicy;
    taskData.retryHandler = retryHandler;
    if (task) {
        [self cacheTask:task data:taskData forSEQ:(int)httpRequest.requestID];
    } else {
        [self cacheTask:quicTask data:taskData forSEQ:(int)httpRequest.requestID];
    }
    [httpRequest configTaskResume];
    [httpRequest.benchMarkMan directSetValue:transformRequest.URL.host forKey:kHost];
    //先创建task，在启动
    SEL quicStartSelector = NSSelectorFromString(@"start");
    if (quicTask && [quicTask respondsToSelector:quicStartSelector]) {
        IMP imp = [quicTask methodForSelector:quicStartSelector];
        void (*func)(id, SEL) = (void *)imp;
        func(quicTask, quicStartSelector);

    } else {
        [task resume];
    }
}


#pragma mark - 域名切换和重试

/**
 * 判断是否需要切换域名（支持超时错误）
 *
 * @param taskData 请求任务数据
 * @param error 网络错误（用于判断超时场景）
 * @return YES 需要切换域名，NO 不需要切换
 */
- (BOOL)shouldSwitchDomain:(QCloudURLSessionTaskData *)taskData error:(NSError *)error {
    // 检查是否禁用域名切换
    if (taskData.httpRequest.runOnService.configuration.disableChangeHost) {
        return NO;
    }
    
    NSURL *hostURL = [NSURL URLWithString:taskData.httpRequest.requestData.serverURL];
    
    // 超时场景：只需检查域名是否可切换，不需要检查响应头
    if ([self isNetworkConnectionError:error]) {
        return [QCloudHTTPRequest needChangeHost:hostURL.host];
    }
    
    // 非超时场景：需要检查响应头中的 request-id
    return [QCloudHTTPRequest needChangeHost:hostURL.host responseHeaders:taskData.response.allHeaderFields];
}

/**
 * 判断是否为网络连接异常（超时或连接丢失）
 *
 * @param error 网络请求错误
 * @return YES 表示网络连接异常，NO 表示其他错误
 */
- (BOOL)isNetworkConnectionError:(NSError *)error {
    if (!error || ![error.domain isEqualToString:NSURLErrorDomain]) {
        return NO;
    }
    switch (error.code) {
        case NSURLErrorTimedOut:
        case NSURLErrorNetworkConnectionLost:
            return YES;
        default:
            return NO;
    }
}


/**
 * 判断是否需要重试（支持超时错误）
 *
 * @param taskData 请求任务数据
 * @param error 网络错误（用于判断超时场景）
 * @return YES 需要重试，NO 不需要重试
 */
- (BOOL)shouldRetry:(QCloudURLSessionTaskData *)taskData error:(NSError *)error {
    BOOL needRetryWithDomainChange = NO;
    
    // 场景1：网络连接异常（超时或连接丢失）
    if ([self isNetworkConnectionError:error]) {
        needRetryWithDomainChange = YES;
    }
    // 场景2：根据 HTTP 状态码判断
    else {
        NSInteger statusCodeCategory = taskData.response.statusCode / 100;
        if (statusCodeCategory == 2) {
            needRetryWithDomainChange = [self hasCopyRequestError:taskData];
        } else if (statusCodeCategory == 3) {
            NSInteger statusCode = taskData.response.statusCode % 100;
            if (statusCode == 1 || statusCode == 2 || statusCode == 7) {
                needRetryWithDomainChange = [self shouldSwitchDomain:taskData error:error];
            }
        } else if (statusCodeCategory == 5) {
            needRetryWithDomainChange = YES;
        }
    }
    
    // CI 域名额外条件：签名必须是 SDK 生成的
    if ([taskData.httpRequest isCIHost]) {
        needRetryWithDomainChange = needRetryWithDomainChange && taskData.httpRequest.signature.sourceType == QCloudSignatureSourceTypeSDK;
    }
    
    return needRetryWithDomainChange;
}

/**
 * 检查 2xx Copy 请求响应体中是否包含需要重试的错误
 *
 * COS Copy 请求（如 PUT Object - Copy）在 HTTP 状态码为 2xx 时，
 * 响应体 <CopyObjectResult> 中可能仍包含错误信息。
 *
 * 需要重试的错误码：
 * - InternalError: 服务端内部错误
 * - SlowDown: 请求频率过高
 * - ServiceUnavailable: 服务暂时不可用
 *
 *
 * @param taskData 请求任务数据
 */
- (BOOL)hasCopyRequestError:(QCloudURLSessionTaskData *)taskData {
    // 仅处理 2xx 响应
    NSInteger statusCodeCategory = taskData.response.statusCode / 100;
    if (statusCodeCategory != 2) {
        return NO;
    }
    if (![taskData.httpRequest isCOSHost]) {
        return NO;
    }
    
    NSError *error = nil;
    QCloudResponseXMLSerializerBlock(taskData.response, taskData.data, &error);
    if (!error) {
        return NO;
    }
    NSString *errorCode = error.userInfo[NSLocalizedDescriptionKey];
    // 检查是否是需要重试的错误码
    if ([errorCode isEqualToString:@"InternalError"] ||
        [errorCode isEqualToString:@"SlowDown"] ||
        [errorCode isEqualToString:@"ServiceUnavailable"]) {
        return YES;
    }
    return NO;
}

- (void)dealloc {
    [cloudBackGroundSessionManagersCache removeObject:self];
}

@end
