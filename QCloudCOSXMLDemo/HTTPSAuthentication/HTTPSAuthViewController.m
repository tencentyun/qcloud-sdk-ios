//
//  HTTPSAuthViewController.m
//  QCloudCOSXMLDemo
//
//  Created by garenwang on 2025/5/9.
//  Copyright © 2025 Tencent. All rights reserved.
//

#import "HTTPSAuthViewController.h"


@interface HTTPSAuthViewController ()

@end

@implementation HTTPSAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupHTTPSAuth];
}

-(void)setupHTTPSAuth{
    QCloudServiceConfiguration* configuration = [QCloudServiceConfiguration new];
    QCloudCOSXMLEndPoint* endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    // 替换为用户的 region，已创建桶归属的 region 可以在控制台查看，https://console.cloud.tencent.com/cos5/bucket
    // COS 支持的所有 region 列表参见 https://www.qcloud.com/document/product/436/6224
    endpoint.regionName = [SecretStorage sharedInstance].region;
    // 使用 HTTPS
    endpoint.useHTTPS = true;
    configuration.endpoint = endpoint;
    // 配置客户端 p12证书。
    NSString *path = [[NSBundle mainBundle] pathForResource:@"client" ofType:@"p12"];
    NSData *p12Data = [NSData dataWithContentsOfFile:path];
    configuration.clientCertificateData = p12Data;
    // 配置证书密码
    configuration.password = @"123456";

    // 初始化 COS 服务示例
    [QCloudCOSXMLService registerDefaultCOSXMLWithConfiguration:configuration];
    [QCloudCOSTransferMangerService registerDefaultCOSTransferMangerWithConfiguration:
            configuration];
}

@end
