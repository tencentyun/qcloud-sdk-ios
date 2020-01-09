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
NSString* TaskDataKey(int64_t identifier){
    return [NSString stringWithFormat:@"data-%lld", identifier];
}

NSString* TaskMapKey(NSURLSessionTask* task) {
    return [NSString stringWithFormat:@"%p",(void*)task];
}
NSString* const kQCloudRestNetURLUsageNotification  = @"kQCloudRestNetURLUsageNotification";


QCloudThreadSafeMutableDictionary* cloudBackGroundSessionManagersCache;
QCloudThreadSafeMutableDictionary* QCloudBackgroundSessionManagerCache()
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cloudBackGroundSessionManagersCache = [QCloudThreadSafeMutableDictionary new];
    });
    return cloudBackGroundSessionManagersCache;
}

@implementation NSDictionary(QCloudRestNetUsage)
- (NSURL*) bdwt_RestNetCoreUsagedURL
{
    return self[@"url"];
}

@end


@interface QCloudHTTPSessionManager() <NSURLSessionDelegate,NSURLSessionTaskDelegate, NSURLSessionDataDelegate>
{
    NSMutableDictionary* _taskQueue;
}   
@property (nonatomic, strong) NSOperationQueue* sessionTaskQueue;;
@property (nonatomic, strong) NSURLSession* session;
@property (nonatomic, strong) dispatch_queue_t buildDataQueue;
@property (nonatomic, strong) QCloudOperationQueue* operationQueue;
@end

@implementation QCloudHTTPSessionManager
@synthesize maxConcurrencyTask = _maxConcurrencyTask;

+ (QCloudHTTPSessionManager*) shareClient
{
    static QCloudHTTPSessionManager* client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[QCloudHTTPSessionManager alloc] initWithConfigruation:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [QCloudNetEnv shareEnv];
    });
    return client;
}


- (instancetype) initWithConfigruation:(NSURLSessionConfiguration*)configuration
{
    self = [super init];
    if (!self) {
        return self;
    }
    
    //for restful request-response using the default session configuration ,and the most import thing is that you must not set the timeout for session configuration
    _configuration = configuration;
    _sessionTaskQueue = [[NSOperationQueue alloc] init];
    _session = [NSURLSession sessionWithConfiguration:_configuration delegate:self delegateQueue:_sessionTaskQueue];
    _buildDataQueue = dispatch_queue_create("com.tencent.qcloud.build.data", NULL);
    _taskQueue = [NSMutableDictionary new];
    _operationQueue = [QCloudOperationQueue new];
    NSLog(@"我被调用了:%@",_operationQueue);
    return self;
}

- (QCloudHTTPSessionManager *)initWithBackgroundSessionWithBackgroundIdentifier:(NSString *)backgroundIdentifier{
    NSAssert(backgroundIdentifier, @"后台传输的标识符为nil，请检查是否设置了backgroundIdentifier");
    NSURLSessionConfiguration* backgroundConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:backgroundIdentifier];
    if (self = [self initWithConfigruation:backgroundConfiguration]) {
        [QCloudNetEnv shareEnv];
    }
    return self;
}

- (void) setMaxConcurrencyTask:(int32_t)maxConcurrencyTask
{
    if (_maxConcurrencyTask != maxConcurrencyTask) {
        _maxConcurrencyTask = maxConcurrencyTask;
        _sessionTaskQueue.maxConcurrentOperationCount = maxConcurrencyTask;
    }
}

- (void) cancelRequests:(NSArray<NSNumber*>*)requestID
{
    
}
- (void) cacheTask:(NSURLSessionTask*)task data:(QCloudURLSessionTaskData*)data forSEQ:(int)seq
{
    if (!task) {
        return;
    }
    @synchronized (self) {
        [_taskQueue setObject:@(seq) forKey:TaskMapKey(task)];
        [_taskQueue setObject:task forKey:@(seq)];
        [_taskQueue setObject:data forKey:TaskDataKey(seq)];
    }
}

- (NSURLSessionTask*) taskForSEQ:(int)seq
{
    @synchronized (self) {
        return [_taskQueue objectForKey:@(seq)];
    }
}
- (QCloudURLSessionTaskData*) taskDataForTask:(NSURLSessionTask*)task
{
    @synchronized (self) {
        int seq = [_taskQueue[TaskMapKey(task)] intValue];
        return [_taskQueue objectForKey:TaskDataKey(seq)];
    }
}
- (int) seqForTask:(NSURLSessionTask*)task
{
    @synchronized (self) {
        return [_taskQueue[TaskMapKey(task)] intValue];
    }
}

