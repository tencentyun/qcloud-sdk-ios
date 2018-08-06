//
//  QCloudListMultipartUploadsResult.m
//  QCloudListMultipartUploadsResult
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


#import "QCloudListMultipartUploadsResult.h"

#import "QCloudListMultipartUploadContent.h"


NS_ASSUME_NONNULL_BEGIN
@implementation QCloudListMultipartUploadsResult

+ (NSDictionary *)modelContainerPropertyGenericClass
{
   return @ {
      @"uploads":[QCloudListMultipartUploadContent class],
  };
}


+ (NSDictionary *)modelCustomPropertyMapper
{
  return @{
      @"bucket" :@"Bucket",
      @"encodingType" :@"Encoding-Type",
      @"keyMarker" :@"KeyMarker",
      @"maxUploads" :@"MaxUploads",
      @"prefix" :@"Prefix",
      @"delimiter" :@"Delimiter",
      @"isTruncated" :@"IsTruncated",
      @"uploads" :@"Upload",
  };
}


- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic
{


    return YES;
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic
{
    if (!dic) {
        return dic;
    }
    NSMutableDictionary* transfromDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    NSArray* transformArrayKeypaths = @[
    @"Upload",
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


NS_ASSUME_NONNULL_END
