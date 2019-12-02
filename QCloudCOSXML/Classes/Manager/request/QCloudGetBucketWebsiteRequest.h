//
//  GetBucketWebsite.h
//  GetBucketWebsite
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
#import "QCloudWebsiteConfiguration.h"
NS_ASSUME_NONNULL_BEGIN
/**
用于获取与存储桶关联的静态网站配置信息

GET Bucket website 请求用于获取与存储桶关联的静态网站配置信息。

关于为存储桶配置静态网站接口的具体描述，请查看https://cloud.tencent.com/document/product/436/31930.

cos iOS SDK 中为存储桶配置静态网站的方法具体步骤如下：

1. 实例化 QCloudGetBucketWebsiteRequest，填入需要的参数。

2. 调用 QCloudCOSXMLService 对象中的 GetBucketWebsite 方法发出请求。

3. 从回调的 finishBlock 中的获取具体内容。
示例：
@code
QCloudGetBucketWebsiteRequest *getReq = [QCloudGetBucketWebsiteRequest new];
getReq.bucket = ="exampleBucket-appid";
[getReq setFinishBlock:^(QCloudWebsiteConfiguration * _Nonnull result, NSError * _Nonnull error) {
        //回调处理，从返回的result中获取信息
}];
[[QCloudCOSXMLService defaultCOSXML] GetBucketWebsite:getReq];
@endcode
*/
@interface QCloudGetBucketWebsiteRequest : QCloudBizHTTPRequest
/**
存储桶名
*/
@property (strong, nonatomic) NSString *bucket;


- (void) setFinishBlock:(void (^_Nullable)(QCloudWebsiteConfiguration* _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
