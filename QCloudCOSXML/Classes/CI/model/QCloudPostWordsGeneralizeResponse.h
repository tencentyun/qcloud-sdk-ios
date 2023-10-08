//
//  QCloudPostWordsGeneralizeResponse.h
//  QCloudPostWordsGeneralizeResponse
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

@class QCloudPostWordsGeneralizeResponseJobsDetail;
@class QCloudPostWordsGeneralizeInput;
@class QCloudPostWordsGeneralizeResponseOperation;
@class QCloudPostWordsGeneralizeResponseWordsGeneralizeResult;
@class QCloudPostWordsGeneralizeResponseWordsGeneralizeLable;
@class QCloudPostWordsGeneralizeResponseWordsGeneralizeToken;
@class QCloudPostWordsGeneralizeWordsGeneralize;
@class QCloudPostWordsGeneralizeOperation;
@interface QCloudPostWordsGeneralizeResponse : NSObject 

/// 任务的详细信息
@property (nonatomic,strong)NSArray <QCloudPostWordsGeneralizeResponseJobsDetail * > * JobsDetail;

@end

@interface QCloudPostWordsGeneralizeResponseJobsDetail : NSObject 

/// 错误码，只有 State 为 Failed 时有意义
@property (nonatomic,strong) NSString * Code;

/// 错误描述，只有 State 为 Failed 时有意义
@property (nonatomic,strong) NSString * Message;

/// 创建任务的 ID
@property (nonatomic,strong) NSString * JobId;

/// 创建任务的 Tag：WordsGeneralize
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
@property (nonatomic,strong) QCloudPostWordsGeneralizeInput * Input;

/// 该任务的规则
@property (nonatomic,strong) QCloudPostWordsGeneralizeResponseOperation * Operation;

@end

@interface QCloudPostWordsGeneralizeInput : NSObject 

/// 文件路径;是否必传：是
@property (nonatomic,strong) NSString * Object;

@end

@interface QCloudPostWordsGeneralizeResponseOperation : NSObject 

/// 同请求中的 Request.Operation.WordsGeneralize
@property (nonatomic,strong) QCloudPostWordsGeneralizeWordsGeneralize * WordsGeneralize;

/// 透传用户信息
@property (nonatomic,strong) NSString * UserData;

/// 任务优先级
@property (nonatomic,strong) NSString * JobLevel;

/// 分词结果，任务执行成功时返回
@property (nonatomic,strong) QCloudPostWordsGeneralizeResponseWordsGeneralizeResult * WordsGeneralizeResult;

@end

@interface QCloudPostWordsGeneralizeResponseWordsGeneralizeResult : NSObject 

/// 智能分类结果
@property (nonatomic,strong)NSArray <QCloudPostWordsGeneralizeResponseWordsGeneralizeLable * > * WordsGeneralizeLable;

/// 分词详细结果
@property (nonatomic,strong)NSArray <QCloudPostWordsGeneralizeResponseWordsGeneralizeToken * > * WordsGeneralizeToken;

@end

@interface QCloudPostWordsGeneralizeResponseWordsGeneralizeLable : NSObject 

/// 类别
@property (nonatomic,strong) NSString * Category;

/// 词汇
@property (nonatomic,strong) NSString * Word;

@end

@interface QCloudPostWordsGeneralizeResponseWordsGeneralizeToken : NSObject 

/// 词汇
@property (nonatomic,strong) NSString * Word;

/// 偏移量
@property (nonatomic,strong) NSString * Offset;

/// 词汇长度
@property (nonatomic,strong) NSString * Length;

/// 词性
@property (nonatomic,strong) NSString * Pos;

@end

@interface QCloudPostWordsGeneralizeWordsGeneralize : NSObject 

/// ner 方式，支持 NerBasic 和 DL，默认值 DL;是否必传：否
@property (nonatomic,strong) NSString * NerMethod;

/// 分词粒度，支持 SegBasic 和 MIX，默认值 MIX;是否必传：否
@property (nonatomic,strong) NSString * SegMethod;

@end

@interface QCloudPostWordsGeneralize : NSObject 

/// 创建任务的 Tag：WordsGeneralize;是否必传：是
@property (nonatomic,strong) NSString * Tag;

/// 待操作的对象信息;是否必传：是
@property (nonatomic,strong) QCloudPostWordsGeneralizeInput * Input;

/// 操作规则;是否必传：是
@property (nonatomic,strong) QCloudPostWordsGeneralizeOperation * Operation;

/// 任务回调格式，JSON 或 XML，默认 XML，优先级高于队列的回调格式;是否必传：否
@property (nonatomic,strong) NSString * CallBackFormat;

/// 任务回调类型，Url 或 TDMQ，默认 Url，优先级高于队列的回调类型;是否必传：否
@property (nonatomic,strong) NSString * CallBackType;

/// 任务回调地址，优先级高于队列的回调地址。设置为 no 时，表示队列的回调地址不产生回调;是否必传：否
@property (nonatomic,strong) NSString * CallBack;

/// 任务回调 TDMQ 配置，当 CallBackType 为 TDMQ 时必填。详情见 CallBackMqConfig;是否必传：否
@property (nonatomic,strong) QCloudCallBackMqConfig * CallBackMqConfig;

@end

@interface QCloudPostWordsGeneralizeOperation : NSObject 

/// 指定分词参数;是否必传：是
@property (nonatomic,strong) QCloudPostWordsGeneralizeWordsGeneralize * WordsGeneralize;

/// 透传用户信息，可打印的 ASCII 码，长度不超过1024;是否必传：否
@property (nonatomic,strong) NSString * UserData;

/// 任务优先级，级别限制：0 、1 、2。级别越大任务优先级越高，默认为0;是否必传：否
@property (nonatomic,strong) NSString * JobLevel;

@end



NS_ASSUME_NONNULL_END
