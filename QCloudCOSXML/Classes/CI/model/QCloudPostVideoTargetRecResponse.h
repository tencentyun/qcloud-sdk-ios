//
//  QCloudPostVideoTargetRecResponse.h
//  QCloudPostVideoTargetRecResponse
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

@class QCloudPostVideoTargetRecResponseJobsDetail;
@class QCloudPostVideoTargetRecResponseOperation;
@class QCloudPostVideoTargetRecResponseVideoTargetRecResult;
@class QCloudPostVideoTargetRecResponseBodyRecognition;
@class QCloudPostVideoTargetRecResponseBodyInfo;
@class QCloudPostVideoTargetRecResponseLocation;
@class QCloudPostVideoTargetRecResponseCarRecognition;
@class QCloudPostVideoTargetRecResponseCarInfo;
@class QCloudPostVideoTargetRecResponsePetRecognition;
@class QCloudPostVideoTargetRecResponsePetInfo;
@class QCloudPostVideoTargetRecInput;
@class QCloudPostVideoTargetRecOperation;
@interface QCloudPostVideoTargetRecResponse : NSObject 

/// 任务的详细信息
@property (nonatomic,strong)NSArray <QCloudPostVideoTargetRecResponseJobsDetail * > * JobsDetail;

@end

@interface QCloudPostVideoTargetRecResponseJobsDetail : NSObject 

/// 错误码，只有 State 为 Failed 时有意义
@property (nonatomic,strong) NSString * Code;

/// 错误描述，只有 State 为 Failed 时有意义
@property (nonatomic,strong) NSString * Message;

/// 新创建任务的 ID
@property (nonatomic,strong) NSString * JobId;

/// 新创建任务的 Tag：VideoTargetRec
@property (nonatomic,strong) NSString * Tag;

/// 任务状态Submitted：已提交，待执行Running：执行中Success：执行成功Failed：执行失败Pause：任务暂停，当暂停队列时，待执行的任务会变为暂停状态Cancel：任务被取消执行
@property (nonatomic,strong) NSString * State;

/// 任务的创建时间
@property (nonatomic,strong) NSString * CreationTime;

/// 任务的开始时间
@property (nonatomic,strong) NSString * StartTime;

/// 任务的结束时间
@property (nonatomic,strong) NSString * EndTime;

/// 任务所属的队列 ID
@property (nonatomic,strong) NSString * QueueId;

/// 该任务的规则
@property (nonatomic,strong) QCloudPostVideoTargetRecResponseOperation * Operation;

@end

@interface QCloudPostVideoTargetRecResponseOperation : NSObject 

/// 任务的模板 ID
@property (nonatomic,strong) NSString * TemplateId;

/// 任务的模板名称, 当 TemplateId 存在时返回
@property (nonatomic,strong) NSString * TemplateName;

/// 同请求中的 Request.Operation.VideoTargetRec
@property (nonatomic,strong) QCloudVideoTargetRec * VideoTargetRec;

/// 视频目标检测结果
@property (nonatomic,strong) QCloudPostVideoTargetRecResponseVideoTargetRecResult * VideoTargetRecResult;

/// 透传用户信息
@property (nonatomic,strong) NSString * UserData;

/// 任务优先级
@property (nonatomic,strong) NSString * JobLevel;

@end

@interface QCloudPostVideoTargetRecResponseVideoTargetRecResult : NSObject 

/// 人体识别结果
@property (nonatomic,strong)NSArray <QCloudPostVideoTargetRecResponseBodyRecognition * > * BodyRecognition;

/// 宠物识别结果
@property (nonatomic,strong)NSArray <QCloudPostVideoTargetRecResponsePetRecognition * > * PetRecognition;

/// 车辆识别结果
@property (nonatomic,strong)NSArray <QCloudPostVideoTargetRecResponseCarRecognition * > * CarRecognition;

@end

@interface QCloudPostVideoTargetRecResponseBodyRecognition : NSObject 

/// 截图的时间点，单位为秒
@property (nonatomic,strong) NSString * Time;

/// 截图 URL
@property (nonatomic,strong) NSString * Url;

/// 人体识别结果，可能有多个
@property (nonatomic,strong) QCloudPostVideoTargetRecResponseBodyInfo * BodyInfo;

@end

@interface QCloudPostVideoTargetRecResponseBodyInfo : NSObject 

/// 识别类型
@property (nonatomic,strong) NSString * Name;

