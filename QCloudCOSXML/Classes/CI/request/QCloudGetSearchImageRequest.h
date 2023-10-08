//
//  QCloudGetSearchImageRequest.h
//  QCloudGetSearchImageRequest
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
#import "QCloudGetSearchImageResponse.h"

NS_ASSUME_NONNULL_BEGIN
/**

 图片搜索接口.

 ### 功能描述

 该接口用于检索图片.

 具体请查看  https://cloud.tencent.com/document/product/460/63901.

### 示例

  @code

	QCloudGetSearchImageRequest * request = [QCloudGetSearchImageRequest new];
	request.bucket = @"sample-1250000000";
	request.regionName = @"COS_REGIONNAME";
	// 出参 Score 中，只有超过 MatchThreshold 值的结果才会返回。默认为0;是否必传：false；
	request.MatchThreshold = 0;
	// 起始序号，默认值为0;是否必传：false；
	request.Offset = 0;
	// 返回数量，默认值为10，最大值为100;是否必传：false；
	request.Limit = 0;
 
    request.ciProcess = @"ImageSearch";
    request.action = @"SearchImage";
	// 针对入库时提交的 Tags 信息进行条件过滤。支持>、>=、<、<=、=、!=，多个条件之间支持 AND 和 OR 进行连接;是否必传：false；
	request.Filter = ;

	[request setFinishBlock:^(QCloudGetSearchImageResponse * outputObject, NSError *error) {
		// result：QCloudGetSearchImageResponse 包含所有的响应；
		// 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/63901
	}];
	[[QCloudCOSXMLService defaultCOSXML] GetSearchImage:request];


*/

@interface QCloudGetSearchImageRequest : QCloudBizHTTPRequest

/// 出参 Score 中，只有超过 MatchThreshold 值的结果才会返回。默认为0;是否必传：否
@property (nonatomic,assign)NSInteger MatchThreshold;

/// 起始序号，默认值为0;是否必传：否
@property (nonatomic,assign)NSInteger Offset;

/// 返回数量，默认值为10，最大值为100;是否必传：否
@property (nonatomic,assign)NSInteger Limit;

/// 针对入库时提交的 Tags 信息进行条件过滤。支持>、>=、<、<=、=、!=，多个条件之间支持 AND 和 OR 进行连接;是否必传：否
@property (nonatomic,strong) NSString * Filter;

/// 存储桶名称
@property (nonatomic,strong)NSString * bucket;

@property (nonatomic,strong)NSString * ObjectKey;

/// 固定值：ImageSearch;是否必传：是
@property (nonatomic,strong) NSString * ciProcess;

/// 固定值：SearchImage;是否必传：是
@property (nonatomic,strong) NSString * action;


- (void)setFinishBlock:(void (^_Nullable)( QCloudGetSearchImageResponse * _Nullable result, NSError *_Nullable error))finishBlock;

@end



NS_ASSUME_NONNULL_END
