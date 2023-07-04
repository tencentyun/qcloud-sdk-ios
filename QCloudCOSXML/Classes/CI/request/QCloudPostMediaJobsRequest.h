//
// QCloudPostMediaJobsRequest.h
//
//  Created by tencent
//  Copyright (c) 2020年 tencent. All rights reserved.

#import <Foundation/Foundation.h>
#import <QCloudCore/QCloudCore.h>
#import "QCloudMediaJobs.h"
#import "QCloudWordsGeneralizeInput.h"
NS_ASSUME_NONNULL_BEGIN

/**
 获取媒体信息任务

 提交一个获取媒体信息任务。

 查看更多：https://cloud.tencent.com/document/product/460/84776

 ### 示例

 @code

    QCloudPostMediaJobsRequest * request = [QCloudPostMediaJobsRequest new];
    // 存储桶名称，格式为 BucketName-APPID
    request.bucket = @"examplebucket-1250000000";
    // 文件所在地域
    request.regionName = @"regionName";
    // 获取媒体信息任务输入参数，具体请查看sdk注释或api文档
    QCloudMediaJobsInput * input = QCloudMediaJobsInput.new;
    input.Input = QCloudMediaJobsInputInput.new;
    input.Input.Object = @"test.m3u8";
    request.input = input;

    [request setFinishBlock:^(QCloudMediaJobs * _Nullable result, NSError * _Nullable error) {
        // result 获取媒体信息 ，详细字段请查看 API 文档或者 SDK 源码
    }];
    [[QCloudCOSXMLService defaultCOSXML]PostMediaJobs:request];

 */

@interface QCloudPostMediaJobsRequest : QCloudBizHTTPRequest

@property (nonatomic,strong)NSString * bucket;

@property (nonatomic,strong)QCloudMediaJobsInput * input;

- (void)setFinishBlock:(void (^_Nullable)(QCloudMediaJobs * _Nullable result, NSError *_Nullable error))finishBlock;

@end




NS_ASSUME_NONNULL_END

