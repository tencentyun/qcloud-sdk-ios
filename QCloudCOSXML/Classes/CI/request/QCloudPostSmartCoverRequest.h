//
// QCloudPostSmartCoverRequest.h
//
//  Created by tencent
//  Copyright (c) 2020年 tencent. All rights reserved.

#import <Foundation/Foundation.h>
#import <QCloudCore/QCloudCore.h>

#import "QCloudPostSmartCover.h"

NS_ASSUME_NONNULL_BEGIN

/**
 智能封面

 提交一个智能封面任务。

 查看更多：https://cloud.tencent.com/document/product/460/84791

 ### 示例

 @code

     QCloudPostSmartCoverRequest * request = [QCloudPostSmartCoverRequest new];
     // 存储桶名称，格式为 BucketName-APPID
     request.bucket = @"examplebucket-1250000000";
     // 文件所在地域
     request.regionName = @"regionName";
     QCloudInputPostSmartCover * input = QCloudInputPostSmartCover.new;
     input.Input = QCloudInputPostSmartCoverInput.new;
     input.Input.Object = @"test.m3u8";
     
     input.Operation = QCloudInputPostSmartCoverOperation.new;
     
     input.Operation.TemplateId = @"TemplateId";
     input.Operation.Output = QCloudInputPostSmartOutput.new;
     input.Operation.Output.Region = @"ap-guangzhou";
     input.Operation.Output.Bucket = @"ci-auditing-sample-1253960454";
     input.Operation.Output.Object = @"test";
     request.input = input;
     
     [request setFinishBlock:^(QCloudPostSmartCover * _Nullable result, NSError * _Nullable error) {
        // result 智能封面 ，详细字段请查看 API 文档或者 SDK 源码
     }];
     
     [[QCloudCOSXMLService defaultCOSXML]PostSmartCover:request];

 */

@interface QCloudPostSmartCoverRequest : QCloudBizHTTPRequest

/// 存储桶名称
@property (nonatomic,strong)NSString * bucket;

/// 请求输入参数
@property (nonatomic,strong)QCloudInputPostSmartCover * input;

- (void)setFinishBlock:(void (^_Nullable)(QCloudPostSmartCover * _Nullable result, NSError *_Nullable error))finishBlock;

@end

NS_ASSUME_NONNULL_END
