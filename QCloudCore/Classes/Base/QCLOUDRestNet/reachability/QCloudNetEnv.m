//
//  QCloudNetEnv.m
//  QCloudTernimalLab_CommonLogic
//
//  Created by tencent on 16/3/24.
//  Copyright © 2016年 QCloudTernimalLab. All rights reserved.
//

#import "QCloudNetEnv.h"
#import "QCloudReachability.h"

NSString* const kQCloudNetEnvChangedNotification = @"kQCloudNetEnvChangedNotification";

@implementation QCloudNetEnv
{
    QCloudReachability* _reachAbility;
    BOOL _isInit;
}
@synthesize currentNetStatus = _currentNetStatus;
- (void) dealloc
{
    [_reachAbility stopNotifier];
}
+ (instancetype) shareEnv
{
    static QCloudNetEnv* env = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        env = [QCloudNetEnv new];
    });
    return env;
}

- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networChanged:) name:kQCloudReachabilityChangedNotification object:nil];
    _reachAbility  = [QCloudReachability reachabilityWithHostname:@"www.tencent.com"];
    [_reachAbility startNotifier];
    _isInit = NO;
    return self;
}

- (void) networChanged:(NSNotification*)nc
{
    id object = nc.object;
    if (object != _reachAbility) {
        return;
    }
    switch (_reachAbility.currentReachabilityStatus) {
        case NotReachable:
            _currentNetStatus = QCloudNotReachable;
            break;
        case ReachableViaWiFi:
            _currentNetStatus = QCloudReachableViaWiFi;
            break;
        case ReachableViaWWAN:
            _currentNetStatus = QCloudReachableViaWWAN;
            break;
        default:
            _currentNetStatus = QCloudReachableViaWiFi;
            break;
    }
    if (!_isInit) {
        _isInit = YES;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kQCloudNetEnvChangedNotification object:self];
}

- (QCloudNetworkStatus) currentNetStatus
{
    if (!_isInit) {
        if ([self isReachableViaWifi]) {
            _currentNetStatus = QCloudReachableViaWiFi;
        } else if ([self isReachableVia2g3g4g])
        {
            _currentNetStatus = QCloudReachableViaWWAN;
        } else if (![_reachAbility isReachable]) {
            _currentNetStatus = QCloudNotReachable;
        } else {
            _currentNetStatus = QCloudReachableViaWiFi;
        }
        _isInit = YES;
        
    }
    return _currentNetStatus;
}

- (BOOL) isReachableViaWifi
{
    return [_reachAbility isReachableViaWiFi];
}

- (BOOL) isReachableVia2g3g4g
{
    return [_reachAbility isReachableViaWWAN];
}

- (BOOL) isReachable
{
    return [_reachAbility isReachable];
}

@end
