//
//
//  QCloudPostConcat.m
//
//  QCloudCOSXML
//
//
//
//  Created by garenwang on
//
//  2023-06-14 03:02:09 +0000.
//

#import "QCloudPostConcat.h"

@implementation QCloudPostConcat

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"JobsDetail" : [QCloudPostConcatJobsDetail class],
    };
}

@end

@implementation QCloudPostConcatJobsDetail

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Input" : [QCloudPostConcatJobsDetailInput class],
        @"Operation" : [QCloudPostConcatJobsDetailOperation class],
    };
}

@end

@implementation QCloudPostConcatJobsDetailInput

@end

@implementation QCloudPostConcatJobsDetailOperation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"ConcatTemplate" : [QCloudInputPostConcatTemplate class],
        @"Output" : [QCloudInputPostConcatOutput class],
        @"MediaInfo" : [QCloudWorkflowMediaInfo class],
        @"MediaResult" : [QCloudMediaResult class],
    };
}

@end

@implementation QCloudInputPostConcat

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Input" : [QCloudInputPostConcatInput class],
        @"Operation" : [QCloudInputPostConcatOperation class],
        @"CallBackMqConfig" : [QCloudCallBackMqConfig class],
    };
}

@end

@implementation QCloudInputPostConcatInput

@end

@implementation QCloudInputPostConcatOperation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"ConcatTemplate" : [QCloudInputPostConcatTemplate class],
        @"Output" : [QCloudInputPostConcatOutput class],
    };
}

@end

@implementation QCloudInputPostConcatOutput

@end

@implementation QCloudInputPostConcatTemplate

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"ConcatFragment" : [QCloudInputPostConcatFragment class],
        @"Audio" : [QCloudAudioVoiceSeparateAudioConfig class],
        @"Video" : [QCloudTemplateVideo class],
        @"Container" : [QCloudTemplateContainer class],
        @"AudioMix" : [QCloudJobsDetailMix class],
        @"AudioMixArray" : [QCloudJobsDetailMix class],
    };
}

@end

@implementation QCloudInputPostConcatFragment

@end

