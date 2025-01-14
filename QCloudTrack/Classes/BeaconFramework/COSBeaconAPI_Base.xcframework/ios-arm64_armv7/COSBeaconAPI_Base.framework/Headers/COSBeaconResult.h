//
//  COSBeaconResult.h
//  COSBeaconAPI_Base
//
//  Created by jackhuali on 2020/4/6.
//  Copyright © 2020 tencent.com. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, COSBeaconResultType) {
    COSBeaconResultTypeSuccess = 0,                // 成功
    COSBeaconResultTypeIllegalParameters,          // 参数非法，一般是接口入参校验不通过
    COSBeaconResultTypeConfigOff,                  // 配置关闭，导致上报失败或者不需要上报
    COSBeaconResultTypeParamsExceededLength,       // 参数长度过长
    COSBeaconResultTypeSDKNotStarted,              // SDK未初始化就进行上报
    COSBeaconResultTypeUnknow,                     // 未知错误
};
/**
  COSBeaconBaseResult:基础结果类
 */
@interface COSBeaconBaseResult : NSObject

/// 上报结果的状态类型，此结果类型一般只代表事件在本地校验的结果，不一定代表事件成功上报到服务端
@property (nonatomic, assign) COSBeaconResultType type;

/// 具体错误信息，成功时为空
@property (nonatomic, copy) NSString *errorMessage;

/// 事件ID,实时和普通事件的id分开计算，有可能相同
@property (nonatomic, copy) NSString *eventId;

@end

/**
  COSBeaconReportResult:上报事件结果类
 */
@interface COSBeaconReportResult : COSBeaconBaseResult
@end

/**
 COSBeacon QUIC 回调参数对象
 */
@interface COSBeaconQUICResult : NSObject

@property(nonatomic, strong) NSURLResponse * _Nonnull response;

@property(nonatomic, strong) id  _Nonnull responseObject;

@property(nonatomic, strong) NSError * _Nonnull error;

@end

/**
  MSFSDK 发送数据结果回调: 0 代表成功 非零则是对应错误码
 */
@interface COSBeaconMsfSendResult : NSObject
/// sequenceId
@property(nonatomic, assign)  NSInteger sequenceId;
/// 发送状态码
@property(nonatomic, assign)  NSInteger sendCode;
/// 发送错误信息
@property(nonatomic, copy)  NSString  *sendMsg;


@end



NS_ASSUME_NONNULL_END
