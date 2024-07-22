//
//  QCloudTrackNetworkUtils.m
//  QCloudTrack
//
//  Created by garenwang on 2023/12/26.
//

#import "QCloudTrackNetworkUtils.h"
#import <arpa/inet.h>
#include <netdb.h>
#include <net/if.h>
#import <dlfcn.h>
#include <sys/sysctl.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <ifaddrs.h>
#import <CFNetwork/CFNetwork.h>

@interface QCloudTrackNetworkUtils ()
@property(nonatomic,strong)QCloudTrackReachability * reachAbility;
@end

@implementation QCloudTrackNetworkUtils

+(QCloudTrackNetworkUtils *)single{
    static QCloudTrackNetworkUtils * utils = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        utils = [[QCloudTrackNetworkUtils alloc]init];
    });
    return utils;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _reachAbility = [QCloudTrackReachability reachabilityWithHostname:@"www.tencent.com"];
        [_reachAbility startNotifier];
    }
    return self;
}



- (BOOL)isProxyUsed {
    NSDictionary *proxySettings = (__bridge NSDictionary *)CFNetworkCopySystemProxySettings();
    NSString *proxies = proxySettings[(__bridge NSString *)kCFNetworkProxiesHTTPProxy];
    
    if (proxies) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString*)getCurrentLocalIP{

    NSString *address = nil;

    struct ifaddrs *interfaces = NULL;

    struct ifaddrs *temp_addr = NULL;

    int success = 0;

    // retrieve the current interfaces - returns 0 on success

    success = getifaddrs(&interfaces);

    if (success == 0) {

        // Loop through linked list of interfaces

        temp_addr = interfaces;

        while(temp_addr != NULL) {

            if(temp_addr->ifa_addr->sa_family == AF_INET) {

                // Check if interface is en0 which is the wifi connection on the iPhone

                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {

                    // Get NSString from C String

                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];

                }

            }

            temp_addr = temp_addr->ifa_next;

        }

    }

    // Free memory

    freeifaddrs(interfaces);

    return address;
}

-(NSString *)getNetWorkType{
    return [self.reachAbility currentReachabilityString];
}

@end


NSString *const kQCloudTrackReachabilityChangedNotification = @"kQCloudTrackReachabilityChangedNotification";

@interface QCloudTrackReachability ()

@property (nonatomic, assign) SCNetworkReachabilityRef reachabilityRef;
@property (nonatomic, strong) dispatch_queue_t reachabilitySerialQueue;
@property (nonatomic, strong) id reachabilityObject;

- (void)reachabilityChanged:(SCNetworkReachabilityFlags)flags;
- (BOOL)isReachableWithFlags:(SCNetworkReachabilityFlags)flags;

@end

static NSString *reachabilityFlags(SCNetworkReachabilityFlags flags) {
    return [NSString stringWithFormat:@"%c%c %c%c%c%c%c%c%c",
#if TARGET_OS_IPHONE
                                      (flags & kSCNetworkReachabilityFlagsIsWWAN) ? 'W' : '-',
#else
                                      'X',
#endif
                                      (flags & kSCNetworkReachabilityFlagsReachable) ? 'R' : '-',
                                      (flags & kSCNetworkReachabilityFlagsConnectionRequired) ? 'c' : '-',
                                      (flags & kSCNetworkReachabilityFlagsTransientConnection) ? 't' : '-',
                                      (flags & kSCNetworkReachabilityFlagsInterventionRequired) ? 'i' : '-',
                                      (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) ? 'C' : '-',
                                      (flags & kSCNetworkReachabilityFlagsConnectionOnDemand) ? 'D' : '-',
                                      (flags & kSCNetworkReachabilityFlagsIsLocalAddress) ? 'l' : '-',
                                      (flags & kSCNetworkReachabilityFlagsIsDirect) ? 'd' : '-'];
}

// Start listening for reachability notifications on the current run loop
static void TMReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void *info) {
#pragma unused(target)

    QCloudTrackReachability *reachability = ((__bridge QCloudTrackReachability *)info);

    // We probably don't need an autoreleasepool here, as GCD docs state each queue has its own autorelease pool,
    // but what the heck eh?
    @autoreleasepool {
        [reachability reachabilityChanged:flags];
    }
}

@implementation QCloudTrackReachability

#pragma mark - Class Constructor Methods

+ (instancetype)reachabilityWithHostName:(NSString *)hostname {
    return [QCloudTrackReachability reachabilityWithHostname:hostname];
}

