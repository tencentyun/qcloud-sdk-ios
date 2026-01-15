//
//  UCPingService.m
//  PingDemo
//
//  Created by mediaios on 06/08/2018.
//  Copyright © 2018 mediaios. All rights reserved.
//

#import "QCloudPhonePingService.h"
#import "QCloudPhoneNetSDKConst.h"
#import "QCloudPhoneNetSDKHelper.h"
#import "QCloudCore/QCloudLogger.h"
@interface QCloudPhonePingService()<QCloudPhonePingDelegate>
@property (nonatomic,strong) QCloudPhonePing *uPing;
@property (nonatomic,strong) NSMutableDictionary *pingResDic;
@property (nonatomic,copy,readonly) NetPingResultHandler pingResultHandler;

@end

@implementation QCloudPhonePingService

static QCloudPhonePingService *ucPingservice_instance = NULL;

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSMutableDictionary *)pingResDic
{
    if (!_pingResDic) {
        _pingResDic = [NSMutableDictionary dictionary];
    }
    return _pingResDic;
}

+ (instancetype)shareInstance
{
    if (ucPingservice_instance == NULL) {
        ucPingservice_instance = [[QCloudPhonePingService alloc] init];
    }
    return ucPingservice_instance;
}

- (void)uStopPing
{
    [self.uPing stopPing];
}

- (BOOL)uIsPing
{
    return [self.uPing isPing];
}

- (void)addPingResToPingResContainer:(QCloudPPingResModel *)pingItem andHost:(NSString *)host
{
    if (host == NULL || pingItem == NULL) {
        return;
    }
    
    NSMutableArray *pingItems = [self.pingResDic objectForKey:host];
    if (pingItems == NULL) {
        pingItems = [NSMutableArray arrayWithArray:@[pingItem]];
    }else{

        try {
            [pingItems addObject:pingItem];
        } catch (NSException *exception) {
            QCloudLogWarningPB(@"PhoneNetPing", @"func: %s, exception info: %s , line: %d",__func__,[exception.description UTF8String],__LINE__);
        }
    }
    
    [self.pingResDic setObject:pingItems forKey:host];
//        NSLog(@"%@",self.pingResDic);

    if (pingItem.status == PhoneNetPingStatusFinished) {
        NSArray *pingItems = [self.pingResDic objectForKey:host];
        NSDictionary *dict = [QCloudPPingResModel pingResultWithPingItems:pingItems];
//            NSLog(@"dict----res:%@, pingRes:%@",dict,self.pingResDic);
        QCloudPReportPingModel *reportPingModel = [QCloudPReportPingModel uReporterPingmodelWithDict:dict];
        
        NSString *pingSummary = [NSString stringWithFormat:@"%d packets transmitted , loss:%d , delay:%0.3fms , ttl:%d",reportPingModel.totolPackets,reportPingModel.loss,reportPingModel.delay,reportPingModel.ttl];
        self.pingResultHandler(pingSummary);
        
        [self removePingResFromPingResContainerWithHostName:host];
    }
}

- (void)removePingResFromPingResContainerWithHostName:(NSString *)host
{
    if (host == NULL) {
        return;
    }
    [self.pingResDic removeObjectForKey:host];
}

- (void)startPingHost:(NSString *)host packetCount:(int)count resultHandler:(NetPingResultHandler)handler
{
    if (_uPing) {
        _uPing = nil;
        _uPing = [[QCloudPhonePing alloc] init];

    }else{
        _uPing = [[QCloudPhonePing alloc] init];
    }
    _pingResultHandler = handler;
    _uPing.delegate = self;
    [_uPing startPingHosts:host packetCount:count];
    
}

#pragma mark-UCPingDelegate
- (void)pingResultWithUCPing:(QCloudPhonePing *)ucPing pingResult:(QCloudPPingResModel *)pingRes pingStatus:(PhoneNetPingStatus)status
{

    [self addPingResToPingResContainer:pingRes andHost:pingRes.IPAddress];
    
    if (status == PhoneNetPingStatusFinished) {
        return;
    }
    
    NSString *pingDetail = [NSString stringWithFormat:@"%d bytes form %@: icmp_seq=%d ttl=%d time=%.3fms",(int)pingRes.dateBytesLength,pingRes.IPAddress,(int)pingRes.ICMPSequence,(int)pingRes.timeToLive,pingRes.timeMilliseconds];
    _pingResultHandler(pingDetail);
}


@end
