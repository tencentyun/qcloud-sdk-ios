//
//
//  QCloudPostAudioTransferJobs.m
//
//  QCloudCOSXML
//
//
//
//  Created by garenwang on
//
//  2023-06-13 09:20:26 +0000.
//

#import "QCloudPostAudioTransferJobs.h"

@implementation QCloudPostAudioTransferJobs

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"JobsDetail" : [QCloudPostAudioTransferDetail class],
    };
}

@end

@implementation QCloudPostAudioTransferDetail

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Input" : [QCloudPostAudioTransferJobsInput class],
        @"Operation" : [QCloudPostAudioTransferJobsOperation class],
    };
}

@end

@implementation QCloudPostAudioTransferJobsInput

@end

@implementation QCloudPostAudioTransferJobsOperation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Segment" : [QCloudInputPostAudioTransferSegment class],
        @"Output" : [QCloudInputPostAudioTransferOutput class],
        @"MediaInfo" : [QCloudWorkflowMediaInfo class],
        @"MediaResult" : [QCloudMediaResult class],
    };
}

@end

@implementation QCloudInputPostAudioTransferJobs

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Input" : [QCloudInputPostAudioTransferJobsInput class],
        @"Operation" : [QCloudInputPostAudioTransferOperation class],
        @"CallBackMqConfig" : [QCloudCallBackMqConfig class],
    };
}

@end

@implementation QCloudInputPostAudioTransferJobsInput

@end

@implementation QCloudInputPostAudioTransferOperation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Segment" : [QCloudInputPostAudioTransferSegment class],
        @"Output" : [QCloudInputPostAudioTransferOutput class],
    };
}

@end

@implementation QCloudInputPostAudioTransferOutput

@end

@implementation QCloudInputPostAudioTransferSegment

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"HlsEncrypt" : [QCloudInputPostAudioTransferHlsEncrypt class],
    };
}

@end

@implementation QCloudInputPostAudioTransferHlsEncrypt

@end

