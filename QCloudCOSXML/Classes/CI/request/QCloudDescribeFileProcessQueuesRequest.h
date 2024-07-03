//
//  QCloudDescribeFileProcessQueuesRequest.h
//  QCloudDescribeFileProcessQueuesRequest
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
#import "QCloudDescribeFileProcessQueuesResponse.h"

NS_ASSUME_NONNULL_BEGIN
/**

 查询文件处理队列.

 ### 功能描述

 本接口用于查询文件处理队列

 具体请查看  https://cloud.tencent.com/document/product/460/86421

### 示例

  @code

	QCloudDescribeFileProcessQueuesRequest * request = [QCloudDescribeFileProcessQueuesRequest new];
	request.bucket = @"sample-1250000000";
	request.regionName = @"COS_REGIONNAME";

	[request setFinishBlock:^(QCloudDescribeFileProcessQueuesResponse * outputObject, NSError *error) {
		// result：QCloudDescribeFileProcessQueuesResponse 包含所有的响应；
		// 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/86421
	}];
	[[QCloudCOSXMLService defaultCOSXML] DescribeFileProcessQueues:request];


*/

@interface QCloudDescribeFileProcessQueuesRequest : QCloudBizHTTPRequest

/// 队列 ID，以“,”符号分割字符串;是否必传：否
@property (nonatomic,strong) NSString * queueIds;

/// Active 表示队列内的作业会被调度执行Paused 表示队列暂停，作业不再会被调度执行，队列内的所有作业状态维持在暂停状态，已经执行中的任务不受影响;是否必传：否
@property (nonatomic,strong) NSString * state;

/// 第几页，默认值1;是否必传：否
@property (nonatomic,strong) NSString * pageNumber;

/// 每页个数，默认值10;是否必传：否
@property (nonatomic,strong) NSString * pageSize;

/// 存储桶名称
@property (nonatomic,strong)NSString * bucket;

- (void)setFinishBlock:(void (^_Nullable)( QCloudDescribeFileProcessQueuesResponse * _Nullable result, NSError *_Nullable error))finishBlock;

@end



NS_ASSUME_NONNULL_END
