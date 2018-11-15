//
//  QCloudLogManager.m
//  QCloudCOSXML
//
//  Created by erichmzhang(张恒铭) on 2018/10/8.
//
#if TARGET_OS_IPHONE
#import "QCloudLogManager.h"
#import <QCloudCore/QCloudCore.h>
#import "QCloudLogTableViewController.h"
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
    if ([self shouldShowLogs]) {
         [UIPasteboard generalPasteboard].string = @"";
        [self showLogs];
    }
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
        [currentViewController presentViewController:tableViewController animated:YES completion:nil];
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
