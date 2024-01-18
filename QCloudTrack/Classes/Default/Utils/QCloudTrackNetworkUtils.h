//
//  NetworkUtils.h
//  QCloudTrack
//
//  Created by garenwang on 2023/12/26.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
NS_ASSUME_NONNULL_BEGIN

#ifndef NS_ENUM
#define NS_ENUM(_type, _name) \
    enum _name : _type _name; \
    enum _name : _type
#endif

extern NSString *const kQCloudTrackReachabilityChangedNotification;

typedef NS_ENUM(NSInteger, QCloudTrackNetworkStatus) {
    // Apple NetworkStatus Compatible Names.
    QCloudTrackNotReachable = 0,
    QCloudTrackReachableViaWiFi = 2,
    QCloudTrackReachableViaWWAN = 1
};

@interface QCloudTrackNetworkUtils : NSObject

+(QCloudTrackNetworkUtils *)single;
-(NSString *)getNetWorkType;

- (NSString*)getCurrentLocalIP;

- (BOOL)isProxyUsed;
@end


@class QCloudTrackReachability;

typedef void (^QCloudNetworkReachable)(QCloudTrackReachability *reachability);
typedef void (^QCloudNetworkUnreachable)(QCloudTrackReachability *reachability);
typedef void (^QCloudNetworkReachability)(QCloudTrackReachability *reachability, SCNetworkConnectionFlags flags);

@interface QCloudTrackReachability : NSObject

@property (nonatomic, copy) QCloudNetworkReachable reachableBlock;
@property (nonatomic, copy) QCloudNetworkUnreachable unreachableBlock;
@property (nonatomic, copy) QCloudNetworkReachability reachabilityBlock;

@property (nonatomic, assign) BOOL reachableOnWWAN;

+ (instancetype)reachabilityWithHostname:(NSString *)hostname;
// This is identical to the function above, but is here to maintain
// compatibility with Apples original code. (see .m)
+ (instancetype)reachabilityWithHostName:(NSString *)hostname;
+ (instancetype)reachabilityForInternetConnection;
+ (instancetype)reachabilityWithAddress:(void *)hostAddress;
+ (instancetype)reachabilityForLocalWiFi;

- (instancetype)initWithReachabilityRef:(SCNetworkReachabilityRef)ref;

- (BOOL)startNotifier;
- (void)stopNotifier;

- (BOOL)isReachable;
- (BOOL)isReachableViaWWAN;
- (BOOL)isReachableViaWiFi;

// WWAN may be available, but not active until a connection has been established.
// WiFi may require a connection for VPN on Demand.
- (BOOL)isConnectionRequired; // Identical DDG variant.
- (BOOL)connectionRequired;   // Apple's routine.
// Dynamic, on demand connection?
- (BOOL)isConnectionOnDemand;
// Is user intervention required?
- (BOOL)isInterventionRequired;

- (QCloudTrackNetworkStatus)currentReachabilityStatus;
- (SCNetworkReachabilityFlags)reachabilityFlags;
- (NSString *)currentReachabilityString;
- (NSString *)currentReachabilityFlags;

@end

NS_ASSUME_NONNULL_END
