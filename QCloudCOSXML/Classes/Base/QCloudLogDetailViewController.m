//
//  QCloudLogDetailViewController.m
//  QCloudCOSXML
//
//  Created by erichmzhang(张恒铭) on 2018/10/8.
//
#if TARGET_OS_IPHONE
#import "QCloudLogDetailViewController.h"
@interface QCloudLogDetailViewController ()
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
#endif
