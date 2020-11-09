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
    NSNumber *COSBucketAccelerateStatusenumValue = dic[@"Status"];
    if (COSBucketAccelerateStatusenumValue) {
        NSString *value = QCloudCOSBucketAccelerateStatusTransferToString([COSBucketAccelerateStatusenumValue intValue]);
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

    NSString *COSBucketAccelerateStatusenumValue = transfromDic[@"Status"];
    if (COSBucketAccelerateStatusenumValue && [COSBucketAccelerateStatusenumValue isKindOfClass:[NSString class]]
        && COSBucketAccelerateStatusenumValue.length > 0) {
        NSInteger value = QCloudCOSBucketAccelerateStatusDumpFromString(COSBucketAccelerateStatusenumValue);
        transfromDic[@"Status"] = @(value);
    }
    return transfromDic;
}

@end
