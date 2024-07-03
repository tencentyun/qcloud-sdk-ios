//
//  QCloudSearchImageRequest.h
//  QCloudSearchImageRequest
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
#import "QCloudSearchImageResponse.h"

NS_ASSUME_NONNULL_BEGIN
/**

 图像检索.

 ### 功能描述

 可通过输入自然语言或图片，基于语义对数据集内文件进行图像检索。.

 具体请查看  https://cloud.tencent.com/document/product/460/106376

### 示例

  @code

	QCloudSearchImageRequest * request = [QCloudSearchImageRequest new];
	request.regionName = @"COS_REGIONNAME";
	request.input = [QCloudSearchImage new];
	// 数据集名称，同一个账户下唯一。;是否必传：是
	request.input.DatasetName = @"ImageSearch001";
	// 指定检索方式为图片或文本，pic 为图片检索，text 为文本检索，默认为 pic。;是否必传：否
	request.input.Mode = @"pic";
	// 资源标识字段，表示需要建立索引的文件地址(Mode 为 pic 时必选)。;是否必传：否
	request.input.URI = @"cos://facesearch-1258726280/huge_base.jpg";
	// 返回相关图片的数量，默认值为10，最大值为100。;是否必传：否
	request.input.Limit = 10;
	// 出参 Score（相关图片匹配得分） 中，只有超过 MatchThreshold 值的结果才会返回。默认值为0，推荐值为80。;是否必传：否
	request.input.MatchThreshold = 1;

	[request setFinishBlock:^(QCloudSearchImageResponse * outputObject, NSError *error) {
		// result：QCloudSearchImageResponse 包含所有的响应；
		// 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/106376
	}];
	[[QCloudCOSXMLService defaultCOSXML] SearchImage:request];


*/

@interface QCloudSearchImageRequest : QCloudBizHTTPRequest

/// 请求输入参数
@property (nonatomic,strong)QCloudSearchImage * input;

- (void)setFinishBlock:(void (^_Nullable)( QCloudSearchImageResponse * _Nullable result, NSError *_Nullable error))finishBlock;

@end



NS_ASSUME_NONNULL_END
