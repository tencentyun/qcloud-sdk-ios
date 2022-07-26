//
//  QCloudGetAudioDiscernTaskResult.m
//  QCloudCOSXML
//
//  Created by garenwang on 2022/7/22.
//

#import "QCloudGetAudioDiscernTaskResult.h"

@implementation QCloudGetAudioDiscernTaskResult

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"JobsDetail": [QCloudPostAudioDiscernTaskJobsDetail class],
        @"SpeechRecognitionResult": [QCloudPostAudioDiscernTaskInfoSpeechRecognitionResult class],
    };
}
@end

@implementation QCloudBatchGetAudioDiscernTaskResult

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"JobsDetail": [QCloudPostAudioDiscernTaskJobsDetail class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    if (dic[@"JobsDetail"] && [dic[@"JobsDetail"] isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mdic setValue:@[dic[@"JobsDetail"]] forKey:@"JobsDetail"];
        dic = mdic.copy;
    }
    return dic;
}

@end
