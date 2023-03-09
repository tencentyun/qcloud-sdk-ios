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
    NSNumber *mode = dic[@"Mode"];
    if (mode) {
        NSString *value = QCloudGenerateSnapshotModeTransferToString([mode intValue]);
        if (value) {
            dic[@"Mode"] = value;
        }
    }
    NSNumber *rotate = dic[@"Rotate"];
    if (rotate) {
        NSString *value = QCloudGenerateSnapshotRotateTypeTransferToString([rotate intValue]);
        if (value) {
            dic[@"Rotate"] = value;
        }
    }
    NSNumber *format = dic[@"Format"];
    if (format) {
        NSString *value = QCloudGenerateSnapshotFormatTransferToString([format intValue]);
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

    NSString *mode = transfromDic[@"Mode"];
    if (mode && [mode isKindOfClass:[NSString class]] && mode.length > 0) {
        NSUInteger value = QCloudGenerateSnapshotModeDumpFromString(mode);
        transfromDic[@"Mode"] = @(value);
    }
    NSString *rotate = transfromDic[@"Rotate"];
    if (rotate && [rotate isKindOfClass:[NSString class]]
        && rotate.length > 0) {
        NSUInteger value = QCloudGenerateSnapshotRotateTypeDumpFromString(rotate);
        transfromDic[@"Rotate"] = @(value);
    }
    NSString *format = transfromDic[@"Format"];
    if (format && [format isKindOfClass:[NSString class]]
        && format.length > 0) {
        NSUInteger value = QCloudGenerateSnapshotFormatDumpFromString(format);
        transfromDic[@"Format"] = @(value);
    }
    return transfromDic;
}

@end

NS_ASSUME_NONNULL_END
