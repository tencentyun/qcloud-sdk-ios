//
//  QCloudDeleteFileMetaIndexRequest.h
//  QCloudDeleteFileMetaIndexRequest
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
#import "QCloudDeleteFileMetaIndexResponse.h"

NS_ASSUME_NONNULL_BEGIN
/**

 删除元数据索引.

 ### 功能描述

 从数据集内删除一个文件的元信息。无论该文件的元信息是否在数据集内存在，均会返回删除成功。

.

 具体请查看  https://cloud.tencent.com/document/product/460/106163.

### 示例

  @code

	QCloudDeleteFileMetaIndexRequest * request = [QCloudDeleteFileMetaIndexRequest new];
	request.regionName = @"COS_REGIONNAME";
	request.input = [QCloudDeleteFileMetaIndex new];
	// 数据集名称，同一个账户下唯一。;是否必传：是
	request.input.DatasetName = @"test";
	// 资源标识字段，表示需要建立索引的文件地址。;是否必传：是
	request.input.URI = @"cos://examplebucket-1250000000/test.jpg";

	[request setFinishBlock:^(QCloudDeleteFileMetaIndexResponse * outputObject, NSError *error) {
		// result：QCloudDeleteFileMetaIndexResponse 包含所有的响应；
		// 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/106163
	}];
	[[QCloudCOSXMLService defaultCOSXML] DeleteFileMetaIndex:request];


*/

@interface QCloudDeleteFileMetaIndexRequest : QCloudBizHTTPRequest

/// 请求输入参数
@property (nonatomic,strong)QCloudDeleteFileMetaIndex * input;

- (void)setFinishBlock:(void (^_Nullable)( QCloudDeleteFileMetaIndexResponse * _Nullable result, NSError *_Nullable error))finishBlock;

@end



NS_ASSUME_NONNULL_END
