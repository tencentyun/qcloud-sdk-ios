//
//  QCloudAIGameRecRequest.h
//  QCloudAIGameRecRequest
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
#import "QCloudAIGameRecResponse.h"

NS_ASSUME_NONNULL_BEGIN
/**

 游戏场景识别.

 ### 功能描述

 游戏标签功能实现游戏图片场景的识别，返回图片中置信度较高的游戏类别标签。游戏标签识别请求包属于 GET 请求，请求时需要携带签名.

 具体请查看  https://cloud.tencent.com/document/product/460/93153

### 示例

  @code

	QCloudAIGameRecRequest * request = [QCloudAIGameRecRequest new];
	request.bucket = @"sample-1250000000";
	request.regionName = @"COS_REGIONNAME";
	// String;是否必传：false；
	request.ObjectKey = null;
	// String;是否必传：true；
	request.detectUrl = null;
 
    request.ciProcess = @"AIGameRec";

	[request setFinishBlock:^(QCloudAIGameRecResponse * outputObject, NSError *error) {
		// result：QCloudAIGameRecResponse 包含所有的响应；
		// 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/93153
	}];
	[[QCloudCOSXMLService defaultCOSXML] AIGameRec:request];


*/

@interface QCloudAIGameRecRequest : QCloudBizHTTPRequest

/// String;是否必传：否
@property (nonatomic,strong)NSString * ObjectKey;

/// String;是否必传：是
@property (nonatomic,strong)NSString * detectUrl;


/// 固定值：AIGameRec
@property (nonatomic,strong)NSString * ciProcess;

/// 存储桶名称
@property (nonatomic,strong)NSString * bucket;

- (void)setFinishBlock:(void (^_Nullable)( QCloudAIGameRecResponse * _Nullable result, NSError *_Nullable error))finishBlock;

@end



NS_ASSUME_NONNULL_END
