//
//  PutBucketWebsite.h
//  PutBucketWebsite
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
@class QCloudWebsiteConfiguration;
NS_ASSUME_NONNULL_BEGIN
/**
为存储桶配置静态网站

PUT Bucket website 请求用于为存储桶配置静态网站，您可以通过传入 XML 格式的配置文件进行配置，文件大小限制为64KB。

关于为存储桶配置静态网站接口的具体描述，请查看https://cloud.tencent.com/document/product/436/31930.

cos iOS SDK 中为存储桶配置静态网站的方法具体步骤如下：

1. 实例化 QCloudPutBucketWebsiteRequest，填入需要的参数。

2. 调用 QCloudCOSXMLService 对象中的 PutBucketWebsite 方法发出请求。

3. 从回调的 finishBlock 中的获取具体内容。
示例：
@code
QCloudPutBucketWebsiteRequest *putReq = [QCloudPutBucketWebsiteRequest new];
putReq.bucket ="exampleBucket-appid";

QCloudWebsiteConfiguration *config = [QCloudWebsiteConfiguration new];

QCloudWebsiteIndexDocument *indexDocument = [QCloudWebsiteIndexDocument new];
indexDocument.suffix =@"index.html";
config.indexDocument = indexDocument;

QCloudWebisteErrorDocument *errDocument = [QCloudWebisteErrorDocument new];
errDocument.key = @"error.html";
config.errorDocument = errDocument;


QCloudWebsiteRedirectAllRequestsTo *redir = [QCloudWebsiteRedirectAllRequestsTo new];
redir.protocol  = @"https";
config.redirectAllRequestsTo = redir;


QCloudWebsiteRoutingRule *rule = [QCloudWebsiteRoutingRule new];
QCloudWebsiteCondition *contition = [QCloudWebsiteCondition new];
contition.httpErrorCodeReturnedEquals = 451;
rule.condition = contition;

QCloudWebsiteRedirect *webRe = [QCloudWebsiteRedirect new];
webRe.protocol = @"https";
webRe.replaceKeyPrefixWith =@"404.html";
rule.redirect = webRe;

QCloudWebsiteRoutingRules *routingRules = [QCloudWebsiteRoutingRules new];
routingRules.routingRule = @[rule];
config.rules = routingRules;
putReq.websiteConfiguration  = config;


[putReq setFinishBlock:^(id outputObject, NSError *error) {
       	//完成回调
	if (nil == error) {
	//成功
	}
}];
[[QCloudCOSXMLService defaultCOSXML] PutBucketWebsite:putReq];
@endcode
*/
@interface QCloudPutBucketWebsiteRequest : QCloudBizHTTPRequest
/**
设置Website的配置信息
*/
@property (strong, nonatomic) QCloudWebsiteConfiguration *websiteConfiguration;
/**
存储桶名
*/
@property (strong, nonatomic) NSString *bucket;


@end
NS_ASSUME_NONNULL_END
