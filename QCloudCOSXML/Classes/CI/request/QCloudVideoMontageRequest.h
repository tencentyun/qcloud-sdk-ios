//
// QCloudVideoMontageRequest.h
//
//  Created by tencent
//  Copyright (c) 2020年 tencent. All rights reserved.

#import <Foundation/Foundation.h>
#import <QCloudCore/QCloudCore.h>

#import "QCloudVideoMontage.h"

NS_ASSUME_NONNULL_BEGIN

/**
 精彩集锦

 提交一个精彩集锦任务。

 查看更多：https://cloud.tencent.com/document/product/460/84778

 ### 示例

 @code

     QCloudVideoMontageRequest * request = [QCloudVideoMontageRequest new];
     // 存储桶名称，格式为 BucketName-APPID
     request.bucket = @"examplebucket-1250000000";
     // 文件所在地域
     request.regionName = @"regionName";

     
     QCloudInputVideoMontage * input = QCloudInputVideoMontage.new;
     input.Input = QCloudInputVideoMontageInput.new;
     input.Input.Object = @"test.m3u8";
     
     input.Operation = QCloudInputVideoMontageOperation.new;
     input.Operation.VideoMontage = QCloudInputVideoMontageVideoMontage.new;
     
     input.Operation.TemplateId = @"TemplateId";
     input.Operation.Output = QCloudInputVideoMontageOutput.new;
     input.Operation.Output.Region = @regionName;
     input.Operation.Output.Bucket = @"sample-125000000";
     input.Operation.Output.Object = @"test";
     request.input = input;
     
     [request setFinishBlock:^(QCloudVideoMontage * _Nullable result, NSError * _Nullable error) {
        // result 精彩集锦 ，详细字段请查看 API 文档或者 SDK 源码
     }];
     
     [[QCloudCOSXMLService defaultCOSXML]PostVideoMontage:request];

 */

@interface QCloudVideoMontageRequest : QCloudBizHTTPRequest

/// 存储桶名称
@property (nonatomic,strong)NSString * bucket;

/// 请求输入参数
@property (nonatomic,strong)QCloudInputVideoMontage * input;

- (void)setFinishBlock:(void (^_Nullable)(QCloudVideoMontage * _Nullable result, NSError *_Nullable error))finishBlock;

@end

NS_ASSUME_NONNULL_END

