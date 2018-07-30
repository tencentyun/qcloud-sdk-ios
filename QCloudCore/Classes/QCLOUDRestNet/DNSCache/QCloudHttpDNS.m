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
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

NSString* const kQCloudHttpDNSCacheReady = @"kQCloudHttpDNSCacheReady";
NSString* const kQCloudHttpDNSHost = @"host";

BOOL QCloudCheckIPVaild(NSString* ip) {
    return YES;
}

@implementation QCloudHttpDNS
{
    QCloudHosts* _hosts;
}
+ (instancetype) shareDNS
{
    static QCloudHttpDNS* dns = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dns = [QCloudHttpDNS new];
    });
    return dns;
}


- (QCloudHosts*) hosts
{
    return _hosts;
}
- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _hosts = [[QCloudHosts alloc] init];
    return self;

}

- (BOOL) resolveDomain:(NSString*)domain error:(NSError**)error
{
    NSString *ip;
    if (self.delegate && [self.delegate respondsToSelector:@selector(resolveDomain:)]) {
        ip = [self.delegate resolveDomain:domain];
    }
    if (!ip) {
        QCloudLogDebug(@"Cannot resolve domain %@",domain);
        *error = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeCannotResloveDomain message:[NSString  stringWithFormat: @"无法解析域名 %@",domain]];
        return NO;
    }

    if (QCloudCheckIPVaild(ip)) {
        [_hosts putDomain:domain ip:[ip stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]]];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kQCloudHttpDNSCacheReady object:nil userInfo:@{
                                                                                                           kQCloudHttpDNSHost:domain
                                                                                                           }];
    return YES;
}


- (NSString*) queryIPForHost:(NSString*)host
{
    NSArray* hosts = [_hosts queryIPForDomain:host];
    //always use the last(lastest) one
    if (hosts.count) {
        return hosts.lastObject;
    }
    return nil;
}
- (NSMutableURLRequest*) resolveURLRequestIfCan:(NSMutableURLRequest*)request
{
    if (!request) {
        return request;
    }
    NSString *host = request.URL.host;
    NSString* ip = [self queryIPForHost:host];
    // Give it second chance to reslove domain by itself
    if (!ip) {
        NSError * resolveError;
        [self resolveDomain:request.URL.host error:&resolveError];
    }
    ip = [self queryIPForHost:host];
    if (!ip) {
        return request;
    }
    NSString* url = request.URL.absoluteString;
    NSRange range = [url rangeOfString:host];
    NSString* originHost = request.URL.host;
    if (range.location != NSNotFound && range.length > 0) {
        url = [url stringByReplacingOccurrencesOfString:host withString:ip options:0 range:range];
        NSMutableURLRequest* mReq = [request mutableCopy];
        mReq.URL = [NSURL URLWithString:url];
        [mReq setValue:originHost forHTTPHeaderField:@"Host"] ;
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

- (BOOL) isTrustIP:(NSString*)ip
{
    NSString* regex = @"\\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\b";
    NSPredicate * predictate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL containsIP = [predictate evaluateWithObject:ip];
    if (!containsIP) {
        return NO;
    }
    
    return [_hosts checkContainsIP:ip];
}
@end

#pragma GCC diagnostic pop
