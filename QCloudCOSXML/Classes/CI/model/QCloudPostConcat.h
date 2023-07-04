//
//  QCloudPostConcat.h 
//  QCloudCOSXML 
// 
//  Created by garenwang on 2023-06-14 03:02:09 +0000. 
// 
#import <Foundation/Foundation.h> 
#import "QCloudCICommonModel.h"
NS_ASSUME_NONNULL_BEGIN

@class QCloudPostConcatJobsDetail;
@class QCloudPostConcatJobsDetailInput;
@class QCloudPostConcatJobsDetailOperation;

@class QCloudInputPostConcat;
@class QCloudInputPostConcatInput;
@class QCloudInputPostConcatOperation;
@class QCloudInputPostConcatOutput;
@class QCloudInputPostConcatTemplate;
@class QCloudInputPostConcatFragment;

@interface QCloudPostConcat : NSObject 

/// 任务的详细信息
@property (nonatomic,strong)QCloudPostConcatJobsDetail * JobsDetail;

@end

@interface QCloudPostConcatJobsDetail : NSObject 

/// 错误码，只有 State 为 Failed 时有意义
@property (nonatomic,strong)NSString * Code;

/// 错误描述，只有 State 为 Failed 时有意义
@property (nonatomic,strong)NSString * Message;

/// 新创建任务的 ID
@property (nonatomic,strong)NSString * JobId;

/// 新创建任务的 Tag：SmartCover
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
@property (nonatomic,strong)QCloudPostConcatJobsDetailInput * Input;

/// 该任务的规则
@property (nonatomic,strong)QCloudPostConcatJobsDetailOperation * Operation;

@end

@interface QCloudPostConcatJobsDetailInput : NSObject 

/// 存储桶的地域
@property (nonatomic,strong)NSString * Region;

/// 存储结果的存储桶
@property (nonatomic,strong)NSString * Bucket;

/// 输出结果的文件名
@property (nonatomic,strong)NSString * Object;

@end

@interface QCloudPostConcatJobsDetailOperation : NSObject 

/// 任务的模板 ID
@property (nonatomic,strong)NSString * TemplateId;

/// 任务的模板名称, 当 TemplateId 存在时返回
@property (nonatomic,strong)NSString * TemplateName;

/// 同请求中的 Request.Operation.ConcatTemplate
@property (nonatomic,strong)QCloudInputPostConcatTemplate * ConcatTemplate;

/// 同请求中的 Request.Operation.Output
@property (nonatomic,strong)QCloudInputPostConcatOutput * Output;

/// 转码输出视频的信息，没有时不返回
@property (nonatomic,strong)QCloudWorkflowMediaInfo * MediaInfo;

/// 输出文件的基本信息，任务未完成时不返回
@property (nonatomic,strong)QCloudMediaResult * MediaResult;

/// 透传用户信息
@property (nonatomic,strong)NSString * UserData;

/// 任务优先级
@property (nonatomic,strong)NSString * JobLevel;

@end


@interface QCloudInputPostConcat : NSObject 

/// 待操作的文件信息;是否必传：是;
@property (nonatomic,strong)QCloudInputPostConcatInput * Input;

/// 操作规则;是否必传：是;
@property (nonatomic,strong)QCloudInputPostConcatOperation * Operation;

/// 任务回调格式，JSON 或 XML，默认 XML，优先级高于队列的回调格式;是否必传：否;
@property (nonatomic,strong)NSString * CallBackFormat;

/// 任务回调类型，Url 或 TDMQ，默认 Url，优先级高于队列的回调类型;是否必传：否;
@property (nonatomic,strong)NSString * CallBackType;

/// 任务回调地址，优先级高于队列的回调地址。设置为 no 时，表示队列的回调地址不产生回调;是否必传：否;
@property (nonatomic,strong)NSString * CallBack;

/// 任务回调 TDMQ 配置，当 CallBackType 为 TDMQ 时必填。详情见 CallBackMqConfig;是否必传：否;
@property (nonatomic,strong)QCloudCallBackMqConfig * CallBackMqConfig;

