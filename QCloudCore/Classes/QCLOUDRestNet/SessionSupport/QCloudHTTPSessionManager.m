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
#import "RNAsyncBenchMark.h"
#import "QCloudNetEnv.h"
#import "QCloudHTTPRequestOperation.h"
#import "QCloudLogger.h"
#import "QCloudNetProfile.h"
#import "QCloudOperationQueue.h"
#import "NSError+QCloudNetworking.h"
#import "QCloudFileUtils.h"
#import "QCloudFileOffsetBody.h"
#import "QCloudRequestData.h"
NSString* TaskDataKey(int64_t identifier){
    return [NSString stringWithFormat:@"data-%lld", identifier];
}

NSString* TaskMapKey(NSURLSessionTask* task) {
    return [NSString stringWithFormat:@"%p",(void*)task];
}
 NSString* const kQCloudRestNetURLUsageNotification  = @"kQCloudRestNetURLUsageNotification";




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
@property (nonatomic, strong) NSOperationQueue* sessionTaskQueue;
@property (nonatomic ,strong) NSURLSessionConfiguration* configuration;
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
        client = [QCloudHTTPSessionManager new];
        [QCloudNetEnv shareEnv];
    });
    return client;
}
- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    //for restful request-response using the default session configuration ,and the most import thing is that you must not set the timeout for session configuration
    _configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    _sessionTaskQueue = [[NSOperationQueue alloc] init];
    _session = [NSURLSession sessionWithConfiguration:_configuration delegate:self delegateQueue:_sessionTaskQueue];
    _buildDataQueue = dispatch_queue_create("com.tencent.qcloud.build.data", NULL);
    _taskQueue = [NSMutableDictionary new];
    _operationQueue = [QCloudOperationQueue new];
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

- (int) performRequest:(QCloudHTTPRequest *)request
{
    QCloudHTTPRequestOperation* operation = [[QCloudHTTPRequestOperation alloc] initWithRequest:request];
    [_operationQueue addOpreation:operation];
    return (int)request.requestID;
}

// only work at iOS 10 and up
- (void) URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics
{
        QCloudURLSessionTaskData* taskData = [self taskDataForTask:task];
        NSURLSessionTaskTransactionMetrics* networkMetrics = nil;
        for (NSURLSessionTaskTransactionMetrics* m in metrics.transactionMetrics) {
            if (m.resourceFetchType == NSURLSessionTaskMetricsResourceFetchTypeNetworkLoad) {
                networkMetrics = m;
            } else if (m.resourceFetchType == NSURLSessionTaskMetricsResourceFetchTypeLocalCache){
            }
        }

        if (networkMetrics) {
            if (!networkMetrics.reusedConnection) {
                [taskData.httpRequest.benchMarkMan directSetCost:[networkMetrics.connectEndDate     timeIntervalSinceDate:networkMetrics.connectStartDate] forKey:kRNBenchmarkConnectionTime];
                if ([taskData.httpRequest.requestData.serverURL.lowercaseString hasPrefix:@"https"]) {
                    [taskData.httpRequest.benchMarkMan directSetCost:[networkMetrics.secureConnectionEndDate timeIntervalSinceDate:networkMetrics.secureConnectionStartDate] forKey:kRNBenchmarkSecureConnectionTime];
                }
                [taskData.httpRequest.benchMarkMan directSetCost:[networkMetrics.domainLookupEndDate timeIntervalSinceDate:networkMetrics.domainLookupEndDate] forKey:kRNBenchmarkDNSLoopupTime];
            }
            [taskData.httpRequest.benchMarkMan directSetCost:[networkMetrics.requestEndDate timeIntervalSinceDate:networkMetrics.requestStartDate] forKey:@"upload"];
            [taskData.httpRequest.benchMarkMan directSetCost:[networkMetrics.responseEndDate timeIntervalSinceDate:networkMetrics.responseStartDate] forKey:@"download"];
        }
}

- (void) URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    QCloudURLSessionTaskData* taskData = [self taskDataForTask:dataTask];
    [taskData.httpRequest.benchMarkMan benginWithKey:kRNBenchmarkServerTime];
    taskData.response = (NSHTTPURLResponse*)response;
    if (taskData.httpRequest.downloadingURL) {
        // if http statue is not found will forbidden write to file
        if ([@[@(400), @(403), @(404), @(405)] containsObject:@(taskData.response.statusCode)]) {
            taskData.forbidenWirteToFile = YES;
            completionHandler([taskData.httpRequest reciveResponse:response]);
        } else {
            completionHandler([taskData.httpRequest reciveResponse:response]);
        }
    } else {
        completionHandler([taskData.httpRequest reciveResponse:response]);
    }
 
}
- (void) URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    QCloudURLSessionTaskData* taskData = [self taskDataForTask:task];
    if (taskData.httpRequest.sendProcessBlock) {
        [taskData.httpRequest notifySendProgressBytesSend:bytesSent totalBytesSend:totalBytesSent totalBytesExpectedToSend:totalBytesExpectedToSend];
    }
    [[QCloudNetProfile shareProfile] pointUpload:bytesSent];
    if (totalBytesSent == totalBytesExpectedToSend) {
        [taskData.httpRequest.benchMarkMan markFinishWithKey:kRNBenchmarkUploadTime];
        [taskData.httpRequest.benchMarkMan markFinishWithKey:kRNBenchmarkRequest];
    }
}

