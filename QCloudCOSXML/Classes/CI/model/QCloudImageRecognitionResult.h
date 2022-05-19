//
//  QCloudImageRecognitionResult.h
//  QCloudCOSXML
//
//  Created by tencent
//  Copyright (c) 2020年 tencent. All rights reserved.
//
//   ██████╗  ██████╗██╗      ██████╗ ██╗   ██╗██████╗     ████████╗███████╗██████╗ ███╗   ███╗██╗███╗   ██╗ █████╗ ██╗         ██╗      █████╗
//   ██████╗
//  ██╔═══██╗██╔════╝██║     ██╔═══██╗██║   ██║██╔══██╗    ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║████╗  ██║██╔══██╗██║         ██║ ██╔══██╗██╔══██╗
//  ██║   ██║██║     ██║     ██║   ██║██║   ██║██║  ██║       ██║   █████╗  ██████╔╝██╔████╔██║██║██╔██╗ ██║███████║██║         ██║ ███████║██████╔╝
//  ██║▄▄ ██║██║     ██║     ██║   ██║██║   ██║██║  ██║       ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║██║╚██╗██║██╔══██║██║         ██║ ██╔══██║██╔══██╗
//  ╚██████╔╝╚██████╗███████╗╚██████╔╝╚██████╔╝██████╔╝       ██║   ███████╗██║  ██║██║ ╚═╝ ██║██║██║ ╚████║██║  ██║███████╗    ███████╗██║
//  ██║██████╔╝
//   ╚══▀▀═╝  ╚═════╝╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝        ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝    ╚══════╝╚═╝ ╚═╝╚═════╝
//
//
//                                                                              _             __                 _                _
//                                                                             (_)           / _|               | |              | |
//                                                          ___  ___ _ ____   ___  ___ ___  | |_ ___  _ __    __| | _____   _____| | ___  _ __   ___ _
//                                                          __ ___
//                                                         / __|/ _ \ '__\ \ / / |/ __/ _ \ |  _/ _ \| '__|  / _` |/ _ \ \ / / _ \ |/ _ \| '_ \ / _ \
//                                                         '__/ __|
//                                                         \__ \  __/ |   \ V /| | (_|  __/ | || (_) | |    | (_| |  __/\ V /  __/ | (_) | |_) |  __/
//                                                         |  \__
//                                                         |___/\___|_|    \_/ |_|\___\___| |_| \___/|_|     \__,_|\___| \_/ \___|_|\___/| .__/
//                                                         \___|_|  |___/
//    ______ ______ ______ ______ ______ ______ ______ ______                                                                            | |
//   |______|______|______|______|______|______|______|______|                                                                           |_|
//

#import <Foundation/Foundation.h>
#import "QCloudRecognitionModel.h"
@class QCloudImageRecognitionResultInfo;
NS_ASSUME_NONNULL_BEGIN

@interface QCloudImageRecognitionResult : NSObject

///  图片审核的任务 ID，您可以通过该 ID 主动查询图片审核结果。
@property (nonatomic,strong)NSString *JobId;

///  该字段表示本次判定的审核结果，您可以根据该结果，进行后续的操作；建议您按照业务所需，对不同的审核结果进行相应处理。
///  有效值：0（审核正常），1 （判定为违规敏感文件），2（疑似敏感，建议人工复核）
@property (nonatomic,assign)NSInteger Result;

///  该字段用于返回检测结果中所对应的优先级最高的恶意标签，表示模型推荐的审核结果，建议您按照业务所需，对不同违规类型与建议值进行处理。
///  返回值：Normal 表示正常，Porn 表示色情，Ads 表示广告，以及其他不安全或不适宜的类型。
@property (nonatomic,strong)NSString *Label;

///  该图命中的二级标签结果
@property (nonatomic,strong)NSString *SubLabel;

///  该字段表示审核结果命中审核信息的置信度，取值范围：0（置信度最低）-100（置信度最高 ），越高代表该内容越有可能属于当前返回审核信息
///  例如：色情 99，则表明该内容非常有可能属于色情内容
@property (nonatomic,assign)NSInteger Score;

///  该图里的文字内容（OCR），当审核策略开启文本内容检测时返回
@property (nonatomic,strong)NSString *Text;

///  审核场景为涉黄的审核结果信息
@property (nonatomic,strong)QCloudImageRecognitionResultInfo *PornInfo;

///  审核场景为广告引导的审核结果信息
@property (nonatomic,strong)QCloudImageRecognitionResultInfo *AdsInfo;

///  审核场景为涉暴恐的审核结果信息。
@property (nonatomic,strong)QCloudImageRecognitionResultInfo *TerrorismInfo;

///  审核场景为政治敏感的审核结果信息。
@property (nonatomic,strong)QCloudImageRecognitionResultInfo *PoliticsInfo;

///  该参数表示当前图片是否被压缩处理过，
///  值为 0（未经过压缩处理），1（已经过压缩处理）。
@property (nonatomic,assign)NSInteger CompressionResult;
@end

@interface QCloudImageRecognitionResultInfo : NSObject

///  错误码，0为正确，其他数字对应相应错误。详情请参见 错误码
@property (nonatomic,assign)NSInteger Code;

///  具体错误信息，如正常则为 OK
@property (nonatomic,strong)NSString *Msg;

///  是否命中该审核分类，0表示未命中，1表示命中，2表示疑似
@property (nonatomic,assign)NSInteger HitFlag;

///  该字段表示审核结果命中审核信息的置信度，取值范围：0（置信度最低）-100（置信度最高），越高代表该内容越有可能属于当前返回审核信息。
///  其中0 - 60分表示图片正常，61 - 90分表示图片疑似敏感，91 - 100分表示图片确定敏感
///  例如：色情 99，则表明该内容非常有可能属于色情内容
@property (nonatomic,assign)NSInteger Score;

///  该字段表示该截图的综合结果标签（可能为 SubLabel，可能为人物名字等）
@property (nonatomic,strong)NSString *Label;

///  该字段表示审核命中的具体子标签，例如：Porn 下的 SexBehavior 子标签。注意：该字段可能返回空，表示未命中具体的子标签
@property (nonatomic,strong)NSString *SubLabel;

///  该字段表示 OCR 文本识别的详细检测结果，包括文本识别结果、命中的关键词等信息，有相关违规内容时返回
@property (nonatomic,strong)NSArray <QCloudRecognitionOcrResults *> *OcrResults;

@property (nonatomic,strong)NSArray <QCloudRecognitionObjectResults *> *ObjectResults;
@end

NS_ASSUME_NONNULL_END
