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
#import "MTAConfig.h"
#import "QCloudMyBucketListCtor.h"
//#import <QCloudCOSXML/QCloudLogManager.h>
//#define  USE_TEMPERATE_SECRET

@interface AppDelegate () <QCloudSignatureProvider, QCloudCredentailFenceQueueDelegate>

@property (nonatomic, strong) QCloudCredentailFenceQueue* credentialFenceQueue;
@end

@interface AppDelegate () <QCloudSignatureProvider>

@end


@implementation AppDelegate

- (void) fenceQueue:(QCloudCredentailFenceQueue *)queue requestCreatorWithContinue:(QCloudCredentailFenceQueueContinue)continueBlock
{                                                                                                                                                                                             
   QCloudCredential* credential = [QCloudCredential new];
   credential.secretID = @"secretID";
   credential.secretKey = @"secretKey";
    //签名过期时间
   credential.experationDate = [NSDate dateWithTimeIntervalSince1970:1504183628];
   credential.token = @"token";
   QCloudAuthentationV5Creator* creator = [[QCloudAuthentationV5Creator alloc] initWithCredential:credential];
   continueBlock(creator, nil);
}
- (void) signatureWithFields:(QCloudSignatureFields*)fileds
                     request:(QCloudBizHTTPRequest*)request
                  urlRequest:(NSMutableURLRequest*)urlRequst
                   compelete:(QCloudHTTPAuthentationContinueBlock)continueBlock
{
#ifdef USE_TEMPERATE_SECRET
    [self.credentialFenceQueue performAction:^(QCloudAuthentationCreator *creator, NSError *error) {
        if (error) {
            continueBlock(nil, error);
        } else {
            QCloudSignature* signature =  [creator signatureForData:urlRequst];
            continueBlock(signature, nil);    
        }
    }];
#else
    QCloudCredential* credential = [QCloudCredential new]; 
    credential.secretID  = [SecretStorage sharedInstance].secretID;
    credential.secretKey = [SecretStorage sharedInstance].secretKey;
    QCloudAuthentationV5Creator* creator = [[QCloudAuthentationV5Creator alloc] initWithCredential:credential];
    QCloudSignature* signature =  [creator signatureForData:urlRequst];
    continueBlock(signature, nil);
#endif
}

- (void) setupCOSXMLShareService {
    QCloudServiceConfiguration* configuration = [QCloudServiceConfiguration new];
    //关闭读取系统剪贴板的功能
    configuration.appID = [SecretStorage sharedInstance].appID;
    configuration.signatureProvider = self;
    QCloudCOSXMLEndPoint* endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.regionName = kRegion;
    endpoint.useHTTPS = YES;
    configuration.endpoint = endpoint;
   
    [QCloudCOSXMLService registerDefaultCOSXMLWithConfiguration:configuration];
    [QCloudCOSTransferMangerService registerDefaultCOSTransferMangerWithConfiguration:configuration];

}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupCOSXMLShareService];
    self.credentialFenceQueue = [QCloudCredentailFenceQueue new];
    self.credentialFenceQueue.delegate = self;
    [[TACMTAConfig getInstance] setDebugEnable:YES];
    
    [QCloudCOSXMLConfiguration sharedInstance].currentRegion = kRegion;
    QCloudServiceConfiguration* configuration = [[QCloudCOSXMLService defaultCOSXML].configuration copy];
    configuration.endpoint.regionName = kRegion;
    [QCloudCOSTransferMangerService registerCOSTransferMangerWithConfiguration:configuration withKey:kRegion];
    
    [QCloudCOSXMLService registerCOSXMLWithConfiguration:configuration withKey:kRegion];
    
    QCloudMyBucketListCtor * bucketList = [[QCloudMyBucketListCtor alloc]init];
    _window = [[UIWindow alloc]initWithFrame:SCREEN_FRAME];
    [_window makeKeyAndVisible];
    UINavigationController * navRoot = [[UINavigationController alloc]initWithRootViewController:bucketList];
    _window.rootViewController = navRoot;
    
    return YES;
}
//后台上传要实现该方法
-(void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler{

}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
