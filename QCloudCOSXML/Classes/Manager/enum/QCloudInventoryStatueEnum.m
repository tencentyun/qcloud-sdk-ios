//
//  InventoryStatue.h
//  InventoryStatue
//
//  Created by tencent
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import "QCloudInventoryStatueEnum.h"

QCloudInventoryStatue QCloudInventoryStatueDumpFromString(NSString *key) {
    if (NO) {
    } else if ([key isEqualToString:@"Enabled"]) {
        return QCloudinventoryStatueEnabled;
    } else if ([key isEqualToString:@"Disabled"]) {
        return QCloudinventoryStatueDisabled;
    }
    return 0;
}
NSString *QCloudInventoryStatueTransferToString(QCloudInventoryStatue type) {
    switch (type) {
        case QCloudinventoryStatueEnabled: {
            return @"Enabled";
        }
        case QCloudinventoryStatueDisabled: {
            return @"Disabled";
        }
        default:
            return nil;
    }
}
