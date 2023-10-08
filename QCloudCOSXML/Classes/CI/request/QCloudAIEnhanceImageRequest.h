//
//  QCloudAIEnhanceImageRequest.h
//  QCloudAIEnhanceImageRequest
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


NS_ASSUME_NONNULL_BEGIN
/**

 图像增强.

 ### 功能描述

 腾讯云数据万象通过 AIEnhanceImage 接口对图像进行增强处理.

 具体请查看  https://cloud.tencent.com/document/product/460/83792

### 示例

  @code

	QCloudAIEnhanceImageRequest * request = [QCloudAIEnhanceImageRequest new];
	request.bucket = @"sample-1250000000";
	request.regionName = @"COS_REGIONNAME";
	// 数据万象处理能力，只能裁剪参固定为 AIEnhanceImage。;是否必传：true；
	request.ciProcess = @"AIEnhanceImage";
	// 去噪强度值，取值范围为 0 - 5 之间的整数，值为 0 时不进行去噪操作，默认值为3。;是否必传：false；
	request.denoise = 0;
	// 锐化强度值，取值范围为 0 - 5 之间的整数，值为 0 时不进行锐化操作，默认值为3。;是否必传：false；
	request.sharpen = 0;
	// 您可以通过填写 detect-url 处理任意公网可访问的图片链接。不填写 detect-url  时，后台会默认处理 ObjectKey ，填写了detect-url 时，后台会处理 detect-url链接，无需再填写 ObjectKey ，detect-url 示例：http://www.example.com/abc.jpg ，需要进行 UrlEncode，处理后为  http%25253A%25252F%25252Fwww.example.com%25252Fabc.jpg;是否必传：false；
	request.detectUrl = @"";
	// ;是否必传：false；
	request.ignoreError = 0;

	[request setFinishBlock:^(id outputObject, NSError *error) {
        UIImage * resultImage = [UIImage imageWithData:outputObject]; // 结果图片
	}];
	[[QCloudCOSXMLService defaultCOSXML] AIEnhanceImage:request];


*/

@interface QCloudAIEnhanceImageRequest : QCloudBizHTTPRequest

/// 数据万象处理能力，只能裁剪参固定为 AIEnhanceImage。;是否必传：是
@property (nonatomic,strong) NSString * ciProcess;

/// 去噪强度值，取值范围为 0 - 5 之间的整数，值为 0 时不进行去噪操作，默认值为3。;是否必传：否
@property (nonatomic,assign)NSInteger denoise;

/// 锐化强度值，取值范围为 0 - 5 之间的整数，值为 0 时不进行锐化操作，默认值为3。;是否必传：否
@property (nonatomic,assign)NSInteger sharpen;

/// 您可以通过填写 detect-url 处理任意公网可访问的图片链接。不填写 detect-url  时，后台会默认处理 ObjectKey ，填写了detect-url 时，后台会处理 detect-url链接，无需再填写 ObjectKey ，detect-url 示例：http://www.example.com/abc.jpg ，需要进行 UrlEncode，处理后为  http%25253A%25252F%25252Fwww.example.com%25252Fabc.jpg;是否必传：否
@property (nonatomic,strong) NSString * detectUrl;

/// ;是否必传：否
@property (nonatomic,assign)NSInteger ignoreError;

/// 存储桶名称
@property (nonatomic,strong)NSString * bucket;

@property (nonatomic,strong)NSString * ObjectKey;

- (void)setFinishBlock:(void (^_Nullable)( id _Nullable result, NSError *_Nullable error))finishBlock;

@end



NS_ASSUME_NONNULL_END
