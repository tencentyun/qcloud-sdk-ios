//
//  QCloudWordsGeneralizeInput.h
//  QCloudCOSXML
//
//  Created by garenwang on 2022/8/24.
//

#import <Foundation/Foundation.h>
@class QCloudWordsGeneralizeInputObject;
@class QCloudWordsGeneralizeInputOperation;
@class QCloudWordsGeneralizeInputGeneralize;
@class QCloudCallBackMqConfig;
NS_ASSUME_NONNULL_BEGIN

@interface QCloudWordsGeneralizeInput : NSObject

/// 待操作的对象信息 必选
@property (nonatomic,strong)QCloudWordsGeneralizeInputObject *Input;

/// 操作规则 必选
@property (nonatomic,strong)QCloudWordsGeneralizeInputOperation *Operation;

/// 任务所在的队列 ID
@property (nonatomic,strong)NSString *QueueId;

/// 任务回调地址，优先级高于队列的回调地址。设置为 no 时，表示队列的回调地址不产生回调 可选
@property (nonatomic,strong)NSString *CallBack;

/// 任务回调类型，Url 或 TDMQ，默认 Url，优先级高于队列的回调类型
@property (nonatomic,strong)NSString *CallBackType;

/// 任务回调格式，JSON 或 XML，默认 XML，优先级高于队列的回调格式 可选
@property (nonatomic,strong)NSString *CallBackFormat;

/// 任务回调TDMQ配置，当 CallBackType 为 TDMQ 时必填。
@property (nonatomic,strong)QCloudCallBackMqConfig *CallBackMqConfig;
@end

@interface QCloudWordsGeneralizeInputObject : NSObject

/// 媒体文件名
@property (nonatomic,strong)NSString *Object;

@end

@interface QCloudWordsGeneralizeInputOperation : NSObject

/// 指定 分词 参数 必选
@property (nonatomic,strong)QCloudWordsGeneralizeInputGeneralize *WordsGeneralize;

/// 透传用户信息, 可打印的 ASCII 码, 长度不超过1024  可选
@property (nonatomic,strong)NSString *UserData;

/// 任务优先级，级别限制：0 、1 、2 。级别越大任务优先级越高，默认为0 可选
@property (nonatomic,strong)NSString *JobLevel;

@end

@interface QCloudWordsGeneralizeInputGeneralize : NSObject


/// ner方式, 默认值DL    String    否    NerBasic或DL
@property (nonatomic,strong)NSString *NerMethod;

/// 分词粒度, 默认值MIX    String    否    SegBasic或MIX
@property (nonatomic,strong)NSString *SegMethod;

@end
NS_ASSUME_NONNULL_END
