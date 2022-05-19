//
//  QCloudVideoRecognitionResult.m
//  QCloudCOSXML
//
//  Created by garenwang on 2021/10/26.
//

#import "QCloudTextRecognitionResult.h"

@implementation QCloudTextRecognitionResult
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"PornInfo" : [QCloudRecognitionItemInfo class],
        @"AbuseInfo" : [QCloudRecognitionItemInfo class],
        @"TerrorismInfo" : [QCloudRecognitionItemInfo class],
        @"PoliticsInfo" : [QCloudRecognitionItemInfo class],
        @"IllegalInfo" : [QCloudRecognitionItemInfo class],
        @"AdsInfo" : [QCloudRecognitionItemInfo class],
        @"Section" : [QCloudTextRecognitionSection class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    NSMutableDictionary * section = [NSMutableDictionary dictionaryWithDictionary:dic[@"JobsDetail"]];
    if (section && section[@"Section"] && [section[@"Section"] isKindOfClass:[NSDictionary class]]) {
        [section setValue:@[section[@"Section"]] forKey:@"Section"];
    }
    
    return section.copy;
}

@end

@implementation QCloudTextRecognitionSection
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"PornInfo": [QCloudRecognitionResultsItemInfo class],
        @"TerrorismInfo": [QCloudRecognitionResultsItemInfo class],
        @"PoliticsInfo": [QCloudRecognitionResultsItemInfo class],
        @"AdsInfo": [QCloudRecognitionResultsItemInfo class],
        @"IllegalInfo": [QCloudRecognitionResultsItemInfo class],
        @"AbuseInfo": [QCloudRecognitionResultsItemInfo class],
    };
}
@end

@implementation QCloudPostTextRecognitionResult

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"PornInfo" : [QCloudRecognitionItemInfo class],
        @"AbuseInfo" : [QCloudRecognitionItemInfo class],
        @"IllegalInfo" : [QCloudRecognitionItemInfo class],
        @"AdsInfo" : [QCloudRecognitionItemInfo class],
        @"TerrorismInfo" : [QCloudRecognitionItemInfo class],
        @"PoliticsInfo" : [QCloudRecognitionItemInfo class],
        @"Section" : [QCloudTextRecognitionSection class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    NSMutableDictionary * section = [NSMutableDictionary dictionaryWithDictionary:dic[@"JobsDetail"]];
    if (section && section[@"Section"] && [section[@"Section"] isKindOfClass:[NSDictionary class]]) {
        [section setValue:@[section[@"Section"]] forKey:@"Section"];
    }
    
    return section.copy;
}

@end
