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
//#import "QCloudTrackCLS.h"
#import "RootViewController.h"
#import "QCloudLoaderManager.h"
#import "QCloudAFLoader.h"
#import "QCloudCore/QCloudCLSLoggerOutput.h"
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
    
//    [[QCloudLoaderManager manager]addLoader: [[QCloudAFLoader alloc]init]];
//    [QCloudLoaderManager manager].enable = YES;
    [QCloudLogger sharedLogger].logLevel = QCloudLogLevelVerbose;
    NSData *keyData = [NSData dataWithBytes:(unsigned char[]){
        0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
        0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F,
        0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
        0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E, 0x1F
    } length:32];

    NSData *ivData = [NSData dataWithBytes:(unsigned char[]){
        0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37,
        0x38, 0x39, 0x3A, 0x3B, 0x3C, 0x3D, 0x3E, 0x3F
    } length:16];
    [QCloudLogger sharedLogger].aesKey = keyData;
    [QCloudLogger sharedLogger].aesIv = ivData;
    QCloudCLSLoggerOutput * clsOutput = [[QCloudCLSLoggerOutput alloc]initWithTopicId:@"5edf1c8b-160c-43d5-8506-0a8621a3fa73" endpoint:@"ap-guangzhou.cls.tencentcs.com"];
//    [clsOutput setupPermanentCredentialsSecretId:@"" secretKey:@""];
    [clsOutput setupCredentialsRefreshBlock:^QCloudCredential * _Nonnull{
        
        dispatch_semaphore_t semp = dispatch_semaphore_create(0);
        
        NSMutableURLRequest * mrequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://9.135.33.98:3000/sts/cls"]];
        __block QCloudCredential * credential = nil;
        
        [[[NSURLSession sharedSession]dataTaskWithRequest:mrequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                
            }else{
                credential = [QCloudCredential new];
                NSDictionary * result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                NSDictionary * credentials = result[@"credentials"];
                credential.secretID = credentials[@"tmpSecretId"];
                credential.secretKey = credentials[@"tmpSecretKey"];
                credential.token = credentials[@"sessionToken"];
                credential.expirationDate =  [NSDate dateWithTimeIntervalSinceNow:[credentials[@"sessionToken"] integerValue]];
                dispatch_semaphore_signal(semp);
            }
        }]resume];
        dispatch_semaphore_wait(semp, DISPATCH_TIME_FOREVER);
        return credential;
    }];
    [[QCloudLogger sharedLogger] addLogger:clsOutput];
    
//    QCloudCLSTrackService * service = [[QCloudCLSTrackService alloc]initWithTopicId:@"c09216e3-ade5-4725-a03e-4b61e32ff4b8" endpoint:@"ap-guangzhou.cls.tencentcs.com"];
//        
//    [[QCloudTrackService singleService] addTrackService:service serviceKey:@"qcloud_track_cos_sdk"];
    
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
