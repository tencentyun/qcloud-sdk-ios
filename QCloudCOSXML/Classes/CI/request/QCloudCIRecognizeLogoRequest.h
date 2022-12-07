//
//  QCloudCIRecognizeLogoRequest.h
//  QCloudCIRecognizeLogoRequest
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
#import "QCloudCILogoRecognitionResult.h"

NS_ASSUME_NONNULL_BEGIN
/**
 Logo 识别
 
 腾讯云数据万象通过 RecognizeLogo 接口实现对图片内电商 Logo 的识别，返回图片中 Logo 的名称、坐标、置信度分值。
 
 查看更多：https://cloud.tencent.com/document/product/460/79736
 
 ### 示例

   @code
 
     QCloudCIRecognizeLogoRequest * request = [QCloudCIRecognizeLogoRequest new];
     request.regionName = @"regionName";
     // 对象键，是对象在 COS 上的完整路径，如果带目录的话，格式为 "dir1/object1"
     request.object = @"exampleobject";
     // 存储桶名称，格式为 BucketName-APPID
     request.bucket = @"examplebucket-1250000000";
     [request setFinishBlock:^(QCloudCILogoRecognitionResult * _Nullable result, NSError * _Nullable error) {
         
     }];
     [[QCloudCOSXMLService defaultCOSXML] RecognizeLogo:request];
*/
@interface QCloudCIRecognizeLogoRequest: QCloudBizHTTPRequest

/**
 存储桶名称
*/
@property (strong, nonatomic) NSString *bucket;

/**
 对象文件名，例如：folder/document.jpg。
*/
@property (strong, nonatomic) NSString *object;

/**
 您可以通过填写 detect-url 处理任意公网可访问的图片链接。不填写 detect-url 时，后台会默认处理 ObjectKey ，填写了 detect-url 时，后台会处理 detect-url 链接，无需再填写 ObjectKey detect-url 示例：http://www.example.com/abc.jpg
 */
@property (strong, nonatomic) NSString *detectUrl;

/**
 当此参数为1时，针对文件过大等导致处理失败的场景，会直接返回原图而不报错。
 */
@property (assign, nonatomic) BOOL ignoreError;

- (void) setFinishBlock:(void (^_Nullable)(QCloudCILogoRecognitionResult * _Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
