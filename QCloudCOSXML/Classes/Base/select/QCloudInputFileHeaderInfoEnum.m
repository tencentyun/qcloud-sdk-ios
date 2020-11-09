//
//  InputFileHeaderInfo.h
//  InputFileHeaderInfo
//
//  Created by tencent
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import "QCloudInputFileHeaderInfoEnum.h"

QCloudInputFileHeaderInfo QCloudInputFileHeaderInfoDumpFromString(NSString *key) {
    if (NO) {
    } else if ([key isEqualToString:@"NONE"]) {
        return QCloudInputFileHeaderInfoNone;
    } else if ([key isEqualToString:@"USE"]) {
        return QCloudInputFileHeaderInfoUse;
    } else if ([key isEqualToString:@"IGNORE"]) {
        return QCloudInputFileHeaderInfoIgnore;
    }
    return 0;
}
NSString *QCloudInputFileHeaderInfoTransferToString(QCloudInputFileHeaderInfo type) {
    switch (type) {
        case QCloudInputFileHeaderInfoNone: {
            return @"NONE";
        }
        case QCloudInputFileHeaderInfoUse: {
            return @"USE";
        }
        case QCloudInputFileHeaderInfoIgnore: {
            return @"IGNORE";
        }
        default:
            return nil;
    }
}