+ (instancetype)reachabilityWithHostname:(NSString *)hostname {
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithName(NULL, [hostname UTF8String]);
    if (ref) {
        id reachability = [[self alloc] initWithReachabilityRef:ref];

        return reachability;
    }

    return nil;
}

+ (instancetype)reachabilityWithAddress:(void *)hostAddress {
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)hostAddress);
    if (ref) {
        id reachability = [[self alloc] initWithReachabilityRef:ref];

        return reachability;
    }

    return nil;
}

+ (instancetype)reachabilityForInternetConnection {
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;

    return [self reachabilityWithAddress:&zeroAddress];
}

+ (instancetype)reachabilityForLocalWiFi {
    struct sockaddr_in localWifiAddress;
    bzero(&localWifiAddress, sizeof(localWifiAddress));
    localWifiAddress.sin_len = sizeof(localWifiAddress);
    localWifiAddress.sin_family = AF_INET;
    // IN_LINKLOCALNETNUM is defined in <netinet/in.h> as 169.254.0.0
    localWifiAddress.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);

    return [self reachabilityWithAddress:&localWifiAddress];
}

// Initialization methods

- (instancetype)initWithReachabilityRef:(SCNetworkReachabilityRef)ref {
    self = [super init];
    if (self != nil) {
        self.reachableOnWWAN = YES;
        self.reachabilityRef = ref;

        // We need to create a serial queue.
        // We allocate this once for the lifetime of the notifier.

        self.reachabilitySerialQueue = dispatch_queue_create("com.tonymillion.reachability", NULL);
    }

    return self;
}

- (void)dealloc {
    [self stopNotifier];

    if (self.reachabilityRef) {
        CFRelease(self.reachabilityRef);
        self.reachabilityRef = nil;
    }

    self.reachableBlock = nil;
    self.unreachableBlock = nil;
    self.reachabilityBlock = nil;
    self.reachabilitySerialQueue = nil;
}

#pragma mark - Notifier Methods

// Notifier
// NOTE: This uses GCD to trigger the blocks - they *WILL NOT* be called on THE MAIN THREAD
// - In other words DO NOT DO ANY UI UPDATES IN THE BLOCKS.
//   INSTEAD USE dispatch_async(dispatch_get_main_queue(), ^{UISTUFF}) (or dispatch_sync if you want)

- (BOOL)startNotifier {
    // allow start notifier to be called multiple times
    if (self.reachabilityObject && (self.reachabilityObject == self)) {
        return YES;
    }

    SCNetworkReachabilityContext context = { 0, NULL, NULL, NULL, NULL };
    context.info = (__bridge void *)self;

    if (SCNetworkReachabilitySetCallback(self.reachabilityRef, TMReachabilityCallback, &context)) {
        // Set it as our reachability queue, which will retain the queue
        if (SCNetworkReachabilitySetDispatchQueue(self.reachabilityRef, self.reachabilitySerialQueue)) {
            // this should do a retain on ourself, so as long as we're in notifier mode we shouldn't disappear out from under ourselves
            // woah
            self.reachabilityObject = self;
            return YES;
        } else {
#ifdef DEBUG
            NSLog(@"SCNetworkReachabilitySetDispatchQueue() failed: %s", SCErrorString(SCError()));
#endif

            // UH OH - FAILURE - stop any callbacks!
            SCNetworkReachabilitySetCallback(self.reachabilityRef, NULL, NULL);
        }
    } else {
#ifdef DEBUG
        NSLog(@"SCNetworkReachabilitySetCallback() failed: %s", SCErrorString(SCError()));
#endif
    }

    // if we get here we fail at the internet
    self.reachabilityObject = nil;
    return NO;
}

- (void)stopNotifier {
    // First stop, any callbacks!
    SCNetworkReachabilitySetCallback(self.reachabilityRef, NULL, NULL);

    // Unregister target from the GCD serial dispatch queue.
    SCNetworkReachabilitySetDispatchQueue(self.reachabilityRef, NULL);

    self.reachabilityObject = nil;
}

#pragma mark - reachability tests

// This is for the case where you flick the airplane mode;
// you end up getting something like this:
// QCloudTrackReachability: WR ct-----
// QCloudTrackReachability: -- -------
// QCloudTrackReachability: WR ct-----
// QCloudTrackReachability: -- -------
// We treat this as 4 UNREACHABLE triggers - really apple should do better than this

#define testcase (kSCNetworkReachabilityFlagsConnectionRequired | kSCNetworkReachabilityFlagsTransientConnection)

