//
//  QCloudListPartsResult.m
//  QCloudListPartsResult
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


#import "QCloudListPartsResult.h"

#import "QCloudMultipartUploadInitiator.h"
#import "QCloudMultipartUploadOwner.h"
#import "QCloudMultipartUploadPart.h"


NS_ASSUME_NONNULL_BEGIN
@implementation QCloudListPartsResult

+ (NSDictionary *)modelContainerPropertyGenericClass
{
   return @ {
      @"parts":[QCloudMultipartUploadPart class],
  };
}


+ (NSDictionary *)modelCustomPropertyMapper
{
  return @{
      @"bucket" :@"Bucket",
      @"encodingType" :@"Encoding-type",
      @"key" :@"Key",
      @"uploadId" :@"UploadID",
      @"storageClass" :@"StorageClass",
      @"partNumberMarker" :@"PartNumberMarker",
      @"nextNumberMarker" :@"NextPartNumberMarker",
      @"maxParts" :@"MaxParts",
      @"isTruncated" :@"IsTruncated",
      @"initiator" :@"Initiator",
      @"owner" :@"Owner",
      @"parts" :@"Part",
  };
}


- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic
{

    NSNumber* COSStorageClassenumValue = dic[@"StorageClass"];
    if (COSStorageClassenumValue) {
        NSString* value = QCloudCOSStorageClassTransferToString([COSStorageClassenumValue intValue]);
        if (value) {
            dic[@"StorageClass"] = value;
        }
    }

    return YES;
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic
{
    if (!dic) {
        return dic;
    }
    NSMutableDictionary* transfromDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    NSArray* transformArrayKeypaths = @[
    @"Part",
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

        NSString* COSStorageClassenumValue = transfromDic[@"StorageClass"];
        if (COSStorageClassenumValue && [COSStorageClassenumValue isKindOfClass:[NSString class]] && COSStorageClassenumValue.length > 0) {
            int value = QCloudCOSStorageClassDumpFromString(COSStorageClassenumValue);
            transfromDic[@"StorageClass"] = @(value);
        }
    return transfromDic;
}

@end


NS_ASSUME_NONNULL_END
