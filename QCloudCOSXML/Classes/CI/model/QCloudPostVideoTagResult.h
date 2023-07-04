//
//  QCloudPostVideoTagResult.h 
//  QCloudCOSXML 
// 
//  Created by garenwang on 2023-06-16 03:40:34 +0000. 
// 
#import <Foundation/Foundation.h> 
#import "QCloudCICommonModel.h"
NS_ASSUME_NONNULL_BEGIN

@class QCloudPostVideoTagResultJobsDetail;
@class QCloudPostVideoTagResultInput;
@class QCloudPostVideoTagResultOperation;
@class QCloudPostVideoTagResultVideoTagResult;
@class QCloudPostVideoTagResultStreamData;
@class QCloudPostVideoTagResultData;
@class QCloudPostVideoTagResultTags;
@class QCloudPostVideoTagResultPlaceTags;
@class QCloudPostVideoTagResultPersonTags;
@class QCloudPostVideoTagResultActionTags;
@class QCloudPostVideoTagResultObjectTags;
@class QCloudPostVideoTagResultObjects;
@class QCloudPostVideoTagResultDetailPerSecond;
@class QCloudPostVideoTagResultBBox;
@class QCloudPostVideoTag;
@class QCloudPostVideoTagInput;
@class QCloudPostVideoTagOperation;
@class QCloudPostVideoTagVideoTag;
@interface QCloudPostVideoTagResult : NSObject 

/// 任务的详细信息
@property (nonatomic,strong)QCloudPostVideoTagResultJobsDetail * JobsDetail;

@end

@interface QCloudPostVideoTagResultJobsDetail : NSObject 

/// 错误码，只有 State 为 Failed 时有意义
@property (nonatomic,strong)NSString * Code;

/// 错误描述，只有 State 为 Failed 时有意义
@property (nonatomic,strong)NSString * Message;

/// 新创建任务的 ID
@property (nonatomic,strong)NSString * JobId;

/// 新创建任务的 Tag：VideoTag
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
@property (nonatomic,strong)QCloudPostVideoTagResultInput * Input;

/// 该任务的规则
@property (nonatomic,strong)QCloudPostVideoTagResultOperation * Operation;

@end

@interface QCloudPostVideoTagResultInput : NSObject 

/// 存储桶的地域
@property (nonatomic,strong)NSString * Region;

/// 存储结果的存储桶
@property (nonatomic,strong)NSString * Bucket;

/// 输出结果的文件名
@property (nonatomic,strong)NSString * Object;

@end

@interface QCloudPostVideoTagResultOperation : NSObject 

/// 同请求中的 Request.Operation.VideoTag
@property (nonatomic,strong)QCloudPostVideoTagVideoTag * VideoTag;

/// 视频标签分析结果,任务未完成时不返回
@property (nonatomic,strong)QCloudPostVideoTagResultVideoTagResult * VideoTagResult;

/// 透传用户信息
@property (nonatomic,strong)NSString * UserData;

/// 任务优先级
@property (nonatomic,strong)NSString * JobLevel;

@end

@interface QCloudPostVideoTagResultVideoTagResult : NSObject 

/// Stream 场景下视频标签任务的结果
@property (nonatomic,strong)QCloudPostVideoTagResultStreamData * StreamData;

@end

@interface QCloudPostVideoTagResultStreamData : NSObject 

/// Stream 场景视频标签任务的结果列表
@property (nonatomic,strong)QCloudPostVideoTagResultData * Data;

/// 算法状态码，成功为0，非0异常
@property (nonatomic,strong)NSString * SubErrCode;

/// 算法错误描述，成功为 ok , 不成功返回对应错误
@property (nonatomic,strong)NSString * SubErrMsg;

@end

@interface QCloudPostVideoTagResultData : NSObject 

/// 视频标签、视频分类信息
@property (nonatomic,strong)QCloudPostVideoTagResultTags * Tags;

/// 人物标签信息
@property (nonatomic,strong)NSArray <QCloudPostVideoTagResultPersonTags * > * PersonTags;

/// 场景标签信息
@property (nonatomic,strong)NSArray <QCloudPostVideoTagResultPlaceTags * > * PlaceTags;

/// 动作标签信息
@property (nonatomic,strong)NSArray <QCloudPostVideoTagResultActionTags * > * ActionTags;

/// 物体标签信息
@property (nonatomic,strong)NSArray <QCloudPostVideoTagResultObjectTags * > * ObjectTags;

@end

@interface QCloudPostVideoTagResultTags : NSObject 

/// 标签名称
@property (nonatomic,strong)NSString * Tag;

/// 标签分类名称
@property (nonatomic,strong)NSString * TagCls;

/// 标签模型预测分数，取值范围[0,1]
@property (nonatomic,assign)CGFloat Confidence;

@end

@interface QCloudPostVideoTagResultPlaceTags : NSObject 

/// 视频场景标签信息，可能不返回，内容同 Response.JobsDetail.Operation.VideoTagResult.StreamData.Data.Tags
@property (nonatomic,strong)NSArray <QCloudPostVideoTagResultTags * > * Tags;

/// 片段起始时间，单位为秒
@property (nonatomic,strong)NSString * StartTime;

/// 片段结束时间，单位为秒
@property (nonatomic,strong)NSString * EndTime;

/// 片段起始帧数
@property (nonatomic,strong)NSString * StartIndex;

