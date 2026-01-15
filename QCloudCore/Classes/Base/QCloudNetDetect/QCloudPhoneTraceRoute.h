//
//  QCloudPhoneTraceRoute.h
//  PingDemo
//
//  Created by mediaios on 08/08/2018.
//  Copyright © 2018 mediaios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QCloudPTracerRouteResModel.h"
#import "QCloudPhoneNetDiagnosisHelper.h"

#define QCloudTracertRouteCount_noRes  10     // 连续无响应的route个数
#define QCloudTracertMaxTTL  64    // Max 30 hops（最多30跳）
#define  QCloudTracertSendIcmpPacketTimes            3     // 对一个中间节点，发送2个icmp包
#define QCloudIcmpPacketTimeoutTime  300   // ICMP包超时时间(ms)

@class QCloudPhoneTraceRoute;
@protocol QCloudPhoneTraceRouteDelegate<NSObject>
- (void)tracerouteWithUCTraceRoute:(QCloudPhoneTraceRoute *)ucTraceRoute tracertResult:(QCloudPTracerRouteResModel *)tracertRes;
- (void)tracerouteFinishedWithUCTraceRoute:(QCloudPhoneTraceRoute *)ucTraceRoute;
@optional


@end

@interface QCloudPhoneTraceRoute : NSObject
@property (nonatomic,strong) id<QCloudPhoneTraceRouteDelegate> delegate;

- (void)startTracerouteHost:(NSString *)host;

- (void)stopTracert;
- (BOOL)isTracert;
@end
