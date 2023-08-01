//
//  QCloudGetDiscernMediaJobsRequest.h
//  QCloudGetDiscernMediaJobsRequest
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
#import "QCloudGetAudioDiscernTaskResult.h"
#import "QCloudRecognitionEnum.h"
NS_ASSUME_NONNULL_BEGIN

/**
 功能描述：

 用于拉取符合条件的语音识别任务。
 具体请查看：https://cloud.tencent.com/document/product/436/76946

  @code
 
        QCloudGetDiscernMediaJobsRequest * request = [[QCloudGetDiscernMediaJobsRequest alloc]init];

        // 存储桶名称，格式为 BucketName-APPID
        request.bucket = @"examplebucket-1250000000";
 
        request.regionName = @"regionName";
 
        request.states = QCloudTaskStatesAll;
 
        // 其他更多参数请查阅sdk文档或源码注释
 
        request.finishBlock = ^(QCloudBatchGetAudioDiscernTaskResult * outputObject, NSError *error) {
         // outputObject 任务结果，详细字段请查看api文档或者SDK源码
         // QCloudBatchGetAudioDiscernTaskResult 类；
        };
        [[QCloudCOSXMLService defaultCOSXML] getDiscernMediaJobs:request];

*/
@interface QCloudGetDiscernMediaJobsRequest : QCloudBizHTTPRequest


/// 拉取该队列 ID 下的任务。
@property (strong, nonatomic) NSString *queueId;

/// 任务的 Tag 具体请参考：https://cloud.tencent.com/document/product/436/76946
@property (strong, nonatomic) NSString *tag;

/// 0:Desc  ,1:Asc。默认为 Desc。
@property (assign, nonatomic) NSInteger orderByTime;

/// 请求的上下文，用于翻页。上次返回的值。
@property (strong, nonatomic) NSString *nextToken;

/// 拉取的最大任务数。默认为10。最大为100。
@property (assign, nonatomic) NSInteger size;

/// QCloudTaskStatesEnum 默认为 QCloudTaskStatesAll。
@property (assign, nonatomic) QCloudTaskStatesEnum  states;

/// 拉取创建时间大于该时间的任务。格式为：%Y-%m-%dT%H:%m:%S%z
@property (strong, nonatomic) NSString *startCreationTime;

/// 拉取创建时间小于该时间的任务。格式为：%Y-%m-%dT%H:%m:%S%z
@property (strong, nonatomic) NSString *endCreationTime;

/// 桶名
@property (strong, nonatomic) NSString *bucket;

/// 触发该任务的工作流ID
@property (strong, nonatomic) NSString *workflowId;

/// 触发该任务的存量触发任务 ID
@property (strong, nonatomic) NSString *inventoryTriggerJobId;

/// 该任务的输入文件名，暂仅支持精确匹配
@property (strong, nonatomic) NSString *inputObject;

/**
 设置完成回调。请求完成后会通过该回调来获取结果，如果没有error，那么可以认为请求成功。
 @param finishBlock 请求完成回调
 */
- (void)setFinishBlock:(void (^_Nullable)(QCloudBatchGetAudioDiscernTaskResult *_Nullable result, NSError *_Nullable error))finishBlock;

@end
NS_ASSUME_NONNULL_END
