//
//  QCloudDownloadViewController.m
//  QCloudCOSXMLDemo
//
//  Created by Dong Zhao on 2017/6/11.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import "QCloudDownloadViewController.h"

#import <QCloudCOSXML/QCloudCOSXML.h>
#import "QCloudCOSXMLContants.h"
#import "DownloadTableViewCell.h"
#import "QCloudCOSXMLConfiguration.h"
#import "QCloudDownloadFinishViewController.h"

 NSString* const REUSE_IDENTIFIER = @"BUCKET_TABLE_VIEW_CELL";

@interface QCloudDownloadViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView* bucketTableView;
@property (nonatomic, strong) NSMutableArray<QCloudBucketContents*>* contentsArray;
@property (nonatomic, strong) UIActivityIndicatorView* indicatorView;
@property (nonatomic, strong) UIDocumentInteractionController* documentInteractionController;
@end

@implementation QCloudDownloadViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    CGFloat tabBarHeight = 49.f;
    [self.tabBarController.navigationItem setTitle:@"下载"];
    self.title = @"下载";
    [self.view addSubview:self.bucketTableView];
    [self.view addSubview:self.indicatorView];
    [self.bucketTableView setFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - tabBarHeight)];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
      [self fetchData];
}

#pragma mark - data related
- (void)fetchData {
    
    [self.indicatorView startAnimating];
    QCloudGetBucketRequest* request = [QCloudGetBucketRequest new];
    request.bucket = [QCloudCOSXMLConfiguration sharedInstance].currentBucket;
    request.maxKeys = 1000;
    __weak typeof(self) weakSelf = self;
    
    [request setFinishBlock:^(QCloudListBucketResult * _Nonnull result, NSError * _Nonnull error) {
        weakSelf.contentsArray = [result.contents mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.bucketTableView reloadData];
            [weakSelf.indicatorView stopAnimating ];
        });
    }];
    
    [[QCloudCOSXMLConfiguration sharedInstance].currentService GetBucket:request];
}

- (void)downloadObjectWithKey:(NSString* )objectKey
                  finishBlock:(void(^)(id outputObject, NSError* error))finishBlock
                progressBlock:(void(^)(int64_t bytesSent,int64_t totalBytesSent,int64_t totalBytesExpectToSend))progressBlock
{
    [self.indicatorView startAnimating];
    QCloudGetObjectRequest* request = [QCloudGetObjectRequest new];
    request.bucket = [QCloudCOSXMLConfiguration sharedInstance].currentBucket;
    request.object = objectKey;
    request.downloadingURL =  [self tempFileURLWithName:objectKey];
    [request setFinishBlock:finishBlock];
    [request setDownProcessBlock:progressBlock];
    [[QCloudCOSXMLConfiguration sharedInstance].currentService GetObject:request];
}


#pragma mark - table view datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentsArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DownloadTableViewCell* cell = [[DownloadTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:REUSE_IDENTIFIER ];
    [cell setCellContent:self.contentsArray[indexPath.row]];
    return cell;
}

#pragma mark - table view delegate 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QCloudBucketContents* content = self.contentsArray[indexPath.row];
    __weak typeof(self)weakSelf = self;
    NSDate* before = [NSDate date];
    [self downloadObjectWithKey:content.key
                    finishBlock:^(id outputObject,NSError* error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                           [weakSelf.indicatorView stopAnimating];
                        });
                        if (!error) {
                            QCloudLogDebug(@"download success");
                            NSDate* after = [NSDate date];
//                            [weakSelf openFile:[weakSelf tempFileURL]];
                            QCloudTaskImformation* imfo = [[QCloudTaskImformation alloc] init];
                            imfo.timeSpent = [after timeIntervalSinceDate:before];
                            imfo.fileURL = [weakSelf tempFileURLWithName:content.key];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                QCloudDownloadFinishViewController* vc = [QCloudDownloadFinishViewController new];
                                vc.imformation = imfo;
                                [weakSelf.navigationController pushViewController:vc animated:YES];
                            });
                        }
                    }
                    progressBlock:nil];
}

#pragma mark - getters
- (UITableView*)bucketTableView {
    if (!_bucketTableView) {
        _bucketTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _bucketTableView.dataSource = self;
        _bucketTableView.delegate = self;
    }
    return _bucketTableView;
}

- (NSMutableArray*)contentsArray {
    if (!_contentsArray) {
        _contentsArray = [NSMutableArray new];
    }
    return _contentsArray;
}

- (NSURL*)tempFileURL {
    NSString* fileName = @"temp";
    NSString* pathString = [[QCloudTempDir() stringByAppendingPathComponent:fileName] stringByAppendingFormat:@"downloading"];
    QCloudLogDebug(@"下载路径%@",pathString);
    return [NSURL fileURLWithPath:pathString];
}

- (NSURL*)tempFileURLWithName:(NSString*)fileName {
    return [NSURL fileURLWithPath:[QCloudTempDir() stringByAppendingPathComponent:fileName]];
}

- (void)openFile:(NSURL*)url {
    UIDocumentInteractionController* documentController = [UIDocumentInteractionController interactionControllerWithURL:url];
    self.documentInteractionController = documentController;
    [documentController  presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
}
@end
