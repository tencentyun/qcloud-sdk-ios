//
// QCloudExtractNumMarkRequest.h
//
//  Created by tencent
//  Copyright (c) 2020年 tencent. All rights reserved.

#import <Foundation/Foundation.h>
#import <QCloudCore/QCloudCore.h>

#import "QCloudExtractNumMark.h"

NS_ASSUME_NONNULL_BEGIN

/**
 提取数字水印

 提交一个提取数字水印任务。

 查看更多：https://cloud.tencent.com/document/product/460/84786

 ### 示例

 @code

     QCloudExtractNumMarkRequest * request = [QCloudExtractNumMarkRequest new];
     // 存储桶名称，格式为 BucketName-APPID
     request.bucket = @"examplebucket-1250000000";
     // 文件所在地域
     request.regionName = @"regionName";
     // 输入参数，具体请查看sdk注释或api文档
     QCloudInputExtractNumMark * input = QCloudInputExtractNumMark.new;
     input.Input = QCloudInputExtractNumMarkInput.new;
     input.Input.Object = @"test.m3u8";
     input.Operation = QCloudInputExtractNumMarkOperation.new;
     request.input = input;
     [request setFinishBlock:^(QCloudExtractNumMark * _Nullable result, NSError * _Nullable error) {
        // result 音视频转封装 ，详细字段请查看 API 文档或者 SDK 源码
     }];
     [[QCloudCOSXMLService defaultCOSXML]ExtractNumMark:request];


 */

@interface QCloudExtractNumMarkRequest : QCloudBizHTTPRequest

/// 存储桶名称
@property (nonatomic,strong)NSString * bucket;

/// 请求输入参数
@property (nonatomic,strong)QCloudInputExtractNumMark * input;

- (void)setFinishBlock:(void (^_Nullable)(QCloudExtractNumMark * _Nullable result, NSError *_Nullable error))finishBlock;

@end

NS_ASSUME_NONNULL_END
