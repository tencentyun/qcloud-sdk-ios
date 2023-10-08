//
//  QCloudPostVideoTargetTempleteRequest.h
//  QCloudPostVideoTargetTempleteRequest
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
#import "QCloudPostVideoTargetTempleteResponse.h"

NS_ASSUME_NONNULL_BEGIN
/**

 创建模板.

 ### 功能描述

 创建视频目标检测模板.

 具体请查看  https://cloud.tencent.com/document/product/460/84736.

### 示例

  @code

	QCloudPostVideoTargetTempleteRequest * request = [QCloudPostVideoTargetTempleteRequest new];
	request.bucket = @"sample-1250000000";
	request.regionName = @"COS_REGIONNAME";
     QCloudPostVideoTargetTemplete * postVideoTargetTemplete = [QCloudPostVideoTargetTemplete new];
     // 模板类型：VideoTargetRec;是否必传：是
     postVideoTargetTemplete.Tag = @"VideoTargetRec";
     // 模板名称，仅支持中文、英文、数字、_、-和*，长度不超过 64;是否必传：是
     postVideoTargetTemplete.Name = @"garenwang_test";

     QCloudVideoTargetRec * targetRec = [QCloudVideoTargetRec new];
     targetRec.Body = @"true";
     
     postVideoTargetTemplete.VideoTargetRec = targetRec;
     
     request.input = postVideoTargetTemplete;

	[request setFinishBlock:^(QCloudPostVideoTargetTempleteResponse * outputObject, NSError *error) {
		// result：QCloudPostVideoTargetTempleteResponse 包含所有的响应；
		// 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/84736
	}];
	[[QCloudCOSXMLService defaultCOSXML] PostVideoTargetTemplete:request];


*/

@interface QCloudPostVideoTargetTempleteRequest : QCloudBizHTTPRequest

/// 存储桶名称
@property (nonatomic,strong)NSString * bucket;

/// 请求输入参数
@property (nonatomic,strong)QCloudPostVideoTargetTemplete * input;

- (void)setFinishBlock:(void (^_Nullable)( QCloudPostVideoTargetTempleteResponse * _Nullable result, NSError *_Nullable error))finishBlock;

@end



NS_ASSUME_NONNULL_END
