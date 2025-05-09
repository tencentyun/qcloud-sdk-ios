//
//  CRC64ViewController.m
//  QCloudCOSXMLDemo
//
//  Created by garenwang on 2025/5/9.
//  Copyright © 2025 Tencent. All rights reserved.
//

#import "CRC64ViewController.h"
#import "QCloudCOSXMLTransfer.h"
#import "QCloudCOSXMLService+Transfer.h"

@interface CRC64ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tvResult;
@property (weak, nonatomic) IBOutlet UISwitch *openCRC64;

@end

@implementation CRC64ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"CRC64校验";
}
- (IBAction)actionUpload:(id)sender {
    
    QCloudCredential *credential = [QCloudCredential new];
    credential.secretID = @"";
    credential.secretKey = @"";
    credential.token = @"";
    if (credential.secretID.length == 0 || credential.secretKey.length == 0) {
        self.tvResult.text = @"请在代码中配置临时密钥";
        return;
    }
    QCloudCOSXMLDownloadObjectRequest *request = [QCloudCOSXMLDownloadObjectRequest new];
    request.credential = credential;
    request.object = @"";// 请设置需要下载的文件key
    request.bucket = @"";// 请设置需要下载的文件所在存储桶
    request.regionName = @"";// 请设置需要下载的文件所在地域
    request.enablePartCrc64 = self.openCRC64.state == UIControlStateSelected;
    if (request.object.length == 0) {
        self.tvResult.text = @"请设置需要下载的文件key";
        return;
    }
    
    [request setFinishBlock:^(id outputObject, NSError *error) {
        if (error) {
            self.tvResult.text = [NSString stringWithFormat:@"下载失败\n%@",error];
        }else{
            self.tvResult.text = [NSString stringWithFormat:@"下载成功\n%@",outputObject];
        }
    }];
    [[QCloudCOSTransferMangerService defaultCOSTransferManager] DownloadObject:request];
}

@end