/// 识别的置信度，取值范围为[0-100]。值越高概率越大。
@property (nonatomic,assign) NSInteger Score;

/// 图中识别到人体的坐标
@property (nonatomic,strong) QCloudPostVideoTargetRecResponseLocation * Location;

@end

@interface QCloudPostVideoTargetRecResponseLocation : NSObject 

/// X坐标
@property (nonatomic,strong) NSString * X;

/// Y坐标
@property (nonatomic,strong) NSString * Y;

/// (X,Y)坐标距离高度
@property (nonatomic,strong) NSString * Height;

/// (X,Y)坐标距离长度
@property (nonatomic,strong) NSString * Width;

@end

@interface QCloudPostVideoTargetRecResponseCarRecognition : NSObject 

/// 截图的时间点，单位为秒
@property (nonatomic,strong) NSString * Time;

/// 截图 URL
@property (nonatomic,strong) NSString * Url;

/// 车辆识别结果，可能有多个
@property (nonatomic,strong)NSArray <QCloudPostVideoTargetRecResponseCarInfo * > * CarInfo;

@end

@interface QCloudPostVideoTargetRecResponseCarInfo : NSObject 

/// 识别类型
@property (nonatomic,strong) NSString * Name;

/// 识别的置信度，取值范围为[0-100]。值越高概率越大。
@property (nonatomic,assign) NSInteger Score;

/// 图中识别到车辆的坐标
@property (nonatomic,strong) QCloudPostVideoTargetRecResponseLocation * Location;

@end

@interface QCloudPostVideoTargetRecResponsePetRecognition : NSObject 

/// 截图的时间点，单位为秒
@property (nonatomic,strong) NSString * Time;

/// 截图 URL
@property (nonatomic,strong) NSString * Url;

/// 宠物识别结果结果，可能有多个
@property (nonatomic,strong)NSArray <QCloudPostVideoTargetRecResponsePetInfo * > * PetInfo;

@end

@interface QCloudPostVideoTargetRecResponsePetInfo : NSObject 

/// 识别类型
@property (nonatomic,strong) NSString * Name;

/// 识别的置信度，取值范围为[0-100]。值越高概率越大。
@property (nonatomic,assign) NSInteger Score;

/// 图中识别到宠物的坐标
@property (nonatomic,strong) QCloudPostVideoTargetRecResponseLocation * Location;

@end

@interface QCloudPostVideoTargetRec : NSObject 

/// 创建任务的 Tag：VideoTargetRec;是否必传：是
@property (nonatomic,strong) NSString * Tag;

/// 操作规则;是否必传：是
@property (nonatomic,strong) QCloudPostVideoTargetRecOperation * Operation;

/// 待操作的媒体信息;是否必传：是
@property (nonatomic,strong) QCloudPostVideoTargetRecInput * Input;

/// 任务回调格式，JSON 或 XML，默认 XML，优先级高于队列的回调格式;是否必传：否
@property (nonatomic,strong) NSString * CallBackFormat;

/// 任务回调类型，Url 或 TDMQ，默认 Url，优先级高于队列的回调类型;是否必传：否
@property (nonatomic,strong) NSString * CallBackType;

/// 任务回调地址，优先级高于队列的回调地址。设置为 no 时，表示队列的回调地址不产生回调;是否必传：否
@property (nonatomic,strong) NSString * CallBack;

/// 任务回调TDMQ配置，当 CallBackType 为 TDMQ 时必填。详情请参见 CallBackMqConfig;是否必传：否
@property (nonatomic,strong) QCloudCallBackMqConfig * CallBackMqConfig;

@end

@interface QCloudPostVideoTargetRecInput : NSObject 

/// 媒体文件名;是否必传：否
@property (nonatomic,strong) NSString * Object;

@end

@interface QCloudPostVideoTargetRecOperation : NSObject 

/// 视频目标检测模板 ID;是否必传：否
@property (nonatomic,strong) NSString * TemplateId;

/// 视频目标检测参数, 同创建视频目标检测模板接口中的 Request.VideoTargetRec﻿;是否必传：否
@property (nonatomic,strong) QCloudVideoTargetRec * VideoTargetRec;

/// 透传用户信息, 可打印的 ASCII 码, 长度不超过1024;是否必传：否
@property (nonatomic,strong) NSString * UserData;

/// 任务优先级，级别限制：0 、1 、2 。级别越大任务优先级越高，默认为0;是否必传：否
@property (nonatomic,strong) NSString * JobLevel;

@end



NS_ASSUME_NONNULL_END
