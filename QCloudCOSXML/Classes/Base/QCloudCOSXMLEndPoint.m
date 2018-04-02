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

- (NSString *)formattedBucket:(NSString*)bucket withAPPID:(NSString*)APPID {
    NSInteger subfixLength = APPID.length + 1;
    if (bucket.length <= subfixLength) {
        return bucket;
    }
    NSString* APPIDSubfix = [NSString stringWithFormat:@"-%@",APPID];
    NSString* subfixString = [bucket substringWithRange:NSMakeRange(bucket.length - subfixLength  , subfixLength)];
    if ([subfixString isEqualToString:APPIDSubfix]) {
        return [bucket substringWithRange:NSMakeRange(0, bucket.length - subfixLength)];
    }
    //should not reach here
    return bucket;
}

- (NSURL*) serverURLWithBucket:(NSString *)bucket appID:(NSString *)appID
{
    NSString* scheme = @"https";
    if (!self.useHTTPS) {
        scheme = @"http";
    }
    NSString* formattedRegionName = [self formattedRegionName:self.regionName];
    NSString* formattedBucketName = [self formattedBucket:bucket withAPPID:appID];
    NSURL* serverURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@-%@.%@.%@",scheme,formattedBucketName,appID,formattedRegionName,self.serviceName]];
    return serverURL;
}

- (id)copyWithZone:(NSZone *)zone {
    QCloudCOSXMLEndPoint* endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.regionName = self.regionName;
    endpoint.serviceName = self.serviceName;
    return endpoint;
}
@end
