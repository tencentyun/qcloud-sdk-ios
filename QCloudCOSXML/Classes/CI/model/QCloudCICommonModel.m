//
//  QCloudCICommonModel.m
//  QCloudCOSXML
//
//  Created by garenwang on 2023/6/13.
//

#import "QCloudCICommonModel.h"

@implementation QCloudCallBackMqConfig
@end

@implementation QCloudMediaResult
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"OutputFile" : [QCloudMediaResultOutputFile class],
    };
}
@end

@implementation QCloudMediaResultOutputFile
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Md5Info" : [QCloudMediaResultOutputFileMd5Info class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {

    if (!dic) {return dic;}

    if (![dic isKindOfClass:[NSDictionary class]]) {return nil;}

    if (dic[@"Md5Info"] && [dic[@"Md5Info"] isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mdic setValue:@[dic[@"Md5Info"]] forKey:@"Md5Info"];
        dic = mdic.copy;
    }
    return dic;
}

@end

@implementation QCloudMediaResultOutputFileMd5Info
@end

@implementation QCloudPicProcess
@end

@implementation QCloudDigitalWatermark
@end

@implementation QCloudJobsDetailMix

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"EffectConfig" : [QCloudJobsDetailMixEffectConfig class],
    };
}

@end

@implementation QCloudJobsDetailMixEffectConfig

@end

@implementation QCloudAudioVoiceSeparateAudioConfig

@end

@implementation QCloudTemplateVideo

@end

@implementation QCloudTemplateContainer
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"ClipConfig" : [QCloudTemplateContainerClipConfig class],
    };
}

@end

@implementation QCloudTemplateContainerClipConfig


@end

@implementation QCloudTemplateTimeInterval


@end

@implementation QCloudInputPostTranscodeWatermark

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"SlideConfig" : [QCloudInputPostTranscodeWatermarkSlideConfig class],
        @"Image" : [QCloudInputPostTranscodeWatermarkImage class],
        @"Text" : [QCloudInputPostTranscodeWatermarkText class],
    };
}

@end

@implementation QCloudInputPostTranscodeWatermarkImage

@end

@implementation QCloudInputPostTranscodeWatermarkSlideConfig

@end

@implementation QCloudInputPostTranscodeWatermarkText

@end

@implementation QCloudInputPostTranscodeDigitalWatermark

@end

@implementation QCloudContainerTransConfig
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"HlsEncrypt" : [QCloudContainerTransConfigHlsEncrypt class],
        @"DashEncrypt" : [QCloudContainerTransConfigDashEncrypt class],
    };
}
@end
@implementation QCloudContainerTransConfigHlsEncrypt

@end
@implementation QCloudContainerTransConfigDashEncrypt

@end

@implementation QCloudContainerSnapshot
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"SpriteSnapshotConfig" : [QCloudContainerSnapshotConfig class],
    };
}
@end

@implementation QCloudContainerSnapshotConfig

@end




@implementation QCloudAudioConfig

@end

@implementation QCloudAudioMix

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"EffectConfig" : [QCloudEffectConfig class],
    };
}

@end


@implementation QCloudCreateWorkflowMediaWorkflow

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Topology" : [QCloudCreateWorkflowTopology class],
    };
}

@end

@implementation QCloudCreateWorkflowResponseMediaWorkflow

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Topology" : [QCloudCreateWorkflowTopology class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {

    if (!dic) {return dic;}

    if (![dic isKindOfClass:[NSDictionary class]]) {return nil;}

    if (dic[@"Topology"] && [dic[@"Topology"] isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mdic setValue:@[dic[@"Topology"]] forKey:@"Topology"];
        dic = mdic.copy;
    }
    return dic;
}

@end

@implementation QCloudCreateWorkflowTopology


@end

@implementation QCloudEffectConfig

@end

@implementation QCloudNoiseReduction

@end

@implementation QCloudNoiseReductionTempleteResponseTemplate

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"NoiseReduction" : [QCloudNoiseReduction class],
    };
}

@end

@implementation QCloudNotifyConfig

