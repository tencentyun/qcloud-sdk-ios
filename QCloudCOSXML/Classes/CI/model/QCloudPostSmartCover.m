//
//
//  QCloudPostSmartCover.m
//
//  QCloudCOSXML
//
//
//
//  Created by garenwang on
//
//  2023-06-14 02:45:20 +0000.
//

#import "QCloudPostSmartCover.h"

@implementation QCloudPostSmartCover

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"JobsDetail" : [QCloudPostSmartCoverJobsDetail class],
    };
}

@end

@implementation QCloudPostSmartCoverJobsDetail

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Input" : [QCloudPostSmartCoverJobsDetailInput class],
        @"Operation" : [QCloudPostSmartCoverJobsDetailOperation class],
    };
}

@end

@implementation QCloudPostSmartCoverJobsDetailInput

@end

@implementation QCloudPostSmartCoverJobsDetailOperation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"SmartCover":[QCloudInputPostSmartOperationCover class],
        @"Output" : [QCloudInputPostSmartOutput class],
        @"MediaResult" : [QCloudMediaResult class],
    };
}

@end

@implementation QCloudInputPostSmartCover

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Input" : [QCloudInputPostSmartCoverInput class],
        @"Operation" : [QCloudInputPostSmartCoverOperation class],
        @"CallBackMqConfig" : [QCloudCallBackMqConfig class],
    };
}

@end

@implementation QCloudInputPostSmartCoverInput

@end

@implementation QCloudInputPostSmartCoverOperation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"SmartCover" : [QCloudInputPostSmartOperationCover class],
        @"Output" : [QCloudInputPostSmartOutput class],
    };
}

@end

@implementation QCloudInputPostSmartOutput

@end

@implementation QCloudInputPostSmartOperationCover

@end

