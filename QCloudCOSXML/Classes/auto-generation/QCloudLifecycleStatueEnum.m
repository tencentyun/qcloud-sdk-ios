//
//  LifecycleStatue.h
//  LifecycleStatue
//
//  Created by tencent
//  Copyright (c) 2015年 tencent. All rights reserved.
//


#import "QCloudLifecycleStatueEnum.h"

QCloudLifecycleStatue QCloudLifecycleStatueDumpFromString(NSString* key) {
      if (NO) {}
      else if ([key isEqualToString:@"Enabled"]) {
          return QCloudLifecycleStatueEnabled;
      }
      else if ([key isEqualToString:@"Disabled"]) {
          return QCloudLifecycleStatueDisabled;
      }
      return 0;
}
NSString* QCloudLifecycleStatueTransferToString(QCloudLifecycleStatue type) {
    switch(type) {
        case QCloudLifecycleStatueEnabled:
        {
            return @"Enabled";
        }
        case QCloudLifecycleStatueDisabled:
        {
            return @"Disabled";
        }
        default:
            return nil;
    }
}
