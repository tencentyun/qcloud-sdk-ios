//
//  QCloudTriggerWorkflow.h 
//  QCloudCOSXML 
// 
//  Created by garenwang on 2023-06-13 02:21:18 +0000. 
// 
#import <Foundation/Foundation.h> 
#import "QCloudWorkflowexecutionResult.h"
 NS_ASSUME_NONNULL_BEGIN

@class QCloudListWorkflow;
@class QCloudMediaWorkflowList;
@interface QCloudListWorkflow : NSObject 

/// 请求的唯一 ID
@property (nonatomic,strong)NSString * RequestId;

/// 工作流总数
@property (nonatomic,assign)NSInteger TotalCount;

/// 当前页数，同请求中的 pageNumber
@property (nonatomic,assign)NSInteger PageNumber;

/// 每页个数，同请求中的 pageSize
@property (nonatomic,assign)NSInteger PageSize;

/// 工作流数组
@property (nonatomic,strong)NSArray <QCloudMediaWorkflowList *> * MediaWorkflowList;

@end

@interface QCloudTriggerWorkflow : NSObject 

/// 请求的唯一 ID
@property (nonatomic,strong)NSString * RequestId;

/// 实例 ID
@property (nonatomic,strong)NSString * InstanceId;

@end

@interface QCloudMediaWorkflowList : NSObject 

/// 工作流名称
@property (nonatomic,strong)NSString * Name;

/// 工作流 ID
@property (nonatomic,strong)NSString * WorkflowId;

/// 创建时间
@property (nonatomic,strong)NSString * CreateTime;

/// 更新时间
@property (nonatomic,strong)NSString * UpdateTime;

/// 拓扑信息
@property (nonatomic,strong)QCloudWorkflowExecutionTopology * Topology;

/// 工作流状态
@property (nonatomic,strong)NSString * State;

@end

NS_ASSUME_NONNULL_END
