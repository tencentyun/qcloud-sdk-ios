//
//  QCloudTextRecognitionResult.h
//  QCloudCOSXML
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
#import "QCloudRecognitionModel.h"
@class QCloudTextRecognitionSectionItemInfo;
@class QCloudTextRecognitionSection;

NS_ASSUME_NONNULL_BEGIN

@interface QCloudTextRecognitionResult : NSObject


/// 错误码，值为0时表示审核成功，非0表示审核失败。
@property (nonatomic,strong)NSString * Code;

/// 错误描述
@property (nonatomic,strong)NSString * Message;

/// 本次审核任务的 ID。
@property (nonatomic,strong)NSString * JobId;


/// 该字段在审核结果中会返回原始内容，长度限制为512字节。您可以使用该字段对待审核的数据进行唯一业务标识。
@property (nonatomic,strong)NSString * DataId;

/// 任务的状态，值为 Submitted（已提交审核）、Success（审核成功）、Failed（审核失败）、Auditing（审核中）其中一个。
@property (nonatomic,strong)NSString * State;

/// 任务的创建时间。
@property (nonatomic,strong)NSString * CreationTime;

/// 审核的对象名称，当创建任务使用 Object 时返回。
@property (nonatomic,strong)NSString * Object;

/// 文本内容的 Base64 编码。当创建任务使用 Content 时返回。
@property (nonatomic,strong)NSString * Content;

/// 审核的文本内容分片数，固定为1。    Integer
@property (nonatomic,assign)NSInteger SectionCount;

/// 该字段用于返回检测结果中所对应的优先级最高的恶意标签，表示模型推荐的审核结果，建议您按照业务所需，对不同违规类型与建议值进行处理。 返回值：Normal：正常，Porn：色情，Ads：广告，以及其他不安全或不适宜的类型。
@property (nonatomic,strong)NSString * Label;

/// 该字段表示本次判定的审核结果，您可以根据该结果，进行后续的操作；建议您按照业务所需，对不同的审核结果进行相应处理。
/// 有效值：0（审核正常），1 （判定为违规敏感文件），2（疑似敏感，建议人工复核）。
@property (nonatomic,strong)NSString * Result;

/// 审核场景为涉黄的审核结果信息。
@property (nonatomic,strong)QCloudRecognitionItemInfo * PornInfo;

/// 审核场景为谩骂的审核结果信息。
@property (nonatomic,strong)QCloudRecognitionItemInfo * AbuseInfo;

/// 审核场景为违法的审核结果信息。
@property (nonatomic,strong)QCloudRecognitionItemInfo * IllegalInfo;

/// 审核场景为广告引导的审核结果信息。
@property (nonatomic,strong)QCloudRecognitionItemInfo * AdsInfo;

/// 审核场景为涉暴恐的审核结果信息。
@property (nonatomic,strong)QCloudRecognitionItemInfo * TerrorismInfo;

/// 审核场景为政治敏感的审核结果信息。
@property (nonatomic,strong)QCloudRecognitionItemInfo * PoliticsInfo;

/// 具体文本分片的审核结果信息。
@property (nonatomic,strong)NSArray <QCloudTextRecognitionSection *> * Section;

@end



@interface QCloudTextRecognitionSection : NSObject

/// 该分片位于文本中的起始位置信息（即10代表第11个utf8文字）。从0开始。
@property (nonatomic,assign)NSInteger StartByte;


/// 该字段用于返回检测结果中所对应的优先级最高的恶意标签，表示模型推荐的审核结果，建议您按照业务所需，对不同违规类型与建议值进行处理。 返回值：Normal：正常，Porn：色情，Ads：广告，Politics：涉政，Terrorism：暴恐。
@property (nonatomic,strong)NSString * Label;

/// 该字段表示本次判定的审核结果，您可以根据该结果，进行后续的操作；建议您按照业务所需，对不同的审核结果进行相应处理。
///            有效值：0（审核正常），1 （判定为违规敏感文件），2（疑似敏感，建议人工复核）。
@property (nonatomic,strong)NSString * Result;

