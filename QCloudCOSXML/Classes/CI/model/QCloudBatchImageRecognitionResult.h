//
//  QCloudBatchImageRecognitionResult.h 
//  QCloudCOSXML
//
//  Created by garenwang on 2022/3/22.
//

#import <Foundation/Foundation.h>
#import "QCloudRecognitionModel.h"
#import "QCloudImageRecognitionResult.h"
#import "QCloudBatchRecognitionUserInfo.h"
@class QCloudBatchImageRecognitionResultInfo;
@class QCloudBatchImageRecognitionResultItem;
@class QCloudBatchRecognitionListInfo;
@class QCloudBatchRecognitionListInfoListResults;
NS_ASSUME_NONNULL_BEGIN

@interface QCloudBatchImageRecognitionResult : NSObject
@property (nonatomic,strong)NSArray <QCloudBatchImageRecognitionResultItem *> * JobsDetail;
@end

@interface QCloudBatchImageRecognitionResultItem : NSObject

///  错误码，只有失败时返回。详情请查看 错误码列表。
@property (nonatomic,strong)NSString * Code;

///  错误描述，只有失败时返回。
@property (nonatomic,strong)NSString * Message;

///  图片标识，审核结果会返回原始内容，长度限制为512字节
@property (nonatomic,strong)NSString * DataId;

/// 审核任务的状态，值为 Submitted（已提交审核）、Failed（审核失败）其中一个。
@property (nonatomic,strong)NSString * State;

/// 任务id，用于获取审核结果
@property (nonatomic,strong)NSString * JobId;

/// 存储在 COS 存储桶中的图片文件名称，创建任务使用 Object 时返回。
@property (nonatomic,strong)NSString * Object;

/// 图片文件的链接地址，创建任务使用Url时返回。
@property (nonatomic,strong)NSString * Url;

/// 图片是否被压缩处理，值为 0（未压缩），1（正常压缩）。
@property (nonatomic,assign)NSInteger CompressionResult;

///  该字段用于返回检测结果中所对应的优先级最高的恶意标签，表示模型推荐的审核结果，建议您按照业务所需，对不同违规类型与建议值进行处理。 \
///  返回值：Normal：正常，Porn：色情，Ads：广告。
@property (nonatomic,strong)NSString * Label;

///  供参考的识别结果，0（正常），1（敏感），2（疑似敏感）
@property (nonatomic,assign)NSInteger  Result;

///  该字段表示审核结果命中审核信息的置信度，取值范围：0（置信度最低）-100（置信度最高 ），越高代表该内容越有可能属于当前返回审核信息
///  例如：色情 99，则表明该内容非常有可能属于色情内容
@property (nonatomic,assign)NSInteger Score;

///  该图命中的二级标签结果
@property (nonatomic,strong)NSString * SubLabel;

/// 该图命中的审核类别结果。
@property (nonatomic,strong)NSString * Category;

///  该图里的文字内容（OCR），当审核策略开启文本内容检测时返回
@property (nonatomic,strong)NSString * Text;

///  审核场景为涉黄的审核结果信息
@property (nonatomic,strong)QCloudBatchImageRecognitionResultInfo * PornInfo;

///  审核场景为广告引导的审核结果信息
@property (nonatomic,strong)QCloudBatchImageRecognitionResultInfo * AdsInfo;

/// 审核场景为涉暴恐的审核结果信息。
@property (nonatomic,strong)QCloudBatchImageRecognitionResultInfo * TerrorismInfo;

/// 审核场景为政治敏感的审核结果信息。
@property (nonatomic,strong)QCloudBatchImageRecognitionResultInfo * PoliticsInfo;

/// 请求中设置的 UserInfo 原样返回。
@property (nonatomic,strong)QCloudBatchRecognitionUserInfo *UserInfo;

/// 账号黑白名单结果。
@property (nonatomic,strong)QCloudBatchRecognitionListInfo *ListInfo;