- (void) URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    QCloudURLSessionTaskData* taskData = [self taskDataForTask:dataTask];
    if (taskData.totalRecivedLength == 0) {
        [taskData.httpRequest.benchMarkMan markFinishWithKey:kRNBenchmarkServerTime];
        [taskData.httpRequest.benchMarkMan benginWithKey:kRNBenchmarkDownploadTime];
        [taskData.httpRequest.benchMarkMan benginWithKey:kRNBenchmarkResponse];
    }
    [taskData appendData:data];
    if (taskData.httpRequest) {
        [taskData.httpRequest notifyDownloadProgressBytesDownload:(int64_t)data.length
                                               totalBytesDownload:(int64_t)taskData.totalRecivedLength
                                     totalBytesExpectedToDownload:(int64_t)[dataTask.response expectedContentLength]];
    }
    [[QCloudNetProfile shareProfile] pointDownload:data.length];
}



- (void) URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kQCloudRestNetURLUsageNotification object:nil userInfo:@{
                                                                                                         @"url":task.originalRequest.URL? task.originalRequest.URL : [NSURL URLWithString:@"http://nullurl.error.com.tencent.qcloud.network"]
          
                                                                                                         }];
    QCloudURLSessionTaskData* taskData = [self taskDataForTask:task];
    if (!taskData) {
        return;
    }
    [taskData.httpRequest.benchMarkMan markFinishWithKey:kRNBenchmarkDownploadTime];
    int seq = [self seqForTask:task];
    __weak typeof(self)weakSelf = self;
    if (error) {
        QCloudLogError(@"Network Error %@",error);
        void(^EndRetryFunc)(void) = ^(void) {
            [taskData.httpRequest.benchMarkMan markFinishWithKey:kRNBenchmarkOnlyNet];
            [taskData.httpRequest onReviveErrorResponse:task.response error:error];
            [weakSelf removeTask:task];
        };

        if (!taskData.retryHandler) {
            EndRetryFunc();
        } else {
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
        [taskData.httpRequest.benchMarkMan markFinishWithKey:kRNBenchmarkOnlyNet];
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
    [httpRequest willStart];
    NSError* error;
    NSMutableURLRequest* urlRequest = [[httpRequest buildURLRequest:&error] mutableCopy];
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
                directError = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeContentError message:@"您输入的body的URL不是本地URL，请检查后使用！！"];
            }
            NSUInteger fileSize = QCloudFileSize(fileURL.path);
            [mutableRequest setValue:[@(fileSize) stringValue] forHTTPHeaderField:@"Content-Length"];
            NSInputStream* inputStream = [NSInputStream inputStreamWithURL:fileURL];
            [mutableRequest setHTTPBodyStream:inputStream];
        } else if ([body isKindOfClass:[QCloudFileOffsetBody class]]) {
            QCloudFileOffsetBody* fileBody = (QCloudFileOffsetBody*)body;
            if (![fileBody.fileURL isFileURL]) {
                directError = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeContentError message:@"您输入的body的URL不是本地URL，请检查后使用！！"];
            }
            
            NSFileHandle* handler = [NSFileHandle fileHandleForReadingAtPath:fileBody.fileURL.path];
            [handler seekToFileOffset:fileBody.offset];
            NSData* data = [handler readDataOfLength:fileBody.sliceLength];
            NSString* tempFile = taskData.uploadTempFilePath;
            
            if([data writeToFile:tempFile options:0 error:&directError]) {
                NSInputStream* inputstream = [NSInputStream inputStreamWithFileAtPath:tempFile];
                [mutableRequest setValue:[@(fileBody.sliceLength) stringValue] forHTTPHeaderField:@"Content-Length"];
                [handler closeFile];
                [mutableRequest setHTTPBodyStream:inputstream];
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
    if (![httpRequest prepareInvokeURLRequest:transformRequest error:&parepareError]) {
        [httpRequest onError:parepareError];
        return;
    }
    if (nil == transformRequest) {
        NSError* error = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeContentError message:@"构建Request时候出错，出现空的Request"];
        [httpRequest onError:error];
        return;
    }

    NSURLSessionDataTask* task = [[QCloudHTTPSessionManager shareClient].session dataTaskWithRequest:transformRequest];
    taskData.httpRequest = httpRequest;
    
    QCloudHTTPRetryHanlder* retryHandler =  httpRequest.retryPolicy;
    taskData.retryHandler = retryHandler;
    [self cacheTask:task data:taskData forSEQ:(int)httpRequest.requestID];
    [httpRequest.benchMarkMan benginWithKey:kRNBenchmarkOnlyNet];
    
    @try {
        int length = [[urlRequest.allHTTPHeaderFields objectForKey:@"Content-Length"] intValue];
        [httpRequest.benchMarkMan directSetCost:length forKey:kRNBenchmarkSizeRequeqstBody];
        NSUInteger headerLength = [NSJSONSerialization dataWithJSONObject:urlRequest.allHTTPHeaderFields options:0 error:nil].length;
        [httpRequest.benchMarkMan directSetCost:headerLength forKey:kRNBenchmarkSizeRequeqstHeader];
    }
    @catch (NSException *exception) {} @finally {}
    [task resume];
    [httpRequest.benchMarkMan benginWithKey:kRNBenchmarkUploadTime];
}
@end
