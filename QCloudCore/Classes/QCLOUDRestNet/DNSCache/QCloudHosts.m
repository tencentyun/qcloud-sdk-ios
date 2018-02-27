//
//  QCloudHosts.m
//  TestHttps
//
//  Created by tencent on 16/2/17.
//  Copyright © 2016年 dzpqzb. All rights reserved.
//

#import "QCloudHosts.h"
#import "QCloudDomain.h"
@implementation QCloudHosts
{
    NSMutableDictionary* _cache;
    dispatch_queue_t _hostChangeQueue;
}

- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _hostChangeQueue = dispatch_queue_create("com.tencent.qcloud.host.resolve", DISPATCH_QUEUE_CONCURRENT);
    _cache = [NSMutableDictionary new];
    return self;
}

- (void) putDomain:(NSString*)domain ip:(NSString*)ip
{
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
        NSMutableArray* array = [self->_cache objectForKey:domain];
        if (!array) {
            array = [NSMutableArray new];
        }
        if (![array containsObject:ip]) {
            [array addObject:ip];
        }
        self->_cache[domain] = array;
    });
}

- (NSArray*) queryIPForDomain:(NSString*)domain
{
    __block NSArray* array = nil;
    dispatch_sync(_hostChangeQueue, ^(void) {
        array = [[self->_cache objectForKey:domain] copy];
    });
    return array;
}

- (BOOL) checkContainsIP:(NSString*)ip
{
    if (!ip) {
        return NO;
    }
    __block BOOL contained = NO;
    dispatch_sync(_hostChangeQueue, ^{
        for (NSArray* array in self->_cache.allValues) {
            for (NSString* cachedIP in array) {
                if ([cachedIP isEqualToString:ip]) {
                    contained = YES;
                    break;
                }
            }
            if (contained) {
                break;
            }
        }
    });
    return contained;
}

- (void) clean
{
    dispatch_barrier_async(_hostChangeQueue, ^{
        [self->_cache removeAllObjects];
    });
}

@end
