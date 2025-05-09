//
//  CustomLoaderViewController.m
//  QCloudCOSXMLDemo
//
//  Created by garenwang on 2025/5/9.
//  Copyright © 2025 Tencent. All rights reserved.
//

#import "CustomLoaderViewController.h"
#import "QCloudLoaderManager.h"
#import "QCloudAFLoader.h"
@interface CustomLoaderViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tvResult;

@end

@implementation CustomLoaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"自定义网络层";
    
    [[QCloudLoaderManager manager] addLoader:[QCloudAFLoader new]];
    [QCloudLoaderManager manager].enable = YES;
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
    QCloudPutObjectRequest *put = [QCloudPutObjectRequest new];
    put.credential = credential;
    put.object = @"customloader_upload";
    put.body = [@"This is test content" dataUsingEncoding:NSUTF8StringEncoding];
    [put setFinishBlock:^(id outputObject, NSError *error) {
        if (error) {
            self.tvResult.text = [NSString stringWithFormat:@"上传失败\n%@",error];
        }else{
            self.tvResult.text = [NSString stringWithFormat:@"上传成功\n%@",outputObject];
        }
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutObject:put];
}

@end
