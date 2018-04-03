//
//  QCloudListAllMyBucketsResult+CustomModelTransfer.m
//  FLEX
//
//  Created by erichmzhang(张恒铭) on 03/04/2018.
//

#import "QCloudListAllMyBucketsResult+CustomModelTransfer.h"

@implementation QCloudListAllMyBucketsResult (CustomModelTransfer)
- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    
    if (!dic) {
        return dic;
    }
    NSMutableDictionary* transfromDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    NSArray* transformArrayKeypaths = @[
                                        @"Buckets",
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
            if ([object isKindOfClass:[NSDictionary class]]) {
                id value = [[object allValues] firstObject];
                if ([value isKindOfClass:[NSArray class]]) {
                    [transfromDic setValue:value forKey:keyPath];
                } else {
                [transfromDic setValue:@[value] forKey:keyPath];
                }
            }
//            [transfromDic setValue:@[object] forKeyPath:keyPath];
        }
    }
    
    return transfromDic;
    
}

@end
