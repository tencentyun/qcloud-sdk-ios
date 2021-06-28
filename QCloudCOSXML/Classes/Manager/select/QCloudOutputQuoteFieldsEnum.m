//
//  OutputQuoteFields.h
//  OutputQuoteFields
//
//  Created by tencent
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import "QCloudOutputQuoteFieldsEnum.h"

QCloudOutputQuoteFields QCloudOutputQuoteFieldsDumpFromString(NSString *key) {
    if (NO) {
    } else if ([key isEqualToString:@"ASNEEDED"]) {
        return QCloudOutputQuoteFieldsAsneeded;
    } else if ([key isEqualToString:@"ALWAYS"]) {
        return QCloudOutputQuoteFieldsAlways;
    }
    return 0;
}
NSString *QCloudOutputQuoteFieldsTransferToString(QCloudOutputQuoteFields type) {
    switch (type) {
        case QCloudOutputQuoteFieldsAsneeded: {
            return @"ASNEEDED";
        }
        case QCloudOutputQuoteFieldsAlways: {
            return @"ALWAYS";
        }
        default:
            return nil;
    }
}
