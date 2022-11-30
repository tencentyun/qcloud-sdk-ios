//
//  QCloudListVersionsResult.m
//  QCloudListVersionsResult
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

#import "QCloudListVersionsResult.h"

#import "QCloudDeleteMarker.h"
#import "QCloudVersionContent.h"

NS_ASSUME_NONNULL_BEGIN
@implementation QCloudListVersionsResult

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"deleteMarker" : [QCloudDeleteMarker class],
        @"versionContent" : [QCloudVersionContent class],
        @"commonPrefixes" : [QCloudCommonPrefixes class]
    };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"name" : @"Name",
        @"prefix" : @"Prefix",
        @"keyMarker" : @"KeyMarker",
        @"versionIDMarkder" : @"VersionIdMarker",
        @"nextKeyMarker" : @"NextKeyMarker",
        @"nextVersionIDMarkder" : @"NextVersionIdMarker",
        @"commonPrefixes" : @"CommonPrefixes",
        @"isTruncated" : @"IsTruncated",
        @"deleteMarker" : @"DeleteMarker",
        @"versionContent" : @"Version",
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

    TransformBoolean(@"IsTruncated", @"True", @"False");

    return YES;
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    NSMutableDictionary *transfromDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    NSArray *transformArrayKeypaths = @[ @"DeleteMarker", @"Version", @"CommonPrefixes" ];

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
    TransformBoolean(@"IsTruncated", @"True", @"False");
    return transfromDic;
}

@end

NS_ASSUME_NONNULL_END
