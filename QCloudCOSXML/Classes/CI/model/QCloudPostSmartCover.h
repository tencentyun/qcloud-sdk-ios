//
//  QCloudPostSmartCover.h 
//  QCloudCOSXML 
// 
//  Created by garenwang on 2023-06-14 02:45:20 +0000. 
// 
#import <Foundation/Foundation.h> 
#import "QCloudCICommonModel.h"
NS_ASSUME_NONNULL_BEGIN

@class QCloudPostSmartCoverJobsDetail;
@class QCloudPostSmartCoverJobsDetailInput;
@class QCloudPostSmartCoverJobsDetailOperation;
@class QCloudInputPostSmartCover;
@class QCloudInputPostSmartCoverInput;
@class QCloudInputPostSmartCoverOperation;
@class QCloudInputPostSmartOutput;
@class QCloudInputPostSmartOperationCover;
@interface QCloudPostSmartCover : NSObject 

/// 任务的详细信息
@property (nonatomic,strong)QCloudPostSmartCoverJobsDetail * JobsDetail;

@end

@interface QCloudPostSmartCoverJobsDetail : NSObject 

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
@property (nonatomic,strong)QCloudPostSmartCoverJobsDetailInput * Input;

/// 该任务的规则
@property (nonatomic,strong)QCloudPostSmartCoverJobsDetailOperation * Operation;

@end

@interface QCloudPostSmartCoverJobsDetailInput : NSObject 

/// 存储桶的地域
@property (nonatomic,strong)NSString * Region;

/// 存储结果的存储桶
@property (nonatomic,strong)NSString * Bucket;

/// 输出结果的文件名
@property (nonatomic,strong)NSString * Object;

@end

@interface QCloudPostSmartCoverJobsDetailOperation : NSObject 

/// 同请求中的 Request.Operation.SmartCover
@property (nonatomic,strong)QCloudInputPostSmartOperationCover * SmartCover;

/// 同请求中的 Request.Operation.Output
@property (nonatomic,strong)QCloudInputPostSmartOutput * Output;

/// 输出文件的基本信息，任务未完成时不返回
@property (nonatomic,strong)QCloudMediaResult * MediaResult;

/// 透传用户信息
@property (nonatomic,strong)NSString * UserData;

/// 任务优先级
@property (nonatomic,strong)NSString * JobLevel;

@end

@interface QCloudInputPostSmartCover : NSObject 

/// 待操作的文件信息;是否必传：是;
@property (nonatomic,strong)QCloudInputPostSmartCoverInput * Input;

/// 操作规则;是否必传：是;
@property (nonatomic,strong)QCloudInputPostSmartCoverOperation * Operation;

/// 任务回调格式，JSON 或 XML，默认 XML，优先级高于队列的回调格式;是否必传：否;
@property (nonatomic,strong)NSString * CallBackFormat;

/// 任务回调类型，Url 或 TDMQ，默认 Url，优先级高于队列的回调类型;是否必传：否;
@property (nonatomic,strong)NSString * CallBackType;

/// 任务回调地址，优先级高于队列的回调地址。设置为 no 时，表示队列的回调地址不产生回调;是否必传：否;
@property (nonatomic,strong)NSString * CallBack;

/// 任务回调 TDMQ 配置，当 CallBackType 为 TDMQ 时必填。详情见 CallBackMqConfig;是否必传：否;
@property (nonatomic,strong)QCloudCallBackMqConfig * CallBackMqConfig;

@end

@interface QCloudInputPostSmartCoverInput : NSObject 

/// 文件路径;是否必传：是
@property (nonatomic,strong)NSString * Object;

@end

@interface QCloudInputPostSmartCoverOperation : NSObject 

/// 智能封面模板id;是否必传：否;
@property (nonatomic,strong)NSString * TemplateId;

/// 封面配置, 同创建智能封面模板接口中的 Request.Container;是否必传：否;
@property (nonatomic,strong)QCloudInputPostSmartOperationCover * SmartCover;

/// 结果输出配置;是否必传：是;
@property (nonatomic,strong)QCloudInputPostSmartOutput * Output;

/// 透传用户信息, 可打印的 ASCII 码, 长度不超过1024;是否必传：否;
@property (nonatomic,strong)NSString * UserData;

/// 任务优先级，级别限制：0 、1 、2 。级别越大任务优先级越高，默认为0;是否必传：否;
@property (nonatomic,strong)NSString * JobLevel;

@end

@interface QCloudInputPostSmartOutput : NSObject

/// 存储桶的地域;是否必传：是;
@property (nonatomic,strong)NSString * Region;

/// 存储结果的存储桶;是否必传：是;
@property (nonatomic,strong)NSString * Bucket;

/// 输出结果的文件名;是否必传：是;
@property (nonatomic,strong)NSString * Object;

@end

@interface QCloudInputPostSmartOperationCover : NSObject

/// 图片格式;是否必传：否;;默认值：jpg;;限制：jpg、png 、webp;
@property (nonatomic,strong)NSString * Format;

/// 宽;是否必传：否;;默认值：视频原始宽度;;限制：值范围：[128，4096] 单位：px 若只设置 Width 时，按照视频原始比例计算 Height;
@property (nonatomic,strong)NSString * Width;

/// 高;是否必传：否;;默认值：视频原始高度;;限制：值范围：[128，4096] 单位：px 若只设置 Height 时，按照视频原始比例计算 Width;
@property (nonatomic,strong)NSString * Height;

/// 截图数量;是否必传：否;;默认值：3;;限制：[1,10];
@property (nonatomic,strong)NSString * Count;

/// 封面去重;是否必传：否;;默认值：FALSE;;限制：true/false;
@property (nonatomic,strong)NSString * DeleteDuplicates;

@end

NS_ASSUME_NONNULL_END
