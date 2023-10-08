//
//  QCloudPostVoiceSynthesisRequest.h
//  QCloudPostVoiceSynthesisRequest
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
#import "QCloudPostVoiceSynthesisResponse.h"

NS_ASSUME_NONNULL_BEGIN
/**

 提交任务.

 ### 功能描述

 提交一个语音合成任务.

 具体请查看  https://cloud.tencent.com/document/product/460/84797.

### 示例

  @code

	QCloudPostVoiceSynthesisRequest * request = [QCloudPostVoiceSynthesisRequest new];
	request.bucket = @"sample-1250000000";
	request.regionName = @"COS_REGIONNAME";
 
     QCloudPostVoiceSynthesis * postVoiceSynthesis = [QCloudPostVoiceSynthesis new];
     request.input = postVoiceSynthesis;
     
     // 创建任务的 Tag：Tts;是否必传：是
     postVoiceSynthesis.Tag = @"Tts";
     // 操作规则;是否必传：是
     QCloudPostVoiceSynthesisOperation * operation = [QCloudPostVoiceSynthesisOperation new];
     postVoiceSynthesis.Operation = operation;
     
     // 语音合成任务参数;是否必传：是
     QCloudPostVoiceSynthesisTtsConfig * ttsConfig = [QCloudPostVoiceSynthesisTtsConfig new];
     operation.TtsConfig = ttsConfig;
     
     // 输入类型，Url/Text;是否必传：是
     ttsConfig.InputType = @"Text";
     // 当 InputType 为 Url 时， 必须是合法的 COS 地址，文件必须是utf-8编码，且大小不超过 10M。如果合成方式为同步处理，则文件内容不超过 300 个 utf-8 字符；如果合成方式为异步处理，则文件内容不超过 10000 个 utf-8 字符。当 InputType 为 Text 时, 输入必须是 utf-8 字符, 且不超过 300 个字符。;是否必传：是
     ttsConfig.Input = @"测试文字";
     // 结果输出配置;是否必传：是
      QCloudPostVoiceSynthesisOutput * output = [QCloudPostVoiceSynthesisOutput new];
     // 存储桶的地域;是否必传：是
     output.Region = @"ap-chongqing";
     // 存储结果的存储桶;是否必传：是
     output.Bucket = @"tinna-media-1253960454";
     // 结果文件名;是否必传：是
     output.Object = @"target_voice.txt";
     operation.Output = output;
     
     QCloudPostVoiceSynthesisTtsTpl * ttsTpl = [QCloudPostVoiceSynthesisTtsTpl new];
     ttsTpl.Mode = @"Sync";
     ttsTpl.Codec = @"mp3";
     operation.TtsTpl = ttsTpl;

	[request setFinishBlock:^(QCloudPostVoiceSynthesisResponse * outputObject, NSError *error) {
		// result：QCloudPostVoiceSynthesisResponse 包含所有的响应；
		// 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/84797
        // outputObject返回JobId，使用QCloudGetMediaJobRequest 查询结果
	}];
	[[QCloudCOSXMLService defaultCOSXML] PostVoiceSynthesis:request];


*/

@interface QCloudPostVoiceSynthesisRequest : QCloudBizHTTPRequest

/// 存储桶名称
@property (nonatomic,strong)NSString * bucket;

/// 请求输入参数
@property (nonatomic,strong)QCloudPostVoiceSynthesis * input;

- (void)setFinishBlock:(void (^_Nullable)( QCloudPostVoiceSynthesisResponse * _Nullable result, NSError *_Nullable error))finishBlock;

@end



NS_ASSUME_NONNULL_END
