//
//  QCloudCreateHashProcessJobsRequest.h
//  QCloudCreateHashProcessJobsRequest
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
#import "QCloudCreateHashProcessJobsResponse.h"

NS_ASSUME_NONNULL_BEGIN
/**

 哈希值计算同步请求.

 ### 功能描述

 以同步请求的方式进行文件哈希值计算，实时返回计算得到的哈希值，该接口属于 GET 请求

 具体请查看  https://cloud.tencent.com/document/product/460/83084

### 示例

  @code

	QCloudCreateHashProcessJobsRequest * request = [QCloudCreateHashProcessJobsRequest new];
	request.bucket = @"sample-1250000000";
	request.regionName = @"COS_REGIONNAME";
    // 设置：ObjectKey;
     request.ObjectKey = @"test.zip";
     request.type = @"md5";

	[request setFinishBlock:^(QCloudCreateHashProcessJobsResponse * outputObject, NSError *error) {
		// result：QCloudCreateHashProcessJobsResponse 包含所有的响应；
		// 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/83084
	}];
	[[QCloudCOSXMLService defaultCOSXML] CreateHashProcessJobs:request];


*/

@interface QCloudCreateHashProcessJobsRequest : QCloudBizHTTPRequest

/// 操作类型，哈希值计算固定为：filehash;是否必传：是
@property (nonatomic,strong) NSString * ciProcess;

/// 支持的哈希算法类型，有效值：md5、sha1、sha256;是否必传：是
@property (nonatomic,strong) NSString * type;

/// 是否将计算得到的哈希值，自动添加至文件的自定义 header，格式为：x-cos-meta-md5/sha1/sha256；有效值： true、false，不填则默认为 false;是否必传：否
@property (nonatomic,strong) NSString * addtoheader;

/// 存储桶名称
@property (nonatomic,strong)NSString * bucket;

@property (nonatomic,strong)NSString * ObjectKey;

- (void)setFinishBlock:(void (^_Nullable)( QCloudCreateHashProcessJobsResponse * _Nullable result, NSError *_Nullable error))finishBlock;

@end



NS_ASSUME_NONNULL_END
