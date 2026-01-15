//
//  QCloudPNetMLanScanner.m
//  PhoneNetSDK
//
//  Created by mediaios on 2019/6/5.
//  Copyright © 2019年 mediaios. All rights reserved.
//

#import "QCloudPNetMLanScanner.h"
#import "QCloudPReportPingModel.h"
#import "QCloudPNetInfoTool.h"
#import "QCloudPNetModel.h"
#import "QCloudPNetworkCalculator.h"
#import "QCloudPNSamplePing.h"
#import "QCloudPhoneNetSDKConst.h"
#import "QCloudCore/QCloudLogger.h"

@interface QCloudPNetMLanScanner()<QCloudPNSamplePingDelegate>
@property (nonatomic,assign) int cursor;
@property (nonatomic,copy) NSArray *ipList;
@property (nonatomic,strong) NSMutableArray *activedIps;
@property (nonatomic,strong) QCloudPNSamplePing *samplePing;
@property (nonatomic,assign,getter=isStopLanScan) BOOL stopLanScan;
@end

@implementation QCloudPNetMLanScanner


- (NSMutableArray *)activedIps
{
    if (!_activedIps) {
        _activedIps = [NSMutableArray array];
    }
    return _activedIps;
}

- (QCloudPNSamplePing *)samplePing
{
    if (!_samplePing) {
        _samplePing = [[QCloudPNSamplePing alloc] init];
        _samplePing.delegate = self;
    }
    return _samplePing;
}

- (BOOL)isScanning
{
    return !(self.isStopLanScan);
}

- (instancetype)init
{
    if (self = [super init]) {
        _cursor = 0;
        [self addObserver:self forKeyPath:@"cursor" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}


static QCloudPNetMLanScanner *lanScanner_instance = nil;
+ (instancetype)shareInstance
{
    if (!lanScanner_instance) {
        lanScanner_instance = [[QCloudPNetMLanScanner alloc] init];
    }
    return lanScanner_instance;
}

- (void)scan
{
    _stopLanScan = NO;
    QCloudPNetInfoTool *phoneNetTool = [QCloudPNetInfoTool shareInstance];
    [phoneNetTool refreshNetInfo];
    if ([phoneNetTool.pGetNetworkType isEqualToString:@"WIFI"]) {
        PDeviceNetInfo *device = [PDeviceNetInfo deviceNetInfo];
        
        NSString *ip = device.wifiIPV4;
        NSString *netMask = device.wifiNetmask;
        if (ip && netMask) {
            QCloudLogDebugPB(@"PhoneNetSDK-LanScanner", @"now device ip :%s , netMask:%s \n",[ip UTF8String],[netMask UTF8String]);
            _ipList = [QCloudPNetworkCalculator getAllHostsForIP:ip andSubnet:netMask];
            if (!_ipList && _ipList.count <= 0) {
                QCloudLogErrorPB(@"PhoneNetSDK-LanScanner", @"caculating the ip list in the current LAN failed...\n");
                return;
            }
            QCloudLogDebugPB(@"PhoneNetSDK-LanScanner", @"scan ip %s begin...",[self.ipList[self.cursor] UTF8String]);
            [self.samplePing startPingIp:self.ipList[self.cursor] packetCount:3];
            self.cursor++;
        }
    }
}

- (void)stop
{
    _stopLanScan = YES;
    if ([_samplePing isPing]) {
        [_samplePing stopPing];
        _activedIps = nil;
        _ipList = nil;
        _cursor = 0;
    }
    
}

#pragma mark - QCloudPNSamplePingDelegate
- (void)simplePing:(QCloudPNSamplePing *)samplePing didTimeOut:(NSString *)ip
{
    
}

- (void)simplePing:(QCloudPNSamplePing *)samplePing receivedPacket:(NSString *)ip
{
    QCloudLogDebugPB(@"PhoneNetSDK-LanScanner", @" %s  active",[ip UTF8String]);
    [self.delegate scanMLan:self activeIp:ip];
}

- (void)simplePing:(QCloudPNSamplePing *)samplePing pingError:(NSException *)exception
{
    
}

- (void)simplePing:(QCloudPNSamplePing *)samplePing finished:(NSString *)ip
{
    if (self.isStopLanScan) {
        _samplePing = nil;
        return;
    }
    _samplePing = nil;
    _samplePing = [[QCloudPNSamplePing alloc] init];
    _samplePing.delegate = self;
    if (self.cursor < self.ipList.count) {
        [_samplePing startPingIp:self.ipList[self.cursor] packetCount:2];
    }
    self.cursor++;
}

- (void)resetPropertys
{
    _cursor = 0;
    _ipList = nil;
    _activedIps = nil;
    QCloudLogDebugPB(@"PhoneNetSDK-LanScanner", @"reseter propertys...\n");
}

#pragma mark - use KVO to observer progress
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    float newCursor = [[change objectForKey:@"new"] floatValue];
    if ([keyPath isEqualToString:@"cursor"]) {
        float percent = self.ipList.count == 0 ? 0.0f : ((float)newCursor/self.ipList.count);
        [self.delegate scanMlan:self percent:percent];
        QCloudLogDebugPB(@"PhoneNetSDK-LanScanner", @"percent: %f  \n",percent);
        if (newCursor == self.ipList.count) {
            _stopLanScan = YES;
            QCloudLogDebugPB(@"PhoneNetSDK-LanScanner", @"finish MLAN scan...\n");
            [self.delegate finishedScanMlan:self];
            [self resetPropertys];
        }
    }
}
@end
