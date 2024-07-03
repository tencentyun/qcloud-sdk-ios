//
//  QCloudPostFileUnzipProcessJobResponse.h
//  QCloudPostFileUnzipProcessJobResponse
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

@class QCloudPostFileUnzipProcessJobInput;
@class QCloudPostFileUnzipProcessJobOperation;
@interface QCloudPostFileUnzipProcessJobResponse : NSObject 

/// 任务的详细信息。
@property (nonatomic,strong)NSArray <QCloudPostFileUnzipProcessJobResponseJobsDetail * > * JobsDetail;

@end

@interface QCloudPostFileUnzipProcessJob : NSObject 

/// 表示任务的类型，文件解压默认为：FileUncompress。;是否必传：是
@property (nonatomic,strong) NSString * Tag;

/// 包含待操作的文件信息。;是否必传：是
@property (nonatomic,strong) QCloudPostFileUnzipProcessJobInput * Input;

/// 包含文件解压的处理规则。;是否必传：是
@property (nonatomic,strong) QCloudPostFileUnzipProcessJobOperation * Operation;

/// 任务回调格式，JSON 或 XML，默认 XML，优先级高于队列的回调格式。;是否必传：否
@property (nonatomic,strong) NSString * CallBackFormat;

/// 任务回调类型，Url 或 TDMQ，默认 Url，优先级高于队列的回调类型。;是否必传：否
@property (nonatomic,strong) NSString * CallBackType;

/// 任务回调的地址，优先级高于队列的回调地址。;是否必传：否
@property (nonatomic,strong) NSString * CallBack;

/// 任务回调 TDMQ 配置，当 CallBackType 为 TDMQ 时必填。详情见 CallBackMqConfig。;是否必传：否
@property (nonatomic,strong) QCloudCallBackMqConfig * CallBackMqConfig;

@end

@interface QCloudPostFileUnzipProcessJobInput : NSObject 

/// 文件名，取值为文件在当前存储桶中的完整名称。;是否必传：是
@property (nonatomic,strong) NSString * Object;

@end

@interface QCloudPostFileUnzipProcessJobOperation : NSObject 

/// 指定文件解压的处理规则。;是否必传：是
@property (nonatomic,strong) QCloudFileUncompressConfig * FileUncompressConfig;

/// 透传用户信息，可打印的 ASCII 码，长度不超过1024。;是否必传：否
@property (nonatomic,strong) NSString * UserData;

/// 指定解压后的文件保存的存储桶信息。;是否必传：是
@property (nonatomic,strong) QCloudPostFileUnzipProcessJobOutput * Output;

@property (nonatomic,assign) NSInteger JobLevel;
@end



NS_ASSUME_NONNULL_END
