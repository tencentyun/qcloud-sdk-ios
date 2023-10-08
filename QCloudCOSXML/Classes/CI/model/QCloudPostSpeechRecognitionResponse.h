//
//  QCloudPostSpeechRecognitionResponse.h
//  QCloudPostSpeechRecognitionResponse
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

@class QCloudPostSpeechRecognitionResponseJobsDetail;
@class QCloudPostSpeechRecognitionInput;
@class QCloudPostSpeechRecognitionResponseOperation;
@class QCloudPostSpeechRecognitionOutput;
@class QCloudPostSpeechRecognitionResponseSpeechRecognitionResult;
@class QCloudPostSpeechRecognitionResponseFlashResult;
@class QCloudPostSpeechRecognitionResponsesentence_list;
@class QCloudPostSpeechRecognitionResponseword_list;
@class QCloudPostSpeechRecognitionResponseResultDetail;
@class QCloudPostSpeechRecognitionResponseWords;
@class QCloudPostSpeechRecognitionOperation;
@interface QCloudPostSpeechRecognitionResponse : NSObject 

/// 任务的详细信息
@property (nonatomic,strong)NSArray <QCloudPostSpeechRecognitionResponseJobsDetail * > * JobsDetail;

@end

@interface QCloudPostSpeechRecognitionResponseJobsDetail : NSObject 

/// 错误码，只有 State 为 Failed 时有意义
@property (nonatomic,strong) NSString * Code;

/// 错误描述，只有 State 为 Failed 时有意义
@property (nonatomic,strong) NSString * Message;

/// 新创建任务的 ID
@property (nonatomic,strong) NSString * JobId;

/// 新创建任务的 Tag：SpeechRecognition
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

/// 同请求中的 Request.Input 节点
@property (nonatomic,strong) QCloudPostSpeechRecognitionInput * Input;

/// 该任务的规则
@property (nonatomic,strong) QCloudPostSpeechRecognitionResponseOperation * Operation;

@end

@interface QCloudPostSpeechRecognitionInput : NSObject 

/// 文件路径;是否必传：否
@property (nonatomic,strong) NSString * Object;

@end

@interface QCloudPostSpeechRecognitionResponseOperation : NSObject 

/// 任务的模板 ID
@property (nonatomic,strong) NSString * TemplateId;

/// 任务的模板名称, 当 TemplateId 存在时返回
@property (nonatomic,strong) NSString * TemplateName;

/// 同请求中的 Request.Operation.SpeechRecognition
@property (nonatomic,strong) QCloudSpeechRecognition * SpeechRecognition;

/// 同请求中的 Request.Operation.Output
@property (nonatomic,strong) QCloudPostSpeechRecognitionOutput * Output;

/// 透传用户信息
@property (nonatomic,strong) NSString * UserData;

/// 任务优先级
@property (nonatomic,strong) NSString * JobLevel;

/// 语音识别任务结果，没有时不返回
@property (nonatomic,strong) QCloudPostSpeechRecognitionResponseSpeechRecognitionResult * SpeechRecognitionResult;

@end

@interface QCloudPostSpeechRecognitionOutput : NSObject 

/// 存储桶的地域;是否必传：是
@property (nonatomic,strong) NSString * Region;

/// 存储结果的存储桶;是否必传：是
@property (nonatomic,strong) NSString * Bucket;

/// 结果文件的名称;是否必传：是
@property (nonatomic,strong) NSString * Object;

@end

@interface QCloudPostSpeechRecognitionResponseSpeechRecognitionResult : NSObject 

/// 音频时长(秒)
@property (nonatomic,strong) NSString * AudioTime;

/// 语音识别结果
@property (nonatomic,strong) NSString * Result;

/// 极速语音识别结果
@property (nonatomic,strong)NSArray <QCloudPostSpeechRecognitionResponseFlashResult * > * FlashResult;

/// 识别结果详情，包含每个句子中的词时间偏移，一般用于生成字幕的场景。(语音识别请求中ResTextFormat=1时该字段不为空)注意：此字段可能为空，表示取不到有效值。
@property (nonatomic,strong)NSArray <QCloudPostSpeechRecognitionResponseResultDetail * > * ResultDetail;

@end

@interface QCloudPostSpeechRecognitionResponseFlashResult : NSObject 

/// 声道标识，从0开始，对应音频声道数
@property (nonatomic,assign) NSInteger channel_id;

/// 声道音频完整识别结果
@property (nonatomic,strong) NSString * text;

