//
//  QCloudVoiceSeparateResult.h
//  QCloudCOSXML 
// 
//  Created by garenwang on 2023-06-13 12:44:09 +0000. 
// 
#import <Foundation/Foundation.h>
#import "QCloudCICommonModel.h"
#import "QCloudWorkflowexecutionResult.h"
NS_ASSUME_NONNULL_BEGIN

@class QCloudVoiceSeparateJobsDetail;
@class QCloudVoiceSeparateInput;
@class QCloudVoiceSeparateOperation;

@class QCloudInputVoiceSeparate;
@class QCloudInputVoiceSeparateInput;
@class QCloudInputVoiceSeparateOperation;
@class QCloudInputVoiceSeparateOutput;
@class QCloudVoiceSeparate;
@class QCloudAudioVoiceSeparateAudioConfig;
@interface QCloudVoiceSeparateResult : NSObject

/// 任务的详细信息
@property (nonatomic,strong)QCloudVoiceSeparateJobsDetail * JobsDetail;

@end

@interface QCloudVoiceSeparateJobsDetail : NSObject

/// 错误码，只有 State 为 Failed 时有意义
@property (nonatomic,strong)NSString * Code;

/// 错误描述，只有 State 为 Failed 时有意义
@property (nonatomic,strong)NSString * Message;

/// 新创建任务的 ID
@property (nonatomic,strong)NSString * JobId;

/// 新创建任务的 Tag：VoiceSeparate
@property (nonatomic,strong)NSString * Tag;

/// 任务的状态，为 Submitted、Running、Success、Failed、Pause、Cancel 其中一个
@property (nonatomic,strong)NSString * State;

/// 任务的创建时间
@property (nonatomic,strong)NSString * CreationTime;

/// 任务的开始时间
@property (nonatomic,strong)NSString * StartTime;

/// 任务的结束时间
@property (nonatomic,strong)NSString * EndTime;

/// 任务所属的队列 ID
@property (nonatomic,strong)NSString * QueueId;

/// 该任务的输入资源地址
@property (nonatomic,strong)QCloudVoiceSeparateInput * Input;

/// 该任务的规则
@property (nonatomic,strong)QCloudVoiceSeparateOperation * Operation;

@end

@interface QCloudVoiceSeparateInput : NSObject

/// 存储桶的地域
@property (nonatomic,strong)NSString * Region;

/// 存储结果的存储桶
@property (nonatomic,strong)NSString * Bucket;

/// 输出结果的文件名
@property (nonatomic,strong)NSString * Object;

@end

@interface QCloudVoiceSeparateOperation : NSObject

/// 任务的模板 ID
@property (nonatomic,strong)NSString * TemplateId;

/// 任务的模板名称, 当 TemplateId 存在时返回
@property (nonatomic,strong)NSString * TemplateName;

/// 同请求中的 Request.Operation.VoiceSeparate
@property (nonatomic,strong)QCloudVoiceSeparate * VoiceSeparate;

/// 同请求中的 Request.Operation.Output
@property (nonatomic,strong)QCloudInputVoiceSeparateOutput * Output;

/// 输出文件的媒体信息，任务未完成时不返回
@property (nonatomic,strong)QCloudWorkflowMediaInfo * MediaInfo;

/// 输出文件的基本信息，任务未完成时不返回
@property (nonatomic,strong)QCloudMediaResult * MediaResult;

/// 透传用户信息
@property (nonatomic,strong)NSString * UserData;

/// 任务优先级
@property (nonatomic,strong)NSString * JobLevel;

@end

@interface QCloudInputVoiceSeparate : NSObject

/// 待操作的文件信息;是否必传：是;
@property (nonatomic,strong)QCloudInputVoiceSeparateInput * Input;

/// 操作规则;是否必传：是;
@property (nonatomic,strong)QCloudInputVoiceSeparateOperation * Operation;

/// 任务回调格式，JSON 或 XML，默认 XML，优先级高于队列的回调格式;是否必传：否;
@property (nonatomic,strong)NSString * CallBackFormat;

/// 任务回调类型，Url 或 TDMQ，默认 Url，优先级高于队列的回调类型;是否必传：否;
@property (nonatomic,strong)NSString * CallBackType;

/// 任务回调地址，优先级高于队列的回调地址。设置为 no 时，表示队列的回调地址不产生回调;是否必传：否;
@property (nonatomic,strong)NSString * CallBack;

/// 任务回调TDMQ配置，当 CallBackType 为 TDMQ 时必填。详情见 CallBackMqConfig;是否必传：否;
@property (nonatomic,strong)QCloudCallBackMqConfig * CallBackMqConfig;

@end

@interface QCloudInputVoiceSeparateInput : NSObject

/// 文件路径;是否必传：是;
@property (nonatomic,strong)NSString * Object;

@end

@interface QCloudInputVoiceSeparateOperation : NSObject

/// 转码模板参数;是否必传：否;
@property (nonatomic,strong)QCloudVoiceSeparate * VoiceSeparate;

/// 模板 ID;是否必传：否;
@property (nonatomic,strong)NSString * TemplateId;

/// 结果输出配置;是否必传：是;
@property (nonatomic,strong)QCloudInputVoiceSeparateOutput * Output;

/// 任务优先级，级别限制：0 、1 、2 。级别越大任务优先级越高，默认为0;是否必传：否;
@property (nonatomic,strong)NSString * JobLevel;

@end

@interface QCloudInputVoiceSeparateOutput : NSObject

/// 存储结果的存储桶;是否必传：是;
@property (nonatomic,strong)NSString * Bucket;

/// 存储桶的地域
@property (nonatomic,strong)NSString * Region;

/// 背景音结果文件名，不能与 AuObject 同时为空;是否必传：否;
@property (nonatomic,strong)NSString * Object;

/// 人声结果文件名，不能与 Object 同时为空
@property (nonatomic,strong)NSString * AuObject;

@end

@interface QCloudVoiceSeparate : NSObject

/// 输出音频:
/// IsAudio：输出人声
/// IsBackground：输出背景声
/// AudioAndBackground：输出人声和背景声
@property (nonatomic,strong)NSString * AudioMode;

/// 音频配置
@property (nonatomic,strong)QCloudAudioVoiceSeparateAudioConfig * AudioConfig;
@end


NS_ASSUME_NONNULL_END
