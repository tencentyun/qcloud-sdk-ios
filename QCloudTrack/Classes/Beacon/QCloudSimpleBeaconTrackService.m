//
//  QCloudSimpleBeaconTrackService.m
//  QCloudTrack
//
//  Created by garenwang on 2023/12/27.
//

#import "QCloudSimpleBeaconTrackService.h"
#import "QCloudTrackConstants.h"

@implementation QCloudSimpleBeaconTrackService

+(QCloudSimpleBeaconTrackService *)service{
    static QCloudSimpleBeaconTrackService * singleService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleService = [[QCloudSimpleBeaconTrackService alloc]init];
    });
    return singleService;
}


- (instancetype)init
{
    self = [super initWithBeaconKey:kSimpleDataBeaconAppKey];
    if (self) {
    }
    return self;
}

@end