/// 片段结束帧数
@property (nonatomic,strong)NSString * EndIndex;

/// 单帧识别结果top1
@property (nonatomic,strong)NSString * ClipFrameResult;

@end

@interface QCloudPostVideoTagResultPersonTags : NSObject 

/// 人物名字
@property (nonatomic,strong)NSString * Name;

/// 标签模型预测分数
@property (nonatomic,assign)CGFloat Confidence;

/// 任务出现频次
@property (nonatomic,strong)NSString * Count;

/// 具体识别到人物出现的位置和时间信息
@property (nonatomic,strong)NSArray <QCloudPostVideoTagResultDetailPerSecond * > * DetailPerSecond;

@end

@interface QCloudPostVideoTagResultActionTags : NSObject 

/// 视频动作标签信息，可能不返回，内容同 Response.JobsDetail.Operation.VideoTagResult.StreamData.Data.Tags
@property (nonatomic,strong)NSArray <QCloudPostVideoTagResultTags * > * Tags;

/// 片段起始时间，单位为秒
@property (nonatomic,strong)NSString * StartTime;

/// 片段结束时间，单位为秒
@property (nonatomic,strong)NSString * EndTime;

@end

@interface QCloudPostVideoTagResultObjectTags : NSObject 

/// 视频物体标签信息，可能不返回，内容同 Response.JobsDetail.Operation.VideoTagResult.StreamData.Data.Tags
@property (nonatomic,strong)NSArray <QCloudPostVideoTagResultObjects * > * Objects;

/// 识别物体时间戳，单位为秒
@property (nonatomic,strong)NSString * TimeStamp;

@end

@interface QCloudPostVideoTagResultObjects : NSObject 

/// 物体名称
@property (nonatomic,strong)NSString * Name;

/// 标签模型预测分数，取值范围[0,1]
@property (nonatomic,assign)CGFloat Confidence;

/// 左上角为原点，物体的相对坐标, 内容同 Response.JobsDetail.Operation.VideoTagResult.StreamData.Data.PersonTags.DetailPerSecond.BBox
@property (nonatomic,strong)NSArray <QCloudPostVideoTagResultBBox * > * BBox;

@end

@interface QCloudPostVideoTagResultDetailPerSecond : NSObject 

/// 出现时间，单位为秒
@property (nonatomic,strong)NSString * TimeStamp;

/// 标签模型预测分数
@property (nonatomic,assign)CGFloat Confidence;

/// 左上角为原点，物体的相对坐标
@property (nonatomic,strong)NSArray <QCloudPostVideoTagResultBBox * > * BBox;

@end

@interface QCloudPostVideoTagResultBBox : NSObject 

/// 坐标X1的相对位置
@property (nonatomic,strong)NSString * X1;

/// 坐标Y1的相对位置
@property (nonatomic,strong)NSString * Y1;

/// 坐标X2的相对位置
@property (nonatomic,strong)NSString * X2;

/// 坐标Y2的相对位置
@property (nonatomic,strong)NSString * Y2;

@end

@interface QCloudPostVideoTag : NSObject 

/// 创建任务的 Tag：VideoTag;是否必传：是;
@property (nonatomic,strong)NSString * Tag;

/// 待操作的文件信息;是否必传：是;
@property (nonatomic,strong)QCloudPostVideoTagInput * Input;

/// 操作规则;是否必传：是;
@property (nonatomic,strong)QCloudPostVideoTagOperation * Operation;

/// 任务回调格式，JSON 或 XML，默认 XML，优先级高于队列的回调格式;是否必传：否;
@property (nonatomic,strong)NSString * CallBackFormat;

/// 任务回调类型，Url 或 TDMQ，默认 Url，优先级高于队列的回调类型;是否必传：否;
@property (nonatomic,strong)NSString * CallBackType;

/// 任务回调地址，优先级高于队列的回调地址。设置为 no 时，表示队列的回调地址不产生回调;是否必传：否;
@property (nonatomic,strong)NSString * CallBack;

/// 任务回调 TDMQ 配置，当 CallBackType 为 TDMQ 时必填。详情见 CallBackMqConfig;是否必传：否;
@property (nonatomic,strong)QCloudCallBackMqConfig * CallBackMqConfig;

@end

@interface QCloudPostVideoTagInput : NSObject 

/// 执行视频标签任务的文件路径，目前支持 mp4、avi、mkv、wmv、rmvb、flv、mov 封装格式，视频时长超过30min的视频请 提交工单 处理;是否必传：是;
@property (nonatomic,strong)NSString * Object;

@end

@interface QCloudPostVideoTagOperation : NSObject 

/// 任务参数;是否必传：是;
@property (nonatomic,strong)QCloudPostVideoTagVideoTag * VideoTag;

/// 任务优先级，级别限制：0 、1 、2。级别越大任务优先级越高，默认为0;是否必传：否;
@property (nonatomic,strong)NSString * JobLevel;

/// 透传用户信息;是否必传：否;
@property (nonatomic,strong)NSString * UserData;

@end

@interface QCloudPostVideoTagVideoTag : NSObject 

/// 场景类型，可选择视频标签的运用场景，不同的运用场景使用的算法、输入输出等都会有所差异;是否必传：是;;限制：当前版本只适配 Stream 场景;
@property (nonatomic,strong)NSString * Scenario;

@end

NS_ASSUME_NONNULL_END
