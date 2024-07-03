//
//  QCloudPostHashProcessJobsRequest.h
//  QCloudPostHashProcessJobsRequest
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
#import "QCloudPostHashProcessJobsResponse.h"

NS_ASSUME_NONNULL_BEGIN
/**

 提交哈希值计算任务.

 ### 功能描述

 以提交任务的方式进行文件哈希值计算，异步返回计算得到的哈希值，该接口属于 POST 请求

 具体请查看  https://cloud.tencent.com/document/product/460/83085

### 示例

  @code

	QCloudPostHashProcessJobsRequest * request = [QCloudPostHashProcessJobsRequest new];
	request.bucket = @"sample-1250000000";
	request.regionName = @"COS_REGIONNAME";
     request.input = [QCloudPostHashProcessJobs new];
     // 表示任务的类型，哈希值计算默认为：FileHashCode。;是否必传：是
     request.input.Tag = @"FileHashCode";
     // 包含待操作的文件信息。;是否必传：是
     request.input.Input = [QCloudPostHashProcessJobsInput new];
     // 文件名，取值为文件在当前存储桶中的完整名称。;是否必传：是
     request.input.Input.Object = @"test.zip";
     // 包含哈希值计算的处理规则。;是否必传：是
     request.input.Operation = [QCloudPostHashProcessJobsOperation new];
     // 透传用户信息, 可打印的 ASCII 码，长度不超过1024。;是否必传：否
     request.input.Operation.FileHashCodeConfig = QCloudPostHashProcessJobsFileHashCodeConfig.new;
     request.input.Operation.FileHashCodeConfig.Type = @"MD5";

	[request setFinishBlock:^(QCloudPostHashProcessJobsResponse * outputObject, NSError *error) {
		// result：QCloudPostHashProcessJobsResponse 包含所有的响应；
		// 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/83085
	}];
	[[QCloudCOSXMLService defaultCOSXML] PostHashProcessJobs:request];


*/

@interface QCloudPostHashProcessJobsRequest : QCloudBizHTTPRequest

/// 存储桶名称
@property (nonatomic,strong)NSString * bucket;

/// 请求输入参数
@property (nonatomic,strong)QCloudPostHashProcessJobs * input;

- (void)setFinishBlock:(void (^_Nullable)( QCloudPostHashProcessJobsResponse * _Nullable result, NSError *_Nullable error))finishBlock;

@end



NS_ASSUME_NONNULL_END
