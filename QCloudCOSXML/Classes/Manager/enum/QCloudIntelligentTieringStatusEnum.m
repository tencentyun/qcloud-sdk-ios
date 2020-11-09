//
//  IntelligentTieringStatus.h
//  IntelligentTieringStatus
//
//  Created by tencent
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import "QCloudIntelligentTieringStatusEnum.h"

QCloudIntelligentTieringStatus QCloudIntelligentTieringStatusDumpFromString(NSString *key) {
    if (NO) {
    } else if ([key isEqualToString:@"Suspended"]) {
        return QCloudintelligentTieringStatusSuspended;
    } else if ([key isEqualToString:@"Enabled"]) {
        return QCloudintelligentTieringStatusEnabled;
    }
    return 0;
}
NSString *QCloudIntelligentTieringStatusTransferToString(QCloudIntelligentTieringStatus type) {
    switch (type) {
        case QCloudintelligentTieringStatusSuspended: {
            return @"Suspended";
        }
        case QCloudintelligentTieringStatusEnabled: {
            return @"Enabled";
        }
        default:
            return nil;
    }
}
