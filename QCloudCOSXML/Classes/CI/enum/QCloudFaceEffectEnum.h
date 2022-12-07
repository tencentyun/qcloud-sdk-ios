//
//  QCloudFaceEffectEnum.h
//  QCloudCOSXML
//
//  Created by garenwang on 2022/3/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 人脸特效类型。
/// 人脸美颜：face-beautify；
/// 人脸性别转换：face-gender-transformation；
/// 人脸年龄变化：face-age-transformation；
/// 人像分割：face-segmentation
typedef NS_ENUM(NSUInteger, QCloudFaceEffectEnum) {
    QCloudFaceEffectNone = 0,
    QCloudFaceEffectBeautify = 1,
    QCloudFaceEffectGenderTransformation = 2,
    QCloudFaceEffectAgeTransformation = 3,
    QCloudFaceEffectSegmentation = 4,
};
NSString *QCloudFaceEffectEnumTransferToString(QCloudFaceEffectEnum type);
QCloudFaceEffectEnum QCloudFaceEffectEnumFromString(NSString *key);
NS_ASSUME_NONNULL_END
