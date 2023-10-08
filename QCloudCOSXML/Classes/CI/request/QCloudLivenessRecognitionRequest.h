//
//  QCloudLivenessRecognitionRequest.h
//  QCloudLivenessRecognitionRequest
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
#import "QCloudLivenessRecognitionResponse.h"

NS_ASSUME_NONNULL_BEGIN
/**

 活体人脸核身.

 ### 功能描述

 集成了活体检测和跟权威库进行比对的能力，传入一段视频和姓名、身份证号信息即可进行验证。对录制的自拍视频进行活体检测，从而确认当前用户为真人，可防止照片、视频、静态3D建模等各种不同类型的攻击。检测为真人后，再判断该视频中的人与权威库的证件照是否属于同一个人，实现用户身份信息核实.

 具体请查看  https://cloud.tencent.com/document/product/460/48641

### 示例

  @code

	QCloudLivenessRecognitionRequest * request = [QCloudLivenessRecognitionRequest new];
	request.bucket = @"sample-1250000000";
	request.regionName = @"COS_REGIONNAME";
	// 数据万象处理能力，人脸核身固定为 LivenessRecognition;是否必传：true；
	request.ciProcess = @"LivenessRecognition";
	// 身份证号;是否必传：true；
	request.IdCard = ;
	// 姓名。;是否必传：true；
	request.Name = ;
	// 活体检测类型，取值：LIP/ACTION/SILENTLIP 为数字模式，ACTION 为动作模式，SILENT 为静默模式，三种模式选择一种传入;是否必传：true；
	request.LivenessType = ;
	// 数字模式传参：数字验证码（1234），需先调用接口获取数字验证码动作模式传参：传动作顺序（2，1 or 1，2），需先调用接口获取动作顺序静默模式传参：空;是否必传：false；
	request.ValidateData = ;
	// 需要返回多张最佳截图，取值范围1 - 10，不设置默认返回一张最佳截图;是否必传：false；
	request.BestFrameNum = 0;

	[request setFinishBlock:^(QCloudLivenessRecognitionResponse * outputObject, NSError *error) {
		// result：QCloudLivenessRecognitionResponse 包含所有的响应；
		// 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/48641
	}];
	[[QCloudCOSXMLService defaultCOSXML] LivenessRecognition:request];


*/

@interface QCloudLivenessRecognitionRequest : QCloudBizHTTPRequest

/// 数据万象处理能力，人脸核身固定为 LivenessRecognition;是否必传：是
@property (nonatomic,strong) NSString * ciProcess;

/// 身份证号;是否必传：是
@property (nonatomic,strong) NSString * IdCard;

/// 姓名。是否必传：是
@property (nonatomic,strong) NSString * Name;

/// 活体检测类型，取值：LIP/ACTION/SILENTLIP 为数字模式，ACTION 为动作模式，SILENT 为静默模式，三种模式选择一种传入;是否必传：是
@property (nonatomic,strong) NSString * LivenessType;

/// 数字模式传参：数字验证码（1234），需先调用接口获取数字验证码动作模式传参：传动作顺序（2，1 or 1，2），需先调用接口获取动作顺序静默模式传参：空;是否必传：否
@property (nonatomic,strong) NSString * ValidateData;

/// 需要返回多张最佳截图，取值范围1 - 10，不设置默认返回一张最佳截图;是否必传：否
@property (nonatomic,assign)NSInteger BestFrameNum;

/// 存储桶名称
@property (nonatomic,strong)NSString * bucket;

@property (nonatomic,strong)NSString * ObjectKey;

- (void)setFinishBlock:(void (^_Nullable)( QCloudLivenessRecognitionResponse * _Nullable result, NSError *_Nullable error))finishBlock;

@end



NS_ASSUME_NONNULL_END
