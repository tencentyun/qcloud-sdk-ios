//
//
//  QCloudPostTranscode.m
//
//  QCloudCOSXML
//
//
//
//  Created by garenwang on
//
//  2023-06-14 03:57:33 +0000.
//

#import "QCloudPostTranscode.h"

@implementation QCloudPostTranscode

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"JobsDetail" : [QCloudPostTranscodeJobsDetail class],
    };
}

@end

@implementation QCloudPostTranscodeJobsDetail

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Input" : [QCloudPostTranscodeInput class],
        @"Operation" : [QCloudPostTranscodeOperation class],
    };
}

@end

@implementation QCloudPostTranscodeInput

@end

@implementation QCloudPostTranscodeOperation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Transcode" : [QCloudInputPostTranscodeTranscode class],
        @"Watermark" : [QCloudInputPostTranscodeWatermark class],
        @"RemoveWatermark" : [QCloudInputPostTranscodeRWatermark class],
        @"Output" : [QCloudInputPostTranscodeOutput class],
        @"MediaInfo" : [QCloudWorkflowMediaInfo class],
        @"MediaResult" : [QCloudMediaResult class],
        @"DigitalWatermark" : [QCloudInputPostTranscodeDigitalWatermark class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {

    if (!dic) {return dic;}

    if (![dic isKindOfClass:[NSDictionary class]]) {return nil;}

    if (dic[@"Watermark"] && [dic[@"Watermark"] isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mdic setValue:@[dic[@"Watermark"]] forKey:@"Watermark"];
        dic = mdic.copy;
    }
    return dic;
}

@end

@implementation QCloudInputPostTranscode

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Input" : [QCloudInputPostTranscodeInput class],
        @"Operation" : [QCloudInputPostTranscodeOperation class],
        @"CallBackMqConfig" : [QCloudCallBackMqConfig class],
    };
}

@end

@implementation QCloudInputPostTranscodeInput

@end

@implementation QCloudInputPostTranscodeOperation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Transcode" : [QCloudInputPostTranscodeTranscode class],
        @"Watermark" : [QCloudInputPostTranscodeWatermark class],
        @"RemoveWatermark" : [QCloudInputPostTranscodeRWatermark class],
        @"Subtitles" : [QCloudInputPostTranscodeSubtitles class],
        @"DigitalWatermark" : [QCloudInputPostTranscodeDigitalWatermark class],
        @"Output" : [QCloudInputPostTranscodeOutput class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {

    if (!dic) {return dic;}

    if (![dic isKindOfClass:[NSDictionary class]]) {return nil;}

    if (dic[@"Watermark"] && [dic[@"Watermark"] isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mdic setValue:@[dic[@"Watermark"]] forKey:@"Watermark"];
        dic = mdic.copy;
    }
    return dic;
}
@end

@implementation QCloudInputPostTranscodeOutput

@end

@implementation QCloudInputPostTranscodeSubtitles

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Subtitle" : [QCloudInputPostTranscodeSubtitle class],
    };
}

@end

@implementation QCloudInputPostTranscodeTranscode

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

@implementation QCloudInputPostTranscodeRWatermark

@end

@implementation QCloudInputPostTranscodeSubtitle

@end

