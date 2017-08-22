//
//  QCloudNetEnv.h
//  QCloudTernimalLab_CommonLogic
//
//  Created by tencent on 16/3/24.
//  Copyright © 2016年 QCloudTernimalLab. All rights reserved.
//

#import <Foundation/Foundation.h>

#define QCloudNetworkShareEnv [QCloudNetEnv shareEnv]

typedef NS_ENUM(NSInteger, QCloudNetworkStatus) {
    QCloudNotReachable = 0,
    QCloudReachableViaWiFi = 2,
    QCloudReachableViaWWAN = 1,
};

extern NSString* const kQCloudNetEnvChangedNotification;

@interface QCloudNetEnv : NSObject
+ (instancetype) shareEnv;
@property (nonatomic, assign, readonly) QCloudNetworkStatus currentNetStatus;
- (BOOL) isReachableViaWifi;
- (BOOL) isReachableVia2g3g4g;
- (BOOL) isReachable;
@end
