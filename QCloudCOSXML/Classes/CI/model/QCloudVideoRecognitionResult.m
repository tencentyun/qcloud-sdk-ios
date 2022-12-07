//
//  QCloudVideoRecognitionResult.m
//  QCloudCOSXML
//
//  Created by garenwang on 2021/10/26.
//

#import "QCloudVideoRecognitionResult.h"

@implementation QCloudVideoRecognitionResult
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"PornInfo" : [QCloudRecognitionItemInfo class],
        @"TerrorismInfo" : [QCloudRecognitionItemInfo class],
        @"PoliticsInfo" : [QCloudRecognitionItemInfo class],
        @"AdsInfo" : [QCloudRecognitionItemInfo class],
        @"Snapshot" : [QCloudVideoRecognitionSnapshot class],
        @"AudioSection" : [QCloudVideoRecognitionAudioSection class],
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
    if (section && section[@"Snapshot"] && [section[@"Snapshot"] isKindOfClass:[NSDictionary class]]) {
        [section setValue:@[section[@"Snapshot"]] forKey:@"Snapshot"];
    }
    
    if (section && section[@"AudioSection"] && [section[@"AudioSection"] isKindOfClass:[NSDictionary class]]) {
        [section setValue:@[section[@"AudioSection"]] forKey:@"AudioSection"];
    }
    
    return section.copy;
}

@end

@implementation QCloudVideoRecognitionSnapshot
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"PornInfo": [QCloudVideoRecognitionSnapshotItemInfo class],
        @"TerrorismInfo": [QCloudVideoRecognitionSnapshotItemInfo class],
        @"PoliticsInfo": [QCloudVideoRecognitionSnapshotItemInfo class],
        @"AdsInfo": [QCloudVideoRecognitionSnapshotItemInfo class],
    };
}

@end

@implementation QCloudVideoRecognitionSnapshotItemInfo
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"OcrResults": [QCloudRecognitionOcrResults class],
        @"ObjectResults": [QCloudRecognitionObjectResults class],
        @"LibResults": [QCloudRecognitionObjectLibResult class],
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

@implementation QCloudRecognitionObjectLibResult

@end

@implementation QCloudVideoRecognitionAudioSection
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"PornInfo": [QCloudRecognitionSectionItemInfo class],
        @"TerrorismInfo": [QCloudRecognitionSectionItemInfo class],
        @"PoliticsInfo": [QCloudRecognitionSectionItemInfo class],
        @"AdsInfo": [QCloudRecognitionSectionItemInfo class],
    };
}
@end

@implementation QCloudPostVideoRecognitionResult

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
