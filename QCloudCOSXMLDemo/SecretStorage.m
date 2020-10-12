//
//  SecretStorage.m
//  QCloudCOSXMLDemoTests
//
//  Created by karisli(李雪) on 2019/1/22.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "SecretStorage.h"

@implementation SecretStorage
+(instancetype)sharedInstance {
    static SecretStorage* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SecretStorage alloc] init];
    });
    return  instance;
}

-(instancetype) init {
    self = [super init];
    NSString* path = [[NSBundle mainBundle] pathForResource:@"key" ofType:@"json"];
    NSData* jsonData = [[NSData alloc] initWithContentsOfFile:path];
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    self.secretID = dict[@"secretID"];
    self.secretKey = dict[@"secretKey"];
    self.appID = dict[@"appId"];
    return  self;
}
@end
