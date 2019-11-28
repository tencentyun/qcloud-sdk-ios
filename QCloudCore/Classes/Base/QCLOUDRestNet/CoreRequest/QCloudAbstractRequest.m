//
//  QCloudAbstractRequest.m
//  Pods
//
//  Created by Dong Zhao on 2017/3/10.
//
//

#import "QCloudAbstractRequest.h"
#import "QCloudLogger.h"
#import "QCloudNetEnv.h"
#import "NSError+QCloudNetworking.h"

@implementation QCloudAbstractRequest
@synthesize requestID = _requestID;

- (instancetype) init {
    self = [super init];
    if (!self) {
        return self;
    }
    _benchMarkMan = [QCloudHttpMetrics new];
    _priority = QCloudAbstractRequestPriorityHigh;
    static int64_t requestID = 3333;
    _requestID = requestID + 1;
    requestID++;
    _finished = NO;
    return self;
}

- (void) __notifyError:(NSError*)error
{
//    [self.benchMarkMan benginWithKey:kRNBenchmarkLogicOnly];
    if ([self.delegate respondsToSelector:@selector(QCloudHTTPRequestDidFinished:failed:)]) {
        [self.delegate QCloudHTTPRequestDidFinished:self failed:error];
    }
    if (self.finishBlock) {
        self.finishBlock(nil, error);
    }
    self.finishBlock = nil;
//    [self.benchMarkMan markFinishWithKey:kRNBenchmarkLogicOnly];
}
- (void) notifyError:(NSError*)error
{
    if (![NSThread isMainThread]) {
        [self __notifyError:error];
    } else {
        [self performSelectorInBackground:@selector(__notifyError:) withObject:error];
    }
}

- (void) onError:(NSError*)error
{
    @synchronized (self) {
        if (_finished) {
            return;
        }
        _finished = YES;
    }
    [self.benchMarkMan markFinishWithKey:kTaskTookTime];
    [self notifyError:error];
    _finished = YES;
    QCloudLogError(@"[%@][%lld]当前网络环境为%d 请求失败%@", [self class],self.requestID, QCloudNetworkShareEnv.currentNetStatus, error);
    QCloudLogVerbose(@"[%@][%lld]性能监控 %@",[self class],self.requestID ,[self.benchMarkMan readablityDescription]);
}

- (void) __notifySuccess:(id)object
{
    
    if ([self.delegate respondsToSelector:@selector(QCloudHTTPRequestDidFinished:succeedWithObject:)]){
        [self.delegate QCloudHTTPRequestDidFinished:self succeedWithObject:object];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        if (self.finishBlock) {
            self.finishBlock(object, nil);
        }
        self.finishBlock = nil;
    });
}

- (void) notifySuccess:(id)object
{
    if (![NSThread isMainThread]) {
        [self __notifySuccess:object];
    } else {
        [self performSelectorInBackground:@selector(__notifySuccess:) withObject:object];
    }
}

- (void) onSuccess:(id)object
{
    @synchronized (self) {
        if (_finished) {
            return;
        }
        _finished = YES;
    }
    [self.benchMarkMan markFinishWithKey:kTaskTookTime];
    [self notifySuccess:object];
    _finished = YES;
    QCloudLogVerbose(@"[%@][%lld]性能监控\n%@", [self class],self.requestID, [self.benchMarkMan readablityDescription]);
}


- (void) cancel
{
    @synchronized (self) {
        _canceled = YES;
    }
    NSError* cancelError = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeCanceled message:@"UserCancelled:The request is canceled"];
    [self onError:cancelError];
}

- (void) notifyDownloadProgressBytesDownload:(int64_t)bytesDownload
                          totalBytesDownload:(int64_t)totalBytesDownload
                totalBytesExpectedToDownload:(int64_t)totalBytesExpectedToDownload
{
    if (self.canceled) {
        return;
    }
    if (self.downProcessBlock) {
        self.downProcessBlock(bytesDownload, totalBytesDownload, totalBytesExpectedToDownload);
    }
    if ([self.delegate respondsToSelector:@selector(QCloudHTTPRequest:bytesDownload:totalBytesDownload:totalBytesExpectedToDownload:)]) {
        [self.delegate QCloudHTTPRequest:self bytesDownload:bytesDownload totalBytesDownload:totalBytesDownload totalBytesExpectedToDownload:totalBytesExpectedToDownload];
    }
}

- (void) notifySendProgressBytesSend:(int64_t)bytesSend
                          totalBytesSend:(int64_t)totalBytesSend
                totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    if (self.canceled) {
        return;
    }
    if (self.sendProcessBlock) {
        self.sendProcessBlock(bytesSend, totalBytesSend, totalBytesExpectedToSend);
    }
    if ([self.delegate respondsToSelector:@selector(QCloudHTTPRequest:sendBytes:totalBytesSent:totalBytesExpectedToSend:)]) {
        [self.delegate QCloudHTTPRequest:self sendBytes:bytesSend totalBytesSent:totalBytesSend totalBytesExpectedToSend:totalBytesExpectedToSend];
    }
}



@end
