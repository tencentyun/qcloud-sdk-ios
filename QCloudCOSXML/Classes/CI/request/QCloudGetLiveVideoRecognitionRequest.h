//
//  QCloudGetLiveVideoRecognitionRequest.h
//  QCloudGetLiveVideoRecognitionRequest
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
#import "QCloudVideoRecognitionResult.h"
NS_ASSUME_NONNULL_BEGIN

/**
 功能描述：查询直播审核任务结果
 
 本接口用于主动查询指定的直播审核任务结果。直播审核功能为异步任务方式，您可以通过提交直播审核任务审核您的直播流，然后通过查询直播审核任务接口轮询获取审核结果。
 具体请查看：https://cloud.tencent.com/document/product/460/76265

  @code
 
        QCloudGetLiveVideoRecognitionRequest * request = [[QCloudGetLiveVideoRecognitionRequest alloc]init];

        // 存储桶名称，格式为 BucketName-APPID
        request.bucket = @"examplebucket-1250000000";

        // QCloudPostLiveVideoRecognitionRequest接口返回的jobid
        request.jobId = @"jobid";
 
        request.regionName = @"regionName";
 
        request.finishBlock = ^(QCloudGetVideoRecognitionRequest * outputObject, NSError *error) {
         // outputObject 审核结果 包含用于查询的job id，详细字段请查看api文档或者SDK源码
         // QCloudVideoRecognitionResult 类；
        };
        [[QCloudCOSXMLService defaultCOSXML] GetLiveVideoRecognition:request];

*/
@interface QCloudGetLiveVideoRecognitionRequest : QCloudBizHTTPRequest

/**
 对象名
 */
@property (strong, nonatomic) NSString *jobId;


/// 桶名
@property (strong, nonatomic) NSString *bucket;

/**
 设置完成回调。请求完成后会通过该回调来获取结果，如果没有error，那么可以认为请求成功。
 @param finishBlock 请求完成回调
 */
- (void)setFinishBlock:(void (^_Nullable)(QCloudVideoRecognitionResult *_Nullable result, NSError *_Nullable error))finishBlock;

@end
NS_ASSUME_NONNULL_END
