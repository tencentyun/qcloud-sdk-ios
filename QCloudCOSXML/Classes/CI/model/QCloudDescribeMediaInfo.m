//
//  QCloudDescribeMediaInfo.m
//  QCloudCOSXML
//
//  Created by garenwang on 2021/10/28.
//

#import "QCloudDescribeMediaInfo.h"

@implementation QCloudDescribeMediaInfo
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"MediaBucketList": [QCloudDescribeMediaBucketItem class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    
    NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    if ([mdic[@"MediaBucketList"] isKindOfClass:[NSDictionary class]]) {
        [mdic setValue:@[mdic[@"MediaBucketList"]] forKey:@"MediaBucketList"];
    }

    return mdic.mutableCopy;
}

@end

@implementation QCloudDescribeMediaBucketItem

@end