@end

@implementation QCloudSpeechRecognition

@end

@implementation QCloudSpeechRecognitionTempleteResponseTemplate

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"SpeechRecognition" : [QCloudSpeechRecognition class],
    };
}

@end

@implementation QCloudVideoTargetRec

@end

@implementation QCloudVideoTargetTempleteResponseTemplate

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"VideoTargetRec" : [QCloudVideoTargetRec class],
    };
}

@end

@implementation QCloudVoiceSeparateTempleteResponseTemplate

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"VoiceSeparate" : [QCloudVoiceSeparateTempleteResponseVoiceSeparate class],
    };
}

@end

@implementation QCloudVoiceSeparateTempleteResponseVoiceSeparate

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"AudioConfig" : [QCloudAudioConfig class],
    };
}

@end

@implementation QCloudVoiceSynthesisTempleteResponseTemplate

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"TtsTpl" : [QCloudVoiceSynthesisTempleteResponseTtsTpl class],
    };
}

@end

@implementation QCloudVoiceSynthesisTempleteResponseTtsTpl

@end


@implementation QCloudPostFileUnzipProcessJobOutput

@end

@implementation QCloudPostFileUnzipProcessJobResponseJobsDetail

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Input" : [QCloudPostFileUnzipProcessJobResponseInput class],
        @"Operation" : [QCloudPostFileUnzipProcessJobResponseOperation class],
    };
}

@end

@implementation QCloudPostFileUnzipProcessJobResponseInput

@end

@implementation QCloudPostFileUnzipProcessJobResponseOperation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Output" : [QCloudPostFileUnzipProcessJobOutput class],
        @"FileUncompressConfig" : [QCloudFileUncompressConfig class],
        @"FileUncompressResult" : [QCloudFileUncompressResult class],
    };
}

@end

@implementation QCloudFileUncompressConfig

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"DownloadConfig" : [QCloudDownloadConfig class],
    };
}

@end

@implementation QCloudDownloadConfig

@end

@implementation QCloudFileUncompressResult

@end

@implementation QCloudCreateFileZipProcessJobsResponseJobsDetail

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Operation" : [QCloudCreateFileZipProcessJobsResponseOperation class],
    };
}

@end

@implementation QCloudCreateFileZipProcessJobsResponseOperation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Output" : [QCloudCreateFileZipProcessJobsOutput class],
        @"FileCompressConfig" : [QCloudFileCompressConfig class],
        @"FileCompressResult" : [QCloudFileCompressResult class],
    };
}

@end

@implementation QCloudCreateFileZipProcessJobsOutput

@end

@implementation QCloudFileCompressConfig

@end

@implementation QCloudFileCompressResult

@end

@implementation QCloudPostHashProcessJobsResponseJobsDetail

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Input" : [QCloudPostHashProcessJobsResponseInput class],
        @"Operation" : [QCloudPostHashProcessJobsResponseOperation class],
    };
}

@end

@implementation QCloudPostHashProcessJobsResponseInput

@end

@implementation QCloudPostHashProcessJobsResponseOperation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"FileHashCodeConfig" : [QCloudPostHashProcessJobsFileHashCodeConfig class],
        @"FileHashCodeResult" : [QCloudPostHashProcessJobsFileHashCodeResult class],
    };
}

@end

@implementation QCloudPostHashProcessJobsFileHashCodeConfig

@end

@implementation QCloudPostHashProcessJobsFileHashCodeResult

@end

@implementation QCloudQueueList

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"NotifyConfig" : [QCloudNotifyConfig class],
    };
}

@end

@implementation QCloudFileListContents

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Contents" : [QCloudFileListContent class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {

    if (!dic) {return dic;}

    if (![dic isKindOfClass:[NSDictionary class]]) {return nil;}

    if (dic[@"Contents"] && [dic[@"Contents"] isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mdic setValue:@[dic[@"Contents"]] forKey:@"Contents"];
        dic = mdic.copy;
    }
    return dic;
}

@end

@implementation QCloudFileListContent

@end
