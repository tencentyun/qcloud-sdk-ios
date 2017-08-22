//
//  QCloudIntelligenceTimeOutAdapter.m
//  QCloudTernimalLab_CommonLogic
//
//  Created by tencent on 5/23/16.
//  Copyright © 2016 QCloudTernimalLab. All rights reserved.
//

#import "QCloudIntelligenceTimeOutAdapter.h"
#import "QCloudNetEnv.h"

@implementation QCloudIntelligenceTimeOutAdapter
+ (double) recommendTimeOut
{
    if ([QCloudNetEnv shareEnv].currentNetStatus == QCloudReachableViaWiFi) {
        return 30;
    } else {
        return 60;
    }
}
@end
