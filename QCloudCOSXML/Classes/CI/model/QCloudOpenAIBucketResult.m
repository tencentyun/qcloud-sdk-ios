//
//  QCloudOpenAIBucketResult.m
//  QCloudCOSXML
//
//  Created by garenwang on 2022/8/23.
//

#import "QCloudOpenAIBucketResult.h"

@implementation QCloudOpenAIBucketResult
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"AiBucket": [QCloudOpenAIBucketAiBucket class],
    };
}
@end

@implementation QCloudOpenAIBucketAiBucket

@end
