//
//  QCloudCIOCRResult.m
//  QCloudCIOCRResult
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


#import "QCloudCIOCRResult.h"

NS_ASSUME_NONNULL_BEGIN
@implementation QCloudCIOCRItemPolygon

@end


@implementation QCloudCIOCRPolygon

@end


@implementation QCloudCIOCRWordPolygon

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"LeftTop" : [QCloudCIOCRPolygon class],
        @"RightTop" : [QCloudCIOCRPolygon class],
        @"RightBottom" : [QCloudCIOCRPolygon class],
        @"LeftBottom" : [QCloudCIOCRPolygon class],
    };
}

@end



@implementation QCloudCIOCRWordCoordPoint

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"WordCoordinate" : [QCloudCIOCRPolygon class],
    };
}

@end


@implementation QCloudCIOCRWords

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"WordCoordPoint" : [QCloudCIOCRWordCoordPoint class],
    };
}

@end

@implementation QCloudCIOCRTextDetections

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Polygon" : [QCloudCIOCRPolygon class],
        @"ItemPolygon" : [QCloudCIOCRItemPolygon class],
        @"Words" : [QCloudCIOCRWords class],
        @"WordPolygon" : [QCloudCIOCRWordPolygon class],
    };
}


- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    if (dic[@"Words"] && [dic[@"Words"] isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mdic setValue:@[dic[@"Words"]] forKey:@"Words"];
        dic = mdic.copy;
    }
    
    if (dic[@"Polygon"] && [dic[@"Polygon"] isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mdic setValue:@[dic[@"Polygon"]] forKey:@"Polygon"];
        dic = mdic.copy;
    }

    return dic;
}

@end

@implementation QCloudCIOCRResult

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"TextDetections" : [QCloudCIOCRTextDetections class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    if (dic[@"TextDetections"] && [dic[@"TextDetections"] isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mdic setValue:@[dic[@"TextDetections"]] forKey:@"TextDetections"];
        dic = mdic.copy;
    }

    return dic;
}


@end

NS_ASSUME_NONNULL_END
