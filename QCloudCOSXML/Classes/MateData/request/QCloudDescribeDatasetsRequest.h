//
//  QCloudDescribeDatasetsRequest.h
//  QCloudDescribeDatasetsRequest
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
#import "QCloudDescribeDatasetsResponse.h"

NS_ASSUME_NONNULL_BEGIN
/**

 列出数据集.

 ### 功能描述

 获取数据集（Dataset）列表。.

 具体请查看  https://cloud.tencent.com/document/product/460/106158.

### 示例

  @code

	QCloudDescribeDatasetsRequest * request = [QCloudDescribeDatasetsRequest new];
	request.regionName = @"COS_REGIONNAME";
	// 本次返回数据集的最大个数，取值范围为0~200。不设置此参数或者设置为0时，则默认值为100。;是否必传：false；
	request.maxresults = 100;
	// 翻页标记。当文件总数大于设置的MaxResults时，用于翻页的Token。从NextToken开始按字典序返回文件信息列表。填写上次查询返回的值，首次使用时填写为空。;是否必传：false；
	request.nexttoken = @"下一页";
	// 数据集名称前缀。;是否必传：false；
	request.prefix = @"数据集前缀";

	[request setFinishBlock:^(QCloudDescribeDatasetsResponse * outputObject, NSError *error) {
		// result：QCloudDescribeDatasetsResponse 包含所有的响应；
		// 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/106158
	}];
	[[QCloudCOSXMLService defaultCOSXML] DescribeDatasets:request];


*/

@interface QCloudDescribeDatasetsRequest : QCloudBizHTTPRequest

/// 本次返回数据集的最大个数，取值范围为0~200。不设置此参数或者设置为0时，则默认值为100。;是否必传：否
@property (nonatomic,assign)NSInteger maxresults;

/// 翻页标记。当文件总数大于设置的MaxResults时，用于翻页的Token。从NextToken开始按字典序返回文件信息列表。填写上次查询返回的值，首次使用时填写为空。;是否必传：否
@property (nonatomic,strong) NSString * nexttoken;

/// 数据集名称前缀。;是否必传：否
@property (nonatomic,strong) NSString * prefix;

- (void)setFinishBlock:(void (^_Nullable)( QCloudDescribeDatasetsResponse * _Nullable result, NSError *_Nullable error))finishBlock;

@end



NS_ASSUME_NONNULL_END
