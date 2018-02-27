//
//  QCloudCredentailFenceQueue.m
//  Pods
//
//  Created by Dong Zhao on 2017/8/31.
//
//

#import "QCloudCredentailFenceQueue.h"
#import "QCloudAuthentationCreator.h"
#import "QCloudCredential.h"
#import "QCloudError.h"
#import "NSError+QCloudNetworking.h"
#import "QCloudWeakProxy.h"

typedef void(^__QCloudFenceActionBlock)(QCloudAuthentationCreator *, NSError *);

@interface QCloudCredentailFenceQueue ()
@property (nonatomic, strong) NSMutableArray* actionCache;
@property (nonatomic, strong) NSRecursiveLock* lock;
@property (atomic, strong) NSTimer* rquestTimer;
@end

@implementation QCloudCredentailFenceQueue


- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _timeout = 2*60;
    _lock = [NSRecursiveLock new];
    _actionCache = [NSMutableArray new];
    return self;
}

- (BOOL) fenceDataVaild
{
    if (!self.authentationCreator) {
        return NO;
    }
    return self.authentationCreator.credential.valid;
}

- (void) performAction:(void (^)(QCloudAuthentationCreator *, NSError *))action
{
    NSParameterAssert(action);
    if (!_delegate) {
        @throw [NSException exceptionWithName:@"com.qcloud.cos.xml" reason:@"当前的QCloudCredentailFenceQueue的delegate为空，请设置之后在使用。如果不设置，将会导致程序线程死锁！！" userInfo:nil];
    }
    [_lock lock];
    if ([self fenceDataVaild]) {
        action(self.authentationCreator, nil);
    } else {
        [_actionCache addObject:action];
        [self requestFenceData];
    }
    [_lock unlock];
}

- (void) onTimeout
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self invalidTimeoutTimter];
        NSError* error = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeCredentialNotReady message:@"获取签名错误"];
        [self postError:error];
    });
}

- (void) invalidTimeoutTimter
{
    [self.rquestTimer invalidate];
    self.rquestTimer = nil;
}

- (void) requestFenceData
{
    if (self.rquestTimer) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    NSTimer* timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:self.timeout] interval:0 target:[QCloudWeakProxy proxyWithTarget:self]  selector:@selector(onTimeout) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    self.rquestTimer = timer;
    [self.delegate fenceQueue:self requestCreatorWithContinue:^(QCloudAuthentationCreator *creator, NSError *error) {
        [weakSelf recive:creator error:error];
    }];
}

- (void) postError:(NSError*)error
{
    [_lock lock];
    NSArray* actions = [_actionCache copy];
    [_actionCache removeAllObjects];
    [_lock unlock];
    for (__QCloudFenceActionBlock action in actions) {
        action(nil, error);
    }
}

- (void) postCreator:(QCloudAuthentationCreator*)creator
{
    [_lock lock];
    NSArray* actions = [_actionCache copy];
    [_actionCache removeAllObjects];
    [_lock unlock];
    for (__QCloudFenceActionBlock action in actions) {
        action(creator, nil);
    }
}

- (void) recive:(QCloudAuthentationCreator*)creator error:(NSError*)error
{
    [self invalidTimeoutTimter];
    [_lock lock];
    _authentationCreator = creator;
    [_lock unlock];
 
    if (error) {
        [self postError:error];
    } else {
        if (!creator.credential.valid) {
            NSError* error = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeCredentialNotReady message:@"获取签名错误"];
            [self postError:error];
        } else {
            [self postCreator:creator];
        }
    }
}
@end
