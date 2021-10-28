//
//  QCloudMediaInfo.m
//  QCloudCOSXML
//
//  Created by garenwang on 2021/10/28.
//

#import "QCloudMediaInfo.h"

@implementation QCloudMediaInfo
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Stream": [QCloudMediaInfoStream class],
        @"Format": [QCloudMediaInfoFormat class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    NSMutableDictionary *transfromDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    return transfromDic[@"MediaInfo"];
}

@end

@implementation QCloudMediaInfoStream
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Video": [QCloudMediaInfoStreamVideo class],
        @"Audio": [QCloudMediaInfoStreamAudio class],
        @"Subtitle": [QCloudMediaInfoStreamSubtitle class],
    };
}
@end


@implementation QCloudMediaInfoFormat



@end


@implementation QCloudMediaInfoStreamVideo



@end

@implementation QCloudMediaInfoStreamAudio



@end

@implementation QCloudMediaInfoStreamSubtitle



@end
