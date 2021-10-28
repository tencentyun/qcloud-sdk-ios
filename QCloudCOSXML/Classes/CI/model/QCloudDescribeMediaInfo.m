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
@end

@implementation QCloudDescribeMediaBucketItem

@end

