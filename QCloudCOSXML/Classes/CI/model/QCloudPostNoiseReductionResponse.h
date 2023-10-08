//
//  QCloudPostNoiseReductionResponse.h
//  QCloudPostNoiseReductionResponse
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
#import <QCloudCore/QCloudCore.h>
#import "QCloudCICommonModel.h"

NS_ASSUME_NONNULL_BEGIN

@class QCloudPostNoiseReductionResponseJobsDetail;
@class QCloudPostNoiseReductionResponseInput;
@class QCloudPostNoiseReductionResponseOperation;
@class QCloudPostNoiseReductionOutput;
@class QCloudPostNoiseReductionInput;
@class QCloudPostNoiseReductionOperation;
@interface QCloudPostNoiseReductionResponse : NSObject 

/// 任务的详细信息
@property (nonatomic,strong)NSArray <QCloudPostNoiseReductionResponseJobsDetail * > * JobsDetail;

@end

@interface QCloudPostNoiseReductionResponseJobsDetail : NSObject 

/// 错误码，只有 State 为 Failed 时有意义
@property (nonatomic,strong) NSString * Code;

/// 错误描述，只有 State 为 Failed 时有意义
@property (nonatomic,strong) NSString * Message;

/// 新创建任务的 ID
@property (nonatomic,strong) NSString * JobId;

/// 新创建任务的 Tag：NoiseReduction
@property (nonatomic,strong) NSString * Tag;

/// 任务状态Submitted：已提交，待执行Running：执行中Success：执行成功Failed：执行失败Pause：任务暂停，当暂停队列时，待执行的任务会变为暂停状态Cancel：任务被取消执行
@property (nonatomic,strong) NSString * State;

/// 任务的创建时间
@property (nonatomic,strong) NSString * CreationTime;

/// 任务的结束时间
@property (nonatomic,strong) NSString * EndTime;

/// 任务所属的 队列 ID﻿
@property (nonatomic,strong) NSString * QueueId;

/// 该任务的输入资源地址
@property (nonatomic,strong) QCloudPostNoiseReductionResponseInput * Input;

/// 该任务的操作规则
@property (nonatomic,strong) QCloudPostNoiseReductionResponseOperation * Operation;

@end

@interface QCloudPostNoiseReductionResponseInput : NSObject 

/// 存储桶的地域
@property (nonatomic,strong) NSString * Region;

/// 存储结果的存储桶
@property (nonatomic,strong) NSString * Bucket;

/// 输出结果的文件名
@property (nonatomic,strong) NSString * Object;

@end

@interface QCloudPostNoiseReductionResponseOperation : NSObject 

/// 降噪模板ID
@property (nonatomic,strong) NSString * TemplateId;

/// 任务的模板名称, 当 TemplateId 存在时返回
@property (nonatomic,strong) NSString * TemplateName;

/// 同请求中的 Request.Operation.NoiseReduction
@property (nonatomic,strong) QCloudNoiseReduction * NoiseReuction;

/// 同请求中的 Request.Operation.Output
@property (nonatomic,strong) QCloudPostNoiseReductionOutput * Output;

/// 透传用户信息
@property (nonatomic,strong) NSString * UserData;

/// 任务优先级
@property (nonatomic,strong) NSString * JobLevel;

@end

@interface QCloudPostNoiseReductionOutput : NSObject 

/// 存储桶的地域;是否必传：是
@property (nonatomic,strong) NSString * Region;

/// 存储结果的存储桶;是否必传：是
@property (nonatomic,strong) NSString * Bucket;

/// 输出结果的文件名;是否必传：是
@property (nonatomic,strong) NSString * Object;

@end

@interface QCloudPostNoiseReduction : NSObject 

/// 创建任务的 Tag：NoiseReduction;是否必传：是
@property (nonatomic,strong) NSString * Tag;

/// 待操作的文件信息;是否必传：是
@property (nonatomic,strong) QCloudPostNoiseReductionInput * Input;

/// 操作规则;是否必传：是
@property (nonatomic,strong) QCloudPostNoiseReductionOperation * Operation;

/// 任务回调格式，JSON 或 XML，默认 XML，优先级高于队列的回调格式;是否必传：否
@property (nonatomic,strong) NSString * CallBackFormat;

/// 任务回调类型，Url 或 TDMQ，默认 Url，优先级高于队列的回调类型;是否必传：否
@property (nonatomic,strong) NSString * CallBackType;

/// 任务回调地址，优先级高于队列的回调地址。设置为 no 时，表示队列的回调地址不产生回调;是否必传：否
@property (nonatomic,strong) NSString * CallBack;

/// 任务回调TDMQ配置，当 CallBackType 为 TDMQ 时必填。详情见 CallBackMqConfig;是否必传：否
@property (nonatomic,strong) QCloudCallBackMqConfig * CallBackMqConfig;

@end

@interface QCloudPostNoiseReductionInput : NSObject 

/// 执行音频降噪任务的文件路径目前只支持文件大小在10M之内的音频 如果输入为视频文件或者多通道的音频，只会保留单通道的音频流 目前暂不支持m3u8格式输入;是否必传：是
@property (nonatomic,strong) NSString * Object;

@end

@interface QCloudPostNoiseReductionOperation : NSObject 

/// 降噪模板ID;是否必传：否
@property (nonatomic,strong) NSString * TemplateId;

/// 降噪任务参数，同创建降噪模板接口中的 Request.NoiseReduction;是否必传：否
@property (nonatomic,strong) QCloudNoiseReduction * NoiseReduction;

/// 任务优先级，级别限制：0 、1 、2 。级别越大任务优先级越高，默认为0;是否必传：否
@property (nonatomic,strong) NSString * JobLevel;

/// 透传用户信息，可打印的 ASCII 码，长度不超过1024;是否必传：否
@property (nonatomic,strong) NSString * UserData;

/// 结果输出配置;是否必传：是
@property (nonatomic,strong) QCloudPostNoiseReductionOutput * Output;

@end



NS_ASSUME_NONNULL_END
