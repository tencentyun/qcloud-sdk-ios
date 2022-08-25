//
//  QCloudPostAudioDiscernTaskRequest.h
//  QCloudPostAudioDiscernTaskRequest
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
#import "QCloudPostAudioDiscernTaskInfo.h"
NS_ASSUME_NONNULL_BEGIN
/**
 功能描述：

 接口用于提交一个语音识别任务。
 
 具体请查看：https://cloud.tencent.com/document/product/460/46228
 
 ### 示例
 
 @code
         
         QCloudPostAudioDiscernTaskRequest * request = [[QCloudPostAudioDiscernTaskRequest alloc]init];

         // 存储桶名称，格式为 BucketName-APPID
         request.bucket = @"BucketName-APPID";
         request.regionName = @"regionName";

         QCloudPostAudioDiscernTaskInfo* taskInfo = [QCloudPostAudioDiscernTaskInfo new];
         taskInfo.Tag = @"SpeechRecognition";
         taskInfo.QueueId = @"QueueId";
         // 操作规则
         QCloudPostAudioDiscernTaskInfoInput * input = QCloudPostAudioDiscernTaskInfoInput.new;
         input.Object = @"test1";
         // 待操作的语音文件
         taskInfo.Input = input;
         QCloudPostAudioDiscernTaskInfoOperation * op = [QCloudPostAudioDiscernTaskInfoOperation new];
         QCloudPostAudioDiscernTaskInfoOutput * output = QCloudPostAudioDiscernTaskInfoOutput.new;
         output.Region = @"regionName";
         output.Bucket = @"BucketName-APPID";
         output.Object = @"test";
         // 结果输出地址
         op.Output = output;
         
         QCloudPostAudioDiscernTaskInfoSpeechRecognition * speechRecognition = [QCloudPostAudioDiscernTaskInfoSpeechRecognition new];
         speechRecognition.EngineModelType =@"16k_zh";
         speechRecognition.ChannelNum = 1;
         speechRecognition.ResTextFormat = 0;
         speechRecognition.ConvertNumMode = 0;
         // 当 Tag 为 SpeechRecognition 时有效，指定该任务的参数
         op.SpeechRecognition = speechRecognition;
         // 操作规则
         taskInfo.Operation = op;
         //  语音识别任务
         request.taskInfo = taskInfo;
         
         [request setFinishBlock:^(QCloudPostAudioDiscernTaskResult * _Nullable result, NSError * _Nullable error) {
             // outputObject 提交审核反馈信息 包含用于查询的job id，详细字段请查看api文档或者SDK源码
             // QCloudPostAudioDiscernTaskResult 类；
         }];
         [[QCloudCOSXMLService defaultCOSXML] PostAudioDiscernTask:request];
 
 */

@interface QCloudPostAudioDiscernTaskRequest : QCloudBizHTTPRequest

/**
 存储桶名
 */
@property (strong, nonatomic) NSString *bucket;

/**
 语音识别任务
 */
@property (strong, nonatomic) QCloudPostAudioDiscernTaskInfo *taskInfo;

/**
 设置完成回调。请求完成后会通过该回调来获取结果，如果没有error，那么可以认为请求成功。

 @param finishBlock 请求完成回调
 */
- (void)setFinishBlock:(void (^_Nullable)(QCloudPostAudioDiscernTaskResult *_Nullable result, NSError *_Nullable error))finishBlock;

@end
NS_ASSUME_NONNULL_END
