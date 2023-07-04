//
//  QCloudExtractNumMark.h 
//  QCloudCOSXML 
// 
//  Created by garenwang on 2023-06-13 12:03:10 +0000. 
// 
#import <Foundation/Foundation.h> 
#import "QCloudCICommonModel.h"
NS_ASSUME_NONNULL_BEGIN

@class QCloudExtractNumMarkJobsDetail;
@class QCloudExtractNumMarkJobsDetailInput;
@class QCloudExtractNumMarkJobsDetailOperation;
@class QCloudExtractNumMarkDigitalWatermark;
@interface QCloudExtractNumMark : NSObject 

/// 任务的详细信息
@property (nonatomic,strong)QCloudExtractNumMarkJobsDetail * JobsDetail;

@end

@interface QCloudExtractNumMarkJobsDetail : NSObject 

/// 错误码，只有 State 为 Failed 时有意义
@property (nonatomic,strong)NSString * Code;

/// 错误描述，只有 State 为 Failed 时有意义
@property (nonatomic,strong)NSString * Message;

/// 新创建任务的 ID
@property (nonatomic,strong)NSString * JobId;

/// 创建任务的 Tag：ExtractDigitalWatermark
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
@property (nonatomic,strong)QCloudExtractNumMarkJobsDetailInput * Input;

/// 该任务的规则
@property (nonatomic,strong)QCloudExtractNumMarkJobsDetailOperation * Operation;

@end

@interface QCloudExtractNumMarkJobsDetailInput : NSObject 

/// 存储桶的地域
@property (nonatomic,strong)NSString * Region;

/// 存储结果的存储桶
@property (nonatomic,strong)NSString * Bucket;

/// 输出结果的文件名
@property (nonatomic,strong)NSString * Object;

@end

@interface QCloudExtractNumMarkJobsDetailOperation : NSObject 

/// 数字水印配置
@property (nonatomic,strong)QCloudExtractNumMarkDigitalWatermark * ExtractDigitalWatermark;

/// 透传用户信息
@property (nonatomic,strong)NSString * UserData;

/// 任务优先级
@property (nonatomic,strong)NSString * JobLevel;

@end

@interface QCloudExtractNumMarkDigitalWatermark : NSObject

/// 提取出的数字水印字符串信息
@property (nonatomic,strong)NSString * Message;

/// 水印类型
@property (nonatomic,strong)NSString * Type;

/// 水印版本
@property (nonatomic,strong)NSString * Version;

@end

@class QCloudInputExtractNumMark;
@class QCloudInputExtractNumMarkInput;
@class QCloudInputExtractNumMarkOperation;
@class QCloudInputExtractNumMarkDigitalWatermark;
@interface QCloudInputExtractNumMark : NSObject 

/// 待操作的文件信息;是否必传：是;
@property (nonatomic,strong)QCloudInputExtractNumMarkInput * Input;

/// 操作规则;是否必传：是;
@property (nonatomic,strong)QCloudInputExtractNumMarkOperation * Operation;

/// 任务回调格式，JSON 或 XML，默认 XML，优先级高于队列的回调格式;是否必传：否;
@property (nonatomic,strong)NSString * CallBackFormat;

/// 任务回调类型，Url 或 TDMQ，默认 Url，优先级高于队列的回调类型;是否必传：否;
@property (nonatomic,strong)NSString * CallBackType;

/// 任务回调地址，优先级高于队列的回调地址。设置为 no 时，表示队列的回调地址不产生回调;是否必传：否;
@property (nonatomic,strong)NSString * CallBack;

/// 任务回调TDMQ配置，当 CallBackType 为 TDMQ 时必填。详情见 CallBackMqConfig;是否必传：否;
@property (nonatomic,strong)QCloudCallBackMqConfig * CallBackMqConfig;

@end

@interface QCloudInputExtractNumMarkInput : NSObject 

/// 文件路径;是否必传：是;
@property (nonatomic,strong)NSString * Object;

@end

@interface QCloudInputExtractNumMarkOperation : NSObject 

/// 提取数字水印配置;是否必传：是;
@property (nonatomic,strong)QCloudInputExtractNumMarkDigitalWatermark * ExtractDigitalWatermark;

/// 任务优先级，级别限制：0 、1 、2 。级别越大任务优先级越高，默认为0;是否必传：否;
@property (nonatomic,strong)NSString * JobLevel;

/// 透传用户信息, 可打印的 ASCII 码, 长度不超过1024;是否必传：否;
@property (nonatomic,strong)NSString * UserData;

@end

@interface QCloudInputExtractNumMarkDigitalWatermark : NSObject

/// 水印类型;是否必传：是;;限制：Text;
@property (nonatomic,strong)NSString * Type;

/// 水印版本;是否必传：是;;限制：V1;
@property (nonatomic,strong)NSString * Version;

@end

NS_ASSUME_NONNULL_END
