//
//  QCloudFaceEffectEnum.m
//  QCloudCOSXML
//
//  Created by garenwang on 2022/3/17.
//

#import "QCloudFaceEffectEnum.h"

//QCloudFaceEffectNone = 0,
//QCloudFaceEffectBeautify = 1,
//QCloudFaceEffectGenderTransformation = 2,
//QCloudFaceEffectAgeTransformation = 3,
//QCloudFaceEffectSegmentation = 4,
NSString *QCloudFaceEffectEnumTransferToString(QCloudFaceEffectEnum type) {
    
    
    if(type ==  QCloudFaceEffectBeautify){
        return @"face-beautify";
    }
    
    if(type ==  QCloudFaceEffectGenderTransformation){
        return @"face-gender-transformation";
    }
    
    if(type ==  QCloudFaceEffectAgeTransformation){
        return @"face-age-transformation";
    }
    
    if(type ==  QCloudFaceEffectSegmentation){
        return @"face-segmentation";
    }
   
    return @"";
}


QCloudFaceEffectEnum QCloudFaceEffectEnumFromString(NSString *key) {
    if ([key isEqualToString:@"face-beautify"]) {
        return QCloudFaceEffectBeautify;
    } else if ([key isEqualToString:@"face-gender-transformation"]) {
        return QCloudFaceEffectGenderTransformation;
    } else if ([key isEqualToString:@"face-age-transformation"]) {
        return QCloudFaceEffectAgeTransformation;
    } else if ([key isEqualToString:@"face-segmentation"]) {
        return QCloudFaceEffectSegmentation;
    } else {
        return QCloudFaceEffectNone;
    }
}
