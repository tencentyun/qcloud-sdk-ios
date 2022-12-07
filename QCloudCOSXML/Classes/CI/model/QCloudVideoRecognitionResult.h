//
//  QCloudVideoRecognitionResult.h
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
@class QCloudVideoRecognitionSnapshotItemInfo;
@class QCloudVideoRecognitionSnapshot;
@class QCloudVideoRecognitionAudioSection;
@class QCloudRecognitionObjectLibResult;

NS_ASSUME_NONNULL_BEGIN

@interface QCloudVideoRecognitionResult : NSObject


/// 错误码，只有State为 Failed时返回。详情请查看 错误码列表。
@property (nonatomic,strong)NSString * Code;

/// 错误描述，只有State为 Failed时返回。
@property (nonatomic,strong)NSString * Message;

/// 该字段在审核结果中会返回原始内容，长度限制为512字节。您可以使用该字段对待审核的数据进行唯一业务标识。
@property (nonatomic,strong)NSString * DataId;

/// 视频审核任务的 ID。
@property (nonatomic,strong)NSString * JobId;

/// 视频审核任务的状态，值为 Submitted（已提交审核）、Snapshoting（视频截帧中）、Success（审核成功）、Failed（审核失败）、Auditing（审核中）其中一个。
@property (nonatomic,strong)NSString * State;

/// 视频审核任务的创建时间
@property (nonatomic,strong)NSString * CreationTime;

/// 被审核的视频文件的名称。
@property (nonatomic,strong)NSString * Object;

/// 本次审核的文件链接，创建任务使用 Url 时返回。
@property (nonatomic,strong)NSString * Url;

/// 视频截图的总数量。
@property (nonatomic,strong)NSString * SnapshotCount;

/// 该字段用于返回检测结果中所对应的优先级最高的恶意标签，表示模型推荐的审核结果，建议您按照业务所需，对不同违规类型与建议值进行处理。 返回值：Normal：正常，Porn：色情，Ads：广告，Politics：涉政，Terrorism：暴恐。
@property (nonatomic,strong)NSString * Label;

/// 该字段表示本次判定的审核结果，您可以根据该结果，进行后续的操作；建议您按照业务所需，对不同的审核结果进行相应处理。
/// 有效值：0（审核正常），1 （判定为违规敏感文件），2（疑似敏感，建议人工复核）。
@property (nonatomic,strong)NSString * Result;

/// 审核场景为涉黄的审核结果信息。
@property (nonatomic,strong)QCloudRecognitionItemInfo * PornInfo;

/// 审核场景为涉暴恐的审核结果信息。
@property (nonatomic,strong)QCloudRecognitionItemInfo * TerrorismInfo;

/// 审核场景为政治敏感的审核结果信息。
@property (nonatomic,strong)QCloudRecognitionItemInfo * PoliticsInfo;

/// 审核场景为广告引导的审核结果信息。
@property (nonatomic,strong)QCloudRecognitionItemInfo * AdsInfo;


/// 该字段用于返回视频中视频画面截图审核的结果。
/// 注意：每次查看数据的有效期为2小时，2小时后如还需查看，请重新发起查询请求。
@property (nonatomic,strong)NSArray <QCloudVideoRecognitionSnapshot *> * Snapshot;

/// 该字段用于返回视频中视频声音审核的结果。
/// 注意：每次查看数据的有效期为2小时，2小时后如还需查看，请重新发起查询请求
@property (nonatomic,strong)NSArray <QCloudVideoRecognitionAudioSection *> * AudioSection;

@end


@interface QCloudVideoRecognitionSnapshot : NSObject


/// 视频截图的访问地址，您可以通过该地址查看该截图内容，地址格式为标准 URL 格式。
@property (nonatomic,strong)NSString * Url;

/// 该字段用于返回当前截图的图片 OCR 文本识别的检测结果（仅在审核策略开启文本内容检测时返回），识别上限为5000字节。
@property (nonatomic,strong)NSString * Text;

/// 该字段用于返回当前截图位于视频中的时间，单位为毫秒。例如5000（视频开始后5000毫秒）。
@property (nonatomic,strong)NSString * SnapshotTime;

@property (nonatomic,strong)QCloudVideoRecognitionSnapshotItemInfo * PornInfo;
@property (nonatomic,strong)QCloudVideoRecognitionSnapshotItemInfo * TerrorismInfo;
@property (nonatomic,strong)QCloudVideoRecognitionSnapshotItemInfo * PoliticsInfo;
@property (nonatomic,strong)QCloudVideoRecognitionSnapshotItemInfo * AdsInfo;

