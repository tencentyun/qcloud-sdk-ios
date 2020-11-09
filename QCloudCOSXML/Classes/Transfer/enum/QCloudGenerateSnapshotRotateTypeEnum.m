//
//  GenerateSnapshotRotateType.h
//  GenerateSnapshotRotateType
//
//  Created by tencent
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import "QCloudGenerateSnapshotRotateTypeEnum.h"

QCloudGenerateSnapshotRotateType QCloudGenerateSnapshotRotateTypeDumpFromString(NSString *key) {
    if (NO) {
    } else if ([key isEqualToString:@"auto"]) {
        return QCloudGenerateSnapshotRotateTypeAuto;
    } else if ([key isEqualToString:@"off"]) {
        return QCloudGenerateSnapshotRotateTypeOff;
    }
    return 0;
}
NSString *QCloudGenerateSnapshotRotateTypeTransferToString(QCloudGenerateSnapshotRotateType type) {
    switch (type) {
        case QCloudGenerateSnapshotRotateTypeAuto: {
            return @"auto";
        }
        case QCloudGenerateSnapshotRotateTypeOff: {
            return @"off";
        }
        default:
            return nil;
    }
}
