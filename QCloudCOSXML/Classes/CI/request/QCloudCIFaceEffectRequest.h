//
//  QCloudCIFaceEffectRequest.h
//  QCloudCIFaceEffectRequest
//
//  Created by tencent
//  Copyright (c) 2015年 tencent. All rights reserved.
//
//   ██████╗  ██████╗██╗      ██████╗ ██╗   ██╗██████╗     ████████╗███████╗██████╗ ███╗   ███╗██╗███╗   ██╗ █████╗ ██╗         ██╗      █████╗ ██████╗
//  ██╔═══██╗██╔════╝██║     ██╔═══██╗██║   ██║██╔══██╗    ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║████╗  ██║██╔══██╗██║         ██║     ██╔══██╗██╔══██╗
//  ██║   ██║██║     ██║     ██║   ██║██║   ██║██║  ██║       ██║   █████╗  ██████╔╝██╔████╔██║██║██╔██╗ ██║███████║██║         ██║     ███████║██████╔╝
//  ██║▄▄ ██║██║     ██║     ██║   ██║██║   ██║██║  ██║       ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║██║╚██╗██║██╔══██║██║         ██║     ██╔══██║██╔══██╗
//  ╚██████╔╝╚██████╗███████╗╚██████╔╝╚██████╔╝██████╔╝       ██║   ███████╗██║  ██║██║ ╚═╝ ██║██║██║ ╚████║██║  ██║███████╗    ███████╗██║  ██║██████╔╝
//   ╚══▀▀═╝  ╚═════╝╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝        ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝    ╚══════╝╚═╝  ╚═╝╚═════╝
//
//
//                                                                              _             __                 _                _
//                                                                             (_)           / _|               | |              | |
//                                                          ___  ___ _ ____   ___  ___ ___  | |_ ___  _ __    __| | _____   _____| | ___  _ __   ___ _ __ ___
//                                                         / __|/ _ \ '__\ \ / / |/ __/ _ \ |  _/ _ \| '__|  / _` |/ _ \ \ / / _ \ |/ _ \| '_ \ / _ \ '__/ __|
//                                                         \__ \  __/ |   \ V /| | (_|  __/ | || (_) | |    | (_| |  __/\ V /  __/ | (_) | |_) |  __/ |  \__
//                                                         |___/\___|_|    \_/ |_|\___\___| |_| \___/|_|     \__,_|\___| \_/ \___|_|\___/| .__/ \___|_|  |___/
//    ______ ______ ______ ______ ______ ______ ______ ______                                                                            | |
//   |______|______|______|______|______|______|______|______|                                                                           |_|
//



#import <Foundation/Foundation.h>
#import <QCloudCore/QCloudCore.h>
#import "QCloudEffectFaceResult.h"
#import "QCloudFaceEffectEnum.h"
NS_ASSUME_NONNULL_BEGIN
/**
 人脸特效
 
 人脸特效支持人脸美颜、人脸性别变换、人脸年龄变化、人像分割的特效功能，适用于社交娱乐、广告营销、互动传播等场景。
 
 查看更多：https://cloud.tencent.com/document/product/460/47197
 
 ### 示例
 
 @code
 
     QCloudCIFaceEffectRequest * request = [QCloudCIFaceEffectRequest new];
     request.regionName = @"regionName";
     // 对象键，是对象在 COS 上的完整路径，如果带目录的话，格式为 "dir1/object1"
     request.object = @"exampleobject";
     // 存储桶名称，格式为 BucketName-APPID
     request.bucket = @"examplebucket-1250000000";
     request.type = QCloudFaceEffectBeautify;
     request.whitening = 100;
     request.smoothing = 100;
     [request setFinishBlock:^(QCloudEffectFaceResult * _Nullable result, NSError * _Nullable error) {
         NSData * data = [[NSData alloc]initWithBase64EncodedString:result.ResultImage options:NSDataBase64DecodingIgnoreUnknownCharacters];
         UIImage * image = [UIImage imageWithData:data];
     }];
     [[QCloudCOSXMLService defaultCOSXML] FaceEffect:request];
*/
@interface QCloudCIFaceEffectRequest: QCloudBizHTTPRequest

/**
 存储桶名称
*/
@property (strong, nonatomic) NSString *bucket;

/**
 对象文件名，例如：folder/document.jpg。
*/
@property (strong, nonatomic) NSString *object;

/**
 人脸特效类型。
 人脸美颜：QCloudFaceEffectBeautify,
 人脸性别转换：QCloudFaceEffectGenderTransformation,
 人脸年龄变化：QCloudFaceEffectAgeTransformation,
 人像分割：QCloudFaceEffectSegmentation,
 */
@property (assign, nonatomic) QCloudFaceEffectEnum type;

/**
 whitening    type 为 face-beautify 时生效，美白程度，取值范围[0,100]。0表示不美白，100表示最高程度。默认值30
 */
@property (assign, nonatomic) NSInteger whitening;

/**
 smoothing    type 为 face-beautify 时生效，磨皮程度，取值范围[0,100]。0表示不磨皮，100表示最高程度。默认值10
 */
@property (assign, nonatomic) NSInteger smoothing;


/**
 faceLifting    type 为 face-beautify 时生效，瘦脸程度，取值范围[0,100]。0表示不瘦脸，100表示最高程度。默认值70
 */
@property (assign, nonatomic) NSInteger faceLifting;


/**
 eyeEnlarging    type 为 face-beautify 时生效，大眼程度，取值范围[0,100]。0表示不大眼，100表示最高程度。默认值70
 */
@property (assign, nonatomic) NSInteger eyeEnlarging;

/**
 gender    type 为 face-gender-transformation 时生效，选择转换方向，0表示男变女，1表示女变男。无默认值。注意：仅对图片中面积最大的人脸进行转换
 */
@property (assign, nonatomic) NSInteger gender;

/**
 age    type 为 face-age-transformation 时生效，变化到的人脸年龄，范围为[10,80]，无默认值。注意：仅对图片中面积最大的人脸进行转换    Integer    是
 */
@property (assign, nonatomic) NSInteger age;



- (void) setFinishBlock:(void (^_Nullable)(QCloudEffectFaceResult * _Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
