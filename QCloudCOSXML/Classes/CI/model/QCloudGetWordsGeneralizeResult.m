//
//  QCloudGetWordsGeneralizeResult.m
//  QCloudCOSXML
//
//  Created by garenwang on 2022/8/24.
//

#import "QCloudGetWordsGeneralizeResult.h"

@implementation QCloudGetWordsGeneralizeResult
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Input" : [QCloudGetWordsGeneralizeInputObject class],
        @"Operation" : [QCloudGetWordsGeneralizeResultOperation class],
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


@implementation QCloudGetWordsGeneralizeInputObject

@end

@implementation QCloudGetWordsGeneralizeResultOperation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Translation" : [QCloudGetWordsGeneralizeTranslation class],
        @"Output" : [QCloudGetWordsGeneralizeOutput class],
    };
}

@end

@implementation QCloudGetWordsGeneralizeTranslation

@end

@implementation QCloudGetWordsGeneralizeOutput

@end

