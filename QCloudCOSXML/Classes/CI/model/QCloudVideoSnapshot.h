//
//  QCloudVideoSnapshot.h
//  QCloudCOSXML 
// 
//  Created by garenwang on 2023-06-14 06:49:22 +0000. 
// 
#import <Foundation/Foundation.h> 
#import "QCloudCICommonModel.h"
NS_ASSUME_NONNULL_BEGIN

@class QCloudVideoSnapshotJobsDetail;
@class QCloudVideoSnapshotJobsDetailInput;
@class QCloudVideoSnapshotJobsDetailOperation;

@class QCloudInputVideoSnapshot;
@class QCloudInputVideoSnapshotInput;
@class QCloudInputVideoSnapshotOperation;
@class QCloudInputVideoSnapshotOperationOutput;

@interface QCloudVideoSnapshot : NSObject

/// 任务的详细信息
@property (nonatomic,strong)QCloudVideoSnapshotJobsDetail * JobsDetail;

@end

@interface QCloudVideoSnapshotJobsDetail : NSObject

/// 错误码，只有 State 为 Failed 时有意义
@property (nonatomic,strong)NSString * Code;

/// 错误描述，只有 State 为 Failed 时有意义
@property (nonatomic,strong)NSString * Message;

/// 新创建任务的 ID
@property (nonatomic,strong)NSString * JobId;

/// 新创建任务的 Tag：Snapshot
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
@property (nonatomic,strong)QCloudVideoSnapshotJobsDetailInput * Input;

/// 该任务的规则
@property (nonatomic,strong)QCloudVideoSnapshotJobsDetailOperation * Operation;

@end

@interface QCloudVideoSnapshotJobsDetailInput : NSObject

/// 存储桶的地域
@property (nonatomic,strong)NSString * Region;

/// 存储结果的存储桶
@property (nonatomic,strong)NSString * Bucket;

/// 输出结果的文件名
@property (nonatomic,strong)NSString * Object;

@end

@interface QCloudVideoSnapshotJobsDetailOperation : NSObject

/// 任务的模板 ID
@property (nonatomic,strong)NSString * TemplateId;

/// 任务的模板名称, 当 TemplateId 存在时返回
@property (nonatomic,strong)NSString * TemplateName;

/// 同请求中的 Request.Operation.Snapshot
@property (nonatomic,strong)QCloudContainerSnapshot * Snapshot;

/// 同请求中的 Request.Operation.Output
@property (nonatomic,strong)QCloudInputVideoSnapshotOperationOutput * Output;

/// 输出文件的基本信息，任务未完成时不返回
@property (nonatomic,strong)QCloudMediaResult * MediaResult;

/// 透传用户信息
@property (nonatomic,strong)NSString * UserData;

/// 任务优先级
@property (nonatomic,strong)NSString * JobLevel;

@end

@interface QCloudInputVideoSnapshot : NSObject

/// 待操作的文件信息;是否必传：是;
@property (nonatomic,strong)QCloudInputVideoSnapshotInput * Input;

/// 操作规则;是否必传：是;
@property (nonatomic,strong)QCloudInputVideoSnapshotOperation * Operation;

/// 任务回调格式，JSON 或 XML，默认 XML，优先级高于队列的回调格式;是否必传：否;
@property (nonatomic,strong)NSString * CallBackFormat;

/// 任务回调类型，Url 或 TDMQ，默认 Url，优先级高于队列的回调类型;是否必传：否;
@property (nonatomic,strong)NSString * CallBackType;

/// 任务回调地址，优先级高于队列的回调地址。设置为 no 时，表示队列的回调地址不产生回调;是否必传：否;
@property (nonatomic,strong)NSString * CallBack;

/// 任务回调TDMQ配置，当 CallBackType 为 TDMQ 时必填。详情见 CallBackMqConfig;是否必传：否;
@property (nonatomic,strong)QCloudCallBackMqConfig * CallBackMqConfig;

@end

@interface QCloudInputVideoSnapshotInput : NSObject

/// 文件路径;是否必传：是;
@property (nonatomic,strong)NSString * Object;

@end

@interface QCloudInputVideoSnapshotOperation : NSObject

/// 该任务的参数，同创建截图模板接口中的 Request.Snapshot;是否必传：否;
@property (nonatomic,strong)QCloudContainerSnapshot * Snapshot;

/// 模板 ID;是否必传：否;
@property (nonatomic,strong)NSString * TemplateId;

/// 结果输出配置;是否必传：是;
@property (nonatomic,strong)QCloudInputVideoSnapshotOperationOutput * Output;

/// 透传用户信息, 可打印的 ASCII 码, 长度不超过1024;是否必传：否;
@property (nonatomic,strong)NSString * UserData;

/// 任务优先级，级别限制：0 、1 、2 。级别越大任务优先级越高，默认为0;是否必传：否;
@property (nonatomic,strong)NSString * JobLevel;

@end

@interface QCloudInputVideoSnapshotOperationOutput : NSObject

/// 存储桶的地域;是否必传：是;
@property (nonatomic,strong)NSString * Region;

/// 存储结果的存储桶;是否必传：是;
@property (nonatomic,strong)NSString * Bucket;

/// 结果文件的名字。当有多个输出文件时必须包含 ${number} 通配符。;是否必传：否;
@property (nonatomic,strong)NSString * Object;

/// 雪碧图的名字。当有多个输出文件时必须包含 ${number} 通配符。仅支持 jpg 格式;是否必传：否;
@property (nonatomic,strong)NSString * SpriteObject;

@end

NS_ASSUME_NONNULL_END
