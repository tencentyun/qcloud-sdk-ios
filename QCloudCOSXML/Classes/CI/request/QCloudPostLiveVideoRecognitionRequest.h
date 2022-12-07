//
//  QCloudPostLiveVideoRecognitionRequest.h
//  QCloudPostLiveVideoRecognitionRequest
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
#import "QCloudVideoRecognitionResult.h"
@class QCloudLiveVideoRecognitionUserInfo;
NS_ASSUME_NONNULL_BEGIN
/**
 功能描述：
 
 本接口用于提交一个直播流审核任务。直播流审核功能为异步任务方式，您可以通过提交直播流审核任务审核您的直播流，然后通过查询直播流审核任务接口查询审核结果。
 
 具体请查看：https://cloud.tencent.com/document/product/460/76261
 
 ### 示例
 
 @code
 
        QCloudPostLiveVideoRecognitionRequest * request = [[QCloudPostLiveVideoRecognitionRequest alloc]init];

        request.regionName = @"regionName";

        // 存储桶名称，格式为 BucketName-APPID
        request.bucket = @"examplebucket-1250000000";
 
        // 表示直播流所要转存的路径，直播流的 ts 文件和 m3u8 文件将保存在本桶该目录下。m3u8 文件保存文件名为 Path/{$JobId}.m3u8，ts 文件的保存文件名为 Path/{$JobId}-{$Realtime}.ts，其中 Realtime 为17位年月日时分秒毫秒时间。
        request.path = @"test";
 
        // 需要审核的直播流播放地址，例如 rtmp://example.com/live/123。
        request.url = @"test";
 
        // 审核策略，不带审核策略时使用默认策略。具体查看 https://cloud.tencent.com/document/product/460/56345
        request.bizType = BizType;

        request.finishBlock = ^(QCloudPostVideoRecognitionResult * outputObject, NSError *error) {
         // outputObject 提交审核反馈信息 包含用于查询的job id，详细字段请查看api文档或者SDK源码
         // QCloudPostVideoRecognitionResult 类；
        };
        [[QCloudCOSXMLService defaultCOSXML] PostLiveVideoRecognition:request];
 
 */

@interface QCloudPostLiveVideoRecognitionRequest : QCloudBizHTTPRequest

/**
 存储桶名
 */
@property (strong, nonatomic) NSString *bucket;

/// 需要审核的直播流播放地址，例如 rtmp://example.com/live/123。
@property (strong, nonatomic) NSString *url;

/// 该字段在审核结果中会返回原始内容，长度限制为512字节。您可以使用该字段对待审核的数据进行唯一业务标识。
@property (strong, nonatomic) NSString *dataId;

/// 自定义字段，可用于辅助行为数据分析。    非必传
@property (strong, nonatomic) QCloudLiveVideoRecognitionUserInfo *userInfo;

/// 审核策略，不带审核策略时使用默认策略。具体查看 https://cloud.tencent.com/document/product/460/56345
@property (strong, nonatomic) NSString * bizType;

/// 回调地址，以http://或者https://开头的地址。
@property (strong, nonatomic) NSString * callback;

/// 回调片段类型，有效值：1（回调全部截帧和音频片段）、2（仅回调违规截帧和音频片段）。默认为 1。
@property (assign, nonatomic) NSInteger callbackType;

/// 表示直播流所要转存的路径，直播流的 ts 文件和 m3u8 文件将保存在本桶该目录下。
/// m3u8 文件保存文件名为 Path/{$JobId}.m3u8，ts 文件的保存文件名为 Path/{$JobId}-{$Realtime}.ts，其中 Realtime 为17位年月日时分秒毫秒时间。
@property (strong, nonatomic) NSString * path;

/**
 设置完成回调。请求完成后会通过该回调来获取结果，如果没有error，那么可以认为请求成功。
 @param finishBlock 请求完成回调
 */
- (void)setFinishBlock:(void (^_Nullable)(QCloudPostVideoRecognitionResult *_Nullable result, NSError *_Nullable error))finishBlock;

@end

@interface QCloudLiveVideoRecognitionUserInfo : NSObject

///  一般用于表示账号信息，长度不超过128字节。
@property (strong, nonatomic) NSString * TokenId;

///  一般用于表示昵称信息，长度不超过128字节。
@property (strong, nonatomic) NSString * Nickname;

///  一般用于表示设备信息，长度不超过128字节。
@property (strong, nonatomic) NSString * DeviceId;

///  一般用于表示 App 的唯一标识，长度不超过128字节。
@property (strong, nonatomic) NSString * AppId;

///  一般用于表示房间号信息，长度不超过128字节。
@property (strong, nonatomic) NSString * Room;

///  一般用于表示 IP 地址信息，长度不超过128字节。
@property (strong, nonatomic) NSString * IP;

///  一般用于表示业务类型，长度不超过128字节。
@property (strong, nonatomic) NSString * Type;

///  一般用于表示接收消息的用户账号，长度不超过128字节。
@property (strong, nonatomic) NSString * ReceiveTokenId;

///  一般用于表示性别信息，长度不超过128字节。
@property (strong, nonatomic) NSString * Gender;

///  一般用于表示等级信息，长度不超过128字节。
@property (strong, nonatomic) NSString * Level;

///  一般用于表示角色信息，长度不超过128字节。
@property (strong, nonatomic) NSString * Role;

@end
NS_ASSUME_NONNULL_END
