//
//  QCloudVocalScoreResponse.m
//  QCloudVocalScoreResponse
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

#import "QCloudVocalScoreResponse.h"
#import "QCloudCICommonModel.h"

NS_ASSUME_NONNULL_BEGIN

@implementation QCloudVocalScoreResponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"JobsDetail" : [QCloudVocalScoreResponseJobsDetail class],
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

@implementation QCloudVocalScoreResponseJobsDetail

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Input" : [QCloudVocalScoreInput class],
        @"Operation" : [QCloudVocalScoreResponseOperation class],
    };
}

@end

@implementation QCloudVocalScoreInput

@end

@implementation QCloudVocalScoreResponseOperation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"VocalScore" : [QCloudVocalScoreVocalScore class],
        @"VocalScoreResult" : [QCloudVocalScoreResponseVocalScoreResult class],
    };
}

@end

@implementation QCloudVocalScoreResponseVocalScoreResult

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"PitchScore" : [QCloudVocalScoreResponsePitchScore class],
        @"RhythemScore" : [QCloudVocalScoreResponseRhythemScore class],
    };
}

@end

@implementation QCloudVocalScoreResponsePitchScore

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"SentenceScores" : [QCloudVocalScoreResponseSentenceScores class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {

    if (!dic) {return dic;}

    if (![dic isKindOfClass:[NSDictionary class]]) {return nil;}

    if (dic[@"SentenceScores"] && [dic[@"SentenceScores"] isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mdic setValue:@[dic[@"SentenceScores"]] forKey:@"SentenceScores"];
        dic = mdic.copy;
    }
    return dic;
}

@end

@implementation QCloudVocalScoreResponseSentenceScores

@end

@implementation QCloudVocalScoreResponseRhythemScore

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"SentenceScores" : [QCloudVocalScoreResponseRhythemScoreSentenceScores class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {

    if (!dic) {return dic;}

    if (![dic isKindOfClass:[NSDictionary class]]) {return nil;}

    if (dic[@"SentenceScores"] && [dic[@"SentenceScores"] isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mdic setValue:@[dic[@"SentenceScores"]] forKey:@"SentenceScores"];
        dic = mdic.copy;
    }
    return dic;
}

@end

@implementation QCloudVocalScoreResponseRhythemScoreSentenceScores

@end

@implementation QCloudVocalScoreVocalScore

@end

@implementation QCloudVocalScore

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Input" : [QCloudVocalScoreInput class],
        @"Operation" : [QCloudVocalScoreOperation class],
        @"CallBackMqConfig" : [QCloudCallBackMqConfig class],
    };
}

@end

@implementation QCloudVocalScoreOperation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"VocalScore" : [QCloudVocalScoreVocalScore class],
    };
}

@end



NS_ASSUME_NONNULL_END
