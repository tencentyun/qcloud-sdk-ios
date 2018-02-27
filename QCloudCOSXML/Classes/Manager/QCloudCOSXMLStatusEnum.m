//
//  COSXMLStatus.h
//  COSXMLStatus
//
//  Created by tencent
//  Copyright (c) 2015年 tencent. All rights reserved.
//


#import "QCloudCOSXMLStatusEnum.h"

QCloudCOSXMLStatus QCloudCOSXMLStatusDumpFromString(NSString* key) {
      if (NO) {}
      else if ([key isEqualToString:@"Enabled"]) {
          return QCloudCOSXMLStatusEnabled;
      }
      else if ([key isEqualToString:@"Disabled"]) {
          return QCloudCOSXMLStatusDisabled;
      }
      return 0;
}
NSString* QCloudCOSXMLStatusTransferToString(QCloudCOSXMLStatus type) {
    switch(type) {
        case QCloudCOSXMLStatusEnabled:
        {
            return @"Enabled";
        }
        case QCloudCOSXMLStatusDisabled:
        {
            return @"Disabled";
        }
        default:
            return nil;
    }
}
