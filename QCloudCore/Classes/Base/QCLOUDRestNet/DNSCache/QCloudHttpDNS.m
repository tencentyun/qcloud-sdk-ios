//
//  QCloudHttpDNS.m
//  TestHttps
//
//  Created by tencent on 16/2/17.
//  Copyright © 2016年 dzpqzb. All rights reserved.
//

#import "QCloudHttpDNS.h"
#import "QCloudHosts.h"
#import "QCloudLogger.h"
#import "NSError+QCloudNetworking.h"
#import "QCloudPingTester.h"
#include <netdb.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#import "QCloudThreadSafeMutableDictionary.h"
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
#define IP_ADDR_IPv4 @"&&ipv4"
#define IP_ADDR_IPv6 @"&&ipv6"
NSString *const kQCloudHttpDNSCacheReady = @"kQCloudHttpDNSCacheReady";
NSString *const kQCloudHttpDNSHost = @"host";

BOOL QCloudCheckIPVaild(NSString *ip) {
    return YES;
}
@interface QCloudHttpDNS () <WHPingDelegate>
@property (nonatomic, strong) NSMutableArray<QCloudPingTester *> *pingTesters;
@end

@implementation QCloudHttpDNS {
    QCloudHosts *_hosts;
    QCloudThreadSafeMutableDictionary *_ipHostMap;
    ;
}
+ (instancetype)shareDNS {
    static QCloudHttpDNS *dns = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dns = [QCloudHttpDNS new];
    });
    return dns;
}

- (QCloudHosts *)hosts {
    return _hosts;
}
- (instancetype)init {
    self = [super init];
    if (!self) {
        return self;
    }
    _hosts = [[QCloudHosts alloc] init];
    _ipHostMap = [[QCloudThreadSafeMutableDictionary alloc] init];
    _pingTesters = [NSMutableArray array];
    return self;
}

- (BOOL)resolveDomain:(NSString *)domain error:(NSError **)error {
    NSString *ip;
    if (self.delegate && [self.delegate respondsToSelector:@selector(resolveDomain:)]) {
        ip = [self.delegate resolveDomain:domain];
    }
    if (!ip) {
        QCloudLogDebug(@"Cannot resolve domain %@", domain);
        if (NULL != error) {
            *error = [NSError qcloud_errorWithCode:kCFURLErrorDNSLookupFailed
                                           message:[NSString stringWithFormat:@"NetworkException:无法解析域名 %@", domain]];
        }
        return NO;
    }

    if (QCloudCheckIPVaild(ip)) {
        [_hosts putDomain:domain ip:[ip stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]]];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kQCloudHttpDNSCacheReady object:nil userInfo:@{ kQCloudHttpDNSHost : domain }];
    return YES;
}

- (NSString *)queryIPForHost:(NSString *)host {
    NSArray *hosts = [_hosts queryIPForDomain:host];
    // always use the last(lastest) one
    if (hosts.count) {
        return hosts.lastObject;
    }
    return nil;
}
- (NSMutableURLRequest *)resolveURLRequestIfCan:(NSMutableURLRequest *)request {
    if (!request) {
        return request;
    }
    NSString *host = request.URL.host;
    NSString *ip = [self queryIPForHost:host];
    // Give it second chance to reslove domain by itself
    if (!ip) {
        NSError *resolveError;
        [self resolveDomain:request.URL.host error:&resolveError];
    }
    ip = [self queryIPForHost:host];

    if (!ip) {
        return request;
    }
    NSString *url = request.URL.absoluteString;
    NSRange range = [url rangeOfString:host];
    NSString *originHost = request.URL.host;
    if (range.location != NSNotFound && range.length > 0) {
        url = [url stringByReplacingOccurrencesOfString:host withString:ip options:0 range:range];
        NSMutableURLRequest *mReq = [request mutableCopy];
        mReq.URL = [NSURL URLWithString:url];
        [mReq setValue:originHost forHTTPHeaderField:@"Host"];
        return mReq;
    } else {
        return request;
    }
}

- (void)setIp:(NSString *)ip forDomain:(NSString *)domain {
    if (QCloudCheckIPVaild(ip)) {
        [_hosts putDomain:domain ip:ip];
    }
}

- (BOOL)isTrustIP:(NSString *)ip {
    NSString *regex = @"\\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\b";
    NSPredicate *predictate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL containsIP = [predictate evaluateWithObject:ip];
    if (!containsIP) {
        return NO;
    }

    return [_hosts checkContainsIP:ip];
}

