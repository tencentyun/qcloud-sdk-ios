//
//  QCloudBatchimageRecognitionRequest.h
//  QCloudBatchimageRecognitionRequest
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
#import "QCloudBatchImageRecognitionResult.h"

@class QCloudBatchRecognitionImageInfo;
@class QCloudBatchImageRecognitionResult;
NS_ASSUME_NONNULL_BEGIN
/**
 功能描述：
 
 图片批量审核接口为同步请求方式，您可以通过本接口对多个图片文件进行内容审核。该接口属于 POST 请求。

 支持根据不同的业务场景配置自定义的审核策略。
 
 具体请查看：https://cloud.tencent.com/document/product/460/63594
 
 ### 示例
 
 @code
 
     QCloudBatchimageRecognitionRequest * request = [[QCloudBatchimageRecognitionRequest alloc]init];
     request.bucket = @"examplebucket-1250000000";
     request.regionName = @"region";
     NSMutableArray * input = [NSMutableArray new];
     
     QCloudBatchRecognitionImageInfo * input1 = [QCloudBatchRecognitionImageInfo new];
     input1.Object = @"***.jpg";
     [input addObject:input1];
     
     QCloudBatchRecognitionImageInfo * input2 = [QCloudBatchRecognitionImageInfo new];
     input2.Object = @"***.jpg";
     [input addObject:input2];
     
     request.input = input;
     request.detectType = QCloudRecognitionPorn | QCloudRecognitionTerrorist | QCloudRecognitionPolitics | QCloudRecognitionAds;
     [request setFinishBlock:^(QCloudBatchImageRecognitionResult * _Nullable result, NSError * _Nullable error) {

     }];
     [[QCloudCOSXMLService defaultCOSXML] BatchImageRecognition:request];
 
 
 */

@interface QCloudBatchimageRecognitionRequest : QCloudBizHTTPRequest


/// 存储桶名
@property (strong, nonatomic) NSString *bucket;

/// 需要审核的内容，如有多个图片，请传入多个 Input 结构。
@property (nonatomic,strong)NSArray <QCloudBatchRecognitionImageInfo *> * input;

/// 审核类型，拥有 porn（涉黄识别）、terrorist（涉暴恐识别）、politics（涉政识别）、ads（广告识别）四种，
/// 用户可选择多种识别类型，例如 detect-type=porn,ads 表示对图片进行涉黄及广告审核
/// 可以使用或进行组合赋值 如： QCloudRecognitionPorn | QCloudRecognitionTerrorist
@property (assign, nonatomic) QCloudRecognitionEnum detectType;


/// 审核策略，不带审核策略时使用默认策略。具体查看 https://cloud.tencent.com/document/product/460/56345
@property (strong, nonatomic) NSString * bizType;


/**
 设置完成回调。请求完成后会通过该回调来获取结果，如果没有error，那么可以认为请求成功。

 @param finishBlock 请求完成回调
 */
- (void)setFinishBlock:(void (^_Nullable)(QCloudBatchImageRecognitionResult *_Nullable result, NSError *_Nullable error))finishBlock;

@end
NS_ASSUME_NONNULL_END
