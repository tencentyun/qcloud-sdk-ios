//
//  AppDelegate.m
//  QCloudCOSXMLDemo
//
//  Created by Dong Zhao on 2017/2/24.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import "AppDelegate.h"
#import <QCloudCOSXML/QCloudCOSXML.h>

#import <UserNotifications/UserNotifications.h>
#import "SecretStorage.h"
#import "QCloudMyBucketListCtor.h"
#import "QCloudTrackCLS.h"
#import "RootViewController.h"
//#import "QCloudHTTPDNSLoader.h"

@interface AppDelegate () <QCloudSignatureProvider>

@end

@implementation AppDelegate

- (void)signatureWithFields:(QCloudSignatureFields *)fileds
                    request:(QCloudBizHTTPRequest *)request
                 urlRequest:(NSMutableURLRequest *)urlRequst
                  compelete:(QCloudHTTPAuthentationContinueBlock)continueBlock {
    
    QCloudCredential *credential = [QCloudCredential new];
    credential.secretID = [SecretStorage sharedInstance].secretID;
    credential.secretKey = [SecretStorage sharedInstance].secretKey;
    QCloudAuthentationV5Creator *creator = [[QCloudAuthentationV5Creator alloc] initWithCredential:credential];
    QCloudSignature *signature = [creator signatureForData:urlRequst];
    continueBlock(signature, nil);
}

- (void)setupCOSXMLShareService {
    
    QCloudServiceConfiguration *configuration = [QCloudServiceConfiguration new];

    configuration.appID = [SecretStorage sharedInstance].appID;
    configuration.signatureProvider = self;
    QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.regionName = [SecretStorage sharedInstance].region;
    configuration.endpoint = endpoint;

    [QCloudCOSXMLService registerDefaultCOSXMLWithConfiguration:configuration];
    [QCloudCOSTransferMangerService registerDefaultCOSTransferMangerWithConfiguration:configuration];

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    QCloudCLSTrackService * service = [[QCloudCLSTrackService alloc]initWithTopicId:@"c09216e3-ade5-4725-a03e-4b61e32ff4b8" endpoint:@"ap-guangzhou.cls.tencentcs.com"];
        
    [[QCloudTrackService singleService] addTrackService:service serviceKey:@"qcloud_track_cos_sdk"];
    
    [self setupCOSXMLShareService];
    
    RootViewController *bucketList = [[RootViewController alloc] init];
    _window = [[UIWindow alloc] initWithFrame:SCREEN_FRAME];
    [_window makeKeyAndVisible];
    UINavigationController *navRoot = [[UINavigationController alloc] initWithRootViewController:bucketList];
    _window.rootViewController = navRoot;

    
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        // 背景色
        appearance.backgroundColor = [UIColor whiteColor];
        // 去掉半透明效果
        appearance.backgroundEffect = nil;
        // 标题字体颜色及大小
        appearance.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:16]};
        // 设置导航栏下边界分割线透明
        appearance.shadowImage = [[UIImage alloc] init];
        // 去除导航栏阴影（如果不设置clear，导航栏底下会有一条阴影线）
        appearance.shadowColor = UIColor.whiteColor;
        // standardAppearance：常规状态, 标准外观，iOS15之后不设置的时候，导航栏背景透明
        navRoot.navigationBar.standardAppearance = appearance;
        // scrollEdgeAppearance：被scrollview向下拉的状态, 滚动时外观，不设置的时候，使用标准外观
        navRoot.navigationBar.scrollEdgeAppearance = appearance;
    }
    
    return YES;
}
//后台上传要实现该方法
- (void)application:(UIApplication *)application
    handleEventsForBackgroundURLSession:(NSString *)identifier
                      completionHandler:(void (^)(void))completionHandler {
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your
    // application to its current state in case it is terminated later. If your application supports background execution, this method is called
    // instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the
    // background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the
    // background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//-(void)setupTencentDNS{
//    QCloudDnsConfig config;
//    config.appId = @"VS065K4POAYA9P1O";
//    config.dnsIp = @"119.29.29.98";
//    config.dnsId = 96766;
//    config.dnsKey = @"cOp66erx";//des的密钥
//    config.encryptType = QCloudHttpDnsEncryptTypeDES;
//    config.debug = YES;
//    config.timeout = 5000;
//    self.dnsloader = [[QCloudHTTPDNSLoader alloc] initWithConfig:config];
//    [QCloudHttpDNS shareDNS].delegate = self.dnsloader;
//
//}

@end
