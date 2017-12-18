//
//  QCloudACLPolicy.m
//  QCloudACLPolicy
//
//  Created by tencent
//  Copyright (c) 2015年 tencent. All rights reserved.
//
//   ██████╗  ██████╗██╗      ██████╗ ██╗   ██╗██████╗     ████████╗███████╗██████╗ ███╗   ███╗██╗███╗   ██╗ █████╗ ██╗         ██╗      █████╗ ██████╗
//  ██╔═══██╗██╔════╝██║     ██╔═══██╗██║   ██║██╔══██╗    ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║████╗  ██║██╔══██╗██║         ██║     ██╔══██╗██╔══██╗
//  ██║   ██║██║     ██║     ██║   ██║██║   ██║██║  ██║       ██║   █████╗  ██████╔╝██╔████╔██║██║██╔██╗ ██║███████║██║         ██║     ███████║██████╔╝
//  ██║▄▄ ██║██║     ██║     ██║   ██║██║   ██║██║  ██║       ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║██║╚██╗██║██╔══██║██║         ██║     ██╔══██║██╔══██╗
//  ╚██████╔╝╚██████╗███████╗╚██████╔╝╚██████╔╝██████╔╝       ██║   ███████╗██║  ██║██║ ╚═╝ ██║██║██║ ╚████║██║  ██║███████╗    ███████╗██║  ██║██████╔╝
//   ╚══▀▀═╝  ╚═════╝╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝        ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝    ╚══════╝╚═╝  ╚═╝╚═════╝
//
//
//                                                                              _             __                 _                _
//                                                                             (_)           / _|               | |              | |
//                                                          ___  ___ _ ____   ___  ___ ___  | |_ ___  _ __    __| | _____   _____| | ___  _ __   ___ _ __ ___
//                                                         / __|/ _ \ '__\ \ / / |/ __/ _ \ |  _/ _ \| '__|  / _` |/ _ \ \ / / _ \ |/ _ \| '_ \ / _ \ '__/ __|
//                                                         \__ \  __/ |   \ V /| | (_|  __/ | || (_) | |    | (_| |  __/\ V /  __/ | (_) | |_) |  __/ |  \__
//                                                         |___/\___|_|    \_/ |_|\___\___| |_| \___/|_|     \__,_|\___| \_/ \___|_|\___/| .__/ \___|_|  |___/
//    ______ ______ ______ ______ ______ ______ ______ ______                                                                            | |
//   |______|______|______|______|______|______|______|______|                                                                           |_|
//


#import "QCloudACLPolicy.h"

#import "QCloudACLOwner.h"
#import "QCloudACLGrant.h"

@class QCloudACLGrant;

NS_ASSUME_NONNULL_BEGIN
@implementation QCloudACLPolicy

+ (NSDictionary *)modelContainerPropertyGenericClass
{
   return @ {
      @"accessControlList":[QCloudACLGrant class],
  };
}


+ (NSDictionary *)modelCustomPropertyMapper
{
  return @{
      @"owner" :@"Owner",
      @"accessControlList" :@"AccessControlList",
  };
}


- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic
{
void(^TransformDictionary)(NSString* originKey, NSString* aimKey) = ^(NSString* originKey, NSString* aimKey) {
    id object = [dic objectForKey:originKey];
    if (!object) {
        return;
    }
    if ([object isKindOfClass:[NSNull class]]) {
        return;
    }
    if ([object isKindOfClass:[NSArray class]]) {
        NSArray* objects = (NSArray*)object;
        [dic removeObjectForKey:originKey];
        NSMutableDictionary* transferDic = [@{aimKey:objects} mutableCopy];
        [dic setObject:transferDic forKey:originKey];
    }
};
    TransformDictionary(@"AccessControlList", @"Grant");


    return YES;
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic
{
    if (!dic) {
        return dic;
    }
    NSMutableDictionary* transfromDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    NSArray* transformArrayKeypaths = @[
    @"AccessControlList",
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
          if ([object isKindOfClass:[NSDictionary class]] && [(NSDictionary*)object count] == 1) {
            id value = [[object allValues] firstObject];
            if ([value isKindOfClass:[NSArray class]]) {
                [transfromDic setValue:value forKey:keyPath];
            } else {
                [transfromDic setValue:@[value] forKey:keyPath];
            }
          } else {
              [transfromDic setValue:@[object] forKeyPath:keyPath];
          }
        }
    }

    return transfromDic;
}

@end


NS_ASSUME_NONNULL_END
