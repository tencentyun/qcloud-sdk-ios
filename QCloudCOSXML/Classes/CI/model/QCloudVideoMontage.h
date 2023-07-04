//
//  QCloudVideoMontage.h 
//  QCloudCOSXML 
// 
//  Created by garenwang on 2023-06-14 02:27:23 +0000. 
// 
#import <Foundation/Foundation.h> 
#import "QCloudCICommonModel.h"
#import "QCloudWorkflowexecutionResult.h"
NS_ASSUME_NONNULL_BEGIN

@class QCloudVideoMontageJobsDetail;
@class QCloudVideoMontageJobsDetailInput;
@class QCloudVideoMontageJobsDetailOperation;
@class QCloudInputVideoMontage;
@class QCloudInputVideoMontageInput;
@class QCloudInputVideoMontageOperation;
@class QCloudInputVideoMontageOutput;
@class QCloudInputVideoMontageVideoMontage;

@interface QCloudVideoMontage : NSObject 

/// 任务的详细信息
@property (nonatomic,strong)QCloudVideoMontageJobsDetail * JobsDetail;

@end

@interface QCloudVideoMontageJobsDetail : NSObject 

/// 错误码，只有 State 为 Failed 时有意义
@property (nonatomic,strong)NSString * Code;

/// 错误描述，只有 State 为 Failed 时有意义
@property (nonatomic,strong)NSString * Message;

/// 新创建任务的 ID
@property (nonatomic,strong)NSString * JobId;

/// 新创建任务的 Tag：VideoMontage
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
@property (nonatomic,strong)QCloudVideoMontageJobsDetailInput * Input;

/// 该任务的规则
@property (nonatomic,strong)QCloudVideoMontageJobsDetailOperation * Operation;

@end

@interface QCloudVideoMontageJobsDetailInput : NSObject 

/// 存储桶的地域
@property (nonatomic,strong)NSString * Region;

/// 存储结果的存储桶
@property (nonatomic,strong)NSString * Bucket;

/// 输出结果的文件名
@property (nonatomic,strong)NSString * Object;

@end

@interface QCloudVideoMontageJobsDetailOperation : NSObject 

/// 同请求中的 Request.Operation.VideoMontage
@property (nonatomic,strong)QCloudInputVideoMontageVideoMontage * VideoMontage;

/// 任务的模板 ID
@property (nonatomic,strong)NSString * TemplateId;

/// 任务的模板名称, 当 TemplateId 存在时返回
@property (nonatomic,strong)NSString * TemplateName;

/// 同请求中的 Request.Operation.Output
@property (nonatomic,strong)QCloudInputVideoMontageOutput * Output;

/// 转码输出视频的信息，没有时不返回
@property (nonatomic,strong)QCloudWorkflowMediaInfo * MediaInfo;

/// 输出文件的基本信息，任务未完成时不返回
@property (nonatomic,strong)QCloudMediaResult * MediaResult;

/// 透传用户信息
@property (nonatomic,strong)NSString * UserData;

/// 任务优先级
@property (nonatomic,strong)NSString * JobLevel;

@end


@interface QCloudInputVideoMontage : NSObject 


/// 待操作的文件信息;是否必传：是;
@property (nonatomic,strong)QCloudInputVideoMontageInput * Input;

/// 操作规则;是否必传：是;
@property (nonatomic,strong)QCloudInputVideoMontageOperation * Operation;

/// 任务回调格式，JSON 或 XML，默认 XML，优先级高于队列的回调格式;是否必传：否;
@property (nonatomic,strong)NSString * CallBackFormat;

/// 任务回调类型，Url 或 TDMQ，默认 Url，优先级高于队列的回调类型;是否必传：否;
@property (nonatomic,strong)NSString * CallBackType;

/// 任务回调地址，优先级高于队列的回调地址。设置为 no 时，表示队列的回调地址不产生回调;是否必传：否;
@property (nonatomic,strong)NSString * CallBack;

/// 任务回调 TDMQ 配置，当 CallBackType 为 TDMQ 时必填。详情见 CallBackMqConfig;是否必传：否;
@property (nonatomic,strong)QCloudCallBackMqConfig * CallBackMqConfig;

@end

@interface QCloudInputVideoMontageInput : NSObject 

/// 文件路径;是否必传：是，当场景为Soccer时非必选;
@property (nonatomic,strong)NSString * Object;

/// 支持公网下载的Url，与Object必须有其中一个，且当两者都传入时，优先使用Object，仅支持Soccer场景;是否必传：否;
@property (nonatomic,strong)NSString * Url;

@end

@interface QCloudInputVideoMontageOperation : NSObject 

/// 精彩集锦模板参数;是否必传：否;
@property (nonatomic,strong)QCloudInputVideoMontageVideoMontage * VideoMontage;

/// 模板 ID;是否必传：否;
@property (nonatomic,strong)NSString * TemplateId;

/// 结果输出配置;是否必传：是;
@property (nonatomic,strong)QCloudInputVideoMontageOutput * Output;

/// 透传用户信息, 可打印的 ASCII 码, 长度不超过1024;是否必传：否;
@property (nonatomic,strong)NSString * UserData;

/// 任务优先级，级别限制：0 、1 、2 。级别越大任务优先级越高，默认为0;是否必传：否;
@property (nonatomic,strong)NSString * JobLevel;

@end

@interface QCloudInputVideoMontageOutput : NSObject

/// 存储桶的地域;是否必传：是;
@property (nonatomic,strong)NSString * Region;

/// 存储结果的存储桶;是否必传：是;
@property (nonatomic,strong)NSString * Bucket;

/// 输出结果的文件名;是否必传：是;
@property (nonatomic,strong)NSString * Object;

@end

@interface QCloudInputVideoMontageVideoMontage : NSObject

/// 同创建转码模板接口中的 Request.TimeInterval;是否必传：否;
@property (nonatomic,strong)QCloudTemplateTimeInterval * TimeInterval;

/// 同创建转码模板接口中的 Request.Container;是否必传：否;
@property (nonatomic,strong)QCloudTemplateContainer * Container;

/// 同创建转码模板接口中的 Request.Video ;是否必传：否;
@property (nonatomic,strong)QCloudTemplateVideo * Video;

/// 同创建转码模板接口中的 Request.Audio;是否必传：否;
@property (nonatomic,strong)QCloudAudioVoiceSeparateAudioConfig * Audio;

/// 同创建转码模板接口中的 Request.TransConfig;是否必传：否;
@property (nonatomic,strong)QCloudContainerTransConfig * TransConfig;

/// 混音参数, 详情见 AudioMix;是否必传：否;
@property (nonatomic,strong)QCloudJobsDetailMix * AudioMix;

/// 混音参数数组, 最多同时传2个。详情见 AudioMixArray;是否必传：否;
@property (nonatomic,strong)NSArray <QCloudJobsDetailMix * > * AudioMixArray;

/// 1.取值范围：Soccer/Video，默认值为Video
@property (nonatomic,strong)NSString * Scene;

@end

NS_ASSUME_NONNULL_END
