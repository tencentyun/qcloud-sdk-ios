//
//  QCloudServiceConfiguration.m
//  Pods
//
//  Created by Dong Zhao on 2017/3/13.
//
//

#import "QCloudServiceConfiguration.h"
#import "QCloudServiceConfiguration_Private.h"
#if TARGET_OS_IOS
#import <UIKit/UIKit.h>
#endif

static NSString *const QCloudServiceConfigurationUnknown = @"Unknown";

@implementation QCloudServiceConfiguration
- (NSString*) userAgent
{
    NSString*(^UserAgent)(NSString* productKey) = ^(NSString* productKey) {
        return [NSString stringWithFormat:@"%@-%@", productKey,self.productVersion];
    };
    if (self.userAgentProductKey.length && self.productVersion.length) {
        return UserAgent(self.userAgentProductKey);
    } else {
        return nil;
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
    config.backgroundIdentifier = self.backgroundIdentifier;
    config.backgroundEnable = self.backgroundEnable;
    config.isCloseShareLog = self.isCloseShareLog;
    config.timeoutInterval = self.timeoutInterval;
    return config;
}
@end
