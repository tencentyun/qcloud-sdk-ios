//
//  QCloudTrackService.m
//  QCloudTrack
//
//  Created by garenwang on 2023/12/18.
//

#import "QCloudTrackService.h"
#import "QCloudTrackNetworkUtils.h"
#import "QCloudTrackConstants.h"

@interface QCloudTrackService ()
@property (nonatomic,strong)NSMutableDictionary <NSString *,NSMutableArray <QCloudBaseTrackService *> *> * trackServiceMap;
@property (nonatomic,strong)NSMutableDictionary * businessParams;
@property (nonatomic,strong)NSDictionary * commonParams;

@property (nonatomic,strong)QCloudBaseTrackService * simpleService;
@end

@implementation QCloudTrackService


+(QCloudTrackService *)singleService{
    static QCloudTrackService * singleService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleService = [[QCloudTrackService alloc]init];
    });
    return singleService;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.trackServiceMap = [NSMutableDictionary new];
        self.commonParams = [self getCommonParams];
        Class cls = NSClassFromString(@"QCloudSimpleBeaconTrackService");
        if (cls) {
            self.simpleService = [cls performSelector:NSSelectorFromString(@"service")];
        }
    }
    return self;
}

-(void)addTrackService:(QCloudBaseTrackService *)service serviceKey:(NSString *)serviceKey{
    @synchronized (self) {
        if ([self.trackServiceMap objectForKey:serviceKey] == nil) {
            [self.trackServiceMap setObject:[NSMutableArray new] forKey:serviceKey];
        }
        [[self.trackServiceMap objectForKey:serviceKey] addObject:service];
    }
}

-(void)setBusinessParams:(NSMutableDictionary *)businessParams{
    if (_businessParams == nil) {
        _businessParams = [NSMutableDictionary new];
    }
    for (NSString * key in businessParams.allKeys) {
        [_businessParams setObject:businessParams[key] forKey:[NSString stringWithFormat:@"business_%@",key]];
    }
}

-(void)setIsCloseReport:(BOOL)isCloseReport{
    for (NSString * key in self.trackServiceMap.allKeys) {
        NSArray * services = [self.trackServiceMap objectForKey:key];
        for (QCloudBaseTrackService * service in services) {
            [service setIsCloseReport:isCloseReport];
        }
    }
}

-(NSDictionary *)getCommonParams{
    
    NSMutableDictionary * commonParams = @{}.mutableCopy;
    NSString * boundleId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    [commonParams setObject:boundleId?:@"" forKey:@"boundle_id"];
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    [commonParams setObject:appVersion?:@"" forKey:@"app_version_code"];
    [commonParams setObject:appVersion?:@"" forKey:@"app_version_name"];
#if TARGET_OS_IOS
    [commonParams setObject:[UIDevice currentDevice].systemName forKey:@"os_name"];
    [commonParams setObject:[UIDevice currentDevice].systemVersion forKey:@"os_version"];
#else
    [commonParams setObject:@"macos" forKey:@"os_name"];
    [commonParams setObject:@"" forKey:@"os_version"];
#endif
    [commonParams setObject:[QCloudTrackNetworkUtils single].getCurrentLocalIP ?:@"" forKey:@"client_local_ip"];
    [commonParams setObject:[QCloudTrackNetworkUtils single].isProxyUsed?@"true":@"false" forKey:@"client_proxy"];
    [commonParams setObject:[QCloudTrackNetworkUtils single].getNetWorkType ?:@"" forKey:@"network_type"];
    
    return commonParams.copy;
}

- (void)reportWithEventCode:(NSString *)eventCode params:(NSDictionary *)params serviceKey:(NSString *)serviceKey{
    NSMutableDictionary * mparams = [NSMutableDictionary new];
    [mparams addEntriesFromDictionary:params];
    
    if (self.commonParams) {
        [mparams addEntriesFromDictionary:self.commonParams];
    }
    
    if (self.businessParams) {
        [mparams addEntriesFromDictionary:self.businessParams];
    }
    
    NSArray * services = self.trackServiceMap[serviceKey];
    for (QCloudBaseTrackService * service in services) {
        [service reportWithEventCode:eventCode params:mparams.copy];
    }
}

- (void)reportSimpleDataWithEventParams:(NSDictionary *)params{
    if (!self.simpleService) {
        return;
    }
    NSMutableDictionary * mparams = [NSMutableDictionary new];
    [mparams addEntriesFromDictionary:params];
    
    if (self.commonParams) {
        [mparams addEntriesFromDictionary:self.commonParams];
    }
    
    if (self.businessParams) {
        [mparams addEntriesFromDictionary:self.businessParams];
    }
    
    [self.simpleService reportWithEventCode:kSimpleDataEventCodeStart params:mparams.copy];
    
}
@end
