//
//  QCloudUpdateAudioDiscernTaskQueueRequest.h
//  QCloudUpdateAudioDiscernTaskQueueRequest
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
#import "QCloudAudioAsrqueueResult.h"
NS_ASSUME_NONNULL_BEGIN

/**
 功能描述：

 更新语音识别队列。
 具体请查看：https://cloud.tencent.com/document/product/460/46235

  @code
 
        QCloudUpdateAudioDiscernTaskQueueRequest * request = [[QCloudUpdateAudioDiscernTaskQueueRequest alloc]init];

        // 存储桶名称，格式为 BucketName-APPID
        request.bucket = @"examplebucket-1250000000";
 
        request.regionName = @"regionName";
 
        request.name = @"name";
        /// 1. Active 表示队列内的作业会被语音识别服务调度执行
        /// 2. Paused 表示队列暂停，作业不再会被语音识别服务调度执行，队列内的所有作业状态维持在暂停状态，已经处于识别中的任务将继续执行，不受影响
        request.state = 1;
 
        request.queueID = @"queueID";
 
        // 其他更多参数请查看sdk文档或源码注释
 
        request.finishBlock = ^(QCloudAudioAsrqueueUpdateResult * outputObject, NSError *error) {
         // outputObject 详细字段请查看api文档或者SDK源码
         // QCloudAudioAsrqueueUpdateResult 类；
        };
        [[QCloudCOSXMLService defaultCOSXML] UpdateAudioDiscernTaskQueue:request];

*/
@interface QCloudUpdateAudioDiscernTaskQueueRequest : QCloudBizHTTPRequest


/// 模板名称
@property (strong, nonatomic) NSString *name;

/// 1. Active 表示队列内的作业会被语音识别服务调度执行
/// 2. Paused 表示队列暂停，作业不再会被语音识别服务调度执行，队列内的所有作业状态维持在暂停状态，已经处于识别中的任务将继续执行，不受影响
@property (assign, nonatomic) NSInteger state;

/// 管道 ID
@property (strong, nonatomic) NSString *queueID;

/// 回调配置    String    否    长度限制100字符
@property (strong, nonatomic) NSString *notifyConfigUrl;

/// 回调类型，普通回调：Url    String    否    长度限制100字符
@property (strong, nonatomic) NSString *notifyConfigType;

/// 回调事件    String    否    长度限制100字符
@property (strong, nonatomic) NSString *notifyConfigEvent;

/// 回调开关，0:Off，1:On
@property (assign, nonatomic) NSInteger notifyConfigState;

/// 桶名
@property (strong, nonatomic) NSString *bucket;

/**
 设置完成回调。请求完成后会通过该回调来获取结果，如果没有error，那么可以认为请求成功。
 @param finishBlock 请求完成回调
 */
- (void)setFinishBlock:(void (^_Nullable)(QCloudAudioAsrqueueUpdateResult *_Nullable result, NSError *_Nullable error))finishBlock;

@end
NS_ASSUME_NONNULL_END
