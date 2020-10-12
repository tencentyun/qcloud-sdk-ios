//
//  QCloudUploadNewCtor.m
//  QCloudCOSXMLDemo
//
//  Created by garenwang on 2020/5/18.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "QCloudUploadNewCtor.h"
#import "QCloudCOSXML/QCloudCOSXML.h"
#import "NSURL+FileExtension.h"

@interface QCloudUploadNewCtor ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>


/// 上传图预览
@property (nonatomic, strong)UIImageView *imgPreviewView;


/// 上传进度
@property (nonatomic, strong)UIProgressView * progressView;


/// 上传状态 1 ：上传中 + 进度； 2：暂停 + 进度  3：上传成功
@property (nonatomic,strong)UILabel * labUploadState;


/// 控制使用简单上传还是高级上传
@property (nonatomic,strong)UISwitch *isSimpleUpload;


@property (nonatomic,strong)UILabel * labUploadType;


@property (nonatomic,strong)UIButton *btnStartUpload;


/// 简单上传没有暂停按钮
@property (nonatomic,strong)UIButton *btnPauseOrGoonUpload;


@property (nonatomic,strong)UIButton *btnCancelUpload;

/// 结果展示
@property (nonatomic, strong)UITextView* tvResult;


@property (nonatomic, strong) NSData* uploadResumeData;

@property (nonatomic, strong) QCloudPutObjectRequest * simpleRequest;

@property (nonatomic, strong) QCloudCOSXMLUploadObjectRequest * advancedRequest;

@property (nonatomic,strong)UISegmentedControl * sgcSetAcl;

@property (nonatomic,strong)UILabel *labAclTitle;

@end

@implementation QCloudUploadNewCtor

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [self fetchData];
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    CGFloat height = 30;
    
    CGFloat margin = 12;
    
    _imgPreviewView.frame = CGRectMake(margin, margin, SCREEN_WIDTH - margin * 2, SCREEN_WIDTH_RATIO(160));
    
    _progressView.frame = CGRectMake(margin, _imgPreviewView.frame.origin.y + _imgPreviewView.frame.size.height + margin * 3, SCREEN_WIDTH - 120 - margin * 3, height);
    
    _labUploadState.frame = CGRectMake(_progressView.frame.size.width + _progressView.frame.origin.x + margin, 0 , SCREEN_WIDTH - _progressView.frame.size.width - 3 * margin, height);
    
    _labUploadState.center = CGPointMake(_labUploadState.center.x, _progressView.center.y);
    
    _labAclTitle.frame = CGRectMake(margin, _labUploadState.frame.origin.y + _labUploadState.frame.size.height + margin * 3, 60, height);
    
    _sgcSetAcl.frame = CGRectMake(_labAclTitle.frame.origin.x + _labAclTitle.frame.size.width + margin, _labAclTitle.frame.origin.y, SCREEN_WIDTH -(_labAclTitle.frame.origin.x + _labAclTitle.frame.size.width + margin * 2), height);
    
    
    _btnStartUpload.frame = CGRectMake(margin, _labAclTitle.frame.origin.y + _labAclTitle.frame.size.height + margin * 3, 80, height);
    
    _btnPauseOrGoonUpload.frame = CGRectMake(margin + _btnStartUpload.frame.size.width + _btnStartUpload.frame.origin.x , _btnStartUpload.frame.origin.y, 80, height);
    
    _btnCancelUpload.frame = CGRectMake(margin + _btnPauseOrGoonUpload.frame.size.width + _btnPauseOrGoonUpload.frame.origin.x , _btnStartUpload.frame.origin.y, 80, height);
    
    _tvResult.frame = CGRectMake(margin, _btnCancelUpload.frame.origin.y + _btnCancelUpload.frame.size.height + margin * 2, SCREEN_WIDTH - margin * 2, 300);
    
}

