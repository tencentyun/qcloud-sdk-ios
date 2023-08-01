//
//  QCloudGetMediaJobListRequest.h
//  QCloudGetMediaJobListRequest
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
#import <QCloudCore/QCloudBizHTTPRequest.h>
#import "QCloudGetMediaJobResponse.h"

NS_ASSUME_NONNULL_BEGIN
/**

 获取符合条件的任务列表.

 ### 功能描述

 获取符合条件的任务列表.

 具体请查看  https://cloud.tencent.com/document/product/460/84766.

### 示例

  @code

     QCloudGetMediaJobListRequest * request = [QCloudGetMediaJobListRequest new];
     // 存储桶名称，格式为 BucketName-APPID
     request.bucket = @"examplebucket-1250000000";
     // 文件所在地域
     request.regionName = @"regionName";
 
     request.queueType = @"queueType";
     [request setFinishBlock:^(QCloudGetMediaJobResponse * _Nullable result, NSError * _Nullable error) {
         // result 查询指定任务 ，详细字段请查看 API 文档或者 SDK 源码
     }];
     [[QCloudCOSXMLService defaultCOSXML] GetMediaJobList:request];

*/

@interface QCloudGetMediaJobListRequest : QCloudBizHTTPRequest

/// 拉取该队列 ID 下的任务
@property (nonatomic,strong)NSString * queueId;

/// 拉取队列类型下的任务，和 queueId 不同时生效，同时存在时 queueId 优先
@property (nonatomic,strong)NSString * queueType;

/// 任务的 Tag
@property (nonatomic,strong)NSString * tag;

/// 触发该任务的工作流ID
@property (nonatomic,strong)NSString * workflowId;

/// 触发该任务的存量触发任务ID
@property (nonatomic,strong)NSString * inventoryTriggerJobId;

/// 该任务的输入文件名，暂仅支持精确匹配
@property (nonatomic,strong)NSString * inputObject;

/// Desc 或者 Asc。默认为 Desc
@property (nonatomic,strong)NSString * orderByTime;

/// 请求的上下文，用于翻页。上次返回的值
@property (nonatomic,strong)NSString * nextToken;

/// 拉取的最大任务数。默认为10。最大为100
@property (nonatomic,strong)NSString * size;

/// 拉取该状态的任务，以,分割，支持多状态：All、Submitted、Running、Success、Failed、Pause、Cancel。默认为 All
@property (nonatomic,strong)NSString * states;

/// 拉取创建时间大于该时间的任务。格式为：%Y-%m-%dT%H:%m:%S%z，示例：2001-01-01T00:00:00+0800
@property (nonatomic,strong)NSString * startCreationTime;

/// 拉取创建时间小于该时间的任务。格式为：%Y-%m-%dT%H:%m:%S%z，示例：2001-01-01T23:59:59+0800
@property (nonatomic,strong)NSString * endCreationTime;

/// 存储桶名称
@property (nonatomic,strong)NSString * bucket;


- (void)setFinishBlock:(void (^_Nullable)( QCloudGetMediaJobResponse * _Nullable result, NSError *_Nullable error))finishBlock;

@end



NS_ASSUME_NONNULL_END
