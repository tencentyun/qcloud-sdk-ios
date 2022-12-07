//
//  QCloudOCRTypeEnum.m
//  QCloudCOSXML
//
//  Created by garenwang on 2022/3/17.
//

#import "QCloudOCRTypeEnum.h"

NSString *QCloudOCRTypeEnumTransferToString(QCloudOCRTypeEnum type) {

    if(type == QCloudOCRTypeGeneral){
        return @"general";
    }
    if(type == QCloudOCRTypeAccurate){
        return @"accurate";
    }
    if(type == QCloudOCRTypeEfficient){
        return @"efficient";
    }
    if(type == QCloudOCRTypeFast){
        return @"fast";
    }
    if(type == QCloudOCRTypeHandwriting){
        return @"handwriting";
    }

    return @"";
}


QCloudOCRTypeEnum QCloudOCRTypeEnumFromString(NSString *key) {
    if ([key isEqualToString:@"general"]) {
        return QCloudOCRTypeGeneral;
    } else if ([key isEqualToString:@"accurate"]) {
        return QCloudOCRTypeAccurate;
    } else if ([key isEqualToString:@"efficient"]) {
        return QCloudOCRTypeEfficient;
    } else if ([key isEqualToString:@"fast"]) {
        return QCloudOCRTypeFast;
    } else  if ([key isEqualToString:@"handwriting"]) {
        return QCloudOCRTypeHandwriting;
    } else {
        return QCloudOCRTypeGeneral;
    }
}
