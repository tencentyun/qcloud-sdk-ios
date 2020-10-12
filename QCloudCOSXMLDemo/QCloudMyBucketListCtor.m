//
//  QCloudMyBucketListCtor.m
//  QCloudCOSXMLDemo
//
//  Created by garenwang on 2020/5/15.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "QCloudMyBucketListCtor.h"
#import <QCloudCOSXML/QCloudCOSXML.h>
#import "QCloudCOSXMLContants.h"
#import "DownloadTableViewCell.h"
#import "QCloudCOSXMLConfiguration.h"
#import "QCloudDownloadFinishViewController.h"
#import "QCCouldMyBucketCell.h"
#import "QCloudTabBarViewController.h"
#import "QCloudCreateBucketCtor.h"
#import "QCloudFileListCtor.h"

NSString * const REUSE_IDENTIFIER_MINE = @"BUCKET_MINE_VIEW_CELL";

NSInteger const RowHeight = 80;

@interface QCloudMyBucketListCtor ()

@property (nonatomic, strong) UIActivityIndicatorView* indicatorView;
@property (nonatomic, strong) NSMutableArray<QCloudBucket*>* contentsArray;

@end

@implementation QCloudMyBucketListCtor

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self fetchData];
}

-(void)setupUI{
    
    self.title = @"我的存储桶";
    [self.view addSubview:self.indicatorView];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithTitle:@"新建桶" style:UIBarButtonItemStylePlain target:self action:@selector(createBucket)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self.tableView registerClass:[QCCouldMyBucketCell class] forCellReuseIdentifier:REUSE_IDENTIFIER_MINE];
    self.tableView.rowHeight = RowHeight;
}


- (void)fetchData {

    [self.indicatorView startAnimating];
    
//  根据用户信息： 获取当前用户所有地区下的存储桶列表，
//    实例化 QCloudGetServiceRequest
//    调用 QCloudCOSXMLService 实例的 GetService 方法 发起请求
//    在FinishBlock获取结果
    QCloudGetServiceRequest* request = [QCloudGetServiceRequest new];
    DEF_WeakSelf(self)
    [request setFinishBlock:^(QCloudListAllMyBucketsResult * _Nullable result, NSError * _Nullable error) {
        DEF_StrongSelf(self)
    
        self.contentsArray = [result.buckets mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.indicatorView stopAnimating];
        });
    }];
    
    [[QCloudCOSXMLConfiguration sharedInstance].currentService GetService:request];
}

-(void)createBucket{
    QCloudCreateBucketCtor * createVC = [[QCloudCreateBucketCtor alloc]init];
    [self.navigationController pushViewController:createVC animated:YES];
}

-(void)exchangeRegion{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.contentsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QCCouldMyBucketCell *cell = [tableView dequeueReusableCellWithIdentifier:REUSE_IDENTIFIER_MINE forIndexPath:indexPath];
    
    cell.cellContent = self.contentsArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [QCloudCOSXMLConfiguration sharedInstance].currentBucket = self.contentsArray[indexPath.row].name;
    NSString* regionName = self.contentsArray[indexPath.row].location;
    [QCloudCOSXMLConfiguration sharedInstance].currentRegion = regionName;
    QCloudServiceConfiguration* configuration = [[QCloudCOSXMLService defaultCOSXML].configuration copy];
    configuration.endpoint.regionName = regionName;
    [QCloudCOSTransferMangerService registerCOSTransferMangerWithConfiguration:configuration withKey:regionName];
    
    [QCloudCOSXMLService registerCOSXMLWithConfiguration:configuration withKey:regionName];
    [self.navigationController pushViewController:[QCloudFileListCtor new] animated:YES];
    
}

@end
