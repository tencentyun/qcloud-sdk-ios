//
//  QCloudPostAudioDiscernTaskInfo.h
//  QCloudCOSXML
//
//  Created by garenwang on 2022/7/22.
//

#import <Foundation/Foundation.h>
#import "QCloudRecognitionEnum.h"
@class QCloudPostAudioDiscernTaskInfoInput;
@class QCloudPostAudioDiscernTaskInfoOperation;

@class QCloudPostAudioDiscernTaskInfoSpeechRecognition;
@class QCloudPostAudioDiscernTaskInfoOutput;

@class QCloudPostAudioDiscernTaskJobsDetail;
@class QCloudPostAudioDiscernTaskJobsOperation;

@class QCloudPostAudioDiscernTaskResultInput;
@class QCloudPostAudioDiscernTaskInfoSpeechRecognitionResult;

@class QCloudPostAudioDiscernTaskInfoSpeechWords;
@class QCloudPostAudioDiscernTaskInfoSpeechResultDetail;
NS_ASSUME_NONNULL_BEGIN

@interface QCloudPostAudioDiscernTaskInfo : NSObject


/// 创建任务的 Tag，目前仅支持：SpeechRecognition
@property (nonatomic,strong)NSString *Tag;

/// 待操作的语音文件
@property (nonatomic,strong)QCloudPostAudioDiscernTaskInfoInput *Input;

/// 操作规则
@property (nonatomic,strong)QCloudPostAudioDiscernTaskInfoOperation *Operation;

/// 任务所在的队列 ID
@property (nonatomic,strong)NSString *QueueId;

@end

@interface QCloudPostAudioDiscernTaskInfoInput : NSObject

/// 语音文件在 COS 上的 key，Bucket 由 Host 指定
@property (nonatomic,strong)NSString *Object;

@end

@interface QCloudPostAudioDiscernTaskInfoOperation : NSObject

/// 当 Tag 为 SpeechRecognition 时有效，指定该任务的参数
@property (nonatomic,strong)QCloudPostAudioDiscernTaskInfoSpeechRecognition *SpeechRecognition;

/// 结果输出地址
@property (nonatomic,strong)QCloudPostAudioDiscernTaskInfoOutput *Output;

@end

@interface QCloudPostAudioDiscernTaskInfoSpeechRecognition : NSObject
/**
 引擎模型类型。
 电话场景：
 • 8k_zh：电话 8k 中文普通话通用（可用于双声道音频）；
 • 8k_zh_s：电话 8k 中文普通话话者分离（仅适用于单声道音频）；
 非电话场景：
 • 16k_zh：16k 中文普通话通用；
 • 16k_zh_video：16k 音视频领域；
 • 16k_en：16k 英语；
 • 16k_ca：16k 粤语。
 */
@property (nonatomic,strong)NSString * EngineModelType;

/// 语音声道数。1：单声道；2：双声道（仅支持 8k_zh 引擎模型）。
@property (nonatomic,assign)NSInteger  ChannelNum;

/// 识别结果返回形式。0： 识别结果文本(含分段时间戳)； 1：仅支持16k中文引擎，含识别结果详情(词时间戳列表，一般用于生成字幕场景)。
@property (nonatomic,assign)NSInteger  ResTextFormat;

/// 是否过滤脏词（目前支持中文普通话引擎）。0：不过滤脏词；1：过滤脏词；2：将脏词替换为 * 。默认值为0。
@property (nonatomic,assign)NSInteger  FilterDirty;

/// 是否过语气词（目前支持中文普通话引擎）。0：不过滤语气词；1：部分过滤；2：严格过滤 。默认值为 0。
@property (nonatomic,assign)NSInteger  FilterModal;

/// 是否进行阿拉伯数字智能转换（目前支持中文普通话引擎）。0：不转换，直接输出中文数字，1：根据场景智能转换为阿拉伯数字。默认值为1。
@property (nonatomic,assign)NSInteger  ConvertNumMode;

@end

@interface QCloudPostAudioDiscernTaskInfoOutput : NSObject

/// 存储桶的地域
@property (nonatomic,strong)NSString *Region;

/// 存储结果的存储桶
@property (nonatomic,strong)NSString *Bucket;

/// 结果文件的名称
@property (nonatomic,strong)NSString *Object;
@end


