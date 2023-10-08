//
//  QCloudPostWordsGeneralizeResponse.m
//  QCloudPostWordsGeneralizeResponse
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

#import "QCloudPostWordsGeneralizeResponse.h"


NS_ASSUME_NONNULL_BEGIN

@implementation QCloudPostWordsGeneralizeResponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"JobsDetail" : [QCloudPostWordsGeneralizeResponseJobsDetail class],
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

@implementation QCloudPostWordsGeneralizeResponseJobsDetail

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Input" : [QCloudPostWordsGeneralizeInput class],
        @"Operation" : [QCloudPostWordsGeneralizeResponseOperation class],
    };
}

@end

@implementation QCloudPostWordsGeneralizeInput

@end

@implementation QCloudPostWordsGeneralizeResponseOperation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"WordsGeneralize" : [QCloudPostWordsGeneralizeWordsGeneralize class],
        @"WordsGeneralizeResult" : [QCloudPostWordsGeneralizeResponseWordsGeneralizeResult class],
    };
}

@end

@implementation QCloudPostWordsGeneralizeResponseWordsGeneralizeResult

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"WordsGeneralizeLable" : [QCloudPostWordsGeneralizeResponseWordsGeneralizeLable class],
        @"WordsGeneralizeToken" : [QCloudPostWordsGeneralizeResponseWordsGeneralizeToken class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {

    if (!dic) {return dic;}

    if (![dic isKindOfClass:[NSDictionary class]]) {return nil;}

    if (dic[@"WordsGeneralizeLable"] && [dic[@"WordsGeneralizeLable"] isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mdic setValue:@[dic[@"WordsGeneralizeLable"]] forKey:@"WordsGeneralizeLable"];
        dic = mdic.copy;
    }
    if (dic[@"WordsGeneralizeToken"] && [dic[@"WordsGeneralizeToken"] isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mdic setValue:@[dic[@"WordsGeneralizeToken"]] forKey:@"WordsGeneralizeToken"];
        dic = mdic.copy;
    }
    return dic;
}

@end

@implementation QCloudPostWordsGeneralizeResponseWordsGeneralizeLable

@end

@implementation QCloudPostWordsGeneralizeResponseWordsGeneralizeToken

@end

@implementation QCloudPostWordsGeneralizeWordsGeneralize

@end

@implementation QCloudPostWordsGeneralize

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Input" : [QCloudPostWordsGeneralizeInput class],
        @"Operation" : [QCloudPostWordsGeneralizeOperation class],
        @"CallBackMqConfig" : [QCloudCallBackMqConfig class],
    };
}

@end

@implementation QCloudPostWordsGeneralizeOperation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"WordsGeneralize" : [QCloudPostWordsGeneralizeWordsGeneralize class],
    };
}

@end



NS_ASSUME_NONNULL_END
