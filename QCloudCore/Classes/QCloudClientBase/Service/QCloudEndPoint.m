//
//  QCloudEndPoint.m
//  Pods
//
//  Created by Dong Zhao on 2017/3/31.
//
//

#import "QCloudEndPoint.h"
#import "QCloudError.h"

@interface QCloudEndPoint ()
@end

@implementation QCloudEndPoint
- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _useHTTPS = NO;
    return self;
}

- (NSURL*) serverURLWithBucket:(NSString *)bucket appID:(NSString *)appID
{
    NSString* msg = @"请在子类中实现该方法，在父类中该方法不关心具体业务的拼装！！！";
    @throw [NSException exceptionWithName:QCloudErrorDomain reason:msg userInfo:@{NSLocalizedDescriptionKey:msg}];
}

- (instancetype) copyWithZone:(NSZone *)zone
{
    QCloudEndPoint* endpoint = [[[self class] allocWithZone:zone] init];
    endpoint.useHTTPS = self.useHTTPS;
    endpoint.serviceName = self.serviceName;
    endpoint.regionName = self.regionName;
    return endpoint;
}



@end
