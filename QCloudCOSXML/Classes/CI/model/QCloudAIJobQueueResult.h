//
//  QCloudAIJobQueueResult.h
//  QCloudCOSXML
//
//  Created by garenwang on 2022/7/22.
//

#import <Foundation/Foundation.h>

@class QCloudAIJobQueueResultQueueListItem;
@class QCloudAIJobQueueResultNotifyConfig;
@class QCloudAIJobQueueResultNonExistPIDs;
NS_ASSUME_NONNULL_BEGIN

@interface QCloudAIJobQueueResult : NSObject

/// 请求的唯一 ID
@property (nonatomic,strong)NSString *RequestId;

/// 队列总数
@property (nonatomic,assign)NSInteger TotalCount;

/// 当前页数，同请求中的 pageNumber
@property (nonatomic,assign)NSInteger PageNumber;

/// 每页个数，同请求中的 pageSize
@property (nonatomic,assign)NSInteger PageSize;

/// 队列数组
@property (nonatomic,strong)NSArray <QCloudAIJobQueueResultQueueListItem *> *QueueList;

/// 队列 ID
@property (nonatomic,strong)NSArray * NonExistPIDs;

@end


/// 不存在的队列 ID 列表
@interface QCloudAIJobQueueResultNonExistPIDs : NSObject

@property (nonatomic,strong)NSString *QueueID;
@end


@interface QCloudAIJobQueueResultQueueListItem : NSObject

/// 队列 ID
@property (nonatomic,strong)NSString *QueueId;

/// 队列名字
@property (nonatomic,strong)NSString *Name;

/// 当前状态，Active 或者 Paused
@property (nonatomic,strong)NSString *State;

/// 回调配置
@property (nonatomic,strong)QCloudAIJobQueueResultNotifyConfig *NotifyConfig;

/// 队列最大长度
@property (nonatomic,assign)NSInteger MaxSize;

/// 当前队列最大并行执行的任务数
@property (nonatomic,assign)NSInteger MaxConcurrent;

/// 更新时间
@property (nonatomic,strong)NSString *UpdateTime;

/// 创建时间
@property (nonatomic,strong)NSString *CreateTime;


@property (nonatomic,strong)NSString *Category;


@property (nonatomic,strong)NSString *BucketId;

@end

@interface QCloudAIJobQueueResultNotifyConfig : NSObject

/// 回调地址
@property (nonatomic,strong)NSString *Url;

/// 开关状态，On 或者 Off
@property (nonatomic,strong)NSString *State;

/// 回调类型，Url
@property (nonatomic,strong)NSString *Type;

/// 触发回调的事件
@property (nonatomic,strong)NSString *Event;

/// 返回数据格式
@property (nonatomic,strong)NSString *ResultFormat;

@end

@interface QCloudAIJobQueueResultUpdateResult : NSObject

/// 请求的唯一 ID
@property (nonatomic,strong)NSString *RequestId;

/// 队列数组
@property (nonatomic,strong)QCloudAIJobQueueResultQueueListItem *Queue;

@end
NS_ASSUME_NONNULL_END
