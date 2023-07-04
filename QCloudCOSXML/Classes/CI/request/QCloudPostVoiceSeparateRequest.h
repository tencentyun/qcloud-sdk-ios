//
// QCloudPostVoiceSeparateRequest.h
//
//  Created by tencent
//  Copyright (c) 2020年 tencent. All rights reserved.

#import <Foundation/Foundation.h>
#import <QCloudCore/QCloudCore.h>

#import "QCloudVoiceSeparateResult.h"

NS_ASSUME_NONNULL_BEGIN

/**
 人声分离

 提交一个人声分离任务。

 查看更多：https://cloud.tencent.com/document/product/460/84794

 ### 示例

 @code

    QCloudPostVoiceSeparateRequest * request = [QCloudPostVoiceSeparateRequest new];
    // 存储桶名称，格式为 BucketName-APPID
    request.bucket = @"examplebucket-1250000000";
    // 文件所在地域
    request.regionName = @"regionName";

    // 人声分离输入参数 具体字段请查看sdk源码注释或API文档
    QCloudInputVoiceSeparate * input = QCloudInputVoiceSeparate.new;
    input.Input = QCloudInputVoiceSeparateInput.new;
    input.Input.Object = @"test.m3u8";

    input.Operation = QCloudInputVoiceSeparateOperation.new;
    input.Operation.TemplateId = @"TemplateId";
    input.Operation.Output = QCloudInputVoiceSeparateOutput.new;
    input.Operation.Output.Region = @"regionName";
    input.Operation.Output.Bucket = @"sample-1250000000";
    input.Operation.Output.Object = @"test";

    // 人声分离输入参数
    request.input = input;

    [request setFinishBlock:^(QCloudVoiceSeparateResult * _Nullable result, NSError * _Nullable error) {
        // result 人声分离 ，详细字段请查看 API 文档或者 SDK 源码
    }];

    [[QCloudCOSXMLService defaultCOSXML]PostVoiceSeparate:request];

 */

@interface QCloudPostVoiceSeparateRequest : QCloudBizHTTPRequest

/// 存储桶名称
@property (nonatomic,strong)NSString * bucket;

/// 请求输入参数
@property (nonatomic,strong)QCloudInputVoiceSeparate * input;

- (void)setFinishBlock:(void (^_Nullable)(QCloudVoiceSeparateResult * _Nullable result, NSError *_Nullable error))finishBlock;

@end

NS_ASSUME_NONNULL_END

