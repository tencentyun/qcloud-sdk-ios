//
//  QCloudRecognitionModel.h 
//  QCloudCOSXML
//
//  Created by garenwang on 2022/3/22.
//

#import <Foundation/Foundation.h>
#import "QCloudRecognitionModel.h"
@class QCloudRecognitionObjectResults;
@class QCloudRecognitionLocationInfo;
@class QCloudRecognitionLabelsItem;
@class QCloudRecognitionSectionItemLibResults;
@class QCloudRecognitionResultsItem;
NS_ASSUME_NONNULL_BEGIN


@interface QCloudRecognitionOcrResults : NSObject

///  图片 OCR 文本识别出的具体文本内容。    String
@property (nonatomic,strong)NSString *Text;

/// 该字段表示审核命中的具体子标签。注意：该字段可能返回空
@property (nonatomic,strong)NSString *SubLabel;

///  在当前审核场景下命中的关键词。    String Array
@property (nonatomic,strong)NSArray <NSString *> *Keywords;

///  该参数用于返回检测结果在图片中的位置（左上角 xy 坐标、长宽、旋转角度），以方便快速定位相关信息。
@property (nonatomic,strong)QCloudRecognitionLocationInfo * Location;

@end

@interface QCloudRecognitionObjectResults : NSObject

///  该标签用于返回所识别出的实体名称，例如人名。
@property (nonatomic,strong)NSString * Name;

/// 该字段表示审核命中的具体子标签。注意：该字段可能返回空。
@property (nonatomic,strong)NSString * SubLabel;

///  该参数用于返回检测结果在图片中的位置（左上角 xy 坐标、长宽、旋转角度），以方便快速定位相关信息。
@property (nonatomic,strong)QCloudRecognitionLocationInfo * Location;

@end

@interface QCloudRecognitionLocationInfo : NSObject

///  该参数用于返回检测框左上角位置的横坐标（x）所在的像素位置，结合剩余参数可唯一确定检测框的大小和位置。
@property (nonatomic,assign)CGFloat X;

///  该参数用于返回检测框左上角位置的纵坐标（y）所在的像素位置，结合剩余参数可唯一确定检测框的大小和位置。
@property (nonatomic,assign)CGFloat Y;

///  该参数用于返回检测框的高度（由左上角出发在 y 轴向下延伸的长度），结合剩余参数可唯一确定检测框的大小和位置。
@property (nonatomic,assign)CGFloat Height;

///  该参数用于返回检测框的宽度（由左上角出发在 x 轴向右延伸的长度），结合剩余参数可唯一确定检测框的大小和位置。
@property (nonatomic,assign)CGFloat Width;

///  该参数用于返回检测框的旋转角度，该参数结合 X 和 Y 两个坐标参数可唯一确定检测框的具体位置；取值：0-360（角度制），方向为逆时针旋转。
@property (nonatomic,assign)CGFloat Rotate;

@end


@interface QCloudRecognitionResultsItemInfo : NSObject

/// 是否命中该审核分类，0表示未命中，1表示命中，2表示疑似。
@property (nonatomic,strong)NSString * HitFlag;

/// 该字段表示审核结果命中审核信息的置信度，取值范围：0（置信度最低）-100（置信度最高 ），越高代表该内容越有可能属于当前返回审核信息
/// 例如：色情 99，则表明该内容非常有可能属于色情内容。
@property (nonatomic,strong)NSString * Score;

/// 命中的风险库名称。
@property (nonatomic,strong)NSString * LibName;

/// 命中的风险库类型，取值为1（预设黑白库）和2（自定义风险库）。
@property (nonatomic,strong)NSString * LibType;

/// 该字段表示审核命中的具体审核类别。例如 Moan，表示色情标签中的呻吟类别。注意：该字段可能返回空。
@property (nonatomic,strong)NSString * Category;

/// 在当前审核场景下命中的关键词。
@property (nonatomic,strong)NSArray <NSString *> * Keywords;

/// 该字段用于返回基于风险库识别的结果。注意：未命中风险库中样本时，此字段不返回。
@property (nonatomic,strong)NSArray <QCloudRecognitionSectionItemLibResults *> * LibResults;

@property (nonatomic,strong)NSArray <QCloudRecognitionResultsItem *> * SpeakerResults;

@property (nonatomic,strong)NSArray <QCloudRecognitionResultsItem *> * RecognitionResults;
/// 该字段表示审核命中的具体子标签，例如：Porn 下的 SexBehavior 子标签。注意：该字段可能返回空，表示未命中具体的子标签。
@property (nonatomic,strong)NSString * SubLabel;

@end


@interface QCloudRecognitionLabels : NSObject

/// 审核场景为涉黄的审核结果信息
@property (nonatomic,strong)QCloudRecognitionLabelsItem * PornInfo;

/// 审核场景为广告引导的审核结果信息
@property (nonatomic,strong)QCloudRecognitionLabelsItem * AdsInfo;

/// 审核场景为涉暴恐的审核结果信息。
@property (nonatomic,strong)QCloudRecognitionLabelsItem * TerrorismInfo;

