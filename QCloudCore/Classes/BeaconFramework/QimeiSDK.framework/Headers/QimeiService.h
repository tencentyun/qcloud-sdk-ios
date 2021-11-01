//
//  QimeiService.h
//  QimeiSDK
//
//  Created by pariszhao on 2020/9/24.
//  Copyright © 2020 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QimeiContent.h"
#import "QimeiServiceConfig.h"

NS_ASSUME_NONNULL_BEGIN

//获取Qimei的入口类
@interface QimeiService : NSObject

//标记service是否被初始化
@property (nonatomic, assign, readonly) BOOL hasStart;

+ (instancetype)serviceWithAppkey:(NSString *)appkey;

//debug打开可以打印更多信息，建议只是debug模式下开启
- (void)setDebugMode:(BOOL)debug;

//设置userid，userid类型可自定义 QQ/GUID/OMGID等, 可调用多次，设置多个账号
- (void)setUserId:(NSString *)userId forType:(NSString *)type;

//设置渠道号
- (void)setChannelId:(NSString *)channelId;

//设置appVersion,业务不设置的话，sdk内部会自己采集
- (void)setAppVersion:(NSString *)appVersion;

//设置log打印,建议都接入自己的log日志中，方便定位问题
- (void)setLogBlock:(void(^)(NSString *msg))logBlock;

/*
 设置配置，可以关闭采集的字段idfa/idfv/uuid
 */
- (void)setConfig:(QimeiServiceConfig *)config;

/*
 初始化接口，调用该接口前完成channelId,userId等的设置工作
 */
- (void)start;

/*
 同步获取qimei，里面的内容(qimeiold/qimeinew)可能为空
 */
- (nullable QimeiContent *)getQimei;

/*
 异步获取qimei，如果本地没有则等待网络请求的回调，针对的是APP首次安装本地没有qimei的场景。
 ！！！只建议在APP启动阶段调用一次本异步接口，其余阶段使用同步接口获取qimei
 */
- (void)getQimeiWithBlock:(void(^_Nullable)(QimeiContent *_Nullable qimei))qimeiBlock;

/*
 only for 灯塔
 */
- (nullable NSString *)getBeaconTicket;

/*
 背景：在第一次启动app时，因为生成qimei需要网络，此时还没有qimei，但是部分网络接口需要使用到。
 使用：携带该token到server，server传token给qimei的server可以换取一个qimei。
 */
- (NSString *)getToken;

/*
 仅sdk需要设置
 */
- (void)setSdkName:(NSString *)sdkName;

//获取SDK版本号
- (nonnull NSString *)sdkVersion;

@end

NS_ASSUME_NONNULL_END

