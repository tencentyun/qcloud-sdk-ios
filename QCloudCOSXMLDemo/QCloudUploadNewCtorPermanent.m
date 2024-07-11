//
//  QCloudUploadNewCtorPermanent.m
//  QCloudCOSXMLDemo
//
//  Created by garenwang on 2020/5/18.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "QCloudUploadNewCtorPermanent.h"
#import "QCloudCOSXML/QCloudCOSXML.h"
#import "NSURL+FileExtension.h"
#import "QCloudProgrameDefines.h"
@interface QCloudUploadNewCtorPermanent () <UIImagePickerControllerDelegate, UINavigationControllerDelegate,QCloudSignatureProvider>

/// 上传图预览
@property (weak, nonatomic) IBOutlet UIImageView *imgPreviewView;


/// 上传进度
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;


/// 上传状态 1 ：上传中 + 进度； 2：暂停 + 进度  3：上传成功
@property (weak, nonatomic) IBOutlet UILabel *labUploadState;

@property (weak, nonatomic) IBOutlet UILabel *labTip;


@property (weak, nonatomic) IBOutlet UIButton *btnStartUpload;

@property (weak, nonatomic) IBOutlet UIButton *btnPauseOrGoonUpload;

@property (weak, nonatomic) IBOutlet UIButton *btnCancelUpload;

@property (weak, nonatomic) IBOutlet UITextView *tvResult;


@property (nonatomic, strong) NSData *uploadResumeData;

@property (nonatomic, strong) QCloudCOSXMLUploadObjectRequest *advancedRequest;

@property (strong, nonatomic) NSString *filePath;
@property (strong, nonatomic) UIImage *image;

@property (nonatomic,strong)NSString * appID;
@property (nonatomic,strong)NSString * bucket;
@property (nonatomic,strong)NSString * region;
@property (nonatomic,strong)QCloudCredential * credential;

@end

@implementation QCloudUploadNewCtorPermanent

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setCOSFileInfo];
    
    [self setupUI];
    
    // 注册 cos 服务实例。需实现 QCloudSignatureProvider
    [self setupCOSXMLService];
}

-(void)setCOSFileInfo{
    self.appID = @"";
    self.bucket = @"";
    self.region = @"";
    QCloudCredential *credential = [QCloudCredential new];
    credential.secretID = @"永久secretID";
    credential.secretKey = @"永久secretKey";
    self.credential = credential;
}

