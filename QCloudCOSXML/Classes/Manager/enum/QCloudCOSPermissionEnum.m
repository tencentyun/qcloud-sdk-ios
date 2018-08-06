//
//  COSPermission.h
//  COSPermission
//
//  Created by tencent
//  Copyright (c) 2015年 tencent. All rights reserved.
//


#import "QCloudCOSPermissionEnum.h"

QCloudCOSPermission QCloudCOSPermissionDumpFromString(NSString* key) {
      if (NO) {}
      else if ([key isEqualToString:@"READ"]) {
          return QCloudCOSPermissionRead;
      }
      else if ([key isEqualToString:@"WRITE"]) {
          return QCloudCOSPermissionWrite;
      }
      else if ([key isEqualToString:@"FULL_CONTROL"]) {
          return QCloudCOSPermissionFullControl;
      }
      return 0;
}
NSString* QCloudCOSPermissionTransferToString(QCloudCOSPermission type) {
    switch(type) {
        case QCloudCOSPermissionRead:
        {
            return @"READ";
        }
        case QCloudCOSPermissionWrite:
        {
            return @"WRITE";
        }
        case QCloudCOSPermissionFullControl:
        {
            return @"FULL_CONTROL";
        }
        default:
            return nil;
    }
}
