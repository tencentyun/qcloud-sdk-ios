//
//  QCloudPNPortScan.h
//  PhoneNetSDK
//
//  Created by mediaios on 2019/2/28.
//  Copyright © 2019 mediaios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QCloudPhoneNetSDKHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCloudPNPortScan : NSObject
+ (instancetype)shareInstance;
- (void)portScan:(NSString *)host beginPort:(NSUInteger)beginPort endPort:(NSUInteger)endPort completeHandler:(NetPortScanHandler)handler;
- (BOOL)isDoingScanPort;
- (void)stopPortScan;
@end

NS_ASSUME_NONNULL_END
