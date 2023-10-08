//
//  QCloudUpdateSpeechRecognitionTempleteRequest.h
//  QCloudUpdateSpeechRecognitionTempleteRequest
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
#import "QCloudUpdateSpeechRecognitionTempleteResponse.h"

NS_ASSUME_NONNULL_BEGIN
/**

 更新模板.

 ### 功能描述

 更新语音识别模板.

 具体请查看  https://cloud.tencent.com/document/product/460/84759.

### 示例

  @code

	QCloudUpdateSpeechRecognitionTempleteRequest * request = [QCloudUpdateSpeechRecognitionTempleteRequest new];
	request.bucket = @"sample-1250000000";
	request.regionName = @"COS_REGIONNAME";
     QCloudUpdateSpeechRecognitionTemplete * updateSpeechRecognitionTemplete = [QCloudUpdateSpeechRecognitionTemplete new];
    // 模板类型：SpeechRecognition;是否必传：是
    updateSpeechRecognitionTemplete.Tag = @"SpeechRecognition";
    // 模板名称，仅支持中文、英文、数字、_、-和*，长度不超过 64;是否必传：是
    updateSpeechRecognitionTemplete.Name = @"garenwang_test";

    request.TemplateId = @"test";
    request.input = updateSpeechRecognitionTemplete;

    request.input.SpeechRecognition = QCloudSpeechRecognition.new;

    request.input.SpeechRecognition.EngineModelType = @"16k_zh";
    request.input.SpeechRecognition.ChannelNum = @"1";

	[request setFinishBlock:^(QCloudUpdateSpeechRecognitionTempleteResponse * outputObject, NSError *error) {
		// result：QCloudUpdateSpeechRecognitionTempleteResponse 包含所有的响应；
		// 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/84759
	}];
	[[QCloudCOSXMLService defaultCOSXML] UpdateSpeechRecognitionTemplete:request];


*/

@interface QCloudUpdateSpeechRecognitionTempleteRequest : QCloudBizHTTPRequest

/// 存储桶名称
@property (nonatomic,strong)NSString * bucket;

@property (nonatomic,strong)NSString * TemplateId;

/// 请求输入参数
@property (nonatomic,strong)QCloudUpdateSpeechRecognitionTemplete * input;

- (void)setFinishBlock:(void (^_Nullable)( QCloudUpdateSpeechRecognitionTempleteResponse * _Nullable result, NSError *_Nullable error))finishBlock;

@end



NS_ASSUME_NONNULL_END
