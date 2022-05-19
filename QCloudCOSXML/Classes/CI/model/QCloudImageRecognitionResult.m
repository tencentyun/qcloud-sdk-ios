//
//  QCloudImageRecognitionResult.m
//  QCloudCOSXML
//
//  Created by garenwang on 2022/3/21.
//

#import "QCloudImageRecognitionResult.h"

@implementation QCloudImageRecognitionResult
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"PornInfo" : [QCloudImageRecognitionResultInfo class],
        @"AdsInfo" : [QCloudImageRecognitionResultInfo class],
        @"TerrorismInfo" : [QCloudImageRecognitionResultInfo class],
        @"PoliticsInfo" : [QCloudImageRecognitionResultInfo class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    if (dic[@"JobsDetail"]) {
        return dic[@"JobsDetail"];
    }
    return dic;
}

@end

@implementation QCloudImageRecognitionResultInfo
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"OcrResults": [QCloudRecognitionOcrResults class],
        @"ObjectResults": [QCloudRecognitionObjectResults class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    
    NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    if ([mdic[@"OcrResults"] isKindOfClass:[NSDictionary class]]) {
        [mdic setValue:@[mdic[@"OcrResults"]] forKey:@"OcrResults"];
    }
    
    if ([mdic[@"ObjectResults"] isKindOfClass:[NSDictionary class]]) {
        [mdic setValue:@[mdic[@"ObjectResults"]] forKey:@"ObjectResults"];
    }
    
    return mdic.mutableCopy;
}

@end


