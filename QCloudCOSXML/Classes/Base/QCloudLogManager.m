//
//  QCloudLogManager.m
//  QCloudCOSXML
//
//  Created by erichmzhang(张恒铭) on 2018/10/8.
//

#import "QCloudLogManager.h"

#import <QCloudCore/QCloudCore.h>
#if TARGET_OS_IOS
#import<UIKit/UIKit.h>


@interface QCloudLogDetailViewController : UIViewController
- (instancetype) initWithLogPath:(NSString *)logPath LogContent:(NSString *)logContent;
@property (nonatomic, strong) NSString *logContent;
@property (nonatomic, strong) NSString *logPath;
@property (nonatomic, strong) UITextView *textView;
@end

@implementation QCloudLogDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(onHandleShareLog)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    self.textView = [[UITextView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.textView];
}

- (instancetype) initWithLogPath:(NSString *)logPath LogContent:(NSString *)logContent {
    self = [super init];
    self.logContent = logContent;
    self.logPath = logPath;
    return self;
}

- (void)onHandleShareLog {
    NSURL *url  = [NSURL fileURLWithPath:self.logPath];
    NSArray *activityItems = @[url];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
    
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.textView.text = self.logContent;
}



@end
@interface QCloudLogTableViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *logsDirecotryArray;
- (instancetype) initWithLog:(NSArray *)logContent;
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


@implementation QCloudLogManager
+ (instancetype) sharedInstance {
    static QCloudLogManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[QCloudLogManager alloc] init];
    });
    return instance;
}

- (instancetype) init {
    self = [super init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onHandleAppBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void) onHandleAppBecomeActive :(NSNotification *)notification {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //
        NSString *currentPasteBoardContent = [UIPasteboard generalPasteboard].string;
           if ([currentPasteBoardContent isEqualToString:@"##qcloud-cos-log-ispct##"]) {
               dispatch_async(dispatch_get_main_queue(), ^{
                   [UIPasteboard generalPasteboard].string = @"";
                    [self showLogs];
               });
           
           }
    });
}


- (BOOL) shouldShowLogs {
    NSString *currentPasteBoardContent = [UIPasteboard generalPasteboard].string;
    if ([currentPasteBoardContent isEqualToString:@"##qcloud-cos-log-ispct##"]) {
        return YES;
    }
    return NO;
}


- (NSArray *)currentLogs {
    NSString *directoryPath = [QCloudLogger sharedLogger].logDirctoryPath;
    NSArray *content = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:nil];
    return content;
}

- (NSString *)readLog:(NSString *)path {
    NSData *content = [[NSFileManager defaultManager] contentsAtPath:path];
    return  [[NSString alloc] initWithData:content encoding:NSUTF8StringEncoding];
}

- (void) showLogs {
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定显示log" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* actionEnsure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction* action) {
        [self onHandleBeginShowlogs];
    }];
    UIAlertAction* actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:actionEnsure];
    [alertController addAction:actionCancel];
    UIViewController *currentViewController = [self currentViewController];
    [currentViewController presentViewController:alertController animated:YES completion:nil];
    
}
-(void)onHandleBeginShowlogs{
    NSArray *currentLogPath = [self currentLogs];
    UIViewController *currentViewController = [self currentViewController];
    QCloudLogTableViewController *tableViewController = [[QCloudLogTableViewController alloc] initWithLog:currentLogPath];
    if ([currentViewController isKindOfClass:UINavigationController.class]) {
        [((UINavigationController *)currentViewController) pushViewController:tableViewController animated:YES];
    } else {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tableViewController];
               [currentViewController presentViewController:nav animated:YES completion:nil];
    }
}
- (UIViewController *)currentViewController {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = keyWindow.rootViewController;
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
        
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = [(UINavigationController *)vc visibleViewController];
        } else if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = [(UITabBarController *)vc selectedViewController];
        }
    }
    return vc;
}

@end

#endif
