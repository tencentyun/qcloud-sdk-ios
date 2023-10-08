//
//  QCloudPostSegmentVideoBodyResponse.h
//  QCloudPostSegmentVideoBodyResponse
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

@class QCloudPostSegmentVideoBodyResponseJobsDetail;
@class QCloudPostSegmentVideoBodyInput;
@class QCloudPostSegmentVideoBodyResponseOperation;
@class QCloudPostSegmentVideoBodyOutput;
@class QCloudPostSegmentVideoBodySegmentVideoBody;
@class QCloudPostSegmentVideoBodyOperation;
@interface QCloudPostSegmentVideoBodyResponse : NSObject 

/// 任务的详细信息
@property (nonatomic,strong)NSArray <QCloudPostSegmentVideoBodyResponseJobsDetail * > * JobsDetail;

@end

@interface QCloudPostSegmentVideoBodyResponseJobsDetail : NSObject 

/// 错误码，只有 State 为 Failed 时有意义
@property (nonatomic,strong) NSString * Code;

/// 错误描述，只有 State 为 Failed 时有意义
@property (nonatomic,strong) NSString * Message;

/// 创建任务的 ID
@property (nonatomic,strong) NSString * JobId;

/// 创建任务的 Tag：SegmentVideoBody
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
@property (nonatomic,strong) QCloudPostSegmentVideoBodyInput * Input;

/// 该任务的规则
@property (nonatomic,strong) QCloudPostSegmentVideoBodyResponseOperation * Operation;

@end

@interface QCloudPostSegmentVideoBodyInput : NSObject 

/// 文件路径;是否必传：是
@property (nonatomic,strong) NSString * Object;

@end

@interface QCloudPostSegmentVideoBodyResponseOperation : NSObject 

/// 同请求中的 Request.Operation.SegmentVideoBody
@property (nonatomic,strong) QCloudPostSegmentVideoBodySegmentVideoBody * SegmentVideoBody;

/// 同请求中的 Request.Operation.Output
@property (nonatomic,strong) QCloudPostSegmentVideoBodyOutput * Output;

/// 透传用户信息
@property (nonatomic,strong) NSString * UserData;

/// 任务优先级
@property (nonatomic,strong) NSString * JobLevel;

/// 输出文件的媒体信息，任务未完成时不返回，详见 MediaInfo﻿
@property (nonatomic,strong) QCloudMediaInfo * MediaInfo;

/// 输出文件的基本信息，任务未完成时不返回，详见 MediaResult﻿
@property (nonatomic,strong) QCloudMediaResult * MediaResult;

@end

@interface QCloudPostSegmentVideoBodyOutput : NSObject 

/// 存储桶的地域;是否必传：是
@property (nonatomic,strong) NSString * Region;

/// 存储结果的存储桶;是否必传：是
@property (nonatomic,strong) NSString * Bucket;

/// 输出结果的文件名;是否必传：是
@property (nonatomic,strong) NSString * Object;

@end

@interface QCloudPostSegmentVideoBodySegmentVideoBody : NSObject 

/// 抠图模式 Mask：输出alpha通道结果Foreground：输出前景视频Combination：输出抠图后的前景与自定义背景合成后的视频默认值：Mask;是否必传：否
@property (nonatomic,strong) NSString * Mode;

/// 抠图类型HumanSeg：人像抠图GreenScreenSeg：绿幕抠图SolidColorSeg：纯色背景抠图默认值：HumanSeg;是否必传：否
@property (nonatomic,strong) NSString * SegmentType;

/// mode为 Foreground 时参数生效，背景颜色为红色，取值范围 [0, 255]， 默认值为 0;是否必传：否
@property (nonatomic,strong) NSString * BackgroundRed;

/// mode为 Foreground 时参数生效，背景颜色为绿色，取值范围 [0, 255]，默认值为 0;是否必传：否
@property (nonatomic,strong) NSString * BackgroundGreen;

/// mode为 Foreground 时参数生效，背景颜色为蓝色，取值范围 [0, 255]，默认值为 0;是否必传：否
@property (nonatomic,strong) NSString * BackgroundBlue;

/// 传入背景文件。mode为 Combination 时，此参数必填，背景文件需与源文件在同存储桶下;是否必传：否
@property (nonatomic,strong) NSString * BackgroundLogoUrl;

/// 调整抠图的边缘位置，取值范围为[0, 255]，默认值为 0;是否必传：否
@property (nonatomic,strong) NSString * BinaryThreshold;

/// 纯色背景抠图的背景色（红）, 当 SegmentType 为 SolidColorSeg 生效，取值范围为 [0, 255]，默认值为 0;是否必传：否
@property (nonatomic,strong) NSString * RemoveRed;

/// 纯色背景抠图的背景色（绿）, 当 SegmentType 为 SolidColorSeg 生效，取值范围为 [0, 255]，默认值为 0;是否必传：否
@property (nonatomic,strong) NSString * RemoveGreen;

/// 纯色背景抠图的背景色（蓝）, 当 SegmentType 为 SolidColorSeg 生效，取���范围为 [0, 255]，默认值为 0;是否必传：否
@property (nonatomic,strong) NSString * RemoveBlue;

@end

@interface QCloudPostSegmentVideoBody : NSObject 

/// 创建任务的 Tag：SegmentVideoBody;是否必传：是
@property (nonatomic,strong) NSString * Tag;

/// 待操作的对象信息;是否必传：是
@property (nonatomic,strong) QCloudPostSegmentVideoBodyInput * Input;

/// 操作规则;是否必传：是
@property (nonatomic,strong) QCloudPostSegmentVideoBodyOperation * Operation;

/// 任务回调格式，JSON 或 XML，默认 XML，优先级高于队列的回调格式;是否必传：否
@property (nonatomic,strong) NSString * CallBackFormat;

/// 任务回调类型，Url 或 TDMQ，默认 Url，优先级高于队列的回调类型;是否必传：否
@property (nonatomic,strong) NSString * CallBackType;

/// 任务回调地址，优先级高于队列的回调地址。设置为 no 时，表示队列的回调地址不产生回调;是否必传：否
@property (nonatomic,strong) NSString * CallBack;

/// 任务回调 TDMQ 配置，当 CallBackType 为 TDMQ 时必填。详情见 CallBackMqConfig;是否必传：否
@property (nonatomic,strong) QCloudCallBackMqConfig * CallBackMqConfig;

@end

@interface QCloudPostSegmentVideoBodyOperation : NSObject 

/// 视频人像抠图配置;是否必传：否
@property (nonatomic,strong) QCloudPostSegmentVideoBodySegmentVideoBody * SegmentVideoBody;

/// 结果输出配置;是否必传：是
@property (nonatomic,strong) QCloudPostSegmentVideoBodyOutput * Output;

/// 透传用户信息，可打印的 ASCII 码，长度不超过1024;是否必传：否
@property (nonatomic,strong) NSString * UserData;

/// 任务优先级，级别限制：0 、1 、2。级别越大任务优先级越高，默认为0;是否必传：否
@property (nonatomic,strong) NSString * JobLevel;

@end



NS_ASSUME_NONNULL_END
