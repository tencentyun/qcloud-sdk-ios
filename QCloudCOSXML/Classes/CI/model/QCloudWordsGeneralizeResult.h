//
//  QCloudWordsGeneralizeResult.h
//  QCloudCOSXML
//
//  Created by garenwang on 2022/8/24.
//

#import <Foundation/Foundation.h>
#import "QCloudWordsGeneralizeInput.h"
NS_ASSUME_NONNULL_BEGIN

@class QCloudWordsGeneralizeResultLable;
@class QCloudWordsGeneralizeResultToken;
@class QCloudWordsGeneralizeResultGeneralize;
@class QCloudWordsGeneralizeResultOperation;
@class QCloudWordsGeneralizeResultObject;
@interface QCloudWordsGeneralizeResult : NSObject

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
@property (nonatomic,strong)QCloudWordsGeneralizeResultObject *Input;

///   该任务的规则    Container
@property (nonatomic,strong)QCloudWordsGeneralizeResultOperation *Operation;
@end

@interface QCloudWordsGeneralizeResultObject : NSObject

/// 媒体文件名
@property (nonatomic,strong)NSString *Object;

@property (nonatomic,strong)NSString *Region;

@property (nonatomic,strong)NSString *BucketId;

@end

@interface QCloudWordsGeneralizeResultOperation : NSObject

///  同请求中的 Request.Operation.WordsGeneralize    Container
@property (nonatomic,strong)QCloudWordsGeneralizeInputGeneralize *WordsGeneralize;

///  透传用户信息    String
@property (nonatomic,strong)NSString *UserData;

///  任务优先级    String
@property (nonatomic,strong)NSString *JobLevel;

///  分词结果, 任务执行成功时返回    Container
@property (nonatomic,strong)QCloudWordsGeneralizeResultGeneralize *WordsGeneralizeResult;

@end

@interface QCloudWordsGeneralizeResultGeneralize : NSObject
/// 智能分类结果    Container数组
@property (nonatomic,strong)NSArray<QCloudWordsGeneralizeResultLable *> *WordsGeneralizeLable;
/// 分词详细结果    Container数组
@property (nonatomic,strong)NSArray<QCloudWordsGeneralizeResultToken *> *WordsGeneralizeToken;
@end

@interface QCloudWordsGeneralizeResultLable : NSObject

/// 类别    string
@property (nonatomic,strong)NSString *Category;

/// 词汇    string
@property (nonatomic,strong)NSString *Word;

@end

@interface QCloudWordsGeneralizeResultToken : NSObject

/// 词汇
@property (nonatomic,strong)NSString *Word;

/// 偏移量
@property (nonatomic,strong)NSString *Offset;

/// 词汇长度
@property (nonatomic,strong)NSString *Length;

/// 词性
@property (nonatomic,strong)NSString *Pos;

@end
NS_ASSUME_NONNULL_END
