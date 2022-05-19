//
//  QCloudAudioRecognitionResult.h
//  QCloudCOSXML
//
//  Created by garenwang on 2021/10/26.
//

#import <Foundation/Foundation.h>
#import "QCloudRecognitionModel.h"
@class QCloudAudioRecognitionSection;
@class QCloudAudioRecognitionItemInfo;
NS_ASSUME_NONNULL_BEGIN


@interface QCloudAudioRecognitionResult : NSObject

/// 错误码，值为0时表示审核成功，非0表示审核失败。
@property (nonatomic,strong)NSString * Code;

/// 错误描述
@property (nonatomic,strong)NSString * Message;

/// 该字段在审核结果中会返回原始内容，长度限制为512字节。您可以使用该字段对待审核的数据进行唯一业务标识。
@property (nonatomic,strong)NSString * DataId;

/// 本次音频审核任务的 ID。
@property (nonatomic,strong)NSString * JobId;

/// 音频审核任务的状态，值为 Submitted（已提交审核）、Success（审核成功）、Failed（审核失败）、Auditing（审核中）其中一个。
@property (nonatomic,strong)NSString * State;

/// 音频审核任务的创建时间。
@property (nonatomic,strong)NSString * CreationTime;

/// 审核的音频文件为存储在 COS 中的文件时，该字段表示本次审核的音频文件名称。
@property (nonatomic,strong)NSString * Object;

/// 审核的音频文件为一条文件链接时，该字段表示本次审核的音频文件链接。
@property (nonatomic,strong)NSString * Url;

/// 该字段用于返回检测结果中所对应的优先级最高的恶意标签，表示模型推荐的审核结果，建议您按照业务所需，对不同违规类型与建议值进行处理。 返回值：Normal：正常，Porn：色情，Ads：广告，以及其他不安全或不适宜的类型。
@property (nonatomic,strong)NSString * Label;

/// 该字段表示本次判定的审核结果，您可以根据该结果，进行后续的操作；建议您按照业务所需，对不同的审核结果进行相应处理。
/// 有效值：0（审核正常），1 （判定为违规敏感文件），2（疑似敏感，建议人工复核）
@property (nonatomic,strong)NSString * Result;

/// 该字段用于返回音频文件中已识别的对应文本内容。
@property (nonatomic,strong)NSString * AudioText;

/// 审核场景为涉黄的审核结果信息。
@property (nonatomic,strong)QCloudAudioRecognitionItemInfo * PornInfo;

/// 审核场景为广告引导的审核结果信息。
@property (nonatomic,strong)QCloudAudioRecognitionItemInfo * AdsInfo;

/// 审核场景为涉暴恐的审核结果信息。
@property (nonatomic,strong)QCloudAudioRecognitionItemInfo * TerrorismInfo;

/// 审核场景为政治敏感的审核结果信息。
@property (nonatomic,strong)QCloudAudioRecognitionItemInfo * PoliticsInfo;

/// 当音频过长时，会对音频进行分段，该字段用于返回音频片段的审核结果，主要包括开始时间和音频审核的相应结果。
@property (nonatomic,strong)NSArray <QCloudAudioRecognitionSection *> * Section;

@end

@interface QCloudAudioRecognitionItemInfo : NSObject


/// 是否命中该审核分类，0表示未命中，1表示命中，2表示疑似。
@property (nonatomic,strong)NSString * HitFlag;

/// 该字段表示审核结果命中审核信息的置信度，取值范围：0（置信度最低）-100（置信度最高 ），越高代表该内容越有可能属于当前返回审核信息。
/// 例如：色情 99，则表明该内容非常有可能属于色情内容。
@property (nonatomic,strong)NSString * Score;

/// 本次审核的结果标签，如果命中了敏感的关键词，该字段返回对应的关键词。
@property (nonatomic,strong)NSString * Label;

@end

@interface QCloudAudioRecognitionSection : NSObject


/// 视频声音片段的访问地址，您可以通过该地址获取该声音片段的内容，地址格式为标准 URL 格式。
@property (nonatomic,strong)NSString * Url;

/// 该字段用于返回当前声音片段位于视频中的时间，单位为毫秒，例如5000（视频开始后5000毫秒）。
@property (nonatomic,strong)NSString * OffsetTime;

/// 当前视频声音片段的时长，单位毫秒。
@property (nonatomic,strong)NSString * Duration;

/// 该字段用于返回当前视频声音的 ASR 文本识别的检测结果（仅在审核策略开启文本内容检测时返回），识别上限为5小时。
@property (nonatomic,strong)NSString * Text;

/// 该字段用于返回检测结果中所对应的优先级最高的恶意标签，表示模型推荐的审核结果，建议您按照业务所需，对不同违规类型与建议值进行处理。 返回值：Normal：正常，Porn：色情，Ads：广告，Politics：涉政，Terrorism：暴恐。
@property (nonatomic,strong)NSString * Label;

/// 审核场景为涉黄的审核结果信息。
@property (nonatomic,strong)QCloudRecognitionResultsItemInfo * PornInfo;

/// 审核场景为广告引导的审核结果信息。
@property (nonatomic,strong)QCloudRecognitionResultsItemInfo * AdsInfo;

/// 审核场景为涉暴恐的审核结果信息。
@property (nonatomic,strong)QCloudRecognitionResultsItemInfo * TerrorismInfo;

/// 审核场景为政治敏感的审核结果信息。
@property (nonatomic,strong)QCloudRecognitionResultsItemInfo * PoliticsInfo;
@end



@interface QCloudPostAudioRecognitionResult : NSObject

/// 本次音频审核任务的 ID。
@property (nonatomic,strong)NSString * JobId;

/// 音频审核任务的状态，值为 Submitted（已提交审核）、Snapshoting（视频截帧中）、Success（审核成功）、Failed（审核失败）、Auditing（审核中）其中一个
@property (nonatomic,strong)NSString * State;

@property (nonatomic,strong)NSString * Object;

/// 请求中添加的唯一业务标识。
@property (nonatomic,strong)NSString * DataId;

/// 视频审核任务的创建时间
@property (nonatomic,strong)NSString * CreationTime;
@end

NS_ASSUME_NONNULL_END

