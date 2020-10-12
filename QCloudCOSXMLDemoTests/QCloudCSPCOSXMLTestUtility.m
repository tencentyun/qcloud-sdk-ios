//
//  QCloudCSPCOSXMLTestUtility.m
//  QCloudCOSXMLDemoTests
//
//  Created by karisli(李雪) on 2018/8/31.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "QCloudCSPCOSXMLTestUtility.h"
#import "TestCommonDefine.h"
@implementation QCloudCSPCOSXMLTestUtility
+(instancetype)sharedInstance{
    static QCloudCSPCOSXMLTestUtility* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[QCloudCSPCOSXMLTestUtility alloc] init];
    });
    return instance;
}
-(QCloudCOSXMLService *)cosxmlService{
    return [QCloudCOSXMLService cosxmlServiceForKey:kCSPServiceKey];
}
@end
