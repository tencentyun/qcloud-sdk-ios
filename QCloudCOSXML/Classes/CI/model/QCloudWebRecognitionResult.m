//
//  QCloudWebRecognitionResult.m
//  QCloudCOSXML
//
//  Created by garenwang on 2021/10/26.
//

#import "QCloudWebRecognitionResult.h"


@implementation QCloudWebRecognitionResult
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Labels" : [QCloudRecognitionLabels class],
        @"ImageResults" : [QCloudWebRecognitionImageResults class],
        @"TextResults" : [QCloudWebRecognitionTextResults class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return dic[@"JobsDetail"];
}
@end

@implementation QCloudWebRecognitionImageResults
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Results": [QCloudWebRecognitionImageResultsItem class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    if ([dic[@"Results"] isKindOfClass:[NSArray class]]) {
        return dic;
    }else if ([dic[@"Results"] isKindOfClass:[NSDictionary class]]) {
        return @{@"Results" : @[dic[@"Results"]]};
    }else{
        return nil;
    }
}

@end

@implementation QCloudWebRecognitionImageResultsItem
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"PornInfo": [QCloudWebRecognitionImageResultsItemInfo class],
        @"AdsInfo": [QCloudWebRecognitionImageResultsItemInfo class],
        @"TerrorismInfo": [QCloudWebRecognitionImageResultsItemInfo class],
        @"PoliticsInfo": [QCloudWebRecognitionImageResultsItemInfo class],
    };
}
@end

@implementation QCloudWebRecognitionImageResultsItemInfo
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


@implementation QCloudWebRecognitionTextResults
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Results": [QCloudWebRecognitionTextResultsItem class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    if ([dic[@"Results"] isKindOfClass:[NSArray class]]) {
        return dic;
    }else if ([dic[@"Results"] isKindOfClass:[NSDictionary class]]) {
        return @{@"Results" : @[dic[@"Results"]]};
    }else{
        return nil;
    }
}

@end

@implementation QCloudWebRecognitionTextResultsItem
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"PornInfo": [QCloudRecognitionResultsItemInfo class],
        @"TerrorismInfo": [QCloudRecognitionResultsItemInfo class],
        @"PoliticsInfo": [QCloudRecognitionResultsItemInfo class],
        @"AdsInfo": [QCloudRecognitionResultsItemInfo class],
    };
}
@end

@implementation QCloudPostWebRecognitionResult

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    return dic[@"JobsDetail"];
}
@end
