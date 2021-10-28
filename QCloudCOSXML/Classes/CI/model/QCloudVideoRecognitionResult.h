//
//  QCloudVideoRecognitionResult.h
//  QCloudCOSXML
//
//  Created by garenwang on 2021/10/26.
//

#import <Foundation/Foundation.h>
@class QCloudVideoRecognitionItemInfo;
@class QCloudVideoRecognitionSnapshotItemInfo;
@class QCloudVideoRecognitionSnapshot;
@class QCloudVideoRecognitionAudioSectionItemInfo;
@class QCloudVideoRecognitionAudioSection;

NS_ASSUME_NONNULL_BEGIN

@interface QCloudVideoRecognitionResult : NSObject


/// 错误码，值为0时表示审核成功，非0表示审核失败。
@property (nonatomic,strong)NSString * Code;

/// 错误描述
@property (nonatomic,strong)NSString * Message;

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
@property (nonatomic,strong)QCloudVideoRecognitionItemInfo * PornInfo;

/// 审核场景为涉暴恐的审核结果信息。
@property (nonatomic,strong)QCloudVideoRecognitionItemInfo * TerrorismInfo;

/// 审核场景为政治敏感的审核结果信息。
@property (nonatomic,strong)QCloudVideoRecognitionItemInfo * PoliticsInfo;

/// 审核场景为广告引导的审核结果信息。
@property (nonatomic,strong)QCloudVideoRecognitionItemInfo * AdsInfo;


/// 该字段用于返回视频中视频画面截图审核的结果。
/// 注意：每次查看数据的有效期为2小时，2小时后如还需查看，请重新发起查询请求。
@property (nonatomic,strong)NSArray <QCloudVideoRecognitionSnapshot *> * Snapshot;

/// 该字段用于返回视频中视频声音审核的结果。
/// 注意：每次查看数据的有效期为2小时，2小时后如还需查看，请重新发起查询请求
@property (nonatomic,strong)QCloudVideoRecognitionAudioSection * AudioSection;

@property (nonatomic,strong)NSString * NonExistJobIds;
@end

@interface QCloudVideoRecognitionItemInfo : NSObject

/// 是否命中该审核分类，0表示未命中，1表示命中，2表示疑似。
@property (nonatomic,strong)NSString * HitFlag;
@property (nonatomic,strong)NSString * Count;
@end

@interface QCloudVideoRecognitionSnapshot : NSObject


/// 视频截图的访问地址，您可以通过该地址查看该截图内容，地址格式为标准 URL 格式。
@property (nonatomic,strong)NSString * Url;

/// 该字段用于返回当前截图的图片 OCR 文本识别的检测结果（仅在审核策略开启文本内容检测时返回），识别上限为5000字节。
@property (nonatomic,strong)NSString * Text;

/// 该字段用于返回当前截图位于视频中的时间，单位为毫秒。例如5000（视频开始后5000毫秒）。
@property (nonatomic,strong)NSString * SnapshotTime;
@property (nonatomic,strong)NSString * Result;
@property (nonatomic,strong)NSString * Label;

@property (nonatomic,strong)QCloudVideoRecognitionSnapshotItemInfo * PornInfo;
@property (nonatomic,strong)QCloudVideoRecognitionSnapshotItemInfo * TerrorismInfo;
@property (nonatomic,strong)QCloudVideoRecognitionSnapshotItemInfo * PoliticsInfo;
@property (nonatomic,strong)QCloudVideoRecognitionSnapshotItemInfo * AdsInfo;

/// <#Description#>


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

/// 该字段用于返回检测结果中所对应的优先级最高的恶意标签，表示模型推荐的审核结果，建议您按照业务所需，对不同违规类型与建议值进行处理。 返回值：Normal：正常，Porn：色情，Ads：广告，Politics：涉政，Terrorism：暴恐。
@property (nonatomic,strong)NSString * Label;

/// 该字段表示本次判定的审核结果，您可以根据该结果，进行后续的操作；建议您按照业务所需，对不同的审核结果进行相应处理。
///            有效值：0（审核正常），1 （判定为违规敏感文件），2（疑似敏感，建议人工复核）。
@property (nonatomic,strong)NSString * Result;


/// 审核场景为涉黄的审核结果信息。
@property (nonatomic,strong)QCloudVideoRecognitionAudioSectionItemInfo * PornInfo;

/// 审核场景为涉暴恐的审核结果信息。
@property (nonatomic,strong)QCloudVideoRecognitionAudioSectionItemInfo * TerrorismInfo;

/// 审核场景为政治敏感的审核结果信息。
@property (nonatomic,strong)QCloudVideoRecognitionAudioSectionItemInfo * PoliticsInfo;

/// 审核场景为广告引导的审核结果信息。
@property (nonatomic,strong)QCloudVideoRecognitionAudioSectionItemInfo * AdsInfo;

@end

@interface QCloudVideoRecognitionAudioSectionItemInfo : NSObject

/// 是否命中该审核分类，0表示未命中，1表示命中，2表示疑似。
@property (nonatomic,strong)NSString * HitFlag;

/// 该字段表示审核结果命中审核信息的置信度，取值范围：0（置信度最低）-100（置信度最高 ），越高代表该内容越有可能属于当前返回审核信息
/// 例如：色情 99，则表明该内容非常有可能属于色情内容。
@property (nonatomic,strong)NSString * Score;

/// 在当前审核场景下命中的关键词。
@property (nonatomic,strong)NSString * Keywords;
@end

@interface QCloudPostVideoRecognitionResult : NSObject

/// 本次视频审核任务的 ID。
@property (nonatomic,strong)NSString * JobId;

/// 视频审核任务的状态，值为 Submitted（已提交审核）、Snapshoting（视频截帧中）、Success（审核成功）、Failed（审核失败）、Auditing（审核中）其中一个
@property (nonatomic,strong)NSString * State;
@property (nonatomic,strong)NSString * Object;

/// 视频审核任务的创建时间
@property (nonatomic,strong)NSString * CreationTime;
@end


NS_ASSUME_NONNULL_END