- (void) removeTaskForSEQ:(int)seq
{
    @synchronized (self) {
        NSURLSessionTask* task = _taskQueue[@(seq)];
        [_taskQueue removeObjectForKey:@(seq)];
        [_taskQueue removeObjectForKey:TaskDataKey(seq)];
        if (task) {
            [_taskQueue removeObjectForKey:TaskMapKey(task)];
        }
    }
    [_operationQueue cancelByRequestID:seq];
}

- (void) removeTask:(NSURLSessionTask*)task
{
    @synchronized (self) {
        int seq = [_taskQueue[TaskMapKey(task)] intValue];
        [_taskQueue removeObjectForKey:@(seq)];
        [_taskQueue removeObjectForKey:TaskDataKey(seq)];
        [_taskQueue removeObjectForKey:TaskMapKey(task)];
    }
}


- (int) performRequest:(QCloudHTTPRequest *)httpRequst withFinishBlock:(QCloudRequestFinishBlock)block
{
    httpRequst.finishBlock = block;
    return [self performRequest:httpRequst];
}

- (int)  performRequest:(QCloudHTTPRequest *)request
{
    
    QCloudHTTPRequestOperation* operation = [[QCloudHTTPRequestOperation alloc] initWithRequest:request];
    operation.sessionManager = self;
    [_operationQueue addOpreation:operation];
    return (int)request.requestID;
}

// only work at iOS 10 and up
- (void) URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics
API_AVAILABLE(ios(10.0)){
    QCloudURLSessionTaskData* taskData = [self taskDataForTask:task];
    //        NSAssert(taskData, @"无法获取缓存的TaskData，请检查主动Cache的地方");
    NSURLSessionTaskTransactionMetrics* networkMetrics = nil;
    for (NSURLSessionTaskTransactionMetrics* m in metrics.transactionMetrics) {
        if (m.resourceFetchType == NSURLSessionTaskMetricsResourceFetchTypeNetworkLoad) {
            networkMetrics = m;
        } else if (m.resourceFetchType == NSURLSessionTaskMetricsResourceFetchTypeLocalCache){
            
        }
    }
    
    if (networkMetrics) {
        if (!networkMetrics.reusedConnection) {
            [taskData.httpRequest.benchMarkMan directSetCost:[networkMetrics.connectEndDate     timeIntervalSinceDate:networkMetrics.connectStartDate] forKey:kConnectTookTime];
            if ([taskData.httpRequest.requestData.serverURL.lowercaseString hasPrefix:@"https"]) {
                [taskData.httpRequest.benchMarkMan directSetCost:[networkMetrics.secureConnectionEndDate timeIntervalSinceDate:networkMetrics.secureConnectionStartDate] forKey:kSecureConnectTookTime];
            }
            [taskData.httpRequest.benchMarkMan directSetCost:[networkMetrics.domainLookupEndDate timeIntervalSinceDate:networkMetrics.domainLookupStartDate] forKey:kDnsLookupTookTime];
        }
        //            [taskData.httpRequest.benchMarkMan directSetCost:[networkMetrics.requestEndDate timeIntervalSinceDate:networkMetrics.requestStartDate] forKey:@"upload"];
        //            [taskData.httpRequest.benchMarkMan directSetCost:[networkMetrics.responseEndDate timeIntervalSinceDate:networkMetrics.responseStartDate] forKey:@"download"];
    }
}

- (void) URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    QCloudLogDebug(@"didReceiveResponse: %@",response);
    QCloudURLSessionTaskData* taskData = [self taskDataForTask:dataTask];
    [taskData.httpRequest.benchMarkMan benginWithKey:kReadResponseHeaderTookTime];
    taskData.response = (NSHTTPURLResponse*)response;
    NSURLSessionResponseDisposition disp = [taskData.httpRequest reciveResponse:response];
    if (taskData.httpRequest.downloadingURL) {
        // if http statue is not found will forbidden write to file
        if (taskData.response.statusCode >= 400) {
            taskData.forbidenWirteToFile = YES;
        }
    }
    completionHandler(disp);
}
- (void) URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    QCloudURLSessionTaskData* taskData = [self taskDataForTask:task];
    if (totalBytesSent<=32768) {
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

- (void) URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    QCloudURLSessionTaskData* taskData = [self taskDataForTask:dataTask];
    QCloudLogDebug(@"totalRecivedLength:  %d",taskData.totalRecivedLength);
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
                                         totalBytesExpectedToDownload:(int64_t)[dataTask.response expectedContentLength]];
        }
        [[QCloudNetProfile shareProfile] pointDownload:data.length];
    }
}



