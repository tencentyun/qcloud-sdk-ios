//
//  QCloudWebRecognitionResult.h
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
@class QCloudWebRecognitionLabels;
@class QCloudWebRecognitionLabelsItem;
@class QCloudWebRecognitionImageResults;
@class QCloudWebRecognitionImageResultsItem;
@class QCloudWebRecognitionImageResultsItemInfo;
@class QCloudWebRecognitionTextResults;
@class QCloudWebRecognitionTextResultsItem;


NS_ASSUME_NONNULL_BEGIN

@interface QCloudWebRecognitionResult : NSObject

///  错误码，只有 State 为 Failed 时返回，详情请查看 错误码列表。    String
@property (nonatomic,strong)NSString *Code;

///  错误描述，只有 State 为 Failed 时返回。    String
@property (nonatomic,strong)NSString *Message;

///  网页审核任务的 ID。    String
@property (nonatomic,strong)NSString *JobId;

///  网页审核任务的状态，值为 Submitted（已提交审核）、Success（审核成功）、Failed（审核失败）、Auditing（审核中）其中一个。    String
@property (nonatomic,strong)NSString *State;

///  网页审核任务的创建时间。    String
@property (nonatomic,strong)NSString *CreationTime;

///  本次审核的文件链接，创建任务使用 Url 时返回。    String
@property (nonatomic,strong)NSString *Url;

///  该字段用于返回检测结果中所对应的恶意标签集合。    Container
@property (nonatomic,strong)QCloudRecognitionLabels *Labels;

///  该字段表示本次判定的审核结果，您可以根据该结果，进行后续的操作；建议您按照业务所需，对不同的审核结果进行相应处理。
///  有效值：0（审核正常），1 （判定为违规敏感文件），2（疑似敏感，建议人工复核）    Integer
@property (nonatomic,assign)NSInteger Suggestion;

///  该字段用于返回检测结果中所对应的优先级最高的恶意标签，表示模型推荐的审核结果，建议您按照业务所需，对不同违规类型与建议值进行处理。
///  返回值：Normal：正常，Porn：色情，Ads：广告。    String
@property (nonatomic,strong)NSString *Label;

///  网页审核会将网页中的图片链接和文本分开送审，该字段表示送审的链接和文本总数量。    Integer
@property (nonatomic,assign)NSInteger PageCount;

///  网页内图片的审核结果。    Container
@property (nonatomic,strong)QCloudWebRecognitionImageResults *ImageResults;

///  网页内文字的审核结果。    Container
@property (nonatomic,strong)QCloudWebRecognitionTextResults *TextResults;

///  对违规关键字高亮处理的Html网页内容，请求内容指定ReturnHighlightHtml时返回。    String
@property (nonatomic,strong)NSString *HighlightHtml;

@end

@interface QCloudWebRecognitionImageResults : NSObject

/// 文档转换为图片后，每张图片的详细审核结果信息
@property (nonatomic,strong)NSArray <QCloudWebRecognitionImageResultsItem *> * Results;

@end

@interface QCloudWebRecognitionImageResultsItem : NSObject


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
@property (nonatomic,strong)QCloudWebRecognitionImageResultsItemInfo * PornInfo;

/// 审核场景为广告引导的审核结果信息
@property (nonatomic,strong)QCloudWebRecognitionImageResultsItemInfo * AdsInfo;

/// 审核场景为政治敏感的审核结果信息。
@property (nonatomic,strong)QCloudWebRecognitionImageResultsItemInfo * PoliticsInfo;

/// 审核场景为涉暴恐的审核结果信息。
@property (nonatomic,strong)QCloudWebRecognitionImageResultsItemInfo * TerrorismInfo;

@end

@interface QCloudWebRecognitionImageResultsItemInfo : NSObject


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

@interface QCloudWebRecognitionTextResults : NSObject

@property (nonatomic,strong)NSArray <QCloudWebRecognitionTextResultsItem *> *Results;
@end

@interface QCloudWebRecognitionTextResultsItem : NSObject

/// 网页文本将进行分段送审，每10000个 utf8 编码字符分一段，该参数返回本段文本内容。
@property (nonatomic,strong)NSString * Text;

/// 该字段用于返回检测结果中所对应的优先级最高的恶意标签，表示模型推荐的审核结果，建议您按照业务所需，对不同违规类型与建议值进行处理。
/// 返回值：Normal：正常，Porn：色情，Ads：广告，以及其他不安全或不适宜的类型。
@property (nonatomic,strong)NSString * Label;

/// 该字段表示本次判定的审核结果，您可以根据该结果，进行后续的操作；建议您按照业务所需，对不同的审核结果进行相应处理。
/// 有效值：0（审核正常），1 （判定为违规敏感文件），2（疑似敏感，建议人工复核
@property (nonatomic,assign)NSInteger Suggestion;

/// 审核场景为涉黄的审核结果信息
@property (nonatomic,strong)QCloudRecognitionResultsItemInfo * PornInfo;

/// 审核场景为广告引导的审核结果信息
@property (nonatomic,strong)QCloudRecognitionResultsItemInfo * AdsInfo;

/// 审核场景为政治敏感的审核结果信息。
@property (nonatomic,strong)QCloudRecognitionResultsItemInfo * PoliticsInfo;

/// 审核场景为涉暴恐的审核结果信息。
@property (nonatomic,strong)QCloudRecognitionResultsItemInfo * TerrorismInfo;

@end


@interface QCloudPostWebRecognitionResult : NSObject

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

