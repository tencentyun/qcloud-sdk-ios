//
//  QCloudGetMediaJobRequest.h
//  QCloudGetMediaJobRequest
//
//  Created by tencent
//  Copyright (c) 2015年 tencent. All rights reserved.
//
//   ██████╗  ██████╗██╗      ██████╗ ██╗   ██╗██████╗     ████████╗███████╗██████╗ ███╗   ███╗██╗███╗   ██╗ █████╗ ██╗         ██╗      █████╗
//   ██████╗
//  ██╔═══██╗██╔════╝██║     ██╔═══██╗██║   ██║██╔══██╗    ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║████╗  ██║██╔══██╗██║         ██║ ██╔══██╗██╔══██╗
//  ██║   ██║██║     ██║     ██║   ██║██║   ██║██║  ██║       ██║   █████╗  ██████╔╝██╔████╔██║██║██╔██╗ ██║███████║██║         ██║ ███████║██████╔╝
//  ██║▄▄ ██║██║     ██║     ██║   ██║██║   ██║██║  ██║       ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║██║╚██╗██║██╔══██║██║         ██║ ██╔══██║██╔══██╗
//  ╚██████╔╝╚██████╗███████╗╚██████╔╝╚██████╔╝██████╔╝       ██║   ███████╗██║  ██║██║ ╚═╝ ██║██║██║ ╚████║██║  ██║███████╗    ███████╗██║
//  ██║██████╔╝
//   ╚══▀▀═╝  ╚═════╝╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝        ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝    ╚══════╝╚═╝ ╚═╝╚═════╝
//
//
//                                                                              _             __                 _                _
//                                                                             (_)           / _|               | |              | |
//                                                          ___  ___ _ ____   ___  ___ ___  | |_ ___  _ __    __| | _____   _____| | ___  _ __   ___ _
//                                                          __ ___
//                                                         / __|/ _ \ '__\ \ / / |/ __/ _ \ |  _/ _ \| '__|  / _` |/ _ \ \ / / _ \ |/ _ \| '_ \ / _ \
//                                                         '__/ __|
//                                                         \__ \  __/ |   \ V /| | (_|  __/ | || (_) | |    | (_| |  __/\ V /  __/ | (_) | |_) |  __/
//                                                         |  \__
//                                                         |___/\___|_|    \_/ |_|\___\___| |_| \___/|_|     \__,_|\___| \_/ \___|_|\___/| .__/
//                                                         \___|_|  |___/
//    ______ ______ ______ ______ ______ ______ ______ ______                                                                            | |
//   |______|______|______|______|______|______|______|______|                                                                           |_|
//

#import <Foundation/Foundation.h>
#import <QCloudCore/QCloudBizHTTPRequest.h>
#import "QCloudGetMediaJobResponse.h"

NS_ASSUME_NONNULL_BEGIN
/**

 查询指定任务.

 ### 功能描述

 查询指定的任务.

 具体请查看  https://cloud.tencent.com/document/product/460/84765.

### 示例

  @code

        QCloudGetMediaJobRequest * request = [QCloudGetMediaJobRequest new];
        // 存储桶名称，格式为 BucketName-APPID
        request.bucket = @"examplebucket-1250000000";
        // 文件所在地域
        request.regionName = @"regionName";
        // 对象键，是对象在 COS 上的完整路径，如果带目录的话，格式为 "dir1/object1"
        request.jobId = @"jobId";
        [request setFinishBlock:^(QCloudGetMediaJobResponse * _Nullable result, NSError * _Nullable error) {
            // result 查询指定任务 ，详细字段请查看 API 文档或者 SDK 源码
        }];
        [[QCloudCOSXMLService defaultCOSXML] GetMediaJob:request];
*/

@interface QCloudGetMediaJobRequest : QCloudBizHTTPRequest

/// 存储桶名称
@property (nonatomic,strong)NSString * bucket;


/// jobId 为提交任务时返回的任务Id，支持传多个，以逗号分隔，最多传10个。
@property (nonatomic,strong)NSString * jobId;


- (void)setFinishBlock:(void (^_Nullable)( QCloudGetMediaJobResponse * _Nullable result, NSError *_Nullable error))finishBlock;

@end



NS_ASSUME_NONNULL_END
