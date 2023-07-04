//
//  QCloudPostVideoRecognitionRequest.h
//  QCloudPostVideoRecognitionRequest
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
#import "QCloudRecognitionModel.h"
#import "QCloudVideoRecognitionResult.h"
#import "QCloudBatchRecognitionUserInfo.h"
NS_ASSUME_NONNULL_BEGIN
/**
 功能描述：
 
 本接口用于提交一个视频审核任务。视频审核功能为异步任务方式，您可以通过提交视频审核任务审核您的视频文件，然后通过查询视频审核任务接口查询审核结果。
 
 具体请查看：https://cloud.tencent.com/document/product/460/46427
 
 ### 示例
 
 @code
 
        QCloudPostVideoRecognitionRequest * request = [[QCloudPostVideoRecognitionRequest alloc]init];

        request.regionName = @"regionName";
        // 对象键，是对象在 COS 上的完整路径，如果带目录的话，格式为 "dir1/object1"
        request.object = @"exampleobject";
        // 存储桶名称，格式为 BucketName-APPID
        request.bucket = @"examplebucket-1250000000";

        // 审核类型，拥有 porn（涉黄识别）、terrorist（涉暴恐识别）、politics（涉政识别）、ads（广告识别）四种，
        // 用户可选择多种识别类型，例如 detect-type=porn,ads 表示对图片进行涉黄及广告审核
        // 截帧模式。Interval 表示间隔模式；Average 表示平均模式；Fps 表示固定帧率模式。
        // Interval 模式：TimeInterval，Count 参数生效。当设置 Count，未设置 TimeInterval 时，表示截取所有帧，共 Count 张图片。
        // Average 模式：Count 参数生效。表示整个视频，按平均间隔截取共 Count 张图片。
        // Fps 模式：TimeInterval 表示每秒截取多少帧，Count 表示共截取多少帧。
        request.mode = QCloudVideoRecognitionModeFps;

        // 视频截帧频率，范围为(0, 60]，单位为秒，支持 float 格式，执行精度精确到毫秒
        request.timeInterval = 1;

        // 视频截帧数量，范围为(0, 10000]。
        request.count = 10;

        // 审核策略，不带审核策略时使用默认策略。具体查看 https://cloud.tencent.com/document/product/460/56345
        request.bizType = BizType;

        // 用于指定是否审核视频声音，当值为0时：表示只审核视频画面截图；值为1时：表示同时审核视频画面截图和视频声音。默认值为0。
        request.detectContent = YES;

        request.finishBlock = ^(QCloudPostVideoRecognitionResult * outputObject, NSError *error) {
         // outputObject 提交审核反馈信息 包含用于查询的job id，详细字段请查看api文档或者SDK源码
         // QCloudPostVideoRecognitionResult 类；
        };
        [[QCloudCOSXMLService defaultCOSXML] PostVideoRecognition:request];
 
 */

typedef NS_ENUM(NSUInteger, QCloudVideoRecognitionMode) {
    QCloudVideoRecognitionModeInterval = 1,
    QCloudVideoRecognitionModeAverage,
    QCloudVideoRecognitionModeFps,
};

@interface QCloudPostVideoRecognitionRequest : QCloudBizHTTPRequest
/**
 当前 COS 存储桶中的视频文件名称，例如在目录 test 中的文件 video.mp4，则文件名称为 test/video.mp4。
 */
@property (strong, nonatomic) NSString *object;


/// 视频文件的链接地址，例如 http://examplebucket-1250000000.cos.ap-shanghai.myqcloud.com/test.mp4。Object 和 Url 只能选择其中一种。
@property (strong, nonatomic) NSString *url;
/**
 存储桶名
 */
@property (strong, nonatomic) NSString *bucket;

/// 该字段在审核结果中会返回原始内容，长度限制为512字节。您可以使用该字段对待审核的数据进行唯一业务标识。
@property (strong, nonatomic) NSString *dataId;

/// 截帧模式。Interval 表示间隔模式；Average 表示平均模式；Fps 表示固定帧率模式。
/// Interval 模式：TimeInterval，Count 参数生效。当设置 Count，未设置 TimeInterval 时，表示截取所有帧，共 Count 张图片。
/// Average 模式：Count 参数生效。表示整个视频，按平均间隔截取共 Count 张图片。
/// Fps 模式：TimeInterval 表示每秒截取多少帧，Count 表示共截取多少帧。
@property (assign, nonatomic) QCloudVideoRecognitionMode mode;


/// 视频截帧频率，范围为(0, 60]，单位为秒，支持 float 格式，执行精度精确到毫秒
@property (assign, nonatomic) NSInteger timeInterval;


/// 视频截帧数量，范围为(0, 10000]。
@property (assign, nonatomic) NSInteger count;


/// 用于指定是否审核视频声音，当值为0时：表示只审核视频画面截图；值为1时：表示同时审核视频画面截图和视频声音。默认值为0。
@property (assign, nonatomic) BOOL detectContent;


/// 审核策略，不带审核策略时使用默认策略。具体查看 https://cloud.tencent.com/document/product/460/56345
@property (strong, nonatomic) NSString * bizType;

/// 回调地址，以http://或者https://开头的地址。
@property (strong, nonatomic) NSString * callback;

/// 回调片段类型，有效值：1（回调全部截帧和音频片段）、2（回调违规截帧和音频片段）。默认为 1。
@property (assign, nonatomic) NSInteger callbackType;

/// 取值为[0,100]，表示当色情审核结果大于或等于该分数时，自动进行冻结操作。不填写则表示不自动冻结，默认值为空。
@property (assign, nonatomic) NSInteger pornScore;

/// 取值为[0,100]，表示当广告审核结果大于或等于该分数时，自动进行冻结操作。不填写则表示不自动冻结，默认值为空。
@property (assign, nonatomic) NSInteger adsScore;

/// 取值为[0,100]，表示当恐怖审核结果大于或等于该分数时，自动进行冻结操作。不填写则表示不自动冻结，默认值为空。
@property (assign, nonatomic) NSInteger terrorismScore;

/// 取值为[0,100]，表示当涉政审核结果大于或等于该分数时，自动进行冻结操作。不填写则表示不自动冻结，默认值为空。
@property (assign, nonatomic) NSInteger politicsScore;

@property (strong,nonatomic)QCloudBatchRecognitionUserInfo * userInfo;

@property (nonatomic,strong)QCloudBatchRecognitionEncryption *Encryption;

/**
 设置完成回调。请求完成后会通过该回调来获取结果，如果没有error，那么可以认为请求成功。

 @param finishBlock 请求完成回调
 */
- (void)setFinishBlock:(void (^_Nullable)(QCloudPostVideoRecognitionResult *_Nullable result, NSError *_Nullable error))finishBlock;

@end
NS_ASSUME_NONNULL_END
