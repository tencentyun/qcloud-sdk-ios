//
//  QCloudDownloadFinishViewController.m
//  QCloudCOSXMLDemo
//
//  Created by erichmzhang(张恒铭) on 26/04/2018.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import "QCloudDownloadFinishViewController.h"
#import "NSURL+FileExtension.h"
@interface QCloudDownloadFinishViewController ()
@property (strong, nonatomic)  UITextView *DownloadImformationTextView;
@property (strong, nonatomic) UIButton *openWithOtherApplicationButton;

@end

@implementation QCloudDownloadFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.DownloadImformationTextView = [[UITextView alloc] initWithFrame:self.view.bounds textContainer:nil];
    [self.view addSubview:self.DownloadImformationTextView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onHandleOpenViaOtherApplicationButtonClicked:(id)sender {
    UIActivityViewController* activityViewController;
    NSMutableArray* itemsToShare = [NSMutableArray array];
    [itemsToShare addObject:self.fileURL];
    activityViewController = [[UIActivityViewController alloc] initWithActivityItems:[itemsToShare copy] applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeAssignToContact];
    activityViewController.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        NSLog(@"Share via system result %d",completed);
    };
    [self presentViewController:activityViewController animated:YES completion:nil];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setImformation:_imformation];
}


- (void)setImformation:(QCloudTaskImformation *)imformation {
    _imformation = imformation;
    self.fileURL = imformation.fileURL;
    NSTimeInterval timeSpent = imformation.timeSpent;
    NSString* fileSizeDescriptioin = [self.fileURL fileSizeWithUnit];
    double fileSizeSmallerThan1024 = [self.fileURL fileSizeSmallerThan1024];
    NSString* fileSizeCount = [self.fileURL fileSizeCount];
    NSMutableString* string = [[NSMutableString alloc] init];
    [string appendFormat:@"文件大小:%@\n\n",fileSizeDescriptioin];
    [string appendFormat:@"下载时间:%.2f s\n\n", timeSpent];
    [string appendFormat:@"下载速度:%.2f %@/s",fileSizeSmallerThan1024/imformation.timeSpent,fileSizeCount];
    [self.DownloadImformationTextView setText:string];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
