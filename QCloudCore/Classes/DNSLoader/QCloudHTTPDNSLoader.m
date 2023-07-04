//
//  QCloudHTTPDNSLoader.m
//  CloudInfinite
//
//  Created by garenwang on 2023/3/14.
//

#import "QCloudHTTPDNSLoader.h"
#import <MSDKDns_C11/MSDKDns.h>
@interface QCloudHTTPDNSLoader ()
@property(nonatomic,assign)QCloudDnsConfig config;
@end

@implementation QCloudHTTPDNSLoader

- (instancetype)initWithConfig:(QCloudDnsConfig)config{
    if (self = [self init]) {
        self.config = config;
        DnsConfig _config;
        _config.token = config.token;
        _config.appId = config.appId;
        _config.dnsId = config.dnsId;
        _config.dnsKey = config.dnsKey;
        _config.token = config.token;
        _config.dnsIp = config.dnsIp;
        _config.debug = config.debug;
        _config.timeout = config.timeout;
        _config.encryptType = (HttpDnsEncryptType)config.encryptType;
        _config.addressType = (HttpDnsAddressType)config.addressType;
        _config.routeIp = config.routeIp;
        _config.httpOnly = config.httpOnly;
        _config.retryTimesBeforeSwitchServer = config.retryTimesBeforeSwitchServer;
        _config.minutesBeforeSwitchToMain = config.minutesBeforeSwitchToMain;
        _config.enableReport = config.enableReport;
        [[MSDKDns sharedInstance] initConfig:&_config];
    }
    return self;
}

- (NSString *)resolveDomain:(NSString *)domain{
    __block NSString * ipAddress;
    dispatch_semaphore_t semp = dispatch_semaphore_create(0);
    [[MSDKDns sharedInstance] WGGetHostByNameAsync:domain returnIps:^(NSArray *ipsArray) {
        ipAddress = ipsArray.firstObject;
        dispatch_semaphore_signal(semp);
    }];
    dispatch_semaphore_wait(semp, dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC));
    return ipAddress;
}
@end
