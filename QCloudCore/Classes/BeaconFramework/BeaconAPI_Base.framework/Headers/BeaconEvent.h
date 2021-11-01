//
//  BeaconEvent.h
//  BeaconAPI_Base
//
//  Created by jackhuali on 2020/4/6.
//  Copyright © 2020 tencent.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 事件类型
typedef NS_ENUM(NSInteger, BeaconEventType) {
    BeaconEventTypeNormal,                      // 普通事件
    BeaconEventTypeRealTime,                    // 实时事件
    BeaconEventTypeDTNormal,                    // 普通的大同事件，大同SDK业务专用
    BeaconEventTypeDTRealTime,                  // 实时的大同事件，大同SDK业务专用
};

/**
  事件(model)类:业务方通过BeaconEvent对象封装事件各种参数
 */
@interface BeaconEvent : NSObject

/// 事件上报的归属appkey，如果不设置，则默认是start初始化接口设置的appkey
/// ！！！为明确上报到哪个appkey，推荐接入方都主动设置自己的appkey
@property (nonatomic, copy, nullable) NSString *appKey;

/// 事件标识code,接入方设置的对事件的唯一标识，后续数据分析可以通过事件code区分事件，
/// 如'APP启动事件'可定义code为：app_launch，'首页页面曝光事件'可定义为：homepage_exposure
@property (nonatomic, copy) NSString *code;

/// 事件类型,默认是普通事件
@property (nonatomic, assign) BeaconEventType type;

/// 事件是否执行成功,默认YES
@property (nonatomic, assign) BOOL success DEPRECATED_MSG_ATTRIBUTE("在4.0+版本已废弃，可不设置");

/// 事件的自定义参数，key和value类型要求是NSString或者NSNumber类型，使用其他类型的事件不会上报
/// 单个value的长度最大为10k，超出10k部分会被截断后上报，所有value长度之和最大为45k，超过45k不会上报此条事件
@property (nonatomic, strong, nullable) NSDictionary *params;

/// 标记事件是否是qimei为空的补报事件
@property (nonatomic, assign) BOOL reportAgainAfterQimeiNotNull;


/// 实时事件的构造函数
/// @param code 事件标识code
/// @param params 事件的自定义参数
+ (instancetype)realTimeEventWithCode:(NSString *)code params:(nullable NSDictionary *)params;

/// 普通事件的构造函数
/// @param code 事件标识code
/// @param params 事件的自定义参数
+ (instancetype)normalEventWithCode:(NSString *)code params:(nullable NSDictionary *)params;

/// 构造函数，兼容老版本的事件初始化
/// @param appKey 各业务在灯塔平台申请的业务唯一标识
/// @param code 事件标识code
/// @param type 事件类型
/// @param success 事件是否执行成功
/// @param params 事件的自定义参数
- (instancetype)initWithAppKey:(nullable NSString *)appKey
                code:(NSString *)code
                type:(BeaconEventType)type
             success:(BOOL)success
              params:(nullable NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
