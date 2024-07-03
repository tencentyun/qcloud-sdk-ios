//
//  QCloudDescribeDatasetBindingsRequest.h
//  QCloudDescribeDatasetBindingsRequest
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
#import "QCloudDescribeDatasetBindingsResponse.h"

NS_ASSUME_NONNULL_BEGIN
/**

 查询绑定关系列表.

 ### 功能描述

 查询数据集和对象存储（COS）Bucket 绑定关系列表。.

 具体请查看  https://cloud.tencent.com/document/product/460/106161.

### 示例

  @code

	QCloudDescribeDatasetBindingsRequest * request = [QCloudDescribeDatasetBindingsRequest new];
	request.regionName = @"COS_REGIONNAME";
	// 数据集名称，同一个账户下唯一。;是否必传：true；
	request.datasetname = @"数据集名称";
	// 返回绑定关系的最大个数，取值范围为0~200。不设置此参数或者设置为0时，则默认值为100。;是否必传：false；
	request.maxresults = 100;
	// 当绑定关系总数大于设置的MaxResults时，用于翻页的token。从NextToken开始按字典序返回绑定关系信息列表。第一次调用此接口时，设置为空。;是否必传：false；
	request.nexttoken = @"下一页";

	[request setFinishBlock:^(QCloudDescribeDatasetBindingsResponse * outputObject, NSError *error) {
		// result：QCloudDescribeDatasetBindingsResponse 包含所有的响应；
		// 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/106161
	}];
	[[QCloudCOSXMLService defaultCOSXML] DescribeDatasetBindings:request];


*/

@interface QCloudDescribeDatasetBindingsRequest : QCloudBizHTTPRequest

/// 数据集名称，同一个账户下唯一。;是否必传：是
@property (nonatomic,strong) NSString * datasetname;

/// 返回绑定关系的最大个数，取值范围为0~200。不设置此参数或者设置为0时，则默认值为100。;是否必传：否
@property (nonatomic,assign)NSInteger maxresults;

/// 当绑定关系总数大于设置的MaxResults时，用于翻页的token。从NextToken开始按字典序返回绑定关系信息列表。第一次调用此接口时，设置为空。;是否必传：否
@property (nonatomic,strong) NSString * nexttoken;

- (void)setFinishBlock:(void (^_Nullable)( QCloudDescribeDatasetBindingsResponse * _Nullable result, NSError *_Nullable error))finishBlock;

@end



NS_ASSUME_NONNULL_END
