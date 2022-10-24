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
        @"ResultDetail": [QCloudPostAudioDiscernTaskInfoSpeechResultDetail class],
        @"FlashResult": [QCloudPostAudioDiscernTaskInfoSpeechFlashResult class],
        @"WordsGeneralizeResult":[QCloudWordsGeneralizeResultGeneralize class]
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
    
    if ([mdic[@"FlashResult"] isKindOfClass:[NSDictionary class]]) {
        [mdic setValue:@[mdic[@"FlashResult"]] forKey:@"FlashResult"];
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


@implementation QCloudPostAudioDiscernTaskInfoSpeechFlashResult
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"sentence_list": [QCloudPostAudioDiscernTaskInfoSpeechFlashResultSentenceList class]
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    
    NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    if ([mdic[@"sentence_list"] isKindOfClass:[NSDictionary class]]) {
        [mdic setValue:@[mdic[@"sentence_list"]] forKey:@"sentence_list"];
    }
    return mdic.mutableCopy;
}
@end

@implementation QCloudPostAudioDiscernTaskInfoSpeechFlashResultSentenceList
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"word_list": [QCloudPostAudioDiscernTaskInfoSpeechFlashResultWordList class]
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    
    NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    if ([mdic[@"word_list"] isKindOfClass:[NSDictionary class]]) {
        [mdic setValue:@[mdic[@"word_list"]] forKey:@"word_list"];
    }
    return mdic.mutableCopy;
}
@end

@implementation QCloudPostAudioDiscernTaskInfoSpeechFlashResultWordList
@end

