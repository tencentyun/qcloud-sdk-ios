//
//  RootViewController.m
//  QCloudCOSXMLDemo
//
//  Created by garenwang on 2024/7/8.
//  Copyright © 2024 Tencent. All rights reserved.
//

#import "HomeViewController.h"
#import "QCloudMyBucketListCtor.h"
#import "QCloudUploadNewCtorPermanent.h"
#import "QCloudUploadNewCtorReuse.h"
#import "QCloudUploadNewCtorOnce.h"
#import "QCloudDownLoadNewCtorPermanent.h"
#import "QCloudDownLoadNewCtorOnce.h"
#import "QCloudDownLoadNewCtorReuse.h"
#import "RootViewController.h"
#import "CustomDomainViewController.h"
#import "CustomLoaderViewController.h"
#import "CLSLogViewController.h"
#import "HTTPDNSViewController.h"
#import "HTTPSAuthViewController.h"
#import "CRC64ViewController.h"
@interface HomeViewController ()
@property (nonatomic,strong)NSArray * dataSource;
@property (nonatomic,strong)NSArray * descSource;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"COS SDK 示例";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];

    self.dataSource = @[@"文件传输功能",
                        @"自定义加速域名",
                        @"自定义网络层",
                        @"SDK日志上报",
                        @"DNS 解析优化",
                        @"HTTPS双向认证",
                        @"下载接口 CRC64 校验",
                        @"其他功能",
];
    
    self.descSource = @[@"介绍单次临时密钥、可复用临时密钥、永久密钥的用法",
                        @"使用加速域名进行文件传输",
                        @"使用AFNetworking介绍SDK自定义网络层功能",
                        @"将客户端 COS SDK 的运行日志，上报至腾讯云日志服务 CLS",
                        @"COS SDK 使用 HTTPDNS 服务访问 COS",
                        @"HTTPS 基础上，新增服务端对客户端证书校验的支持",
                        @"使用CRC64校验下载文件是否完整",
    @"并发配置、设置自定义请求头、设置不签名Header、自定义协议切换策略"];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    cell.detailTextLabel.numberOfLines = 0;
    cell.textLabel.text = self.dataSource[indexPath.row];
    cell.detailTextLabel.text = self.descSource[indexPath.row];
    cell.backgroundColor = DEF_HEXCOLOR(0xf5f5f5);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController * vc;
    if (indexPath.row == 0) {
        vc = [RootViewController new];
    }
    
    if (indexPath.row == 1) {
        vc = [CustomDomainViewController new];
    }
    
    if (indexPath.row == 2) {
        vc = [CustomLoaderViewController new];
    }
    
    if (indexPath.row == 3) {
        vc = [CLSLogViewController new];
    }
    
    if (indexPath.row == 4) {
        vc = [HTTPDNSViewController new];
    }
    if (indexPath.row == 5) {
        vc = [HTTPSAuthViewController new];
    }
    if (indexPath.row == 6) {
        vc = [CRC64ViewController new];
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
