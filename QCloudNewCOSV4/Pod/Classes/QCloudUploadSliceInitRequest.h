//
//  UploadSliceInit.h
//  UploadSliceInit
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
#import "QCloudUploadSliceInitResult.h"
@class QCloudSHAPart;
NS_ASSUME_NONNULL_BEGIN
@interface QCloudUploadSliceInitRequest : QCloudBizHTTPRequest
/**
存储桶是 COS 中用于存储数据的容器，是用户存储在 Appid 下的第一级目录，每个对象都存储在一个存储桶中。
*/
@property (strong, nonatomic) NSString *bucket;
/**
目录是 COS 中用于存储数据的容器，是用于分级管理资源的有效工具。
*/
@property (strong, nonatomic) NSString *directory;
/**
文件在COS上的文件名
*/
@property (strong, nonatomic) NSString *fileName;
/**
文件大小，要与Finish Slice Upload里的文件大小一致。
*/
@property (assign, nonatomic) int64_t fileSize;
/**
分片大小
*/
@property (assign, nonatomic) int64_t sliceSize;
/**
COS 服务调用方自定义属性
*/
@property (strong, nonatomic) NSString *bizAttribute;
/**
同名文件覆盖选项，有效值：NO--覆盖（删除已有的重名文件，存储新上传的文件），YES---不覆盖（若已存在重名文件，则不做覆盖，返回“上传失败”）。默认为 YES---不覆盖。
*/
@property (assign, nonatomic) BOOL insertOnly;
/**
sha值
*/
@property (strong, nonatomic) NSString *sha;
/**

*/
@property (strong, nonatomic) NSArray<QCloudSHAPart*> *uploadParts;


- (void) setFinishBlock:(void (^)(QCloudUploadSliceInitResult* result, NSError * error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