/**直播审核有下面字段********************/
/// 该字段用于返回检测结果中所对应的优先级最高的恶意标签，表示模型推荐的审核结果，建议您按照业务所需，对不同违规类型与建议值进行处理。 返回值：Normal：正常，Porn：色情，Ads：广告，以及其他不安全或不适宜的类型。
@property (nonatomic,strong)NSString * Label;

/// 该字段表示本次判定的审核结果，您可以根据该结果，进行后续的操作；建议您按照业务所需，对不同的审核结果进行相应处理。
/// 有效值：0（审核正常），1 （判定为违规敏感内容），2（疑似敏感内容，建议人工复核）。
@property (nonatomic,strong)NSString * Result;

@end

@interface QCloudVideoRecognitionSnapshotItemInfo : NSObject

/// 是否命中该审核分类，0表示未命中，1表示命中，2表示疑似。
@property (nonatomic,strong)NSString * HitFlag;

/// 该字段表示审核结果命中审核信息的置信度，取值范围：0（置信度最低）-100（置信度最高 ），越高代表该内容越有可能属于当前返回审核信息。
/// 例如：色情 99，则表明该内容非常有可能属于色情内容。
@property (nonatomic,strong)NSString * Score;

/// 该字段为兼容旧版本的保留字段，表示该截图的结果标签（可能为 SubLabel，可能为人物名字等）。
@property (nonatomic,strong)NSString * Label;

/// 该字段表示审核命中的具体子标签，例如：Porn 下的 SexBehavior 子标签。
/// 注意：该字段可能返回空，表示未命中具体的子标签。
@property (nonatomic,strong)NSString * SubLabel;


///  该字段表示 OCR 文本识别的详细检测结果，包括文本识别结果、命中的关键词等信息，有相关违规内容时返回
@property (nonatomic,strong)NSArray <QCloudRecognitionOcrResults *> *OcrResults;

@property (nonatomic,strong)NSArray <QCloudRecognitionObjectResults *> *ObjectResults;

/**
 表示命中的具体审核类别。例如 Sexy，表示色情标签中的性感类别。该字段可能为空，表示未命中或暂无相关的类别。
 */
@property (nonatomic,strong)NSString * Category;

/**
 该字段用于返回基于风险库识别的结果。
 注意：未命中风险库中样本时，此字段不返回。
 */
@property (nonatomic,strong)NSArray <QCloudRecognitionObjectLibResult *> *LibResults;

@end

@interface QCloudRecognitionObjectLibResult : NSObject
/**
 该字段表示命中的风险库中的图片样本 ID。
 */
@property (nonatomic,strong)NSString * ImageId;
/**
 该字段用于返回当前标签下的置信度，
 取值范围：0（置信度最低）-100（置信度最高 ），越高代表当前的图片越有可能命中库中的样本；如：色情 99，则表明该数据非常有可能命中库中的色情样本。
 */
@property (nonatomic,assign)NSInteger Score;
@end


@interface QCloudVideoRecognitionAudioSection : NSObject


/// 视频声音片段的访问地址，您可以通过该地址获取该声音片段的内容，地址格式为标准 URL 格式。
@property (nonatomic,strong)NSString * Url;

/// 该字段用于返回当前声音片段位于视频中的时间，单位为毫秒，例如5000（视频开始后5000毫秒）。
@property (nonatomic,strong)NSString * OffsetTime;

/// 当前视频声音片段的时长，单位毫秒。
@property (nonatomic,strong)NSString * Duration;

/// 该字段用于返回当前视频声音的 ASR 文本识别的检测结果（仅在审核策略开启文本内容检测时返回），识别上限为5小时。
@property (nonatomic,strong)NSString * Text;

/// 审核场景为涉黄的审核结果信息。
@property (nonatomic,strong)QCloudRecognitionSectionItemInfo * PornInfo;

/// 审核场景为涉暴恐的审核结果信息。
@property (nonatomic,strong)QCloudRecognitionSectionItemInfo * TerrorismInfo;

/// 审核场景为政治敏感的审核结果信息。
@property (nonatomic,strong)QCloudRecognitionSectionItemInfo * PoliticsInfo;

/// 审核场景为广告引导的审核结果信息。
@property (nonatomic,strong)QCloudRecognitionSectionItemInfo * AdsInfo;

@end

@interface QCloudPostVideoRecognitionResult : NSObject

/// 请求中添加的唯一业务标识。
@property (nonatomic,strong)NSString * DataId;

/// 本次视频审核任务的 ID。
@property (nonatomic,strong)NSString * JobId;

/// 视频审核任务的状态，值为 Submitted（已提交审核）、Snapshoting（视频截帧中）、Success（审核成功）、Failed（审核失败）、Auditing（审核中）其中一个
@property (nonatomic,strong)NSString * State;

/// 视频审核任务的创建时间
@property (nonatomic,strong)NSString * CreationTime;
@end


NS_ASSUME_NONNULL_END

