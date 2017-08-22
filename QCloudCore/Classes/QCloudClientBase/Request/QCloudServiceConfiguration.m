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
}


- (instancetype) copyWithZone:(NSZone *)zone
{
    QCloudServiceConfiguration* config = [[QCloudServiceConfiguration  allocWithZone:zone] init];
    config.signatureProvider = self.signatureProvider;
    config.appID = self.appID;
    config.userAgentProductKey = self.userAgentProductKey;
    config.endpoint = [self.endpoint copy];
    config.productVersion = self.productVersion;
    return config;
}
@end
