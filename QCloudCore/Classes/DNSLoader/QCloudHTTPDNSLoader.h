//
//  QCloudHTTPDNSLoader.h
//  CloudInfinite
//
//  Created by garenwang on 2023/3/14.
//
#import <QCloudCore/QCloudCore.h>
NS_ASSUME_NONNULL_BEGIN

typedef enum {
    QCloudHttpDnsEncryptTypeDES = 0,
    QCloudHttpDnsEncryptTypeAES = 1,
    QCloudHttpDnsEncryptTypeHTTPS = 2
} QCloudHttpDnsEncryptType;

typedef enum {
    QCloudHttpDnsAddressTypeAuto = 0, // sdk自动检测
    QCloudHttpDnsAddressTypeIPv4 = 1, // 只支持ipv4
    QCloudHttpDnsAddressTypeIPv6 = 2, // 只支持ipv6
    QCloudHttpDnsAddressTypeDual = 3, // 支持双协议栈
} QCloudHttpDnsAddressType;

typedef struct QCloudDnsConfigStruct {
    NSString* appId; // 可选，应用ID，腾讯云控制台申请获得，用于灯塔数据上报（未集成灯塔时该参数无效）
    int dnsId; // 授权ID，腾讯云控制台申请后，通过邮件发送，用于域名解析鉴权
    NSString* dnsKey; // 加密密钥，加密方式为AES、DES时必传。腾讯云控制台申请后，通过邮件发送，用于域名解析鉴权
    NSString* token; // 加密token，加密方式为 HTTPS 时必传
    NSString* dnsIp; // HTTPDNS 服务器 IP
    BOOL debug; // 是否开启Debug日志，YES：开启，NO：关闭。建议联调阶段开启，正式上线前关闭
    int timeout; // 可选，超时时间，单位ms，如设置0，则设置为默认值2000ms
    QCloudHttpDnsEncryptType encryptType; // 控制加密方式
    QCloudHttpDnsAddressType addressType; // 指定返回的ip地址类型，默认为 QCloudHttpDnsAddressTypeAuto sdk自动检测
    NSString* routeIp; // 可选，DNS 请求的 ECS（EDNS-Client-Subnet）值，默认情况下 HTTPDNS 服务器会查询客户端出口 IP 为 DNS 线路查询 IP，可以指定线路 IP 地址。支持 IPv4/IPv6 地址传入
    BOOL httpOnly;// 可选，是否仅返回 httpDns 解析结果。默认 false，即当 httpDns 解析失败时会返回 localDns 解析结果，设置为 true 时，仅返回 httpDns 的解析结果
    NSUInteger retryTimesBeforeSwitchServer; // 可选，切换ip之前重试次数, 默认3次
    NSUInteger minutesBeforeSwitchToMain; // 可选，设置切回主ip间隔时长，默认10分钟
    BOOL enableReport; // 是否开启解析异常上报，默认NO，不上报
} QCloudDnsConfig;

@interface QCloudHTTPDNSLoader : NSObject <QCloudHTTPDNSProtocol>

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithConfig:(QCloudDnsConfig)config;

- (NSString *)resolveDomain:(NSString *)domain;
@end

NS_ASSUME_NONNULL_END
