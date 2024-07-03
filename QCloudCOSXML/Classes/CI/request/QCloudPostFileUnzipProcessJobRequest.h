//
//  QCloudPostFileUnzipProcessJobRequest.h
//  QCloudPostFileUnzipProcessJobRequest
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
#import "QCloudPostFileUnzipProcessJobResponse.h"

NS_ASSUME_NONNULL_BEGIN
/**

 提交文件解压任务.

 ### 功能描述

 以提交任务的方式进行压缩包文件的解压缩，异步返回压缩包内的全部或部分文件，该接口属于 POST 请求

 具体请查看  https://cloud.tencent.com/document/product/460/83087

### 示例

  @code

	QCloudPostFileUnzipProcessJobRequest * request = [QCloudPostFileUnzipProcessJobRequest new];
	request.bucket = @"sample-1250000000";
	request.regionName = @"COS_REGIONNAME";
	
    request.input = [QCloudPostFileUnzipProcessJob new];
    // 表示任务的类型，文件解压默认为：FileUncompress。;是否必传：是
    request.input.Tag = @"FileUncompress";
    // 包含待操作的文件信息。;是否必传：是
    request.input.Input = [QCloudPostFileUnzipProcessJobInput new];
    // 文件名，取值为文件在当前存储桶中的完整名称。;是否必传：是
    request.input.Input.Object = @"test.zip";
    // 包含文件解压的处理规则。;是否必传：是
    request.input.Operation = [QCloudPostFileUnzipProcessJobOperation new];
    request.input.Operation.FileUncompressConfig = QCloudFileUncompressConfig.new;
    request.input.Operation.FileUncompressConfig.Prefix = @"/";
    request.input.Operation.Output = QCloudPostFileUnzipProcessJobOutput.new;
    request.input.Operation.Output.Bucket = @"tinna-media-1253960454";
    request.input.Operation.Output.Region = @"ap-chongqing";

	[request setFinishBlock:^(QCloudPostFileUnzipProcessJobResponse * outputObject, NSError *error) {
		// result：QCloudPostFileUnzipProcessJobResponse 包含所有的响应；
		// 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/83087
	}];
	[[QCloudCOSXMLService defaultCOSXML] PostFileUnzipProcessJob:request];


*/

@interface QCloudPostFileUnzipProcessJobRequest : QCloudBizHTTPRequest

/// 存储桶名称
@property (nonatomic,strong)NSString * bucket;

/// 请求输入参数
@property (nonatomic,strong)QCloudPostFileUnzipProcessJob * input;

- (void)setFinishBlock:(void (^_Nullable)( QCloudPostFileUnzipProcessJobResponse * _Nullable result, NSError *_Nullable error))finishBlock;

@end



NS_ASSUME_NONNULL_END
