//
//  QCloudCIOCRRequest.h
//  QCloudCIOCRRequest
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
#import "QCloudBodyRecognitionResult.h"
#import "QCloudOCRTypeEnum.h"
#import "QCloudCIOCRResult.h"
NS_ASSUME_NONNULL_BEGIN
/**
 通用文字识别
 
 通用文字识别功能（Optical Character Recognition，OCR）基于行业前沿的深度学习技术，将图片上的文字内容，
 智能识别为可编辑的文本，可应用于随手拍扫描、纸质文档电子化、电商广告审核等多种场景，大幅提升信息处理效率。

 本接口属于 GET 请求，为同步请求方式。
 
 查看更多：https://cloud.tencent.com/document/product/436/64324
 
 ### 示例

   @code
 
     QCloudCIOCRRequest * request = [QCloudCIOCRRequest new];
     request.regionName = @"regionName";
     // 对象键，是对象在 COS 上的完整路径，如果带目录的话，格式为 "dir1/object1"
     request.object = @"exampleobject";
     // 存储桶名称，格式为 BucketName-APPID
     request.bucket = @"examplebucket-1250000000";
     [request setFinishBlock:^(QCloudCIOCRResult * _Nullable result, NSError * _Nullable error) {
         
     }];
     [[QCloudCOSXMLService defaultCOSXML] OCR:request];
*/
@interface QCloudCIOCRRequest: QCloudBizHTTPRequest

/**
 存储桶名称
*/
@property (strong, nonatomic) NSString *bucket;

/**
 对象文件名，例如：folder/document.jpg。
*/
@property (strong, nonatomic) NSString *object;

/**
 OCR 的识别类型，有效值为 general，accurate，efficient，fast，handwriting。
 general 表示通用印刷体识别；
 accurate 表示印刷体高精度版；
 efficient 表示印刷体精简版；
 fast 表示印刷体高速版；
 handwriting 表示手写体识别。
 默认值为 general。
 */
@property (assign, nonatomic) QCloudOCRTypeEnum type;

/**
 查看支持的语言类型
 https://cloud.tencent.com/document/product/460/63227#language-type
 */
@property (strong, nonatomic) NSString * languageType;

/**
 type 值为 general、fast 时有效，表示是否开启 PDF 识别，有效值为 true 和 false，默认值为 false，开启后可同时支持图片和 PDF 的识别。
 */
@property (assign, nonatomic) BOOL ispdf;

/**
 type 值为 general、fast 时有效，表示需要识别的 PDF 页面的对应页码，仅支持 PDF 单页识别，当上传文件为 PDF 且 ispdf 参数值为 true 时有效，默认值为1。
 */
@property (assign, nonatomic) NSInteger pdfPagenumber;

/**
 type 值为 general、accurate 时有效，表示识别后是否需要返回单字信息，有效值为 true 和 false，默认为 false。
 */
@property (assign, nonatomic) BOOL isword;

/**
 type 值为 handwriting 时有效，表示是否开启单字的四点定位坐标输出，有效值为 true 和 false，默认值为 false。
 */
@property (assign, nonatomic) BOOL enableWordPolygon;

- (void) setFinishBlock:(void (^_Nullable)(QCloudCIOCRResult * _Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