- (void)setupUI {
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"上传文件";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _labTip.text = @"体验之前，请在 QCloudUploadNewCtorPermanent 类中的 setCOSFileInfo:方法内配置永久密钥";
    _labUploadState.text = @"等待上传";
    
    [_btnStartUpload setTitle:@"开始" forState:UIControlStateNormal];
    [_btnStartUpload setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    [_btnStartUpload addTarget:self action:@selector(actionStartUpload:) forControlEvents:UIControlEventTouchUpInside];

    [_btnPauseOrGoonUpload setTitle:@"暂停" forState:UIControlStateNormal];
    [_btnPauseOrGoonUpload setTitle:@"继续" forState:UIControlStateSelected];
    [_btnPauseOrGoonUpload setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    [_btnPauseOrGoonUpload addTarget:self action:@selector(actionPauseOrGoon:) forControlEvents:UIControlEventTouchUpInside];

    [_btnCancelUpload setTitle:@"取消" forState:UIControlStateNormal];
    [_btnCancelUpload setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    [_btnCancelUpload addTarget:self action:@selector(actionCancelUpload:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"选择照片"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(uploadFileToBucket)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)setupCOSXMLService{
    QCloudServiceConfiguration *configuration = [QCloudServiceConfiguration new];
    configuration.appID = self.appID;
    QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.regionName = self.region;
    configuration.endpoint = endpoint;
    configuration.signatureProvider = self;
    [QCloudCOSXMLService registerCOSXMLWithConfiguration:configuration withKey:@"PermanentCredential"];
    [QCloudCOSTransferMangerService registerCOSTransferMangerWithConfiguration:configuration withKey:@"PermanentCredential"];
}

- (void)signatureWithFields:(QCloudSignatureFields *)fileds
                    request:(QCloudBizHTTPRequest *)request
                 urlRequest:(NSMutableURLRequest *)urlRequst
                  compelete:(QCloudHTTPAuthentationContinueBlock)continueBlock {
    QCloudAuthentationV5Creator *creator = [[QCloudAuthentationV5Creator alloc] initWithCredential:self.credential];
    QCloudSignature *signature = [creator signatureForData:urlRequst];
    continueBlock(signature, nil);
}

- (void)actionStartUpload:(UIButton *)sender {
    [self showErrorMessage:@""];
    [self advancedBeginUpload];
}

- (void)actionPauseOrGoon:(UIButton *)sender {
    if (sender.selected == NO) {
        if (_advancedRequest == nil) {
            [self showErrorMessage:@"当前没有可以暂停的上传"];
            return;
        }

        NSError *error;
        _uploadResumeData = [_advancedRequest cancelByProductingResumeData:&error];
        if (error == nil) {
            sender.selected = !sender.selected; //选中为 已经暂停 需要继续上传     ；默认为正在上传可以点暂停
            self.labUploadState.text = @"已暂停";
            [self showErrorMessage:@"暂停成功"];
        } else {
            [self showErrorMessage:@"暂停失败"];
        }
    } else {
        if (_uploadResumeData == nil) {
            [self showErrorMessage:@"当前无没有可以继续上传的请求"];
            return;
        }
        [self showErrorMessage:@"继续上传"];
        sender.selected = !sender.selected;
        QCloudCOSXMLUploadObjectRequest *upload = [QCloudCOSXMLUploadObjectRequest requestWithRequestData:self.uploadResumeData];
        [self advancedUpload:upload];
    }
}

- (void)actionCancelUpload:(UIButton *)sender {
    if (_advancedRequest == nil) {
        [self showErrorMessage:@"当前没有可以取消的上传"];
    } else {
        [_advancedRequest cancel];
        _advancedRequest = nil;
        _labUploadState.text = @"已取消";
        _progressView.progress = 0.0f;
        _uploadResumeData = nil;
        [self showErrorMessage:@"上传已取消，请重新上传"];
    }
}

- (void)advancedBeginUpload {
    //    新的上传
    if (self.advancedRequest != nil) {
        [self showErrorMessage:@"正在上传，请稍等"];
        return;
    }

    if (self.filePath == nil) {
        [self showErrorMessage:@"请选择文件"];
        return;
    }

    _btnPauseOrGoonUpload.selected = NO;

    QCloudCOSXMLUploadObjectRequest *advancedRequest = [QCloudCOSXMLUploadObjectRequest new];

    advancedRequest.bucket = self.bucket;

    advancedRequest.body = [NSURL fileURLWithPath:self.filePath];
    NSDate *datenow = [NSDate date];
    advancedRequest.object = [NSString stringWithFormat:@"image_%ld", (long)[datenow timeIntervalSince1970]];

    [self advancedUpload:advancedRequest];
}

- (void)advancedUpload:(QCloudCOSXMLUploadObjectRequest *)upload {
    
    self.labUploadState.text = @"正在上传";
    [self showErrorMessage:@"正在上传"];
    _advancedRequest = upload;

    NSDate *beforeUploadDate = [NSDate date];
    NSString *fileSizeDescription = [(NSURL *)upload.body fileSizeWithUnit];
    double fileSizeSmallerThan1024 = [(NSURL *)upload.body fileSizeSmallerThan1024];
    NSString *fileSizeCount = [(NSURL *)upload.body fileSizeCount];

    //    高级上传文件接口
    //      bucket ：桶名
    //      body   ：本地文件url（真正要上传的文件）
    //      object ：object 文件名称

    QCloudWeakSelf(self);
    [upload setFinishBlock:^(QCloudUploadObjectResult *result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                if (weakself.uploadResumeData != nil) { // 如果 uploadResumeData不为空 则为用户手动暂停
                    weakself.labUploadState.text = @"上传暂停";
                    [weakself showErrorMessage:@"已暂停"];
                } else {
                    weakself.advancedRequest = nil;
                    weakself.labUploadState.text = @"上传失败";
                    weakself.progressView.progress = 0;
                    [weakself showErrorMessage:error.localizedDescription];
                }
            } else {
                weakself.advancedRequest = nil;
                weakself.progressView.progress = 1.0f;
                weakself.labUploadState.text = @"上传完成";

                NSDate *afterUploadDate = [NSDate date];
                NSTimeInterval uploadTime = [afterUploadDate timeIntervalSinceDate:beforeUploadDate];
                NSMutableString *resultImformationString = [[NSMutableString alloc] init];
                [resultImformationString appendFormat:@"上传耗时:%.1f 秒\n\n", uploadTime];
                [resultImformationString appendFormat:@"文件大小: %@\n\n", fileSizeDescription];
                [resultImformationString appendFormat:@"上传速度:%.2f %@/s\n\n", fileSizeSmallerThan1024 / uploadTime, fileSizeCount];
                [resultImformationString appendFormat:@"下载链接:%@\n\n", result.location];
                if (result.__originHTTPURLResponse__) {
                    [resultImformationString appendFormat:@"返回HTTP头部:\n%@\n", result.__originHTTPURLResponse__.allHeaderFields];
                }

                if (result.__originHTTPResponseData__) {
                    [resultImformationString
                        appendFormat:@"返回HTTP Body内容:\n%@\n", [[NSString alloc] initWithData:result.__originHTTPResponseData__
                                                                                        encoding:NSUTF8StringEncoding]];
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

            [weakself.progressView setProgress:(1.0f * totalBytesSent) / totalBytesExpectedToSend animated:YES];
            weakself.labUploadState.text = [NSString stringWithFormat:@"上传中（%.0f%%）", 1.0f * totalBytesSent / totalBytesExpectedToSend * 100];
        });
    }];

    [[QCloudCOSTransferMangerService costransfermangerServiceForKey:@"PermanentCredential"] UploadObject:upload];
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

- (void)showErrorMessage:(NSString *)message {
    self.tvResult.text = message;
}

- (void)dealloc {
    if (self.advancedRequest != nil) {
        [self.advancedRequest cancel];
    }
}

- (void)uploadFileToBucket {
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSString *tempPath = QCloudTempFilePathWithExtension(@"png");
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
