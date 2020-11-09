//
//  GenerateSnapshotMode.h
//  GenerateSnapshotMode
//
//  Created by tencent
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import "QCloudGenerateSnapshotModeEnum.h"

QCloudGenerateSnapshotMode QCloudGenerateSnapshotModeDumpFromString(NSString *key) {
    if (NO) {
    } else if ([key isEqualToString:@"exactframe"]) {
        return QCloudGenerateSnapshotModeExactframe;
    } else if ([key isEqualToString:@"keyframe"]) {
        return QCloudGenerateSnapshotModeKeyframe;
    }
    return 0;
}
NSString *QCloudGenerateSnapshotModeTransferToString(QCloudGenerateSnapshotMode type) {
    switch (type) {
        case QCloudGenerateSnapshotModeExactframe: {
            return @"exactframe";
        }
        case QCloudGenerateSnapshotModeKeyframe: {
            return @"keyframe";
        }
        default:
            return nil;
    }
}
