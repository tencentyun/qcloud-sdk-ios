//
//  BeaconBaseInfoModel.h
//  BeaconAPI_Base
//
//  Created by jackhuali on 2020/4/14.
//  Copyright © 2020 tencent.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeaconQimei.h"
#import "BeaconReportConfig.h"

typedef enum : NSInteger { BeaconNotReachable = 0, BeaconReachableViaWiFi, BeaconReachableViaWWAN, BeaconReachableUnknow } BeaconNetworkStatus;

@class BeaconLocalConfig;

NS_ASSUME_NONNULL_BEGIN

/// 灯塔SDK采集的公共基础信息
/// 存储在单例里的属性，在多线程，采用atomic控制线程同步，重写set/get方法的属性需手动控制同步，不同步的属性在多线程时可能引起crash或计算结果不是预期的
@interface BeaconBaseInfoModel : NSObject

/// 主App的appKey
@property (copy) NSString *mainAppKey;
@property (strong) BeaconReportConfig *config;
/// 缓存各appKey的的附加参数，以通道的appKey作为key进行缓存
@property (copy) NSMutableDictionary<NSString *, NSDictionary *> *additionalInfoDict;
/// 缓存各appKet的的userId，以通道的appKey作为key进行缓存
@property (copy) NSMutableDictionary<NSString *, NSString *> *userIdDict;

// qimei相关
@property (nonatomic, strong, readonly) BeaconQimei *qimei;
@property (nonatomic, copy, readonly) NSString *qimeiOld;
@property (nonatomic, copy, readonly) NSString *qimeiNew;
@property (nonatomic, copy) NSString *qimeiJson;

// bundle相关
@property (copy, readonly) NSString *bundleId;
@property (assign, readonly) int platformId;
@property (copy) NSString *gatewayIP;
@property (copy, readonly) NSString *hardwareModel;
@property (copy, readonly) NSString *country;
@property (copy, readonly) NSString *language;
@property (assign, readonly) long long romSize;
@property (copy, readonly) NSString *openUdid;
@property (copy, readonly) NSString *idfv;
@property (copy, readonly) NSString *idfa;
@property (assign, readonly) BOOL isReet;
/// 主通道的channelId
@property (copy) NSString *channelId;
/// 分辨率
@property (copy, readonly) NSString *resolution;
@property (copy) NSString *sessionId;

/// 缓存服务端返回的sId，请求时带上，给服务端从缓存取解密后的密钥
@property (copy) NSString *sId;

// 版本相关
@property (copy) NSString *appVersion;
@property (copy, readonly) NSString *sdkVersion;
@property (copy, readonly) NSString *osVer;
@property (assign, readonly) float osVerFloat;
/// 是否纯新增用户，纯新增用户的定义是首次在某台设备上安装APP，卸载重装的不算纯新增
@property (assign) BOOL isnew;
/// 是否版本新增用户
@property (assign) BOOL isNewWithVer;
@property (assign, readonly) BOOL versionChanged;
@property (assign, readonly) BOOL sdkVersionChanged;

// 网络相关
@property (copy, nullable) NSString *wifiName;
@property (copy, readonly) NSString *imsi;
@property (copy, nullable) NSString *wifiMac;
/// 终端获取的APN信息(cmwap、cmnet等)
@property (copy) NSString *apn;
@property (assign) BeaconNetworkStatus currentNetStatus;
/// all_ssid
@property (copy, readonly) NSString *wlanDevices;

/// APP或者此SDK在运行过程中的一些运行时参数的模型类
@property (strong) BeaconLocalConfig *localConfig;
@property (assign) BOOL isBackground;
@property (assign, readonly) BOOL isSimulator;
/// 是否冷启动
@property (assign) BOOL isCold;
@property (copy) NSString *launchSource;
@property (copy, readonly) NSString *deviceName;
@property (copy, readonly) NSString *deviceModel;
@property (copy, readonly) NSString *deviceType;
@property (copy, readonly) NSString *battery;

@property (copy) NSString *aesKey;
@property (copy, readonly) NSString *aesKeyEncrypt;
/// 与服务器进行时钟同步的时间差
@property (nonatomic, assign) long serverTimeDelta;
/// app安装时间
@property (assign, readonly) long long appInstallTime;

// 延迟初始化相关需要耗时的参数，需在子线程调用
- (void)initBaseInfo;

@end

NS_ASSUME_NONNULL_END
