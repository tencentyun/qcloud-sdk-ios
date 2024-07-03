//
//  QCloudCreateHashProcessJobsResponse.h
//  QCloudCreateHashProcessJobsResponse
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
#import <QCloudCore/QCloudCore.h>
#import "QCloudCICommonModel.h"

NS_ASSUME_NONNULL_BEGIN

@class QCloudCreateHashProcessJobsResponseFileHashCodeResult;
@class QCloudCreateHashProcessJobsResponseInput;
@interface QCloudCreateHashProcessJobsResponse : NSObject 

/// 文件哈希值的结果。
@property (nonatomic,strong) QCloudCreateHashProcessJobsResponseFileHashCodeResult * FileHashCodeResult;

/// 输入文件的基本信息。
@property (nonatomic,strong) QCloudCreateHashProcessJobsResponseInput * Input;

@end

@interface QCloudCreateHashProcessJobsResponseFileHashCodeResult : NSObject 

/// 请求时type为 md5 时返回
@property (nonatomic,strong) NSString * MD5;

/// 请求时type为 sha1 时返回
@property (nonatomic,strong) NSString * SHA1;

/// 请求时type为 sha256 时返回
@property (nonatomic,strong) NSString * SHA256;

/// 文件的大小
@property (nonatomic,assign) NSInteger FileSize;

/// 对象的最近一次修改的时间
@property (nonatomic,strong) NSString * LastModified;

/// ETag 全称为 Entity Tag，是对象被创建时标识对象内容的信息标签，可用于检查对象的内容是否发生变化
@property (nonatomic,strong) NSString * Etag;

@end

@interface QCloudCreateHashProcessJobsResponseInput : NSObject 

/// 存储桶所在地域
@property (nonatomic,strong) NSString * Region;

/// 输入文件所在的存储桶
@property (nonatomic,strong) NSString * Bucket;

/// 输入文件在存储桶中的名称
@property (nonatomic,strong) NSString * Object;

@end



NS_ASSUME_NONNULL_END
