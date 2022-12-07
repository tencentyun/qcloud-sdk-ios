//
//  QCloudCIOCRResult.h
//  QCloudCIOCRResult
//
//  Created by tencent
//  Copyright (c) 2015年 tencent. All rights reserved.
//
//   ██████╗  ██████╗██╗      ██████╗ ██╗   ██╗██████╗     ████████╗███████╗██████╗ ███╗   ███╗██╗███╗   ██╗ █████╗ ██╗         ██╗      █████╗ ██████╗
//  ██╔═══██╗██╔════╝██║     ██╔═══██╗██║   ██║██╔══██╗    ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║████╗  ██║██╔══██╗██║         ██║     ██╔══██╗██╔══██╗
//  ██║   ██║██║     ██║     ██║   ██║██║   ██║██║  ██║       ██║   █████╗  ██████╔╝██╔████╔██║██║██╔██╗ ██║███████║██║         ██║     ███████║██████╔╝
//  ██║▄▄ ██║██║     ██║     ██║   ██║██║   ██║██║  ██║       ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║██║╚██╗██║██╔══██║██║         ██║     ██╔══██║██╔══██╗
//  ╚██████╔╝╚██████╗███████╗╚██████╔╝╚██████╔╝██████╔╝       ██║   ███████╗██║  ██║██║ ╚═╝ ██║██║██║ ╚████║██║  ██║███████╗    ███████╗██║  ██║██████╔╝
//   ╚══▀▀═╝  ╚═════╝╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝        ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝    ╚══════╝╚═╝  ╚═╝╚═════╝
//
//
//                                                                              _             __                 _                _
//                                                                             (_)           / _|               | |              | |
//                                                          ___  ___ _ ____   ___  ___ ___  | |_ ___  _ __    __| | _____   _____| | ___  _ __   ___ _ __ ___
//                                                         / __|/ _ \ '__\ \ / / |/ __/ _ \ |  _/ _ \| '__|  / _` |/ _ \ \ / / _ \ |/ _ \| '_ \ / _ \ '__/ __|
//                                                         \__ \  __/ |   \ V /| | (_|  __/ | || (_) | |    | (_| |  __/\ V /  __/ | (_) | |_) |  __/ |  \__
//                                                         |___/\___|_|    \_/ |_|\___\___| |_| \___/|_|     \__,_|\___| \_/ \___|_|\___/| .__/ \___|_|  |___/
//    ______ ______ ______ ______ ______ ______ ______ ______                                                                            | |
//   |______|______|______|______|______|______|______|______|                                                                           |_|
//



#import <Foundation/Foundation.h>
#import <QCloudCore/QCloudCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface QCloudCIOCRItemPolygon : NSObject

@property (nonatomic,assign)NSInteger X;

@property (nonatomic,assign)NSInteger Y;

@property (nonatomic,assign)NSInteger Width;

@property (nonatomic,assign)NSInteger Height;
@end

@interface QCloudCIOCRPolygon : NSObject

@property (nonatomic,assign)NSInteger X;

@property (nonatomic,assign)NSInteger Y;
@end

@interface QCloudCIOCRWordPolygon : NSObject

///     WordPolygon    左上顶点坐标。    Container
@property (nonatomic,strong)QCloudCIOCRPolygon * LeftTop;

///     WordPolygon    右上顶点坐标。    Container
@property (nonatomic,strong)QCloudCIOCRPolygon * RightTop;

///     WordPolygon    右下顶点坐标。    Container
@property (nonatomic,strong)QCloudCIOCRPolygon * RightBottom;

///     WordPolygon    左下顶点坐标。    Container
@property (nonatomic,strong)QCloudCIOCRPolygon * LeftBottom;
@end

@interface QCloudCIOCRWordCoordPoint : NSObject

/// 单字在原图中的坐标，以四个顶点坐标表示，以左上角为起点，顺时针返回。
@property (nonatomic,strong)QCloudCIOCRPolygon * WordCoordinate;

@end


@interface QCloudCIOCRWords : NSObject

/// 单字在原图中的四点坐标，支持识别的接口：general、accurate。
@property (nonatomic,strong)QCloudCIOCRWordCoordPoint * WordCoordPoint;

/// 识别出来的单词信息。
@property (nonatomic,strong)NSString * Character;

/// 置信度 0 - 100。
@property (nonatomic,assign)NSInteger Confidence;

@end


@interface QCloudCIOCRTextDetections : NSObject

/// TextDetections    识别出的文本行内容。    String
@property (nonatomic,strong)NSString * DetectedText;

/// TextDetections    置信度 0 - 100。    Integer
@property (nonatomic,assign)NSInteger Confidence;

/// TextDetections    文本行坐标，以顶点坐标表示 注意：此字段可能返回 null，表示取不到有效值。    Container
@property (nonatomic,strong)NSArray <QCloudCIOCRPolygon *> * Polygon;

/// TextDetections    文本行在旋转纠正之后的图像中的像素坐标，表示为（左上角 x, 左上角 y，宽 width，高 height）。
@property (nonatomic,strong)QCloudCIOCRItemPolygon * ItemPolygon;

/// TextDetections    识别出来的单字信息包括单字（包括单字 Character 和单字置信度 confidence），支持识别的接口：general、accurate。
@property (nonatomic,strong)NSArray <QCloudCIOCRWords *> * Words;

/// TextDetections    字的坐标数组，以四个顶点坐标表示。
/// 注意：此字段可能返回 null，表示取不到有效值。支持识别的类型：handwriting。
@property (nonatomic,strong)QCloudCIOCRWordPolygon * WordPolygon;

@end

@interface QCloudCIOCRResult : NSObject

///  Response    检测到的文本信息，包括文本行内容、置信度、文本行坐标以及文本行旋转纠正后的坐标。    Container
@property (nonatomic,strong)NSArray<QCloudCIOCRTextDetections *> * TextDetections;

///  Response    检测到的语言类型，目前支持的语言类型可参考入参 language-type 说明。    String
@property (nonatomic,strong)NSString * Language;

///  Response    图片旋转角度（角度制），文本的水平方向为0°；顺时针为正，逆时针为负。    Float
@property (nonatomic,assign)CGFloat Angel;

///  Response    图片为 PDF 时，返回 PDF 的总页数，默认为0。    Integer
@property (nonatomic,assign)NSInteger PdfPageSize;

///  Response    唯一请求 ID，每次请求都会返回。定位问题时需要提供该次请求的 RequestId。    String
@property (nonatomic,strong)NSString * RequestId;

@end
NS_ASSUME_NONNULL_END
