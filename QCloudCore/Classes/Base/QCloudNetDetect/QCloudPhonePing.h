//
//  QCloudPhonePing.h
//  PingDemo
//
//  Created by mediaios on 03/08/2018.
//  Copyright © 2018 mediaios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QCloudPPingResModel.h"
#import "QCloudPhoneNetDiagnosisHelper.h"

@class QCloudPhonePing;

@protocol QCloudPhonePingDelegate  <NSObject>

@optional
- (void)pingResultWithUCPing:(QCloudPhonePing *)ucPing pingResult:(QCloudPPingResModel *)pingRes pingStatus:(PhoneNetPingStatus)status;


@end

@interface QCloudPhonePing : NSObject

@property (nonatomic,strong) id<QCloudPhonePingDelegate> delegate;

- (void)startPingHosts:(NSString *)host packetCount:(int)count;

- (void)stopPing;
- (BOOL)isPing;
@end
