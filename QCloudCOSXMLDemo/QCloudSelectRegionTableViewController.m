//
//  QCloudSelectRegionTableViewController.m
//  QCloudCOSXMLDemo
//
//  Created by erichmzhang(张恒铭) on 26/04/2018.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import "QCloudSelectRegionTableViewController.h"
#import "QCloudCOSXMLConfiguration.h"
#import "QCloudTabBarViewController.h"
#import "QCloudCOSXMLContants.h"
#import "QCloudMyBucketListCtor.h"

@interface QCloudSelectRegionTableViewController ()
@property (nonatomic, strong) NSArray* regionArray;
@end

@implementation QCloudSelectRegionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"选择 Region"];
  
    self.regionArray = [QCloudCOSXMLConfiguration sharedInstance].availableRegions;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
    
    
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelSelect)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.regionArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    [cell.textLabel setText:self.regionArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString* regionName = self.regionArray[indexPath.row];
    self.selectRegion(regionName);
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)cancelSelect{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
