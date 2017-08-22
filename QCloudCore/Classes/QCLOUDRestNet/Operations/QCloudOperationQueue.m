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
@interface QCloudOperationQueue () <QCloudRequestOperationDelegate>
{
    NSMutableArray* _operationArray;
    NSRecursiveLock* _dataLock;
    NSMutableArray* _runningOperationArray;
}
@end

@implementation QCloudOperationQueue

- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _dataLock = [NSRecursiveLock new];
    _operationArray  = [NSMutableArray new];
    _runningOperationArray = [NSMutableArray new];
    _maxConcurrentCount = 4;
    return self;
}

- (void) addOpreation:(QCloudRequestOperation *)operation
{
    [_dataLock lock];
    [_operationArray addObject:operation];
    [_operationArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    [_dataLock unlock];
    QCloudLogInfo(@"[%@][%lld]请求已经缓存到队列中", [operation.request class], [operation.request requestID]);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self tryStartAnyOperation];
    });
}

- (void) tryStartAnyOperation
{
    [_dataLock lock];
    void(^ExeOperation)(QCloudRequestOperation* operation) = ^(QCloudRequestOperation* operation) {
        [_operationArray removeObject:operation];
        operation.delagte = self;
        QCloudLogInfo(@"[%@][%lld]请求从队列中取出，开始执行", [operation.request class], [operation.request requestID]);
        [_runningOperationArray addObject:operation];
        [operation execute];

    };
    if (_operationArray.count !=0 ) {
        NSMutableArray* highPerfomanceRequest = [NSMutableArray new];
        NSMutableArray* lowPerformanceRequest = [NSMutableArray new];
        NSMutableArray* normalPerformanceRequest = [NSMutableArray new];
        for (QCloudRequestOperation* operation  in [_operationArray copy]) {
            if (operation.request.priority > QCloudAbstractRequestPriorityNormal) {
                [highPerfomanceRequest addObject:operation];
            } else if (operation.request.priority < QCloudAbstractRequestPriorityNormal){
                [normalPerformanceRequest addObject:operation];
            } else {
                [lowPerformanceRequest addObject:operation];
            }
        }
        for (QCloudRequestOperation* op  in highPerfomanceRequest) {
            ExeOperation(op);
        }
        if (_runningOperationArray.count < self.maxConcurrentCount) {
            if (normalPerformanceRequest.count) {
                if (normalPerformanceRequest.count) {
                    QCloudRequestOperation* operation = normalPerformanceRequest.firstObject;
                    ExeOperation(operation);
                }
            } else {
                if (lowPerformanceRequest.count) {
                    QCloudRequestOperation* operation = lowPerformanceRequest.firstObject;
                    ExeOperation(operation);
                }
            }
        }
    }
    [_dataLock unlock];
}

- (void) requestOperationFinish:(QCloudRequestOperation *)operation
{
    [_dataLock lock];
    [_runningOperationArray removeObject:operation];
    [_dataLock unlock];
    [self tryStartAnyOperation];
    QCloudLogInfo(@"[%@][%lld]执行完毕", [operation.request class], [operation.request requestID]);
}


- (void) cancel:(QCloudRequestOperation *)operation
{
    [_dataLock lock];
    [_runningOperationArray removeObject:operation];
    [_operationArray removeObject:operation];
    [_dataLock unlock];
    [self tryStartAnyOperation];
}

- (void) cancelByRequestID:(int64_t)requestID
{
    [_dataLock lock];
    void(^RemoveOperation)(NSMutableArray* array) = ^(NSMutableArray* array) {
        for (QCloudRequestOperation* request in [array copy]) {
            if (request.request.requestID == requestID) {
                [array removeObject:request];
            }
        }
    };
    RemoveOperation(_runningOperationArray);
    RemoveOperation(_operationArray);
    [self tryStartAnyOperation];
    [_dataLock unlock];
}
@end

