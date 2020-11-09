

//
//  WHPingTester.m
//  BigVPN
//
//  Created by wanghe on 2017/5/11.
//  Copyright © 2017年 wanghe. All rights reserved.
//

#import "QCloudPingTester.h"
#import "QCloudCore.h"
@interface QCloudPingTester () <SimplePingDelegate> {
    NSTimer *_timer;
    NSDate *_beginDate;
}
@property (nonatomic, strong) QCloudSimplePing *simplePing;
@property (nonatomic) NSString *ip;
@property (nonatomic) NSString *host;
@property (nonatomic, strong) NSMutableArray<QCloudPingItem *> *pingItems;
@end

@implementation QCloudPingTester

- (instancetype)initWithIp:(NSString *)ip host:(NSString *)host fulfil:(dispatch_semaphore_t)sema {
    if (self = [super init]) {
        self.ip = ip;
        self.host = host;
        self.sema = sema;
        self.simplePing = [[QCloudSimplePing alloc] initWithHostName:ip];
        self.simplePing.delegate = self;
        self.simplePing.addressStyle = SimplePingAddressStyleAny;

        self.pingItems = [NSMutableArray new];
    }
    return self;
}

- (void)startPing {
    [self.simplePing start];
}

- (void)stopPing {
    [_timer invalidate];
    _timer = nil;
    [self.simplePing stop];
}

- (void)actionTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(sendPingData) userInfo:nil repeats:YES];
}

- (void)sendPingData {
    [self.simplePing sendPingWithData:nil];
}

#pragma mark Ping Delegate
- (void)simplePing:(QCloudSimplePing *)pinger didStartWithAddress:(NSData *)address {
    [self actionTimer];
}

- (void)simplePing:(QCloudSimplePing *)pinger didFailWithError:(NSError *)error {
    QCloudLogError(@"ping失败,error: %@", error);
}

- (void)simplePing:(QCloudSimplePing *)pinger didSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber {
    QCloudPingItem *item = [QCloudPingItem new];
    item.sequence = sequenceNumber;
    [self.pingItems addObject:item];

    _beginDate = [NSDate date];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.pingItems containsObject:item]) {
            QCloudLogError(@"超时---->");
            [self.pingItems removeObject:item];
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(pingTester:didPingSucccessWithTime:withError:)]) {
                [self.delegate pingTester:self didPingSucccessWithTime:0 withError:[NSError errorWithDomain:NSURLErrorDomain code:111 userInfo:nil]];
            }
        }
    });
}
- (void)simplePing:(QCloudSimplePing *)pinger didFailToSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber error:(NSError *)error {
    QCloudLogError(@"发包失败:%@", error);
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(pingTester:didPingSucccessWithTime:withError:)]) {
        [self.delegate pingTester:self didPingSucccessWithTime:0 withError:error];
    }
}

- (void)simplePing:(QCloudSimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber {
    float delayTime = [[NSDate date] timeIntervalSinceDate:_beginDate] * 1000;
    [self.pingItems enumerateObjectsUsingBlock:^(QCloudPingItem *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (obj.sequence == sequenceNumber) {
            [self.pingItems removeObject:obj];
        }
    }];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(pingTester:didPingSucccessWithTime:withError:)]) {
        [self.delegate pingTester:self didPingSucccessWithTime:delayTime withError:nil];
    }
}

- (void)simplePing:(QCloudSimplePing *)pinger didReceiveUnexpectedPacket:(NSData *)packet {
}

@end

@implementation QCloudPingItem

@end
