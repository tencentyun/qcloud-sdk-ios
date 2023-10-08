//
//  QCloudPostWordsGeneralizeRequest.h
//  QCloudPostWordsGeneralizeRequest
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
#import "QCloudPostWordsGeneralizeResponse.h"

NS_ASSUME_NONNULL_BEGIN
/**

 提交任务.

 ### 功能描述

 提交一个分词任务.

 具体请查看  https://cloud.tencent.com/document/product/460/84800.

### 示例

  @code

	QCloudPostWordsGeneralizeRequest * request = [QCloudPostWordsGeneralizeRequest new];
	request.bucket = @"sample-1250000000";
	request.regionName = @"COS_REGIONNAME";
 
     request.input = [QCloudPostWordsGeneralize new];
     
     // 创建任务的 Tag：WordsGeneralize;是否必传：是
     request.input.Tag = @"WordsGeneralize";
     
     // 待操作的对象信息;是否必传：是
     request.input.Input = [QCloudPostWordsGeneralizeInput new];
     
     // 文件路径;是否必传：是
     request.input.Input.Object = @"xihaiqingge.txt";

     // 操作规则;是否必传：是
     request.input.Operation = [QCloudPostWordsGeneralizeOperation new];
     // 指定分词参数;是否必传：是
     request.input.Operation.WordsGeneralize = [QCloudPostWordsGeneralizeWordsGeneralize new];
     request.input.Operation.WordsGeneralize.NerMethod = @"DL";
     request.input.Operation.WordsGeneralize.SegMethod = @"MIX";

	[request setFinishBlock:^(QCloudPostWordsGeneralizeResponse * outputObject, NSError *error) {
		// result：QCloudPostWordsGeneralizeResponse 包含所有的响应；
		// 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/84800
        // outputObject返回JobId，使用QCloudGetMediaJobRequest 查询结果
	}];
	[[QCloudCOSXMLService defaultCOSXML] PostWordsGeneralize:request];


*/

@interface QCloudPostWordsGeneralizeRequest : QCloudBizHTTPRequest

/// 存储桶名称
@property (nonatomic,strong)NSString * bucket;

/// 请求输入参数
@property (nonatomic,strong)QCloudPostWordsGeneralize * input;

- (void)setFinishBlock:(void (^_Nullable)( QCloudPostWordsGeneralizeResponse * _Nullable result, NSError *_Nullable error))finishBlock;

@end



NS_ASSUME_NONNULL_END
