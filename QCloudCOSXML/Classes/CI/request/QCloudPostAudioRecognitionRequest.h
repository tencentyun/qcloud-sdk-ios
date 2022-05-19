//
//  QCloudPostAudioRecognitionRequest.h
//  QCloudPostAudioRecognitionRequest
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
#import "QCloudAudioRecognitionResult.h"
@class QCloudPostAudioRecognitionResult;
NS_ASSUME_NONNULL_BEGIN
/**
 功能描述：

 本接口用于提交一个音频审核任务。音频审核功能为异步任务方式，您可以通过提交音频审核任务审核您的音频文件，然后通过查询音频审核任务接口查询审核结果。
 
 具体请查看：https://cloud.tencent.com/document/product/460/53395
 
 ### 示例
 
 @code
 
        QCloudPostAudioRecognitionRequest * request = [[QCloudPostAudioRecognitionRequest alloc]init];

        // 对象键，是对象在 COS 上的完整路径，如果带目录的话，格式为 "dir1/object1"
        request.object = @"exampleobject";
        // 存储桶名称，格式为 BucketName-APPID
        request.bucket = @"examplebucket-1250000000";

        request.detectType = QCloudRecognitionPorn | QCloudRecognitionAds;

        request.bizType = BizType;
 
        request.regionName = @"regionName";
 
        request.finishBlock = ^(QCloudPostAudioRecognitionResult * outputObject, NSError *error) {
         // outputObject 提交审核反馈信息 包含用于查询的job id，详细字段请查看api文档或者SDK源码
         // QCloudPostAudioRecognitionResult 类；
        };
        [[QCloudCOSXMLService defaultCOSXML] PostAudioRecognition:request];
 
 */

@interface QCloudPostAudioRecognitionRequest : QCloudBizHTTPRequest
/**
 存储在 COS 存储桶中的音频文件名称，例如在目录 test 中的文件audio.mp3，则文件名称为 test/audio.mp3。Object 和 Url 只能选择其中一种。
 */
@property (strong, nonatomic) NSString *object;


/// 音频文件的链接地址，例如 http://examplebucket-1250000000.cos.ap-shanghai.myqcloud.com/audio.mp3。Object 和 Url 只能选择其中一种。
@property (strong, nonatomic) NSString *url;
/**
 存储桶名
 */
@property (strong, nonatomic) NSString *bucket;


/// 该字段在审核结果中会返回原始内容，长度限制为512字节。您可以使用该字段对待审核的数据进行唯一业务标识。
@property (strong, nonatomic) NSString *dataId;

/// 审核的场景类型，有效值：Porn（涉黄）、Ads（广告），可以传入多种类型，不同类型以逗号分隔，例如：Porn,Ads。
/// 用户可选择多种识别类型，例如 detect-type=porn,ads 表示对图片进行涉黄及广告审核
/// 可以使用或进行组合赋值 如： QCloudRecognitionPorn | QCloudRecognitionAds
@property (assign, nonatomic) QCloudRecognitionEnum detectType;

/// 审核策略，不带审核策略时使用默认策略。具体查看 https://cloud.tencent.com/document/product/460/56345
@property (strong, nonatomic) NSString * bizType;


/// 回调地址，以http://或者https://开头的地址。
@property (strong, nonatomic) NSString * callback;


/**
 设置完成回调。请求完成后会通过该回调来获取结果，如果没有error，那么可以认为请求成功。

 @param finishBlock 请求完成回调
 */
- (void)setFinishBlock:(void (^_Nullable)(QCloudPostAudioRecognitionResult *_Nullable result, NSError *_Nullable error))finishBlock;

@end
NS_ASSUME_NONNULL_END
