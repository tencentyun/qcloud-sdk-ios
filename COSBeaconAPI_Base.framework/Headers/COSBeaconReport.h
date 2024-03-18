//
//  COSBeacon.h
//  COSBeaconAPI_Base
//
//  Created by jackhuali on 2020/4/6.
//  Copyright © 2020 tencent.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "COSBeaconResult.h"
#import "COSBeaconEvent.h"
#import "COSBeaconBaseInfoModel.h"
#import <QimeiSDK/QimeiSDK.h> 
#import "COSBeaconReportConfig.h"
#import "COSBeaconQUICArgs.h"
#import "COSBeaconMsfSendArgs.h"
#import "COSBeaconCallBackManager.h"
NS_ASSUME_NONNULL_BEGIN


typedef void (^COSBeaconQUICCallback)(COSBeaconQUICArgs *args, COSBeaconQUICResult *result);

typedef void (^COSBeaconMsfSendCallback)(COSBeaconMsfSendResult *beaconResult);
/**
  长连接网络数据传输的适配协议(可选):当业务对灯塔上报数据实时性有要求时,可开启长连接上报功能.
  开启此功能需要业务集成TQUIC SDK. 初始化TQUIC SDK并实现TUQIC SDK数据传输的代理接口.
 */
@protocol COSBeaconTransferProtocal <NSObject>
@optional
/// QUIC 数据传输的代理接口
- (void)transferArgs:(COSBeaconQUICArgs *)args
            delegate:(COSBeaconQUICCallback)callBack;

/**
 * MSFSDK数据传输的代理接口
 * callbackManager: 回调管理类. 收到msf回调后,接入层可以通过COSBeaconCallBackManager单例对象,直接调用callBackSendResult回传结果.4.1.36版本msfSDK 是通过代理回调结果,为了简化接入层逻辑,所以这里构建了COSBeaconCallBackManager中间层.
 * return: sequenceId. 接入层需要保证sequenceId合法,非法id(如:0,nil,NULL)灯塔会拦截走原通道, 非法情况下继续调 MSF,有可能造成数据重复.
 */
- (NSInteger)sendArgs:(COSBeaconMsfSendArgs *)beaconArgs callback:(COSBeaconCallBackManager *)callbackManager;


@end

/// COSBeaconMttProtocal穿上甲日志协议
@protocol COSBeaconMttProtocal <NSObject>
- (void)mttLog:(NSString *)message
          file:(const char *)file
      function:(const char *)function
          line:(NSUInteger)line
      threadID:(NSInteger)threadID
        module:(NSString *)module
        folder:(int)folder level:(int)level;

@end

extern BOOL COSBeaconHasStarted;

/**
  上报模块的接口类:提供SDK对外API
 */
@interface COSBeaconReport : NSObject

/// 原来使用的设备标识符，通过OMGID SDK获取
@property (copy, nullable) NSString *omgId;

/// 渠道ID
@property (copy, nullable) NSString *channelId;

/// 是否开启严苛模式，默认为NO，严苛模式开启时用于上线前排查问题, SDK会主动触发crash, 上线务必关闭!!!
@property (assign) BOOL strictMode;

/// 设置本地调试时控制台输出的日志级别：1 fetal, 2 error, 3 warn, 4 info, debug, 5 debug, 10 all, 默认为0，不打印日志
/// 线上正式环境，必须设置为0关闭此日志
@property (nonatomic, assign) int logLevel;

/// 是否采集WiFiMac地址，参数为NO时不采集，默认采集，如果需要关闭则需要在初始化前设置为NO
@property (assign) BOOL collectMacEnable DEPRECATED_MSG_ATTRIBUTE("4.2.74以后不再采集,如需使用请自行采集后通过[COSBeaconReport.sharedInstance setWifiName:/setWifiMac:]填充");

/// 是否采集idfa,参数为NO时不采集，默认采集，如果需要关闭则需要在初始化前设置为NO
@property (assign) BOOL collectIdfaEnable DEPRECATED_MSG_ATTRIBUTE("4.2.74以后不再采集,如需使用请自行采集后通过[COSBeaconReport.sharedInstance setIDFA:]填充");


/// 是否采集idfv，默认采集。无特殊情况不要关闭 ! 若关闭后务必在授权后填充IDFV(setIDFV:)
@property (assign) BOOL collectIdfvEnable;

/// 网络数据传输通道代理
@property (nonatomic, weak) id<COSBeaconTransferProtocal> transferDelegate;

/// 穿山甲日志代理
@property (nonatomic, weak) id<COSBeaconMttProtocal> mttDelegate;


