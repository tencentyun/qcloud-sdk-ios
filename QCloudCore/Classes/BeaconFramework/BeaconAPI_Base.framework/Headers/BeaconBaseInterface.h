//
//  BeaconBaseInterface.h
//
//  Created by tencent on 16/1/19.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import "BeaconEventUploader.h"
#import "BeaconBaseInfoModel.h"

#define Beacon_CLASS_DEPRECATED_APP(versionBegin, versionDeprecated, description, ...) __attribute__((deprecated("从 "#versionDeprecated" 版本开始废弃, "#description", "#__VA_ARGS__""))) __attribute__((weak_import))
Beacon_CLASS_DEPRECATED_APP(1.0.0, 3.2.0, "推荐使用BeaconReport类")
@interface BeaconBaseInterface : NSObject

//设置appKey（灯塔事件），启动灯塔SDK
+ (void)setAppKey:(NSString *)appKey;

//1 fetal 2 error 3 warn 4 info
//in debug version: 5 debug 10 all
+ (void)setLogLevel:(int)logLevel;

//得到灯塔sdk的版本
+ (NSString *)getSDKVersion;

//打开事件上报功能的开关
+ (BOOL)enableEventRecord:(BOOL)enable;

//实时用户事件上报通用接口，该接口会保存用户事件实时上报
//event 事件名称 isSucceed 事件执行是否成功 elapse 事件执行耗时，单位ms size 上报包大小，单位kb params 其他参数，用户自定义
+ (BOOL)onDirectUserAction: (NSString *)eventName isSucceed:(BOOL)isSucceed elapse:(long)elapse size:(long)size params:(NSDictionary *)params;
+ (BOOL)onDirectUserAction: (NSString *)eventName isImmediately:(BOOL)isImmediately isSucceed:(BOOL)isSucceed elapse:(long)elapse size:(long)size params:(NSDictionary *)params;

+ (BOOL)onDirectUserActionToTunnel:(NSString *)appKey eventName:(NSString *)eventName isSucceed:(BOOL)isSucceed elapse:(long)elapse size:(long)size params:(NSDictionary *)params;
+ (BOOL)onDirectUserActionToTunnel:(NSString *)appKey eventName:(NSString *)eventName isImmediately:(BOOL)isImmediately isSucceed:(BOOL)isSucceed elapse:(long)elapse size:(long)size params:(NSDictionary *)params;

//用户事件上报通用接口，该接口会保存用户事件到本地，根据上报策略择机上报
//event 事件名称 isSucceed 事件执行是否成功 elapse 事件执行耗时，单位ms size 上报包大小，单位kb params 其他参数，用户自定义
+ (BOOL)onUserAction:(NSString *)eventName isSucceed:(BOOL)isSucceed elapse:(long)elapse size:(long)size params:(NSDictionary *)params;
+ (BOOL)onUserAction: (NSString*) eventName isSucceed:(BOOL) isSucceed elapse:(long) elapse size:(long) size params:(NSDictionary *) params isOnlyWifiUpload:(BOOL)isOnlyWifiUpload;

+ (BOOL)onUserActionToTunnel:(NSString *)appKey eventName:(NSString *)eventName  isSucceed:(BOOL)isSucceed elapse:(long)elapse size:(long)size params:(NSDictionary *)params;
+ (BOOL)onUserActionToTunnel:(NSString *)appKey eventName:(NSString *)eventName isSucceed:(BOOL) isSucceed elapse:(long) elapse size:(long) size params:(NSDictionary *) params isOnlyWifiUpload:(BOOL)isOnlyWifiUpload;

