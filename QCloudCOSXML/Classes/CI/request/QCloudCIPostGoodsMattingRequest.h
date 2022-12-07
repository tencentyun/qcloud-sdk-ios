//
//  QCloudCIPostGoodsMattingRequest.h
//  QCloudCIPostGoodsMattingRequest
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
#import "QCloudCIGoodsMattingResult.h"
@class QCloudCIGoodsMattingInput;
NS_ASSUME_NONNULL_BEGIN
/**
 商品抠图 云上数据处理
 
 腾讯云数据万象通过 GoodsMatting 接口对图像中的商品主体进行抠图。
 
 查看更多：https://cloud.tencent.com/document/product/460/79735
 
 ### 示例
 
 @code
 
     QCloudCIPostGoodsMattingRequest * request = [QCloudCIPostGoodsMattingRequest new];
     request.regionName = @"regionName";
     // 对象键，是对象在 COS 上的完整路径，如果带目录的话，格式为 "dir1/object1"
     request.object = @"exampleobject";
     // 存储桶名称，格式为 BucketName-APPID
     request.bucket = @"examplebucket-1250000000";
     
     QCloudCIGoodsMattingInput * input = [QCloudCIGoodsMattingInput new];
     input.fileid = @"object1";
     request.rules = @[input];
     
     [request setFinishBlock:^(QCloudCIGoodsMattingResult *  _Nullable result, NSError * _Nullable error) {
         
     }];
     [[QCloudCOSXMLService defaultCOSXML] PostGoodsMatting:request];
*/
@interface QCloudCIPostGoodsMattingRequest: QCloudBizHTTPRequest
/**
 存储桶名称
*/
@property (strong, nonatomic) NSString *bucket;
/**
 要识别的对象
*/
@property (strong, nonatomic) NSString *object;

@property(strong,nonatomic)NSArray <QCloudCIGoodsMattingInput *> * rules;

- (void) setFinishBlock:(void (^_Nullable)(QCloudCIGoodsMattingResult * _Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end

@interface QCloudCIGoodsMattingInput : QCloudBizHTTPRequest

/// 文件key
@property (strong, nonatomic) NSString *fileid;

/// 当此参数为1时，针对文件过大等导致处理失败的场景，会直接返回原图而不报错。
@property (assign, nonatomic) BOOL ignoreError;

-(NSDictionary *)getInfo;
@end

NS_ASSUME_NONNULL_END
