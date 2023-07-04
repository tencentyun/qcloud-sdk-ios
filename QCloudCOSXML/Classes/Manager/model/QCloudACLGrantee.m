//
//  QCloudACLGrantee.m
//  QCloudACLGrantee
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

#import "QCloudACLGrantee.h"

NS_ASSUME_NONNULL_BEGIN
@implementation QCloudACLGrantee

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"subAccount" : @"Subaccount",
        @"identifier" : @"ID",
        @"displayName" : @"DisplayName",
//        @"type" : @"_type",
        @"xsiType" : @"_xsi:type",
        @"xmlns" : @"_xmlns:xsi",
        @"uri" : @"URI",
    };
}

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    NSNumber *type = dic[@"_type"];
//    if (type) {
//        NSString *value = QCloudCOSAccountTypeTransferToString([type intValue]);
//        if (value) {
//            dic[@"_type"] = value;
//        }
//    }
    
    NSNumber *xsitype = dic[@"_xsi:type"];
    if (xsitype) {
        NSString *value = QCloudCOSAccountXSITypeTransferToString([xsitype intValue]);
        if (value) {
            dic[@"_xsi:type"] = value;
        }
    }

    return YES;
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    NSMutableDictionary *transfromDic = [NSMutableDictionary dictionaryWithDictionary:dic];

//    NSString *type = transfromDic[@"_type"];
//    if (type && [type isKindOfClass:[NSString class]] && type.length > 0) {
//        NSInteger value = QCloudCOSAccountTypeDumpFromString(type);
//        transfromDic[@"_type"] = @(value);
//    }
    
    NSString *xsitype = transfromDic[@"_xsi:type"];
    if (xsitype && [xsitype isKindOfClass:[NSString class]] && xsitype.length > 0) {
        NSInteger value = QCloudCOSAccountXSITypeDumpFromString(xsitype);
        transfromDic[@"_xsi:type"] = @(value);
    }
    return transfromDic;
}

@end

NS_ASSUME_NONNULL_END
