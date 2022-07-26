//
//  QCloudGetAudioDiscernTaskResult.h
//  QCloudCOSXML
//
//  Created by garenwang on 2022/7/22.
//

#import <Foundation/Foundation.h>
#import "QCloudPostAudioDiscernTaskInfo.h"
@class QCloudGetAudioDiscernTaskSpeechRecognitionResult;
NS_ASSUME_NONNULL_BEGIN

@interface QCloudGetAudioDiscernTaskResult : NSObject

/// 任务的详细信息
@property (nonatomic,strong)QCloudPostAudioDiscernTaskJobsDetail *JobsDetail;

/// 查询的 ID 中不存在的任务，所有任务都存在时不返回
@property (nonatomic,strong)NSString *NonExistJobIds;

/// 在 job 的类型为 SpeechRecognition 且 job 状态为 success 时，返回语音识别的识别结果详情。
@property (nonatomic,strong)QCloudGetAudioDiscernTaskSpeechRecognitionResult *SpeechRecognitionResult;
@end


@interface QCloudGetAudioDiscernTaskSpeechRecognitionResult : NSObject
/// 识别结果
@property (nonatomic,strong)NSString *Result;
/// Response.SpeechRecognition.ResultDetail    识别结果详情，包含每个句子中的词时间偏移，一般用于生成字幕的场景。(识别请求中ResTextFormat=1时该字段不为空)
/// 注意：此字段可能返回 null，表示取不到有效值。
@property (nonatomic,strong)NSString *ResultDetail;
/// 语音时长
@property (nonatomic,assign)CGFloat AudioTime;
@end


@interface QCloudBatchGetAudioDiscernTaskResult : NSObject

/// 任务的详细信息
@property (nonatomic,strong)NSArray <QCloudPostAudioDiscernTaskJobsDetail *> *JobsDetail;

/// 翻页的上下文 Token
@property (nonatomic,strong)NSString *NextToken;

@end
NS_ASSUME_NONNULL_END
