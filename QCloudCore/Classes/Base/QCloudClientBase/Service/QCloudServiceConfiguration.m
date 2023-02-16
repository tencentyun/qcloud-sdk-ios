//
//  QCloudServiceConfiguration.m
//  Pods
//
//  Created by Dong Zhao on 2017/3/13.
//
//

#import "QCloudServiceConfiguration.h"
#import "QCloudConfiguration_Private.h"
#import "QCloudServiceConfiguration+Quality.h"
#if TARGET_OS_IOS
#import <UIKit/UIKit.h>
#endif

static NSString *const QCloudServiceConfigurationUnknown = @"Unknown";

@implementation QCloudServiceConfiguration


- (instancetype)copyWithZone:(NSZone *)zone {
    QCloudServiceConfiguration *config = [[QCloudServiceConfiguration allocWithZone:zone] init];
    config.signatureProvider = self.signatureProvider;
    config.appID = self.appID;
    config.userAgentProductKey = self.userAgentProductKey;
    config.endpoint = [self.endpoint copy];
    config.productVersion = self.productVersion;
    config.isCloseShareLog = self.isCloseShareLog;
    config.disableUploadZeroData = self.disableUploadZeroData;
    config.timeoutInterval = self.timeoutInterval;
    config.enableQuic = self.enableQuic;
    config.disableSetupBeacon = self.disableSetupBeacon;
    config.bridge = self.bridge;
    return config;
}
@end
