//
//  COSDomainType.h
//  COSDomainType
//
//  Created by tencent
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import "QCloudCOSDomainTypeEnum.h"

QCloudCOSDomainType QCloudCOSDomainTypeDumpFromString(NSString *key) {
    if (NO) {
    } else if ([key isEqualToString:@"REST"]) {
        return QCloudCOSDomainTypeRest;
    } else if ([key isEqualToString:@"WEBSITE"]) {
        return QCloudCOSDomainTypeWebsite;
    }
    return 0;
}
NSString *QCloudCOSDomainTypeTransferToString(QCloudCOSDomainType type) {
    switch (type) {
        case QCloudCOSDomainTypeRest: {
            return @"REST";
        }
        case QCloudCOSDomainTypeWebsite: {
            return @"WEBSITE";
        }
        default:
            return nil;
    }
}