// 大同SDK 专属接口 其他三方禁止调用
+ (BOOL)onDTDirectUserAction: (NSString *)eventName isSucceed:(BOOL)isSucceed elapse:(long)elapse size:(long)size params:(NSDictionary *)params;
+ (BOOL)onDTDirectUserAction: (NSString *)eventName isImmediately:(BOOL)isImmediately isSucceed:(BOOL)isSucceed elapse:(long)elapse size:(long)size params:(NSDictionary *)params;
/// 大同多通道上报接口
+ (BOOL)onDTDirectUserActionToTunnel:(NSString *)appKey eventName: (NSString *)eventName isSucceed:(BOOL)isSucceed elapse:(long)elapse size:(long)size params:(NSDictionary *)params;
+ (BOOL)onDTDirectUserActionToTunnel:(NSString *)appKey eventName: (NSString *)eventName isImmediately:(BOOL)isImmediately isSucceed:(BOOL)isSucceed elapse:(long)elapse size:(long)size params:(NSDictionary *)params;

//设置实时事件上报的间隔,默认为5s,单位是秒  保护区间<=60 >＝1
+ (void)setUserRealEventDurationSecond:(int)seconds;

//设置实时事件每次上报的最大上报条数, 默认为24，保护区间<=50 >＝1
+ (BOOL)setRealTimeEventUploaMaxCount:(int)maxPkgSize;

//为通道设置userId
+ (void)setUserIdToTunnel:(NSString *)appKey userId:(NSString *)userId;

//为主通道设置渠道
+ (void)setChannelIdToTunnel:(NSString *)appKey channelId:(NSString *)channelId;

//设置一个GUID的标识,用以通过GUID标识和分类异常用户信息
+ (void)setGUID:(NSString *)guid;

//更换用户时设置userId
+ (void)setUserId:(NSString *)userId;

//当第一次安装 ,第一次启动时有可能获取不到,返回A3
+ (NSString *)getQIMEI;

//当第一次安装 ,第一次启动时有可能获取不到,返回A153
+ (NSString *)getQimeiNew;

//当第一次安装 ,第一次启动时有可能获取不到, 按key返回（可能为空）
+ (NSString *)getQimeiWithKey:(NSString *)key;

//如果本地没有缓存, 则请求网络获取,同getQIMEI,由于接口设计问题请不要重复调用,回调时间取决于网络请求时间
+ (void)getQIMEIwithBlock:(void (^)(NSString * qimei)) block;

//打开海外版本,需要在初始化之前设置,默认关闭
+ (void)enableAbroad:(BOOL)enalbe;

//sessionid 设置sessionid可以帮您区分哪些事件属于同一次会话
+ (void)setSessionid:(NSString *)sessionid;

+ (NSString *)getSessionid;

//设置omgId
+ (void)setOmgId:(NSString *)omgId;

//设置渠道（灯塔事件）
+ (void)setChannelId:(NSString*)chanId;

//设置appVersion
+ (void)setAppVersion:(NSString *)bundleVer;

+ (void)setGatewayIp:(NSString *)gateWayIp;

//设置事件上报的最大累计上报条数（满足条数即上报)，及本地数据库的最大容量（超过限额不予存储）
//默认分别为20 10000，保护区间10～100, 100～10000
//注意：采用默认调用方式，sdk会在与服务器通讯获取策略后更新本地策略，所以该模式下调用该API无效
+ (BOOL)setStrategyForMaxPkgSize:(int)maxPkgSize dbMaxSize:(int)dbMaxSize;

//登录事件
+ (BOOL)onLogin: (BOOL) isSucceed elapse:(long) elapse size:(long) size params:(NSDictionary *) params;
//上传图片事件
+ (BOOL)onUploadPicture: (BOOL) isSucceed elapse:(long) elapse size:(long) size params:(NSDictionary *) params;
//写日志事件
+ (BOOL)onWriteBlog: (BOOL) isSucceed elapse:(long) elapse size:(long) size params:(NSDictionary *) params;

//启动事件
+ (BOOL)onStart: (BOOL) isSucceed elapse:(long) elapse size:(long) size params:(NSDictionary *) params;
//写操作
+ (BOOL)onWrite: (BOOL) isSucceed elapse:(long) elapse size:(long) size params:(NSDictionary *) params;
//刷新操作
+ (BOOL)onRefresh: (BOOL) isSucceed elapse:(long) elapse size:(long) size params:(NSDictionary *) params;
//界面渲染
+ (BOOL)onRender: (BOOL) isSucceed elapse:(long) elapse size:(long) size params:(NSDictionary *) params;

