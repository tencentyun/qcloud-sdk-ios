//
//  QCloudCreateBucketCtor.m
//  QCloudCOSXMLDemo
//
//  Created by garenwang on 2020/5/15.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "QCloudCreateBucketCtor.h"
#import "QCloudSelectRegionTableViewController.h"

NSInteger const marginH = 16;

NSInteger const marginV = 12;

@interface QCloudCreateBucketCtor ()<UITextFieldDelegate>

@property (nonatomic,strong)NSString * strRegionName;

@property (nonatomic,strong)UITextField * tfBucketName;

@property (nonatomic,strong)UILabel * labTipErrorInfo;

@property (nonatomic,strong)UIButton * btnSubmit;

@property (nonatomic,strong)UIButton * btnSelectRegion;

@end

@implementation QCloudCreateBucketCtor

- (UITextField *)tfBucketName{
    if (!_tfBucketName) {
        _tfBucketName = [[UITextField alloc]init];
        _tfBucketName.textColor = DEF_HEXCOLOR(0x444444);
        _tfBucketName.backgroundColor = DEF_HEXCOLOR(0xf9f9f9);
        _tfBucketName.font = [UIFont systemFontOfSize:14];
        _tfBucketName.placeholder = @"请输入桶名称";
        _tfBucketName.delegate = self;
    }
    return _tfBucketName;
}

- (UILabel *)labTipErrorInfo{
    if (!_labTipErrorInfo) {
        _labTipErrorInfo = [[UILabel alloc]init];
        _labTipErrorInfo.textColor = DEF_HEXCOLOR(0xff0000);
        _labTipErrorInfo.font = [UIFont systemFontOfSize:13];
    }
    return _labTipErrorInfo;
}

- (UIButton *)btnSubmit{
    if (!_btnSubmit) {
        _btnSubmit = [[UIButton alloc]init];
        [_btnSubmit setTitle:@"创建" forState:UIControlStateNormal];
        [_btnSubmit addTarget:self action:@selector(actionCreateBucket) forControlEvents:UIControlEventTouchUpInside];
        [_btnSubmit setTitleColor:DEF_HEXCOLOR(0xffffff) forState:UIControlStateNormal];
        _btnSubmit.backgroundColor = DEF_HEXCOLOR(0x56B2F9);
    }
    return _btnSubmit;
}

- (UIButton *)btnSelectRegion{
    if (!_btnSelectRegion) {
        _btnSelectRegion = [[UIButton alloc]init];
        [_btnSelectRegion setTitle:@"请选择地区" forState:UIControlStateNormal];
        [_btnSelectRegion addTarget:self action:@selector(actionSelectRegion) forControlEvents:UIControlEventTouchUpInside];
        [_btnSelectRegion setTitleColor:DEF_HEXCOLOR(0x333333) forState:UIControlStateNormal];
        _btnSelectRegion.backgroundColor = DEF_HEXCOLOR(0xf1f1f1);
    }
    return _btnSelectRegion;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
}

- (void)setupUI{
    
    self.title = @"新建存储桶";
    
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationController.navigationBar.translucent = NO;
    
    [self.view addSubview:self.tfBucketName];
    [self.view addSubview:self.labTipErrorInfo];
    [self.view addSubview:self.btnSubmit];
    
    [self.view addSubview:self.btnSelectRegion];
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    _tfBucketName.frame = CGRectMake(marginH, marginV , SCREEN_WIDTH - 2 * marginH, 44);
    _labTipErrorInfo.frame = CGRectMake(marginH, _tfBucketName.frame.origin.y + _tfBucketName.frame.size.height + marginV, SCREEN_WIDTH - 2 * marginH, 20);
    
    _btnSelectRegion.frame = CGRectMake(marginH, _labTipErrorInfo.frame.origin.y + _labTipErrorInfo.frame.size.height + marginV, SCREEN_WIDTH - 2 * marginH, 44);
    
    _btnSubmit.frame = CGRectMake(marginH, _btnSelectRegion.frame.origin.y + _btnSelectRegion.frame.size.height + marginV, SCREEN_WIDTH - 2 * marginH, 35);
    

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_tfBucketName resignFirstResponder];
}


-(void)actionCreateBucket{
    if (_tfBucketName.text.length == 0) {
        _labTipErrorInfo.text = @"请输入名称";
        return;
    }else{
        _labTipErrorInfo.text = @"";
    }
   
    if (_strRegionName.length == 0) {
        _labTipErrorInfo.text = @"请选择地区";
        return;
    }
    
    [self.tfBucketName resignFirstResponder];
    
    NSString * bucketName = [NSString stringWithFormat:@"%@-%@",_tfBucketName.text, [SecretStorage sharedInstance].appID];
    
//  创建存储桶
//    实例化 QCloudPutBucketRequest
//    调用 QCloudCOSXMLService 实例的 PutBucket 方法 发起请求
//    在FinishBlock获取结果
//  设置访问控制权限有两种方式：1：创建时在QCloudPutBucketRequest类种设置好，在创建桶的同时设置权限；
//                         2：创建完成后：使用QCloudPutBucketACLRequest类 根据桶名称为已有的桶设置访问控制全新啊；
//    参数 1：bucket               桶名称 (必填)；
//        2：accessControlList    定义ACL属性，有效值 private，public-read-write，public-read（选填）
//        3：grantRead            赋予被授权者读的权限
//        4：grantWrite           授予被授权者写的权限
//        5：grantFullControl     授予被授权者读写权限
        
    QCloudPutBucketRequest* putBucket = [[QCloudPutBucketRequest alloc] init];
    
    putBucket.bucket =bucketName;
    
    WeakSelf(self);
    [putBucket setFinishBlock:^(id outputObject, NSError *error) {
        NSLog(@"%@",outputObject);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error == nil) {
                weakself.labTipErrorInfo.text = @"创建成功";
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakself.navigationController popViewControllerAnimated:YES];
                });
            }else{
                NSDictionary *msgDic = error.userInfo;
                NSString * errorMsg = msgDic[@"message"];
                weakself.labTipErrorInfo.text = [NSString stringWithFormat:@"创建失败：%@",errorMsg];
            }
        });
    }];
    
    [[QCloudCOSXMLConfiguration sharedInstance].currentService PutBucket:putBucket];
}

-(void)actionSelectRegion{
    
    QCloudSelectRegionTableViewController * selectRegion = [[QCloudSelectRegionTableViewController alloc]init];
    WeakSelf(self);
    selectRegion.selectRegion = ^(NSObject *obj) {
        [weakself.btnSelectRegion setTitle:(NSString *)obj forState:0];
        weakself.strRegionName = (NSString *)obj;
    };
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:selectRegion] animated:YES completion:nil];
}

#pragma UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _labTipErrorInfo.text = @"";
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (string.length == 0) {
        return YES;
    }
    return [self isValid:string];
}

- (BOOL)isValid:(NSString *)string {
    NSString *str =@"[a-z0-9]";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    if ([emailTest evaluateWithObject:string]) {
        return YES;
    }
    return NO;
}

@end

