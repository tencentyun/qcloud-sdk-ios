//
//  QCloudCOSXMLStatus.h
//  QCloudCOSXMLStatus
//
//  Created by tencent
//  Copyright (c) 2015年 tencent. All rights reserved.
//


#import "QCloudQCloudCOSXMLStatusEnum.h"

QCloudQCloudCOSXMLStatus QCloudQCloudCOSXMLStatusDumpFromString(NSString* key) {
      if (NO) {}
      else if ([key isEqualToString:@"Enabled"]) {
          return QCloudQCloudCOSXMLStatusEnabled;
      }
      else if ([key isEqualToString:@"Disabled"]) {
          return QCloudQCloudCOSXMLStatusDisabled;
      }
      return 0;
}
NSString* QCloudQCloudCOSXMLStatusTransferToString(QCloudQCloudCOSXMLStatus type) {
    switch(type) {
        case QCloudQCloudCOSXMLStatusEnabled:
        {
            return @"Enabled";
        }
        case QCloudQCloudCOSXMLStatusDisabled:
        {
            return @"Disabled";
        }
        default:
            return nil;
    }
}