/// 审核场景为涉黄的审核结果信息。
@property (nonatomic,strong)QCloudRecognitionResultsItemInfo * PornInfo;

/// 审核场景为广告引导的审核结果信息。
@property (nonatomic,strong)QCloudRecognitionResultsItemInfo * AbuseInfo;

/// 审核场景为违法的审核结果信息。
@property (nonatomic,strong)QCloudRecognitionResultsItemInfo * IllegalInfo;

/// 审核场景为广告引导的审核结果信息。
@property (nonatomic,strong)QCloudRecognitionResultsItemInfo * AdsInfo;

/// 审核场景为涉暴恐的审核结果信息。
@property (nonatomic,strong)QCloudRecognitionResultsItemInfo * TerrorismInfo;

/// 审核场景为政治敏感的审核结果信息。
@property (nonatomic,strong)QCloudRecognitionResultsItemInfo * PoliticsInfo;

@end


@interface QCloudPostTextRecognitionResult : NSObject

/// ****** 1）Input 为 Object 时
/// 本次审核任务的 ID。
@property (nonatomic,strong)NSString * JobId;

/// Submitted（已提交审核）、Snapshoting（视频截帧中）、Success（审核成功）、Failed（审核失败）、Auditing（审核中）其中一个
@property (nonatomic,strong)NSString * State;

@property (nonatomic,strong)NSString * Object;

/// 任务的创建时间
@property (nonatomic,strong)NSString * CreationTime;


/// 错误码，只有 State 为 Failed 时返回，详情请查看 错误码列表。
@property (nonatomic,strong)NSString * Code;

/// 请求中添加的唯一业务标识。    String
@property (nonatomic,strong)NSString * DataId;

/// 错误描述，只有 State 为 Failed 时返回。    String
@property (nonatomic,strong)NSString * Message;

/// 文本内容的 Base64 编码。    String
@property (nonatomic,strong)NSString * Content;

/// 该字段用于返回检测结果中所对应的优先级最高的恶意标签，表示模型推荐的审核结果，建议您按照业务所需，对不同违规类型与建议值进行处理。
/// 返回值：Normal：正常，Porn：色情，Ads：广告，以及其他不安全或不适宜的类型。
@property (nonatomic,strong)NSString * Label;

/// 该字段表示本次判定的审核结果，您可以根据该结果，进行后续的操作；建议您按照业务所需，对不同的审核结果进行相应处理。
/// 有效值：0（审核正常），1（判定为违规敏感文件），2（疑似敏感，建议人工复核）。
@property (nonatomic,assign)NSInteger Result;

/// 审核的文本内容分片数，固定为1。    Integer
@property (nonatomic,assign)NSInteger SectionCount;

/// 审核场景为涉黄的审核结果信息。    Container
@property (nonatomic,strong)QCloudRecognitionItemInfo * PornInfo;

/// 审核场景为广告引导的审核结果信息。    Container
@property (nonatomic,strong)QCloudRecognitionItemInfo * AdsInfo;

/// 审核场景为涉暴恐的审核结果信息。
@property (nonatomic,strong)QCloudRecognitionItemInfo * TerrorismInfo;

/// 审核场景为政治敏感的审核结果信息。
@property (nonatomic,strong)QCloudRecognitionItemInfo * PoliticsInfo;

/// 审核场景为违法的审核结果信息。    Container
@property (nonatomic,strong)QCloudRecognitionItemInfo * IllegalInfo;

/// 审核场景为谩骂的审核结果信息。    Container
@property (nonatomic,strong)QCloudRecognitionItemInfo * AbuseInfo;

/// 文本审核的具体结果信息。    Container Array
@property (nonatomic,strong)NSArray <QCloudTextRecognitionSection *> * Section;


@end


NS_ASSUME_NONNULL_END

