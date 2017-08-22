//
//  QCloudDomain.m
//  TestHttps
//
//  Created by tencent on 16/2/17.
//  Copyright © 2016年 dzpqzb. All rights reserved.
//

#import "QCloudDomain.h"

@implementation QCloudDomain
- (instancetype) initWithDomain:(NSString *)domain
{
    self = [super init];
    if (!self) {
        return self;
    }
    _domain = domain;
    return self;
}
@end
