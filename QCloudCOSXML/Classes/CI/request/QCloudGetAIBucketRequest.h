//
//  QCloudGetAIBucketRequest.h
//  QCloudGetAIBucketRequest
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
#import "QCloudGetAIBucketResponse.h"

NS_ASSUME_NONNULL_BEGIN
/**

 查询AI内容识别服务.

 ### 功能描述

 本接口用于查询已经开通AI 内容识别（异步）服务的存储桶.

 具体请查看  https://cloud.tencent.com/document/product/460/79594

### 示例

  @code

	QCloudGetAIBucketRequest * request = [QCloudGetAIBucketRequest new];
	request.bucket = @"sample-1250000000";
	request.regionName = @"COS_REGIONNAME";
	// 地域信息，例如 ap-shanghai、ap-beijing，若查询多个地域以“,”分隔字符串，详情请参见 地域与域名;是否必传：true；
	request.regions = ;
	// 存储桶名称，以“,”分隔，支持多个存储桶，精确搜索;是否必传：true；
	request.bucketNames = ;
	// 存储桶名称前缀，前缀搜索;是否必传：true；
	request.bucketName = ;
	// 第几页;是否必传：true；
	request.pageNumber = @"1";
	// 每页个数，大于0且小于等于100的整数;是否必传：true；
	request.pageSize = @"10";

	[request setFinishBlock:^(QCloudGetAIBucketResponse * outputObject, NSError *error) {
		// result：QCloudGetAIBucketResponse 包含所有的响应；
		// 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/79594
	}];
	[[QCloudCOSXMLService defaultCOSXML] GetAIBucket:request];


*/

@interface QCloudGetAIBucketRequest : QCloudBizHTTPRequest

/// 地域信息，例如 ap-shanghai、ap-beijing，若查询多个地域以“,”分隔字符串，详情请参见 地域与域名;是否必传：是
@property (nonatomic,strong) NSString * regions;

/// 存储桶名称，以“,”分隔，支持多个存储桶，精确搜索;是否必传：是
@property (nonatomic,strong) NSString * bucketNames;

/// 存储桶名称前缀，前缀搜索;是否必传：是
@property (nonatomic,strong) NSString * bucketName;

/// 第几页;是否必传：是
@property (nonatomic,assign)NSInteger pageNumber;

/// 每页个数，大于0且小于等于100的整数;是否必传：是
@property (nonatomic,assign)NSInteger pageSize;

/// 存储桶名称
@property (nonatomic,strong)NSString * bucket;

- (void)setFinishBlock:(void (^_Nullable)( QCloudGetAIBucketResponse * _Nullable result, NSError *_Nullable error))finishBlock;

@end



NS_ASSUME_NONNULL_END
