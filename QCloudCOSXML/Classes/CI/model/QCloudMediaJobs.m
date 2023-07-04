//
//
//  QCloudMediaJobs.m
//
//  QCloudCOSXML
//
//
//
//  Created by garenwang on
//
//  2023-06-13 02:55:47 +0000.
//

#import "QCloudMediaJobs.h"

@implementation QCloudMediaJobs

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"JobsDetail" : [QCloudMediaJobsDetail class],
    };
}

@end

@implementation QCloudMediaJobsDetail

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Input" : [QCloudJobsDetailInput class],
        @"Operation" : [QCloudJobsDetailOperation class],
    };
}

@end

@implementation QCloudJobsDetailInput

@end

@implementation QCloudJobsDetailOperation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"MediaInfo" : [QCloudWorkflowMediaInfo class],
    };
}

@end


@implementation QCloudMediaJobsInput
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Input": [QCloudMediaJobsInputInput class],
        @"Operation": [QCloudMediaJobsInputOperation class],
        @"CallBackMqConfig":[QCloudCallBackMqConfig class]
    };
}
@end

@implementation QCloudMediaJobsInputInput

@end

@implementation QCloudMediaJobsInputOperation

@end

