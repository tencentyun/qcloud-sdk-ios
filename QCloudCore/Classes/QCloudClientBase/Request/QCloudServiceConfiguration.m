//
//  QCloudServiceConfiguration.m
//  Pods
//
//  Created by Dong Zhao on 2017/3/13.
//
//

#import "QCloudServiceConfiguration.h"
#import "QCloudServiceConfiguration_Private.h"
static NSString *const QCloudServiceConfigurationUnknown = @"Unknown";

@implementation QCloudServiceConfiguration
- (NSString*) userAgent
{
#if TARGET_OS_IPHONE

    NSString*(^UserAgent)(NSString* productKey) = ^(NSString* productKey) {
            NSString *systemName = [[[UIDevice currentDevice] systemName] stringByReplacingOccurrencesOfString:@" " withString:@"-"];
            if (!systemName) {
                systemName = QCloudServiceConfigurationUnknown;
            }
            NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
            if (!systemVersion) {
                systemVersion = QCloudServiceConfigurationUnknown;
            }
            NSString *localeIdentifier = [[NSLocale currentLocale] localeIdentifier];
            if (!localeIdentifier) {
                localeIdentifier = QCloudServiceConfigurationUnknown;
            }
            return [NSString stringWithFormat:@"%@-iOS-%@ %@/%@ %@", productKey,self.productVersion, systemName, systemVersion, localeIdentifier];
    };
    if (self.userAgentProductKey.length) {
        return UserAgent(self.userAgentProductKey);
    } else {
        return UserAgent(@"");
    }
#elif TARGET_OS_MAC
    return @"Test-Mac-Agent";
#endif
}


- (instancetype) copyWithZone:(NSZone *)zone
{
    QCloudServiceConfiguration* config = [[QCloudServiceConfiguration  allocWithZone:zone] init];
    config.signatureProvider = self.signatureProvider;
    config.appID = self.appID;
    config.userAgentProductKey = self.userAgentProductKey;
    config.endpoint = [self.endpoint copy];
    config.productVersion = self.productVersion;
    config.backgroundIdentifier = self.backgroundIdentifier;
    config.backgroundEnable = self.backgroundEnable;
    config.backgroundIn4GEnable = self.backgroundIn4GEnable;
    return config;
}
@end
