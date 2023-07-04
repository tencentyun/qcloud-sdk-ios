//
//  QCloudPostTranscode.h 
//  QCloudCOSXML 
// 
//  Created by garenwang on 2023-06-14 03:57:33 +0000. 
// 
#import <Foundation/Foundation.h> 
#import "QCloudCICommonModel.h"
NS_ASSUME_NONNULL_BEGIN

@class QCloudPostTranscodeJobsDetail;
@class QCloudPostTranscodeInput;
@class QCloudPostTranscodeOperation;


@class QCloudInputPostTranscode;
@class QCloudInputPostTranscodeInput;
@class QCloudInputPostTranscodeOperation;
@class QCloudInputPostTranscodeOutput;
@class QCloudInputPostTranscodeSubtitles;
@class QCloudInputPostTranscodeTranscode;
@class QCloudInputPostTranscodeWatermark;
@class QCloudInputPostTranscodeRWatermark;
@class QCloudInputPostTranscodeSubtitle;


@interface QCloudPostTranscode : NSObject 

/// 任务的详细信息
@property (nonatomic,strong)QCloudPostTranscodeJobsDetail * JobsDetail;

@end

@interface QCloudPostTranscodeJobsDetail : NSObject 

/// 错误码，只有 State 为 Failed 时有意义
@property (nonatomic,strong)NSString * Code;

/// 错误描述，只有 State 为 Failed 时有意义
@property (nonatomic,strong)NSString * Message;

/// 新创建任务的 ID
@property (nonatomic,strong)NSString * JobId;

/// 新创建任务的 Tag：Transcode
@property (nonatomic,strong)NSString * Tag;

/// 任务的状态，为 Submitted、Running、Success、Failed、Pause、Cancel 其中一个
@property (nonatomic,strong)NSString * State;

/// 任务进度百分比，只有在State为 Submitted、Running、Success、Pause 时有意义，范围为[0, 100]
@property (nonatomic,strong)NSString * Progress;

/// 任务的创建时间
@property (nonatomic,strong)NSString * CreationTime;

/// 任务的开始时间
@property (nonatomic,strong)NSString * StartTime;

/// 任务的结束时间
@property (nonatomic,strong)NSString * EndTime;

/// 任务所属的队列 ID
@property (nonatomic,strong)NSString * QueueId;

/// 该任务的输入资源地址
@property (nonatomic,strong)QCloudPostTranscodeInput * Input;

/// 该任务的规则
@property (nonatomic,strong)QCloudPostTranscodeOperation * Operation;

@end

@interface QCloudPostTranscodeInput : NSObject

/// 存储桶的地域
@property (nonatomic,strong)NSString * Region;

/// 存储结果的存储桶
@property (nonatomic,strong)NSString * Bucket;

/// 输出结果的文件名
@property (nonatomic,strong)NSString * Object;

@end

@interface QCloudPostTranscodeOperation : NSObject

/// 任务的模板 ID
@property (nonatomic,strong)NSString * TemplateId;

/// 任务的模板名称, 当 TemplateId 存在时返回
@property (nonatomic,strong)NSString * TemplateName;

/// 同请求中的 Request.Operation.Transcode
@property (nonatomic,strong)QCloudInputPostTranscodeTranscode * Transcode;

/// 同请求中的 Request.Operation.Watermark
@property (nonatomic,strong)NSArray <QCloudInputPostTranscodeWatermark * > * Watermark;

/// 同请求中的 Request.Operation.RemoveWatermark
@property (nonatomic,strong)QCloudInputPostTranscodeRWatermark * RemoveWatermark;

/// 水印模板 ID
@property (nonatomic,strong)NSArray <NSString * > * WatermarkTemplateId;

/// 同请求中的 Request.Operation.Output
@property (nonatomic,strong)QCloudInputPostTranscodeOutput * Output;

/// 转码输出视频的信息，没有时不返回
@property (nonatomic,strong)QCloudWorkflowMediaInfo * MediaInfo;

/// 输出文件的基本信息，任务未完成时不返回
@property (nonatomic,strong)QCloudMediaResult * MediaResult;

/// 同请求中的 Request.Operation.DigitalWatermark
@property (nonatomic,strong)QCloudInputPostTranscodeDigitalWatermark * DigitalWatermark;

/// 透传用户信息
@property (nonatomic,strong)NSString * UserData;

/// 任务优先级
@property (nonatomic,strong)NSString * JobLevel;

@end

@interface QCloudInputPostTranscode : NSObject 

/// 待操作的文件信息;是否必传：是;
@property (nonatomic,strong)QCloudInputPostTranscodeInput * Input;

