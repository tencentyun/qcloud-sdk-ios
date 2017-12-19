//
//  QCloudV4EndPoint.m
//  Pods-QCloudNewCOSV4Demo
//
//  Created by erichmzhang(张恒铭) on 31/10/2017.
//

#import "QCloudV4EndPoint.h"

static NSString* const kDefaultServiceHostSubfix = @"file.myqcloud.com";
@implementation QCloudV4EndPoint

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    _serviceHostSubfix = kDefaultServiceHostSubfix;
    return self;
}

- (NSURL*)serverURLWithBucket:(NSString *)bucket appID:(NSString *)appID {
    NSString* scheme = self.useHTTPS?@"HTTPS":@"HTTP";
    
    NSString* result = [NSString stringWithFormat:@"%@://%@.%@/files/v2",scheme,self.regionName,self.serviceHostSubfix];
    
    return [NSURL URLWithString:result];
}

@end
