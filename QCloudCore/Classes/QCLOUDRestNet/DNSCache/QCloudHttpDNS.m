//
//  QCloudHttpDNS.m
//  TestHttps
//
//  Created by tencent on 16/2/17.
//  Copyright © 2016年 dzpqzb. All rights reserved.
//

#import "QCloudHttpDNS.h"
#import "QCloudHosts.h"

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

- (BOOL) resolveDomain:(NSString*)domain error:(NSError* __autoreleasing*)error
{
#warning  this host & port is not set
    NSString* reqstr = [NSString stringWithFormat:@"http://**.**.**.**/?dn=%@", domain];
    NSURL* url = [NSURL URLWithString:reqstr];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    NSHTTPURLResponse* response;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:error];
    if (response.statusCode != 200) {
        return NO;
    }
    if (error != NULL) {
        if (*error) {
            return NO;
        }
    }

    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray* array = [str componentsSeparatedByString:@" "];
    for (NSString* ip  in array) {
        if (QCloudCheckIPVaild(ip)) {
            [_hosts putDomain:domain ip:[ip stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]]];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kQCloudHttpDNSCacheReady object:nil userInfo:@{
                                                                                                           kQCloudHttpDNSHost:domain
                                                                                                           }];
    return YES;
}


- (NSString*) queryIPForHost:(NSString*)host
{
    NSArray* hosts = [_hosts queryIPForDomain:host];
    //always use the first one
    if (hosts.count) {
        return hosts.firstObject;
    }
    return nil;
}
- (NSMutableURLRequest*) resolveURLRequestIfCan:(NSMutableURLRequest*)request
{
    if (!request) {
        return request;
    }
    
    NSString* ip = [self queryIPForHost:request.URL.host];
    if (!ip) {
        return request;
    }

    NSString* url = request.URL.absoluteString;
    NSRange range = [url rangeOfString:request.URL.host];
    NSString* originHost = request.URL.host;
    if (range.location != NSNotFound && range.length > 0) {
        url = [url stringByReplacingOccurrencesOfString:request.URL.host withString:ip options:0 range:range];
        NSMutableURLRequest* mReq = [request mutableCopy];
        mReq.URL = [NSURL URLWithString:url];
        [mReq setValue:originHost forHTTPHeaderField:@"Host"] ;
        return mReq;
    } else {
        return request;
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
