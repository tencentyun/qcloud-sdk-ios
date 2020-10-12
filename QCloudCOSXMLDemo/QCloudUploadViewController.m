//
//  QCloudUploadViewController.m
//  QCloudCOSXMLDemo
//
//  Created by Dong Zhao on 2017/6/11.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#ifndef BUILD_FOR_TEST

#import "QCloudUploadViewController.h"
#import <QCloudCOSXML/QCloudCOSXML.h>
#import "QCloudCOSXMLContants.h"
#import "NSURL+FileExtension.h"
#import "QCloudCOSXMLConfiguration.h"
#import "AppDelegate.h"

@interface QCloudUploadViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong)  UIImageView* imagePreviewView;
@property (nonatomic, strong)  UIProgressView* progressView;

@property (nonatomic,strong) UIView *operationsView;
@property (nonatomic, strong)  UITextView* resultTextView;


@property (nonatomic, strong) NSString* uploadTempFilePath;
@property (nonatomic, weak) QCloudCOSXMLUploadObjectRequest* uploadRequest;
@property (nonatomic, strong) NSData* uploadResumeData;
@property (nonatomic, copy) NSString* uploadBucket;
@property (nonatomic,strong)QCloudServiceConfiguration *config;
@end

@implementation QCloudUploadViewController
- (NSString*) tempFileWithSize:(int)size
{
    NSString* file4MBPath = QCloudPathJoin(QCloudTempDir(), [NSUUID UUID].UUIDString);
    
    if (!QCloudFileExist(file4MBPath)) {
        [[NSFileManager defaultManager] createFileAtPath:file4MBPath contents:[NSData data] attributes:nil];
    }
    NSFileHandle* handler = [NSFileHandle fileHandleForWritingAtPath:file4MBPath];
    [handler truncateFileAtOffset:size];
    [handler closeFile];
    
    return file4MBPath;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(selectImage)];
    self.title = @"上传";
    self.tabBarController.navigationItem.rightBarButtonItems = @[rightItem];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpContent];
    
}
-(void)setUpContent{
    self.imagePreviewView = [[UIImageView alloc] init];
    [self.view addSubview:self.imagePreviewView];
    
    self.progressView = [[UIProgressView alloc]init];
    self.progressView.backgroundColor = [UIColor lightGrayColor];
    self.progressView.progressTintColor = [UIColor blueColor];
    [self.view addSubview:self.progressView];
    
    self.operationsView = [[UIView alloc]init];
    [self.view addSubview:self.operationsView];
    
    NSArray *actions = @[@"上传",@"暂停",@"续传",@"取消"];
    for (int i = 0; i<actions.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:actions[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        [self.operationsView addSubview:button];
        switch (i) {
            case 0:
                [button addTarget:self action:@selector(beginUpload:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 1:
            [button addTarget:self action:@selector(pasueUpload:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 2:
                [button addTarget:self action:@selector(resumeUpload:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 3:
                [button addTarget:self action:@selector(abortUpload:) forControlEvents:UIControlEventTouchUpInside];
                break;
                
            default:
                break;
        }
    }
    self.resultTextView = [[UITextView alloc]init];
    self.resultTextView.text = @"上传结果的信息展示";
    [self.view addSubview:self.resultTextView];
    
    
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat space = 20;
    self.imagePreviewView.frame = CGRectMake(space, 0,screenW - space*2 , 300);
    self.progressView.frame = CGRectMake(space, CGRectGetMaxY(self.imagePreviewView.frame)+space, self.imagePreviewView.frame.size.width, 10);
    self.operationsView.frame = CGRectMake(space, CGRectGetMaxY(self.progressView.frame)+space,  self.imagePreviewView.frame.size.width, 40);
    NSUInteger count  = self.operationsView.subviews.count;
    CGFloat w = (screenW - space*2 - space*(count - 1))/count;
    for (int i = 0; i<self.operationsView.subviews.count; i++) {
        UIButton *button = self.operationsView.subviews[i];
        button.frame = CGRectMake((space + w )*i, 0, w, 40);
    }
    self.resultTextView.frame = CGRectMake(space, CGRectGetMaxY(self.operationsView.frame)+space,  self.imagePreviewView.frame.size.width, 200);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tabBarController.navigationItem setTitle:@"上传"];
    [self.progressView setProgress:0.0f animated:NO];
}

- (void)  selectImage{
    UIImagePickerController* picker = [UIImagePickerController new];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSString* tempPath = QCloudTempFilePathWithExtension(@"png");
    [UIImagePNGRepresentation(image) writeToFile:tempPath atomically:YES];
    self.uploadTempFilePath = tempPath;
    self.imagePreviewView.image = image;
    [picker dismissViewControllerAnimated:NO completion:^{
        
    }];
}

- (void) showErrorMessage:(NSString*)message
{
    self.resultTextView.text = message;
}

- (void) beginUpload:(id)sender
{
    if (!self.uploadTempFilePath) {
        [self showErrorMessage:@"没有选择文件！！！"];
        return;
    }
    if (self.uploadRequest) {
        [self showErrorMessage:@"在上传中，请稍后重试"];
        return;
    }
    QCloudCOSXMLUploadObjectRequest* upload = [QCloudCOSXMLUploadObjectRequest new];
//    upload.enableQuic = YES;
    upload.bucket = self.uploadBucket;
    
//    upload.body = [NSURL fileURLWithPath:[self tempFileWithSize:1*1024*1024]];
    upload.body = [NSURL fileURLWithPath:self.uploadTempFilePath];



    upload.object = [NSUUID UUID].UUIDString;
    [self uploadFileByRequest:upload];
}

- (void) abortUpload:(id)sender
{
    if (!self.uploadRequest) {
        [self showErrorMessage:@"不存在上传请求，无法完全中断上传"];
        return;
    }
    __weak typeof(self) weakSelf = self;
    [self.uploadRequest abort:^(id outputObject, NSError *error) {
        weakSelf.uploadRequest = nil;
    }];
}


- (void)dealloc {
    if (self.uploadRequest) {
        [self.uploadRequest cancel];
    }
}
- (void) pasueUpload:(id)sender {
    QCloudLogDebug(@"点击了暂停按钮");
    if (!self.uploadRequest) {
        [self showErrorMessage:@"不存在上传请求，无法暂停上传"];
        return;
    }
    NSError* error;
    self.uploadResumeData = [self.uploadRequest cancelByProductingResumeData:&error];
    if (error) {
        [self showErrorMessage:error.localizedDescription];
    } else {
        [self showErrorMessage:@"暂停成功"];
    }
}

- (void)resumeUpload:(id)sender {
    if (!self.uploadResumeData) {
        [self showErrorMessage:@"不再在恢复上传数据，无法继续上传"];
        return;
    }
    QCloudCOSXMLUploadObjectRequest* upload = [QCloudCOSXMLUploadObjectRequest requestWithRequestData:self.uploadResumeData];
    [self uploadFileByRequest:upload];
}

- (void) uploadFileByRequest:(QCloudCOSXMLUploadObjectRequest*)upload
{
    [self showErrorMessage:@"开始上传"];
    _uploadRequest = upload;
    
    
    __weak typeof(self) weakSelf = self;
    NSDate* beforeUploadDate = [NSDate date];
    NSString* fileSizeDescription =  [(NSURL*)upload.body fileSizeWithUnit];
    double fileSizeSmallerThan1024 = [(NSURL*)upload.body fileSizeSmallerThan1024];
    NSString* fileSizeCount = [(NSURL*)upload.body fileSizeCount];
    [upload setFinishBlock:^(QCloudUploadObjectResult *result, NSError * error) {
    
        weakSelf.uploadRequest = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [weakSelf showErrorMessage:error.localizedDescription];
            } else {
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
            [weakSelf.progressView setProgress:(1.0f*totalBytesSent)/totalBytesExpectedToSend animated:YES];
            QCloudLogDebug(@"⬆️⬆️⬆️⬆️⬆️⬆️⬆️bytesSent: %i, totoalBytesSent %i ,totalBytesExpectedToSend: %i ",bytesSent,totalBytesSent,totalBytesExpectedToSend);
        });
    }];

    QCloudCOSTransferMangerService *transferService = [QCloudCOSXMLConfiguration sharedInstance].currentTransferManager;
    [transferService UploadObject:upload];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSString *)uploadBucket {
    return [QCloudCOSXMLConfiguration sharedInstance].currentBucket;
}
@end
#endif
