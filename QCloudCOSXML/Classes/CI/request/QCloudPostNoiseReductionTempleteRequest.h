//
//  QCloudPostNoiseReductionTempleteRequest.h
//  QCloudPostNoiseReductionTempleteRequest
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
#import "QCloudPostNoiseReductionTempleteResponse.h"

NS_ASSUME_NONNULL_BEGIN
/**

 创建模板.

 ### 功能描述

 创建音频降噪模板.

 具体请查看  https://cloud.tencent.com/document/product/460/94315.

### 示例

  @code

	QCloudPostNoiseReductionTempleteRequest * request = [QCloudPostNoiseReductionTempleteRequest new];
	request.bucket = @"sample-1250000000";
	request.regionName = @"COS_REGIONNAME";
 
    QCloudPostNoiseReductionTemplete * postNoiseReductionTemplete = [QCloudPostNoiseReductionTemplete new];
    // 固定值：NoiseReduction;是否必传：是
    postNoiseReductionTemplete.Tag = @"NoiseReduction";
    // 模板名称，仅支持中文、英文、数字、_、-和*，长度不超过 64。;是否必传：是
    postNoiseReductionTemplete.Name = @"garenwang";

    QCloudNoiseReduction * noiseReduction = [QCloudNoiseReduction new];
    noiseReduction.Format = @"mp3";
    noiseReduction.Samplerate = @"8000";
    postNoiseReductionTemplete.NoiseReduction = noiseReduction;
    request.input = postNoiseReductionTemplete;

	[request setFinishBlock:^(QCloudPostNoiseReductionTempleteResponse * outputObject, NSError *error) {
		// result：QCloudPostNoiseReductionTempleteResponse 包含所有的响应；
		// 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/94315
	}];
	[[QCloudCOSXMLService defaultCOSXML] PostNoiseReductionTemplete:request];


*/

@interface QCloudPostNoiseReductionTempleteRequest : QCloudBizHTTPRequest

/// 存储桶名称
@property (nonatomic,strong)NSString * bucket;

/// 请求输入参数
@property (nonatomic,strong)QCloudPostNoiseReductionTemplete * input;

- (void)setFinishBlock:(void (^_Nullable)( QCloudPostNoiseReductionTempleteResponse * _Nullable result, NSError *_Nullable error))finishBlock;

@end



NS_ASSUME_NONNULL_END
