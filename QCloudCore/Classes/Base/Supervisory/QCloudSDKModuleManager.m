//
//  QCloudSDKModuleManager.m
//  Pods
//
//  Created by Dong Zhao on 2017/5/26.
//
//

#import "QCloudSDKModuleManager.h"
#import "QCloudObjectModel.h"

// 模块信息提供类名列表
static NSArray<NSString *> *QCloudModuleInfoProviderClassNames(void) {
    return @[
        @"QCloudQCloudCoreLoad",
        @"QCloudQCloudCOSXMLLoad",
        @"QCloudQCloudTrackLoad",
        @"QCloudQCloudQuicLoad",
        @"QCloudQCloudNewCOSV4Load"
    ];
}

@interface QCloudSDKModuleManager () {
    NSMutableArray *_modules;
    BOOL _hasRegistered;
}
@property (nonatomic, strong) dispatch_queue_t dispatchQueue;
@end

@implementation QCloudSDKModuleManager
+ (QCloudSDKModuleManager *)shareInstance {
    static QCloudSDKModuleManager *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [QCloudSDKModuleManager new];
    });
    return share;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return self;
    }
    _dispatchQueue = dispatch_queue_create("com.tencent.qcloud.sdkmodulemanager", DISPATCH_QUEUE_SERIAL);
    _modules = [NSMutableArray new];
    _hasRegistered = NO;
    return self;
}

- (NSArray *)allModules {
    return [_modules copy];
}

- (void)registerModule:(QCloudSDKModule *)module {
    if (!module) {
        return;
    }
    @synchronized(self) {
        // 检查是否已注册过同名模块
        for (QCloudSDKModule *existingModule in _modules) {
            if ([existingModule.name isEqualToString:module.name]) {
                return;
            }
        }
        [_modules addObject:module];
    }
}

- (void)registerModuleByJSON:(NSDictionary *)json {
    if (!json.count) {
        return;
    }
    dispatch_async(self.dispatchQueue, ^{
        QCloudSDKModule *module = [QCloudSDKModule qcloud_modelWithJSON:json];
        if (!module) {
            return;
        }
        [self registerModule:module];
    });
}

- (void)registerAllModules {
    @synchronized(self) {
        if (_hasRegistered) {
            return;
        }
        _hasRegistered = YES;
        
        SEL nameSel = NSSelectorFromString(@"moduleName");
        SEL versionSel = NSSelectorFromString(@"moduleVersion");
        
        for (NSString *className in QCloudModuleInfoProviderClassNames()) {
            Class cls = NSClassFromString(className);
            if (!cls || ![cls respondsToSelector:nameSel] || ![cls respondsToSelector:versionSel]) {
                continue;
            }
            
            NSString *(*getName)(Class, SEL) = (void *)[cls methodForSelector:nameSel];
            NSString *(*getVersion)(Class, SEL) = (void *)[cls methodForSelector:versionSel];
            NSString *name = getName(cls, nameSel);
            NSString *version = getVersion(cls, versionSel);
            
            if (name && version) {
                [self registerModuleByJSON:@{@"name": name, @"version": version}];
            }
        }
    }
}

@end

@implementation QCloudSDKModule

@end
