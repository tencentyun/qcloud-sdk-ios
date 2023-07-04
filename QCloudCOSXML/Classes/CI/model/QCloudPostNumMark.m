//
//
//  QCloudPostNumMark.m
//
//  QCloudCOSXML
//
//
//
//  Created by garenwang on
//
//  2023-06-13 12:12:24 +0000.
//

#import "QCloudPostNumMark.h"

@implementation QCloudPostNumMark

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"JobsDetail" : [QCloudPostNumMarkJobsDetail class],
    };
}

@end

@implementation QCloudPostNumMarkJobsDetail

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Input" : [QCloudPostNumMarkJobsDetailInput class],
        @"Operation" : [QCloudPostNumMarkJobsDetailOperation class],
    };
}

@end

@implementation QCloudPostNumMarkJobsDetailInput

@end

@implementation QCloudPostNumMarkJobsDetailOperation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Output" : [QCloudInputPostNumMarkOperationOutput class],
        @"DigitalWatermark" : [QCloudDigitalWatermark class],
        @"MediaInfo" : [QCloudWorkflowMediaInfo class],
        @"MediaResult" : [QCloudMediaResult class],
    };
}
@end

@implementation QCloudInputPostNumMark

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Input" : [QCloudInputPostNumMarkInput class],
        @"Operation" : [QCloudInputPostNumMarkOperation class],
        @"CallBackMqConfig" : [QCloudCallBackMqConfig class],
    };
}

@end

@implementation QCloudInputPostNumMarkInput

@end

@implementation QCloudInputPostNumMarkOperation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Output" : [QCloudInputPostNumMarkOperationOutput class],
        @"DigitalWatermark" : [QCloudDigitalWatermark class],
    };
}

@end

@implementation QCloudInputPostNumMarkOperationOutput

@end

