//
//  QCloudHttpMetrics.m
//  QCloudTernimalLab_CommonLogic
//
//  Created by tencent on 5/27/16.
//  Copyright © 2016 QCloudTernimalLab. All rights reserved.
//

#import "QCloudHttpMetrics.h"


NSString* const kTaskTookTime                = @"kTaskTookTime";
NSString* const kCalculateMD5STookTime = @"kCalculateMD5STookTime";
NSString* const kSignRequestTookTime   = @"kSignRequestTookTime";
NSString* const kDnsLookupTookTime       = @"kDnsLookupTookTime";
NSString* const kConnectTookTime    = @"kConnectTookTime";
NSString* const kSecureConnectTookTime       = @"kSecureConnectTookTime";
NSString* const kWriteRequestBodyTookTime    = @"kWriteRequestBodyTookTime";
NSString* const kReadResponseHeaderTookTime    = @"kReadResponseHeaderTookTime";
NSString* const kReadResponseBodyTookTime    = @"kReadResponseBodyTookTime";








@interface QCloudHttpMetrics ()
{
    NSMutableDictionary* _beginCache;
    NSMutableDictionary* _benchMarkCache;
}
@end

@implementation QCloudHttpMetrics
- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _beginCache = [NSMutableDictionary new];
    _benchMarkCache = [NSMutableDictionary new];
    return self;
}
- (void) benginWithKey:(NSString*)key
{
    if (!key) {
        return;
    }
    @synchronized (self) {
        _beginCache[key] = @(CFAbsoluteTimeGetCurrent());
    }
}

- (void) markFinishWithKey:(NSString*)key
{
    if (!key) {
        return;
    }
    @synchronized (self) {
        double begin = [_beginCache[key] doubleValue];
        double value = CFAbsoluteTimeGetCurrent() - begin;
        value = floor(value * 10000 ) / 10000;
        _benchMarkCache[key] = @(value);
    }
}

- (void) directSetCost:(double)cost forKey:(NSString *)key
{
    if (!key) {
        return;
    }
    @synchronized (self) {
        _benchMarkCache[key] = @(cost);
    }

}
-(NSDictionary *)tastMetrics{
    return _benchMarkCache;
}
- (double) costTimeForKey:(NSString*)key
{
    if (!key) {
        return 0;
    }
    @synchronized (self) {
        NSNumber* cost = _benchMarkCache[key];
        return [cost doubleValue];
    }
}

- (NSString*) readablityString:(NSString*)key
{
    if ([key isEqualToString:kTaskTookTime]) {
        return @"整体请求耗时";
    }else if ([key isEqualToString:kReadResponseBodyTookTime]) {
        return @"下行行传输耗时";
    } else if ([key isEqualToString:kWriteRequestBodyTookTime]){
        return @"上行传输耗时";
    } else if ([key isEqualToString:kReadResponseHeaderTookTime]){
        return @"服务器耗时";
    } else if ([key isEqualToString:kConnectTookTime]){
        return @"建立连接耗时";
    }else if ([key isEqualToString:kSecureConnectTookTime]){
        return @"建立安全连接";
    }else if ([key isEqualToString:kDnsLookupTookTime]){
        return @"DNS解析耗时";
    }else if ([key isEqualToString:kCalculateMD5STookTime]){
        return @"计算MD5耗时";
    }else if ([key isEqualToString:kSignRequestTookTime]){
        return @"获取签名耗时";
    }
    return key;
}

- (NSString*) readablityDescription
{
    NSDictionary* benchmark = nil;
    @synchronized (self) {
        benchmark = [_benchMarkCache copy];
    }

    NSMutableString* readStr = [NSMutableString new];
    
    [readStr appendString:@"\n参数项\t\t\t消耗\n"];
    for (NSString* key  in benchmark.allKeys) {
        [readStr appendFormat:@"%@\t\t\t%f\n", [self readablityString:key], [benchmark[key] floatValue]];
    }
    return readStr;
}

- (NSString*) description
{
    NSString * desp = @"";
    @try {
        @synchronized (self) {
            NSData* data = [NSJSONSerialization dataWithJSONObject:_benchMarkCache options:0 error:nil];
            if (!data) {
                return @"{}";
            }
            desp = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
    } @catch (NSException *exception) {
        desp = @"";
    } @finally {
        return desp;
    }
}
@end
