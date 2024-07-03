//
//  QCloudCreateDatasetBindingRequest.h
//  QCloudCreateDatasetBindingRequest
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
#import "QCloudCreateDatasetBindingResponse.h"

NS_ASSUME_NONNULL_BEGIN
/**

 绑定存储桶与数据集.

 ### 功能描述

 本文档介绍创建数据集（Dataset）和对象存储（COS）Bucket 的绑定关系，绑定后将使用创建数据集时所指定算子对文件进行处理。
绑定关系创建后，将对 COS 中新增的文件进行准实时的增量追踪扫描，使用创建数据集时所指定算子对文件进行处理，抽取文件元数据信息进行索引。通过此方式为文件建立索引后，您可以使用元数据查询API对元数据进行查询、管理和统计。
.

 具体请查看  https://cloud.tencent.com/document/product/460/106159.

### 示例

  @code

	QCloudCreateDatasetBindingRequest * request = [QCloudCreateDatasetBindingRequest new];
	request.regionName = @"COS_REGIONNAME";
	request.input = [QCloudCreateDatasetBinding new];
	// 数据集名称，同一个账户下唯一;是否必传：是
	request.input.DatasetName = @"test";
	// 资源标识字段，表示需要与数据集绑定的资源，当前仅支持COS存储桶，字段规则：cos://<BucketName>，其中BucketName表示COS存储桶名称，例如：cos://examplebucket-1250000000;是否必传：是
	request.input.URI = @"cos://examplebucket-1250000000";

	[request setFinishBlock:^(QCloudCreateDatasetBindingResponse * outputObject, NSError *error) {
		// result：QCloudCreateDatasetBindingResponse 包含所有的响应；
		// 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/106159
	}];
	[[QCloudCOSXMLService defaultCOSXML] CreateDatasetBinding:request];


*/

@interface QCloudCreateDatasetBindingRequest : QCloudBizHTTPRequest

/// 请求输入参数
@property (nonatomic,strong)QCloudCreateDatasetBinding * input;

- (void)setFinishBlock:(void (^_Nullable)( QCloudCreateDatasetBindingResponse * _Nullable result, NSError *_Nullable error))finishBlock;

@end



NS_ASSUME_NONNULL_END
