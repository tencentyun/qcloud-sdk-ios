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


