//
//  QCloudBatchImageRecognitionResult.m
//  QCloudCOSXML
//
//  Created by garenwang on 2022/3/22.
//

#import "QCloudBatchImageRecognitionResult.h"

@implementation QCloudBatchImageRecognitionResult
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"JobsDetail" : [QCloudBatchImageRecognitionResultItem class],
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
    if ([transfromDic[@"JobsDetail"] isKindOfClass:[NSArray class]]) {
        return dic;
    }
    if (transfromDic[@"JobsDetail"]) {
        NSObject * obj = transfromDic[@"JobsDetail"];
        transfromDic[@"JobsDetail"] = @[obj];
        return transfromDic;
    }
    return dic;
}

@end

@implementation QCloudBatchImageRecognitionResultItem
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"AdsInfo" : [QCloudBatchImageRecognitionResultInfo class],
        @"PornInfo" : [QCloudBatchImageRecognitionResultInfo class],
        @"TerrorismInfo" : [QCloudBatchImageRecognitionResultInfo class],
        @"PoliticsInfo" : [QCloudBatchImageRecognitionResultInfo class],
    };
}

@end

@implementation QCloudBatchImageRecognitionResultInfo
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"OcrResults" : [QCloudRecognitionOcrResults class],
        @"ObjectResults": [QCloudRecognitionObjectResults class]
    };
}

@end


@implementation QCloudBatchRecognitionImageInfo

@end
