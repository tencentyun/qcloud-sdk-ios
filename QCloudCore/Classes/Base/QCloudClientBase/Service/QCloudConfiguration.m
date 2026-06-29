//
//  QCloudCommenService.m
//  Pods
//
//  Created by karisli(李雪) on 2021/7/14.
//

#import "QCloudConfiguration.h"
#import "QCloudConfiguration_Private.h"

NSString * QCloudRequestNetworkStrategyToString(QCloudRequestNetworkStrategy strategy){
    
    if (strategy == QCloudRequestNetworkStrategyAggressive) {
        return @"Aggressive";
    }
    
    if (strategy == QCloudRequestNetworkStrategyConservative) {
        return @"Conservative";
    }
    return nil;
}

@implementation QCloudConfiguration
- (instancetype)init {
    self = [super init];
    if (self) {
        _disableNetworkDetect = YES;
    }
    return self;
}

- (NSString *)userAgent {
    NSString * (^UserAgent)(NSString *productKey) = ^(NSString *productKey) {
        return [NSString stringWithFormat:@"%@-%@", productKey, self.productVersion];
    };
    if (self.userAgentProductKey.length && self.productVersion.length) {
        return UserAgent(self.userAgentProductKey);
    } else {
        return nil;
    }
}
@end
