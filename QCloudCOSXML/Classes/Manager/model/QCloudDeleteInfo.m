//
//  QCloudDeleteInfo.m
//  QCloudDeleteInfo
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

#import "QCloudDeleteInfo.h"

#import "QCloudDeleteObjectInfo.h"

NS_ASSUME_NONNULL_BEGIN
@implementation QCloudDeleteInfo

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"objects" : [QCloudDeleteObjectInfo class],
    };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"quiet" : @"Quiet",
        @"objects" : @"Object",
    };
}

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    void (^TransformBoolean)(NSString *originKey, NSString *trueStr, NSString *falseStr)
        = ^(NSString *originKey, NSString *trueStr, NSString *falseStr) {
              id value = [dic objectForKey:originKey];
              if (!value) {
                  return;
              }
              if ([value boolValue]) {
                  [dic setObject:trueStr forKey:originKey];
              } else {
                  [dic setObject:falseStr forKey:originKey];
              }
          };

    TransformBoolean(@"Quiet", @"True", @"False");

    return YES;
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    NSMutableDictionary *transfromDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    NSArray *transformArrayKeypaths = @[
        @"Object",
    ];

    for (NSString *keyPath in transformArrayKeypaths) {
        id object = [dic valueForKeyPath:keyPath];
        if (!object) {
            continue;
        }
        if ([object isKindOfClass:[NSNull class]]) {
            continue;
        }
        if (![object isKindOfClass:[NSArray class]]) {
            [transfromDic setValue:@[ object ] forKeyPath:keyPath];
        }
    }

    void (^TransformBoolean)(NSString *originKey, NSString *trueStr, NSString *falseStr)
        = ^(NSString *originKey, NSString *trueStr, NSString *falseStr) {
              id value = [dic objectForKey:originKey];
              if (!value) {
                  return;
              }
              if ([value isKindOfClass:[NSString class]]) {
                  NSString *boolean = (NSString *)value;
                  if ([value isEqualToString:trueStr]) {
                      [transfromDic setValue:@(YES) forKey:originKey];
                  } else if ([boolean isEqualToString:falseStr]) {
                      [transfromDic setValue:@(NO) forKey:originKey];
                  }
              }
          };
    TransformBoolean(@"Quiet", @"True", @"False");
    return transfromDic;
}

@end

NS_ASSUME_NONNULL_END