+ (COSBeaconReport *)sharedInstance;

/**
 * 初始化接口，开启灯塔服务，会向服务器查询策略，初始化各个模块的默认数据上传器等
 * 1.宿主(应用)集成灯塔时:
 *     a:建议在didFinishLaunchingWithOptions中最早位置调用灯塔,避免其他组件SDK提前初始化灯塔而引起数据错误问题.
 *     b:应用中多份组件SDK同时使用灯塔,强烈建议配置COSBeaconInfo.plist文件记录beacon_main_appkey,
 *       配置后灯塔初始化以配置文件为准,所以务必确保配置文件appkey正确!! 非必要情况不要修改配置文件!!
 * 2.二方(中台,组件)SDK集成灯塔:
 *     a:使用公版灯塔(和宿主共用)情况下, 禁止调用此方法!!!
 *     b:使用前缀版本灯塔情况下,需要调用此方法. 通常一个二方SDK业务对应一份前缀版本灯塔,彼此是相互隔离.
 * @param appKey 各业务在灯塔平台申请的业务唯一标识
 * @param config 全局配置，可配置一些开关和策略等
 */
- (void)startWithAppkey:(NSString *)appKey config:(nullable COSBeaconReportConfig *)config;

/// 上报事件
/// @param event 事件，包括所有用户行为事件、APP启动事件等，事件的具体定义参考COSBeaconEvent模型类
/// @return 返回事件上报结果，此同步返回的结果只代表事件符合上报要求，可以进行上报，
///         但不一定代表事件当前已成功上报到服务端，有可能存在事件在本地缓存并等待上报等情况
- (COSBeaconReportResult *)reportEvent:(COSBeaconEvent *)event;

/// 给指定的appKey设置附加参数，此appKey的所有事件都会带上这些参数
/// @param additionalParams 附加参数
/// @param appKey 各业务在灯塔平台申请的业务唯一标识
/// @return 返回设置参数结果,参数非法将返回NO, 设置成功返回 YES. (参数类型要求是:NSNumber 和 NSString)
- (BOOL)setAdditionalParams:(NSDictionary *)additionalParams forAppKey:(NSString *)appKey;

/// 用户设置抽样事件，根据appkey和eventCode进行抽样
/// @param appkey 多通道
/// @param sampleEventDict key是事件名(EventCode),value是抽样比例的分子，分母固定10000，分子区分范围:0~10000.
/// 比如，输入1代表抽样留万分之一，输入10代表抽样留千分之一,输入0为不上报
/// @return 返回设置抽样配置结果,参数非法将返回NO, 设置成功返回 YES
- (BOOL)setUserSampleEvents:(NSDictionary<NSString *, NSNumber *> *)sampleEventDict forAppKey:(NSString *)appkey;

/// 给指定的appKey设置userId
/// @param userId 用户唯一标识符
/// @param appKey 各业务在灯塔平台申请的业务唯一标识
- (void)setUserId:(NSString *)userId forAppKey:(NSString *)appKey;

/// 给指定的appKey设置openid
/// @param openId 小程序、H5设置的开放平台的id
/// @param appKey 各业务在灯塔平台申请的业务唯一标识
- (void)setOpenId:(NSString *)openId forAppKey:(NSString *)appKey;


/// 同步获取对应appkey的qimei,可以在未初始化灯塔前调用
- (nullable QimeiContent *)getQimeiForAppKey:(NSString *)appKey;

/// 异步获取对应appkey的qimei，可以在未初始化灯塔前调用
- (void)getQimeiWithBlock:(void (^)(QimeiContent * _Nullable qimei))block forAppKey:(NSString *)appkey;


/// 默认不采集idfa,由需采集idfa的应用宿主填充.
- (void)setIDFA:(NSString *)idfa;

/// 默认采集IDFV,业务如有关闭IDFV,用户同意隐私采集后,需填充给灯塔
- (void)setIDFV:(NSString *)idfv;

/// 设置wifiName. 用户授权隐私数据采集后,可统一采集后填充到灯塔
- (void)setWifiName:(NSString *)wifiName;

/// 设置wifiMac. 用户授权隐私数据采集后,可统一采集后填充到灯塔
- (void)setWifiMac:(NSString *)wifiMac;


/// 获取所有灯塔已默认采集的公参
- (COSBeaconBaseInfoModel *)getCommonParams;

///Socket上报开启/关闭接口，默认YES，如果需要关闭则需要设置为NO
- (void)setSocketOnOff:(BOOL)yesOrNo;

@end

NS_ASSUME_NONNULL_END

#define BEACON_SDK_VERSION @"4.2.76.50"