//
//  QCloudTabBarViewController.m
//  QCloudCOSXMLDemo
//
//  Created by erichmzhang(张恒铭) on 26/04/2018.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import "QCloudTabBarViewController.h"
#import "QCloudUploadViewController.h"
#import "QCloudDownloadViewController.h"
@interface QCloudTabBarViewController ()

@end

@implementation QCloudTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    QCloudUploadViewController *uplaodVc = [QCloudUploadViewController new];
    uplaodVc.title = @"上传";
    [self addChildViewController:uplaodVc];
    
    QCloudDownloadViewController *downloadVC = [QCloudDownloadViewController new];
    downloadVC.title = @"下载";
    [self addChildViewController:downloadVC];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
