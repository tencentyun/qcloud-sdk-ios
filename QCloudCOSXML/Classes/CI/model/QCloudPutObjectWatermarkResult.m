//
//  QCloudPutObjectWatermarkResult.m
//  QCloudPutObjectWatermarkResult
//
//  Created by tencent
//  Copyright (c) 2020年 tencent. All rights reserved.
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

#import "QCloudPutObjectWatermarkResult.h"

@implementation QCloudPutObjectWatermarkResult

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"originalInfo" : [QCloudPutObjectOriginalInfo class],
        @"processResults" : [QCloudPutObjectProcessResults class],
    };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"originalInfo" : @"OriginalInfo", @"processResults" : @"ProcessResults" };
}

@end

@implementation QCloudPutObjectOriginalInfo

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"imageInfo" : [QCloudPutObjectImageInfo class]
    };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"key" : @"Key", @"location" : @"Location", @"imageInfo" : @"ImageInfo" };
}


@end

@implementation QCloudPutObjectProcessResults


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Object" : [QCloudPutObjectObj class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic
{
    if (!dic) {
        return dic;
    }
    NSMutableDictionary* transfromDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    NSArray* transformArrayKeypaths = @[
    @"Object",
    ];

    for (NSString* keyPath in transformArrayKeypaths) {
        id object = [dic valueForKeyPath:keyPath];
        if (!object) {
            continue;
        }
        if ([object isKindOfClass:[NSNull class]]) {
            continue;
        }
        if (![object isKindOfClass:[NSArray class]]) {
            [transfromDic setValue:@[object] forKeyPath:keyPath];
        }
    }

    return transfromDic;
}

@end

@implementation QCloudPutObjectImageInfo

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"format" : @"Format",
        @"width" : @"Width",
        @"height" : @"Height",
        @"quality" : @"Quality",
        @"ave" : @"Ave",
        @"orientation" : @"Orientation",

    };
}

@end

@implementation QCloudPutObjectObj

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"key" : @"Key",
        @"location" : @"Location",
        @"format" : @"Format",
        @"width" : @"Width",
        @"height" : @"Height",
        @"size" : @"Size",
        @"orientation" : @"Orientation",
    };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"QRcodeInfo" : [QCloudCIQRcodeInfo class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic
{
    if (!dic) {
        return dic;
    }
    NSMutableDictionary* transfromDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    NSArray* transformArrayKeypaths = @[
    @"QRcodeInfo",
    ];

    for (NSString* keyPath in transformArrayKeypaths) {
        id object = [dic valueForKeyPath:keyPath];
        if (!object) {
            continue;
        }
        if ([object isKindOfClass:[NSNull class]]) {
            continue;
        }
        if (![object isKindOfClass:[NSArray class]]) {
            [transfromDic setValue:@[object] forKeyPath:keyPath];
        }
    }

    return transfromDic;
}
@end
