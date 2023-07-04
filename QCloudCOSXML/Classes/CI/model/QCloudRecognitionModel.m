//
//  QCloudRecognitionModel.m
//  QCloudCOSXML
//
//  Created by garenwang on 2022/3/22.
//

#import "QCloudRecognitionModel.h"

@implementation QCloudRecognitionOcrResults
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Location" : [QCloudRecognitionLocationInfo class]
    };
}

@end

@implementation QCloudRecognitionObjectResults
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Location" : [QCloudRecognitionLocationInfo class]
    };
}

@end

@implementation QCloudRecognitionResultsItemInfo
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"LibResults": [QCloudRecognitionSectionItemLibResults class],
        @"SpeakerResults": [QCloudRecognitionResultsItem class],
        @"RecognitionResults": [QCloudRecognitionResultsItem class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    NSMutableDictionary * mdic = dic.mutableCopy;
    if ([mdic[@"LibResults"] isKindOfClass:[NSDictionary class]]) {
        [mdic setValue:@[mdic[@"LibResults"]] forKey:@"LibResults"];
    }
    if ([mdic[@"SpeakerResults"] isKindOfClass:[NSDictionary class]]) {
        [mdic setValue:@[mdic[@"SpeakerResults"]] forKey:@"SpeakerResults"];
    }
    if ([mdic[@"RecognitionResults"] isKindOfClass:[NSDictionary class]]) {
        [mdic setValue:@[mdic[@"RecognitionResults"]] forKey:@"RecognitionResults"];
    }
    
    return mdic.mutableCopy;
}

@end

@implementation QCloudRecognitionLabels
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"PornInfo": [QCloudRecognitionLabels class],
        @"AdsInfo": [QCloudRecognitionLabels class],
        @"TerrorismInfo": [QCloudRecognitionLabels class],
        @"PoliticsInfo": [QCloudRecognitionLabels class],
        @"LibResults": [QCloudRecognitionSectionItemLibResults class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    NSMutableDictionary * mdic = dic.mutableCopy;
    if ([mdic[@"LibResults"] isKindOfClass:[NSDictionary class]]) {
        [mdic setValue:@[mdic[@"LibResults"]] forKey:@"LibResults"];
    }
    
    return mdic.mutableCopy;
}
@end

@implementation QCloudRecognitionLocationInfo

@end

@implementation QCloudRecognitionSectionItemInfo
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"LibResults": [QCloudRecognitionSectionItemLibResults class],
    };
}
- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    NSMutableDictionary * mdic = dic.mutableCopy;
    if ([mdic[@"LibResults"] isKindOfClass:[NSDictionary class]]) {
        [mdic setValue:@[mdic[@"LibResults"]] forKey:@"LibResults"];
    }
    
    return mdic.mutableCopy;
}
@end

@implementation QCloudRecognitionSectionItemLibResults

@end

@implementation QCloudRecognitionLabelsItem

@end

@implementation QCloudRecognitionItemInfo

@end

@implementation QCloudRecognitionResultsItem

@end


@implementation QCloudBatchRecognitionEncryption

@end
