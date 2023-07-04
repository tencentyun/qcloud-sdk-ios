//
// QCloudPostTranscodeRequest.h
//
//  Created by tencent
//  Copyright (c) 2020年 tencent. All rights reserved.

#import <Foundation/Foundation.h>
#import <QCloudCore/QCloudCore.h>

#import "QCloudPostTranscode.h"

NS_ASSUME_NONNULL_BEGIN

/**
 音视频转码

 提交一个转码任务。

 查看更多：https://cloud.tencent.com/document/product/460/84790

 ### 示例

 @code

     QCloudPostTranscodeRequest * request = [QCloudPostTranscodeRequest new];
     request.bucket = @"sample-125000000";
     request.regionName = @"regionName";
     
     QCloudInputPostTranscode * input = QCloudInputPostTranscode.new;
     input.Input = QCloudInputPostTranscodeInput.new;
     input.Input.Object = @"test.m3u8";
     
     input.Operation = QCloudInputPostTranscodeOperation.new;
     
     input.Operation.TemplateId = @"TemplateId";
     input.Operation.Output = QCloudInputPostTranscodeOutput.new;
     input.Operation.Output.Region = @"regionName";
     input.Operation.Output.Bucket = @"sample-125000000";
     input.Operation.Output.Object = @"test";
     request.input = input;
     
     [request setFinishBlock:^(QCloudPostTranscode * _Nullable result, NSError * _Nullable error) {
        // result 音视频转码 ，详细字段请查看 API 文档或者 SDK 源码
     }];
     
     [[QCloudCOSXMLService defaultCOSXML]PostTranscode:request];

 */

@interface QCloudPostTranscodeRequest : QCloudBizHTTPRequest

/// 存储桶名称
@property (nonatomic,strong)NSString * bucket;

/// 请求输入参数
@property (nonatomic,strong)QCloudInputPostTranscode * input;

- (void)setFinishBlock:(void (^_Nullable)(QCloudPostTranscode * _Nullable result, NSError *_Nullable error))finishBlock;

@end

NS_ASSUME_NONNULL_END
