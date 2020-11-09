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
    NSNumber *DomainStatueenumValue = dic[@"Status"];
    if (DomainStatueenumValue) {
        NSString *value = QCloudDomainStatueTransferToString([DomainStatueenumValue intValue]);
        if (value) {
            dic[@"Status"] = value;
        }
    }
    NSNumber *COSDomainTypeenumValue = dic[@"Type"];
    if (COSDomainTypeenumValue) {
        NSString *value = QCloudCOSDomainTypeTransferToString([COSDomainTypeenumValue intValue]);
        if (value) {
            dic[@"Type"] = value;
        }
    }
    NSNumber *COSDomainReplaceTypeenumValue = dic[@"Replace"];
    if (COSDomainReplaceTypeenumValue) {
        NSString *value = QCloudCOSDomainReplaceTypeTransferToString([COSDomainReplaceTypeenumValue intValue]);
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

    NSString *DomainStatueenumValue = transfromDic[@"Status"];
    if (DomainStatueenumValue && [DomainStatueenumValue isKindOfClass:[NSString class]] && DomainStatueenumValue.length > 0) {
        NSInteger value = QCloudDomainStatueDumpFromString(DomainStatueenumValue);
        transfromDic[@"Status"] = @(value);
    }
    NSString *COSDomainTypeenumValue = transfromDic[@"Type"];
    if (COSDomainTypeenumValue && [COSDomainTypeenumValue isKindOfClass:[NSString class]] && COSDomainTypeenumValue.length > 0) {
        NSInteger value = QCloudCOSDomainTypeDumpFromString(COSDomainTypeenumValue);
        transfromDic[@"Type"] = @(value);
    }
    NSString *COSDomainReplaceTypeenumValue = transfromDic[@"Replace"];
    if (COSDomainReplaceTypeenumValue && [COSDomainReplaceTypeenumValue isKindOfClass:[NSString class]] && COSDomainReplaceTypeenumValue.length > 0) {
        NSInteger value = QCloudCOSDomainReplaceTypeDumpFromString(COSDomainReplaceTypeenumValue);
        transfromDic[@"Replace"] = @(value);
    }
    return transfromDic;
}

@end

NS_ASSUME_NONNULL_END
