#import <Foundation/Foundation.h>

#define KEEP_CLASS_AVAILABLE NS_CLASS_AVAILABLE(10_11, 9_0)

NS_ASSUME_NONNULL_BEGIN

/// TODO 是否删除
KEEP_CLASS_AVAILABLE
@protocol reportProtocol <NSObject>
/// @brief 上报接口
/// @param event event
/// @param reportInfo 上报的信息
- (void)report: (NSString*)appkey
         event:(NSString*)event
         param:(NSDictionary*)reportInfo;

/// @brief 获取 qimei
/// @param appkey 灯塔appkey
/// @return 返回灯塔Qimei36
- (NSString*)getQimei36: (NSString*)appkey;
@end

KEEP_CLASS_AVAILABLE
@interface CKeyInfo : NSObject
// 加密后数据
@property (nonatomic, copy) NSString *data;
// ckey
@property (nonatomic, copy) NSString *ckey;
@end

// vsckey 旧版本接口
KEEP_CLASS_AVAILABLE
@interface ckey_lib : NSObject

// reportProtocol接口调用业务实现的getQimei和上报接口
@property (nonatomic,weak) id <reportProtocol> reportDelegate;

/// 单实例
+ (instancetype)sharedInstance;

/// @brief 初始化 ckey 接口
/// @param delegate 上报协议, 当前不使用
/// @param guid 业务guid
/// @param vsAppKey 具体业务 key，需要在 http://wp.pcg.com/#/apps/service/00000000/db/platform?platformid=530603 申请
/// @return 初始化成功返回 YES，否则为 NO
- (BOOL)initCkeyLib : (id<reportProtocol>)delegate
               guid : (NSString*)guid
            vsAppkey: (NSString*)vsAppKey;

/// @brief 获取 ckey 库版本
- (NSString *)getSoVersion;

/// @brief 添加多 vsappkey 可以通过多次初始化或使用 addVsAppKey
/// @param vsAppKey 具体业务key，需要在http://wp.pcg.com/#/apps/service/00000000/db/platform?platformid=530603申请
/// @return 添加成功返回 YES，否则为 NO
- (BOOL) addVsAppKey : (NSString*)vsAppKey;

/// @brief 传入 base64 后的加密数据, 双清单解密算法
/// @return 返回解密数据
- (NSString *)decrypt : (NSString*)data;

/// @brief 双清单加密, data 为明文字符串
- (NSString *)encrypt : (NSString *)data;

/// @brief 使用公钥解密数据
/// @param cipher base64 字符串
/// @param pubkey 公钥, der 格式
/// @return 返回解密结果
+ (NSData *)decryptRSA : (NSString *)cipher pubkey:(NSString *)pubkey;

/// @brief 签名接口
/// @param userID 用户 ID
/// @param moudleID 模块 ID
/// @param salt 待签名数据
/// @param saltsz 待签名数据长度
/// @return 返回签名结果， 可见字符
+ (NSMutableData*)signWith:(NSString *)userID
                  moudleID:(NSString *)moudleID
                      salt:(void*)salt
                    saltsz:(int)saltsz;

/// @brief 协议签名接口
/// @param userID 用户账号或者 ID
/// @param moudleID 模块ID, 用于区分业务使用场景
/// @param salt 待签名数据
/// @param saltsz 待签名数据长度
/// @return 返回签名数据可见数据
+ (NSString*)strSignWith:(NSString *)userID
                moudleID:(NSString *)moudleID
                    salt:(void*)salt
                  saltsz:(int)saltsz;

/// @brief 轻签名
/// @param salt 待签名数据
/// @param saltsz 待签名数据长度
/// @return 返回签名数据不可见字符
+ (NSMutableData *)lwsign:(void*)salt
                   saltsz:(unsigned)saltsz;

/// @brief 轻签名
/// @param salt 待签名数据
/// @param saltsz 待签名数据长度
/// @return 返回签名数据可见数据
+ (NSString *)strLwsign:(void*)salt
                 saltsz:(unsigned)saltsz;

/// @brief 获取 token, 当前无用, 直接返回 "2" + guid
- (NSString*) getToken : (NSString*) guid
              platForm : (int)platForm
             strappVer : (NSString*) strappVer;

