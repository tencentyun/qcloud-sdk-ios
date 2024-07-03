//
//  QCloudDatasetFaceSearchRequest.h
//  QCloudDatasetFaceSearchRequest
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
#import "QCloudDatasetFaceSearchResponse.h"

NS_ASSUME_NONNULL_BEGIN
/**

 人脸搜索.

 ### 功能描述

 从数据集中搜索与指定图片最相似的前N张图片并返回人脸坐标可对数据集内文件进行一个或多个人员的人脸识别。.

 具体请查看  https://cloud.tencent.com/document/product/460/106166.

### 示例

  @code

	QCloudDatasetFaceSearchRequest * request = [QCloudDatasetFaceSearchRequest new];
	request.regionName = @"COS_REGIONNAME";
	request.input = [QCloudDatasetFaceSearch new];
	// 数据集名称，同一个账户下唯一。;是否必传：是
	request.input.DatasetName = @"test";
	// 资源标识字段，表示需要建立索引的文件地址。;是否必传：是
	request.input.URI = @"cos://examplebucket-1250000000/test.jpg";
	// 输入图片中检索的人脸数量，默认值为1(传0或不传采用默认值)，最大值为10。;是否必传：否
	request.input.MaxFaceNum = 1;
	// 检索的每张人脸返回相关人脸数量，默认值为10，最大值为100。;是否必传：否
	request.input.Limit = 10;
	// 限制返回人脸的最低相关度分数，只有超过 MatchThreshold 值的人脸才会返回。默认值为0，推荐值为80。 例如：设置 MatchThreshold 的值为80，则检索结果中仅会返回相关度分数大于等于80分的人脸。;是否必传：否
	request.input.MatchThreshold = 10;

	[request setFinishBlock:^(QCloudDatasetFaceSearchResponse * outputObject, NSError *error) {
		// result：QCloudDatasetFaceSearchResponse 包含所有的响应；
		// 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/106166
	}];
	[[QCloudCOSXMLService defaultCOSXML] DatasetFaceSearch:request];


*/

@interface QCloudDatasetFaceSearchRequest : QCloudBizHTTPRequest

/// 请求输入参数
@property (nonatomic,strong)QCloudDatasetFaceSearch * input;

- (void)setFinishBlock:(void (^_Nullable)( QCloudDatasetFaceSearchResponse * _Nullable result, NSError *_Nullable error))finishBlock;

@end



NS_ASSUME_NONNULL_END
