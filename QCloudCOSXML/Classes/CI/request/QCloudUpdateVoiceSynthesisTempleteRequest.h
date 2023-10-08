//
//  QCloudUpdateVoiceSynthesisTempleteRequest.h
//  QCloudUpdateVoiceSynthesisTempleteRequest
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
#import "QCloudUpdateVoiceSynthesisTempleteResponse.h"

NS_ASSUME_NONNULL_BEGIN
/**

 更新模板.

 ### 功能描述

 更新语音合成模板.

 具体请查看  https://cloud.tencent.com/document/product/460/84758.

### 示例

  @code

	QCloudUpdateVoiceSynthesisTempleteRequest * request = [QCloudUpdateVoiceSynthesisTempleteRequest new];
	request.bucket = @"sample-1250000000";
	request.regionName = @"COS_REGIONNAME";
     QCloudUpdateVoiceSynthesisTemplete * updateVoiceSynthesisTemplete = [QCloudUpdateVoiceSynthesisTemplete new];
    // 模板类型：Tts;是否必传：是
    updateVoiceSynthesisTemplete.Tag = @"Tts";
    // 模板名称，仅支持中文、英文、数字、_、-和*，长度不超过 64;是否必传：是
    updateVoiceSynthesisTemplete.Name = @"garenwang_test";

    request.TemplateId = @"test";

    request.input = updateVoiceSynthesisTemplete;

	[request setFinishBlock:^(QCloudUpdateVoiceSynthesisTempleteResponse * outputObject, NSError *error) {
		// result：QCloudUpdateVoiceSynthesisTempleteResponse 包含所有的响应；
		// 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/84758
	}];
	[[QCloudCOSXMLService defaultCOSXML] UpdateVoiceSynthesisTemplete:request];


*/

@interface QCloudUpdateVoiceSynthesisTempleteRequest : QCloudBizHTTPRequest

/// 存储桶名称
@property (nonatomic,strong)NSString * bucket;

@property (nonatomic,strong)NSString * TemplateId;

/// 请求输入参数
@property (nonatomic,strong)QCloudUpdateVoiceSynthesisTemplete * input;

- (void)setFinishBlock:(void (^_Nullable)( QCloudUpdateVoiceSynthesisTempleteResponse * _Nullable result, NSError *_Nullable error))finishBlock;

@end



NS_ASSUME_NONNULL_END