/// @brief 获取本地 token, 当前无用, 直接返回 "2" + guid
- (NSString *)getLocalToken:(NSString*) guid;

/// @brief 获取 ckey v3 接口
/// @param strToken token
/// @param unPlatform 平台 ID, 需要申请
/// @param unEncVer 加密版本
/// @param strappVer 业务版本
/// @param strAppKey app key
/// @param strvid 视频 vid
/// @param sdtFrom 申请的 sdtfrom
/// @param strRandflag 非必须, 可空
/// @param strBundleID bundle id
/// @param strGuid 常规 guid(如手 Q 等)
/// @param strStkey stkey
/// @param intA 业务额外数据
/// @param ArrLen 业务额外数据长度
/// @param uTime 当前时间
/// @param deviceModel 设备 module, 上报使用
/// @param currentDevice 当前设备名称
/// @return 返回 ckey
- (NSString *)getCKey : (NSString*) strToken
           unPlatform : (int) unPlatform
             unEncVer : (int) unEncVer
            strappVer : (NSString*) strappVer
               strvid : (NSString*) strvid
                uTime : (int) uTime
            strAppKey : (NSString*) strAppKey
              sdtFrom : (NSString*) sdtFrom
          strRandflag : (NSString*) strRandflag
          strBundleID : (NSString*) strBundleID
              strGuid : (NSString*) strGuid
             strStkey : (NSString*) strStkey
                 intA : (int[_Nullable]) intA
               ArrLen : (int) ArrLen
          deviceModel : (NSString*) deviceModel
        currentDevice : (NSString*) currentDevice;

/// @brief 获取 ckey 旧接口
/// @param strToken token
/// @param unPlatform 平台 ID, 需要申请
/// @param strappVer 业务版本
/// @param strAppKey app key
/// @param strvid 视频 vid
/// @param sdtFrom 申请的 sdtfrom
/// @param strRandflag 非必须, 可空
/// @param uTime 当前时间
/// @return 返回 ckey
- (NSString *)getCKey_O : (NSString*) strToken
             unPlatform : (int) unPlatform
              strappVer : (NSString*) strappVer
                 strvid : (NSString*) strvid
              strAppKey : (NSString*) strAppKey
                sdtFrom : (NSString*) sdtFrom
            strRandflag : (NSString*) strRandflag
                  uTime : (int) uTime;

/// @brief 任务数据加密接口
/// @param seqid 请求 id
/// @param vid 视频 vid
/// @param omgid omg id
/// @param guid 常规 guid(如手 Q 等)
/// @param taskid 任务 id
/// @param type 任务类型
/// @param systemtype 系统类型
/// @param timestamp 当前时间
/// @param rand 随机数
/// @param struin 账号
/// @return 返回加密后数据
- (NSString *)getTaskEncrypt : (NSString*) seqid
                         vid : (NSString*) vid
                       omgid : (NSString*) omgid
                        guid : (NSString*) guid
                      taskid : (int) taskid
                        type : (int) type
                  systemtype : (int) systemtype
                   timestamp : (int) timestamp
                        rand : (int) rand
                      struin : (NSString*) struin;

/// @brief ckey 生成函数
/// @param unPlatform 平台号， 申请获得
/// @param unEncVer 不需要
/// @param strappVer 业务版本号
/// @param strvid 视频VID， 点播vid， 直播channelid
/// @param uTime 当前时间， 点播85 -3 、直播 32 -3 需要使用服务器时间生成ckey重试。
/// @param sdtFrom 平台号对应的dtfrom
/// @param strRandflag rand ，非必须， 无可传空
/// @param strBundleID bundleID
/// @param strGuid 业务guid，用户唯一标识
/// @param intA 视频额外字段
/// @param ArrLen 额外字段数组长度
/// @return ckey 返回ckey ， 长度大于 10 为正常，否则为错误码 ？
- (NSString *)getCKeyAll: (int) unPlatform
               unEncVer : (int) unEncVer
              strappVer : (NSString*) strappVer
                 strvid : (NSString*) strvid
                  uTime : (int) uTime
                sdtFrom : (NSString*) sdtFrom
            strRandflag : (NSString*) strRandflag
            strBundleID : (NSString*) strBundleID
                strGuid : (NSString*) strGuid
                   intA : (int[_Nullable]) intA
                 ArrLen : (int) ArrLen;

