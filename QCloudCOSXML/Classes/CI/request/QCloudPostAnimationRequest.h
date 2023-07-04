//
// QCloudPostAnimationRequest.h
//
//  Created by tencent
//  Copyright (c) 2020年 tencent. All rights reserved.

#import <Foundation/Foundation.h>
#import <QCloudCore/QCloudCore.h>

#import "QCloudPostAnimation.h"

NS_ASSUME_NONNULL_BEGIN

/**
 视频转动图

 提交一个动图任务。

 查看更多：https://cloud.tencent.com/document/product/460/84784

 ### 示例

 @code

     QCloudPostAnimationRequest * request = [QCloudPostAnimationRequest new];
     // 存储桶名称，格式为 BucketName-APPID
     request.bucket = @"examplebucket-1250000000";
     // 文件所在地域
     request.regionName = @"regionName";

     
     QCloudInputPostAnimation * input = QCloudInputPostAnimation.new;
     input.Input = QCloudInputPostAnimationInput.new;
     input.Input.Object = @"test.m3u8";
     
     input.Operation = QCloudInputPostAnimationOperation.new;
     
     input.Operation.TemplateId = @"TemplateId";
     input.Operation.Output = QCloudInputPostAnimationOperationOutput.new;
     input.Operation.Output.Region = @"regionName";
     input.Operation.Output.Bucket = @"sample-125000000";
     input.Operation.Output.Object = @"test";
     request.input = input;
     
     [request setFinishBlock:^(QCloudPostAnimation * _Nullable result, NSError * _Nullable error) {
        // result 视频转动图 ，详细字段请查看 API 文档或者 SDK 源码
     }];
     
     [[QCloudCOSXMLService defaultCOSXML]PostAnimation:request];

 */

@interface QCloudPostAnimationRequest : QCloudBizHTTPRequest

/// 存储桶名称
@property (nonatomic,strong)NSString * bucket;

/// 请求输入参数
@property (nonatomic,strong)QCloudInputPostAnimation * input;

- (void)setFinishBlock:(void (^_Nullable)(QCloudPostAnimation * _Nullable result, NSError *_Nullable error))finishBlock;

@end

NS_ASSUME_NONNULL_END

