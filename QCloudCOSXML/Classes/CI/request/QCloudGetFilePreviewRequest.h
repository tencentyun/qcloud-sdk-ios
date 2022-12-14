//
//  QCloudGetFilePreviewRequest.h
//  QCloudGetFilePreviewRequest
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
#import <QCloudCore/QCloudCore.h>
@class QCloudGetFilePreviewResult;
NS_ASSUME_NONNULL_BEGIN

/**
 COS 文档预览方法.

 ### 功能描述

 文档预览功能支持对多种文件类型生成图片格式预览，可以解决文档内容的页面展示问题，
 满足 PC、App 等多个用户端的文档在线浏览需求，适用于在线教育、企业 OA、网站转码等业务场景。

 ### 示例

  @code

    QCloudGetFilePreviewRequest *request = [[QCloudGetFilePreviewRequest alloc]init];
    request.bucket = @"examplebucket-1250000000";
    request.object = 文件名;
    request.page = 页码;
    request.regionName = 桶所属区域;
    [request setFinishBlock:^(NSDictionary * _Nullable result, NSError * _Nullable error) {
        返回一个字典 包含总页数，文件data
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetFilePreviewObject:request];

*/

@interface QCloudGetFilePreviewRequest : QCloudBizHTTPRequest

/**
 指定 Object 的 VersionID (在开启多版本的情况下)
 */
@property (strong, nonatomic) NSString *versionID;
/**
 对象名
 */
@property (strong, nonatomic) NSString *object;

/**
存储桶名
*/
@property (strong, nonatomic) NSString *bucket;

/// 源数据的后缀类型，当前文档转换根据 COS 对象的后缀名来确定源数据类型。当 COS 对象没有后缀名时，
/// 可以设置该值
@property (copy, nonatomic) NSString *srcType;

/**
 转换输出目标文件类型：
 png，转成 png 格式的图片文件
 jpg，转成 jpg 格式的图片文件
 pdf，转成 pdf 格式文件。 无法选择页码，page 参数不生效
 如果传入的格式未能识别，默认使用 jpg 格式
 */
@property (copy, nonatomic) NSString *dstType;

/**
 Office 文档的打开密码，如果需要转换有密码的文档，请设置该字段
 */
@property (copy, nonatomic) NSString *password;

/// 需转换的文档页码，从1开始计数
@property (assign, nonatomic) NSInteger page;

/**
 是否隐藏批注和应用修订，默认为0
 0：隐藏批注，应用修订
 1：显示批注和修订
 */
@property (copy, nonatomic) NSString * comment;

/****适用于表格文件（Excel）的参数***/

/**
 表格文件参数，转换第 X 个表，默认为1
 */
@property (copy, nonatomic) NSString * sheet;

/**
 表格文件转换纸张方向，0代表垂直方向，非0代表水平方向，默认为0
 */
@property (copy, nonatomic) NSString * excelPaperDirection;

/**
 设置纸张（画布）大小，对应信息为： 0 → A4 、 1 → A2 、 2 → A0 ，默认 A4 纸张 （需配合 excelRow 或 excelCol 一起使用）
 */
@property (copy, nonatomic) NSString * excelPaperSize;


/****适用于转码成 png/jpg 图片的参数***/

/**
 转换后的图片处理参数，支持 基础图片处理 所有处理参数，多个处理参数可通过 管道操作符 分隔，从而实现在一次访问中按顺序对图片进行不同处理
 */
@property (copy, nonatomic) NSString *ImageParams;

/**
 生成预览图的图片质量，取值范围为 [1, 100]，默认值100。 例如取值为100，代表生成图片质量为100%
 */
@property (copy, nonatomic) NSString * quality;

/**
 预览图片的缩放参数，取值范围为 [10, 200]， 默认值100。 例如取值为200，代表图片缩放比例为200% 即放大两倍
 */
@property (copy, nonatomic) NSString * scale;

/**
 按指定 dpi 渲染图片，该参数与 scale 共同作用，取值范围 96-600 ，默认值为 96 。转码后的图片单边宽度需小于65500像素
 */
@property (copy, nonatomic) NSString * imageDpi;

/**

 @param QCloudRequestFinishBlock 返回图片回调
 */
- (void)setFinishBlock:(void (^_Nullable)(QCloudGetFilePreviewResult *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;

@end
NS_ASSUME_NONNULL_END
