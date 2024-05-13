//
//  QCloudCreateQRcodeRequest.h
//  QCloudCreateQRcodeRequest
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
#import "QCloudCreateQRcodeResponse.h"

NS_ASSUME_NONNULL_BEGIN
/**

 图片二维码生成.

 ### 功能描述

 数据万象二维码生成功能可根据用户指定的文本信息（URL 或文本），生成对应的二维码或条形码.

 具体请查看  https://cloud.tencent.com/document/product/460/53491

### 示例

  @code

	QCloudCreateQRcodeRequest * request = [QCloudCreateQRcodeRequest new];
	request.bucket = @"sample-1250000000";
	request.regionName = @"COS_REGIONNAME";
	// 数据万象处理能力，二维码生成参数为 qrcode-generate;是否必传：true；
	request.ciProcess = @"qrcode-generate";
	// 可识别的二维码文本信息;是否必传：true；
	request.qrcodeContent = ;
	// 生成的二维码类型，可选值：0或1。0为二维码，1为条形码，默认值为0;是否必传：false；
	request.mode = 0;
	// 指定生成的二维码或条形码的宽度，高度会进行等比压缩;是否必传：true；
	request.width = ;

	[request setFinishBlock:^(QCloudCreateQRcodeResponse * outputObject, NSError *error) {
		// result：QCloudCreateQRcodeResponse 包含所有的响应；
		// 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/53491
	}];
	[[QCloudCOSXMLService defaultCOSXML] CreateQRcode:request];


*/

@interface QCloudCreateQRcodeRequest : QCloudBizHTTPRequest

/// 数据万象处理能力，二维码生成参数为 qrcode-generate;是否必传：是
@property (nonatomic,strong) NSString * ciProcess;

/// 可识别的二维码文本信息;是否必传：是
@property (nonatomic,strong) NSString * qrcodeContent;

/// 生成的二维码类型，可选值：0或1。0为二维码，1为条形码，默认值为0;是否必传：否
@property (nonatomic,assign)NSInteger mode;

/// 指定生成的二维码或条形码的宽度，高度会进行等比压缩;是否必传：是
@property (nonatomic,strong) NSString * width;

/// 存储桶名称
@property (nonatomic,strong)NSString * bucket;

- (void)setFinishBlock:(void (^_Nullable)( QCloudCreateQRcodeResponse * _Nullable result, NSError *_Nullable error))finishBlock;

@end



NS_ASSUME_NONNULL_END
