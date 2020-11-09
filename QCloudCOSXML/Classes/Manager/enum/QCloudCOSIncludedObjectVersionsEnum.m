//
//  COSIncludedObjectVersions.h
//  COSIncludedObjectVersions
//
//  Created by tencent
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import "QCloudCOSIncludedObjectVersionsEnum.h"

QCloudCOSIncludedObjectVersions QCloudCOSIncludedObjectVersionsDumpFromString(NSString *key) {
    if (NO) {
    } else if ([key isEqualToString:@"All"]) {
        return QCloudCOSIncludedObjectVersionsAll;
    } else if ([key isEqualToString:@"Current"]) {
        return QCloudCOSIncludedObjectVersionsCurrent;
    }
    return 0;
}
NSString *QCloudCOSIncludedObjectVersionsTransferToString(QCloudCOSIncludedObjectVersions type) {
    switch (type) {
        case QCloudCOSIncludedObjectVersionsAll: {
            return @"All";
        }
        case QCloudCOSIncludedObjectVersionsCurrent: {
            return @"Current";
        }
        default:
            return nil;
    }
}
