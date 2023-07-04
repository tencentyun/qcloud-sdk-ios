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
#import "QCloudBatchRecognitionUserInfo.h"
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

/// 审核策略，不带审核策略时使用默认策略。具体查看 https://cloud.tencent.com/document/product/460/56345
@property (strong, nonatomic) NSString * bizType;


/// 回调地址，以http://或者https://开头的地址。
@property (strong, nonatomic) NSString * callback;

/// 回调片段类型，有效值：1（回调全部音频片段）、2（回调违规音频片段）。默认为 1。
@property (assign, nonatomic) NSInteger callbackType;

/// 取值为[0,100]，表示当色情审核结果大于或等于该分数时，自动进行冻结操作。不填写则表示不自动冻结，默认值为空。
@property (assign, nonatomic) NSInteger pornScore;

/// 取值为[0,100]，表示当广告审核结果大于或等于该分数时，自动进行冻结操作。不填写则表示不自动冻结，默认值为空。
@property (assign, nonatomic) NSInteger adsScore;

/// 取值为[0,100]，表示当恐怖审核结果大于或等于该分数时，自动进行冻结操作。不填写则表示不自动冻结，默认值为空。
@property (assign, nonatomic) NSInteger terrorismScore;

/// 取值为[0,100]，表示当涉政审核结果大于或等于该分数时，自动进行冻结操作。不填写则表示不自动冻结，默认值为空。
@property (assign, nonatomic) NSInteger politicsScore;


/// 用户业务字段。
@property (strong, nonatomic) QCloudBatchRecognitionUserInfo * userInfo;

/**
 设置完成回调。请求完成后会通过该回调来获取结果，如果没有error，那么可以认为请求成功。

 @param finishBlock 请求完成回调
 */
- (void)setFinishBlock:(void (^_Nullable)(QCloudPostAudioRecognitionResult *_Nullable result, NSError *_Nullable error))finishBlock;

@end
NS_ASSUME_NONNULL_END
