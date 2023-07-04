//
//  QCloudMediaJobs.h 
//  QCloudCOSXML 
// 
//  Created by garenwang on 2023-06-13 02:55:47 +0000. 
// 
#import <Foundation/Foundation.h>
#import "QCloudCICommonModel.h"
 NS_ASSUME_NONNULL_BEGIN

@class QCloudMediaJobsDetail;
@class QCloudJobsDetailInput;
@class QCloudJobsDetailOperation;
@interface QCloudMediaJobs : NSObject 

/// 任务的详细信息
@property (nonatomic,strong)QCloudMediaJobsDetail * JobsDetail;

@end

@interface QCloudMediaJobsDetail : NSObject 

/// 错误码，只有 State 为 Failed 时有意义
@property (nonatomic,strong)NSString * Code;

/// 错误描述，只有 State 为 Failed 时有意义
@property (nonatomic,strong)NSString * Message;

/// 新创建任务的 ID
@property (nonatomic,strong)NSString * JobId;

/// 新创建任务的 Tag：MediaInfo
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
@property (nonatomic,strong)QCloudJobsDetailInput * Input;

/// 该任务的规则
@property (nonatomic,strong)QCloudJobsDetailOperation * Operation;

@end

@interface QCloudJobsDetailInput : NSObject 

/// 存储桶的地域
@property (nonatomic,strong)NSString * Region;

/// 存储结果的存储桶
@property (nonatomic,strong)NSString * Bucket;

/// 输出结果的文件名
@property (nonatomic,strong)NSString * Object;

@end

@interface QCloudJobsDetailOperation : NSObject 

/// 输出视频的信息，任务未完成时不返回
@property (nonatomic,strong)QCloudWorkflowMediaInfo * MediaInfo;

/// 透传用户信息
@property (nonatomic,strong)NSString * UserData;

/// 任务优先级
@property (nonatomic,strong)NSString * JobLevel;

@end

@class QCloudMediaJobsInputInput;
@class QCloudMediaJobsInputOperation;

@interface QCloudMediaJobsInput : NSObject
/// 待操作的对象信息 必选
@property (nonatomic,strong)QCloudMediaJobsInputInput *Input;

/// 操作规则 必选
@property (nonatomic,strong)QCloudMediaJobsInputOperation *Operation;

/// 任务所在的队列 ID 必选
@property (nonatomic,strong)NSString *QueueId;

/// 任务回调地址，优先级高于队列的回调地址。设置为 no 时，表示队列的回调地址不产生回调 可选
@property (nonatomic,strong)NSString *CallBack;

/// 任务回调类型，Url 或 TDMQ，默认 Url，优先级高于队列的回调类型
@property (nonatomic,strong)NSString *CallBackType;

/// 任务回调格式，JSON 或 XML，默认 XML，优先级高于队列的回调格式 可选
@property (nonatomic,strong)NSString *CallBackFormat;

/// 任务回调TDMQ配置，当 CallBackType 为 TDMQ 时必填。
@property (nonatomic,strong)QCloudCallBackMqConfig *CallBackMqConfig;
@end

@interface QCloudMediaJobsInputInput : NSObject

/// 文件路径
@property (nonatomic,strong)NSString *Object;

@end

@interface QCloudMediaJobsInputOperation : NSObject

/// 透传用户信息, 可打印的 ASCII 码, 长度不超过1024  可选
@property (nonatomic,strong)NSString *UserData;

/// 任务优先级，级别限制：0 、1 、2 。级别越大任务优先级越高，默认为0 可选
@property (nonatomic,strong)NSString *JobLevel;

@end

NS_ASSUME_NONNULL_END
