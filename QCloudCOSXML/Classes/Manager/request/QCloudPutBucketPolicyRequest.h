//
//  QCloudPutBucketPolicyRequest.h
//  QCloudPutBucketPolicyRequest
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

 PUT Bucket policy 请求可以向 Bucket 写入权限策略，当存储桶已存在权限策略时，该请求上传的策略将覆盖原有的权限策略。

请查看 https://cloud.tencent.com/document/product/436/8282


### 示例

  @code
 
     QCloudPutBucketPolicyRequest * request = [QCloudPutBucketPolicyRequest new];
     request.bucket = @"0-1253960454";
     request.regionName = @"ap-chengdu";
     request.policyInfo = @{
         @"Statement": @[
           @{
             @"Principal": @{
               @"qcs": @[
                 @"qcs::cam::uin/100000000001:uin/100000000001"
               ]
             },
             @"Effect": @"allow",
             @"Action": @[
               @"name/cos:GetBucket"
             ],
             @"Resource": @[
               @"qcs::cos:ap-guangzhou:uid/1250000000:examplebucket-1250000000/*"
             ]
           }
         ],
         @"version": @"2.0"
       };
     
     [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {

     }];
     [[QCloudCOSXMLService defaultCOSXML] PutBucketPolicy:request];


*/
@interface QCloudPutBucketPolicyRequest : QCloudBizHTTPRequest
/**
存储桶名
*/
@property (strong, nonatomic) NSString *bucket;
/**
 下面的示例表示给主账号100000000001下的子账号100000000011授权，以允许访问存储桶名为 examplebucket-1250000000 中的对象列表。
 关于访问策略中的元素介绍，请参见 访问策略语言概述(https://cloud.tencent.com/document/product/436/18023)，
 以及授权策略示例请参见 COS API 授权策略使用指引(https://cloud.tencent.com/document/product/436/31923)。
 @{
     @"Statement": @[
       @{
         @"Principal": @{
           @"qcs": @[
             @"qcs::cam::uin/100000000001:uin/100000000001"
           ]
         },
         @"Effect": @"allow",
         @"Action": @[
           @"name/cos:GetBucket"
         ],
         @"Resource": @[
           @"qcs::cos:ap-guangzhou:uid/1250000000:examplebucket-1250000000/*"
         ]
       }
     ],
     @"version": @"2.0"
   }
 */
@property (strong, nonatomic) NSDictionary *policyInfo;

@end
NS_ASSUME_NONNULL_END