/// 若您在请求时设置了自动冻结，该字段表示图片的冻结状态。0：未冻结，1：已被冻结。
@property (nonatomic,assign)NSInteger ForbidState;

@end

@interface QCloudBatchRecognitionListInfo : NSObject
@property(nonatomic,strong)NSArray <QCloudBatchRecognitionListInfoListResults *> * ListResults;
@end

@interface QCloudBatchRecognitionListInfoListResults : NSObject

/// 命中的名单类型，取值为0（白名单）和1（黑名单）。
@property (nonatomic,assign)NSInteger ListType;

/// 命中的名单名称。
@property (nonatomic,strong)NSString * ListName;

/// 命中了名单中的哪条内容。
@property (nonatomic,strong)NSString * Entity;
@end

@interface QCloudBatchImageRecognitionResultInfo : NSObject

///  单个审核场景的错误码，0为成功，其他为失败。详情请参见 错误码
@property (nonatomic,strong)NSString * Code;

///  具体错误信息，如正常则为 OK
@property (nonatomic,strong)NSString * Msg;

///  供参考的识别结果，0（正常），1（敏感），2（疑似敏感）
@property (nonatomic,assign)NSInteger HitFlag;

///  该字段表示审核结果命中审核信息的置信度，
///  取值范围：0（置信度最低）-100（置信度最高 ），越高代表该内容越有可能属于当前返回审核信息
///  例如：色情 99，则表明该内容非常有可能属于色情内容
@property (nonatomic,assign)NSInteger Score;

///  该图的结果标签（为综合标签，可能为 SubLabel，可能为人物名字等）
@property (nonatomic,strong)NSString * Label;

///  该图的二级标签结果
@property (nonatomic,strong)NSString * SubLabel;

///rray    该字段表示 OCR 文本识别的详细检测结果，包括文本坐标信息、文本识别结果等信息，有相关违规内容时返回。
@property (nonatomic,strong)NSArray <QCloudRecognitionOcrResults *>  * OcrResults;

/// 该字段用于返回基于风险库识别的结果。注意：未命中风险库中样本时，此字段不返回。
@property (nonatomic,strong)NSArray <QCloudImageRecognitionLibResults *> *LibResults;

@property (nonatomic,strong)NSArray <QCloudRecognitionObjectResults *>  * ObjectResults;

@end

@interface QCloudBatchRecognitionImageInfo : NSObject


///  存储在 COS 存储桶中的图片文件名称，
///  例如在目录 test 中的文件 image.jpg，则文件名称为 test/image.jpg。Object 和 Url 只能选择其中一种。
@property (nonatomic,strong)NSString * Object;

///  图片文件的链接地址，
///  例如 http://a-1250000.cos.ap-shanghai.myqcloud.com/image.jpg。Object 和 Url 只能选择其中一种。
@property (nonatomic,strong)NSString * Url;

/// 图片文件的内容，需要先经过 base64 编码。Content，Object 和 Url 只能选择其中一种，传入多个时仅一个生效，按 Content，Object， Url 顺序。
@property (nonatomic,strong)NSString * Content;

///  截帧频率，GIF 图检测专用，默认值为5，表示从第一帧（包含）开始每隔5帧截取一帧
@property (nonatomic,assign)NSInteger Interval;

///  最大截帧数量，GIF 图检测专用，默认值为5，表示只截取 GIF 的5帧图片进行审核，必须大于0
@property (nonatomic,assign)NSInteger MaxFrames;

///  图片标识，该字段在结果中返回原始内容，长度限制为512字节
@property (nonatomic,strong)NSString * DataId;

/// 对于超过大小限制的图片是否进行压缩后再审核，取值为： 0（不压缩），1（压缩）。默认为0。注：压缩最大支持32M的图片，且会收取压缩费用。
@property (nonatomic,assign)NSInteger LargeImageDetect;

@property (nonatomic,strong)QCloudBatchRecognitionUserInfo *UserInfo;

@property (nonatomic,strong)QCloudBatchRecognitionEncryption *Encryption;
@end

NS_ASSUME_NONNULL_END