- (NSString *)findHealthyIpFor:(NSString *)host {
    NSArray *ipList = [_ipHostMap objectForKey:host];
    if (ipList.count) {
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        [self pingIp:ipList.lastObject host:host fulfil:sema];
        dispatch_wait(sema, DISPATCH_TIME_FOREVER);
        return [self queryIPForHost:host];
    }
    return nil;
}

- (void)pingIp:(NSString *)ip host:(NSString *)host fulfil:(dispatch_semaphore_t)sema {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *ipAdd;
        if ([ip hasSuffix:IP_ADDR_IPv4]) {
            ipAdd = [ip stringByReplacingOccurrencesOfString:IP_ADDR_IPv4 withString:@""];
        } else if ([ip hasSuffix:IP_ADDR_IPv6]) {
            ipAdd = [ip stringByReplacingOccurrencesOfString:IP_ADDR_IPv6 withString:@""];
        }
        QCloudPingTester *pingTester = [[QCloudPingTester alloc] initWithIp:ipAdd host:host fulfil:sema];
        pingTester.delegate = self;
        [self->_pingTesters addObject:pingTester];
        [pingTester startPing];
    });
}

- (void)pingTester:(QCloudPingTester *)pingTester didPingSucccessWithTime:(float)time withError:(NSError *)error {
    if (!error) {
        QCloudLogInfo(@"ping的延迟是--->%f", time);
        [pingTester stopPing];
        [self setIp:pingTester.ip forDomain:pingTester.host];
        dispatch_semaphore_signal(pingTester.sema);
    } else {
        QCloudLogDebug(@"网络不通过ip[%@]", pingTester.ip);
        [pingTester stopPing];
        NSMutableArray *ipList = [[_ipHostMap objectForKey:pingTester.host] mutableCopy];
        if (ipList.count) {
            [ipList removeLastObject];
        }
        [_ipHostMap setObject:ipList forKey:pingTester.host];
        if (ipList.count) {
            [self pingIp:ipList.lastObject host:pingTester.host fulfil:pingTester.sema];
        } else {
            dispatch_semaphore_signal(pingTester.sema);
        }
    }
    [_pingTesters removeObject:pingTester];
}

- (void)prepareFetchIPListForHost:(NSString *)host port:(NSString *)port {
    NSArray *list = [_ipHostMap objectForKey:host];
    if (![_ipHostMap objectForKey:host] || !list.count) {
        list = getIPListFromToHost(host.UTF8String, port.UTF8String);
        if (list) {
            [_ipHostMap setObject:list forKey:host];
        }
    }
}

NSArray *getIPListFromToHost(const char *mHost, const char *mPort) {
    NSMutableArray *ipList = [NSMutableArray array];
    if (nil == mHost)
        return NULL;
    const char *newChar = "No";
    //返回的结构体信息链表
    struct addrinfo *res0;
    // 配置需要返回的结构体信息组成
    struct addrinfo hints;
    // 返回的地址信息
    struct addrinfo *res;
    int n;

    // 置空结构体
    memset(&hints, 0, sizeof(hints));

    hints.ai_flags = AI_DEFAULT;
    hints.ai_family = PF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;

    if ((n = getaddrinfo(mHost, "http", &hints, &res0)) != 0) {
        QCloudLogInfo(@"getaddrinfo error: %s", gai_strerror(n));
        return NULL;
    }

    struct sockaddr_in6 *addr6;
    struct sockaddr_in *addr;
    NSString *NewStr = NULL;
    char ipbuf[32];
    for (res = res0; res; res = res->ai_next) {
        if (res->ai_family == AF_INET6) {
            addr6 = (struct sockaddr_in6 *)res->ai_addr;
            newChar = inet_ntop(AF_INET6, &addr6->sin6_addr, ipbuf, sizeof(ipbuf));
            NSString *TempA = [[NSString alloc] initWithCString:(const char *)newChar encoding:NSASCIIStringEncoding];
            NSString *TempB = [NSString stringWithUTF8String:IP_ADDR_IPv6.UTF8String];

            NewStr = [TempA stringByAppendingString:TempB];

        } else {
            addr = (struct sockaddr_in *)res->ai_addr;
            newChar = inet_ntop(AF_INET, &addr->sin_addr, ipbuf, sizeof(ipbuf));
            NSString *TempA = [[NSString alloc] initWithCString:(const char *)newChar encoding:NSASCIIStringEncoding];
            NSString *TempB = [NSString stringWithUTF8String:IP_ADDR_IPv4.UTF8String];

            NewStr = [TempA stringByAppendingString:TempB];
        }

        [ipList addObject:NewStr];
        QCloudLogInfo(@"host[%s] ipList:%@", mHost, ipList);
    }

    freeaddrinfo(res0);

    return ipList;
}
@end

#pragma GCC diagnostic pop
