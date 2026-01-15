//
//  QCloudPNSamplePing.h
//  PhoneNetSDK
//
//  Created by mediaios on 2019/6/5.
//  Copyright © 2019年 mediaios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QCloudPPingResModel.h"
#import "QCloudPhoneNetDiagnosisHelper.h"

NS_ASSUME_NONNULL_BEGIN
@class QCloudPNSamplePing;
@protocol QCloudPNSamplePingDelegate <NSObject>

@optional
- (void)simplePing:(QCloudPNSamplePing *)samplePing didTimeOut:(NSString *)ip;
- (void)simplePing:(QCloudPNSamplePing *)samplePing receivedPacket:(NSString *)ip;
- (void)simplePing:(QCloudPNSamplePing *)samplePing pingError:(NSException *)exception;
- (void)simplePing:(QCloudPNSamplePing *)samplePing finished:(NSString *)ip;

@end



@interface QCloudPNSamplePing : NSObject

@property (nonatomic,weak) id<QCloudPNSamplePingDelegate> delegate;

- (void)startPingIp:(NSString *)ip packetCount:(int)count;

- (void)stopPing;
- (BOOL)isPing;
@end

NS_ASSUME_NONNULL_END
