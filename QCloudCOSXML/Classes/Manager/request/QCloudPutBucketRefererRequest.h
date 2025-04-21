//
//  QCloudPutBucketRefererRequest.h
//  QCloudPutBucketRefererRequest
//
//  Created by tencent
//  Copyright (c) 2015年 tencent. All rights reserved.
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
NS_ASSUME_NONNULL_BEGIN

/**

### 功能说明

 PUT Bucket referer 接口用于为存储桶设置 Referer 白名单或者黑名单。

 具体请查看https://cloud.tencent.com/document/product/436/32492.

### 示例

  @code
 
         QCloudPutBucketRefererRequest* request = [QCloudPutBucketRefererRequest new];

         // 防盗链类型，枚举值：Black-List、White-List
         request.refererType = QCloudBucketRefererTypeBlackList;

         // 是否开启防盗链，枚举值：Enabled、Disabled
         request.status = QCloudBucketRefererStatusEnabled;

         // 是否允许空 Referer 访问，枚举值：Allow、Deny，默认值为 Deny
         request.configuration = QCloudBucketRefererConfigurationDeny;

         // 生效域名列表， 支持多个域名且为前缀匹配， 支持带端口的域名和 IP， 支持通配符*，做二级域名或多级域名的通配
         request.domainList = @[@"*.com",@"*.qq.com"];

         // 存储桶名称，格式为 BucketName-APPID
         request.bucket = @"examplebucket-1250000000";

         [request setFinishBlock:^(id outputObject, NSError *error) {
             if (error){
                 // 添加防盗链失败
             }else{
                 // 添加防盗链失败
             }

         }];
         [[QCloudCOSXMLService defaultCOSXML] PutBucketReferer:request];

*/

typedef NS_ENUM(NSUInteger, QCloudBucketRefererType) {
    QCloudBucketRefererTypeBlackList = 1,
    QCloudBucketRefererTypeWhiteList,
};
QCloudBucketRefererType QCloudBucketRefererTypeFromString(NSString *key);
NSString *QCloudBucketRefererTypeTransferToString(QCloudBucketRefererType type);

typedef NS_ENUM(NSUInteger, QCloudBucketRefererStatus) {
    QCloudBucketRefererStatusEnabled = 1,
    QCloudBucketRefererStatusDisabled,
};
QCloudBucketRefererStatus QCloudBucketRefererStatusFromString(NSString *key);
NSString *QCloudBucketRefererStatusTransferToString(QCloudBucketRefererStatus type);

typedef NS_ENUM(NSUInteger, QCloudBucketRefererConfiguration) {
    QCloudBucketRefererConfigurationDeny = 0,
    QCloudBucketRefererConfigurationAllow,
};
QCloudBucketRefererConfiguration QCloudBucketRefererConfigurationFromString(NSString *key);
NSString *QCloudBucketRefererConfigurationTransferToString(QCloudBucketRefererConfiguration type);


@interface QCloudPutBucketRefererRequest : QCloudBizHTTPRequest


@property (strong, nonatomic) NSString * bucket;

/// 防盗链类型，枚举值：Black-List、White-List
@property (assign, nonatomic) QCloudBucketRefererType refererType;


/// 是否开启防盗链，枚举值：Enabled、Disabled
@property (assign, nonatomic) QCloudBucketRefererStatus status;


/// 是否允许空 Referer 访问，枚举值：Allow、Deny，默认值为 Deny
@property (assign, nonatomic) QCloudBucketRefererConfiguration configuration;


/// 生效域名列表， 支持多个域名且为前缀匹配， 支持带端口的域名和 IP， 支持通配符*，做二级域名或多级域名的通配
@property (strong, nonatomic) NSArray * domainList;


- (void)setFinishBlock:(void (^_Nullable)(id _Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
