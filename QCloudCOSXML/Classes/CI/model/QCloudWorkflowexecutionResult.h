//
//  QCloudWorkflowexecutionResult.h 
//  QCloudCOSXML 
// 
//  Created by garenwang on 2023-06-16 07:01:36 +0000. 
// 
#import <Foundation/Foundation.h> 

NS_ASSUME_NONNULL_BEGIN

@class QCloudWorkflowexecutionResultWE;
@class QCloudWorkflowexecutionResultTasks;
@class QCloudWorkflowFileInfo;
@class QCloudWorkflowResultInfo;
@class QCloudWorkflowJudgementInfo;
@class QCloudWorkflowBasicInfo;
@class QCloudWorkflowMediaInfo;
@class QCloudWorkflowImageInfo;
@class QCloudWorkflowObjectInfo;
@class QCloudWorkflowexecutionResultVideo;
@class QCloudWorkflowexecutionResultAudio;
@class QCloudWorkflowexecutionResultFormat;
@class QCloudWorkflowSpriteObjectInfo;
@class QCloudWorkflowJudgementResult;
@class QCloudWorkflowInputObjectInfo;
@class QCloudWorkflowExecutionTopology;
@interface QCloudWorkflowexecutionResult : NSObject 

/// 请求 ID
@property (nonatomic,strong)NSString * RequestId;

/// 工作流实例详细信息
@property (nonatomic,strong)QCloudWorkflowexecutionResultWE * WorkflowExecution;

@end

@interface QCloudWorkflowexecutionResultWE : NSObject

/// 工作流 ID
@property (nonatomic,strong)NSString * WorkflowId;

/// 工作流名称
@property (nonatomic,strong)NSString * WorkflowName;

/// 工作流实例 ID
@property (nonatomic,strong)NSString * RunId;

/// 创建时间
@property (nonatomic,strong)NSString * CreateTime;

/// COS 对象地址
@property (nonatomic,strong)NSString * Object;

/// 工作流实例状态
@property (nonatomic,strong)NSString * State;

/// 同创建工作流接口的 Topology
@property (nonatomic,strong)QCloudWorkflowExecutionTopology * Topology;

/// 工作流实例任务
@property (nonatomic,strong)NSArray <QCloudWorkflowexecutionResultTasks * > * Tasks;

@end

@interface QCloudWorkflowExecutionTopology : NSObject

@property (nonatomic,strong)NSDictionary * Dependencies;

@property (nonatomic,strong)NSDictionary * Nodes;

@end

@interface QCloudWorkflowexecutionResultTasks : NSObject 

/// 任务所属节点类型
@property (nonatomic,strong)NSString * Type;

/// 任务状态，当该节点为判断节点时，PartialSuccess 表示部分输入文件通过判断
@property (nonatomic,strong)NSString * State;

/// 任务 ID
@property (nonatomic,strong)NSString * JobId;

/// 任务创建时间
@property (nonatomic,strong)NSString * CreateTime;

/// 任务开始时间
@property (nonatomic,strong)NSString * StartTime;

/// 任务结束时间
@property (nonatomic,strong)NSString * EndTime;

/// 任务的错误码
@property (nonatomic,strong)NSString * Code;

/// 任务的错误信息
@property (nonatomic,strong)NSString * Message;

/// 工作流节点节点name
@property (nonatomic,strong)NSString * Name;

/// 任务结果详情
@property (nonatomic,strong)QCloudWorkflowResultInfo * ResultInfo;

/// 判断节点结果详情，当节点为判断节点时返回
@property (nonatomic,strong)QCloudWorkflowJudgementInfo * JudgementInfo;

/// 判断节点结果详情，当节点为判断节点时返回
@property (nonatomic,strong)NSArray <QCloudWorkflowFileInfo * > * FileInfo;

@end

@interface QCloudWorkflowFileInfo : NSObject

/// 文件基础信息
@property (nonatomic,strong)QCloudWorkflowBasicInfo * BasicInfo;

/// 音视频信息
@property (nonatomic,strong)QCloudWorkflowMediaInfo * MediaInfo;

/// 图片信息
@property (nonatomic,strong)QCloudWorkflowImageInfo * ImageInfo;

@end

@interface QCloudWorkflowResultInfo : NSObject

/// 任务生成对象文件个数
@property (nonatomic,strong)NSString * ObjectCount;

/// 仅在截图生成雪碧图有效，表示生成雪碧图个数
@property (nonatomic,strong)NSString * SpriteObjectCount;

/// 任务生成对象详情
@property (nonatomic,strong)NSArray <QCloudWorkflowObjectInfo * > * ObjectInfo;

