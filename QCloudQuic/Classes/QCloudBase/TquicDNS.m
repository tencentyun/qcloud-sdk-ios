//
//  TquicDNS.m
//  QCloudQuic
//
//  Created by karisli(李雪) on 2019/6/6.
//

#import "TquicDNS.h"
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netdb.h>

static TquicDNS *_instance;
static NSMutableDictionary *_cache;
static dispatch_queue_t _hostChangeQueue;
@interface TquicDNS ()

@end
@implementation TquicDNS

+ (instancetype)shareDNS {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[TquicDNS alloc] init];
        _hostChangeQueue = dispatch_queue_create("com.tencent.qcloud.quic.host.resolve", DISPATCH_QUEUE_CONCURRENT);
        _cache = [NSMutableDictionary new];
    });
    return _instance;
}
- (NSString *)resolveHostForDomain:(NSString *)domain {
    if ([self queryIpForDomain:domain]) {
        return [self queryIpForDomain:domain];
    }

    //    Boolean result,bResolved;
    //    CFHostRef hostRef;
    //    CFArrayRef address = NULL;
    //    //    NSMutableArray *ipsaArr = [[NSMutableArray alloc] init];
    //
    //    CFStringRef hostNamrRef = CFStringCreateWithCString(kCFAllocatorDefault, [domain UTF8String], kCFStringEncodingASCII);
    //    hostRef = CFHostCreateWithName(kCFAllocatorDefault, hostNamrRef);
    //    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    //    result = CFHostStartInfoResolution(hostRef, kCFHostAddresses, NULL);
    //    if (result == TRUE) {
    //        address = CFHostGetAddressing(hostRef, &result);
    //    }
    //    bResolved = result == TRUE?true:false;
    //
    //    if (bResolved) {
    //        struct sockaddr_in *remoteAddr;
    //        for (int i = 0; i<CFArrayGetCount(address); i++) {
    //            CFDataRef sdata = (CFDataRef)CFArrayGetValueAtIndex(address, i);
    //            remoteAddr = (struct sockaddr_in *)CFDataGetBytePtr(sdata);
    //            if (remoteAddr != NULL) {
    //                //获取ip地址
    //                char ip[6];
    //                strcpy(ip, inet_ntoa(remoteAddr->sin_addr));
    //                CFRelease(hostNamrRef);
    //                CFRelease(hostRef);
    //                NSString  *ipStr = [NSString stringWithCString:ip encoding:NSUTF8StringEncoding];
    //                //                [ipsaArr addObject:ipStr];
    //                CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
    //                NSLog(@"33333 === ip === %@ === time cost: %0.3fs", ipStr,end - startTime);
    //                [[TquicDNS shareDNS] setIP:ipStr forDomain:domain];
    //                return ipStr;
    //
    //            }
    //        }
    //    }
    return nil;
}

//得到ip。缓存
- (void)setIP:(NSString *)ip forDomain:(NSString *)domain {
#ifdef DEBUG
    NSParameterAssert(domain);
    NSParameterAssert(ip);
#else
    if (!domain) {
        return;
    }
    if (!ip) {
        return;
    }
#endif
    dispatch_barrier_async(_hostChangeQueue, ^{
        NSMutableArray *array = [_cache objectForKey:domain];
        if (!array) {
            array = [NSMutableArray new];
        }
        if (![array containsObject:ip]) {
            [array addObject:ip];
        }
        _cache[domain] = array;
    });
}

- (NSString *)queryIpForDomain:(NSString *)domain {
    __block NSArray *array = nil;
    dispatch_sync(_hostChangeQueue, ^(void) {
        array = [[_cache objectForKey:domain] copy];
    });
    return array.lastObject;
}
@end
