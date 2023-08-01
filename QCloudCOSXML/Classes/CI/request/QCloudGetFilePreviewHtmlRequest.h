//
//  QCloudGetFilePreviewHtmlRequest.h
//  QCloudGetFilePreviewHtmlRequest
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
#import "QCloudGetFilePreviewHtmlResult.h"
NS_ASSUME_NONNULL_BEGIN

/**
 COS 文档预览方法.

 ### 功能描述

 文档 HTML 预览功能支持对多种文件类型生成 HTML 格式预览，可以解决文档内容的页面展示问题，满足 PC、App 等多个用户端的文档在线浏览需求，适用于在线教育、企业 OA、网站转码等业务场景。

 ### 示例

  @code

    QCloudGetFilePreviewHtmlRequest *request = [[QCloudGetFilePreviewHtmlRequest alloc]init];
    request.bucket = @"桶名称";
    request.object = 文件名;
    request.regionName = 桶所属区域;
    request.htmlwaterword = @"测试文字";
    [request setFinishBlock:^(QCloudGetFilePreviewHtmlResult * _Nullable result, NSError * _Nullable error) {
         if (error) {
             
         }else{
             NSDictionary * dicResult = [NSJSONSerialization JSONObjectWithData:result.resultData options:NSJSONReadingMutableContainers error:nil];
             // dicResult[@"PreviewUrl"] 为预览链接，可以用webview打开。
         }
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetFilePreviewObject:request];

*/

@interface QCloudGetFilePreviewHtmlRequest : QCloudBizHTTPRequest

/**
 对象名
 */
@property (strong, nonatomic) NSString *object;

/**
存储桶名
*/
@property (strong, nonatomic) NSString *bucket;

/**
 指定 Object 的 VersionID (在开启多版本的情况下)
 */
@property (strong, nonatomic) NSString *versionID;

/**
 转换输出目标文件类型，文档 HTML 预览固定为 html（需为小写字母）
 */
@property (copy, nonatomic) NSString *dstType;

/**
 是否获取预览链接。如需获取，填入值为1；否则直接预览
 */
@property (assign, nonatomic)BOOL weboffice_url;

/**
 是否禁用可复制。默认为不禁用可复制
 */
@property (assign, nonatomic)BOOL disCopyable;

/**
 水印文字，默认为空
 */
@property (strong, nonatomic)NSString * htmlwaterword;

/**
 水印 RGBA（颜色和透明度），需要经过 URL 安全 的 Base64 编码，默认为：rgba(192,192,192,0.6)
 */
@property (strong, nonatomic)NSString * htmlfillstyle;

/**
 水印文字样式  bold 20px Serif 默认
 */
@property (strong, nonatomic)NSString * htmlfront;

/**
 旋转角度，0~360
 */
@property (assign, nonatomic)NSInteger htmlrotate;

/**
 水印文字水平间距，单位 px
 */
@property (assign, nonatomic)NSInteger htmlhorizontal;

/**
 水印文字垂直间距，单位 px
 */
@property (assign, nonatomic)NSInteger htmlvertical;


/**
 @param QCloudRequestFinishBlock 返回图片回调
 */
- (void)setFinishBlock:(void (^_Nullable)(QCloudGetFilePreviewHtmlResult *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;

@end
NS_ASSUME_NONNULL_END
