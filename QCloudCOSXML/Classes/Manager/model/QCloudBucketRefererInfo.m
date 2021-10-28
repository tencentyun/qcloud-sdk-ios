//
//  QCloudBucketRefererInfo.m
//  QCloudCOSXML
//
//  Created by garenwang on 2021/10/26.
//

#import "QCloudBucketRefererInfo.h"

@implementation QCloudBucketRefererInfo

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    NSMutableDictionary *transfromDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    NSArray *transformArrayKeypaths = @[
        @"DomainList.Domain",
    ];

    for (NSString *keyPath in transformArrayKeypaths) {
        id object = [dic valueForKeyPath:keyPath];
        if (!object) {
            continue;
        }
        if ([object isKindOfClass:[NSNull class]]) {
            continue;
        }
        if ([object isKindOfClass:[NSArray class]]) {
            [transfromDic setValue:object forKeyPath:@"DomainList"];
        }
    }

    return transfromDic;
}

@end
