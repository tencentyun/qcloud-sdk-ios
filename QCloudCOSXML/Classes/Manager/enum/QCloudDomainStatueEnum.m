//
//  DomainStatue.h
//  DomainStatue
//
//  Created by tencent
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import "QCloudDomainStatueEnum.h"

QCloudDomainStatue QCloudDomainStatueDumpFromString(NSString *key) {
    if (NO) {
    } else if ([key isEqualToString:@"ENABLED"]) {
        return QCloudDomainStatueEnabled;
    } else if ([key isEqualToString:@"DISABLED"]) {
        return QCloudDomainStatueDisabled;
    }
    return 0;
}
NSString *QCloudDomainStatueTransferToString(QCloudDomainStatue type) {
    switch (type) {
        case QCloudDomainStatueEnabled: {
            return @"ENABLED";
        }
        case QCloudDomainStatueDisabled: {
            return @"DISABLED";
        }
        default:
            return nil;
    }
}
