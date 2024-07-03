//
//  QCloudDescribeFileMetaIndexRequest.h
//  QCloudDescribeFileMetaIndexRequest
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
#import "QCloudDescribeFileMetaIndexResponse.h"

NS_ASSUME_NONNULL_BEGIN
/**

 查询元数据索引.

 ### 功能描述

 获取数据集内已完成索引的一个文件的元数据。.

 具体请查看  https://cloud.tencent.com/document/product/460/106164.

### 示例

  @code

	QCloudDescribeFileMetaIndexRequest * request = [QCloudDescribeFileMetaIndexRequest new];
	request.regionName = @"COS_REGIONNAME";
	// 数据集名称，同一个账户下唯一。;是否必传：true；
	request.datasetname = @"数据集名称";
	// 资源标识字段，表示需要建立索引的文件地址，当前仅支持 COS 上的文件，字段规则：cos://<BucketName>/<ObjectKey>，其中BucketName表示 COS 存储桶名称，ObjectKey 表示文件完整路径，例如：cos://examplebucket-1250000000/test1/img.jpg。 注意： 仅支持本账号内的 COS 文件 不支持 HTTP 开头的地址 需 UrlEncode;是否必传：true；
	request.uri = @"cos://facesearch-12500000000";

	[request setFinishBlock:^(QCloudDescribeFileMetaIndexResponse * outputObject, NSError *error) {
		// result：QCloudDescribeFileMetaIndexResponse 包含所有的响应；
		// 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/106164
	}];
	[[QCloudCOSXMLService defaultCOSXML] DescribeFileMetaIndex:request];


*/

@interface QCloudDescribeFileMetaIndexRequest : QCloudBizHTTPRequest

/// 数据集名称，同一个账户下唯一。;是否必传：是
@property (nonatomic,strong) NSString * datasetname;

/// 资源标识字段，表示需要建立索引的文件地址，当前仅支持 COS 上的文件，字段规则：cos://<BucketName>/<ObjectKey>，其中BucketName表示 COS 存储桶名称，ObjectKey 表示文件完整路径，例如：cos://examplebucket-1250000000/test1/img.jpg。 注意： 仅支持本账号内的 COS 文件 不支持 HTTP 开头的地址 需 UrlEncode;是否必传：是
@property (nonatomic,strong) NSString * uri;

- (void)setFinishBlock:(void (^_Nullable)( QCloudDescribeFileMetaIndexResponse * _Nullable result, NSError *_Nullable error))finishBlock;

@end



NS_ASSUME_NONNULL_END
