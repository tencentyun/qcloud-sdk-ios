//
//  CustomDomainViewController.m
//  QCloudCOSXMLDemo
//
//  Created by garenwang on 2025/5/9.
//  Copyright © 2025 Tencent. All rights reserved.
//

#import "CustomDomainViewController.h"

@interface CustomDomainViewController ()
@property (weak, nonatomic) IBOutlet UITextField *inputDomain;
@property (weak, nonatomic) IBOutlet UITextView *tvResult;

@end

@implementation CustomDomainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"使用自定义域名上传";
    
}

- (IBAction)actionUpload:(UIButton *)sender {
    [self setupCosSDK];
}

-(void)setupCosSDK{
    if (self.inputDomain.text.length == 0) {
        self.tvResult.text = @"请输入正确的域名";
        return;
    }
    self.tvResult.text = @"";
    QCloudServiceConfiguration* configuration = [QCloudServiceConfiguration new];
    configuration.appID = [SecretStorage sharedInstance].appID;
    QCloudCOSXMLEndPoint* endpoint = [[QCloudCOSXMLEndPoint alloc] initWithLiteralURL:[NSURL URLWithString:self.inputDomain.text]]; // 设置加速域名
    endpoint.useHTTPS = YES; // 使用 https
    configuration.endpoint = endpoint;
    [QCloudCOSXMLService registerCOSXMLWithConfiguration:configuration withKey:@"customdomain_upload"];
}

-(void)uploadFile{
    
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
    put.object = @"customdomain_upload";
    put.body = [@"This is test content" dataUsingEncoding:NSUTF8StringEncoding];
    [put setFinishBlock:^(id outputObject, NSError *error) {
        if (error) {
            self.tvResult.text = [NSString stringWithFormat:@"上传失败\n%@",error];
        }else{
            self.tvResult.text = [NSString stringWithFormat:@"上传成功\n%@",outputObject];
        }
    }];
    [[QCloudCOSXMLService cosxmlServiceForKey:@"customdomain_upload"] PutObject:put];
}



@end