@interface QCloudPostAudioDiscernTaskResult : NSObject
@property (nonatomic,strong)QCloudPostAudioDiscernTaskJobsDetail *JobsDetail;
@end

@interface QCloudPostAudioDiscernTaskJobsDetail : NSObject

/// 错误码，只有 State 为 Failed 时有意义
@property (nonatomic,strong)NSString *Code;

/// 错误描述，只有 State 为 Failed 时有意义
@property (nonatomic,strong)NSString *Message;

/// 新创建任务的 ID
@property (nonatomic,strong)NSString *JobId;

/// 新创建任务的 Tag：SpeechRecognition
@property (nonatomic,strong)NSString *Tag;

/// 任务的状态，为 Submitted、Running、Success、Failed、Pause、Cancel 其中一个
@property (nonatomic,assign)QCloudTaskStatesEnum State;

/// 任务的创建时间
@property (nonatomic,strong)NSString *CreationTime;


@property (nonatomic,strong)NSString *EndTime;


@property (nonatomic,strong)NSString *StartTime;

/// 任务所属的队列 ID
@property (nonatomic,strong)NSString *QueueId;

/// 该任务的输入资源地址
@property (nonatomic,strong)QCloudPostAudioDiscernTaskResultInput *Input;

/// 该任务的规则
@property (nonatomic,strong)QCloudPostAudioDiscernTaskJobsOperation *Operation;

@end

@interface QCloudPostAudioDiscernTaskResultInput : NSObject

/// 存储桶的地域
@property (nonatomic,strong)NSString *Region;

/// 存储结果的存储桶
@property (nonatomic,strong)NSString *BucketId;

/// 结果文件的名称
@property (nonatomic,strong)NSString *Object;
@end

@interface QCloudPostAudioDiscernTaskJobsOperation : NSObject

/// 任务的模板 ID
@property (nonatomic,strong)NSString *TemplateId;

/// 文件的输出地址
@property (nonatomic,strong)QCloudPostAudioDiscernTaskInfoOutput *Output;

@property (nonatomic,strong)QCloudPostAudioDiscernTaskInfoSpeechRecognition *SpeechRecognition;

@property (nonatomic,strong)QCloudPostAudioDiscernTaskInfoSpeechRecognitionResult *SpeechRecognitionResult;
@end

@interface QCloudPostAudioDiscernTaskInfoSpeechRecognitionResult : NSObject

/// 语音时长
@property (nonatomic,strong)NSString *AudioTime;

/// 识别结果
@property (nonatomic,strong)NSString *Result;

/// 结果详情
@property (nonatomic,strong)NSArray <QCloudPostAudioDiscernTaskInfoSpeechResultDetail *> *ResultDetail;
@end

@interface QCloudPostAudioDiscernTaskInfoSpeechResultDetail : NSObject

/// 单句结束时间（毫秒）
@property (nonatomic,strong)NSString * EndMs;

/// 单句最终识别结果
@property (nonatomic,strong)NSString * FinalSentence;

/// 单句中间识别结果，使用空格拆分为多个词
@property (nonatomic,strong)NSString * SliceSentence;

/// 声道或说话人 Id（请求中如果设置了 speaker_diarization或者ChannelNum为双声道，可区分说话人或声道）
@property (nonatomic,strong)NSString * SpeakerId;

/// 单句语速，单位：字数/秒
@property (nonatomic,strong)NSString * SpeechSpeed;

/// 单句开始时间（毫秒）
@property (nonatomic,strong)NSString * StartMs;

/// 单句中词详情
@property (nonatomic,strong)NSArray <QCloudPostAudioDiscernTaskInfoSpeechWords *> * Words;

/// 单句中词个数
@property (nonatomic,strong)NSString * WordsNum;
@end

@interface QCloudPostAudioDiscernTaskInfoSpeechWords : NSObject


/// 在句子中的结束时间偏移量
@property (nonatomic,strong)NSString * OffsetEndMs;

/// 在句子中的开始时间偏移量
@property (nonatomic,strong)NSString * OffsetStartMs;
@property (nonatomic,strong)NSString * VoiceType;

/// 词文本
@property (nonatomic,strong)NSString * Word;

@end


NS_ASSUME_NONNULL_END
