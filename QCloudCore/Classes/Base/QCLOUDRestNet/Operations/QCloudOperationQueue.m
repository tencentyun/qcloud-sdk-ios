//
//  QCloudOperationQueue.m
//  Pods
//
//  Created by Dong Zhao on 2017/3/10.
//
//

#import "QCloudOperationQueue.h"
#import "QCloudRequestOperation.h"
#import "QCloudLogger.h"
#import "QCloudAbstractRequest.h"
#import "QCloudHTTPRequest.h"
#import "QCloudNetEnv.h"
#import "QCloudNetProfile.h"
static const NSInteger kDefaultCouncurrentCount = 4;
static const NSInteger kWeakNetworkConcurrentCount = 1;

@interface QCloudOperationQueue () <QCloudRequestOperationDelegate> {
    NSRecursiveLock *_dataLock;
    NSMutableArray *_runningOperationArray;
    NSMutableArray *_highPerfomanceRequest;
    NSMutableArray *_lowPerformanceRequest;
    NSMutableArray *_normalPerformanceRequest;
    NSMutableArray *_backgroundPerformanceRequest;
}
@property (nonatomic, assign) NSInteger uploadSpeedReachThresholdTimes;
@end

@implementation QCloudOperationQueue

- (instancetype)init {
    self = [super init];
    if (!self) {
        return self;
    }
    _dataLock = [NSRecursiveLock new];
    _runningOperationArray = [NSMutableArray new];
    _highPerfomanceRequest = [NSMutableArray array];
    _normalPerformanceRequest = [NSMutableArray array];
    _lowPerformanceRequest = [NSMutableArray array];
    _backgroundPerformanceRequest = [NSMutableArray array];
    _maxConcurrentCount = kWeakNetworkConcurrentCount;
    _uploadSpeedReachThresholdTimes = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onHandleNetworkSituationChange:)
                                                 name:kNetworkSituationChangeKey
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onHandleNetworkUploadSpeedUpadte:)
                                                 name:kQCloudNetProfileUploadSpeedUpdate
                                               object:nil];

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addOpreation:(QCloudRequestOperation *)operation {
    [_dataLock lock];
    if (operation.request.priority > QCloudAbstractRequestPriorityNormal) {
        [_highPerfomanceRequest addObject:operation];
    } else if (operation.request.priority > QCloudAbstractRequestPriorityLow) {
        [_normalPerformanceRequest addObject:operation];
    } else if (operation.request.priority > QCloudAbstractRequestPriorityBackground) {
        [_lowPerformanceRequest addObject:operation];
    } else {
        [_backgroundPerformanceRequest addObject:operation];
    }
    [_dataLock unlock];
    QCloudLogVerbose(@"[%@][%lld]请求已经缓存到队列中", [operation.request class], [operation.request requestID]);
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    [self tryStartAnyOperation];
    //    });
}

- (void)tryStartAnyOperation {
    [_dataLock lock];
    int concurrentCount = self.customConcurrentCount ? self.customConcurrentCount : self.maxConcurrentCount;

    void (^ExeOperation)(QCloudRequestOperation *operation) = ^(QCloudRequestOperation *operation) {
        operation.delagte = self;
        QCloudLogVerbose(@"[%@][%lld]请求从队列中取出，开始执行", [operation.request class], [operation.request requestID]);
        [self->_runningOperationArray addObject:operation];
        [operation execute];
    };

    if (_highPerfomanceRequest.count || _normalPerformanceRequest.count || _lowPerformanceRequest.count || _backgroundPerformanceRequest.count) {
        for (QCloudRequestOperation *op in [_highPerfomanceRequest copy]) {
            ExeOperation(op);
            [_highPerfomanceRequest removeObject:op];
        }
        QCloudLogDebug(@"Current max concurrent count is %i", concurrentCount);
        if (_runningOperationArray.count < concurrentCount) {
            if (_normalPerformanceRequest.count) {
                QCloudRequestOperation *operation = _normalPerformanceRequest.firstObject;
                ExeOperation(operation);
                [_normalPerformanceRequest removeObject:operation];
            } else if (_lowPerformanceRequest.count) {
                QCloudRequestOperation *operation = _lowPerformanceRequest.firstObject;
                ExeOperation(operation);
                [_lowPerformanceRequest removeObject:operation];
            } else if (_backgroundPerformanceRequest.count) {
                QCloudRequestOperation *operation = _backgroundPerformanceRequest.firstObject;
                ExeOperation(operation);
                [_backgroundPerformanceRequest removeObject:operation];
            }
        }
    }
    [_dataLock unlock];
}

- (void)requestOperationFinish:(QCloudRequestOperation *)operation {
    [_dataLock lock];
    [_runningOperationArray removeObject:operation];
    [_dataLock unlock];
    [self tryStartAnyOperation];
    QCloudLogVerbose(@"[%@][%lld]执行完毕", [operation.request class], [operation.request requestID]);
}

