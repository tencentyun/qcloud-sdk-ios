//
//  QCloudPostSpeechRecognitionRequest.h
//  QCloudPostSpeechRecognitionRequest
//
//  Created by tencent
//  Copyright (c) 2015年 tencent. All rights reserved.
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
#import <QCloudCore/QCloudBizHTTPRequest.h>
#import "QCloudPostSpeechRecognitionResponse.h"

NS_ASSUME_NONNULL_BEGIN
/**

 提交任务.

 ### 功能描述

 提交一个语音识别任务.

 具体请查看  https://cloud.tencent.com/document/product/460/84798.

### 示例

  @code

	QCloudPostSpeechRecognitionRequest * request = [QCloudPostSpeechRecognitionRequest new];
	request.bucket = @"sample-1250000000";
	request.regionName = @"COS_REGIONNAME";
 
    QCloudPostSpeechRecognition * postSpeechRecognition = [QCloudPostSpeechRecognition new];
    // 创建任务的 Tag：SpeechRecognition;是否必传：是
    postSpeechRecognition.Tag = @"SpeechRecognition";
    // 待操作的对象信息;是否必传：是
    QCloudPostSpeechRecognitionInput * input = [QCloudPostSpeechRecognitionInput new];
    input.Object = @"1347199842654.jpg";
    postSpeechRecognition.Input = input;

    // 操作规则;是否必传：是
    QCloudPostSpeechRecognitionOperation * operation = [QCloudPostSpeechRecognitionOperation new];
    // 结果输出配置;是否必传：是
    QCloudPostSpeechRecognitionOutput * output = [QCloudPostSpeechRecognitionOutput new];
    // 存储桶的地域;是否必传：是
    output.Region = @"ap-nanjing";
    // 存储结果的存储桶;是否必传：是
    output.Bucket = @"000garenwang-1253960454";
    // 结果文件的名称;是否必传：是
    output.Object = @"target_1347199842654.jpg";

    operation.Output = output;

    QCloudSpeechRecognition * peechRecognition = [QCloudSpeechRecognition new];
    operation.SpeechRecognition = peechRecognition;
    peechRecognition.EngineModelType = @"8k_zh";
    peechRecognition.ChannelNum = @"1";
    postSpeechRecognition.Operation = operation;

    request.input = postSpeechRecognition;

	[request setFinishBlock:^(QCloudPostSpeechRecognitionResponse * outputObject, NSError *error) {
		// result：QCloudPostSpeechRecognitionResponse 包含所有的响应；
		// 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/84798
        // outputObject返回JobId，使用QCloudGetMediaJobRequest 查询结果
	}];
	[[QCloudCOSXMLService defaultCOSXML] PostSpeechRecognition:request];


*/

@interface QCloudPostSpeechRecognitionRequest : QCloudBizHTTPRequest

/// 存储桶名称
@property (nonatomic,strong)NSString * bucket;

/// 请求输入参数
@property (nonatomic,strong)QCloudPostSpeechRecognition * input;

- (void)setFinishBlock:(void (^_Nullable)( QCloudPostSpeechRecognitionResponse * _Nullable result, NSError *_Nullable error))finishBlock;

@end



NS_ASSUME_NONNULL_END
