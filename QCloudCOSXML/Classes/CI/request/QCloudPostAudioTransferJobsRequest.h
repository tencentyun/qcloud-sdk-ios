//
// QCloudPostAudioTransferJobsRequest.h
//
//  Created by tencent
//  Copyright (c) 2020年 tencent. All rights reserved.

#import <Foundation/Foundation.h>
#import <QCloudCore/QCloudCore.h>

#import "QCloudPostAudioTransferJobs.h"

NS_ASSUME_NONNULL_BEGIN

/**
 音视频转封装

 提交一个转封装任务。

 查看更多：https://cloud.tencent.com/document/product/460/84789

 ### 示例

 @code

    QCloudPostAudioTransferJobsRequest * request = [QCloudPostAudioTransferJobsRequest new];
    // 存储桶名称，格式为 BucketName-APPID
    request.bucket = @"examplebucket-1250000000";
    // 文件所在地域
    request.regionName = @"regionName";

    // 音视频转封装输入参数，具体请查看sdk注释或api文档
    QCloudInputPostAudioTransferJobs * input = QCloudInputPostAudioTransferJobs.new;
    input.Input = QCloudInputPostAudioTransferJobsInput.new;
    input.Input.Object = @"test.mp4";
    input.Operation = QCloudInputPostAudioTransferOperation.new;
    input.Operation.Segment = QCloudInputPostAudioTransferSegment.new;
    input.Operation.Segment.Format = @"mp4";

    input.Operation.Output = QCloudInputPostAudioTransferOutput.new;
    input.Operation.Output.Region = @"ap-guangzhou";
    input.Operation.Output.Bucket = @"sample-125000000";
    input.Operation.Output.Object = @"test1.mp4";

    request.input = input;

    [request setFinishBlock:^(QCloudPostAudioTransferJobs * _Nullable result, NSError * _Nullable error) {
        // result 音视频转封装 ，详细字段请查看 API 文档或者 SDK 源码
    }];
    [[QCloudCOSXMLService defaultCOSXML]PostAudioTransferJobs:request];

 */

@interface QCloudPostAudioTransferJobsRequest : QCloudBizHTTPRequest

@property (nonatomic,strong)NSString * bucket;

@property (nonatomic,strong)QCloudInputPostAudioTransferJobs * input;

- (void)setFinishBlock:(void (^_Nullable)(QCloudPostAudioTransferJobs * _Nullable result, NSError *_Nullable error))finishBlock;

@end

NS_ASSUME_NONNULL_END