/// 任务生成雪碧图对象详情
@property (nonatomic,strong)NSArray <QCloudWorkflowSpriteObjectInfo * > * SpriteObjectInfo;

@end

@interface QCloudWorkflowJudgementInfo : NSObject

/// 判断节点输入对象文件个数
@property (nonatomic,assign)NSInteger ObjectCount;

/// 判断节点输入对象具体判断结果
@property (nonatomic,strong)NSArray <QCloudWorkflowJudgementResult * > * JudgementResult;

@end

@interface QCloudWorkflowBasicInfo : NSObject

/// 文件类型
@property (nonatomic,strong)NSString * ContentType;

/// 文件大小
@property (nonatomic,strong)NSString * Size;

/// 文件Etag
@property (nonatomic,strong)NSString * ETag;

/// 文件上修改时间
@property (nonatomic,strong)NSString * LastModified;

/// 文件名
@property (nonatomic,strong)NSString * Object;

@end

@interface QCloudWorkflowMediaInfo : NSObject

/// 视频信息
@property (nonatomic,strong)QCloudWorkflowexecutionResultVideo * Video;

/// 音频信息
@property (nonatomic,strong)QCloudWorkflowexecutionResultAudio * Audio;

/// 格式信息
@property (nonatomic,strong)QCloudWorkflowexecutionResultFormat * Format;

@end

@interface QCloudWorkflowImageInfo : NSObject

/// 图片高
@property (nonatomic,strong)NSString * Format;

/// 图片宽
@property (nonatomic,strong)NSString * Height;

/// 图片宽
@property (nonatomic,strong)NSString * Width;

/// 图片Md5
@property (nonatomic,strong)NSString * Md5;

/// 图片帧数，静态图为1，动图为对应的帧数
@property (nonatomic,strong)NSString * FrameCount;

@end

@interface QCloudWorkflowObjectInfo : NSObject

/// 对象名
@property (nonatomic,strong)NSString * ObjectName;

/// 对象Url
@property (nonatomic,strong)NSString * ObjectUrl;

/// 输入对象名
@property (nonatomic,strong)NSString * InputObjectName;

/// InputObjectName对应错误码，O为处理成功，非0处理失败
@property (nonatomic,strong)NSString * Code;

/// InputObjectName对应错误信息，处理失败时有效
@property (nonatomic,strong)NSString * Message;

@end

@interface QCloudWorkflowexecutionResultVideo : NSObject 

/// 视频高
@property (nonatomic,strong)NSString * Height;

/// 视频宽
@property (nonatomic,strong)NSString * Width;

/// 视频宽高比
@property (nonatomic,strong)NSString * Dar;

/// 视频时长，单位秒
@property (nonatomic,strong)NSString * Duration;

@end

@interface QCloudWorkflowexecutionResultAudio : NSObject 

/// 音频时长，单位秒
@property (nonatomic,strong)NSString * Duration;

@end

@interface QCloudWorkflowexecutionResultFormat : NSObject 

/// 时长，单位秒
@property (nonatomic,strong)NSString * Duration;

@end

@interface QCloudWorkflowSpriteObjectInfo : NSObject

/// 对象名
@property (nonatomic,strong)NSString * ObjectName;

/// 对象Url
@property (nonatomic,strong)NSString * ObjectUrl;

@end

@interface QCloudWorkflowJudgementResult : NSObject

/// 对象名
@property (nonatomic,strong)NSString * ObjectName;

/// 对象链接
@property (nonatomic,strong)NSString * ObjectUrl;

/// 判断结果状态，Success 表示通过条件判断，Failed 表示未通过条件判断
@property (nonatomic,strong)NSString * State;

/// 输入文件的判断参数
@property (nonatomic,strong)QCloudWorkflowInputObjectInfo * InputObjectInfo;

@end

@interface QCloudWorkflowInputObjectInfo : NSObject 

/// 视频宽
@property (nonatomic,strong)NSString * Width;

/// 视频高
@property (nonatomic,strong)NSString * Height;

/// 视频宽高比
@property (nonatomic,strong)NSString * Dar;

/// 音视频时长
@property (nonatomic,strong)NSString * Duration;

/// 文件大小
@property (nonatomic,strong)NSString * Size;

/// 图片宽
@property (nonatomic,strong)NSString * ImageWidth;

/// 图片高
@property (nonatomic,strong)NSString * ImageHeight;

/// 图片宽高比
@property (nonatomic,strong)NSString * ImageDar;

@end

NS_ASSUME_NONNULL_END
