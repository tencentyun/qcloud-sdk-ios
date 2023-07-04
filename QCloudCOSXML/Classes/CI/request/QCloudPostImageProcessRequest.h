//
// QCloudPostImageProcessRequest.h
//
//  Created by tencent
//  Copyright (c) 2020年 tencent. All rights reserved.

#import <Foundation/Foundation.h>
#import <QCloudCore/QCloudCore.h>

#import "QCloudPostImageProcess.h"

NS_ASSUME_NONNULL_BEGIN

/**
 图片处理

 提交一个图片处理任务。

 查看更多：https://cloud.tencent.com/document/product/460/84793

 ### 示例

 @code

    QCloudPostImageProcessRequest * request = [QCloudPostImageProcessRequest new];
    // 存储桶名称，格式为 BucketName-APPID
    request.bucket = @"examplebucket-1250000000";
    // 文件所在地域
    request.regionName = @"regionName";
    // 图片处理输入参数，具体字段请查看sdk注释或api文档
    QCloudInputPostImageProcess * input = QCloudInputPostImageProcess.new;
    input.Input = QCloudInputPostImageProcessInput.new;
    input.Input.Object = @"test.mp4";

    input.Operation = QCloudInputPostImageProcessOperation.new;
    input.Operation.Output = QCloudInputPostImageProcessOutput.new;
    input.Operation.Output.Region = @"Region";
    input.Operation.Output.Bucket = @"sample-125000000";
    input.Operation.Output.Object = @"test1.mp4";
    input.Operation.TemplateId = @"TemplateId";
    request.input = input;

    [request setFinishBlock:^(QCloudPostImageProcess * _Nullable result, NSError * _Nullable error) {
        // result 图片处理 ，详细字段请查看 API 文档或者 SDK 源码
    }];
    [[QCloudCOSXMLService defaultCOSXML]PostImageProcess:request];

 */

@interface QCloudPostImageProcessRequest : QCloudBizHTTPRequest

@property (nonatomic,strong)NSString * bucket;
@property (nonatomic,strong)QCloudInputPostImageProcess * input;
- (void)setFinishBlock:(void (^_Nullable)(QCloudPostImageProcess * _Nullable result, NSError *_Nullable error))finishBlock;

@end

NS_ASSUME_NONNULL_END

