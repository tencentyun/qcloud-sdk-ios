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
        @"PornInfo" : [QCloudVideoRecognitionItemInfo class],
        @"TerrorismInfo" : [QCloudVideoRecognitionItemInfo class],
        @"PoliticsInfo" : [QCloudVideoRecognitionItemInfo class],
        @"AdsInfo" : [QCloudVideoRecognitionItemInfo class],
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
    
    NSMutableDictionary *transfromDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    return transfromDic[@"JobsDetail"];
}

@end

@implementation QCloudVideoRecognitionItemInfo

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

@end

@implementation QCloudVideoRecognitionAudioSection
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"PornInfo": [QCloudVideoRecognitionAudioSectionItemInfo class],
        @"TerrorismInfo": [QCloudVideoRecognitionAudioSectionItemInfo class],
        @"PoliticsInfo": [QCloudVideoRecognitionAudioSectionItemInfo class],
        @"AdsInfo": [QCloudVideoRecognitionAudioSectionItemInfo class],
    };
}
@end

@implementation QCloudVideoRecognitionAudioSectionItemInfo

@end

@implementation QCloudPostVideoRecognitionResult

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    NSMutableDictionary *transfromDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    return transfromDic[@"JobsDetail"];
}

@end
