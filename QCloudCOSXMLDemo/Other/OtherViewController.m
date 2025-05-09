//
//  OtherViewController.m
//  QCloudCOSXMLDemo
//
//  Created by garenwang on 2025/5/9.
//  Copyright © 2025 Tencent. All rights reserved.
//

#import "OtherViewController.h"


@interface OtherViewController ()<QCloudSignatureProvider>

@end

@implementation OtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setConcurrentCount];
}

//1、并发配置 
-(void)setConcurrentCount{
//    设置当前并发数为2
    [QCloudHTTPSessionManager shareClient].customConcurrentCount = 2;
//    设置并发数自增上线为4
    [QCloudHTTPSessionManager shareClient].maxConcurrentCountLimit = 4;
}
//2、设置自定义请求头 
-(void)setCustomHeader{
//    以下载接口为例：
    
    QCloudCOSXMLDownloadObjectRequest *request = [QCloudCOSXMLDownloadObjectRequest new];
    request.object = @"";// 请设置需要下载的文件key
    request.bucket = @"";// 请设置需要下载的文件所在存储桶
    request.regionName = @"";// 请设置需要下载的文件所在地域

    // 设置自定义请求头
    request.customHeaders = @{@"customerKey":@"customerValue"}.mutableCopy;
    [request setFinishBlock:^(id outputObject, NSError *error) {
        
    }];
    [[QCloudCOSTransferMangerService defaultCOSTransferManager] DownloadObject:request];
    
}
//3、设置不签名Header 
-(void)setNosignHeader{
//    在- (void)signatureWithFields:(QCloudSignatureFields *)fileds
//    request:(QCloudBizHTTPRequest *)request
// urlRequest:(NSMutableURLRequest *)urlRequst
//  compelete:(QCloudHTTPAuthentationContinueBlock)continueBlock{} 方法中配置不参与签名Header。
//
    QCloudServiceConfiguration *configuration = [QCloudServiceConfiguration new];

    configuration.appID = [SecretStorage sharedInstance].appID;
    configuration.signatureProvider = self;
    QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.regionName = [SecretStorage sharedInstance].region;
    configuration.endpoint = endpoint;

    [QCloudCOSXMLService registerDefaultCOSXMLWithConfiguration:configuration];
    [QCloudCOSTransferMangerService registerDefaultCOSTransferMangerWithConfiguration:configuration];
}

- (void)signatureWithFields:(QCloudSignatureFields *)fileds
                    request:(QCloudBizHTTPRequest *)request
                 urlRequest:(NSMutableURLRequest *)urlRequst
                  compelete:(QCloudHTTPAuthentationContinueBlock)continueBlock {
    
    QCloudCredential *credential = [QCloudCredential new];
    credential.secretID = [SecretStorage sharedInstance].secretID;
    credential.secretKey = [SecretStorage sharedInstance].secretKey;
    QCloudAuthentationV5Creator *creator = [[QCloudAuthentationV5Creator alloc] initWithCredential:credential];
//   配置参与签名的Header，若需指定某个字段不参与签名，则将其删除即可。
    creator.shouldSignedList = @[@"Cache-Control", @"Content-Disposition", @"Content-Encoding", @"Content-Length", @"Content-MD5", @"Content-Type", @"Expect", @"Expires", @"If-Match" , @"If-Modified-Since" , @"If-None-Match" , @"If-Unmodified-Since" , @"Origin" , @"Range" , @"transfer-encoding" ,@"Host",@"Pic-Operations",@"ci-process"];
    QCloudSignature *signature = [creator signatureForData:urlRequst];
    
    continueBlock(signature, nil);
}
//4、自定义协议切换策略
-(void)setNetworkStrategy{
    QCloudServiceConfiguration *configuration = [QCloudServiceConfiguration new];

    configuration.appID = [SecretStorage sharedInstance].appID;
    configuration.signatureProvider = self;
    QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.regionName = [SecretStorage sharedInstance].region;
    configuration.endpoint = endpoint;
    // 配置切换策略为激进策略
    configuration.networkStrategy = QCloudRequestNetworkStrategyAggressive;
    // 配置切换策略为保守策略
    // configuration.networkStrategy = QCloudRequestNetworkStrategyConservative;

    [QCloudCOSXMLService registerDefaultCOSXMLWithConfiguration:configuration];
    [QCloudCOSTransferMangerService registerDefaultCOSTransferMangerWithConfiguration:configuration];
}

@end
