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
      }else if([key isEqualToString:@"ARCHIVE"]){
          return QCloudCOSStorageARCHIVE;
      }else if([key isEqualToString:@"MAZ_STANDARD"]){
          return QCloudCOSStorageMAZ_Standard;
      }else if([key isEqualToString:@"MAZ_STANDARD_IA"]){
          return QCloudCOSStorageMAZ_StandardIA;
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
        case QCloudCOSStorageARCHIVE:
        {
            return @"ARCHIVE";
        }
        case QCloudCOSStorageMAZ_Standard:
        {
            return @"MAZ_STANDARD";
        }
        case QCloudCOSStorageMAZ_StandardIA:
        {
            return @"MAZ_STANDARD_IA";
        }
        default:
            return nil;
    }
}
