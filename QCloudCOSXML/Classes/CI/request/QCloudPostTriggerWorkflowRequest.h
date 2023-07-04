//
// QCloudPostTriggerWorkflowRequest.h
//
//  Created by tencent
//  Copyright (c) 2020年 tencent. All rights reserved.

#import <Foundation/Foundation.h>
#import <QCloudCore/QCloudCore.h>
#import "QCloudTriggerWorkflow.h"
NS_ASSUME_NONNULL_BEGIN

/**
 测试工作流

 测试工作流。

 查看更多：https://cloud.tencent.com/document/product/460/76864

 ### 示例
 
    QCloudPostTriggerWorkflowRequest * request = [QCloudPostTriggerWorkflowRequest new];
    // 存储桶名称，格式为 BucketName-APPID
    request.bucket = @"examplebucket-1250000000";
    // 地域
    request.regionName = @"regionName";
    // 需要触发的工作流 ID
    request.workflowId = @"workflowId";
    // 需要进行工作流处理的对象名称
    request.object = @"object";
    [request setFinishBlock:^(QCloudTriggerWorkflow * _Nullable result, NSError * _Nullable error) {
        // result 测试工作流 ，详细字段请查看 API 文档或者 SDK 源码
    }];
    [[QCloudCOSXMLService defaultCOSXML] PostTriggerWorkflow:request];

 @code

 TODO:

 */

@interface QCloudPostTriggerWorkflowRequest : QCloudBizHTTPRequest

/// 需要触发的工作流 ID
@property (nonatomic,strong)NSString * workflowId;

/// 需要进行工作流处理的对象名称
@property (nonatomic,strong)NSString * object;

/// 存量触发任务名称，支持中文、英文、数字、—和_，长度限制128字符，默认为空
@property (nonatomic,strong)NSString * name;

@property (nonatomic,strong)NSString * bucket;

- (void)setFinishBlock:(void (^_Nullable)(QCloudTriggerWorkflow * _Nullable result, NSError *_Nullable error))finishBlock;

@end

NS_ASSUME_NONNULL_END

