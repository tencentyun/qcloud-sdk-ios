//
//  UploadPartCopy.h
//  UploadPartCopy
//
//  Created by tencent
//  Copyright (c) 2015年 tencent. All rights reserved.
//
//   ██████╗  ██████╗██╗      ██████╗ ██╗   ██╗██████╗     ████████╗███████╗██████╗ ███╗   ███╗██╗███╗   ██╗ █████╗ ██╗         ██╗      █████╗ ██████╗
//  ██╔═══██╗██╔════╝██║     ██╔═══██╗██║   ██║██╔══██╗    ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║████╗  ██║██╔══██╗██║         ██║     ██╔══██╗██╔══██╗
//  ██║   ██║██║     ██║     ██║   ██║██║   ██║██║  ██║       ██║   █████╗  ██████╔╝██╔████╔██║██║██╔██╗ ██║███████║██║         ██║     ███████║██████╔╝
//  ██║▄▄ ██║██║     ██║     ██║   ██║██║   ██║██║  ██║       ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║██║╚██╗██║██╔══██║██║         ██║     ██╔══██║██╔══██╗
//  ╚██████╔╝╚██████╗███████╗╚██████╔╝╚██████╔╝██████╔╝       ██║   ███████╗██║  ██║██║ ╚═╝ ██║██║██║ ╚████║██║  ██║███████╗    ███████╗██║  ██║██████╔╝
//   ╚══▀▀═╝  ╚═════╝╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝        ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝    ╚══════╝╚═╝  ╚═╝╚═════╝
//
//
//                                                                              _             __                 _                _
//                                                                             (_)           / _|               | |              | |
//                                                          ___  ___ _ ____   ___  ___ ___  | |_ ___  _ __    __| | _____   _____| | ___  _ __   ___ _ __ ___
//                                                         / __|/ _ \ '__\ \ / / |/ __/ _ \ |  _/ _ \| '__|  / _` |/ _ \ \ / / _ \ |/ _ \| '_ \ / _ \ '__/ __|
//                                                         \__ \  __/ |   \ V /| | (_|  __/ | || (_) | |    | (_| |  __/\ V /  __/ | (_) | |_) |  __/ |  \__
//                                                         |___/\___|_|    \_/ |_|\___\___| |_| \___/|_|     \__,_|\___| \_/ \___|_|\___/| .__/ \___|_|  |___/
//    ______ ______ ______ ______ ______ ______ ______ ______                                                                            | |
//   |______|______|______|______|______|______|______|______|                                                                           |_|
//



#import <Foundation/Foundation.h>
#import <QCloudCore/QCloudCore.h>
#import "QCloudCopyObjectResult.h"
NS_ASSUME_NONNULL_BEGIN
/**
    存储桶名称
    */
@interface QCloudUploadPartCopyRequest : QCloudBizHTTPRequest
/**
    存储桶名称
    */
@property (strong, nonatomic) NSString *bucket;
/**
    对象名
    */
@property (strong, nonatomic) NSString *object;
/**
    在初始化分块上传的响应中，会返回一个唯一的描述符（upload ID）
    */
@property (strong, nonatomic) NSString *uploadID;
/**
    标志当前分块的序号
    */
@property (assign, nonatomic) int64_t partNumber;
/**
    源文件 URL 路径，可以通过 versionid 子资源指定历史版本
    */
@property (strong, nonatomic) NSString *source;
/**
    源文件的字节范围，范围值必须使用 bytes=first-last 格式，first 和 last 都是基于 0 开始的偏移量。
    例如 bytes=0-9 表示你希望拷贝源文件的开头10个字节的数据，如果不指定，则表示拷贝整个文件。
    */
@property (strong, nonatomic) NSString *sourceRange;
/**
    当 Object 在指定时间后被修改，则执行操作，否则返回 412。
    可与 x-cos-copy-source-If-None-Match 一起使用，与其他条件联合使用返回冲突。
    */
@property (strong, nonatomic) NSString *sourceIfModifiedSince;
/**
    当 Object 在指定时间后未被修改，则执行操作，否则返回 412。
    可与 x-cos-copy-source-If-Match 一起使用，与其他条件联合使用返回冲突。
    */
@property (strong, nonatomic) NSString *sourceIfUnmodifiedSince;
/**
    当 Object 的 Etag 和给定一致时，则执行操作，否则返回 412。
    可与x-cos-copy-source-If-Unmodified-Since 一起使用，与其他条件联合使用返回冲突。
    */
@property (strong, nonatomic) NSString *sourceIfMatch;
/**
    当 Object 的 Etag 和给定不一致时，则执行操作，否则返回 412。
    可与 x-cos-copy-source-If-Modified-Since 一起使用，与其他条件联合使用返回冲突。
    */
@property (strong, nonatomic) NSString *sourceIfNoneMatch;
/**
    指定源文件的版本号
    */
@property (strong, nonatomic) NSString *versionID;


- (void) setFinishBlock:(void (^)(QCloudCopyObjectResult* result, NSError * error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