-(void)setupUI{
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"上传文件";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _imgPreviewView = [[UIImageView alloc]init];
    _imgPreviewView.backgroundColor = DEF_HEXCOLOR(0xf1f1f1);
    [self.view addSubview:_imgPreviewView];
    
    _progressView = [[UIProgressView alloc]init];
    _progressView.backgroundColor = [UIColor lightGrayColor];
    _progressView.progressTintColor = [UIColor blueColor];
    [self.view addSubview:_progressView];
    
    _labUploadState = [[UILabel alloc]init];
    _labUploadState.textColor = [UIColor systemBlueColor];
    _labUploadState.text = @"等待上传";
    _labUploadState.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_labUploadState];
    
    _btnStartUpload = [[UIButton alloc]init];
    [_btnStartUpload setTitle:@"开始" forState:UIControlStateNormal];
    [_btnStartUpload setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    [self.view addSubview:_btnStartUpload];
    [_btnStartUpload addTarget:self action:@selector(actionStartUpload:) forControlEvents:UIControlEventTouchUpInside];
    
    _btnPauseOrGoonUpload = [[UIButton alloc]init];
    [_btnPauseOrGoonUpload setTitle:@"暂停" forState:UIControlStateNormal];
    [_btnPauseOrGoonUpload setTitle:@"继续" forState:UIControlStateSelected];
    [_btnPauseOrGoonUpload setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    [self.view addSubview:_btnPauseOrGoonUpload];
    [_btnPauseOrGoonUpload addTarget:self action:@selector(actionPauseOrGoon:) forControlEvents:UIControlEventTouchUpInside];
    
    _btnCancelUpload = [[UIButton alloc]init];
    [_btnCancelUpload setTitle:@"取消" forState:UIControlStateNormal];
    [_btnCancelUpload setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    [self.view addSubview:_btnCancelUpload];
    [_btnCancelUpload addTarget:self action:@selector(actionCancelUpload:) forControlEvents:UIControlEventTouchUpInside];
    
    _tvResult = [[UITextView alloc]init];
    _tvResult.font = [UIFont systemFontOfSize:14];
    _tvResult.textColor = DEF_HEXCOLOR(0x666666);
    [self.view addSubview:_tvResult];
    
    _sgcSetAcl = [[UISegmentedControl alloc]initWithItems:[self getAllAcl]];
    [_sgcSetAcl setTintColor: [UIColor systemBlueColor]];
    [_sgcSetAcl setSelectedSegmentIndex:0];
    
    [self.view addSubview:_sgcSetAcl];
    
    _labAclTitle = [[UILabel alloc]init];
    _labAclTitle.text = @"设置权限";
    _labAclTitle.textColor = DEF_HEXCOLOR(0x666666);
    _labAclTitle.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_labAclTitle];
    
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithTitle:@"选择照片" style:UIBarButtonItemStylePlain target:self action:@selector(uploadFileToBucket)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //    简单上传 ： 上传 + 取消      高级上传： 上传  + 暂停/继续 + 取消
    
    //    设置acl
    
    //    文件列表页右上角可以调用图库上传文件，上传同样需要展示上传进度与结果，上传支持暂停继续，支持选择用简单上传、分片上传或者高级上传接口，支持设置ACL
    //    图片预览
    
    //    进度与结果
    
    //    暂停继续
    
    //    简单上传      QCloudPutObjectRequest
    
    //    分片上传      QCloudListBucketMultipartUploadsRequest
    //                    上传：
    //                            新的上传 初始化（QCloudInitiateMultipartUploadRequest）-> 上传 —> 完成
    //                            续传 ： 查询 -> 上传
    //                    终止：QCloudAbortMultipfartUploadRequest
    //                    删除：
    
    //    高级上传      QCloudCOSXMLUploadObjectRequest
    
    //    支持设置ACL   QCloudPutObjectACLRequest
    //                   accessControlList ： private，public-read，default（继承桶的权限）
    //                   grantRead grantWrite grantFullControl
    //    设置acl两种方式1 : 上传文件时：在上传请求中设置，然后跟文件一起上传，2：上传完成，用QCloudPutObjectACLRequest类，根据文件名设置，
}

-(void)fetchData{
    self.imgPreviewView.image = _image;
}

-(void)actionChangeUploadType:(UISwitch *)sender{
    if (sender.on == YES) {
        _labUploadType.text = @"高级上传";
        _btnPauseOrGoonUpload.hidden = NO;
    }else{
        _labUploadType.text = @"简单上传";
        _btnPauseOrGoonUpload.hidden = YES;
    }
}

-(void)actionStartUpload:(UIButton *)sender{
    [self showErrorMessage:@""];
    [self advancedBeginUpload];
}

-(void)actionPauseOrGoon:(UIButton *)sender{
    if (sender.selected == NO) {
        if (_advancedRequest == nil) {
            [self showErrorMessage:@"当前没有可以暂停的上传"];
            return;
        }
        
        NSError * error;
        
//        上传暂停：
//        返回暂停的位置，用于在续传时从当前暂停位置开始，无需重新上传
        _uploadResumeData = [_advancedRequest cancelByProductingResumeData:&error];
        if (error == nil) {
            sender.selected = !sender.selected; //选中为 已经暂停 需要继续上传     ；默认为正在上传可以点暂停
            self.labUploadState.text = @"已暂停";
            [self showErrorMessage:@"暂停成功"];
        }else{
            [self showErrorMessage:@"暂停失败"];
        }
    }else{
        if (_uploadResumeData == nil) {
            [self showErrorMessage:@"当前无没有可以继续上传的请求"];
            return;
        }
        [self showErrorMessage:@"继续上传"];
        sender.selected = !sender.selected;
        QCloudCOSXMLUploadObjectRequest* upload = [QCloudCOSXMLUploadObjectRequest requestWithRequestData:self.uploadResumeData];
        [self advancedUpload:upload];
    }
}

-(void)actionCancelUpload:(UIButton *)sender{
    if (_advancedRequest == nil) {
        [self showErrorMessage:@"当前没有可以取消的上传"];
    }else{
        [_advancedRequest cancel];
        _advancedRequest = nil;
        _labUploadState.text = @"已取消";
        _progressView.progress = 0.0f;
        _uploadResumeData = nil;
        [self showErrorMessage:@"上传已取消，请重新上传"];
    }
}

-(void)advancedBeginUpload{
    
    //    新的上传
    if (self.advancedRequest != nil) {
        [self showErrorMessage:@"正在上传，请稍等"];
        return;
    }
    
    if (self.filePath == nil) {
        [self showErrorMessage:@"请选择文件"];
        return;
    }
    
//    实例化 QCloudCOSXMLUploadObjectRequest
//    调用 QCloudCOSTransferMangerService 实例的 UploadObject 方法 进行文件高级上传
//    在setSendProcessBlock 回调中 处理上传进度进度
//    在setFinishBlock 处理上传完成结果
    
    _btnPauseOrGoonUpload.selected = NO;
    
    QCloudCOSXMLUploadObjectRequest * advancedRequest = [QCloudCOSXMLUploadObjectRequest new];
    
    advancedRequest.accessControlList = [[self getAllAcl] objectAtIndex:_sgcSetAcl.selectedSegmentIndex];
    
    advancedRequest.bucket = CURRENT_BUCKET;
    
    advancedRequest.body = [NSURL fileURLWithPath:self.filePath];
    NSDate *datenow = [NSDate date];
    advancedRequest.object = [NSString stringWithFormat:@"image_%ld",(long)[datenow timeIntervalSince1970]];
    
    [self advancedUpload:advancedRequest];
}


-(void)advancedUpload:(QCloudCOSXMLUploadObjectRequest *)upload{
    self.labUploadState.text = @"正在上传";
    [self showErrorMessage:@"正在上传"];
    _advancedRequest = upload;
    
    
    NSDate* beforeUploadDate = [NSDate date];
    NSString* fileSizeDescription =  [(NSURL*)upload.body fileSizeWithUnit];
    double fileSizeSmallerThan1024 = [(NSURL*)upload.body fileSizeSmallerThan1024];
    NSString* fileSizeCount = [(NSURL*)upload.body fileSizeCount];
    
//    高级上传文件接口
//      bucket ：桶名
//      body   ：本地文件url（真正要上传的文件）
//      object ：object 文件名称
    
    WeakSelf(self);
    [upload setFinishBlock:^(QCloudUploadObjectResult *result, NSError * error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                if (weakself.uploadResumeData != nil) { // 如果 uploadResumeData不为空 则为用户手动暂停
                    weakself.labUploadState.text = @"上传暂停";
                    [weakself showErrorMessage:@"已暂停"];
                }else{
                    weakself.advancedRequest = nil;
                    weakself.labUploadState.text = @"上传失败";
                    weakself.progressView.progress = 0;
                    [weakself showErrorMessage:error.localizedDescription];
                }
            } else {
                weakself.advancedRequest = nil;
                weakself.progressView.progress = 1.0f;
                weakself.labUploadState.text = @"上传完成";
                
                NSDate* afterUploadDate = [NSDate date];
                NSTimeInterval uploadTime = [afterUploadDate timeIntervalSinceDate:beforeUploadDate];
                NSMutableString* resultImformationString = [[NSMutableString alloc] init];
                [resultImformationString appendFormat:@"上传耗时:%.1f 秒\n\n",uploadTime];
                [resultImformationString appendFormat:@"文件大小: %@\n\n",fileSizeDescription];
                [resultImformationString appendFormat:@"上传速度:%.2f %@/s\n\n",fileSizeSmallerThan1024/uploadTime,fileSizeCount];
                [resultImformationString appendFormat:@"下载链接:%@\n\n",result.location];
                if (result.__originHTTPURLResponse__) {
                    [resultImformationString appendFormat:@"返回HTTP头部:\n%@\n",result.__originHTTPURLResponse__.allHeaderFields];
                }
                
                if (result.__originHTTPResponseData__) {
                    [resultImformationString appendFormat:@"返回HTTP Body内容:\n%@\n",[[NSString alloc] initWithData:result.__originHTTPResponseData__ encoding:NSUTF8StringEncoding]];
                }
                [self showErrorMessage:resultImformationString];
            }
        });
    }];
    
    [upload setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            bytesSent  本次发送的字节数
//            totalBytesSent  总共发送的字节数
//            totalBytesExpectedToSend  总共需要发送的字节数（即整个文件的大小）
            
            [weakself.progressView setProgress:(1.0f*totalBytesSent)/totalBytesExpectedToSend animated:YES];
            weakself.labUploadState.text = [NSString stringWithFormat:@"上传中（%.0f%%）",1.0f*totalBytesSent/totalBytesExpectedToSend * 100];
        });
    }];
    
    [CURRENT_TRANSFER_MANAGER UploadObject:upload];
}

- (UIImage *)compressImageQuality:(UIImage *)image toByte:(NSInteger)maxLength {
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    while (data.length > maxLength && compression > 0) {
        compression -= 0.02;
        data = UIImageJPEGRepresentation(image, compression);
    }
    
    UIImage *resultImage = [UIImage imageWithData:data];
    return resultImage;
}

- (void) showErrorMessage:(NSString*)message{
    self.tvResult.text = message;
}

-(void)dealloc{
    if (self.advancedRequest != nil) {
        [self.advancedRequest cancel];
    }
    if (self.simpleRequest != nil) {
        [self.simpleRequest cancel];
    }
}

-(NSArray *)getAllAcl{
    return @[@"default",@"private",@"public-read"];
}

-(void)uploadFileToBucket{
    UIImagePickerController* picker = [UIImagePickerController new];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}


- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSString* tempPath = QCloudTempFilePathWithExtension(@"png");
        [UIImagePNGRepresentation(image) writeToFile:tempPath atomically:YES];
        self.filePath = tempPath;
        self.image = image;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imgPreviewView.image = image;
        });
    });
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
