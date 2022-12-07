//
//  QCloudOCRTypeEnum.h
//  QCloudCOSXML
//
//  Created by garenwang on 2022/3/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// OCR 的识别类型
/// general 表示通用印刷体识别；
/// accurate 表示印刷体高精度版；
/// efficient 表示印刷体精简版；
/// fast 表示印刷体高速版；
/// handwriting 表示手写体识别。
typedef NS_ENUM(NSUInteger, QCloudOCRTypeEnum) {
    QCloudOCRTypeGeneral = 0,
    QCloudOCRTypeAccurate = 1,
    QCloudOCRTypeEfficient = 2,
    QCloudOCRTypeFast = 3,
    QCloudOCRTypeHandwriting = 4,
};
NSString *QCloudOCRTypeEnumTransferToString(QCloudOCRTypeEnum type);
QCloudOCRTypeEnum QCloudOCRTypeEnumFromString(NSString *key);
NS_ASSUME_NONNULL_END
