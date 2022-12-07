//
//  QCloudCIAutoTranslationRequest.h
//  QCloudCIAutoTranslationRequest
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
#import "QCloudAutoTranslationResult.h"
NS_ASSUME_NONNULL_BEGIN
/**
 实时文字翻译
 
 腾讯云数据万象通过 AutoTranslationBlock 接口对文字块进行翻译，请求时需要携带签名。
 
 查看更多：https://cloud.tencent.com/document/product/460/83547
 
 ### 示例
 
 @code
 
     QCloudCIAutoTranslationRequest * request = [QCloudCIAutoTranslationRequest new];
     request.regionName = @"regionName";
     // 对象键，是对象在 COS 上的完整路径，如果带目录的话，格式为 "dir1/object1"
     request.object = @"exampleobject";
     // 存储桶名称，格式为 BucketName-APPID
     request.bucket = @"examplebucket-1250000000";
     request.InputText = @"要翻译的文本";
     request.SourceLang = @"文本语言";
     request.TargetLang = @"翻译目标语言";
     [request setFinishBlock:^(QCloudAutoTranslationResult * _Nullable result, NSError * _Nullable error) {
         
     }];
     [[QCloudCOSXMLService defaultCOSXML] AutoTranslation:request];
 
*/
@interface QCloudCIAutoTranslationRequest: QCloudBizHTTPRequest

/**
 存储桶名称
*/
@property (strong, nonatomic) NSString *bucket;

/**
 最多处理的人脸数目。默认值为1（仅检测图片中面积最大的那张人脸），最大值为120。
 此参数用于控制处理待检测图片中的人脸个数，值越小，处理速度越快。
 */
@property (strong, nonatomic) NSString *InputText;

/**
 输入语言，如 "zh"    String    是
 */
@property (strong, nonatomic) NSString *SourceLang;

/**
 输出语言，如 "en"    String    是
 */
@property (strong, nonatomic) NSString *TargetLang;

/**
 文本所属业务领域，如: "ecommerce", //缺省值为 general
 */
@property (strong, nonatomic) NSString *TextDomain;

/**
 文本类型，如: "title", //缺省值为 sentence
 */
@property (strong, nonatomic) NSString *TextStyle;

- (void) setFinishBlock:(void (^_Nullable)(QCloudAutoTranslationResult * _Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
