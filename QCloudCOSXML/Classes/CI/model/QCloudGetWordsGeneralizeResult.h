//
//  QCloudGetWordsGeneralizeResult.h
//  QCloudCOSXML
//
//  Created by garenwang on 2022/8/24.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@class QCloudGetWordsGeneralizeInputObject;
@class QCloudGetWordsGeneralizeResultOperation;
@class QCloudGetWordsGeneralizeOutput;
@class QCloudGetWordsGeneralizeTranslation;

@interface QCloudGetWordsGeneralizeResult : NSObject

///   错误码，只有 State 为 Failed 时有意义    String
@property (nonatomic,strong)NSString *Code;

///   错误描述，只有 State 为 Failed 时有意义    String
@property (nonatomic,strong)NSString *Message;

///   新创建任务的 ID    String
@property (nonatomic,strong)NSString *JobId;

///   新创建任务的 Tag：WordsGeneralize    String
@property (nonatomic,strong)NSString *Tag;

///   任务的状态，为 Submitted、Running、Success、Failed、Pause、Cancel 其中一个    String
@property (nonatomic,strong)NSString *State;

///   任务的创建时间    String
@property (nonatomic,strong)NSString *CreationTime;

///   任务的开始时间    String
@property (nonatomic,strong)NSString *StartTime;

///   任务的结束时间    String
@property (nonatomic,strong)NSString *EndTime;

///   任务所属的队列 ID    String
@property (nonatomic,strong)NSString *QueueId;

///   同请求中的 Request.Input 节点。    Container
@property (nonatomic,strong)QCloudGetWordsGeneralizeInputObject *Input;

///   该任务的规则    Container
@property (nonatomic,strong)QCloudGetWordsGeneralizeResultOperation *Operation;
@end

@interface QCloudGetWordsGeneralizeInputObject : NSObject

@property (nonatomic,strong)NSString *Object;

@property (nonatomic,strong)NSString *Lang;

@property (nonatomic,strong)NSString *Type;

@end

@interface QCloudGetWordsGeneralizeResultOperation : NSObject

///  透传用户信息    String
@property (nonatomic,strong)NSString *UserData;

///  同请求中的 Request.Operation.WordsGeneralize    Container
@property (nonatomic,strong)QCloudGetWordsGeneralizeTranslation *Translation;

///  分词结果, 任务执行成功时返回    Container
@property (nonatomic,strong)QCloudGetWordsGeneralizeOutput *Output;

@end

@interface QCloudGetWordsGeneralizeTranslation : NSObject

@property (nonatomic,strong)NSString *Lang;

@property (nonatomic,strong)NSString *Type;

@end

@interface QCloudGetWordsGeneralizeOutput : NSObject


@property (nonatomic,strong)NSString *Region;

@property (nonatomic,strong)NSString *Bucket;

@property (nonatomic,strong)NSString *Object;

@end
NS_ASSUME_NONNULL_END
