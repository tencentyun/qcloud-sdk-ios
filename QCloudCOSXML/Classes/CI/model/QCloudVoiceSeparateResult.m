//
//
//  QCloudVoiceSeparateResult.m
//
//  QCloudCOSXML
//
//
//
//  Created by garenwang on
//
//  2023-06-13 12:44:12 +0000.
//

#import "QCloudVoiceSeparateResult.h"

@implementation QCloudVoiceSeparateResult

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"JobsDetail" : [QCloudVoiceSeparateJobsDetail class],
    };
}

@end

@implementation QCloudVoiceSeparateJobsDetail

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Input" : [QCloudVoiceSeparateInput class],
        @"Operation" : [QCloudVoiceSeparateOperation class],
    };
}

@end

@implementation QCloudVoiceSeparateInput

@end

@implementation QCloudVoiceSeparateOperation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"VoiceSeparate" : [QCloudVoiceSeparate class],
        @"Output" : [QCloudInputVoiceSeparateOutput class],
        @"MediaInfo" : [QCloudWorkflowMediaInfo class],
        @"MediaResult" : [QCloudMediaResult class],
    };
}

@end

@implementation QCloudInputVoiceSeparate

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Input" : [QCloudInputVoiceSeparateInput class],
        @"Operation" : [QCloudInputVoiceSeparateOperation class],
        @"CallBackMqConfig" : [QCloudCallBackMqConfig class],
    };
}

@end

@implementation QCloudInputVoiceSeparateInput

@end

@implementation QCloudInputVoiceSeparateOperation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"VoiceSeparate" : [QCloudVoiceSeparate class],
        @"Output" : [QCloudInputVoiceSeparateOutput class],
    };
}

@end

@implementation QCloudInputVoiceSeparateOutput

@end

@implementation QCloudVoiceSeparate
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"AudioConfig" : [QCloudAudioVoiceSeparateAudioConfig class],
    };
}
@end


