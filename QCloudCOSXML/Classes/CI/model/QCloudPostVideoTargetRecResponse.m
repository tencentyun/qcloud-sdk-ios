//
//  QCloudPostVideoTargetRecResponse.m
//  QCloudPostVideoTargetRecResponse
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

#import "QCloudPostVideoTargetRecResponse.h"


NS_ASSUME_NONNULL_BEGIN

@implementation QCloudPostVideoTargetRecResponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"JobsDetail" : [QCloudPostVideoTargetRecResponseJobsDetail class],
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

@implementation QCloudPostVideoTargetRecResponseJobsDetail

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Operation" : [QCloudPostVideoTargetRecResponseOperation class],
    };
}

@end

@implementation QCloudPostVideoTargetRecResponseOperation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"VideoTargetRec" : [QCloudVideoTargetRec class],
        @"VideoTargetRecResult" : [QCloudPostVideoTargetRecResponseVideoTargetRecResult class],
    };
}

@end

@implementation QCloudPostVideoTargetRecResponseVideoTargetRecResult

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"BodyRecognition" : [QCloudPostVideoTargetRecResponseBodyRecognition class],
        @"PetRecognition" : [QCloudPostVideoTargetRecResponsePetRecognition class],
        @"CarRecognition" : [QCloudPostVideoTargetRecResponseCarRecognition class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {

    if (!dic) {return dic;}

    if (![dic isKindOfClass:[NSDictionary class]]) {return nil;}

    if (dic[@"BodyRecognition"] && [dic[@"BodyRecognition"] isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mdic setValue:@[dic[@"BodyRecognition"]] forKey:@"BodyRecognition"];
        dic = mdic.copy;
    }
    if (dic[@"PetRecognition"] && [dic[@"PetRecognition"] isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mdic setValue:@[dic[@"PetRecognition"]] forKey:@"PetRecognition"];
        dic = mdic.copy;
    }
    if (dic[@"CarRecognition"] && [dic[@"CarRecognition"] isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mdic setValue:@[dic[@"CarRecognition"]] forKey:@"CarRecognition"];
        dic = mdic.copy;
    }
    return dic;
}

@end

@implementation QCloudPostVideoTargetRecResponseBodyRecognition

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"BodyInfo" : [QCloudPostVideoTargetRecResponseBodyInfo class],
    };
}

@end

@implementation QCloudPostVideoTargetRecResponseBodyInfo

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Location" : [QCloudPostVideoTargetRecResponseLocation class],
    };
}

@end

@implementation QCloudPostVideoTargetRecResponseLocation

@end

@implementation QCloudPostVideoTargetRecResponseCarRecognition

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"CarInfo" : [QCloudPostVideoTargetRecResponseCarInfo class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {

    if (!dic) {return dic;}

    if (![dic isKindOfClass:[NSDictionary class]]) {return nil;}

    if (dic[@"CarInfo"] && [dic[@"CarInfo"] isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mdic setValue:@[dic[@"CarInfo"]] forKey:@"CarInfo"];
        dic = mdic.copy;
    }
    return dic;
}

@end

@implementation QCloudPostVideoTargetRecResponseCarInfo

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Location" : [QCloudPostVideoTargetRecResponseLocation class],
    };
}

@end

@implementation QCloudPostVideoTargetRecResponsePetRecognition

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"PetInfo" : [QCloudPostVideoTargetRecResponsePetInfo class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {

    if (!dic) {return dic;}

    if (![dic isKindOfClass:[NSDictionary class]]) {return nil;}

    if (dic[@"PetInfo"] && [dic[@"PetInfo"] isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mdic setValue:@[dic[@"PetInfo"]] forKey:@"PetInfo"];
        dic = mdic.copy;
    }
    return dic;
}

@end

@implementation QCloudPostVideoTargetRecResponsePetInfo

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Location" : [QCloudPostVideoTargetRecResponseLocation class],
    };
}

@end

@implementation QCloudPostVideoTargetRec

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Operation" : [QCloudPostVideoTargetRecOperation class],
        @"Input" : [QCloudPostVideoTargetRecInput class],
        @"CallBackMqConfig" : [QCloudCallBackMqConfig class],
    };
}

@end

@implementation QCloudPostVideoTargetRecInput

@end

@implementation QCloudPostVideoTargetRecOperation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"VideoTargetRec" : [QCloudVideoTargetRec class],
    };
}

@end



NS_ASSUME_NONNULL_END
