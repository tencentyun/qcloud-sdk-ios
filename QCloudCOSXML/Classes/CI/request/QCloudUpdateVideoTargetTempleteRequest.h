//
//  QCloudUpdateVideoTargetTempleteRequest.h
//  QCloudUpdateVideoTargetTempleteRequest
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
#import "QCloudUpdateVideoTargetTempleteResponse.h"

NS_ASSUME_NONNULL_BEGIN
/**

 更新模板.

 ### 功能描述

 更新视频目标检测模板.

 具体请查看  https://cloud.tencent.com/document/product/460/84760.

### 示例

  @code

	QCloudUpdateVideoTargetTempleteRequest * request = [QCloudUpdateVideoTargetTempleteRequest new];
	request.bucket = @"sample-1250000000";
	request.regionName = @"COS_REGIONNAME";
     QCloudUpdateVideoTargetTemplete * updateVideoTargetTemplete = [QCloudUpdateVideoTargetTemplete new];
    // 模板类型：VideoTargetRec;是否必传：是
    updateVideoTargetTemplete.Tag = @"VideoTargetRec";
    // 模板名称，仅支持中文、英文、数字、_、-和*，长度不超过 64;是否必传：是
    updateVideoTargetTemplete.Name = @"garenwang_test";
    request.input = updateVideoTargetTemplete;
    request.TemplateId = @"test";

	[request setFinishBlock:^(QCloudUpdateVideoTargetTempleteResponse * outputObject, NSError *error) {
		// result：QCloudUpdateVideoTargetTempleteResponse 包含所有的响应；
		// 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/84760
	}];
	[[QCloudCOSXMLService defaultCOSXML] UpdateVideoTargetTemplete:request];


*/

@interface QCloudUpdateVideoTargetTempleteRequest : QCloudBizHTTPRequest

/// 存储桶名称
@property (nonatomic,strong)NSString * bucket;

@property (nonatomic,strong)NSString * TemplateId;

/// 请求输入参数
@property (nonatomic,strong)QCloudUpdateVideoTargetTemplete * input;

- (void)setFinishBlock:(void (^_Nullable)( QCloudUpdateVideoTargetTempleteResponse * _Nullable result, NSError *_Nullable error))finishBlock;

@end



NS_ASSUME_NONNULL_END
