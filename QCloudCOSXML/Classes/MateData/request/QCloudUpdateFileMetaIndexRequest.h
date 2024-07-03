//
//  QCloudUpdateFileMetaIndexRequest.h
//  QCloudUpdateFileMetaIndexRequest
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
#import "QCloudUpdateFileMetaIndexResponse.h"

NS_ASSUME_NONNULL_BEGIN
/**

 更新元数据索引.

 ### 功能描述

 更新数据集内已索引的一个文件的部分元数据。

并非所有的元数据都允许您自定义更新，在您发起更新请求时需要填写数据集，默认会根据该数据集的算子进行元数据重新提取并更新已存在的索引，此外您也可以更新部分自定义的元数据索引，如CustomTags、CustomId等字段，具体请参考请求参数一节。.

 具体请查看  https://cloud.tencent.com/document/product/460/106162.

### 示例

  @code

	QCloudUpdateFileMetaIndexRequest * request = [QCloudUpdateFileMetaIndexRequest new];
	request.regionName = @"COS_REGIONNAME";
	request.input = [QCloudUpdateFileMetaIndex new];
	// 数据集名称，同一个账户下唯一。;是否必传：是
	request.input.DatasetName = @"test001";
	// 用于建立索引的文件信息。;是否必传：是
	request.input.File = [QCloudUpdateMetaFile new];
	// 自定义ID。该文件索引到数据集后，作为该行元数据的属性存储，用于和您的业务系统进行关联、对应。您可以根据业务需求传入该值，例如将某个URI关联到您系统内的某个ID。推荐传入全局唯一的值。在查询时，该字段支持前缀查询和排序，详情请见[字段和操作符的支持列表](https://cloud.tencent.com/document/product/460/106154)。   ;是否必传：否
	request.input.File.CustomId = @"001";
	// 自定义标签。您可以根据业务需要自定义添加标签键值对信息，用于在查询时可以据此为筛选项进行检索，详情请见[字段和操作符的支持列表](https://cloud.tencent.com/document/product/460/106154)。  ;是否必传：否
	request.input.File.CustomLabels = [object Object];
	// 可选项，文件媒体类型，枚举值： image：图片。  other：其他。 document：文档。 archive：压缩包。 video：视频。  audio：音频。  ;是否必传：否
	request.input.File.MediaType = @"image";
	// 可选项，文件内容类型（MIME Type），如image/jpeg。  ;是否必传：否
	request.input.File.ContentType = @"image/jpeg";
	// 资源标识字段，表示需要建立索引的文件地址，当前仅支持COS上的文件，字段规则：cos:///，其中BucketName表示COS存储桶名称，ObjectKey表示文件完整路径，例如：cos://examplebucket-1250000000/test1/img.jpg。 注意： 1、仅支持本账号内的COS文件 2、不支持HTTP开头的地址;是否必传：是
	request.input.File.URI = @"cos://examplebucket-1250000000/test1/img.jpg";

	[request setFinishBlock:^(QCloudUpdateFileMetaIndexResponse * outputObject, NSError *error) {
		// result：QCloudUpdateFileMetaIndexResponse 包含所有的响应；
		// 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/106162
	}];
	[[QCloudCOSXMLService defaultCOSXML] UpdateFileMetaIndex:request];


*/

@interface QCloudUpdateFileMetaIndexRequest : QCloudBizHTTPRequest

/// 请求输入参数
@property (nonatomic,strong)QCloudUpdateFileMetaIndex * input;

- (void)setFinishBlock:(void (^_Nullable)( QCloudUpdateFileMetaIndexResponse * _Nullable result, NSError *_Nullable error))finishBlock;

@end



NS_ASSUME_NONNULL_END
