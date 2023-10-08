//
//  QCloudCIUploadOperationsRequest.h
//  QCloudCIUploadOperationsRequest
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
#import "QCloudCOSStorageClassEnum.h"
#import "QCloudPicOperations.h"

NS_ASSUME_NONNULL_BEGIN
/**
 图片处理机制介绍-上传时处理.

 上传时处理功能可以帮助使用者在上传时实现图片处理。您只需要在请求包头部中加入 Pic-Operations 项并设置好相应的 图片处理参数，就可在图片上传时实现相应的图片处理，并可将原图和处理结果存入到 COS。目前支持32M以内的图片处理。

 https://cloud.tencent.com/document/product/460/18147#.E8.AF.B7.E6.B1.82.E8.AF.AD.E6.B3.952
 
### 示例

  @code

    QCloudCIUploadOperationsRequest* request = [QCloudCIUploadOperationsRequest new];
    // 对象键，是对象在 COS 上的完整路径，如果带目录的话，格式为 "video/xxx/movie.mp4"
    request.object = @"exampleobject";
    // 存储桶名称，由 BucketName-Appid 组成，可以在 COS 控制台查看 https://console.cloud.tencent.com/cos5/bucket
    request.bucket = @"examplebucket-1250000000";

    request.body =  [@"123456789" dataUsingEncoding:NSUTF8StringEncoding];
    QCloudPicOperations * op = [[QCloudPicOperations alloc]init];

    // 是否返回原图信息。0表示不返回原图信息，1表示返回原图信息，默认为0
    op.is_pic_info = NO;
    QCloudPicOperationRule * rule = [[QCloudPicOperationRule alloc]init];

    // 处理结果的文件路径名称，如以/开头，则存入指定文件夹中，否则，存入原图文件存储的同目录
    request.fileid = @"test";

    // rule 参数请前往图片基础操作页面，选择对应的操作，查看rules.rule参数。 https://cloud.tencent.com/document/product/460/6924
    request.rule = @"imageMogr2/***";


    op.rule = @[rule];
    request.picOperations = op;

    [request setFinishBlock:^(QCloudImageProcessResult * outputObject, NSError *error) {
       完成回调
    }];
    [[QCloudCOSXMLService defaultCOSXML] UploadOperations:request];

*/
@interface QCloudCIUploadOperationsRequest<BodyType> : QCloudBizHTTPRequest
@property (nonatomic, strong) BodyType body;
/**
 对象 名称
*/
@property (strong, nonatomic) NSString *object;
/**
 存储桶 名称
*/
@property (strong, nonatomic) NSString *bucket;
/**
RFC 2616 中定义的缓存策略，将作为 Object 元数据保存
*/
@property (strong, nonatomic) NSString *cacheControl;
/**
RFC 2616 中定义用于指示资源的MIME类型，将作为 Object 元数据保存
*/
@property (strong, nonatomic) NSString *contentType;
/**
RFC 2616 中定义的文件名称，将作为 Object 元数据保存
*/
@property (strong, nonatomic) NSString *contentDisposition;
/**
当使用 Expect: 100-continue 时，在收到服务端确认后，才会发送请求内容
*/
@property (strong, nonatomic) NSString *expect;
/**
RFC 2616 中定义的过期时间，将作为 Object 元数据保存
*/
@property (strong, nonatomic) NSString *expires;
@property (strong, nonatomic) NSString *contentSHA1;
/**
对象的存储级别，枚举值：STANDARD（QCloudCOSStorageStandard），STANDARD_IA（QCloudCOSStorageStandardIA），
 ARCHIVE（QCloudCOSStorageARCHIVE）。默认值：STANDARD（QCloudCOSStorageStandard）
*/
@property (assign, nonatomic) QCloudCOSStorageClass storageClass;
/**
定义 Object 的 ACL 属性。有效值：private，public-read-write，public-read；默认值：private
*/
@property (strong, nonatomic) NSString *accessControlList;
/**
 赋予被授权者读的权限。格式：id="OwnerUin";

*/
@property (strong, nonatomic) NSString *grantRead;
/**
赋予被授权者写的权限。格式：id="OwnerUin";

*/
@property (strong, nonatomic) NSString *grantWrite;
/**
赋予被授权者读写权限。格式: id="OwnerUin";

*/
@property (strong, nonatomic) NSString *grantFullControl;
/**
指定对象对应的Version ID（在开启了多版本的情况才有）
*/
@property (strong, nonatomic) NSString *versionID;

/**
给图片添加盲水印
*/
@property (strong, nonatomic) QCloudPicOperations *picOperations;

/**
设置完成回调。请求完成后会通过该回调来获取结果，如果没有error，那么可以认为请求成功。
*/
- (void)setFinishBlock:(void (^_Nullable)(QCloudImageProcessResult *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;

@end
NS_ASSUME_NONNULL_END

