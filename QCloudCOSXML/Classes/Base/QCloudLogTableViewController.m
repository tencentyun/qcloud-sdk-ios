//
//  QCloudLogTableViewController.m
//  QCloudCOSXML
//
//  Created by erichmzhang(张恒铭) on 2018/10/8.
//
#if TARGET_OS_IPHONE
#import "QCloudLogTableViewController.h"
#import "QCloudLogDetailViewController.h"
#import <QCloudCore/QCloudCore.h>
@interface QCloudLogTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *logsDirecotryArray;
@end

@implementation QCloudLogTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}


- (instancetype)initWithLog:(NSArray *)logContent {
    self = [super init];
    self.logsDirecotryArray = logContent;
    return self;
}

#pragma  mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.logsDirecotryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse-cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }
    cell.textLabel.text = self.logsDirecotryArray[indexPath.row];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // shoud detail view
    NSString * logPath = [[QCloudLogger sharedLogger].logDirctoryPath stringByAppendingPathComponent:self.logsDirecotryArray[indexPath.row]];
    NSData *logData = [[NSFileManager defaultManager] contentsAtPath:logPath];
    NSString *logContent = [[NSString alloc] initWithData:logData encoding:NSUTF8StringEncoding];
    QCloudLogDetailViewController *viewController = [[QCloudLogDetailViewController alloc] initWithLogPath:logPath LogContent:logContent];
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
#endif
