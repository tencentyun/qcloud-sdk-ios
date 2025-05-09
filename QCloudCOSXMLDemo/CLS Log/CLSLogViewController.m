//
//  CLSLogViewController.m
//  QCloudCOSXMLDemo
//
//  Created by garenwang on 2025/5/9.
//  Copyright © 2025 Tencent. All rights reserved.
//

#import "CLSLogViewController.h"
#import "QCloudCLSTrackService.h"
#import "QCloudTrackService.h"
@interface CLSLogViewController ()

@end

@implementation CLSLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCLS];
}

-(void)setupCLS{
    // 使用 TopicId 和 endpoint 示例化 CLS 上报服务（QCloudCLSTrackService）；
    QCloudCLSTrackService * service = [[QCloudCLSTrackService alloc]initWithTopicId:@"日志主题ID" endpoint:@"地域"];
    // 将示例化的service 加入 QCloudTrackService 中并指定serviceKey
    // serviceKey 固定值：qcloud_track_cos_sdk。
    [[QCloudTrackService singleService] addTrackService:service serviceKey:@"qcloud_track_cos_sdk"];
    
    [service setupCredentialsRefreshBlock:^QCloudClsSessionCredentials * _Nonnull{
        QCloudClsSessionCredentials * credentials = [QCloudClsSessionCredentials new];
        credentials.secretId = @"SECRETID"; // 临时密钥 SecretId
        credentials.secretKey = @"SECRETKEY"; // 临时密钥 SecretKey
        credentials.token = @"SESSIONTOKEN"; // 临时密钥 Token
        credentials.expiredTime = 1556183496L;//临时密钥有效截止时间戳，单位是秒
        // 最后返回临时密钥信息对象
        return credentials;
    }];
}


@end
