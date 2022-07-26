//
//  QCloudGetAudioDiscernOpenBucketListRequest.h
//  QCloudGetAudioDiscernOpenBucketListRequest
//
//  Created by tencent
//  Copyright (c) 2020年 tencent. All rights reserved.
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
#import <QCloudCore/QCloudCore.h>
#import "QCloudGetAudioOpenBucketListResult.h"
NS_ASSUME_NONNULL_BEGIN

/**
 功能描述：

 接口用于查询存储桶是否已开通语音识别功能。
 具体请查看：https://cloud.tencent.com/document/product/460/46232

  @code
 
        QCloudGetAudioDiscernOpenBucketListRequest * request = [[QCloudGetAudioDiscernOpenBucketListRequest alloc]init];

        // 存储桶名称前缀，前缀搜索
        request.bucketName = @"bucketName";
        
        request.regionName = @"regionName";
        // 地域信息，以“,”分隔字符串，支持 All、ap-shanghai、ap-beijing
        request.regions = @"regions";

        request.finishBlock = ^(QCloudGetAudioOpenBucketListResult * outputObject, NSError *error) {
         // outputObject 详细字段请查看api文档或者SDK源码
         // QCloudGetAudioOpenBucketListResult 类；
        };
        [[QCloudCOSXMLService defaultCOSXML] GetAudioDiscernOpenBucketList:request];

*/
@interface QCloudGetAudioDiscernOpenBucketListRequest : QCloudBizHTTPRequest


/// 地域信息，以“,”分隔字符串，支持 All、ap-shanghai、ap-beijing
@property (strong, nonatomic) NSString *regions;

/// 存储桶名称，以“,”分隔，支持多个存储桶，精确搜索
@property (strong, nonatomic) NSString *bucketNames;

/// 存储桶名称前缀，前缀搜索
@property (strong, nonatomic) NSString *bucketName;

/// 第几页
@property (assign, nonatomic) NSInteger pageNumber;

/// 每页个数
@property (assign, nonatomic) NSInteger pageSize;

/**
 设置完成回调。请求完成后会通过该回调来获取结果，如果没有error，那么可以认为请求成功。
 @param finishBlock 请求完成回调
 */
- (void)setFinishBlock:(void (^_Nullable)(QCloudGetAudioOpenBucketListResult *_Nullable result, NSError *_Nullable error))finishBlock;

@end
NS_ASSUME_NONNULL_END