- (BOOL)isReachableWithFlags:(SCNetworkReachabilityFlags)flags {
    BOOL connectionUP = YES;

    if (!(flags & kSCNetworkReachabilityFlagsReachable))
        connectionUP = NO;

    if ((flags & testcase) == testcase)
        connectionUP = NO;

#if TARGET_OS_IPHONE
    if (flags & kSCNetworkReachabilityFlagsIsWWAN) {
        // We're on 3G.
        if (!self.reachableOnWWAN) {
            // We don't want to connect when on 3G.
            connectionUP = NO;
        }
    }
#endif

    return connectionUP;
}

- (BOOL)isReachable {
    SCNetworkReachabilityFlags flags;

    if (!SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags))
        return NO;

    return [self isReachableWithFlags:flags];
}

- (BOOL)isReachableViaWWAN {
#if TARGET_OS_IPHONE

    SCNetworkReachabilityFlags flags = 0;

    if (SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags)) {
        // Check we're REACHABLE
        if (flags & kSCNetworkReachabilityFlagsReachable) {
            // Now, check we're on WWAN
            if (flags & kSCNetworkReachabilityFlagsIsWWAN) {
                return YES;
            }
        }
    }
#endif

    return NO;
}

- (BOOL)isReachableViaWiFi {
    SCNetworkReachabilityFlags flags = 0;

    if (SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags)) {
        // Check we're reachable
        if ((flags & kSCNetworkReachabilityFlagsReachable)) {
#if TARGET_OS_IPHONE
            // Check we're NOT on WWAN
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN)) {
                return NO;
            }
#endif
            return YES;
        }
    }

    return NO;
}

// WWAN may be available, but not active until a connection has been established.
// WiFi may require a connection for VPN on Demand.
- (BOOL)isConnectionRequired {
    return [self connectionRequired];
}

- (BOOL)connectionRequired {
    SCNetworkReachabilityFlags flags;

    if (SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags)) {
        return (flags & kSCNetworkReachabilityFlagsConnectionRequired);
    }

    return NO;
}

// Dynamic, on demand connection?
- (BOOL)isConnectionOnDemand {
    SCNetworkReachabilityFlags flags;

    if (SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags)) {
        return ((flags & kSCNetworkReachabilityFlagsConnectionRequired)
                && (flags & (kSCNetworkReachabilityFlagsConnectionOnTraffic | kSCNetworkReachabilityFlagsConnectionOnDemand)));
    }

    return NO;
}

// Is user intervention required?
- (BOOL)isInterventionRequired {
    SCNetworkReachabilityFlags flags;

    if (SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags)) {
        return ((flags & kSCNetworkReachabilityFlagsConnectionRequired) && (flags & kSCNetworkReachabilityFlagsInterventionRequired));
    }

    return NO;
}

#pragma mark - reachability status stuff

- (QCloudTrackNetworkStatus)currentReachabilityStatus {
    if ([self isReachable]) {
        if ([self isReachableViaWiFi])
            return QCloudTrackReachableViaWiFi;

#if TARGET_OS_IPHONE
        return QCloudTrackReachableViaWWAN;
#endif
    }

    return QCloudTrackNotReachable;
}

- (SCNetworkReachabilityFlags)reachabilityFlags {
    SCNetworkReachabilityFlags flags = 0;

    if (SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags)) {
        return flags;
    }

    return 0;
}

- (NSString *)currentReachabilityString {
    QCloudTrackNetworkStatus temp = [self currentReachabilityStatus];

    if (temp == QCloudTrackReachableViaWWAN) {
        return @"WWAN";
    }
    if (temp == QCloudTrackReachableViaWiFi) {
        return @"WIFI";
    }

    return @"No Connection";
}

- (NSString *)currentReachabilityFlags {
    return reachabilityFlags([self reachabilityFlags]);
}

#pragma mark - Callback function calls this method

- (void)reachabilityChanged:(SCNetworkReachabilityFlags)flags {
    if ([self isReachableWithFlags:flags]) {
        if (self.reachableBlock) {
            self.reachableBlock(self);
        }
    } else {
        if (self.unreachableBlock) {
            self.unreachableBlock(self);
        }
    }

    if (self.reachabilityBlock) {
        self.reachabilityBlock(self, flags);
    }

    // this makes sure the change notification happens on the MAIN THREAD
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kQCloudTrackReachabilityChangedNotification object:self];
    });
}

#pragma mark - Debug Description

- (NSString *)description {
    NSString *description =
        [NSString stringWithFormat:@"<%@: %#x (%@)>", NSStringFromClass([self class]), (unsigned int)self, [self currentReachabilityFlags]];
    return description;
}

@end
