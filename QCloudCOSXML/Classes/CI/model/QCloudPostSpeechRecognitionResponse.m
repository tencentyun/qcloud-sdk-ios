//
//  QCloudPostSpeechRecognitionResponse.m
//  QCloudPostSpeechRecognitionResponse
//
//  Created by tencent
//  Copyright (c) 2015年 tencent. All rights reserved.
//
//   ██████╗  ██████╗██╗      ██████╗ ██╗   ██╗██████╗     ████████╗███████╗██████╗ ███╗   ███╗██╗███╗   ██╗ █████╗ ██╗         ██╗      █████╗
//   ██████╗
//  ██╔═══██╗██╔════╝██║     ██╔═══██╗██║   ██║██╔══██╗    ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║████╗  ██║██╔══██╗██║         ██║ ██╔══██╗██╔══██╗
//  ██║   ██║██║     ██║     ██║   ██║██║   ██║██║  ██║       ██║   █████╗  ██████╔╝██╔████╔██║██║██╔██╗ ██║███████║██║         ██║ ███████║██████╔╝
//  ██║▄▄ ██║██║     ██║     ██║   ██║██║   ██║██║  ██║       ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║██║╚██╗██║██╔══██║██║         ██║ ██╔══██║██╔══██╗
//  ╚██████╔╝╚██████╗███████╗╚██████╔╝╚██████╔╝██████╔╝       ██║   ███████╗██║  ██║██║ ╚═╝ ██║██║██║ ╚████║██║  ██║███████╗    ███████╗██║
//  ██║██████╔╝
//   ╚══▀▀═╝  ╚═════╝╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝        ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝    ╚══════╝╚═╝ ╚═╝╚═════╝
//
//
//                                                                              _             __                 _                _
//                                                                             (_)           / _|               | |              | |
//                                                          ___  ___ _ ____   ___  ___ ___  | |_ ___  _ __    __| | _____   _____| | ___  _ __   ___ _
//                                                          __ ___
//                                                         / __|/ _ \ '__\ \ / / |/ __/ _ \ |  _/ _ \| '__|  / _` |/ _ \ \ / / _ \ |/ _ \| '_ \ / _ \
//                                                         '__/ __|
//                                                         \__ \  __/ |   \ V /| | (_|  __/ | || (_) | |    | (_| |  __/\ V /  __/ | (_) | |_) |  __/
//                                                         |  \__
//                                                         |___/\___|_|    \_/ |_|\___\___| |_| \___/|_|     \__,_|\___| \_/ \___|_|\___/| .__/
//                                                         \___|_|  |___/
//    ______ ______ ______ ______ ______ ______ ______ ______                                                                            | |
//   |______|______|______|______|______|______|______|______|                                                                           |_|
//

#import "QCloudPostSpeechRecognitionResponse.h"


NS_ASSUME_NONNULL_BEGIN

@implementation QCloudPostSpeechRecognitionResponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"JobsDetail" : [QCloudPostSpeechRecognitionResponseJobsDetail class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {

    if (!dic) {return dic;}

    if (![dic isKindOfClass:[NSDictionary class]]) {return nil;}

    if (dic[@"JobsDetail"] && [dic[@"JobsDetail"] isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mdic setValue:@[dic[@"JobsDetail"]] forKey:@"JobsDetail"];
        dic = mdic.copy;
    }
    return dic;
}

@end

@implementation QCloudPostSpeechRecognitionResponseJobsDetail

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Input" : [QCloudPostSpeechRecognitionInput class],
        @"Operation" : [QCloudPostSpeechRecognitionResponseOperation class],
    };
}

@end

@implementation QCloudPostSpeechRecognitionInput

@end

@implementation QCloudPostSpeechRecognitionResponseOperation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"SpeechRecognition" : [QCloudSpeechRecognition class],
        @"Output" : [QCloudPostSpeechRecognitionOutput class],
        @"SpeechRecognitionResult" : [QCloudPostSpeechRecognitionResponseSpeechRecognitionResult class],
    };
}

@end

@implementation QCloudPostSpeechRecognitionOutput

@end

@implementation QCloudPostSpeechRecognitionResponseSpeechRecognitionResult

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"FlashResult" : [QCloudPostSpeechRecognitionResponseFlashResult class],
        @"ResultDetail" : [QCloudPostSpeechRecognitionResponseResultDetail class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {

    if (!dic) {return dic;}

    if (![dic isKindOfClass:[NSDictionary class]]) {return nil;}

    if (dic[@"FlashResult"] && [dic[@"FlashResult"] isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mdic setValue:@[dic[@"FlashResult"]] forKey:@"FlashResult"];
        dic = mdic.copy;
    }
    if (dic[@"ResultDetail"] && [dic[@"ResultDetail"] isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mdic setValue:@[dic[@"ResultDetail"]] forKey:@"ResultDetail"];
        dic = mdic.copy;
    }
    return dic;
}

@end

@implementation QCloudPostSpeechRecognitionResponseFlashResult

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"sentence_list" : [QCloudPostSpeechRecognitionResponsesentence_list class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {

    if (!dic) {return dic;}

    if (![dic isKindOfClass:[NSDictionary class]]) {return nil;}

    if (dic[@"sentence_list"] && [dic[@"sentence_list"] isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mdic setValue:@[dic[@"sentence_list"]] forKey:@"sentence_list"];
        dic = mdic.copy;
    }
    return dic;
}

@end

@implementation QCloudPostSpeechRecognitionResponsesentence_list

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"word_list" : [QCloudPostSpeechRecognitionResponseword_list class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {

    if (!dic) {return dic;}

    if (![dic isKindOfClass:[NSDictionary class]]) {return nil;}

    if (dic[@"word_list"] && [dic[@"word_list"] isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mdic setValue:@[dic[@"word_list"]] forKey:@"word_list"];
        dic = mdic.copy;
    }
    return dic;
}

@end

@implementation QCloudPostSpeechRecognitionResponseword_list

@end

@implementation QCloudPostSpeechRecognitionResponseResultDetail

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Words" : [QCloudPostSpeechRecognitionResponseWords class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {

    if (!dic) {return dic;}

    if (![dic isKindOfClass:[NSDictionary class]]) {return nil;}

    if (dic[@"Words"] && [dic[@"Words"] isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mdic setValue:@[dic[@"Words"]] forKey:@"Words"];
        dic = mdic.copy;
    }
    return dic;
}

@end

@implementation QCloudPostSpeechRecognitionResponseWords

@end

@implementation QCloudPostSpeechRecognition

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Input" : [QCloudPostSpeechRecognitionInput class],
        @"Operation" : [QCloudPostSpeechRecognitionOperation class],
        @"CallBackMqConfig" : [QCloudCallBackMqConfig class],
    };
}

@end

@implementation QCloudPostSpeechRecognitionOperation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"SpeechRecognition" : [QCloudSpeechRecognition class],
        @"Output" : [QCloudPostSpeechRecognitionOutput class],
    };
}

@end



NS_ASSUME_NONNULL_END
