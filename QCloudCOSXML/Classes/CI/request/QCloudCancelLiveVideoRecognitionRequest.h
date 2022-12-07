//
//  QCloudCancelLiveVideoRecognitionRequest.h
//  QCloudCancelLiveVideoRecognitionRequest
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
 功能描述：
 
 本接口用于取消一个在进行中的直播审核任务，成功取消后将返回已终止任务的 JobID。
 
 具体请查看：https://cloud.tencent.com/document/product/460/76262
 
 ### 示例
 
 @code
 
    QCloudCancelLiveVideoRecognitionRequest * request = [[QCloudCancelLiveVideoRecognitionRequest alloc]init];

     // 存储桶名称，格式为 BucketName-APPID
     request.bucket = @"examplebucket-1250000000";

     // QCloudPostLiveVideoRecognitionRequest接口返回的jobid
     request.jobId = @"jobid";

     request.regionName = @"regionName";

     request.finishBlock = ^(QCloudPostVideoRecognitionResult * outputObject, NSError *error) {
      // outputObject 审核结果 包含用于查询的job id，详细字段请查看api文档或者SDK源码
      // QCloudPostVideoRecognitionResult 类；
     };
    [[QCloudCOSXMLService defaultCOSXML] CancelLiveVideoRecognition:request];

*/

@interface QCloudCancelLiveVideoRecognitionRequest : QCloudBizHTTPRequest

/**
存储桶名
*/
@property (strong, nonatomic) NSString *bucket;

@property (strong, nonatomic) NSString *jobId;

/**
设置完成回调。请求完成后会通过该回调来获取结果，如果没有error，那么可以认为请求成功。
@param finishBlock 请求完成回调
*/
- (void)setFinishBlock:(void (^_Nullable)(QCloudPostVideoRecognitionResult *_Nullable result, NSError *_Nullable error))finishBlock;

@end

NS_ASSUME_NONNULL_END
