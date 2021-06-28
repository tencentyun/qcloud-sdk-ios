//
//  QCloudGenerateSnapshotConfiguration.m
//  QCloudGenerateSnapshotConfiguration
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

#import "QCloudGenerateSnapshotConfiguration.h"
#import "QCloudGenerateSnapshotInput.h"
#import "QCloudGenerateSnapshotOutput.h"

NS_ASSUME_NONNULL_BEGIN
@implementation QCloudGenerateSnapshotConfiguration

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"time" : @"Time",
        @"width" : @"Width",
        @"height" : @"Height",
        @"input" : @"Input",
        @"output" : @"Output",
        @"mode" : @"Mode",
        @"rotate" : @"Rotate",
        @"format" : @"Format",
    };
}

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    NSNumber *GenerateSnapshotModeenumValue = dic[@"Mode"];
    if (GenerateSnapshotModeenumValue) {
        NSString *value = QCloudGenerateSnapshotModeTransferToString([GenerateSnapshotModeenumValue intValue]);
        if (value) {
            dic[@"Mode"] = value;
        }
    }
    NSNumber *GenerateSnapshotRotateTypeenumValue = dic[@"Rotate"];
    if (GenerateSnapshotRotateTypeenumValue) {
        NSString *value = QCloudGenerateSnapshotRotateTypeTransferToString([GenerateSnapshotRotateTypeenumValue intValue]);
        if (value) {
            dic[@"Rotate"] = value;
        }
    }
    NSNumber *GenerateSnapshotFormatenumValue = dic[@"Format"];
    if (GenerateSnapshotFormatenumValue) {
        NSString *value = QCloudGenerateSnapshotFormatTransferToString([GenerateSnapshotFormatenumValue intValue]);
        if (value) {
            dic[@"Format"] = value;
        }
    }

    return YES;
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    NSMutableDictionary *transfromDic = [NSMutableDictionary dictionaryWithDictionary:dic];

    NSString *GenerateSnapshotModeenumValue = transfromDic[@"Mode"];
    if (GenerateSnapshotModeenumValue && [GenerateSnapshotModeenumValue isKindOfClass:[NSString class]] && GenerateSnapshotModeenumValue.length > 0) {
        NSUInteger value = QCloudGenerateSnapshotModeDumpFromString(GenerateSnapshotModeenumValue);
        transfromDic[@"Mode"] = @(value);
    }
    NSString *GenerateSnapshotRotateTypeenumValue = transfromDic[@"Rotate"];
    if (GenerateSnapshotRotateTypeenumValue && [GenerateSnapshotRotateTypeenumValue isKindOfClass:[NSString class]]
        && GenerateSnapshotRotateTypeenumValue.length > 0) {
        NSUInteger value = QCloudGenerateSnapshotRotateTypeDumpFromString(GenerateSnapshotRotateTypeenumValue);
        transfromDic[@"Rotate"] = @(value);
    }
    NSString *GenerateSnapshotFormatenumValue = transfromDic[@"Format"];
    if (GenerateSnapshotFormatenumValue && [GenerateSnapshotFormatenumValue isKindOfClass:[NSString class]]
        && GenerateSnapshotFormatenumValue.length > 0) {
        NSUInteger value = QCloudGenerateSnapshotFormatDumpFromString(GenerateSnapshotFormatenumValue);
        transfromDic[@"Format"] = @(value);
    }
    return transfromDic;
}

@end

NS_ASSUME_NONNULL_END
