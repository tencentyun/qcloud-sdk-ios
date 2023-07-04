//
//
//  QCloudPostVideoTagResult.m
//
//  QCloudCOSXML
//
//
//
//  Created by garenwang on
//
//  2023-06-16 03:40:34 +0000.
//

#import "QCloudPostVideoTagResult.h"

@implementation QCloudPostVideoTagResult

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"JobsDetail" : [QCloudPostVideoTagResultJobsDetail class],
    };
}

@end

@implementation QCloudPostVideoTagResultJobsDetail

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Input" : [QCloudPostVideoTagResultInput class],
        @"Operation" : [QCloudPostVideoTagResultOperation class],
    };
}

@end

@implementation QCloudPostVideoTagResultInput

@end

@implementation QCloudPostVideoTagResultOperation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"VideoTag" : [QCloudPostVideoTagVideoTag class],
        @"VideoTagResult" : [QCloudPostVideoTagResultVideoTagResult class],
    };
}

@end

@implementation QCloudPostVideoTagResultVideoTagResult

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"StreamData" : [QCloudPostVideoTagResultStreamData class],
    };
}

@end

@implementation QCloudPostVideoTagResultStreamData

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Data" : [QCloudPostVideoTagResultData class],
    };
}

@end

@implementation QCloudPostVideoTagResultData

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Tags" : [QCloudPostVideoTagResultTags class],
        @"PersonTags" : [QCloudPostVideoTagResultPersonTags class],
        @"PlaceTags" : [QCloudPostVideoTagResultPlaceTags class],
        @"ActionTags" : [QCloudPostVideoTagResultActionTags class],
        @"ObjectTags" : [QCloudPostVideoTagResultObjectTags class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {

    if (!dic) {return dic;}

    if (![dic isKindOfClass:[NSDictionary class]]) {return nil;}

    if (dic[@"PersonTags"] && [dic[@"PersonTags"] isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mdic setValue:@[dic[@"PersonTags"]] forKey:@"PersonTags"];
        dic = mdic.copy;
    }
    if (dic[@"PlaceTags"] && [dic[@"PlaceTags"] isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mdic setValue:@[dic[@"PlaceTags"]] forKey:@"PlaceTags"];
        dic = mdic.copy;
    }
    if (dic[@"ActionTags"] && [dic[@"ActionTags"] isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mdic setValue:@[dic[@"ActionTags"]] forKey:@"ActionTags"];
        dic = mdic.copy;
    }
    if (dic[@"ObjectTags"] && [dic[@"ObjectTags"] isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mdic setValue:@[dic[@"ObjectTags"]] forKey:@"ObjectTags"];
        dic = mdic.copy;
    }
    return dic;
}

@end

@implementation QCloudPostVideoTagResultTags

@end

@implementation QCloudPostVideoTagResultPlaceTags

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Tags" : [QCloudPostVideoTagResultTags class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {

    if (!dic) {return dic;}

    if (![dic isKindOfClass:[NSDictionary class]]) {return nil;}

    if (dic[@"Tags"] && [dic[@"Tags"] isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mdic setValue:@[dic[@"Tags"]] forKey:@"Tags"];
        dic = mdic.copy;
    }
    return dic;
}

@end

@implementation QCloudPostVideoTagResultPersonTags

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"DetailPerSecond" : [QCloudPostVideoTagResultDetailPerSecond class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {

    if (!dic) {return dic;}

    if (![dic isKindOfClass:[NSDictionary class]]) {return nil;}

    if (dic[@"DetailPerSecond"] && [dic[@"DetailPerSecond"] isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mdic setValue:@[dic[@"DetailPerSecond"]] forKey:@"DetailPerSecond"];
        dic = mdic.copy;
    }
    return dic;
}

@end

@implementation QCloudPostVideoTagResultActionTags

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Tags" : [QCloudPostVideoTagResultTags class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {

    if (!dic) {return dic;}

    if (![dic isKindOfClass:[NSDictionary class]]) {return nil;}

    if (dic[@"Tags"] && [dic[@"Tags"] isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mdic setValue:@[dic[@"Tags"]] forKey:@"Tags"];
        dic = mdic.copy;
    }
    return dic;
}

@end

@implementation QCloudPostVideoTagResultObjectTags

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Objects" : [QCloudPostVideoTagResultObjects class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {

    if (!dic) {return dic;}

    if (![dic isKindOfClass:[NSDictionary class]]) {return nil;}

    if (dic[@"Objects"] && [dic[@"Objects"] isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mdic setValue:@[dic[@"Objects"]] forKey:@"Objects"];
        dic = mdic.copy;
    }
    return dic;
}

@end

@implementation QCloudPostVideoTagResultObjects

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"BBox" : [QCloudPostVideoTagResultBBox class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {

    if (!dic) {return dic;}

    if (![dic isKindOfClass:[NSDictionary class]]) {return nil;}

    if (dic[@"BBox"] && [dic[@"BBox"] isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mdic setValue:@[dic[@"BBox"]] forKey:@"BBox"];
        dic = mdic.copy;
    }

    return dic;
}

@end

@implementation QCloudPostVideoTagResultDetailPerSecond

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"BBox" : [QCloudPostVideoTagResultBBox class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {

    if (!dic) {return dic;}

    if (![dic isKindOfClass:[NSDictionary class]]) {return nil;}

    if (dic[@"BBox"] && [dic[@"BBox"] isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mdic setValue:@[dic[@"BBox"]] forKey:@"BBox"];
        dic = mdic.copy;
    }
    return dic;
}

@end

@implementation QCloudPostVideoTagResultBBox

@end

@implementation QCloudPostVideoTag

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Input" : [QCloudPostVideoTagInput class],
        @"Operation" : [QCloudPostVideoTagOperation class],
        @"CallBackMqConfig" : [QCloudCallBackMqConfig class],
    };
}

@end

@implementation QCloudPostVideoTagInput

@end

@implementation QCloudPostVideoTagOperation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"VideoTag" : [QCloudPostVideoTagVideoTag class],
    };
}

@end

@implementation QCloudPostVideoTagVideoTag

@end

