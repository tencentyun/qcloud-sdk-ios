//
//  QCloudPostVoiceSynthesisResponse.h
//  QCloudPostVoiceSynthesisResponse
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

@class QCloudPostVoiceSynthesisResponseJobsDetail;
@class QCloudPostVoiceSynthesisResponseOperation;
@class QCloudPostVoiceSynthesisOutput;
@class QCloudPostVoiceSynthesisTtsConfig;
@class QCloudPostVoiceSynthesisTtsTpl;
@class QCloudPostVoiceSynthesisOperation;
@interface QCloudPostVoiceSynthesisResponse : NSObject 

/// 任务的详细信息
@property (nonatomic,strong)NSArray <QCloudPostVoiceSynthesisResponseJobsDetail * > * JobsDetail;

@end

@interface QCloudPostVoiceSynthesisResponseJobsDetail : NSObject 

/// 错误码，只有 State 为 Failed 时有意义
@property (nonatomic,strong) NSString * Code;

/// 错误描��，只有 State 为 Failed 时有意义
@property (nonatomic,strong) NSString * Message;

/// 新创建任务的 ID
@property (nonatomic,strong) NSString * JobId;

/// 新创建任务的 Tag：Tts
@property (nonatomic,strong) NSString * Tag;

/// 任务状态Submitted：已提交，待执行Running：执行中Success：执行成功Failed：执行失败Pause：任务暂停，当暂停队列时，待执行的任务会变为暂停状态Cancel：任务被取消执行
@property (nonatomic,strong) NSString * State;

/// 任务的创建时间
@property (nonatomic,strong) NSString * CreationTime;

/// 任务的开始时间
@property (nonatomic,strong) NSString * StartTime;

/// 任务的结束时间
@property (nonatomic,strong) NSString * EndTime;

/// 任务所属的 队列 ID﻿
@property (nonatomic,strong) NSString * QueueId;

/// 该任务的规则
@property (nonatomic,strong) QCloudPostVoiceSynthesisResponseOperation * Operation;

@end

@interface QCloudPostVoiceSynthesisResponseOperation : NSObject 

/// 任务的模板 ID
@property (nonatomic,strong) NSString * TemplateId;

/// 任务的模板名称, 当 TemplateId 存在时返回
@property (nonatomic,strong) NSString * TemplateName;

/// 请求中的 Request.Operation.TtsTpl
@property (nonatomic,strong) QCloudPostVoiceSynthesisTtsTpl * TtsTpl;

/// 请求中的 Request.Operation.TtsConfig
@property (nonatomic,strong) QCloudPostVoiceSynthesisTtsConfig * TtsConfig;

/// 请求中的 Request.Operation.Output
@property (nonatomic,strong) QCloudPostVoiceSynthesisOutput * Output;

/// 输出文件的媒体信息，任务未完成时不返回，详见 MediaInfo﻿
@property (nonatomic,strong) QCloudMediaInfo * MediaInfo;

/// 输出文件的基本信息，任务未完成时不返回，详见 MediaResult﻿
@property (nonatomic,strong) QCloudMediaResult * MediaResult;

/// 透传用户信息
@property (nonatomic,strong) NSString * UserData;

/// 任务优先级
@property (nonatomic,strong) NSString * JobLevel;

@end

@interface QCloudPostVoiceSynthesisOutput : NSObject 

/// 存储桶的地域;是否必传：是
@property (nonatomic,strong) NSString * Region;

/// 存储结果的存储桶;是否必传：是
@property (nonatomic,strong) NSString * Bucket;

/// 结果文件名;是否必传：是
@property (nonatomic,strong) NSString * Object;

@end

@interface QCloudPostVoiceSynthesisTtsConfig : NSObject 

/// 输入类型，Url/Text;是否必传：是
@property (nonatomic,strong) NSString * InputType;

/// 当 InputType 为 Url 时， 必须是合法的 COS 地址，文件必须是utf-8编码，且大小不超过 10M。如果合成方式为同步处理，则文件内容不超过 300 个 utf-8 字符；如果合成方式为异步处理，则文件内容不超过 10000 个 utf-8 字符。当 InputType 为 Text 时, 输入必须是 utf-8 字符, 且不超过 300 个字符。;是否必传：是
@property (nonatomic,strong) NSString * Input;

@end

@interface QCloudPostVoiceSynthesisTtsTpl : NSObject 

/// 同创建语音合成模板接口中的 Request.Mode﻿;是否必传：否
@property (nonatomic,strong) NSString * Mode;

/// 同创建语音合成模板接口中的 Request.Codec﻿;是否必传：否
@property (nonatomic,strong) NSString * Codec;

/// 同创建语音合成模板接口中的 Request.VoiceType﻿;是否必传：否
@property (nonatomic,strong) NSString * VoiceType;

/// 同创建语音合成模板接口中的 Request.Volume﻿;是否必传：否
@property (nonatomic,strong) NSString * Volume;

/// 同创建语音合成模板接口中的 Request.Speed﻿;是否必传：否
@property (nonatomic,strong) NSString * Speed;

/// 同创建语音合成模板接口中的 Request.Emotion﻿;是否必传：否
@property (nonatomic,strong) NSString * Emotion;

@end

@interface QCloudPostVoiceSynthesis : NSObject 

/// 创建任务的 Tag：Tts;是否必传：是
@property (nonatomic,strong) NSString * Tag;

/// 操作规则;是否必传：是
@property (nonatomic,strong) QCloudPostVoiceSynthesisOperation * Operation;

/// 任务回调格式，JSON 或 XML，默认 XML，优先级高于队列的回调格式;是否必传：否
@property (nonatomic,strong) NSString * CallBackFormat;

/// 任务回调类型，Url 或 TDMQ，默认 Url，优先级高于队列的回调类型;是否必传：否
@property (nonatomic,strong) NSString * CallBackType;

/// 任务回调地址，优先级高于队列的回调地址。设置为 no 时，表示队列的回调地址不产生回调;是否必传：否
@property (nonatomic,strong) NSString * CallBack;

/// 任务回调TDMQ配置，当 CallBackType 为 TDMQ 时必填。详情见 CallBackMqConfig;是否必传：否
@property (nonatomic,strong) QCloudCallBackMqConfig * CallBackMqConfig;

@end

@interface QCloudPostVoiceSynthesisOperation : NSObject 

/// 语音合成模板 ID;是否必传：否
@property (nonatomic,strong) NSString * TemplateId;

/// 语音合成参数;是否必传：否
@property (nonatomic,strong) QCloudPostVoiceSynthesisTtsTpl * TtsTpl;

/// 语音合成任务参数;是否必传：是
@property (nonatomic,strong) QCloudPostVoiceSynthesisTtsConfig * TtsConfig;

/// 结果输出配置;是否必传：是
@property (nonatomic,strong) QCloudPostVoiceSynthesisOutput * Output;

/// 透传用户信息，可打印的 ASCII 码，长度不超过1024;是否必传：否
@property (nonatomic,strong) NSString * UserData;

/// 任务优先级，级别限制：0 、1 、2 。级别越大任务优先级越高，默认为0;是否必传：否
@property (nonatomic,strong) NSString * JobLevel;

@end



NS_ASSUME_NONNULL_END
