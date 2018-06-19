//
//  COSStorageClass.h
//  COSStorageClass
//
//  Created by tencent
//  Copyright (c) 2015年 tencent. All rights reserved.
//


#import "QCloudCOSStorageClassEnum.h"

QCloudCOSStorageClass QCloudCOSStorageClassDumpFromString(NSString* key) {
      if (NO) {}
      else if ([key isEqualToString:@"Standard"]) {
          return QCloudCOSStorageStandard;
      }
      else if ([key isEqualToString:@"Standard_IA"]) {
          return QCloudCOSStorageStandardIA;
      }
      return 0;
}
NSString* QCloudCOSStorageClassTransferToString(QCloudCOSStorageClass type) {
    switch(type) {
        case QCloudCOSStorageStandard:
        {
            return @"Standard";
        }
        case QCloudCOSStorageStandardIA:
        {
            return @"Standard_IA";
        }
        default:
            return nil;
    }
}
