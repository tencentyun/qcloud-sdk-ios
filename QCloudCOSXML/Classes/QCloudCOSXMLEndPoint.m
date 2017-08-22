//
//  QCloudCOSXMLEndPoint.m
//  Pods
//
//  Created by Dong Zhao on 2017/8/22.
//
//

#import "QCloudCOSXMLEndPoint.h"

@implementation QCloudCOSXMLEndPoint

- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _serviceName = @"myqcloud.com";
    return self;
}

- (NSURL*) serverURLWithBucket:(NSString *)bucket appID:(NSString *)appID
{
    NSString* scheme = @"https";
    if (!self.useHTTPS) {
        scheme = @"http";
    }
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@-%@.%@.%@", scheme, bucket, appID, [self regionName], [self serviceName]]];
}
@end