@end

@interface QCloudInputPostConcatInput : NSObject 

/// 文件路径;是否必传：是，当场景为Soccer时非必选;
@property (nonatomic,strong)NSString * Object;

@end

@interface QCloudInputPostConcatOperation : NSObject 

/// 拼接参数;是否必传：否;
@property (nonatomic,strong)QCloudInputPostConcatTemplate * ConcatTemplate;

/// 模板 ID;是否必传：否;
@property (nonatomic,strong)NSString * TemplateId;

/// 结果输出配置;是否必传：是;
@property (nonatomic,strong)QCloudInputPostConcatOutput * Output;

/// 任务优先级，级别限制：0 、1 、2 。级别越大任务优先级越高，默认为0;是否必传：否;
@property (nonatomic,strong)NSString * JobLevel;

@end

@interface QCloudInputPostConcatOutput : NSObject

/// 存储桶的地域;是否必传：是;
@property (nonatomic,strong)NSString * Region;

/// 存储结果的存储桶;是否必传：是;
@property (nonatomic,strong)NSString * Bucket;

/// 输出结果的文件名;是否必传：是;
@property (nonatomic,strong)NSString * Object;

@end

@interface QCloudInputPostConcatTemplate : NSObject

/// 拼接节点;是否必传：否;;默认值：无;;限制：支持多个文件，按照文件顺序拼接;
@property (nonatomic,strong)NSArray <QCloudInputPostConcatFragment * > * ConcatFragment;

/// 音频参数，同创建拼接模板接口中的 Request.ConcatTemplate.Audio;是否必传：否;;默认值：无;;限制：无;
@property (nonatomic,strong)QCloudAudioVoiceSeparateAudioConfig * Audio;

/// 视频参数，同创建拼接模板接口中的 Request.ConcatTemplate.Video;是否必传：否;;默认值：无;;限制：无;
@property (nonatomic,strong)QCloudTemplateVideo * Video;

/// 封装格式，同创建拼接模板接口中的 Request.ConcatTemplate.Container;是否必传：是;;默认值：无;;限制：无;
@property (nonatomic,strong)QCloudTemplateContainer * Container;

/// 混音参数, 详情见 AudioMix;是否必传：否;;默认值：无;;限制：仅在 Audio.Remove 为 false 时生效;
@property (nonatomic,strong)QCloudJobsDetailMix * AudioMix;

/// 混音参数数组, 最多同时传2个。详情见 AudioMixArray;是否必传：否;;默认值：-;;限制：-;
@property (nonatomic,strong)NSArray <QCloudJobsDetailMix * > * AudioMixArray;

/// Input 节点位于 ConcatFragment 序列索引;是否必传：否;;默认值：0;;限制：不能大于 ConcatFragment 长度;
@property (nonatomic,strong)NSString * Index;

/// 简单拼接方式（不转码直接拼接），其他的视频和音频参数失效;是否必传：否;;默认值：FALSE;;限制：true、false;
@property (nonatomic,strong)NSString * DirectConcat;

@end

@interface QCloudInputPostConcatFragment : NSObject

/// 拼接对象地址;是否必传：是;;默认值：无;;限制：同 bucket 对象文件;
@property (nonatomic,strong)NSString * Url;

/// 拼接对象的索引位置;是否必传：否;;默认值：0;;限制：大于等于0的整数;
@property (nonatomic,strong)NSString * FragmentIndex;

/// 开始时间;是否必传：否;;默认值：视频开始;;限制：[0 视频时长] 单位为秒 当 Request.Operation. ConcatTemplate. DirectConcat 为 true 时不生效;
@property (nonatomic,strong)NSString * StartTime;

/// 结束时间;是否必传：否;;默认值：视频结束;;限制：[0 视频时长] 单位为秒 当 Request.Operation. ConcatTemplate. DirectConcat 为 true 时不生效;
@property (nonatomic,strong)NSString * EndTime;

@end

NS_ASSUME_NONNULL_END
