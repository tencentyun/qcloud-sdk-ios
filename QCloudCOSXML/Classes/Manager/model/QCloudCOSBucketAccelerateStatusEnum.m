//
//  QCloudCOSBucketAccelerateStatus.m
//  QCloudCOSXML
//
//  Created by karisli(李雪) on 2020/8/28.
//

#import "QCloudCOSBucketAccelerateStatusEnum.h"

QCloudCOSBucketAccelerateStatus QCloudCOSBucketAccelerateStatusDumpFromString(NSString *key) {
    if (NO) {
    } else if ([key isEqualToString:@"Enabled"]) {
        return QCloudCOSBucketAccelerateStatusEnabled;
    } else if ([key isEqualToString:@"Suspended"]) {
        return QCloudCOSBucketAccelerateStatusSuspended;
    }
    return 0;
}
NSString *QCloudCOSBucketAccelerateStatusTransferToString(QCloudCOSBucketAccelerateStatus type) {
    switch (type) {
        case QCloudCOSBucketAccelerateStatusEnabled: {
            return @"Enabled";
        }
        case QCloudCOSBucketAccelerateStatusSuspended: {
            return @"Suspended";
        }
        default:
            return nil;
    }
}
