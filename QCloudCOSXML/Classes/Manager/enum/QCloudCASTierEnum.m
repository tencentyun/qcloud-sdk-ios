//
//  CASTier.h
//  CASTier
//
//  Created by tencent
//  Copyright (c) 2015年 tencent. All rights reserved.
//


#import "QCloudCASTierEnum.h"

QCloudCASTier QCloudCASTierDumpFromString(NSString* key) {
      if (NO) {}
      else if ([key isEqualToString:@"Expedited"]) {
          return QCloudCASTierExpedited;
      }
      else if ([key isEqualToString:@"Standard"]) {
          return QCloudCASTierStandard;
      }
      else if ([key isEqualToString:@"Bulk"]) {
          return QCloudCASTierBulk;
      }
      return 0;
}
NSString* QCloudCASTierTransferToString(QCloudCASTier type) {
    switch(type) {
        case QCloudCASTierExpedited:
        {
            return @"Expedited";
        }
        case QCloudCASTierStandard:
        {
            return @"Standard";
        }
        case QCloudCASTierBulk:
        {
            return @"Bulk";
        }
        default:
            return nil;
    }
}
