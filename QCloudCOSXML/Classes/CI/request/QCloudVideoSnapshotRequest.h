//
// QCloudVideoSnapshotRequest.h
//
//  Created by tencent
//  Copyright (c) 2020年 tencent. All rights reserved.

#import <Foundation/Foundation.h>
#import <QCloudCore/QCloudCore.h>

#import "QCloudVideoSnapshot.h"

NS_ASSUME_NONNULL_BEGIN

/**
 视频截图

 提交一个截图任务。

 查看更多：https://cloud.tencent.com/document/product/460/84780

 ### 示例

 @code

     QCloudVideoSnapshotRequest * request = [QCloudVideoSnapshotRequest new];
     // 存储桶名称，格式为 BucketName-APPID
     request.bucket = @"examplebucket-1250000000";
     // 文件所在地域
     request.regionName = @"regionName";
         
     QCloudInputVideoSnapshot * input = QCloudInputVideoSnapshot.new;
     input.Input = QCloudInputVideoSnapshotInput.new;
     input.Input.Object = @"test.m3u8";
     
     input.Operation = QCloudInputVideoSnapshotOperation.new;
     
     input.Operation.TemplateId = @"TemplateId";
     input.Operation.Output = QCloudInputVideoSnapshotOperationOutput.new;
     input.Operation.Output.Region = @"ap-guangzhou";
     input.Operation.Output.Bucket = @"ci-auditing-sample-1253960454";
     input.Operation.Output.Object = @"test";
     request.input = input;
     
     [request setFinishBlock:^(QCloudVideoSnapshot * _Nullable result, NSError * _Nullable error) {
        // result 视频截图 ，详细字段请查看 API 文档或者 SDK 源码
     }];
     
     [[QCloudCOSXMLService defaultCOSXML]PostVideoSnapshot:request];

 */

@interface QCloudVideoSnapshotRequest : QCloudBizHTTPRequest

/// 存储桶名称
@property (nonatomic,strong)NSString * bucket;

/// 请求输入参数
@property (nonatomic,strong)QCloudInputVideoSnapshot * input;

- (void)setFinishBlock:(void (^_Nullable)(QCloudVideoSnapshot * _Nullable result, NSError *_Nullable error))finishBlock;

@end

NS_ASSUME_NONNULL_END

