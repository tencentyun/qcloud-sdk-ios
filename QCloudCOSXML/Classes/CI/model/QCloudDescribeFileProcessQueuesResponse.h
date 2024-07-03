//
//  QCloudDescribeFileProcessQueuesResponse.h
//  QCloudDescribeFileProcessQueuesResponse
//
//  Created by tencent
//  Copyright (c) 2015年 tencent. All rights reserved.
//
//   ██████╗  ██████╗██╗      ██████╗ ██╗   ██╗██████╗     ████████╗███████╗██████╗ ███╗   ███╗██╗███╗   ██╗ █████╗ ██╗         ██╗      █████╗
//   ██████╗
//  ██╔═══██╗██╔════╝██║     ██╔═══██╗██║   ██║██╔══██╗    ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║████╗  ██║██╔══██╗██║         ██║ ██╔══██╗██╔══██╗
//  ██║   ██║██║     ██║     ██║   ██║██║   ██║██║  ██║       ██║   █████╗  ██████╔╝██╔████╔██║██║██╔██╗ ██║███████║██║         ██║ ███████║██████╔╝
//  ██║▄▄ ██║██║     ██║     ██║   ██║██║   ██║██║  ██║       ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║██║╚██╗██║██╔══██║██║         ██║ ██╔══██║██╔══██╗
//  ╚██████╔╝╚██████╗███████╗╚██████╔╝╚██████╔╝██████╔╝       ██║   ███████╗██║  ██║██║ ╚═╝ ██║██║██║ ╚████║██║  ██║███████╗    ███████╗██║
//  ██║██████╔╝
//   ╚══▀▀═╝  ╚═════╝╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝        ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝    ╚══════╝╚═╝ ╚═╝╚═════╝
//
//
//                                                                              _             __                 _                _
//                                                                             (_)           / _|               | |              | |
//                                                          ___  ___ _ ____   ___  ___ ___  | |_ ___  _ __    __| | _____   _____| | ___  _ __   ___ _
//                                                          __ ___
//                                                         / __|/ _ \ '__\ \ / / |/ __/ _ \ |  _/ _ \| '__|  / _` |/ _ \ \ / / _ \ |/ _ \| '_ \ / _ \
//                                                         '__/ __|
//                                                         \__ \  __/ |   \ V /| | (_|  __/ | || (_) | |    | (_| |  __/\ V /  __/ | (_) | |_) |  __/
//                                                         |  \__
//                                                         |___/\___|_|    \_/ |_|\___\___| |_| \___/|_|     \__,_|\___| \_/ \___|_|\___/| .__/
//                                                         \___|_|  |___/
//    ______ ______ ______ ______ ______ ______ ______ ______                                                                            | |
//   |______|______|______|______|______|______|______|______|                                                                           |_|
//

#import <Foundation/Foundation.h>
#import <QCloudCore/QCloudCore.h>
#import "QCloudCICommonModel.h"

NS_ASSUME_NONNULL_BEGIN

@class QCloudDescribeFileProcessQueuesResponseQueueList;
@class QCloudDescribeFileProcessQueuesResponseNotifyConfig;
@interface QCloudDescribeFileProcessQueuesResponse : NSObject 

/// 请求的唯一 ID
@property (nonatomic,strong) NSString * RequestId;

/// 队列总数
@property (nonatomic,assign) NSInteger TotalCount;

/// 当前页数，同请求中的 pageNumber
@property (nonatomic,assign) NSInteger PageNumber;

/// 每页个数，同请求中的 pageSize
@property (nonatomic,assign) NSInteger PageSize;

/// 队列数组
@property (nonatomic,strong)NSArray <QCloudDescribeFileProcessQueuesResponseQueueList * > * QueueList;

/// 不存在的队列 ID 列表
@property (nonatomic,strong) NSString * NonExistPIDs;

@end

@interface QCloudDescribeFileProcessQueuesResponseQueueList : NSObject 

/// 队列 ID
@property (nonatomic,strong) NSString * QueueId;

/// 队列名字
@property (nonatomic,strong) NSString * Name;

/// 当前状态，Active 或者 Paused
@property (nonatomic,strong) NSString * State;

/// 回调配置
@property (nonatomic,strong) QCloudDescribeFileProcessQueuesResponseNotifyConfig * NotifyConfig;

/// 队列最大长度
@property (nonatomic,assign) NSInteger MaxSize;

/// 当前队列最大并行执行的任务数
@property (nonatomic,assign) NSInteger MaxConcurrent;

/// 队列类型
@property (nonatomic,strong) NSString * Category;

/// 更新时间
@property (nonatomic,strong) NSString * UpdateTime;

/// 创建时间
@property (nonatomic,strong) NSString * CreateTime;

@end

@interface QCloudDescribeFileProcessQueuesResponseNotifyConfig : NSObject 

/// 回调地址
@property (nonatomic,strong) NSString * Url;

/// 开关状态
@property (nonatomic,strong) NSString * State;

/// 回调类型
@property (nonatomic,strong) NSString * Type;

/// 回调事件
@property (nonatomic,strong) NSString * Event;

/// 回调类型
@property (nonatomic,strong) NSString * ResultFormat;

/// TDMQ 使用模式
@property (nonatomic,strong) NSString * MqMode;

/// TDMQ 所属园区
@property (nonatomic,strong) NSString * MqRegion;

/// TDMQ 主题名称
@property (nonatomic,strong) NSString * MqName;

@end



NS_ASSUME_NONNULL_END
