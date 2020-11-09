//
//  COSXMLCompressionType.h
//  COSXMLCompressionType
//
//  Created by tencent
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import "QCloudCOSXMLCompressionTypeEnum.h"

QCloudCOSXMLCompressionType QCloudCOSXMLCompressionTypeDumpFromString(NSString *key) {
    if (NO) {
    } else if ([key isEqualToString:@"NONE"]) {
        return QCloudCOSXMLCompressionTypeNONE;
    } else if ([key isEqualToString:@"GZIP"]) {
        return QCloudCOSXMLCompressionTypeGZIP;
    } else if ([key isEqualToString:@"BZIP2"]) {
        return QCloudCOSXMLCompressionTypeBZIP2;
    }
    return 0;
}
NSString *QCloudCOSXMLCompressionTypeTransferToString(QCloudCOSXMLCompressionType type) {
    switch (type) {
        case QCloudCOSXMLCompressionTypeNONE: {
            return @"NONE";
        }
        case QCloudCOSXMLCompressionTypeGZIP: {
            return @"GZIP";
        }
        case QCloudCOSXMLCompressionTypeBZIP2: {
            return @"BZIP2";
        }
        default:
            return nil;
    }
}
