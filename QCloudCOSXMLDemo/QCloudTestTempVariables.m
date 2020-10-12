//
//  QCloudTestTempVariables.m
//  QCloudCOSXMLDemoTests
//
//  Created by erichmzhang(张恒铭) on 13/11/2017.
//  Copyright © 2017 Tencent. All rights reserved.
//

#import "QCloudTestTempVariables.h"

@implementation QCloudTestTempVariables

+ (instancetype)sharedInstance {
    static QCloudTestTempVariables * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[QCloudTestTempVariables alloc] init];
    });
    return instance;
}


@end
