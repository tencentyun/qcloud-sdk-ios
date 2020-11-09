//
//  QCloudInventoryConfiguration.m
//  QCloudInventoryConfiguration
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

#import "QCloudInventoryConfiguration.h"

#import "QCloudInventoryDestination.h"
#import "QCloudInventorySchedule.h"
#import "QCloudInventoryFilter.h"
#import "QCloudInventoryOptionalFields.h"

NS_ASSUME_NONNULL_BEGIN
@implementation QCloudInventoryConfiguration

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"identifier" : @"Id",
        @"isEnabled" : @"IsEnabled",
        @"includedObjectVersions" : @"IncludedObjectVersions",
        @"destination" : @"Destination",
        @"schedule" : @"Schedule",
        @"filter" : @"Filter",
        @"optionalFields" : @"OptionalFields",
    };
}

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    NSNumber *COSIncludedObjectVersionsenumValue = dic[@"IncludedObjectVersions"];
    if (COSIncludedObjectVersionsenumValue) {
        NSString *value = QCloudCOSIncludedObjectVersionsTransferToString([COSIncludedObjectVersionsenumValue intValue]);
        if (value) {
            dic[@"IncludedObjectVersions"] = value;
        }
    }

    return YES;
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    NSMutableDictionary *transfromDic = [NSMutableDictionary dictionaryWithDictionary:dic];

    NSString *COSIncludedObjectVersionsenumValue = transfromDic[@"IncludedObjectVersions"];
    if (COSIncludedObjectVersionsenumValue && [COSIncludedObjectVersionsenumValue isKindOfClass:[NSString class]]
        && COSIncludedObjectVersionsenumValue.length > 0) {
        NSInteger value = QCloudCOSIncludedObjectVersionsDumpFromString(COSIncludedObjectVersionsenumValue);
        transfromDic[@"IncludedObjectVersions"] = @(value);
    }
    return transfromDic;
}

@end

NS_ASSUME_NONNULL_END
