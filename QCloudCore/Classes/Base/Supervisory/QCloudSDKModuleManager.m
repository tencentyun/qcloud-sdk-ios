//
//  QCloudSDKModuleManager.m
//  Pods
//
//  Created by Dong Zhao on 2017/5/26.
//
//

#import "QCloudSDKModuleManager.h"
#import "QCloudObjectModel.h"
@interface QCloudSDKModuleManager  ()
{
    NSMutableArray* _modules;
}

@end

@implementation QCloudSDKModuleManager
+ (QCloudSDKModuleManager*) shareInstance
{
    static QCloudSDKModuleManager* share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [QCloudSDKModuleManager new];
    });
    return share;
}

- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _modules = [NSMutableArray new];
    return self;
}

- (NSArray*) allModules
{
    return [_modules copy];
}

- (void) registerModule:(QCloudSDKModule*)module
{
    if (!module) {
        return;
    }
    @synchronized (self) {
        [_modules addObject:module];
    }
}

- (void) registerModuleByJSON:(NSDictionary *)json
{
    if (!json.count) {
        return;
    }
    QCloudSDKModule* module = [QCloudSDKModule qcloud_modelWithJSON:json];
    if (!module) {
        return;
    }
    [self registerModule:module];
}

@end


@implementation QCloudSDKModule


@end
