//
//  QCloudDomainRule.m
//  QCloudDomainRule
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

#import "QCloudDomainRule.h"

NS_ASSUME_NONNULL_BEGIN
@implementation QCloudDomainRule

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"name" : @"Name",
        @"status" : @"Status",
        @"type" : @"Type",
        @"replace" : @"Replace",
    };
}

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    NSNumber *status = dic[@"Status"];
    if (status) {
        NSString *value = QCloudDomainStatueTransferToString([status intValue]);
        if (value) {
            dic[@"Status"] = value;
        }
    }
    NSNumber *type = dic[@"Type"];
    if (type) {
        NSString *value = QCloudCOSDomainTypeTransferToString([type intValue]);
        if (value) {
            dic[@"Type"] = value;
        }
    }
    NSNumber *replace = dic[@"Replace"];
    if (replace) {
        NSString *value = QCloudCOSDomainReplaceTypeTransferToString([replace intValue]);
        if (value) {
            dic[@"Replace"] = value;
        }
    }

    return YES;
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    NSMutableDictionary *transfromDic = [NSMutableDictionary dictionaryWithDictionary:dic];

    NSString *status = transfromDic[@"Status"];
    if (status && [status isKindOfClass:[NSString class]] && status.length > 0) {
        NSInteger value = QCloudDomainStatueDumpFromString(status);
        transfromDic[@"Status"] = @(value);
    }
    NSString *type = transfromDic[@"Type"];
    if (type && [type isKindOfClass:[NSString class]] && type.length > 0) {
        NSInteger value = QCloudCOSDomainTypeDumpFromString(type);
        transfromDic[@"Type"] = @(value);
    }
    NSString *replace = transfromDic[@"Replace"];
    if (replace && [replace isKindOfClass:[NSString class]] && replace.length > 0) {
        NSInteger value = QCloudCOSDomainReplaceTypeDumpFromString(replace);
        transfromDic[@"Replace"] = @(value);
    }
    return transfromDic;
}

@end

NS_ASSUME_NONNULL_END
