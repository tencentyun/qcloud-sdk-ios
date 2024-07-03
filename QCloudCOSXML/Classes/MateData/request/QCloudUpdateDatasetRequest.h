//
//  QCloudUpdateDatasetRequest.h
//  QCloudUpdateDatasetRequest
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
#import "QCloudUpdateDatasetResponse.h"

NS_ASSUME_NONNULL_BEGIN
/**

 更新数据集.

 ### 功能描述

 更新一个数据集（Dataset）信息。.

 具体请查看  https://cloud.tencent.com/document/product/460/106156.

### 示例

  @code

	QCloudUpdateDatasetRequest * request = [QCloudUpdateDatasetRequest new];
	request.regionName = @"COS_REGIONNAME";
	request.input = [QCloudUpdateDataset new];
	// 数据集名称，同一个账户下唯一。;是否必传：是
	request.input.DatasetName = @"test";
	// 数据集描述信息。长度为1~256个英文或中文字符，默认值为空。;是否必传：否
	request.input.Description = @"test";
	//  检与数据集关联的检索模板，在建立元数据索引时，后端将根据检索模板来决定采集文件的哪些元数据。 每个检索模板都包含若干个算子，不同的算子表示不同的处理能力，更多信息请参见 [检索模板与算子](https://cloud.tencent.com/document/product/460/106018)。 默认值为空，即不关联检索模板，不进行任何元数据的采集。;是否必传：否
	request.input.TemplateId = @"Official:COSBasicMeta";

	[request setFinishBlock:^(QCloudUpdateDatasetResponse * outputObject, NSError *error) {
		// result：QCloudUpdateDatasetResponse 包含所有的响应；
		// 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/106156
	}];
	[[QCloudCOSXMLService defaultCOSXML] UpdateDataset:request];


*/

@interface QCloudUpdateDatasetRequest : QCloudBizHTTPRequest

/// 请求输入参数
@property (nonatomic,strong)QCloudUpdateDataset * input;

- (void)setFinishBlock:(void (^_Nullable)( QCloudUpdateDatasetResponse * _Nullable result, NSError *_Nullable error))finishBlock;

@end



NS_ASSUME_NONNULL_END
