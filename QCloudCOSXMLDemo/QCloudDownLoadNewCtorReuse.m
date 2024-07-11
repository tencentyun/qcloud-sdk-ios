//
//  QCloudDownLoadNewCtorReuse.m
//  QCloudCOSXMLDemo
//
//  Created by garenwang on 2020/5/18.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "QCloudDownLoadNewCtorReuse.h"
#import "NSURL+FileExtension.h"

@interface QCloudDownLoadNewCtorReuse ()<QCloudSignatureProvider,QCloudCredentailFenceQueueDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labTips;

/// 进度条
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *btnStart;
@property (weak, nonatomic) IBOutlet UIButton *btnPause;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;


@property (weak, nonatomic) IBOutlet UILabel *result;

@property (nonatomic, strong) NSString *fileName;

@property (nonatomic, strong) QCloudCOSXMLDownloadObjectRequest *request;

@property (nonatomic, strong) QCloudCredentailFenceQueue *credentialFenceQueue;

@property (nonatomic,strong)NSString * appID;
@property (nonatomic,strong)NSString * bucket;
@property (nonatomic,strong)NSString * region;

@end

@implementation QCloudDownLoadNewCtorReuse

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCOSFileInfo];
    // 注册 cos 服务实例。需实现 QCloudSignatureProvider ，业务中推荐放在单例中初始化。
    [self setupCOSXMLService];
    _labTips.text = @"体验之前，请在 QCloudDownLoadNewCtorReuse 类中的 setCOSFileInfo:文件信息，fenceQueue:配置请求临时密钥";
}


-(void)setCOSFileInfo{
    self.appID = @"";
    self.bucket = @"";
    self.region = @"";
    self.fileName = @"";
}

-(void)setupCOSXMLService{
    
    self.credentialFenceQueue = [QCloudCredentailFenceQueue new];
    self.credentialFenceQueue.delegate = self;
    
    QCloudServiceConfiguration *configuration = [QCloudServiceConfiguration new];
    configuration.appID = self.appID;
    QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.regionName = self.region;
    configuration.endpoint = endpoint;
    configuration.signatureProvider = self;
    [QCloudCOSXMLService registerCOSXMLWithConfiguration:configuration withKey:@"ReuseCredential_download"];
    [QCloudCOSTransferMangerService registerCOSTransferMangerWithConfiguration:configuration withKey:@"ReuseCredential_download"];
}

- (void)signatureWithFields:(QCloudSignatureFields *)fileds
                    request:(QCloudBizHTTPRequest *)request
                 urlRequest:(NSMutableURLRequest *)urlRequst
                  compelete:(QCloudHTTPAuthentationContinueBlock)continueBlock {
    
    [self.credentialFenceQueue performAction:^(QCloudAuthentationCreator *creator, NSError *error) {
        if (error) {
            continueBlock(nil, error);
        } else {
            QCloudSignature *signature = [creator signatureForData:urlRequst];
            continueBlock(signature, nil);
        }
    }];
}

- (void)fenceQueue:(QCloudCredentailFenceQueue *)queue requestCreatorWithContinue:(QCloudCredentailFenceQueueContinue)continueBlock {
    [[[NSURLSession sharedSession]dataTaskWithURL:[NSURL URLWithString:@"http://获取临时密钥业务接口业务接口"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            // 从业务服务接口请求临时密钥。
            QCloudCredential *credential = [QCloudCredential new];
            credential.secretID = @"临时secretID";
            credential.secretKey = @"临时secretKey";
            credential.token = @"token";
            //签名过期时间
            credential.expirationDate = nil;
            credential.startDate = nil;
            QCloudAuthentationV5Creator *creator = [[QCloudAuthentationV5Creator alloc] initWithCredential:credential];
            continueBlock(creator, nil);
        }] resume];
}

- (void)startDownload {
    _request = [[QCloudCOSXMLDownloadObjectRequest alloc] init];
    _request.downloadingURL = [self tempFileURLWithName:self.fileName];
    _request.bucket = self.bucket;
    _request.object = self.fileName;
    _request.resumableDownload = YES;
    DEF_WeakSelf(self);

    _request.downProcessBlock = ^(int64_t bytesDownload, int64_t totalBytesDownload, int64_t totalBytesExpectedToDownload) {

        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat progress = 1.0f * totalBytesDownload / totalBytesExpectedToDownload;
            weakself.progressView.progress = progress > 1.0f ? 1.0f : progress;
        });
    };

    NSDate *before = [NSDate date];
    _request.finishBlock = ^(id outputObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakself.request = nil;
            if (error) {
            
                weakself.result.text = @"下载失败";
            } else {
                NSDate *after = [NSDate date];
                NSTimeInterval timeSpent = [after timeIntervalSinceDate:before];
                NSURL *fileUrl = [weakself tempFileURLWithName:weakself.fileName];
                NSString * result = [NSString stringWithFormat:@"下载完成\n本地路径：%@；\n文件大小：%@;总用时：%.2fs\n平均下载速度：%.2f %@/s",[weakself tempFileURLWithName:weakself.fileName],[[weakself tempFileURLWithName:weakself.fileName] fileSizeWithUnit], timeSpent,fileUrl.fileSizeSmallerThan1024 / timeSpent, fileUrl.fileSizeCount];
                weakself.result.text = result;
            }
        });
    };

    [[QCloudCOSTransferMangerService costransfermangerServiceForKey:@"ReuseCredential_download"] DownloadObject:_request];
}

- (NSURL *)tempFileURLWithName:(NSString *)fileName {
    return [NSURL fileURLWithPath:[QCloudTempDir() stringByAppendingPathComponent:fileName]];
}

- (IBAction)actionStart:(id)sender {
    [self startDownload];
}
- (IBAction)actionPause:(id)sender {
    if (_request && !_request.canceled) {
        [_request cancel];
    }
    _request = nil;
    self.result.text = @"下载暂停";
}
- (IBAction)actionCancel:(id)sender {
    if (_request && !_request.canceled) {
        [_request cancel];
    }
    _request = nil;
    self.result.text = @"下载取消";
}


- (void)dealloc {
    //   正在下载的文件，如果用户点击退出，当前请求应该取消
    if (_request != nil) {
        [_request cancel];
    }
}

@end
