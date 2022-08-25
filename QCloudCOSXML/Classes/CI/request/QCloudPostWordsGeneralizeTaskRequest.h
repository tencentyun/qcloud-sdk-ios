//
//  QCloudPostWordsGeneralizeTaskRequest.h
//  QCloudPostWordsGeneralizeTaskRequest
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
#import "QCloudWordsGeneralizeResult.h"
#import "QCloudWordsGeneralizeInput.h"
NS_ASSUME_NONNULL_BEGIN
/**
 功能描述：

 接口用于提交一个提交分词任务。
 
 具体请查看：https://cloud.tencent.com/document/product/436/79491
 
 ### 示例
 
 @code
         
    QCloudPostWordsGeneralizeTaskRequest * request = [[QCloudPostWordsGeneralizeTaskRequest alloc]init];

    // 存储桶名称，格式为 BucketName-APPID
    request.bucket = @"examplebucket-1250000000";

    request.regionName = @"regionName";
    // 创建分词任务对象
    QCloudWordsGeneralizeInput * taskInfo = [QCloudWordsGeneralizeInput new];

    // 设置要处理的文件
    taskInfo.Input = [QCloudWordsGeneralizeInputObject new];
    taskInfo.Input.Object = @"aaa.m4a";

    taskInfo.Tag = @"WordsGeneralize";
 
    // QCloudGetAIJobQueueRequest 接口获取
    taskInfo.QueueId = @"QueueId";

    taskInfo.Operation = [QCloudWordsGeneralizeInputOperation new];
    taskInfo.Operation.WordsGeneralize = [QCloudWordsGeneralizeInputGeneralize new];
    taskInfo.Operation.WordsGeneralize.NerMethod = @"DL";
    taskInfo.Operation.WordsGeneralize.SegMethod = @"SegBasic";

    //  分词任务
    request.taskInfo = taskInfo;

    [request setFinishBlock:^(QCloudWordsGeneralizeResult * _Nullable result, NSError * _Nullable error) {
     // result 包含用于查询的job id，详细字段请查看api文档或者SDK源码
     // QCloudWordsGeneralizeResult 类；
    }];
    [[QCloudCOSXMLService defaultCOSXML] PostWordsGeneralizeTask:request];
 
 */

@interface QCloudPostWordsGeneralizeTaskRequest : QCloudBizHTTPRequest

/**
 存储桶名
 */
@property (strong, nonatomic) NSString *bucket;

/**
 任务信息
 */
@property (strong, nonatomic) QCloudWordsGeneralizeInput * taskInfo;

/**
 设置完成回调。请求完成后会通过该回调来获取结果，如果没有error，那么可以认为请求成功。

 @param finishBlock 请求完成回调
 */
- (void)setFinishBlock:(void (^_Nullable)(QCloudWordsGeneralizeResult *_Nullable result, NSError *_Nullable error))finishBlock;

@end
NS_ASSUME_NONNULL_END
