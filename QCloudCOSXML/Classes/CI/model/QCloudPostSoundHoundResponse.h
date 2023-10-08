//
//  QCloudPostSoundHoundResponse.h
//  QCloudPostSoundHoundResponse
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

@class QCloudPostSoundHoundResponseJobsDetail;
@class QCloudPostSoundHoundInput;
@class QCloudPostSoundHoundResponseOperation;
@class QCloudPostSoundHoundResponseSoundHoundResult;
@class QCloudPostSoundHoundResponseSongList;
@class QCloudPostSoundHoundOperation;
@interface QCloudPostSoundHoundResponse : NSObject 

/// 任务的详细信息
@property (nonatomic,strong)NSArray <QCloudPostSoundHoundResponseJobsDetail * > * JobsDetail;

@end

@interface QCloudPostSoundHoundResponseJobsDetail : NSObject 

/// 错误码，只有 State 为 Failed 时有意义
@property (nonatomic,strong) NSString * Code;

/// 错误描述，只有 State 为 Failed 时有意义
@property (nonatomic,strong) NSString * Message;

/// 新创建任务的 ID
@property (nonatomic,strong) NSString * JobId;

/// 新创建任务的 Tag：SoundHound
@property (nonatomic,strong) NSString * Tag;

/// 任务状态Submitted：已提交，待执行Running：执行中Success：执行成功Failed：执行失败Pause：任务暂停，当暂停队列时，待执行的任务会变为暂停状态Cancel：任务被取消执行
@property (nonatomic,strong) NSString * State;

/// 任务的创建时间
@property (nonatomic,strong) NSString * CreationTime;

/// 任务的开始时间
@property (nonatomic,strong) NSString * StartTime;

/// 任务的结束时间
@property (nonatomic,strong) NSString * EndTime;

/// 任务所属的 队列 ID﻿
@property (nonatomic,strong) NSString * QueueId;

/// 同请求中的 Request.Input 节点
@property (nonatomic,strong) QCloudPostSoundHoundInput * Input;

/// 该任务的规则
@property (nonatomic,strong) QCloudPostSoundHoundResponseOperation * Operation;

@end

@interface QCloudPostSoundHoundInput : NSObject 

/// 文件路径;是否必传：是
@property (nonatomic,strong) NSString * Object;

@property (nonatomic,strong) NSString * BucketId;

@property (nonatomic,strong) NSString * Region;

@end

@interface QCloudPostSoundHoundResponseOperation : NSObject 

/// 透传用户信息
@property (nonatomic,strong) NSString * UserData;

/// 任务优先级
@property (nonatomic,strong) NSString * JobLevel;

/// 听歌识曲任务结果，没有时不返回
@property (nonatomic,strong) QCloudPostSoundHoundResponseSoundHoundResult * SoundHoundResult;

@end

@interface QCloudPostSoundHoundResponseSoundHoundResult : NSObject 

/// 识别结果详情
@property (nonatomic,strong)NSArray <QCloudPostSoundHoundResponseSongList * > * SongList;

@end

@interface QCloudPostSoundHoundResponseSongList : NSObject 

/// 识别置信度
@property (nonatomic,assign) NSInteger Inlier;

/// 歌手姓名
@property (nonatomic,strong) NSString * SingerName;

/// 歌曲名
@property (nonatomic,strong) NSString * SongName;

@end

@interface QCloudPostSoundHound : NSObject 

/// 创建任务的 Tag：SoundHound;是否必传：是
@property (nonatomic,strong) NSString * Tag;

/// 待操作的对象信息;是否必传：是
@property (nonatomic,strong) QCloudPostSoundHoundInput * Input;

/// 操作规则;是否必传：是
@property (nonatomic,strong) QCloudPostSoundHoundOperation * Operation;

/// 任务回调格式，JSON 或 XML，默认 XML，优先级高于队列的回调格式;是否必传：否
@property (nonatomic,strong) NSString * CallBackFormat;

/// 任务回调类型，Url 或 TDMQ，默认 Url，优先级高于队列的回调类型;是否必传：否
@property (nonatomic,strong) NSString * CallBackType;

/// 任务回调地址，优先级高于队列的回调地址。设置为 no 时，表示队列的回调地址不产生回调;是否必传：否
@property (nonatomic,strong) NSString * CallBack;

/// 任务回调TDMQ配置，当 CallBackType 为 TDMQ 时必填。详情见 CallBackMqConfig;是否必传：否
@property (nonatomic,strong) QCloudCallBackMqConfig * CallBackMqConfig;

@end

@interface QCloudPostSoundHoundOperation : NSObject 

/// 透���用户信息，可打印的 ASCII 码，长度不超过1024;是否必传：否
@property (nonatomic,strong) NSString * UserData;

/// 任务优先级，级别限制：0 、1 、2 。级别越大任务优先级越高，默认为0;是否必传：否
@property (nonatomic,strong) NSString * JobLevel;

@end



NS_ASSUME_NONNULL_END
