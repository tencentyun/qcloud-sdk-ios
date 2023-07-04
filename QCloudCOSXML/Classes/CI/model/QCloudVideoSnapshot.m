//
//
//  QCloudVideoSnapshot.m
//
//  QCloudCOSXML
//
//
//
//  Created by garenwang on
//
//  2023-06-14 06:49:22 +0000.
//

#import "QCloudVideoSnapshot.h"

@implementation QCloudVideoSnapshot

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"JobsDetail" : [QCloudVideoSnapshotJobsDetail class],
    };
}

@end

@implementation QCloudVideoSnapshotJobsDetail

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Input" : [QCloudVideoSnapshotJobsDetailInput class],
        @"Operation" : [QCloudVideoSnapshotJobsDetailOperation class],
    };
}

@end

@implementation QCloudVideoSnapshotJobsDetailInput

@end

@implementation QCloudVideoSnapshotJobsDetailOperation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Snapshot" : [QCloudContainerSnapshot class],
        @"Output" : [QCloudInputVideoSnapshotOperationOutput class],
        @"MediaResult" : [QCloudMediaResult class],
    };
}

@end

@implementation QCloudInputVideoSnapshot

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Input" : [QCloudInputVideoSnapshotInput class],
        @"Operation" : [QCloudInputVideoSnapshotOperation class],
        @"CallBackMqConfig" : [QCloudCallBackMqConfig class],
    };
}

@end

@implementation QCloudInputVideoSnapshotInput

@end

@implementation QCloudInputVideoSnapshotOperation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Snapshot" : [QCloudContainerSnapshot class],
        @"Output" : [QCloudInputVideoSnapshotOperationOutput class],
    };
}

@end

@implementation QCloudInputVideoSnapshotOperationOutput

@end