- (void) URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    QCloudLogDebug(@"任务完成的回调 didCompleteWithError");
    [[NSNotificationCenter defaultCenter] postNotificationName:kQCloudRestNetURLUsageNotification object:nil userInfo:@{
        @"url":task.originalRequest.URL? task.originalRequest.URL : [NSURL URLWithString:@"http://nullurl.error.com.tencent.qcloud.network"]
        
    }];
    QCloudURLSessionTaskData* taskData = [self taskDataForTask:task];
    [taskData.httpRequest.benchMarkMan markFinishWithKey:kReadResponseBodyTookTime];
    if (!taskData) {
        return;
    }
    int seq = [self seqForTask:task];
    __weak typeof(self)weakSelf = self;
    if (!taskData.isTaskCancelledByStatusCodeCheck && error) {
        QCloudLogError(@"Network Error %@",error);
        void(^EndRetryFunc)(void) = ^(void) {
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
            if (![taskData.retryHandler retryFunction:^{
                QCloudLogDebug(@"[%i] 错误，开始重试",seq);
                QCloudURLSessionTaskData* taskData = [weakSelf taskDataForTask:task];
                if (taskData.httpRequest.sendProcessBlock) {
                    [taskData.httpRequest notifySendProgressBytesSend:-(task.countOfBytesSent) totalBytesSend:task.countOfBytesSent totalBytesExpectedToSend:task.countOfBytesExpectedToSend];
                }
                QCloudHTTPRequest* httpRequset = taskData.httpRequest;
                [taskData restData];
                [weakSelf removeTask:task];
                [httpRequset.requestData clean];
                [weakSelf executeRestHTTPReqeust:httpRequset];
            } whenError:error])
            {
                EndRetryFunc();
            }
        }
        
    } else {
        [taskData.httpRequest onReciveRespone:task.response data:taskData.data];
        [self removeTask:task];
    }
}

- (void) URLSession:(NSURLSession * _Nonnull)session task:(NSURLSessionTask * _Nonnull)task didReceiveChallenge:(NSURLAuthenticationChallenge * _Nonnull)challenge completionHandler:(void (^ _Nonnull)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler
{
    QCloudURLSessionTaskData* taskData = [self taskDataForTask:task];
    
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    NSURLCredential* credential = nil;
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if (!IS_QCloud_NORMAL_ENV || !taskData.httpRequest.requestSerializer.shouldAuthentication) {
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
            OSStatus status =   SecTrustEvaluate(serverTrust, &rType);
            if (status == errSecSuccess &&
                (rType == kSecTrustResultProceed || rType == kSecTrustResultUnspecified)) {
                credential = [NSURLCredential credentialForTrust:serverTrust];
                disposition = NSURLSessionAuthChallengeUseCredential;
            } else {
                disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
            }
        }
    } else {
        disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    }
    
    if (completionHandler) {
        completionHandler(disposition, credential);
    }
}

- (void) cancelRequestWithID:(int)requestID
{
    NSURLSessionTask* task  = [self taskForSEQ:requestID];
    [task cancel];
    [self removeTaskForSEQ:requestID];
}

- (void) cancelRequestsWithID:(NSArray<NSNumber*>*)requestIDs {
    QCloudLogDebug(@"我是cancle的queue%@",self.operationQueue);
    [self.operationQueue cancelByRequestIDs:requestIDs];
    for (NSNumber* requestID in requestIDs) {
        [self cancelRequestWithID:[requestID intValue]];
    }
    
}

- (void) cancelAllRequest
{
    @synchronized (self) {
        NSEnumerator* enumertor = [_taskQueue objectEnumerator];
        NSURLSessionTask* task = nil;
        while (task = [enumertor nextObject]) {
            [task cancel];
        }
        [_taskQueue removeAllObjects];
    }
}

