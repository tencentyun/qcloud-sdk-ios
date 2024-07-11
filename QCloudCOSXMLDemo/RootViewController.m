//
//  RootViewController.m
//  QCloudCOSXMLDemo
//
//  Created by garenwang on 2024/7/8.
//  Copyright © 2024 Tencent. All rights reserved.
//

#import "RootViewController.h"
#import "QCloudMyBucketListCtor.h"
#import "QCloudUploadNewCtorPermanent.h"
#import "QCloudUploadNewCtorReuse.h"
#import "QCloudUploadNewCtorOnce.h"
#import "QCloudDownLoadNewCtorPermanent.h"
#import "QCloudDownLoadNewCtorOnce.h"
#import "QCloudDownLoadNewCtorReuse.h"

@interface RootViewController ()
@property (nonatomic,strong)NSArray * dataSource;
@property (nonatomic,strong)NSArray * headerSource;
@property (nonatomic,strong)NSArray * headerDesc;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"COS SDK 示例";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.dataSource = @[@"上传",@"下载",];
    self.headerSource = @[@"方式一：单次临时密钥",@"方式二：可复用临时密钥",@"方式三：永久临时密钥"];
    self.headerDesc = @[@"使用场景：\n适用于每组临时密钥只用于上传一个文件或一次请求。",@"使用场景：\n适用于临时密钥可复用于上传多个文件或多个请求。",@"使用场景：\n适用于开发过程中调试使用，由于该方式存在泄漏密钥的风险，请务必在上线前替换为临时密钥的方式。"];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    UIButton * footer = [UIButton buttonWithType:UIButtonTypeCustom];
    footer.backgroundColor = UIColor.blueColor;
    [footer setTitle:@"体验完整功能" forState:UIControlStateNormal];
    footer.titleLabel.font = [UIFont systemFontOfSize:18];
    [footer addTarget:self action:@selector(toExample) forControlEvents:UIControlEventTouchUpInside];
    footer.frame = CGRectMake(0, SCREEN_HEIGHT + self.tableView.contentOffset.y - 83, SCREEN_WIDTH, 83);
    [self.tableView addSubview:footer];
}

-(void)toExample{
    QCloudMyBucketListCtor * bucketList = [QCloudMyBucketListCtor new];
    [self.navigationController pushViewController:bucketList animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.headerSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataSource[indexPath.row];
    cell.backgroundColor = DEF_HEXCOLOR(0xf5f5f5);
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 90)];
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, self.view.frame.size.width - 32, 18)];
    title.textColor = UIColor.blackColor;
    title.font = [UIFont systemFontOfSize:16];
    title.text = self.headerSource[section];
    UILabel * desc = [[UILabel alloc]initWithFrame:CGRectMake(16, 20, self.view.frame.size.width - 32, 72)];
    desc.textColor = UIColor.blackColor;
    desc.font = [UIFont systemFontOfSize:15];
    desc.numberOfLines = -1;
    desc.text = self.headerDesc[section];
    
    [header addSubview:title];
    [header addSubview:desc];
    header.backgroundColor = UIColor.whiteColor;
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            QCloudUploadNewCtorOnce * once = [QCloudUploadNewCtorOnce new];
            [self.navigationController pushViewController:once animated:YES];
        }
        if (indexPath.row == 1) {
            QCloudDownLoadNewCtorOnce * download = QCloudDownLoadNewCtorOnce.new;
            [self.navigationController pushViewController:download animated:YES];
        }
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            QCloudUploadNewCtorReuse * once = [QCloudUploadNewCtorReuse new];
            [self.navigationController pushViewController:once animated:YES];
        }
        if (indexPath.row == 1) {
            QCloudDownLoadNewCtorReuse * download = QCloudDownLoadNewCtorReuse.new;
            [self.navigationController pushViewController:download animated:YES];
        }
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            QCloudUploadNewCtorPermanent * once = [QCloudUploadNewCtorPermanent new];
            [self.navigationController pushViewController:once animated:YES];
        }
        if (indexPath.row == 1) {
            QCloudDownLoadNewCtorPermanent * download = QCloudDownLoadNewCtorPermanent.new;
            [self.navigationController pushViewController:download animated:YES];
        }
    }
}

@end
