//
//  QCloudRecognitionModel.h
//  QCloudCOSXML
//
//  Created by garenwang on 2022/3/22.
//

#import <Foundation/Foundation.h>

@class QCloudRecognitionObjectResults;
@class QCloudRecognitionLocationInfo;
@class QCloudRecognitionLabelsItem;
@class QCloudRecognitionSectionItemLibResults;
NS_ASSUME_NONNULL_BEGIN


@interface QCloudRecognitionOcrResults : NSObject

///  图片 OCR 文本识别出的具体文本内容。    String
@property (nonatomic,strong)NSString *Text;

///  在当前审核场景下命中的关键词。    String Array
@property (nonatomic,strong)NSArray <NSString *> *Keywords;

///  该参数用于返回检测结果在图片中的位置（左上角 xy 坐标、长宽、旋转角度），以方便快速定位相关信息。
@property (nonatomic,strong)QCloudRecognitionLocationInfo * Location;

@end

@interface QCloudRecognitionObjectResults : NSObject

///  该标签用于返回所识别出的实体名称，例如人名。
@property (nonatomic,strong)NSString * Name;

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

/// 在当前审核场景下命中的关键词。
@property (nonatomic,strong)NSArray <NSString *> * Keywords;
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

NS_ASSUME_NONNULL_END
