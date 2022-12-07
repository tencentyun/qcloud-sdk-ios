//
//  QCloudCIDetectCarResult.h
//  QCloudCIDetectCarResult
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

@interface QCloudCIDetectCarPlateLocation : NSObject

@property (nonatomic,assign)NSInteger X;

@property (nonatomic,assign)NSInteger Y;
@end



@interface QCloudCIDetectCarPlateContent: NSObject

///     PlateContent    车牌号信息    String
@property (nonatomic,strong)NSString *Plate;

///     PlateContent    车牌的颜色    String
@property (nonatomic,strong)NSString *Color;

///     PlateContent    车牌的种类，例如普通蓝牌    String
@property (nonatomic,strong)NSString *Type;

///     PlateContent    车牌的位置    Container
@property (nonatomic,strong)QCloudCIDetectCarPlateLocation *PlateLocation;

@end


@interface QCloudCIDetectCarTags : NSObject

/// CarTags    车系    String
@property (nonatomic,strong)NSString *Serial;

/// CarTags    车辆品牌    String
@property (nonatomic,strong)NSString *Brand;

/// CarTags    车辆类型    String
@property (nonatomic,strong)NSString *Type;

/// CarTags    车辆颜色    String
@property (nonatomic,strong)NSString *Color;

/// CarTags    置信度，0 - 100    Int
@property (nonatomic,assign)NSInteger Confidence;

/// CarTags    年份，识别不出年份时返回0    Int
@property (nonatomic,assign)NSInteger Year;

/// CarTags    车辆在图片中的坐标信息，可能返回多个坐标点的值    Container
@property (nonatomic,strong)NSArray<QCloudCIDetectCarPlateLocation *> *CarLocation;

/// CarTags    车牌信息，包含车牌号、车牌颜色、车牌位置。支持返回多个车牌    Container
@property (nonatomic,strong)NSArray <QCloudCIDetectCarPlateContent *> *PlateContent;

@end

@interface QCloudCIDetectCarResult : NSObject

///  Response    检测到的文本信息，包括文本行内容、置信度、文本行坐标以及文本行旋转纠正后的坐标。    Container
@property (nonatomic,strong)QCloudCIDetectCarTags * CarTags;

///  Response    唯一请求 ID，每次请求都会返回。定位问题时需要提供该次请求的 RequestId。    String
@property (nonatomic,strong)NSString * RequestId;

@end
NS_ASSUME_NONNULL_END
