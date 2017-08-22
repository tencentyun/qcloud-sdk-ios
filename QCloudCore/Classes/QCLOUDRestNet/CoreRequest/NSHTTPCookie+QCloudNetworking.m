//
//  NSHTTPCookie+QCloudNetworking.m
//  QCloudNetworking
//
//  Created by tencent on 15/9/29.
//  Copyright © 2015年 QCloudTernimalLab. All rights reserved.
//

#import "NSHTTPCookie+QCloudNetworking.h"

NSArray* QCloudFuseAndUpdateCookiesArray(NSArray* source, NSArray* aim) {
    NSMutableArray* aimArray = [NSMutableArray new];
    if (source.count) {
        [aimArray addObjectsFromArray:source];
    }
    for (NSHTTPCookie* s  in source) {
        if (![aimArray containsObject:s]) {
            [aimArray addObject:s];
        }

    }
    return aimArray;
}


@implementation NSHTTPCookie (QCloudNetworking)
- (BOOL) isEqualToQCloudCookie:(NSHTTPCookie*)c
{
    if (![c.name isEqualToString:self.name]) {
        return NO;
    }
    if (![c.value isEqualToString:self.value]) {
        return NO;
    }
    if (![c.path isEqualToString:self.path]) {
        return NO;
    }

    NSString* maxDomain  = c.domain.length > self.domain.length ? c.domain : self.domain;
    NSString* minDomain  = c.domain.length < self.domain.length ? c.domain : self.domain;
    if ([maxDomain hasSuffix:minDomain]) {
        return YES;
    }
    return NO;
}
@end