/// 操作规则;是否必传：是;
@property (nonatomic,strong)QCloudInputPostTranscodeOperation * Operation;

/// 任务所在的队列类型，限制为 SpeedTranscoding, 表示为开启倍速转码;是否必传：否;
@property (nonatomic,strong)NSString * QueueType;

/// 任务回调格式，JSON 或 XML，默认 XML，优先级高于队列的回调格式;是否必传：否;
@property (nonatomic,strong)NSString * CallBackFormat;

/// 任务回调类型，Url 或 TDMQ，默认 Url，优先级高于队列的回调类型;是否必传：否;
@property (nonatomic,strong)NSString * CallBackType;

/// 任务回调地址，优先级高于队列的回调地址。设置为 no 时，表示队列的回调地址不产生回调;是否必传：否;
@property (nonatomic,strong)NSString * CallBack;

/// 任务回调TDMQ配置，当 CallBackType 为 TDMQ 时必填。详情见 CallBackMqConfig;是否必传：否;
@property (nonatomic,strong)QCloudCallBackMqConfig * CallBackMqConfig;

@end

@interface QCloudInputPostTranscodeInput : NSObject 

/// 文件路径;是否必传：是;
@property (nonatomic,strong)NSString * Object;

@end

@interface QCloudInputPostTranscodeOperation : NSObject 

/// 转码模板 ID;是否必传：否;
@property (nonatomic,strong)NSString * TemplateId;

/// 转码模板参数;是否必传：否;
@property (nonatomic,strong)QCloudInputPostTranscodeTranscode * Transcode;

/// 水印模板 ID，可以传多个水印模板 ID，最多传3个。;是否必传：否;
@property (nonatomic,strong)NSArray <NSString * > * WatermarkTemplateId;

/// 水印模板参数，同创建水印模板接口中的 Request.Watermark ，最多传3个。;是否必传：否;
@property (nonatomic,strong)NSArray <QCloudInputPostTranscodeWatermark * > * Watermark;

/// 去除水印参数, H265、AV1编码暂不支持该参数;是否必传：否;
@property (nonatomic,strong)QCloudInputPostTranscodeRWatermark * RemoveWatermark;

/// 字幕参数, H265、AV1编码和非mkv封装 暂不支持该参数;是否必传：否;
@property (nonatomic,strong)QCloudInputPostTranscodeSubtitles * Subtitles;

/// 数字水印参数,详情见 DigitalWatermark;是否必传：否;
@property (nonatomic,strong)QCloudInputPostTranscodeDigitalWatermark * DigitalWatermark;

/// 结果输出配置;是否必传：是;
@property (nonatomic,strong)QCloudInputPostTranscodeOutput * Output;

/// 透传用户信息, 可打印的 ASCII 码, 长度不超过1024;是否必传：否;
@property (nonatomic,strong)NSString * UserData;

/// 任务优先级，级别限制：0 、1 、2 。级别越大任务优先级越高，默认为0;是否必传：否;
@property (nonatomic,strong)NSString * JobLevel;

@end

@interface QCloudInputPostTranscodeOutput : NSObject

/// 存储桶的地域;是否必传：是;
@property (nonatomic,strong)NSString * Region;

/// 存储结果的存储桶;是否必传：是;
@property (nonatomic,strong)NSString * Bucket;

/// 输出结果的文件名;是否必传：是;
@property (nonatomic,strong)NSString * Object;

@end

@interface QCloudInputPostTranscodeSubtitles : NSObject

/// 字幕参数;是否必传：是;
@property (nonatomic,strong)NSArray <QCloudInputPostTranscodeSubtitle * > * Subtitle;

@end

@interface QCloudInputPostTranscodeTranscode : NSObject

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

@end

@interface QCloudInputPostTranscodeRWatermark : NSObject

/// 距离左上角原点 x 偏移，范围为[1, 4096];是否必传：是;
@property (nonatomic,strong)NSString * Dx;

/// 距离左上角原点 y 偏移，范围为[1, 4096];是否必传：是;
@property (nonatomic,strong)NSString * Dy;

/// 宽，范围为[1, 4096];是否必传：是;
@property (nonatomic,strong)NSString * Width;

/// 高，范围为[1, 4096];是否必传：是;
@property (nonatomic,strong)NSString * Height;

@end

@interface QCloudInputPostTranscodeSubtitle : NSObject

/// 同 bucket 的字幕地址;是否必传：是;
@property (nonatomic,strong)NSString * Url;

@end

NS_ASSUME_NONNULL_END
