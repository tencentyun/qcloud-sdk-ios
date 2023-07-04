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
        @"UserInfo":[QCloudBatchRecognitionUserInfo class],
        @"ListInfo":[QCloudBatchRecognitionListInfo class]
    };
}

@end

@implementation QCloudBatchImageRecognitionResultInfo
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"OcrResults" : [QCloudRecognitionOcrResults class],
        @"ObjectResults": [QCloudRecognitionObjectResults class],
        @"LibResults":QCloudImageRecognitionLibResults.class
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
    
    if ([mdic[@"LibResults"] isKindOfClass:[NSDictionary class]]) {
        [mdic setValue:@[mdic[@"LibResults"]] forKey:@"LibResults"];
    }
    
    return mdic.mutableCopy;
}

@end


@implementation QCloudBatchRecognitionImageInfo
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"UserInfo" : [QCloudBatchRecognitionUserInfo class],
        @"Encryption" : [QCloudBatchRecognitionEncryption class]
    };
}
@end



@implementation QCloudBatchRecognitionListInfo

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"ListResults" : [QCloudBatchRecognitionListInfoListResults class]
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    
    NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    if ([mdic[@"ListResults"] isKindOfClass:[NSDictionary class]]) {
        [mdic setValue:@[mdic[@"ListResults"]] forKey:@"ListResults"];
    }
    
    return mdic.mutableCopy;
}


@end

@implementation QCloudBatchRecognitionListInfoListResults


@end
