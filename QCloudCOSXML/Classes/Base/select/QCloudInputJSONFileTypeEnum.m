//
//  InputJSONFileType.h
//  InputJSONFileType
//
//  Created by tencent
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import "QCloudInputJSONFileTypeEnum.h"

QCloudInputJSONFileType QCloudInputJSONFileTypeDumpFromString(NSString *key) {
    if (NO) {
    } else if ([key isEqualToString:@"DOCUMENT"]) {
        return QCloudInputJSONFileTypeDocument;
    } else if ([key isEqualToString:@"LINES"]) {
        return QCloudInputJSONFileTypeLines;
    }
    return 0;
}
NSString *QCloudInputJSONFileTypeTransferToString(QCloudInputJSONFileType type) {
    switch (type) {
        case QCloudInputJSONFileTypeDocument: {
            return @"DOCUMENT";
        }
        case QCloudInputJSONFileTypeLines: {
            return @"LINES";
        }
        default:
            return nil;
    }
}
