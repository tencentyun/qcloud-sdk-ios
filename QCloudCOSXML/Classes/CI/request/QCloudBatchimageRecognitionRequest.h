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
#import "QCloudBatchRecognitionUserInfo.h"

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
     [request setFinishBlock:^(QCloudBatchImageRecognitionResult * _Nullable result, NSError * _Nullable error) {

     }];
     [[QCloudCOSXMLService defaultCOSXML] BatchImageRecognition:request];
 
 
 */

@interface QCloudBatchimageRecognitionRequest : QCloudBizHTTPRequest


/// 存储桶名
@property (strong, nonatomic) NSString *bucket;

/// 需要审核的内容，如有多个图片，请传入多个 Input 结构。
@property (nonatomic,strong)NSArray <QCloudBatchRecognitionImageInfo *> * input;

/// 审核策略，不带审核策略时使用默认策略。具体查看 https://cloud.tencent.com/document/product/460/56345
@property (strong, nonatomic) NSString * bizType;


/// 是否异步进行审核，取值 0：同步返回结果，1：异步进行审核，默认为0。
@property (assign,nonatomic)BOOL async;

/// 审核结果（Detail版本）以回调形式发送至您的回调地址，异步审核时生效，支持以 http:// 或者 https:// 开头的地址，例如： http://www.callback.com。
@property (strong, nonatomic) NSString * callback;

/// 回调片段类型，有效值：1（回调全部音频片段）、2（回调违规音频片段）。默认为 1。
@property (assign, nonatomic) NSInteger callbackType;

/// 取值为[0,100]，表示当色情审核结果大于或等于该分数时，自动进行冻结操作。不填写则表示不自动冻结，默认值为空。
@property (assign, nonatomic) NSInteger pornScore;

/// 取值为[0,100]，表示当广告审核结果大于或等于该分数时，自动进行冻结操作。不填写则表示不自动冻结，默认值为空。
@property (assign, nonatomic) NSInteger adsScore;

/// 取值为[0,100]，表示当恐怖审核结果大于或等于该分数时，自动进行冻结操作。不填写则表示不自动冻结，默认值为空。
@property (assign, nonatomic) NSInteger terrorismScore;

/// 取值为[0,100]，表示当涉政审核结果大于或等于该分数时，自动进行冻结操作。不填写则表示不自动冻结，默认值为空。
@property (assign, nonatomic) NSInteger politicsScore;

/**
 设置完成回调。请求完成后会通过该回调来获取结果，如果没有error，那么可以认为请求成功。

 @param finishBlock 请求完成回调
 */
- (void)setFinishBlock:(void (^_Nullable)(QCloudBatchImageRecognitionResult *_Nullable result, NSError *_Nullable error))finishBlock;

@end
NS_ASSUME_NONNULL_END
