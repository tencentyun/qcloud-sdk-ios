//
//
//  QCloudPostAnimation.m
//
//  QCloudCOSXML
//
//
//
//  Created by garenwang on
//
//  2023-06-14 03:43:21 +0000.
//

#import "QCloudPostAnimation.h"

@implementation QCloudPostAnimation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"JobsDetail" : [QCloudPostAnimationJobsDetail class],
    };
}

@end

@implementation QCloudPostAnimationJobsDetail

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Input" : [QCloudPostAnimationJobsDetailInput class],
        @"Operation" : [QCloudPostAnimationJobsDetailOperation class],
    };
}

@end

@implementation QCloudPostAnimationJobsDetailInput

@end

@implementation QCloudPostAnimationJobsDetailOperation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Animation" : [QCloudInputPostAnimationOperationAnimation class],
        @"Output" : [QCloudInputPostAnimationOperationOutput class],
        @"MediaInfo" : [QCloudWorkflowMediaInfo class],
        @"MediaResult" : [QCloudMediaResult class],
    };
}

@end

@implementation QCloudInputPostAnimation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Input" : [QCloudInputPostAnimationInput class],
        @"Operation" : [QCloudInputPostAnimationOperation class],
        @"CallBackMqConfig" : [QCloudCallBackMqConfig class],
    };
}

@end

@implementation QCloudInputPostAnimationInput

@end

@implementation QCloudInputPostAnimationOperation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Animation" : [QCloudInputPostAnimationOperationAnimation class],
        @"Output" : [QCloudInputPostAnimationOperationOutput class],
    };
}

@end

@implementation QCloudInputPostAnimationOperationOutput

@end

@implementation QCloudInputPostAnimationOperationAnimation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Container" : [QCloudTemplateContainer class],
        @"Video" : [QCloudTemplateVideo class],
        @"TimeInterval" : [QCloudTemplateTimeInterval class],
    };
}

@end

