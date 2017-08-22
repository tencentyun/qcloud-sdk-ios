//
//  RNAsyncBenchMark.m
//  QCloudTernimalLab_CommonLogic
//
//  Created by tencent on 5/27/16.
//  Copyright © 2016 QCloudTernimalLab. All rights reserved.
//

#import "RNAsyncBenchMark.h"


NSString* const kRNBenchmarkRTT                = @"a";
NSString* const kRNBenchmarkServerCost         = @"b";
NSString* const kRNBenchmarkRequest            = @"c";
NSString* const kRNBenchmarkResponse           = @"d";
NSString* const kRNBenchmarkLogic              = @"e";
NSString* const kRNBenchmarkLogicOnly          = @"f";
NSString* const kRNBenchmarkOnlyNet            = @"g";
NSString* const kRNBenchmarkBuildData          = @"h";
NSString* const kRNBenchmarkBuildRequest       = @"i";
NSString* const kRNBenchmarkSizeRequeqstHeader = @"j";
NSString* const kRNBenchmarkSizeRequeqstBody   = @"k";
NSString* const kRNBenchmarkSizeResponseHeader = @"l";
NSString* const kRNBenchmarkSizeResponseBody   = @"m";
NSString* const kRNBenchmarkUploadTime    = @"n";
NSString* const kRNBenchmarkDownploadTime    = @"o";
NSString* const kRNBenchmarkServerTime    = @"p";

NSString* const kRNBenchmarkConnectionTime    = @"q";
NSString* const kRNBenchmarkDNSLoopupTime       = @"r";
NSString* const kRNBenchmarkSecureConnectionTime       = @"s";

@interface RNAsyncBenchMark ()
{
    NSMutableDictionary* _beginCache;
    NSMutableDictionary* _benchMarkCache;
}
@end

@implementation RNAsyncBenchMark
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
    if ([key isEqualToString:kRNBenchmarkRTT]) {
        return @"整体请求耗时";
    } else if ([key isEqualToString:kRNBenchmarkRequest]) {
        return @"上行请求耗时";
    } else if ([key isEqualToString:kRNBenchmarkResponse]) {
        return @"下行请求耗时";
    } else if ([key isEqualToString:kRNBenchmarkLogic]) {
        return @"业务处理耗时";
    } else if ([key isEqualToString:kRNBenchmarkLogicOnly]) {
        return @"单纯业务处理耗时";
    } else if ([key isEqualToString:kRNBenchmarkOnlyNet]) {
        return @"单纯网络耗时";
    } else if ([key isEqualToString:kRNBenchmarkBuildData]) {
        return @"构建请求数据耗时";
    } else if ([key isEqualToString:kRNBenchmarkBuildRequest]) {
        return @"构建请求耗时";
    } else if ([key isEqualToString:kRNBenchmarkSizeRequeqstHeader]) {
        return @"上行包头大小";
    } else if ([key isEqualToString:kRNBenchmarkSizeRequeqstBody]) {
        return @"上行包体大小";
    } else if ([key isEqualToString:kRNBenchmarkSizeResponseHeader]) {
        return @"下行包头大小";
    } else if ([key isEqualToString:kRNBenchmarkSizeResponseBody]) {
        return @"下行包体大小";
    } else if ([key isEqualToString:kRNBenchmarkDownploadTime]) {
        return @"下行行传输耗时";
    } else if ([key isEqualToString:kRNBenchmarkUploadTime]){
        return @"上行传输耗时";
    } else if ([key isEqualToString:kRNBenchmarkServerTime]){
        return @"服务器耗时";
    } else if ([key isEqualToString:kRNBenchmarkConnectionTime]){
        return @"建立连接耗时";
    }else if ([key isEqualToString:kRNBenchmarkSecureConnectionTime]){
        return @"建立安全连接";
    }else if ([key isEqualToString:kRNBenchmarkDNSLoopupTime]){
        return @"DNS解析耗时";
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
