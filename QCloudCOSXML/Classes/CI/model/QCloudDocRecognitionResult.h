//
//  QCloudDocRecognitionResult.h
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
@class QCloudDocRecognitionPageSegment;
@class QCloudDocRecognitionPageSegmentItem;
@class QCloudDocRecognitionPageSegmentResultsInfo;
@class QCloudDocRecognitionPageSegmentOcrResults;
@class QCloudDocRecognitionLocationInfo;

NS_ASSUME_NONNULL_BEGIN

@interface QCloudDocRecognitionResult : NSObject


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

/// 该字段表示本次判定的审核结果，您可以根据该结果，进行后续的操作；建议您按照业务所需，对不同的审核结果进行相应处理。
/// 有效值：0（审核正常），1 （判定为违规敏感文件），2（疑似敏感，建议人工复核）
@property (nonatomic,strong)NSString * Suggestion;

/// 审核的对象名称，当创建任务使用 Object 时返回。
@property (nonatomic,strong)NSString * Object;

/// 文本内容的 Base64 编码。当创建任务使用 Content 时返回。
@property (nonatomic,strong)NSString * Content;

/// 文档审核会将文档转换为图片进行审核，该字段表示转换的图片总数量
@property (nonatomic,assign)NSInteger PageCount;

/// 该字段用于返回检测结果中所对应的优先级最高的恶意标签，表示模型推荐的审核结果，建议您按照业务所需，对不同违规类型与建议值进行处理。 返回值：Normal：正常，Porn：色情，Ads：广告，以及其他不安全或不适宜的类型。
@property (nonatomic,strong)NSString * Label;

@property (nonatomic,strong)QCloudRecognitionLabels * Labels;

/// 该字段表示本次判定的审核结果，您可以根据该结果，进行后续的操作；建议您按照业务所需，对不同的审核结果进行相应处理。
/// 有效值：0（审核正常），1 （判定为违规敏感文件），2（疑似敏感，建议人工复核）。
@property (nonatomic,strong)QCloudDocRecognitionPageSegment * PageSegment;


@end

@interface QCloudDocRecognitionPageSegment : NSObject

/// 文档转换为图片后，每张图片的详细审核结果信息
@property (nonatomic,strong)NSArray <QCloudDocRecognitionPageSegmentItem *> * Results;

@end

@interface QCloudDocRecognitionPageSegmentItem : NSObject


/// 文档转换成图片后，您可以通过该地址查看该图片内容，地址格式为标准 URL 格式。
/// 注意：每次查看数据的有效期为2小时，2小时后如还需查看，请重新发起查询请求。    String
@property (nonatomic,strong)NSString * Url;

/// 该字段用于返回当前图片 OCR 文本识别的检测结果，仅在审核策略开启文本内容检测时返回。    String
@property (nonatomic,strong)NSString * Text;

/// 该图片的页码，通常是文档的页码    Integer
@property (nonatomic,assign)NSInteger PageNumber;

/// 如果审核的为表格文件，该字段表示表格内的 Sheet 页码    Integer
@property (nonatomic,assign)NSInteger SheetNumber;

/// 该字段用于返回检测结果中所对应的优先级最高的恶意标签，表示模型推荐的审核结果，建议您按照业务所需，对不同违规类型与建议值进行处理。
/// 返回值：Normal：正常，Porn：色情，Ads：广告，以及其他不安全或不适宜的类型。
@property (nonatomic,strong)NSString * Label;

/// 该字段表示本次判定的审核结果，您可以根据该结果，进行后续的操作；建议您按照业务所需，对不同的审核结果进行相应处理。
/// 有效值：0（审核正常），1 （判定为违规敏感文件），2（疑似敏感，建议人工复核
@property (nonatomic,assign)NSInteger Suggestion;

/// 审核场景为涉黄的审核结果信息
@property (nonatomic,strong)QCloudDocRecognitionPageSegmentResultsInfo * PornInfo;

/// 审核场景为广告引导的审核结果信息
@property (nonatomic,strong)QCloudDocRecognitionPageSegmentResultsInfo * AdsInfo;

/// 审核场景为涉暴恐的审核结果信息。
@property (nonatomic,strong)QCloudDocRecognitionPageSegmentResultsInfo * TerrorismInfo;

/// 审核场景为政治敏感的审核结果信息。
@property (nonatomic,strong)QCloudDocRecognitionPageSegmentResultsInfo * PoliticsInfo;

@end

@interface QCloudDocRecognitionPageSegmentResultsInfo : NSObject


/// 是否命中该审核分类，0表示未命中，1表示命中，2表示疑似    Integer
@property (nonatomic,assign)NSInteger HitFlag;

///  该字段表示审核命中的具体子标签，
///  例如：Porn 下的 SexBehavior 子标签注意：该字段可能返回空，表示未命中具体的子标签
@property (nonatomic,strong)NSString *SubLabel;

///  该字段表示审核结果命中审核信息的置信度，
///  取值范围：0（置信度最低）-100（置信度最高 ），越高代表该内容越有可能属于当前返回审核信息
///  例如：色情 99，则表明该内容非常有可能属于色情内容    Integer
@property (nonatomic,assign)NSInteger Score;

///  该字段表示 OCR 文本识别的详细检测结果，包括文本坐标信息、文本识别结果等信息，有相关违规内容时返回
@property (nonatomic,strong)NSArray <QCloudRecognitionOcrResults *> *OcrResults;

@property (nonatomic,strong)NSArray <QCloudRecognitionObjectResults *> *ObjectResults;

@end


@interface QCloudPostDocRecognitionResult : NSObject

/// 本次审核任务的 ID。
@property (nonatomic,strong)NSString * JobId;

/// 文档审核任务的状态，
/// 值为 Submitted（已提交审核）、Success（审核成功）、Failed（审核失败）、Auditing（审核中）其中一个
@property (nonatomic,strong)NSString * State;

/// 请求中添加的唯一业务标识。
@property (nonatomic,strong)NSString * DataId;

/// 审核任务的创建时间
@property (nonatomic,strong)NSString * CreationTime;
@end
NS_ASSUME_NONNULL_END

