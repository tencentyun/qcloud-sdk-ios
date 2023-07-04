//
//
//  QCloudVideoMontage.m
//
//  QCloudCOSXML
//
//
//
//  Created by garenwang on
//
//  2023-06-14 02:27:23 +0000.
//

#import "QCloudVideoMontage.h"

@implementation QCloudVideoMontage

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"JobsDetail" : [QCloudVideoMontageJobsDetail class],
    };
}

@end

@implementation QCloudVideoMontageJobsDetail

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Input" : [QCloudVideoMontageJobsDetailInput class],
        @"Operation" : [QCloudVideoMontageJobsDetailOperation class],
    };
}

@end

@implementation QCloudVideoMontageJobsDetailInput

@end

@implementation QCloudVideoMontageJobsDetailOperation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"VideoMontage" : [QCloudInputVideoMontageVideoMontage class],
        @"Output" : [QCloudInputVideoMontageOutput class],
        @"MediaInfo" : [QCloudWorkflowMediaInfo class],
        @"MediaResult" : [QCloudMediaResult class],
    };
}

@end

@implementation QCloudInputVideoMontage

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Input" : [QCloudInputVideoMontageInput class],
        @"Operation" : [QCloudInputVideoMontageOperation class],
        @"CallBackMqConfig" : [QCloudCallBackMqConfig class],
    };
}

@end

@implementation QCloudInputVideoMontageInput

@end

@implementation QCloudInputVideoMontageOperation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"VideoMontage" : [QCloudInputVideoMontageVideoMontage class],
        @"Output" : [QCloudInputVideoMontageOutput class],
    };
}

@end

@implementation QCloudInputVideoMontageOutput

@end

@implementation QCloudInputVideoMontageVideoMontage

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"TimeInterval" : [QCloudTemplateTimeInterval class],
        @"Container" : [QCloudTemplateContainer class],
        @"Video" : [QCloudTemplateVideo class],
        @"Audio" : [QCloudAudioVoiceSeparateAudioConfig class],
        @"TransConfig" : [QCloudContainerTransConfig class],
        @"AudioMix" : [QCloudJobsDetailMix class],
        @"AudioMixArray" : [QCloudJobsDetailMix class],
    };
}

@end

