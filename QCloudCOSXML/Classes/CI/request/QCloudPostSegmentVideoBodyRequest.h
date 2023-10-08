//
//  QCloudPostSegmentVideoBodyRequest.h
//  QCloudPostSegmentVideoBodyRequest
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
#import "QCloudPostSegmentVideoBodyResponse.h"

NS_ASSUME_NONNULL_BEGIN
/**

 提交任务.

 ### 功能描述

 提交一个视频人像抠图任务.

 具体请查看  https://cloud.tencent.com/document/product/460/83973.

### 示例

  @code

	QCloudPostSegmentVideoBodyRequest * request = [QCloudPostSegmentVideoBodyRequest new];
	request.bucket = @"sample-1250000000";
	request.regionName = @"COS_REGIONNAME";
 
     QCloudPostSegmentVideoBody * postSegmentVideoBody = [QCloudPostSegmentVideoBody new];
     // 创建任务的 Tag：SegmentVideoBody;是否必传：是
     postSegmentVideoBody.Tag = @"SegmentVideoBody";
     // 待操作的对象信息;是否必传：是
     
      QCloudPostSegmentVideoBodyInput * input = [QCloudPostSegmentVideoBodyInput new];
     // 文件路径;是否必传：是
     input.Object = @"1347199842654.jpg";
     
     // 操作规则;是否必传：是
      QCloudPostSegmentVideoBodyOperation * operation = [QCloudPostSegmentVideoBodyOperation new];

     postSegmentVideoBody.Operation = operation;
     // 结果输出配置;是否必传：是
      QCloudPostSegmentVideoBodyOutput * output = [QCloudPostSegmentVideoBodyOutput new];
     // 存储桶的地域;是否必传：是
     output.Region = @"ap-nanjing";
     // 存储结果的存储桶;是否必传：是
     output.Bucket = @"000garenwang-1253960454";
     // 输出结果的文件名;是否必传：是
     output.Object = @"target_1347199842654.jpg";
     
     operation.Output = output;
     
     postSegmentVideoBody.Input = input;

     
     request.input = postSegmentVideoBody;

	[request setFinishBlock:^(QCloudPostSegmentVideoBodyResponse * outputObject, NSError *error) {
		// result：QCloudPostSegmentVideoBodyResponse 包含所有的响应；
		// 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/83973
        // outputObject返回JobId，使用QCloudGetMediaJobRequest 查询结果
	}];
	[[QCloudCOSXMLService defaultCOSXML] PostSegmentVideoBody:request];


*/

@interface QCloudPostSegmentVideoBodyRequest : QCloudBizHTTPRequest

/// 存储桶名称
@property (nonatomic,strong)NSString * bucket;

/// 请求输入参数
@property (nonatomic,strong)QCloudPostSegmentVideoBody * input;

- (void)setFinishBlock:(void (^_Nullable)( QCloudPostSegmentVideoBodyResponse * _Nullable result, NSError *_Nullable error))finishBlock;

@end



NS_ASSUME_NONNULL_END