/// 审核场景为政治敏感的审核结果信息。
@property (nonatomic,strong)QCloudRecognitionLabelsItem * PoliticsInfo;

@end

@interface QCloudRecognitionLabelsItem : NSObject

/// 是否命中该审核分类，0表示未命中，1表示命中，2表示疑似。
@property (nonatomic,assign)NSInteger HitFlag;

/// 该字段表示审核结果命中审核信息的置信度，取值范围：
/// 0（置信度最低）-100（置信度最高 ），越高代表该内容越有可能属于当前返回审核信息
/// 例如：色情 99，则表明该内容非常有可能属于色情内容
@property (nonatomic,assign)NSInteger Score;

@end


@interface QCloudRecognitionSectionItemInfo : NSObject

/// 是否命中该审核分类，0表示未命中，1表示命中，2表示疑似。
@property (nonatomic,strong)NSString * HitFlag;

/// 该字段表示审核结果命中审核信息的置信度，取值范围：0（置信度最低）-100（置信度最高 ），越高代表该内容越有可能属于当前返回审核信息
/// 例如：色情 99，则表明该内容非常有可能属于色情内容。
@property (nonatomic,strong)NSString * Score;

/// 在当前审核场景下命中的关键词。
@property (nonatomic,strong)NSArray * Keywords;

/// 表示命中的具体审核类别。例如 Sexy，表示色情标签中的性感类别。该字段可能为空，表示未命中或暂无相关的类别。
@property (nonatomic,strong)NSString * Category;

@property (nonatomic,strong)NSArray<QCloudRecognitionSectionItemLibResults *> * LibResults;

@end

@interface QCloudRecognitionSectionItemLibResults : NSObject

/// 命中的风险库类型，取值为1（预设风险库）和2（自定义风险库）。
@property (nonatomic,strong)NSString * LibType;

/// 命中的风险库名称。
@property (nonatomic,strong)NSString * LibName;

/// 命中的库中关键词。该参数可能会有多个返回值，代表命中的多个关键词。
@property (nonatomic,strong)NSArray * Keywords;
@end

@interface QCloudRecognitionItemInfo : NSObject

/// 是否命中该审核分类，0表示未命中，1表示命中，2表示疑似。
@property (nonatomic,strong)NSString * HitFlag;

/// 命中该审核分类的分片数。
@property (nonatomic,strong)NSString * Count;

@end

@interface QCloudRecognitionResultsItem : NSObject

/// 该字段表示对应的识别结果类型信息。
/// LanguageResults 的 Label 取值含义：
///
/// | 值      | 含义   |
/// | :------ | :----- |
/// | cmn     | 普通话 |
/// | en      | 英语   |
/// | yue     | 粤语   |
/// | ja      | 日语   |
/// | ko      | 韩语   |
/// | mn      | 蒙语   |
/// | bo      | 藏语   |
/// | ug      | 维语   |
/// | dialect | 方言   |
@property (nonatomic,strong)NSString * Label;

/// 该字段表示审核结果命中审核信息的置信度，取值范围：0（**置信度最低**）-100（**置信度最高** ），越高代表音频越有可能属于当前返回的标签。
@property (nonatomic,assign)NSInteger Score;

/// 该字段表示对应标签的片段在音频文件内的开始时间，单位为毫秒。注意：此字段可能未返回，表示取不到有效值。
@property (nonatomic,assign)NSInteger StartTime;

/// 该字段表示对应标签的片段在音频文件内的结束时间，单位为毫秒。注意：此字段可能未返回，表示取不到有效值。
@property (nonatomic,assign)NSInteger EndTime;

@end

@interface QCloudBatchRecognitionEncryption : NSObject
/// Request.Input.Encryption | 当前支持`aes-256-ctr、aes-256-cfb、aes-256-ofb、aes-192-ctr、aes-192-cfb、aes-192-ofb、aes-128-ctr、aes-128-cfb、aes-128-ofb`，不区分大小写。以`aes-256-ctr`为例，`aes`代表加密算法，`256`代表密钥长度，`ctr`代表加密模式。
@property (nonatomic,strong)NSString * Algorithm;

/// 文件加密使用的密钥的值，需进行 Base64 编码。当KeyType值为1时，需要将Key进行指定的加密后再做Base64 编码。Key的长度与使用的算法有关，详见`Algorithm`介绍，如：使用`aes-256-ctr`算法时，需要使用256位密钥，即32个字节。
@property (nonatomic,strong)NSString * Key;

/// 初始化向量，需进行 Base64 编码。AES算法要求IV长度为128位，即16字节
@property (nonatomic,strong)NSString * IV;

/// 当KeyType值为1时，该字段表示RSA加密密钥的版本号，当前支持`1.0`。默认值为`1.0`。
@property (nonatomic,strong)NSString * KeyId;

/// 指定加密算法的密钥（参数Key）的传输模式，有效值：0（明文传输）、1（RSA密文传输，使用OAEP填充模式），默认值为0。
@property (nonatomic,strong)NSString * KeyType;
@end

NS_ASSUME_NONNULL_END
