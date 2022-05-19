//
//  QCloudGetDescribeMediaBucketsRequest.h
//  QCloudGetDescribeMediaBucketsRequest 
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
@class QCloudDescribeMediaInfo;
NS_ASSUME_NONNULL_BEGIN

/**
 功能描述：

 用于查询已经开通媒体处理功能的存储桶。
 具体请查看：https://cloud.tencent.com/document/product/436/48988

  @code
 
     QCloudGetDescribeMediaBucketsRequest * request = [[QCloudGetDescribeMediaBucketsRequest alloc]init];

     // 地域信息，例如 ap-shanghai、ap-beijing，若查询多个地域以“,”分隔字符串，支持中国大陆地域
     request.regions = regions;
     // 存储桶名称，以“,”分隔，支持多个存储桶，精确搜索
     request.bucketNames = bucketNames;
     // 存储桶名称前缀，前缀搜索
     request.bucketName = bucketName;
     // 第几页
     request.pageNumber = pageNumber;
     // 每页个数
     request.pageSize = pageSize;

     request.finishBlock = ^(QCloudDescribeMediaInfo * outputObject, NSError *error) {
         // outputObject 请求到的媒体信息，详细字段请查看api文档或者SDK源码
         // QCloudDescribeMediaInfo  类；
     };
     [[QCloudCOSXMLService defaultCOSXML] CIGetDescribeMediaBuckets:request];

*/
@interface QCloudGetDescribeMediaBucketsRequest : QCloudBizHTTPRequest



/// 地域信息，例如 ap-shanghai、ap-beijing，若查询多个地域以“,”分隔字符串，支持中国大陆地域
@property (strong, nonatomic) NSArray *regions;

/// 存储桶名称，以“,”分隔，支持多个存储桶，精确搜索
@property (strong, nonatomic) NSArray *bucketNames;

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
- (void)setFinishBlock:(void (^_Nullable)(QCloudDescribeMediaInfo *_Nullable result, NSError *_Nullable error))finishBlock;

@end
NS_ASSUME_NONNULL_END
