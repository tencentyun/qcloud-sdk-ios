//
//  QCloudWordsGeneralizeResult.m
//  QCloudCOSXML
//
//  Created by garenwang on 2022/8/24.
//

#import "QCloudWordsGeneralizeResult.h"

@implementation QCloudWordsGeneralizeResult
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Input" : [QCloudWordsGeneralizeResultObject class],
        @"Operation" : [QCloudWordsGeneralizeResultOperation class],
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

@implementation QCloudWordsGeneralizeResultObject


@end

@implementation QCloudWordsGeneralizeResultOperation
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"WordsGeneralize" : [QCloudWordsGeneralizeInputGeneralize class],
        @"WordsGeneralizeResult" : [QCloudWordsGeneralizeResultGeneralize class],
    };
}
@end

@implementation QCloudWordsGeneralizeResultGeneralize

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"WordsGeneralizeLable" : [QCloudWordsGeneralizeResultLable class],
        @"WordsGeneralizeToken" : [QCloudWordsGeneralizeResultToken class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    
    NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    if ([mdic[@"WordsGeneralizeLable"] isKindOfClass:[NSDictionary class]]) {
        [mdic setValue:@[mdic[@"WordsGeneralizeLable"]] forKey:@"WordsGeneralizeLable"];
    }
    
    if ([mdic[@"WordsGeneralizeToken"] isKindOfClass:[NSDictionary class]]) {
        [mdic setValue:@[mdic[@"WordsGeneralizeToken"]] forKey:@"WordsGeneralizeToken"];
    }
    
    return mdic.mutableCopy;
}

@end

@implementation QCloudWordsGeneralizeResultLable

@end

@implementation QCloudWordsGeneralizeResultToken

@end
