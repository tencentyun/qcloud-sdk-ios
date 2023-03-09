//
//  QCloudBucketAccelerateConfiguration.m
//  QCloudCOSXML
//
//  Created by karisli(李雪) on 2020/8/28.
//

#import "QCloudBucketAccelerateConfiguration.h"

@implementation QCloudBucketAccelerateConfiguration

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"status" : @"Status",
    };
}

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    NSNumber *status = dic[@"Status"];
    if (status) {
        NSString *value = QCloudCOSBucketAccelerateStatusTransferToString([status intValue]);
        if (value) {
            dic[@"Status"] = value;
        }
    }

    return YES;
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    NSMutableDictionary *transfromDic = [NSMutableDictionary dictionaryWithDictionary:dic];

    NSString *status = transfromDic[@"Status"];
    if (status && [status isKindOfClass:[NSString class]]
        && status.length > 0) {
        NSInteger value = QCloudCOSBucketAccelerateStatusDumpFromString(status);
        transfromDic[@"Status"] = @(value);
    }
    return transfromDic;
}

@end
