//
//  QCloudPostSegmentVideoBodyResponse.m
//  QCloudPostSegmentVideoBodyResponse
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

#import "QCloudPostSegmentVideoBodyResponse.h"


NS_ASSUME_NONNULL_BEGIN

@implementation QCloudPostSegmentVideoBodyResponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"JobsDetail" : [QCloudPostSegmentVideoBodyResponseJobsDetail class],
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

@implementation QCloudPostSegmentVideoBodyResponseJobsDetail

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Input" : [QCloudPostSegmentVideoBodyInput class],
        @"Operation" : [QCloudPostSegmentVideoBodyResponseOperation class],
    };
}

@end

@implementation QCloudPostSegmentVideoBodyInput

@end

@implementation QCloudPostSegmentVideoBodyResponseOperation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"SegmentVideoBody" : [QCloudPostSegmentVideoBodySegmentVideoBody class],
        @"Output" : [QCloudPostSegmentVideoBodyOutput class],
        @"MediaInfo" : [QCloudMediaInfo class],
        @"MediaResult" : [QCloudMediaResult class],
    };
}

@end

@implementation QCloudPostSegmentVideoBodyOutput

@end

@implementation QCloudPostSegmentVideoBodySegmentVideoBody

@end

@implementation QCloudPostSegmentVideoBody

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Input" : [QCloudPostSegmentVideoBodyInput class],
        @"Operation" : [QCloudPostSegmentVideoBodyOperation class],
        @"CallBackMqConfig" : [QCloudCallBackMqConfig class],
    };
}

@end

@implementation QCloudPostSegmentVideoBodyOperation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"SegmentVideoBody" : [QCloudPostSegmentVideoBodySegmentVideoBody class],
        @"Output" : [QCloudPostSegmentVideoBodyOutput class],
    };
}

@end



NS_ASSUME_NONNULL_END
