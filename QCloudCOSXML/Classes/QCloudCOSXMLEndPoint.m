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

- (NSString*)formattedRegionName:(NSString*)regionName {
    NSArray* oldRegionNameArray = @[@"cn-east",@"cn-south",@"cn-south-2",@"cn-north",@"cn-southwest",@"sg"];
    BOOL isOldRegion = NO;
    for (NSString* oldRegionName in oldRegionNameArray) {
        if ([regionName isEqualToString:oldRegionName]) {
            isOldRegion = YES;
            break;
        }
    }
    if (isOldRegion) {
        return regionName;
    } else {
        return [NSString stringWithFormat:@"cos.%@",self.regionName];
    }
}



- (NSURL*) serverURLWithBucket:(NSString *)bucket appID:(NSString *)appID
{
    NSString* scheme = @"https";
    if (!self.useHTTPS) {
        scheme = @"http";
    }    
    NSURL* serverURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@-%@.%@.%@",scheme,bucket,appID,[self formattedRegionName:self.regionName],self.serviceName]];
    return serverURL;
}
@end
