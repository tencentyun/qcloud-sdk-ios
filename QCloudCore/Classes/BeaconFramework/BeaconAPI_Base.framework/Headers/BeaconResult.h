//
//  BeaconResult.h
//  BeaconAPI_Base
//
//  Created by jackhuali on 2020/4/6.
//  Copyright © 2020 tencent.com. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, BeaconResultType) {
    BeaconResultTypeSuccess = 0,                // 成功
    BeaconResultTypeIllegalParameters,          // 参数非法，一般是接口入参校验不通过
    BeaconResultTypeConfigOff,                  // 配置关闭，导致上报失败或者不需要上报
    BeaconResultTypeParamsExceededLength,       // 参数长度过长
    BeaconResultTypeSDKNotStarted,              // SDK未初始化就进行上报
    BeaconResultTypeUnknow,                     // 未知错误
};
/**
  BeaconBaseResult:基础结果类
 */
@interface BeaconBaseResult : NSObject

/// 上报结果的状态类型，此结果类型一般只代表事件在本地校验的结果，不一定代表事件成功上报到服务端
@property (nonatomic, assign) BeaconResultType type;

/// 具体错误信息，成功时为空
@property (nonatomic, copy) NSString *errorMessage;

/// 事件ID,实时和普通事件的id分开计算，有可能相同
@property (nonatomic, copy) NSString *eventId;

@end

/**
  BeaconReportResult:上报事件结果类
 */
@interface BeaconReportResult : BeaconBaseResult
@end

/**
 BeaconWnsTransferResult:msf回调灯塔的参数对象
 */
@interface BeaconWnsTransferResult : NSObject

/// 客户端层返回码
@property(nonatomic, assign)  NSInteger     sdkCode;
/// 后台返回码
@property(nonatomic, assign)  NSInteger     wnsCode;
/// 业务层返回码
@property(nonatomic, assign)  NSInteger     bizCode;
/// 业务层返回数据
@property(nonatomic, strong)  NSData*       bizBuffer;
/// 异常错误信息
@property(nonatomic, strong)  NSString*     bizMsg;

@end

/**
  MSFSDK 发送数据结果回调: 0 代表成功 非零则是对应错误码
 */
@interface BeaconMsfSendResult : NSObject
/// sequenceId
@property(nonatomic, assign)  NSInteger sequenceId;
/// 发送状态码
@property(nonatomic, assign)  NSInteger sendCode;
/// 发送错误信息
@property(nonatomic, assign)  NSString  *sendMsg;

@end



NS_ASSUME_NONNULL_END
