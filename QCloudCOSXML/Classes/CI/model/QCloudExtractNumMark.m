//
//
//  QCloudExtractNumMark.m
//
//  QCloudCOSXML
//
//
//
//  Created by garenwang on
//
//  2023-06-13 12:03:10 +0000.
//

#import "QCloudExtractNumMark.h"

@implementation QCloudExtractNumMark

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"JobsDetail" : [QCloudExtractNumMarkJobsDetail class],
    };
}

@end

@implementation QCloudExtractNumMarkJobsDetail

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Input" : [QCloudExtractNumMarkJobsDetailInput class],
        @"Operation" : [QCloudExtractNumMarkJobsDetailOperation class],
    };
}

@end

@implementation QCloudExtractNumMarkJobsDetailInput

@end

@implementation QCloudExtractNumMarkJobsDetailOperation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"ExtractDigitalWatermark" : [QCloudExtractNumMarkDigitalWatermark class],
    };
}

@end

@implementation QCloudExtractNumMarkDigitalWatermark

@end

@implementation QCloudInputExtractNumMark

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Input" : [QCloudInputExtractNumMarkInput class],
        @"Operation" : [QCloudInputExtractNumMarkOperation class],
        @"CallBackMqConfig" : [QCloudCallBackMqConfig class],
    };
}

@end

@implementation QCloudInputExtractNumMarkInput

@end

@implementation QCloudInputExtractNumMarkOperation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"ExtractDigitalWatermark" : [QCloudInputExtractNumMarkDigitalWatermark class],
    };
}

@end

@implementation QCloudInputExtractNumMarkDigitalWatermark

@end

