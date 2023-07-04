//
// QCloudPostConcatRequest.h
//
//  Created by tencent
//  Copyright (c) 2020年 tencent. All rights reserved.

#import <Foundation/Foundation.h>
#import <QCloudCore/QCloudCore.h>

#import "QCloudPostConcat.h"

NS_ASSUME_NONNULL_BEGIN

/**
 音视频拼接

 提交一个拼接任务。

 查看更多：https://cloud.tencent.com/document/product/460/84788

 ### 示例

 @code

     QCloudPostConcatRequest * request = [QCloudPostConcatRequest new];
     // 存储桶名称，格式为 BucketName-APPID
     request.bucket = @"examplebucket-1250000000";
     // 文件所在地域
     request.regionName = @"regionName";
     QCloudInputPostConcat * input = QCloudInputPostConcat.new;
     input.Input = QCloudInputPostConcatInput.new;
     input.Input.Object = @"test.m3u8";
     
     input.Operation = QCloudInputPostConcatOperation.new;
     
     input.Operation.TemplateId = @"TemplateId";
     input.Operation.Output = QCloudInputPostConcatOutput.new;
     input.Operation.Output.Region = @"ap-guangzhou";
     input.Operation.Output.Bucket = @"sample-125000000";
     input.Operation.Output.Object = @"test";
     request.input = input;
     
     [request setFinishBlock:^(QCloudPostConcat * _Nullable result, NSError * _Nullable error) {
        // result 音视频拼接 ，详细字段请查看 API 文档或者 SDK 源码
     }];
     
     [[QCloudCOSXMLService defaultCOSXML]PostConcat:request];

 */

@interface QCloudPostConcatRequest : QCloudBizHTTPRequest

/// 存储桶名称
@property (nonatomic,strong)NSString * bucket;

/// 请求输入参数
@property (nonatomic,strong)QCloudInputPostConcat * input;

- (void)setFinishBlock:(void (^_Nullable)(QCloudPostConcat * _Nullable result, NSError *_Nullable error))finishBlock;

@end

NS_ASSUME_NONNULL_END

