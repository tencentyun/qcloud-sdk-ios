//
//  QCloudPostVoiceSeparateTempleteRequest.h
//  QCloudPostVoiceSeparateTempleteRequest
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
#import "QCloudPostVoiceSeparateTempleteResponse.h"

NS_ASSUME_NONNULL_BEGIN
/**

 创建模板.

 ### 功能描述

 创建人声分离模板.

 具体请查看  https://cloud.tencent.com/document/product/460/84500.

### 示例

  @code

	QCloudPostVoiceSeparateTempleteRequest * request = [QCloudPostVoiceSeparateTempleteRequest new];
	request.bucket = @"sample-1250000000";
	request.regionName = @"COS_REGIONNAME";
 
    QCloudPostVoiceSeparateTemplete * postVoiceSeparateTemplete = [QCloudPostVoiceSeparateTemplete new];
    // 模板类型: VoiceSeparate;是否必传：是
    postVoiceSeparateTemplete.Tag = @"VoiceSeparate";
    // 模板名称，仅支持中文、英文、数字、_、-和*，长度不超过 64;是否必传：是
    postVoiceSeparateTemplete.Name = @"garenwang_test";
    // 输出音频IsAudio：输出人声IsBackground：输出背景声AudioAndBackground：输出人声和背景声MusicMode：输出人声、背景声、Bass声、鼓声;是否必传：是
    postVoiceSeparateTemplete.AudioMode = @"IsAudio";

    QCloudAudioConfig * audioConfig = [QCloudAudioConfig new];
    audioConfig.Codec = @"mp3";
    audioConfig.Samplerate = @"22050";
    postVoiceSeparateTemplete.AudioConfig = audioConfig;

    request.input = postVoiceSeparateTemplete;

	[request setFinishBlock:^(QCloudPostVoiceSeparateTempleteResponse * outputObject, NSError *error) {
		// result：QCloudPostVoiceSeparateTempleteResponse 包含所有的响应；
		// 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/84500
	}];
	[[QCloudCOSXMLService defaultCOSXML] PostVoiceSeparateTemplete:request];


*/

@interface QCloudPostVoiceSeparateTempleteRequest : QCloudBizHTTPRequest

/// 存储桶名称
@property (nonatomic,strong)NSString * bucket;

/// 请求输入参数
@property (nonatomic,strong)QCloudPostVoiceSeparateTemplete * input;

- (void)setFinishBlock:(void (^_Nullable)( QCloudPostVoiceSeparateTempleteResponse * _Nullable result, NSError *_Nullable error))finishBlock;

@end



NS_ASSUME_NONNULL_END
