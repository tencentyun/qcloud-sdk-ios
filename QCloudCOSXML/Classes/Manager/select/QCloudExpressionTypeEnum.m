//
//  ExpressionType.h
//  ExpressionType
//
//  Created by tencent
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import "QCloudExpressionTypeEnum.h"

QCloudExpressionType QCloudExpressionTypeDumpFromString(NSString *key) {
    if (NO) {
    } else if ([key isEqualToString:@"SQL"]) {
        return QCloudExpressionTypeSQL;
    }
    return 0;
}
NSString *QCloudExpressionTypeTransferToString(QCloudExpressionType type) {
    switch (type) {
        case QCloudExpressionTypeSQL: {
            return @"SQL";
        }
        default:
            return nil;
    }
}
