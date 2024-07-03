//
//  QCloudCreateFileZipProcessJobsResponse.h
//  QCloudCreateFileZipProcessJobsResponse
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

@class QCloudCreateFileZipProcessJobsOperation;
@interface QCloudCreateFileZipProcessJobsResponse : NSObject 

/// 任务的详细信息。
@property (nonatomic,strong)NSArray <QCloudCreateFileZipProcessJobsResponseJobsDetail * > * JobsDetail;

@end

@interface QCloudCreateFileZipProcessJobs : NSObject 

/// 表示任务的类型，多文件打��压缩默认为：FileCompress。;是否必传：是
@property (nonatomic,strong) NSString * Tag;

/// 包含文件打包压缩的处理规则。;是否必传：是
@property (nonatomic,strong) QCloudCreateFileZipProcessJobsOperation * Operation;

/// 任务回调格式，JSON 或 XML，默认 XML，优先级高于队列的回调格式。;是否必传：否
@property (nonatomic,strong) NSString * CallBackFormat;

/// 任务回调类型，Url 或 TDMQ，默认 Url，优先级高于队列的回调类型。;是否必传：否
@property (nonatomic,strong) NSString * CallBackType;

/// 任务回调的地址，优先级高于队列的回调地址。;是否必传：否
@property (nonatomic,strong) NSString * CallBack;

/// 任务回调 TDMQ 配置，当 CallBackType 为 TDMQ 时必填。详情请参见 CallBackMqConfig。;是否必传：否
@property (nonatomic,strong) QCloudCallBackMqConfig * CallBackMqConfig;

@end

@interface QCloudCreateFileZipProcessJobsOperation : NSObject 

/// 指定文件打包压缩的处理规则。;是否必传：是
@property (nonatomic,strong) QCloudFileCompressConfig * FileCompressConfig;

/// 透传用户信息，可打印的 ASCII 码，长度不超过1024。;是否必传：否
@property (nonatomic,strong) NSString * UserData;

/// 指定打包压缩后的文件保存的地址信息。;是否必传：是
@property (nonatomic,strong) QCloudCreateFileZipProcessJobsOutput * Output;

@end



NS_ASSUME_NONNULL_END
