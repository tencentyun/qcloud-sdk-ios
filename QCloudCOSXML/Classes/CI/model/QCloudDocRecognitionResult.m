//
//  QCloudDocRecognitionResult.m
//  QCloudCOSXML
//
//  Created by garenwang on 2021/10/26.
//

#import "QCloudDocRecognitionResult.h"

@implementation QCloudDocRecognitionResult
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Labels" : [QCloudRecognitionLabels class],
        @"PageSegment" : [QCloudDocRecognitionPageSegment class],
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

@implementation QCloudDocRecognitionPageSegment
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Results": [QCloudDocRecognitionPageSegmentItem class],
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

@implementation QCloudDocRecognitionPageSegmentItem
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"PornInfo": [QCloudDocRecognitionPageSegmentResultsInfo class],
        @"AdsInfo": [QCloudDocRecognitionPageSegmentResultsInfo class],
        @"TerrorismInfo": [QCloudDocRecognitionPageSegmentResultsInfo class],
        @"PoliticsInfo": [QCloudDocRecognitionPageSegmentResultsInfo class],
    };
}
@end

@implementation QCloudDocRecognitionPageSegmentResultsInfo
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

@implementation QCloudPostDocRecognitionResult

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
