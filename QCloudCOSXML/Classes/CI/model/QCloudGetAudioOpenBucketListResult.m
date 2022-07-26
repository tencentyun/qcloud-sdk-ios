//
//  QCloudGetAudioOpenBucketListResult.m
//  QCloudCOSXML
//
//  Created by garenwang on 2022/7/25.
//

#import "QCloudGetAudioOpenBucketListResult.h"

@implementation QCloudGetAudioOpenBucketListResult

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"AsrBucketList": [QCloudGetAudioOpenAsrBucketList class]
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    
    NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    if ([mdic[@"AsrBucketList"] isKindOfClass:[NSDictionary class]]) {
        [mdic setValue:@[mdic[@"AsrBucketList"]] forKey:@"AsrBucketList"];
    }
    
    return mdic.mutableCopy;
}
@end

@implementation QCloudGetAudioOpenAsrBucketList

@end



