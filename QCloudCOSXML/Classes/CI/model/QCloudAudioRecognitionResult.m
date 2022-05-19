//
//  QCloudAudioRecognitionResult.m
//  QCloudCOSXML
//
//  Created by garenwang on 2021/10/26.
//

#import "QCloudAudioRecognitionResult.h"

@implementation QCloudAudioRecognitionResult
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"PornInfo" : [QCloudAudioRecognitionItemInfo class],
        @"AdsInfo" : [QCloudAudioRecognitionItemInfo class],
        @"PoliticsInfo" : [QCloudAudioRecognitionItemInfo class],
        @"TerrorismInfo" : [QCloudAudioRecognitionItemInfo class],
        @"Section" : [QCloudAudioRecognitionSection class],
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

@implementation QCloudAudioRecognitionItemInfo

@end

@implementation QCloudAudioRecognitionSection
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"PornInfo": [QCloudRecognitionResultsItemInfo class],
        @"AdsInfo": [QCloudRecognitionResultsItemInfo class],
        @"TerrorismInfo": [QCloudRecognitionResultsItemInfo class],
        @"PoliticsInfo": [QCloudRecognitionResultsItemInfo class],
    };
}

@end


@implementation QCloudPostAudioRecognitionResult

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
