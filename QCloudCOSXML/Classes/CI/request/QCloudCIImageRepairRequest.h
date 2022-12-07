//
//  QCloudCIImageRepairRequest.h
//  QCloudCIImageRepairRequest
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
/**
图像修复.

腾讯云数据万象通过 ImageRepair 接口检测图片中的水印并将其擦除。
查看更多：https://cloud.tencent.com/document/product/436/79043

待处理的图片，原图大小不超过32MB。
宽高不超过50000像素且总像素不超过2.5亿像素，处理结果图宽高设置不超过9999像素。

cos iOS SDK 盲水印上传请求的方法具体步骤如下：

1. 实例化 QCloudCIImageRepairRequest，填入需要的参数。

2. 调用 QCloudCOSXMLService 对象中的 ImageRepair 方法发出请求。

4. 从回调的 finishBlock 中的 outputObject 获取具体内容。

### 示例

  @code

     QCloudCIImageRepairRequest * request = [[QCloudCIImageRepairRequest alloc]init];
     request.regionName = @"regionName";
     // 对象键，是对象在 COS 上的完整路径，如果带目录的话，格式为 "dir1/object1"
     request.object = @"exampleobject";
     // 存储桶名称，格式为 BucketName-APPID
     request.bucket = @"examplebucket-1250000000";
     request.maskPic = @"http://test.png";
     request.maskPoly = @[@[@[@1,@3],@[@4,@3],@[@8,@3]],@[@[@40,@30],@[@19,@3],@[@20,@30]]];
     [request setFinishBlock:^(NSString * _Nullable result, NSError * _Nullable error) {
         
     }];
     [[QCloudCOSXMLService defaultCOSXML] ImageRepair:request];

*/
@interface QCloudCIImageRepairRequest: QCloudBizHTTPRequest
/**
存储桶名称
*/
@property (strong, nonatomic) NSString *bucket;
/**
要识别的对象
*/
@property (strong, nonatomic) NSString *object;

/**
 例如：[[[608, 794], [1024, 794], [1024, 842], [608, 842]],[[1295, 62], [1295, 30], [1597, 32],[1597, 64]]] ，顺时针输入多边形的每个点的坐标,每个多边形: [[x1, y1], [x2, y2]...], 形式为三维矩阵（多个多边形：[多边形1, 多边形2]）或二维矩阵（单个多边形）MaskPoly 同时与 MaskPic 填写时，优先采用 MaskPic 的值。
 */
@property (strong, nonatomic) NSArray *maskPoly;

/**
 遮罩（白色区域为需要去除的水印位置）图片地址，
 */
@property (strong, nonatomic) NSString *maskPic;

- (void) setFinishBlock:(void (^_Nullable)(NSString*_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
