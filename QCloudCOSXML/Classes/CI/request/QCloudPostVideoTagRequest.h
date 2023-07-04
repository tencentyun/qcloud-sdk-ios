//
// QCloudPostVideoTagRequest.h
//
//  Created by tencent
//  Copyright (c) 2020年 tencent. All rights reserved.

#import <Foundation/Foundation.h>
#import <QCloudCore/QCloudCore.h>

#import "QCloudPostVideoTagResult.h"

NS_ASSUME_NONNULL_BEGIN

/**
 视频标签

 提交一个视频标签任务。

 查看更多：https://cloud.tencent.com/document/product/460/84779

 ### 示例

 @code

 TODO:
 
    QCloudPostVideoTagRequest * request = [QCloudPostVideoTagRequest new];
    // 存储桶名称，格式为 BucketName-APPID
    request.bucket = @"examplebucket-1250000000";
    // 文件所在地域
    request.regionName = @"regionName";
    // 视频标签输入参数，具体请查看sdk注释或api文档
    QCloudPostVideoTag * input = QCloudPostVideoTag.new;
    input.Input = QCloudPostVideoTagInput.new;
    input.Input.Object = @"test.m3u8";

    input.Operation = QCloudPostVideoTagOperation.new;
    input.Operation.VideoTag = QCloudPostVideoTagVideoTag.new;
    input.Operation.VideoTag.Scenario = @"Stream";

    request.input = input;

    [request setFinishBlock:^(QCloudPostVideoTagResult * _Nullable result, NSError * _Nullable error) {
        // result 音视频转封装 ，详细字段请查看 API 文档或者 SDK 源码
    }];
    [[QCloudCOSXMLService defaultCOSXML]PostVideoTag:request];

 */

@interface QCloudPostVideoTagRequest : QCloudBizHTTPRequest


/// 存储桶名称
@property (nonatomic,strong)NSString * bucket;

/// 请求参数
@property (nonatomic,strong)QCloudPostVideoTag * input;

- (void)setFinishBlock:(void (^_Nullable)(QCloudPostVideoTagResult * _Nullable result, NSError *_Nullable error))finishBlock;

@end

NS_ASSUME_NONNULL_END

