//
// QCloudGetListWorkflowRequest.h
//
//  Created by tencent
//  Copyright (c) 2020年 tencent. All rights reserved.

#import <Foundation/Foundation.h>
#import <QCloudCore/QCloudCore.h>
#import "QCloudTriggerWorkflow.h"
NS_ASSUME_NONNULL_BEGIN

/**
 查询工作流
 
 查询工作流。
 具体请查看：https://cloud.tencent.com/document/product/460/76857

 @code
 
    QCloudGetListWorkflowRequest * request = [QCloudGetListWorkflowRequest new];

    // 存储桶名称，格式为 BucketName-APPID
    request.bucket = @"examplebucket-1250000000";
    // 文件所在地域
    request.regionName = @"regionName";

    // 工作流 ID，以,符号分割字符串
    request.ids = @"ids";
    // 工作流名称
    request.name = @"name";

    [request setFinishBlock:^(QCloudListWorkflow * _Nullable result, NSError * _Nullable error) {
        // result 查询工作流 ，详细字段请查看 API 文档或者 SDK 源码
    }];
    [QCloudCOSXMLService.defaultCOSXML GetListWorkflow:request];

*/

@interface QCloudGetListWorkflowRequest : QCloudBizHTTPRequest

/// 工作流 ID，以,符号分割字符串
@property (nonatomic,strong)NSString * ids;

/// 工作流名称
@property (nonatomic,strong)NSString * name;

/// 第几页
@property (nonatomic,strong)NSString * pageNumber;

/// 每页个数
@property (nonatomic,strong)NSString * pageSize;

@property (nonatomic,strong)NSString * bucket;

- (void)setFinishBlock:(void (^_Nullable)(QCloudListWorkflow * _Nullable result, NSError *_Nullable error))finishBlock;

@end

NS_ASSUME_NONNULL_END