- (void)cancel:(QCloudRequestOperation *)operation {
    QCloudLogDebug(@"[%llu] cancelled by operation", operation.request.requestID);
    [_dataLock lock];
    [_runningOperationArray removeObject:operation];
    if (operation.request.priority == QCloudAbstractRequestPriorityHigh) {
        [_highPerfomanceRequest removeObject:operation];
    } else if (operation.request.priority == QCloudAbstractRequestPriorityNormal) {
        [_normalPerformanceRequest removeObject:operation];
    } else if (operation.request.priority == QCloudAbstractRequestPriorityLow) {
        [_lowPerformanceRequest removeObject:operation];
    } else {
        [_backgroundPerformanceRequest removeObject:operation];
    }
    [_dataLock unlock];
    [self tryStartAnyOperation];
}

- (void)cancelByRequestID:(int64_t)requestID {
    QCloudLogDebug(@"[%llu] cancelled by request id ", requestID);
    [_dataLock lock];
    [self removeRequestInQueue:requestID];
    [self tryStartAnyOperation];
    [_dataLock unlock];
}

- (void)removeRequestInQueue:(int64_t)requestID {
    @autoreleasepool {
        void (^RemoveOperation)(NSMutableArray *array) = ^(NSMutableArray *array) {
            for (QCloudRequestOperation *request in [array copy]) {
                if (request.request.requestID == requestID) {
                    [array removeObject:request];
                    QCloudLogDebug(@"[%llu] request removed successes!", requestID);
                }
            }
        };
        RemoveOperation(_runningOperationArray);
        RemoveOperation(_highPerfomanceRequest);
        RemoveOperation(_lowPerformanceRequest);
        RemoveOperation(_normalPerformanceRequest);
        RemoveOperation(_backgroundPerformanceRequest);
    }
}

-(void)cancelAllOperation{
    @autoreleasepool {
        void (^CancelOperation)(NSMutableArray *array) = ^(NSMutableArray *array) {
            for (QCloudRequestOperation *request in [array copy]) {
                [request.request cancel];
            }
        };
        CancelOperation(_runningOperationArray);
        CancelOperation(_highPerfomanceRequest);
        CancelOperation(_lowPerformanceRequest);
        CancelOperation(_normalPerformanceRequest);
        CancelOperation(_backgroundPerformanceRequest);
    }
}

- (void)cancelByRequestIDs:(NSArray<NSNumber *> *)requestIDs {
    [_dataLock lock];
    for (NSNumber *requestID in requestIDs) {
        [self removeRequestInQueue:[requestID longLongValue]];
    }
    [_dataLock unlock];
    [self tryStartAnyOperation];
}

- (void)onHandleNetworkSituationChange:(NSNotification *)notification {
    NSString *descriptionString;
    QCloudNetworkSituation networkSituation = (QCloudNetworkSituation)[notification.object integerValue];
    switch (networkSituation) {
        case QCloudNetworkSituationWeakNetwork:
            self.maxConcurrentCount = kWeakNetworkConcurrentCount;
            descriptionString = @"弱网络";
            [self resetConcurrentCount];
            break;
        case QCloudNetworkSituationGreatNetork:
            self.maxConcurrentCount = kDefaultCouncurrentCount;
            descriptionString = @"良好网络";
        default:
            break;
    }
    QCloudLogDebug(@"网络环境发生变化，当前的网络环境为：%@", descriptionString);
}

- (void)onHandleNetworkUploadSpeedUpadte:(NSNotification *)notification {
    int concurrentCount = self.customConcurrentCount ? self.customConcurrentCount : self.maxConcurrentCount;
    NSArray *speedLevelsArray = [notification.object copy];
    int64_t uploadSpeedIn30S = 0;
    for (QCloudNetProfileLevel *level in speedLevelsArray) {
        if (level.interval == 30) {
            uploadSpeedIn30S = level.uploadSpped;
        }
    }
    int64_t currentUploadSpeedPerOperation = uploadSpeedIn30S / concurrentCount;
    //若每个任务速度大于250KB/s
    static const int64_t increaseConcurrentCountThreashold = 250 * 1024;
    //        NSLog(@"Current network speed per operation = %lu  KB/S， uploadSpeedIn30S = %llu KB/s, max concurrent count
    //        =%lu",currentUploadSpeedPerOperation/(1024),uploadSpeedIn30S/1024,self.maxConcurrentCount);
    if (currentUploadSpeedPerOperation > increaseConcurrentCountThreashold) {
        self.uploadSpeedReachThresholdTimes++;
    } else {
        self.uploadSpeedReachThresholdTimes = 0;
    }
    if (self.uploadSpeedReachThresholdTimes > 5) {
        [self incresetConcurrentCount];
        self.uploadSpeedReachThresholdTimes = 0;
    }
}

- (void)incresetConcurrentCount {
    if (self.maxConcurrentCount < kDefaultCouncurrentCount) {
        QCloudLogDebug(@"concurernt count increased! previous concurrent count is %i ", self.maxConcurrentCount);
        self.maxConcurrentCount++;
    }
    return;
}

- (void)resetConcurrentCount {
    QCloudLogDebug(@"Max concurrent count has beed reset!");
    self.maxConcurrentCount = 1;
}
@end
