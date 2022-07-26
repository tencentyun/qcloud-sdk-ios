//
//  QCloudPostAudioDiscernTaskInfo.m
//  QCloudCOSXML
//
//  Created by garenwang on 2022/7/22.
//

#import "QCloudPostAudioDiscernTaskInfo.h"

@implementation QCloudPostAudioDiscernTaskInfo
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Input": [QCloudPostAudioDiscernTaskInfoInput class],
        @"Operation": [QCloudPostAudioDiscernTaskInfoOperation class],
    };
}
@end

@implementation QCloudPostAudioDiscernTaskInfoInput

@end

@implementation QCloudPostAudioDiscernTaskInfoOperation
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"SpeechRecognition": [QCloudPostAudioDiscernTaskInfoSpeechRecognition class],
        @"Output": [QCloudPostAudioDiscernTaskInfoOutput class],
    };
}
@end

@implementation QCloudPostAudioDiscernTaskInfoSpeechRecognition
@end

@implementation QCloudPostAudioDiscernTaskInfoOutput

@end

@implementation QCloudPostAudioDiscernTaskResult

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"JobsDetail": [QCloudPostAudioDiscernTaskJobsDetail class]
    };
}
@end

@implementation QCloudPostAudioDiscernTaskJobsDetail

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Operation": [QCloudPostAudioDiscernTaskJobsOperation class],
        @"Input": [QCloudPostAudioDiscernTaskResultInput class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    NSMutableDictionary *transfromDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    NSString *StateenumValue = transfromDic[@"State"];
    if (StateenumValue && [StateenumValue isKindOfClass:[NSString class]] && StateenumValue.length > 0) {
        NSUInteger value = QCloudTaskStatesEnumFromString(StateenumValue);
        transfromDic[@"State"] = @(value);
    }
    return transfromDic;
}

@end

@implementation QCloudPostAudioDiscernTaskJobsOperation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Output": [QCloudPostAudioDiscernTaskInfoOutput class],
        @"SpeechRecognition":[QCloudPostAudioDiscernTaskInfoSpeechRecognition class],
        @"SpeechRecognitionResult":[QCloudPostAudioDiscernTaskInfoSpeechRecognitionResult class]
    };
}

@end

@implementation QCloudPostAudioDiscernTaskResultInput

@end

@implementation QCloudPostAudioDiscernTaskInfoSpeechRecognitionResult
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"ResultDetail": [QCloudPostAudioDiscernTaskInfoSpeechResultDetail class]
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    
    NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    if ([mdic[@"ResultDetail"] isKindOfClass:[NSDictionary class]]) {
        [mdic setValue:@[mdic[@"ResultDetail"]] forKey:@"ResultDetail"];
    }
    return mdic.mutableCopy;
}
@end


@implementation QCloudPostAudioDiscernTaskInfoSpeechResultDetail
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Words": [QCloudPostAudioDiscernTaskInfoSpeechWords class]
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    
    NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    if ([mdic[@"Words"] isKindOfClass:[NSDictionary class]]) {
        [mdic setValue:@[mdic[@"Words"]] forKey:@"Words"];
    }
    return mdic.mutableCopy;
}
@end

@implementation QCloudPostAudioDiscernTaskInfoSpeechWords

@end

