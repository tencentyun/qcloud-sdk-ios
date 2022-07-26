//
//  QCloudGetAudioDiscernTaskResult.h
//  QCloudCOSXML
//
//  Created by garenwang on 2022/7/22.
//

#import <Foundation/Foundation.h>
#import "QCloudPostAudioDiscernTaskInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface QCloudGetAudioDiscernTaskResult : NSObject

/// 任务的详细信息
@property (nonatomic,strong)QCloudPostAudioDiscernTaskJobsDetail *JobsDetail;

/// 查询的 ID 中不存在的任务，所有任务都存在时不返回
@property (nonatomic,strong)NSString *NonExistJobIds;

/// 在 job 的类型为 SpeechRecognition 且 job 状态为 success 时，返回语音识别的识别结果详情。
@property (nonatomic,strong)QCloudPostAudioDiscernTaskInfoSpeechRecognitionResult *SpeechRecognitionResult;
@end


@interface QCloudBatchGetAudioDiscernTaskResult : NSObject

/// 任务的详细信息
@property (nonatomic,strong)NSArray <QCloudPostAudioDiscernTaskJobsDetail *> *JobsDetail;

/// 翻页的上下文 Token
@property (nonatomic,strong)NSString *NextToken;

@end
NS_ASSUME_NONNULL_END
