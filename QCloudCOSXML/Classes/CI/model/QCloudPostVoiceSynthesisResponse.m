//
//  QCloudPostVoiceSynthesisResponse.m
//  QCloudPostVoiceSynthesisResponse
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

#import "QCloudPostVoiceSynthesisResponse.h"


NS_ASSUME_NONNULL_BEGIN

@implementation QCloudPostVoiceSynthesisResponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"JobsDetail" : [QCloudPostVoiceSynthesisResponseJobsDetail class],
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

@implementation QCloudPostVoiceSynthesisResponseJobsDetail

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Operation" : [QCloudPostVoiceSynthesisResponseOperation class],
    };
}

@end

@implementation QCloudPostVoiceSynthesisResponseOperation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"TtsTpl" : [QCloudPostVoiceSynthesisTtsTpl class],
        @"TtsConfig" : [QCloudPostVoiceSynthesisTtsConfig class],
        @"Output" : [QCloudPostVoiceSynthesisOutput class],
        @"MediaInfo" : [QCloudMediaInfo class],
        @"MediaResult" : [QCloudMediaResult class],
    };
}

@end

@implementation QCloudPostVoiceSynthesisOutput

@end

@implementation QCloudPostVoiceSynthesisTtsConfig

@end

@implementation QCloudPostVoiceSynthesisTtsTpl

@end

@implementation QCloudPostVoiceSynthesis

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Operation" : [QCloudPostVoiceSynthesisOperation class],
        @"CallBackMqConfig" : [QCloudCallBackMqConfig class],
    };
}

@end

@implementation QCloudPostVoiceSynthesisOperation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"TtsTpl" : [QCloudPostVoiceSynthesisTtsTpl class],
        @"TtsConfig" : [QCloudPostVoiceSynthesisTtsConfig class],
        @"Output" : [QCloudPostVoiceSynthesisOutput class],
    };
}

@end



NS_ASSUME_NONNULL_END
