//
//  GenerateSnapshotFormat.h
//  GenerateSnapshotFormat
//
//  Created by tencent
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import "QCloudGenerateSnapshotFormatEnum.h"

QCloudGenerateSnapshotFormat QCloudGenerateSnapshotFormatDumpFromString(NSString *key) {
    if (NO) {
    } else if ([key isEqualToString:@"jpg"]) {
        return QCloudGenerateSnapshotFormatJPG;
    } else if ([key isEqualToString:@"png"]) {
        return QCloudGenerateSnapshotFormatPNG;
    }
    return 0;
}
NSString *QCloudGenerateSnapshotFormatTransferToString(QCloudGenerateSnapshotFormat type) {
    switch (type) {
        case QCloudGenerateSnapshotFormatJPG: {
            return @"jpg";
        }
        case QCloudGenerateSnapshotFormatPNG: {
            return @"png";
        }
        default:
            return nil;
    }
}