/// 句子/段落级别的识别结果列表
@property (nonatomic,strong)NSArray <QCloudPostSpeechRecognitionResponsesentence_list * > * sentence_list;

@end

@interface QCloudPostSpeechRecognitionResponsesentence_list : NSObject 

/// 句子/段落级别文本
@property (nonatomic,strong) NSString * text;

/// 开始时间
@property (nonatomic,assign) NSInteger start_time;

/// 结束时间
@property (nonatomic,assign) NSInteger end_time;

/// 说话人 Id（请求中如果设置了 speaker_diarization，可以按照 speaker_id 来区分说话人）
@property (nonatomic,assign) NSInteger speaker_id;

/// 词级别的识别结果列表
@property (nonatomic,strong)NSArray <QCloudPostSpeechRecognitionResponseword_list * > * word_list;

@end

@interface QCloudPostSpeechRecognitionResponseword_list : NSObject 

/// 词级别文本
@property (nonatomic,strong) NSString * word;

/// 开始时间
@property (nonatomic,assign) NSInteger start_time;

/// 结束时间
@property (nonatomic,assign) NSInteger end_time;

@end

@interface QCloudPostSpeechRecognitionResponseResultDetail : NSObject 

/// 单句最终识别结果
@property (nonatomic,strong) NSString * FinalSentence;

/// 单句中间识别结果，使用空格拆分为多个词
@property (nonatomic,strong) NSString * SliceSentence;

/// 单句开始时间（毫秒）
@property (nonatomic,strong) NSString * StartMs;

/// 单句结束时间（毫秒）
@property (nonatomic,strong) NSString * EndMs;

/// 单句中词个数
@property (nonatomic,strong) NSString * WordsNum;

/// 单句语速，单位：字数/秒
@property (nonatomic,strong) NSString * SpeechSpeed;

/// 声道或说话人 Id（请求中如果设置了 speaker_diarization或者ChannelNum为双声道，可区分说话人或声道）
@property (nonatomic,strong) NSString * SpeakerId;

/// 单句中词详情
@property (nonatomic,strong)NSArray <QCloudPostSpeechRecognitionResponseWords * > * Words;

@end

@interface QCloudPostSpeechRecognitionResponseWords : NSObject 

/// 词文本
@property (nonatomic,strong) NSString * Word;

/// 在句子中的开始时间偏移量
@property (nonatomic,strong) NSString * OffsetStartMs;

/// 在句子中的结束时间偏移量
@property (nonatomic,strong) NSString * OffsetEndMs;

@end

@interface QCloudPostSpeechRecognition : NSObject 

/// 创建任务的 Tag：SpeechRecognition;是否必传：是
@property (nonatomic,strong) NSString * Tag;

/// 待操作的对象信息;是否必传：是
@property (nonatomic,strong) QCloudPostSpeechRecognitionInput * Input;

/// 操作规则;是否必传：是
@property (nonatomic,strong) QCloudPostSpeechRecognitionOperation * Operation;

/// 任务回调格式，JSON 或 XML，默认 XML，优先级高于队列的回调格式;是否必传：否
@property (nonatomic,strong) NSString * CallBackFormat;

/// 任务回调类型，Url 或 TDMQ，默认 Url，优先级高于队列的回调类型;是否必传：否
@property (nonatomic,strong) NSString * CallBackType;

/// 任务回调地址，优先级高于队列的回调地址。设置为 no 时，表示队列的回调地址不产生回调;是否必传：否
@property (nonatomic,strong) NSString * CallBack;

/// 任务回调TDMQ配置，当 CallBackType 为 TDMQ 时必填。详情见 CallBackMqConfig;是否必传：否
@property (nonatomic,strong) QCloudCallBackMqConfig * CallBackMqConfig;

@end

@interface QCloudPostSpeechRecognitionOperation : NSObject 

/// 语音识别模板 ID;是否必传：否
@property (nonatomic,strong) NSString * TemplateId;

/// 语音识别参数，同创建语音识别模板接口中的 Request.SpeechRecognition﻿;是否必传：否
@property (nonatomic,strong) QCloudSpeechRecognition * SpeechRecognition;

/// 结果输出配置;是否必传：是
@property (nonatomic,strong) QCloudPostSpeechRecognitionOutput * Output;

/// 透传用户信息, 可打印的 ASCII 码, 长度不超过1024;是否必传：否
@property (nonatomic,strong) NSString * UserData;

/// 任务优先级，级别限制：0 、1 、2 。级别越大任务优先级越高，默认为0;是否必传：否
@property (nonatomic,strong) NSString * JobLevel;

@end



NS_ASSUME_NONNULL_END