/// @brief ckey 生成函数
/// @param unPlatform 平台号， 申请获得
/// @param unEncVer 不需要
/// @param strappVer 业务版本号
/// @param strvid 视频VID， 点播vid， 直播channelid
/// @param uTime 当前时间， 点播85 -3 、直播 32 -3 需要使用服务器时间生成ckey重试。
/// @param sdtFrom 平台号对应的dtfrom
/// @param strRandflag rand ，非必须， 无可传空
/// @param strBundleID bundleID
/// @param strGuid 业务guid，用户唯一标识
/// @param intA 视频额外字段
/// @param ArrLen 额外字段数组长度
/// @param strBusJson 额外数据
/// @return ckey 返回ckey ， 长度大于 10 为正常，否则为错误码 ？
- (NSString *)getCKeyAll: (int) unPlatform
               unEncVer : (int) unEncVer
              strappVer : (NSString*) strappVer
                 strvid : (NSString*) strvid
                  uTime : (int) uTime
                sdtFrom : (NSString*) sdtFrom
            strRandflag : (NSString*) strRandflag
            strBundleID : (NSString*) strBundleID
                strGuid : (NSString*) strGuid
                   intA : (int[_Nullable]) intA
                 ArrLen : (int) ArrLen
                busJson : (NSString *) strBusJson;

/// @brief ckey 生成函数, 可附加 post 数据, 用于签名校验
/// @param unPlatform 平台号， 申请获得
/// @param unEncVer 不需要
/// @param strappVer 业务版本号
/// @param strvid 视频VID， 点播vid， 直播channelid
/// @param uTime 当前时间， 点播85 -3 、直播 32 -3 需要使用服务器时间生成ckey重试。
/// @param sdtFrom 平台号对应的dtfrom
/// @param strRandflag rand ，非必须， 无可传空
/// @param strBundleID bundleID
/// @param strGuid 业务guid，用户唯一标识
/// @param intA 视频额外字段
/// @param ArrLen 额外字段数组长度
/// @param strBusJson 额外数据
/// @param postData 发送 ckey 时待签名数据, 为 nil 或者长度为 0 时不签名
/// @return { encyrpt_data, ckey } 返回 加密后请求数据 && ckey, ckey 长度大于 10 为正常，否则为错误码 ？
- (CKeyInfo *)getCKeyAll: (int) unPlatform
               unEncVer : (int) unEncVer
              strappVer : (NSString*) strappVer
                 strvid : (NSString*) strvid
                  uTime : (int) uTime
                sdtFrom : (NSString*) sdtFrom
            strRandflag : (NSString*) strRandflag
            strBundleID : (NSString*) strBundleID
                strGuid : (NSString*) strGuid
                   intA : (int[_Nullable]) intA
                 ArrLen : (int) ArrLen
                busJson : (NSString *) strBusJson
               postData : (NSData *) postData;

@end

NS_ASSUME_NONNULL_END

/// @brief 开启反调试
FOUNDATION_EXPORT void qimei_enable_ptrace(void);

/// @brief 加密日志
/// @param from 协商的 from 来源
/// @param log 待加密的日志
/// @return char *, 返回加密的日志信息, 需要调用方 qimei_free_data
FOUNDATION_EXPORT char * _Nullable qimei_encrypt_log(const char * _Nonnull from, const char * _Nonnull log);

/// @brief 解密安全加密后的返回数据
/// @param data 待解密数据, 为 base64 数据 , 以 '\0' 结束
/// @param out_data 返回数据, 需要调用方 qimei_free_data, 如果解密失败, 则返回 NULL
/// @param out_data_len 返回数据长度
/// @return 解密状态, 0 成功, 其他为具体错误
FOUNDATION_EXPORT int qimei_decrpt_ckey_sec_data(const char * _Nonnull data, char * _Nullable * _Nonnull out_data, int * _Nonnull out_data_len);

/// @brief 释放数据
/// @param data 待释放的数据
FOUNDATION_EXPORT void qimei_free_data(char * _Nullable * _Nonnull data);
