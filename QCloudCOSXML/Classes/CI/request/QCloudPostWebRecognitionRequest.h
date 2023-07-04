//
//  QCloudPostWebRecognitionRequest.h
//  QCloudPostWebRecognitionRequest
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
#import "QCloudWebRecognitionResult.h"
#import "QCloudBatchRecognitionUserInfo.h"
NS_ASSUME_NONNULL_BEGIN
/**
 功能描述：
 
 本接口用于提交一个文档审核任务，可审核您的文档文件是否存在敏感违规信息。文档审核结合了对象存储（Cloud Object Storage，COS）文档预览功能，通过预先将文档转成图片，结合图片内容审核、图片 OCR 审核等方式，进行文档审核。
 
 具体请查看：https://cloud.tencent.com/document/product/460/63968
 
 ### 示例
 
 @code
 
        QCloudPostWebRecognitionRequest * request = [[QCloudPostWebRecognitionRequest alloc]init];

        // 存储桶名称，格式为 BucketName-APPID
        request.bucket = @"examplebucket-1250000000";
 
        request.regionName = @"regionName";
 
        request.url = @"www.****.com";
        // 审核类型，拥有 porn（涉黄识别）、terrorist（涉暴恐识别）、politics（涉政识别）、ads（广告识别）四种，
        // 用户可选择多种识别类型，例如 detect-type=porn,ads 表示对图片进行涉黄及广告审核
        // 可以使用或进行组合赋值 如： QCloudRecognitionPorn | QCloudRecognitionTerrorist

        // 审核策略，不带审核策略时使用默认策略。具体查看 https://cloud.tencent.com/document/product/460/56345
        request.bizType = BizType;

        request.finishBlock = ^(QCloudPostWebRecognitionResult * outputObject, NSError *error) {
         // outputObject 提交审核反馈信息 包含用于查询的job id，详细字段请查看api文档或者SDK源码
         // QCloudPostWebRecognitionResult 类；
        };
        [[QCloudCOSXMLService defaultCOSXML] PostWebRecognition:request];
 
 */

@interface QCloudPostWebRecognitionRequest : QCloudBizHTTPRequest


/// 文档文件的链接地址，例如 http://www.example.com/doctest.doc，Object 和 Url 只能选择其中一种。
@property (strong, nonatomic) NSString *url;
/**
 存储桶名
 */
@property (strong, nonatomic) NSString *bucket;

/// 审核策略，不带审核策略时使用默认策略。具体查看 https://cloud.tencent.com/document/product/460/56345
@property (strong, nonatomic) NSString * bizType;

/// 该字段在审核结果中会返回原始内容，长度限制为512字节。您可以使用该字段对待审核的数据进行唯一业务标识。
@property (strong, nonatomic) NSString * dataId;

/// 回调地址，以http://或者https://开头的地址。
@property (strong, nonatomic) NSString * callback;

/// 回调片段类型，有效值：1（回调全部截帧和音频片段）、2（仅回调违规截帧和音频片段）。默认为 1。
@property (assign, nonatomic) NSInteger callbackType;

/// 用户业务字段。
@property (strong, nonatomic) QCloudBatchRecognitionUserInfo * userInfo;

/// 指定是否需要高亮展示网页内的违规文本，查询及回调结果时会根据此参数决定是否返回高亮展示的 html 内容。取值为 true 或者 false，默认为 false。
@property (assign, nonatomic) BOOL returnHighlightHtml;

/**
 设置完成回调。请求完成后会通过该回调来获取结果，如果没有error，那么可以认为请求成功。

 @param finishBlock 请求完成回调
 */
- (void)setFinishBlock:(void (^_Nullable)(QCloudPostWebRecognitionResult *_Nullable result, NSError *_Nullable error))finishBlock;

@end
NS_ASSUME_NONNULL_END
