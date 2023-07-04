//
//  COSAccountType.h
//  COSAccountType
//
//  Created by tencent
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import "QCloudCOSAccountTypeEnum.h"

QCloudCOSAccountType QCloudCOSAccountTypeDumpFromString(NSString *key) {
    if (NO) {
    } else if ([key isEqualToString:@"RootAccount"]) {
        return QCloudCOSAccountTypeRoot;
    } else if ([key isEqualToString:@"SubAccount"]) {
        return QCloudCOSAccountTypeSub;
    }
    return 0;
}
NSString *QCloudCOSAccountTypeTransferToString(QCloudCOSAccountType type) {
    switch (type) {
        case QCloudCOSAccountTypeRoot: {
            return @"RootAccount";
        }
        case QCloudCOSAccountTypeSub: {
            return @"SubAccount";
        }
        default:
            return nil;
    }
}

QCloudCOSAccountXSIType QCloudCOSAccountXSITypeDumpFromString(NSString *key) {
    if (NO) {
    } else if ([key isEqualToString:@"RootAccount"]) {
        return QCloudCOSAccountXSITypeGroup;
    } else if ([key isEqualToString:@"SubAccount"]) {
        return QCloudCOSAccountXSITypeCanonicalUser;
    }
    return 0;
}
NSString *QCloudCOSAccountXSITypeTransferToString(QCloudCOSAccountXSIType type) {
    switch (type) {
        case QCloudCOSAccountXSITypeGroup: {
            return @"Group";
        }
        case QCloudCOSAccountXSITypeCanonicalUser: {
            return @"CanonicalUser";
        }
        default:
            return nil;
    }
}
