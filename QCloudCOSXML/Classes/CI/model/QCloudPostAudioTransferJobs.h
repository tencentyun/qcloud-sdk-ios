//
//  QCloudPostAudioTransferJobs.h 
//  QCloudCOSXML 
// 
//  Created by garenwang on 2023-06-13 09:20:26 +0000. 
//
#import <Foundation/Foundation.h>
#import "QCloudCICommonModel.h"
#import "QCloudWorkflowexecutionResult.h"
NS_ASSUME_NONNULL_BEGIN

@class QCloudPostAudioTransferDetail;
@class QCloudPostAudioTransferJobsInput;
@class QCloudPostAudioTransferJobsOperation;

@class QCloudInputPostAudioTransferJobs;
@class QCloudInputPostAudioTransferJobsInput;
@class QCloudInputPostAudioTransferOperation;
@class QCloudInputPostAudioTransferOutput;
@class QCloudInputPostAudioTransferSegment;
@class QCloudInputPostAudioTransferHlsEncrypt;

@interface QCloudPostAudioTransferJobs : NSObject 

/// 任务的详细信息
@property (nonatomic,strong)QCloudPostAudioTransferDetail * JobsDetail;

@end

@interface QCloudPostAudioTransferDetail : NSObject

/// 错误码，只有 State 为 Failed 时有意义
@property (nonatomic,strong)NSString * Code;

/// 错误描述，只有 State 为 Failed 时有意义
@property (nonatomic,strong)NSString * Message;

/// 新创建任务的 ID
@property (nonatomic,strong)NSString * JobId;

/// 新创建任务的 Tag：Segment
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
@property (nonatomic,strong)QCloudPostAudioTransferJobsInput * Input;

/// 该任务的规则
@property (nonatomic,strong)QCloudPostAudioTransferJobsOperation * Operation;

@end

@interface QCloudPostAudioTransferJobsInput : NSObject

/// 存储桶的地域
@property (nonatomic,strong)NSString * Region;

/// 存储结果的存储桶
@property (nonatomic,strong)NSString * Bucket;

/// 输出结果的文件名
@property (nonatomic,strong)NSString * Object;

@end

@interface QCloudPostAudioTransferJobsOperation : NSObject

/// 同请求中的 Request.Operation.Segment
@property (nonatomic,strong)QCloudInputPostAudioTransferSegment * Segment;

/// 同请求中的 Request.Operation.Output
@property (nonatomic,strong)QCloudInputPostAudioTransferOutput * Output;

/// 转码输出视频的信息，没有时不返回
@property (nonatomic,strong)QCloudWorkflowMediaInfo * MediaInfo;

/// 输出文件的基本信息，任务未完成时不返回
@property (nonatomic,strong)QCloudMediaResult * MediaResult;

/// 透传用户信息
@property (nonatomic,strong)NSString * UserData;

/// 任务优先级
@property (nonatomic,strong)NSString * JobLevel;

@end

@interface QCloudInputPostAudioTransferJobs : NSObject 

/// 待操作的文件信息;是否必传：是;
@property (nonatomic,strong)QCloudInputPostAudioTransferJobsInput * Input;

/// 操作规则;是否必传：是;
@property (nonatomic,strong)QCloudInputPostAudioTransferOperation * Operation;

/// 任务回调格式，JSON 或 XML，默认 XML，优先级高于队列的回调格式;是否必传：否;
@property (nonatomic,strong)NSString * CallBackFormat;

/// 任务回调类型，Url 或 TDMQ，默认 Url，优先级高于队列的回调类型;是否必传：否;
@property (nonatomic,strong)NSString * CallBackType;

/// 任务回调地址，优先级高于队列的回调地址。设置为 no 时，表示队列的回调地址不产生回调;是否必传：否;
@property (nonatomic,strong)NSString * CallBack;

/// 任务回调TDMQ配置，当 CallBackType 为 TDMQ 时必填。详情见 CallBackMqConfig;是否必传：否;
@property (nonatomic,strong)QCloudCallBackMqConfig * CallBackMqConfig;

@end

@interface QCloudInputPostAudioTransferJobsInput : NSObject 

/// 文件路径;是否必传：是;
@property (nonatomic,strong)NSString * Object;

@end

@interface QCloudInputPostAudioTransferOperation : NSObject

/// 转封装参数;是否必传：是;
@property (nonatomic,strong)QCloudInputPostAudioTransferSegment * Segment;

/// 结果输出配置;是否必传：是;
@property (nonatomic,strong)QCloudInputPostAudioTransferOutput * Output;

/// 任务优先级，级别限制：0 、1 、2 。级别越大任务优先级越高，默认为0;是否必传：否;
@property (nonatomic,strong)NSString * JobLevel;

@end

@interface QCloudInputPostAudioTransferOutput : NSObject

/// 存储桶的地域;是否必传：是;
@property (nonatomic,strong)NSString * Region;

/// 存储结果的存储桶;是否必传：是;
@property (nonatomic,strong)NSString * Bucket;

/// 输出结果的文件名，如果设置了Duration, 且 Format 不为 HLS 或 m3u8 时, 文件名必须包含${number}参数作为自定义转封装后每一小段音/视频流的输出序号;是否必传：是;
@property (nonatomic,strong)NSString * Object;

@end

@interface QCloudInputPostAudioTransferSegment : NSObject

/// 封装格式;是否必传：是;;限制：aac、mp3、flac、mp4、ts、mkv、avi、hls、m3u8;
@property (nonatomic,strong)NSString * Format;

/// 转封装时长，单位：秒;是否必传：否;;限制：不小于5的整数;
@property (nonatomic,strong)NSString * Duration;

/// 处理的流编号，对应媒体信息中的 Response.MediaInfo.Stream.Video.Index 和 Response.MediaInfo.Stream.Audio.Index，详见 获取媒体信息接口;是否必传：否;;限制：无;
@property (nonatomic,strong)NSString * TranscodeIndex;

/// hls 加密配置;是否必传：否;;限制：无, 只有当封装格式为 hls 时生效;
@property (nonatomic,strong)QCloudInputPostAudioTransferHlsEncrypt * HlsEncrypt;

@end

@interface QCloudInputPostAudioTransferHlsEncrypt : NSObject

/// 是否开启 HLS 加密;是否必传：否;;默认值：FALSE;;限制：1. true/false 2. Segment.Format 为 HLS 时支持加密;
@property (nonatomic,strong)NSString * IsHlsEncrypt;

/// HLS 加密的 key;是否必传：否;;默认值：无;;限制：当 IsHlsEncrypt 为 true 时，该参数才有意义;
@property (nonatomic,strong)NSString * UriKey;

@end

NS_ASSUME_NONNULL_END
