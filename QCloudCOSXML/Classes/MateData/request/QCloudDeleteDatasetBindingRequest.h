//
//  QCloudDeleteDatasetBindingRequest.h
//  QCloudDeleteDatasetBindingRequest
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
#import "QCloudDeleteDatasetBindingResponse.h"

NS_ASSUME_NONNULL_BEGIN
/**

 解绑存储桶与数据集.

 ### 功能描述

 解绑数据集和对象存储（COS）Bucket ，解绑会导致 COS Bucket新增的变更不会同步到数据集，请谨慎操作。.

 具体请查看  https://cloud.tencent.com/document/product/460/106160.

### 示例

  @code

	QCloudDeleteDatasetBindingRequest * request = [QCloudDeleteDatasetBindingRequest new];
	request.regionName = @"COS_REGIONNAME";
	request.input = [QCloudDeleteDatasetBinding new];
	// 数据集名称，同一个账户下唯一。;是否必传：是
	request.input.DatasetName = @"test";
	// 资源标识字段，表示需要与数据集绑定的资源，当前仅支持COS存储桶，字段规则：cos://<BucketName>，其中BucketName表示COS存储桶名称，例如：cos://examplebucket-1250000000;是否必传：是
	request.input.URI = @"cos://examplebucket-1250000000";

	[request setFinishBlock:^(QCloudDeleteDatasetBindingResponse * outputObject, NSError *error) {
		// result：QCloudDeleteDatasetBindingResponse 包含所有的响应；
		// 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/106160
	}];
	[[QCloudCOSXMLService defaultCOSXML] DeleteDatasetBinding:request];


*/

@interface QCloudDeleteDatasetBindingRequest : QCloudBizHTTPRequest

/// 请求输入参数
@property (nonatomic,strong)QCloudDeleteDatasetBinding * input;

- (void)setFinishBlock:(void (^_Nullable)( QCloudDeleteDatasetBindingResponse * _Nullable result, NSError *_Nullable error))finishBlock;

@end



NS_ASSUME_NONNULL_END