/**
 主通道的通用参数, 设置所有事件都会带的参数
 **/
+ (void)setAdditionalInfo:(NSDictionary *)dic;

+ (BeaconEventUploader *)getMixDataUploader;

/**
 提供一个Model存放所有灯塔已默认采集的公参
 **/
+ (BeaconBaseInfoModel *)getCommonParams;

//2.3.4
/**
 * 事件接口总开关
 * @param isEventUpOnOff 默认为YES
 */
+ (void)setEventUpOnOff:(BOOL)isEventUpOnOff;

/**
 * 设置严苛模式用于上线前排查问题, 严苛模式下SDK会主动触发crash, 默认关闭,上线请务必关闭!!!!!!!!!!!
 */
+ (void)setStrictModeOnOff:(BOOL)yesOrNo;


#pragma mark -- 已废弃的无效接口
//sdk的状态，未开启，初始化中，初始化完成，与服务器同步完成，错误
typedef enum {
    notenabled, initialing, initialed, syncedwithserver, initerror
} sdkstatus;

//获取当前sdk的运行状态
+ (sdkstatus)getSDKStatus;

//设置sdk进行与服务器同步的延时（初次启动不会有延时，如果上次发生crash也不会延迟）
//主要是控制sdk在启动过程中占用更多资源
+ (void)setSynchServerTimerDelay:(int)delay;

//注册监控服务，将会向服务器查询策略，并初始化各个模块的默认数据上传器，参数userId为用户qua，参数gateWayIP为当前网络网关IP，不填则默认使用服务器下发的IP
+ (BOOL)enableAnalytics:(NSString *)userId gatewayIP:(NSString *)gatewayIP;

+ (BOOL)enableAnalyticsWithoutNetwork:(NSString *)userId gatewayIP:(NSString *)gatewayIP;

//注册通道
+ (void)registerTunnel:(NSString *)appKey userId:(NSString *)userId channelId:(NSString *)channelId appVersion:(NSString *)appVersion;

//为通道设置app版本
+ (void)setAppVersionToTunnel:(NSString *)appKey appVersion:(NSString *)appVersion;

//该开关为YES的时候会在本地策略生效的时候就开启功能开关（测速／异常），等服务器策略生效后再更新一次
//如果为NO那么会等到服务器策略生效后才开启功能开关
//影响范围：服务器策略生效之前的事件记录和异常处理函数的问题注册
+ (BOOL)enableModuleFunctionBeforeSeverStrategy:(BOOL)enable;

/**
 测试接口，只在Test的模式下生效
 **/
// 这是控查询serverUlr
+ (BOOL)setAnalyticsServer:(NSString *)serverUrl;

//开启和关闭灯塔上报（包括属性采集／启动上报／退出事件／使用状况上报）
+ (BOOL)setEnableReport:(BOOL)enabled;

//1.8.4
/**
 * wifi上报控制
 */
+ (void)isOnlyWifiUpload:(BOOL)yesOrNo;

/**
 * 临时关掉灯塔上报, 达到上报条件的事件先存数据库
 */
+ (void)setEventUploadClose:(BOOL)isClose;

// 1.9.0实时联调测试功能
+ (void)setAccessTest:(BOOL)yesOrNo;

/**
 * 业务事件接口开关
 * @param isBizEventUpload 默认为YES
 */
+ (void)setBizEventUpload:(BOOL)isBizEventUpload;

/**
 * 路径分析功能开启/关闭接口，默认关闭此功能
 */
+ (void)enablePagePath:(BOOL)yesOrNo;

/**
 * Socket上报开启/关闭接口，默认开启
 */
+ (void)setSocketOnOff:(BOOL)yesOrNo;

/**
 * 进入页面跟踪，在viewWillAppear或viewDidAppear方法里调用此方法
 */
+ (void)onPageBegin:(NSString *)pageName;

/**
 * 离开页面跟踪，在viewWillDisappear或viewDidDisappear方法里调用此方法
 */
+ (void)onPageEnd:(NSString *)pageName;


@end
