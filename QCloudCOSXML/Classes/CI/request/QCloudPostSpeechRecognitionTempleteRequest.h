//
//  QCloudPostSpeechRecognitionTempleteRequest.h
//  QCloudPostSpeechRecognitionTempleteRequest
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
#import "QCloudPostSpeechRecognitionTempleteResponse.h"

NS_ASSUME_NONNULL_BEGIN
/**

 创建模板.

 ### 功能描述

 创建语音识别模板.

 具体请查看  https://cloud.tencent.com/document/product/460/84498.

### 示例

  @code

	QCloudPostSpeechRecognitionTempleteRequest * request = [QCloudPostSpeechRecognitionTempleteRequest new];
	request.bucket = @"sample-1250000000";
	request.regionName = @"COS_REGIONNAME";
 
     QCloudPostSpeechRecognitionTemplete * postSpeechRecognitionTemplete = [QCloudPostSpeechRecognitionTemplete new];
     // 模板类型：SpeechRecognition;是否必传：是
     postSpeechRecognitionTemplete.Tag = @"SpeechRecognition";
     // 模板名称，仅支持中文、英文、数字、_、-和*，长度不超过 64;是否必传：是
     postSpeechRecognitionTemplete.Name = @"garenwang_test";

     QCloudSpeechRecognition * speechRecognition = [QCloudSpeechRecognition new];
     speechRecognition.EngineModelType = @"8k_zh";
     speechRecognition.ChannelNum = @"1";
     postSpeechRecognitionTemplete.SpeechRecognition = speechRecognition;
     
     request.input = postSpeechRecognitionTemplete;
	[request setFinishBlock:^(QCloudPostSpeechRecognitionTempleteResponse * outputObject, NSError *error) {
		// result：QCloudPostSpeechRecognitionTempleteResponse 包含所有的响应；
		// 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/84498
	}];
	[[QCloudCOSXMLService defaultCOSXML] PostSpeechRecognitionTemplete:request];


*/

@interface QCloudPostSpeechRecognitionTempleteRequest : QCloudBizHTTPRequest

/// 存储桶名称
@property (nonatomic,strong)NSString * bucket;

/// 请求输入参数
@property (nonatomic,strong)QCloudPostSpeechRecognitionTemplete * input;

- (void)setFinishBlock:(void (^_Nullable)( QCloudPostSpeechRecognitionTempleteResponse * _Nullable result, NSError *_Nullable error))finishBlock;

@end



NS_ASSUME_NONNULL_END