- (void) executeRestHTTPReqeust:(QCloudHTTPRequest*)httpRequest
{
    [httpRequest.benchMarkMan benginWithKey:kTaskTookTime];
    [httpRequest willStart];

    NSError* error;
    NSMutableURLRequest* urlRequest = [[httpRequest buildURLRequest:&error] mutableCopy];
    if (httpRequest.timeoutInterval) {
        urlRequest.timeoutInterval = httpRequest.timeoutInterval;
    }
    if (error) {
        [httpRequest onError:error];
        return;
    }
    NSMutableURLRequest* transformRequest = urlRequest;
    if (httpRequest.requestSerializer.HTTPDNSPrefetch) {
        transformRequest = [[QCloudHttpDNS shareDNS] resolveURLRequestIfCan:urlRequest];
        if (error) {
            QCloudLogError(@"DNS转存请求失败%@",error);
        }
    }
    
    QCloudURLSessionTaskData*  taskData = nil;
    if (httpRequest.downloadingURL) {
        NSError* localError;
        if (!QCloudFileExist(httpRequest.downloadingURL.path)) {
            [[NSFileManager defaultManager] createFileAtPath:httpRequest.downloadingURL.path contents:nil attributes:nil];
        }
        NSFileHandle* handler = [NSFileHandle fileHandleForWritingToURL:httpRequest.downloadingURL error:&localError];
        if (localError) {
            [httpRequest onError:localError];
            return;
        } else {
            [handler seekToFileOffset:httpRequest.localCacheDownloadOffset];
            taskData =  [[QCloudURLSessionTaskData alloc] initWithDowndingFileHandler:handler];
        }
    } else {
        taskData = [[QCloudURLSessionTaskData alloc] init];
    }
    
    NSError* directError;
    
    NSURL* uploadFileURL = nil;
    
    if (httpRequest.requestData.directBody) {
        NSMutableURLRequest* mutableRequest = [transformRequest mutableCopy];
        id body = httpRequest.requestData.directBody;
        if ([body isKindOfClass:[NSData class]]) {
            NSData* data = (NSData*)body;
            [mutableRequest setHTTPBody:data];
            [mutableRequest setValue:[@([data length]) stringValue] forHTTPHeaderField:@"Content-Length"];
        } else if ([body isKindOfClass:[NSURL class]]) {
            NSURL* fileURL = (NSURL*)body;
            if (![fileURL isFileURL]) {
                directError = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid message:@"InvalidArgument:您输入的body的URL不是本地URL，请检查后使用！！"];
            }
            NSUInteger fileSize = QCloudFileSize(fileURL.path);
            [mutableRequest setValue:[@(fileSize) stringValue] forHTTPHeaderField:@"Content-Length"];
            uploadFileURL = fileURL;
        } else if ([body isKindOfClass:[QCloudFileOffsetBody class]]) {
            QCloudFileOffsetBody* fileBody = (QCloudFileOffsetBody*)body;
            if (![fileBody.fileURL isFileURL]) {
                directError = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid message:@"InvalidArgument:您输入的body的URL不是本地URL，请检查后使用！！"];
            }
            
            NSFileHandle* handler = [NSFileHandle fileHandleForReadingAtPath:fileBody.fileURL.path];
            [handler seekToFileOffset:fileBody.offset];
            NSData* data = [handler readDataOfLength:fileBody.sliceLength];
            NSString* tempFile = taskData.uploadTempFilePath;
            if([data writeToFile:tempFile options:0 error:&directError]) {
                [mutableRequest setValue:[@(fileBody.sliceLength) stringValue] forHTTPHeaderField:@"Content-Length"];
                [handler closeFile];
                uploadFileURL = [NSURL fileURLWithPath:tempFile];
            }
            
        } else {
            @throw [NSException exceptionWithName:kQCloudNetworkDomain reason:@"不支持设置该类型的body，支持的类型为NSData、QCloudFileOffsetBody、NSURL" userInfo:@{}];
        }
        transformRequest = mutableRequest;
    }
    if (directError) {
        [httpRequest onError:directError];
        return;
    }
    
    // 准备发送请求，最后一次机会修改将要发送的HTTP请求
    NSError* parepareError;
    [httpRequest.benchMarkMan benginWithKey:kSignRequestTookTime];
    if (![httpRequest prepareInvokeURLRequest:transformRequest error:&parepareError]) {
        [httpRequest onError:parepareError];
        return;
    }
    [httpRequest.benchMarkMan markFinishWithKey:kSignRequestTookTime];
    if (nil == transformRequest) {
        NSError* error = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeContentError message:@"构建Request时候出错，出现空的Request"];
        [httpRequest onError:error];
        return;
    }
    
    NSURLSessionDataTask* task = nil;
    //如果是文件上传
    if (uploadFileURL) {
        task = [self.session uploadTaskWithRequest:transformRequest fromFile:uploadFileURL];
        
    }else{
        task = [self.session dataTaskWithRequest:transformRequest];
    }
    QCloudLogDebug(@"current session type:%@ task type:%@",self.session,task);
    taskData.httpRequest = httpRequest;
    QCloudHTTPRetryHanlder* retryHandler =  httpRequest.retryPolicy;
    taskData.retryHandler = retryHandler;
    [self cacheTask:task data:taskData forSEQ:(int)httpRequest.requestID];
    [task resume];
    
    
}


-(void)dealloc{
    [cloudBackGroundSessionManagersCache removeObject:self];
}

@end
