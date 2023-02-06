//
//  QCloudBucketPolicyResult.m
//  QCloudCOSXML
//
//  Created by garenwang on 2023/2/4.
//

#import "QCloudBucketPolicyResult.h"

@implementation QCloudBucketPolicyResult
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Statement" : [QCloudBucketPolicyResultItem class],
    };
}
@end

@implementation QCloudBucketPolicyResultItem
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Principal" : [QCloudBucketPolicyResultItemPrincipal class],
    };
}
@end

@implementation QCloudBucketPolicyResultItemPrincipal

@end
