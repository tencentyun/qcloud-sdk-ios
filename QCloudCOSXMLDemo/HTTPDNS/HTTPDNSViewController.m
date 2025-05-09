//
//  HTTPDNSViewController.m
//  QCloudCOSXMLDemo
//
//  Created by garenwang on 2025/5/9.
//  Copyright © 2025 Tencent. All rights reserved.
//

#import "HTTPDNSViewController.h"
#import "QCloudCLSTrackService.h"
#import "QCloudTrackService.h"
#import "QCloudHTTPDNSLoader.h"

@interface HTTPDNSViewController ()
@property (nonatomic,strong)QCloudHTTPDNSLoader * dnsloader;
@end

@implementation HTTPDNSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupHTTPDNS];
}

-(void)setupHTTPDNS{
    QCloudDnsConfig config;
    config.appId = @"******"; // 可选，应用 ID，腾讯云控制台申请获得，用于灯塔数据上报（未集成灯塔时该参数无效）
    config.dnsIp = @"0.0.0.0"; // HTTPDNS 服务器 IP
    config.dnsId = 1; // 授权 ID，腾讯云控制台申请后，通过邮件发送，用于域名解析鉴权
    config.dnsKey = @"*******";// des 的密钥
    config.encryptType = QCloudHttpDnsEncryptTypeDES; // 控制加密方式
    config.debug = YES; // 是否开启 Debug 日志，YES：开启，NO：关闭。建议联调阶段开启，正式上线前关闭
    config.timeout = 5000; // 可选，超时时间，单位ms，如设置0，则设置为默认值2000ms
    self.dnsloader = [[QCloudHTTPDNSLoader alloc] initWithConfig:config];
    [QCloudHttpDNS shareDNS].delegate = self.dnsloader;
}


@end
