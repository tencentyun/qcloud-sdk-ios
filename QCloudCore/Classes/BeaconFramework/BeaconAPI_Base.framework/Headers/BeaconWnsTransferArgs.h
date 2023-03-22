//
//  BeaconTransferArgs.h
//  BeaconAPI_Base
//
//  Created by jackhuali on 2021/3/2.
//  Copyright © 2021 tencent.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * WNS转发传递的参数对象
 */
@interface BeaconWnsTransferArgs : NSObject

/// 业务上报的事件的二进制内容
@property (nonatomic, strong) NSData *data;
/// 请求命令字
@property (nonatomic, strong) NSString *command;
/// 超时时间
@property (nonatomic, assign) NSUInteger timeout;
/// 客户端端重试次数
@property (nonatomic, assign) NSUInteger retryCnt;
/// 上行包是否加压
@property (nonatomic, assign) BOOL busiBufUpFlag;
/// 是否支持下行包加压
@property (nonatomic, assign) BOOL busiBufDownFlag;
/// 业务后台是否支持重入请求
@property (nonatomic, assign) BOOL isSupportReentry;
/// 是否高实时命令字
@property (nonatomic, assign) BOOL isHighRealTimeReq;
/// 业务app id
@property (nonatomic, strong) NSString *uid;
/// 事件名
@property (nonatomic, copy) NSString *eventCode;
/// 应用id
@property (nonatomic, copy) NSString *appKey;
@end

NS_ASSUME_NONNULL_END
