//
//  QCloudVocalScoreRequest.h
//  QCloudVocalScoreRequest
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
#import "QCloudVocalScoreResponse.h"

NS_ASSUME_NONNULL_BEGIN
/**

 提交任务.

 ### 功能描述

 提交一个音乐评分任务.

 具体请查看  https://cloud.tencent.com/document/product/460/96095.

### 示例

  @code

	QCloudVocalScoreRequest * request = [QCloudVocalScoreRequest new];
	request.bucket = @"sample-1250000000";
	request.regionName = @"COS_REGIONNAME";
     request.input = [QCloudVocalScore new];
     // 创建任务的 Tag：VocalScore;是否必传：是
     request.input.Tag = @"VocalScore";
     
     // 待操作的对象信息;是否必传：是
     request.input.Input = [QCloudVocalScoreInput new];
     request.input.Input.Object = @"test_video.mp4";
     
     // 操作规则;是否必传：是
     request.input.Operation = [QCloudVocalScoreOperation new];
     // 音乐评分参数配置;是否必传：是
     request.input.Operation.VocalScore = [QCloudVocalScoreVocalScore new];
     request.input.Operation.VocalScore.StandardObject = @"test.txt";

	[request setFinishBlock:^(QCloudVocalScoreResponse * outputObject, NSError *error) {
		// result：QCloudVocalScoreResponse 包含所有的响应；
		// 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/96095
        // outputObject返回JobId，使用QCloudGetMediaJobRequest 查询结果
	}];
	[[QCloudCOSXMLService defaultCOSXML] VocalScore:request];


*/

@interface QCloudVocalScoreRequest : QCloudBizHTTPRequest

/// 存储桶名称
@property (nonatomic,strong)NSString * bucket;

/// 请求输入参数
@property (nonatomic,strong)QCloudVocalScore * input;

- (void)setFinishBlock:(void (^_Nullable)( QCloudVocalScoreResponse * _Nullable result, NSError *_Nullable error))finishBlock;

@end



NS_ASSUME_NONNULL_END
