//
//  COSBucketVersioningStatus.h
//  COSBucketVersioningStatus
//
//  Created by tencent
//  Copyright (c) 2015年 tencent. All rights reserved.
//


#import "QCloudCOSBucketVersioningStatusEnum.h"

QCloudCOSBucketVersioningStatus QCloudCOSBucketVersioningStatusDumpFromString(NSString* key) {
      if (NO) {}
      else if ([key isEqualToString:@"Enabled"]) {
          return QCloudCOSBucketVersioningStatusEnabled;
      }
      else if ([key isEqualToString:@"Suspended"]) {
          return QCloudCOSBucketVersioningStatusSuspended;
      }
      return 0;
}
NSString* QCloudCOSBucketVersioningStatusTransferToString(QCloudCOSBucketVersioningStatus type) {
    switch(type) {
        case QCloudCOSBucketVersioningStatusEnabled:
        {
            return @"Enabled";
        }
        case QCloudCOSBucketVersioningStatusSuspended:
        {
            return @"Suspended";
        }
        default:
            return nil;
    }
}
