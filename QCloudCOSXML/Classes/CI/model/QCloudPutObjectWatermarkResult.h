//
//  QCloudPutObjectWatermarkResult.h 
//  QCloudPutObjectWatermarkResult
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
@class QCloudPutObjectOriginalInfo;
@class QCloudPutObjectProcessResults;
@class QCloudPutObjectImageInfo;
@class QCloudPutObjectObj;
#import "QCloudCIQRcodeInfo.h"

NS_ASSUME_NONNULL_BEGIN
/**
 设置图片盲水印请求的返回结果
 */
@interface QCloudPutObjectWatermarkResult : NSObject

/**
 原图信息
 */
@property (nonatomic, strong) QCloudPutObjectOriginalInfo *originalInfo;

/**
 图片处理结果
 */
@property (nonatomic, strong) QCloudPutObjectProcessResults *processResults;

@end

/**
 原图信息
 */
@interface QCloudPutObjectOriginalInfo : NSObject

/// 原图文件名
@property (nonatomic, copy) NSString *key;

/// 图片路径
@property (nonatomic, copy) NSString *location;

/// 原图图片信息
@property (nonatomic, strong) QCloudPutObjectImageInfo *imageInfo;

/// 原图 ETag 信息（若处理结果图覆盖原图则为结果图 ETag 信息）
@property (nonatomic, copy) NSString *ETag;

@end

/**
 图片处理结果
 */
@interface QCloudPutObjectProcessResults : NSObject
/**
 图片处理结果
*/
@property (nonatomic, strong) NSArray <QCloudPutObjectObj *> *Object;

@end

/**
每一个图片处理结果
*/
@interface QCloudPutObjectObj : NSObject

/// 文件名
@property (nonatomic, copy) NSString *key;

/// 图片路径
@property (nonatomic, copy) NSString *location;

/// 格式
@property (nonatomic, copy) NSString *format;

/// 图片宽度
@property (nonatomic, assign) NSInteger width;

/// 图片高度
@property (nonatomic, assign) NSInteger height;

/// 图片质量
@property (nonatomic, assign) NSInteger quality;

/// 图片大小
@property (nonatomic, assign) NSInteger Size;

/// 处理结果图 ETag 信息
@property (nonatomic, copy) NSString *ETag;

/// 图片的帧数。静态图为1，动图为对应的帧数.
@property (nonatomic, assign) NSInteger FrameCount;

/// 二维码识别结果。0表示未识别到二维码，1表示识别到二维码
@property (nonatomic,assign) NSInteger CodeStatus;

/// 二维码识别结果，可能有多个
@property (nonatomic,strong) NSArray<QCloudCIQRcodeInfo *> * QRcodeInfo;

@end

/// 原图图片信息
@interface QCloudPutObjectImageInfo : NSObject
/// 格式
@property (nonatomic, copy) NSString *format;

/// 图片宽度
@property (nonatomic, assign) NSInteger width;

/// 图片高度
@property (nonatomic, assign) NSInteger height;

/// 图片质量
@property (nonatomic, assign) NSInteger quality;

/// 图片主色调
@property (nonatomic, copy) NSString *ave;

/// 图片旋转角度
@property (nonatomic, assign) NSInteger orientation;

/// 图片的帧数。静态图为1，动图为对应的帧数.
@property (nonatomic, assign) NSInteger FrameCount;
@end

NS_ASSUME_NONNULL_END

