//
//  QCloudCreateFileZipProcessJobsRequest.h
//  QCloudCreateFileZipProcessJobsRequest
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
#import "QCloudCreateFileZipProcessJobsResponse.h"

NS_ASSUME_NONNULL_BEGIN
/**

 提交多文件打包压缩任务.

 ### 功能描述

 多文件打包压缩功能可以将您的多个文件，打包为 zip 等压缩包格式，以提交任务的方式进行多文件打包压缩，异步返回打包后的文件，该接口属于 POST 请求

 具体请查看  https://cloud.tencent.com/document/product/460/83091

### 示例

  @code

	QCloudCreateFileZipProcessJobsRequest * request = [QCloudCreateFileZipProcessJobsRequest new];
	request.bucket = @"sample-1250000000";
	request.regionName = @"COS_REGIONNAME";
     request.input = [QCloudCreateFileZipProcessJobs new];
     // 表示任务的类型，多文件打��压缩默认为：FileCompress。;是否必传：是
     request.input.Tag = @"FileCompress";
     // 包含文件打包压缩的处理规则。;是否必传：是
     request.input.Operation = [QCloudCreateFileZipProcessJobsOperation new];
     request.input.Operation.FileCompressConfig = [QCloudFileCompressConfig new];
     request.input.Operation.FileCompressConfig.Flatten = @"1";
     request.input.Operation.FileCompressConfig.Format = @"zip";
     request.input.Operation.FileCompressConfig.Prefix = @"/";
     request.input.Operation.Output = [QCloudCreateFileZipProcessJobsOutput new];
     request.input.Operation.Output.Region = @"ap-chongqing";
     request.input.Operation.Output.Bucket = @"sample-1250000000";
     request.input.Operation.Output.Object = @"test123.zip";

	[request setFinishBlock:^(QCloudCreateFileZipProcessJobsResponse * outputObject, NSError *error) {
		// result：QCloudCreateFileZipProcessJobsResponse 包含所有的响应；
		// 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/83091
	}];
	[[QCloudCOSXMLService defaultCOSXML] CreateFileZipProcessJobs:request];


*/

@interface QCloudCreateFileZipProcessJobsRequest : QCloudBizHTTPRequest

/// 存储桶名称
@property (nonatomic,strong)NSString * bucket;

/// 请求输入参数
@property (nonatomic,strong)QCloudCreateFileZipProcessJobs * input;

- (void)setFinishBlock:(void (^_Nullable)( QCloudCreateFileZipProcessJobsResponse * _Nullable result, NSError *_Nullable error))finishBlock;

@end



NS_ASSUME_NONNULL_END
