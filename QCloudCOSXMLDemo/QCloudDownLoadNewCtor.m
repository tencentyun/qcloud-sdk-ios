//
//  QCloudDownLoadNewCtor.m
//  QCloudCOSXMLDemo
//
//  Created by garenwang on 2020/5/18.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "QCloudDownLoadNewCtor.h"
#import "NSURL+FileExtension.h"


@interface QCloudDownLoadNewCtor ()


/// 进度条
@property(nonatomic,strong)UIProgressView * progressView;

///  下载中+进度。完成
@property(nonatomic,strong)UILabel * labDownloadState;

/// 文件名
@property(nonatomic,strong)UILabel * labFileName;

/// 文件大小
@property(nonatomic,strong)UILabel * labFileSize;

/// 下载平均速度
@property(nonatomic,strong)UILabel * labDownloadSpeed;

/// 下载耗费时间
@property(nonatomic,strong)UILabel * labDuration;

@property (nonatomic,strong) QCloudGetObjectRequest * request;

@end

@implementation QCloudDownLoadNewCtor

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [self fetchData];
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    

    CGFloat heigth = 30;

    CGFloat margin = 12;
    
    _labDownloadState.frame = CGRectMake(SCREEN_WIDTH - (2 * margin) - 120, margin ,120 , heigth);
    
    _progressView.frame = CGRectMake(margin, margin, SCREEN_WIDTH - (3 * margin) - 120, heigth);
    
    _progressView.center = CGPointMake(_progressView.center.x, _labDownloadState.center.y);
    
    _labFileName.frame = CGRectMake(margin, _progressView.frame.origin.y + heigth + margin, SCREEN_WIDTH - margin * 2, heigth);
    
    _labFileSize.frame = CGRectMake(margin, _labFileName.frame.origin.y + heigth + margin, SCREEN_WIDTH - margin * 2, heigth);
    
    _labDownloadSpeed.frame = CGRectMake(margin, _labFileSize.frame.origin.y + heigth + margin, SCREEN_WIDTH - margin * 2, heigth);
    
    _labDuration.frame = CGRectMake(margin, _labDownloadSpeed.frame.origin.y + heigth + margin, SCREEN_WIDTH - margin * 2, heigth);
}

-(void)setupUI{
    
    self.title = @"下载详情";
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    _progressView = [[UIProgressView alloc]init];
    _progressView.backgroundColor = [UIColor lightGrayColor];
    _progressView.progressTintColor = [UIColor blueColor];
    [self.view addSubview:_progressView];
    
    _labDownloadState = [[UILabel alloc]init];
    _labDownloadState.textAlignment = NSTextAlignmentCenter;
    _labDownloadState.textColor = [UIColor systemBlueColor];
    _labDownloadState.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_labDownloadState];
    
    _labFileName = [[UILabel alloc]init];
    _labFileName.textColor = DEF_HEXCOLOR(0x333333);
    _labFileName.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_labFileName];
    
    _labFileSize = [[UILabel alloc]init];
    _labFileSize.textColor = DEF_HEXCOLOR(0x333333);
    _labFileSize.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_labFileSize];
    
    _labDownloadSpeed = [[UILabel alloc]init];
    _labDownloadSpeed.textColor = DEF_HEXCOLOR(0x333333);
    _labDownloadSpeed.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_labDownloadSpeed];
    
    _labDuration = [[UILabel alloc]init];
    _labDuration.textColor = DEF_HEXCOLOR(0x333333);
    _labDuration.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_labDuration];
    
    _progressView.progress = 0.f;
    _labDownloadState.text = @"下载中";
    _labFileName.text = [NSString stringWithFormat:@"文件名称：%@",_content.key];
    _labFileSize.text = [NSString stringWithFormat:@"文件大小：%@",_content.fileSize];
    _labDownloadSpeed.text = @"";
    _labDuration.text = @"";
    
}

-(void)fetchData{
    
//    下载存储桶中文件对象：
//    实例化 QCloudGetObjectRequest
//    调用 QCloudCOSXMLService 实例的 GetObject 方法 发起请求
//    在downProcessBlock 回调中 处理下载进度
//    在FinishBlock获取结果
//          参数：桶名称 + 文件唯一标识 + 本地下载路径
    _request = [[QCloudGetObjectRequest alloc]init];
    _request.downloadingURL = [self tempFileURLWithName:_content.key];
    _request.bucket = CURRENT_BUCKET;
    _request.object = _content.key;

    DEF_WeakSelf(self);
    
    _request.downProcessBlock = ^(int64_t bytesDownload, int64_t totalBytesDownload, int64_t totalBytesExpectedToDownload) {
//      bytesDownload       一次下载的字节数，
//      totalBytesDownload  总过接受的字节数
//      totalBytesExpectedToDownload 文件一共多少字节
        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat progress = 1.0f * totalBytesDownload / totalBytesExpectedToDownload;
            weakself.progressView.progress = progress > 1.0f ? 1.0f : progress;
            weakself.labDownloadState.text = [NSString stringWithFormat:@"下载中（%.1f%%）",progress * 100];
        });
    };
    
    NSDate* before = [NSDate date];
    _request.finishBlock = ^(id outputObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakself.request = nil;
            if (error) {
                weakself.labDownloadState.text = @"下载失败";
            }else{
                
                NSDate* after = [NSDate date];
                NSTimeInterval timeSpent = [after timeIntervalSinceDate:before];
                NSURL * fileUrl = [weakself tempFileURLWithName:weakself.content.key];
                
                weakself.labDownloadState.text = @"下载完成";
                weakself.labFileSize.text = [NSString stringWithFormat:@"文件大小：%@",[fileUrl fileSizeWithUnit]];
                weakself.labDuration.text = [NSString stringWithFormat:@"总用时：%.2fs",timeSpent];
//                fileSizeSmallerThan1024/imformation.timeSpent,fileSizeCount
                weakself.labDownloadSpeed.text = [NSString stringWithFormat:@"平均下载速度：%.2f %@/s",fileUrl.fileSizeSmallerThan1024 / timeSpent,fileUrl.fileSizeCount];
            }
            
        });
    };
    
    [CURRENT_SERVICE GetObject:_request];
}


- (NSURL*)tempFileURLWithName:(NSString*)fileName {
    return [NSURL fileURLWithPath:[QCloudTempDir() stringByAppendingPathComponent:fileName]];
}

-(void)dealloc{
    
//   正在下载的文件，如果用户点击退出，当前请求应该取消
    if (_request != nil) {
        [_request cancel];
    }
}

@end
