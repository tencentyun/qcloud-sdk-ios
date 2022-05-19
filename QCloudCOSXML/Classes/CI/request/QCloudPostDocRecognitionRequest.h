//
//  QCloudPostDocRecognitionRequest.h
//  QCloudPostDocRecognitionRequest
//
//  Created by tencent
//  Copyright (c) 2020年 tencent. All rights reserved.
//
//   ██████╗  ██████╗██╗      ██████╗ ██╗   ██╗██████╗     ████████╗███████╗██████╗ ███╗   ███╗██╗███╗   ██╗ █████╗ ██╗         ██╗      █████╗
//   ██████╗
//  ██╔═══██╗██╔════╝██║     ██╔═══██╗██║   ██║██╔══██╗    ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║████╗  ██║██╔══██╗██║         ██║ ██╔══██╗██╔══██╗
//  ██║   ██║██║     ██║     ██║   ██║██║   ██║██║  ██║       ██║   █████╗  ██████╔╝██╔████╔██║██║██╔██╗ ██║███████║██║         ██║ ███████║██████╔╝
//  ██║▄▄ ██║██║     ██║     ██║   ██║██║   ██║██║  ██║       ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║██║╚██╗██║██╔══██║██║         ██║ ██╔══██║██╔══██╗
//  ╚██████╔╝╚██████╗███████╗╚██████╔╝╚██████╔╝██████╔╝       ██║   ███████╗██║  ██║██║ ╚═╝ ██║██║██║ ╚████║██║  ██║███████╗    ███████╗██║
//  ██║██████╔╝
//   ╚══▀▀═╝  ╚═════╝╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝        ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝    ╚══════╝╚═╝ ╚═╝╚═════╝
//
//
//                                                                              _             __                 _                _
//                                                                             (_)           / _|               | |              | |
//                                                          ___  ___ _ ____   ___  ___ ___  | |_ ___  _ __    __| | _____   _____| | ___  _ __   ___ _
//                                                          __ ___
//                                                         / __|/ _ \ '__\ \ / / |/ __/ _ \ |  _/ _ \| '__|  / _` |/ _ \ \ / / _ \ |/ _ \| '_ \ / _ \
//                                                         '__/ __|
//                                                         \__ \  __/ |   \ V /| | (_|  __/ | || (_) | |    | (_| |  __/\ V /  __/ | (_) | |_) |  __/
//                                                         |  \__
//                                                         |___/\___|_|    \_/ |_|\___\___| |_| \___/|_|     \__,_|\___| \_/ \___|_|\___/| .__/
//                                                         \___|_|  |___/
//    ______ ______ ______ ______ ______ ______ ______ ______                                                                            | |
//   |______|______|______|______|______|______|______|______|                                                                           |_|
//

#import <Foundation/Foundation.h>
#import <QCloudCore/QCloudCore.h>
#import "QCloudRecognitionEnum.h"
#import "QCloudDocRecognitionResult.h"
NS_ASSUME_NONNULL_BEGIN
/**
 功能描述：
 
 本接口用于提交一个文档审核任务，可审核您的文档文件是否存在敏感违规信息。文档审核结合了对象存储（Cloud Object Storage，COS）文档预览功能，通过预先将文档转成图片，结合图片内容审核、图片 OCR 审核等方式，进行文档审核。
 
 具体请查看：https://cloud.tencent.com/document/product/460/59380
 
 ### 示例
 
 @code
 
        QCloudPostDocRecognitionRequest * request = [[QCloudPostDocRecognitionRequest alloc]init];

        // 对象键，是对象在 COS 上的完整路径，如果带目录的话，格式为 "dir1/object1"
        request.object = @"exampleobject";
        // 存储桶名称，格式为 BucketName-APPID
        request.bucket = @"examplebucket-1250000000";
 
        request.type = @"doc";

        request.regionName = @"regionName";
 
        // 审核类型，拥有 porn（涉黄识别）、terrorist（涉暴恐识别）、politics（涉政识别）、ads（广告识别）四种，
        // 用户可选择多种识别类型，例如 detect-type=porn,ads 表示对图片进行涉黄及广告审核
        // 可以使用或进行组合赋值 如： QCloudRecognitionPorn | QCloudRecognitionTerrorist
        request.detectType = QCloudRecognitionPorn | QCloudRecognitionAds | QCloudRecognitionPolitics | QCloudRecognitionTerrorist;

        // 审核策略，不带审核策略时使用默认策略。具体查看 https://cloud.tencent.com/document/product/460/56345
        request.bizType = BizType;

        request.finishBlock = ^(QCloudPostDocRecognitionResult * outputObject, NSError *error) {
         // outputObject 提交审核反馈信息 包含用于查询的job id，详细字段请查看api文档或者SDK源码
         // QCloudPostDocRecognitionResult 类；
        };
        [[QCloudCOSXMLService defaultCOSXML] PostDocRecognition:request];
 
 */

@interface QCloudPostDocRecognitionRequest : QCloudBizHTTPRequest

/**
 存储在 COS 存储桶中的文件名称，例如在目录 test 中的文件test.doc，则文件名称为 test/test.doc。Object 和 Url 只能选择其中一种。
 */
@property (strong, nonatomic) NSString *object;

/// 文档文件的链接地址，例如 http://www.example.com/doctest.doc，Object 和 Url 只能选择其中一种。
@property (strong, nonatomic) NSString *url;

/// 指定文档文件的类型，如未指定则默认以文件的后缀为类型。
/// 如果文件没有后缀，该字段必须指定，否则会审核失败。例如：doc、docx、ppt、pptx 等
@property (strong, nonatomic) NSString *type;

/// 该字段在审核结果中会返回原始内容，长度限制为512字节。您可以使用该字段对待审核的数据进行唯一业务标识。
@property (strong, nonatomic) NSString *dataId;
/**
 存储桶名
 */
@property (strong, nonatomic) NSString *bucket;

/// 审核类型，拥有 porn（涉黄识别）、terrorist（涉暴恐识别）、politics（涉政识别）、ads（广告识别）四种，
/// 用户可选择多种识别类型，例如 detect-type=porn,ads 表示对图片进行涉黄及广告审核
/// 可以使用或进行组合赋值 如： QCloudRecognitionPorn | QCloudRecognitionTerrorist
@property (assign, nonatomic) QCloudRecognitionEnum detectType;


/// 审核策略，不带审核策略时使用默认策略。具体查看 https://cloud.tencent.com/document/product/460/56345
@property (strong, nonatomic) NSString * bizType;


/// 回调地址，以http://或者https://开头的地址。
@property (strong, nonatomic) NSString * callback;


/**
 设置完成回调。请求完成后会通过该回调来获取结果，如果没有error，那么可以认为请求成功。

 @param finishBlock 请求完成回调
 */
- (void)setFinishBlock:(void (^_Nullable)(QCloudPostDocRecognitionResult *_Nullable result, NSError *_Nullable error))finishBlock;

@end
NS_ASSUME_NONNULL_END
