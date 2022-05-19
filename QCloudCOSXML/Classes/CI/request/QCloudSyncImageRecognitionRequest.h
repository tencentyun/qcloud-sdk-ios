//
//  QCloudSyncImageRecognitionRequest.h
//  QCloudSyncImageRecognitionRequest
//
//  Created by tencent
//  Copyright (c) 2020年 tencent. All rights reserved.
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
#import <QCloudCore/QCloudCore.h>
#import "QCloudRecognitionEnum.h"
@class QCloudImageRecognitionResult;
NS_ASSUME_NONNULL_BEGIN

/**
 功能描述：

 图片审核功能通过深度学习技术，识别可能令人反感、不安全或不适宜的违规图片内容。该功能为同步请求方式，您可以通过本接口对图片进行内容审核。该接口属于 GET 请求。
 该接口支持情况如下：

 支持审核的图片方式：
 审核 COS 上的图片文件
 审核可访问的图片链接（支持传输协议：HTTP、HTTPS）
 支持对 GIF 图进行截帧审核。
 支持识别多种违规场景，包括：低俗、违法违规、色情、广告等场景。
 支持多种物体检测（实体、广告台标、二维码等）及图片中的文字（即 OCR 文本审核）。
 支持根据不同的业务场景 配置自定义审核策略。
 支持用户自定义选择图片风险库，打击自定义识别类型的违规图片（目前仅支持黑名单配置）。
 具体请查看：https://cloud.tencent.com/document/product/460/37318

  @code
 
     QCloudSyncImageRecognitionRequest * request = [[QCloudSyncImageRecognitionRequest alloc]init];
 
     // 存储桶名称，格式为 BucketName-APPID
     request.bucket = @"examplebucket-1250000000";
 
     request.regionName = @"regionName";
     request.object = @"***.jpg";
     request.detectType = QCloudRecognitionPorn | QCloudRecognitionTerrorist | QCloudRecognitionPolitics | QCloudRecognitionAds;
     [request setFinishBlock:^(QCloudImageRecognitionResult * _Nullable result, NSError * _Nullable error) {
     }];
     [[QCloudCOSXMLService defaultCOSXML] SyncImageRecognition:request];
        

*/
@interface QCloudSyncImageRecognitionRequest : QCloudBizHTTPRequest


///  COS 存储桶中的图片文件名称，COS 存储桶由Host指定，
///  例如在北京的 examplebucket-1250000000存储桶中的目录 test 下的文件 img.jpg，
///  object填写 test/img.jpg
@property (strong, nonatomic) NSString *object;

/// 存储桶名
@property (strong, nonatomic) NSString *bucket;

/// 您可以通过填写detectUrl审核任意公网可访问的图片链接
/// 不填写detectUrl时，后台会默认审核ObjectKey
/// 填写了detectUrl时，后台会审核detect-url链接，无需再填写ObjectKey
/// detectUrl示例：http://www.example.com/abc.jpg
@property (strong, nonatomic) NSString *detectUrl;

/// 审核 GIF 动图时，可使用该参数进行截帧配置，代表截帧的间隔。例如值设为5，则表示从第1帧开始截取，每隔5帧截取一帧，默认值5
@property (assign, nonatomic) NSInteger interval;


/// 针对 GIF 动图审核的最大截帧数量，需大于0。例如值设为5，则表示最大截取5帧，默认值为5
@property (assign, nonatomic) NSInteger maxFrames;


/// 对于超过大小限制的图片，可通过该参数选择是否需要压缩图片后再审核，压缩为后台默认操作，会产生额外的 基础图片处理用量
/// 取值为：0（不压缩），1（压缩）。默认为0。 注意：最大支持压缩32MB的图片。
@property (strong, nonatomic) NSString *largeImageDetect;


/// 审核类型，拥有 porn（涉黄识别）、ads（广告识别）。用户可选择多种识别类型，例如 detect-type=porn,ads 表示对图片进行涉黄及广告审核
@property (assign, nonatomic) QCloudRecognitionEnum detectType;

/// 审核策略，不带审核策略时使用默认策略。具体查看 https://cloud.tencent.com/document/product/460/56345
@property (strong, nonatomic) NSString * bizType;

/**
 设置完成回调。请求完成后会通过该回调来获取结果，如果没有error，那么可以认为请求成功。
 @param finishBlock 请求完成回调
 */
- (void)setFinishBlock:(void (^_Nullable)(QCloudImageRecognitionResult *_Nullable result, NSError *_Nullable error))finishBlock;

@end
NS_ASSUME_NONNULL_END
