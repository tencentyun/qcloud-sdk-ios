//
//  COSDomainReplaceType.h
//  COSDomainReplaceType
//
//  Created by tencent
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import "QCloudCOSDomainReplaceTypeEnum.h"

QCloudCOSDomainReplaceType QCloudCOSDomainReplaceTypeDumpFromString(NSString *key) {
    if (NO) {
    } else if ([key isEqualToString:@"CNAME"]) {
        return QCloudCOSDomainReplaceTypeCname;
    } else if ([key isEqualToString:@"TXT"]) {
        return QCloudCOSDomainReplaceTypeTxt;
    }
    return 0;
}
NSString *QCloudCOSDomainReplaceTypeTransferToString(QCloudCOSDomainReplaceType type) {
    switch (type) {
        case QCloudCOSDomainReplaceTypeCname: {
            return @"CNAME";
        }
        case QCloudCOSDomainReplaceTypeTxt: {
            return @"TXT";
        }
        default:
            return nil;
    }
}
