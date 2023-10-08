//
//  QCloudCICloudDataOperationsRequest.h
//  QCloudCOSXML
//
//  Created by karisli(李雪) on 2021/4/20.
//

//  PutObject.h
//  PutObject
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

@class QCloudPutObjectWatermarkResult;
@class QCloudCICloudDataOperationsRequest;
NS_ASSUME_NONNULL_BEGIN
/**
 
图片处理机制介绍——云上数据处理
 
对象存储的图片处理 API 能够对已存储在 COS 的图片进行相应处理操作，并将结果存入到 COS。

https://cloud.tencent.com/document/product/460/18147#.E8.AF.B7.E6.B1.82.E8.AF.AD.E6.B3.953
 
### 示例

  @code
     
     QCloudCICloudDataOperationsRequest* put = [QCloudCICloudDataOperationsRequest new];


     // 对象键，是对象在 COS 上的完整路径，如果带目录的话，格式为 "video/xxx/movie.mp4"
     put.object = @"exampleobject";
     // 存储桶名称，由BucketName-Appid 组成，可以在COS控制台查看 https://console.cloud.tencent.com/cos5/bucket
     put.bucket = @"examplebucket-1250000000";


     QCloudPicOperations * op = [[QCloudPicOperations alloc]init];


     // 是否返回原图信息。0表示不返回原图信息，1表示返回原图信息，默认为0
     op.is_pic_info = NO;
     QCloudPicOperationRule * rule = [[QCloudPicOperationRule alloc]init];


     // 处理结果的文件路径名称，如以/开头，则存入指定文件夹中，否则，存入原图文件存储的同目录
     rule.fileid = @"test";


     // rule 参数请前往图片基础操作页面，选择对应的操作，查看rules.rule参数。 https://cloud.tencent.com/document/product/460/6924
     rule.rule = @"imageMogr2/***"


     op.rule = @[rule];
     put.picOperations = op;
     [put setFinishBlock:^(QCloudImageProcessResult *outputObject, NSError *error) {


     }];
     [[QCloudCOSXMLService defaultCOSXML] CloudDataOperations:put];


*/

typedef QCloudCICloudDataOperationsRequest QCloudPostObjectProcessRequest;

@interface QCloudCICloudDataOperationsRequest<BodyType> : QCloudBizHTTPRequest
/**
 对象 名称
*/
@property (strong, nonatomic) NSString *object;
/**
 存储桶 名称
*/
@property (strong, nonatomic) NSString *bucket;

/**
云上数据处理
*/
@property (strong, nonatomic) QCloudPicOperations *picOperations;

/**
设置完成回调。请求完成后会通过该回调来获取结果，如果没有error，那么可以认为请求成功。
*/
- (void)setFinishBlock:(void (^_Nullable)(QCloudImageProcessResult *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;

@end


NS_ASSUME_NONNULL_END
