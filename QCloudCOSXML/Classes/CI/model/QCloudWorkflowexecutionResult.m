//
//
//  QCloudWorkflowexecutionResult.m
//
//  QCloudCOSXML
//
//
//
//  Created by garenwang on
//
//  2023-06-16 07:01:36 +0000.
//

#import "QCloudWorkflowexecutionResult.h"

@implementation QCloudWorkflowexecutionResult

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"WorkflowExecution" : [QCloudWorkflowexecutionResultWE class],
    };
}

@end

@implementation QCloudWorkflowexecutionResultWE

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Topology" : [QCloudWorkflowExecutionTopology class],
        @"Tasks" : [QCloudWorkflowexecutionResultTasks class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {

    if (!dic) {return dic;}

    if (![dic isKindOfClass:[NSDictionary class]]) {return nil;}

    if (dic[@"Tasks"] && [dic[@"Tasks"] isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mdic setValue:@[dic[@"Tasks"]] forKey:@"Tasks"];
        dic = mdic.copy;
    }
    return dic;
}

@end

@implementation QCloudWorkflowexecutionResultTasks

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"ResultInfo" : [QCloudWorkflowResultInfo class],
        @"JudgementInfo" : [QCloudWorkflowJudgementInfo class],
        @"FileInfo" : [QCloudWorkflowFileInfo class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {

    if (!dic) {return dic;}

    if (![dic isKindOfClass:[NSDictionary class]]) {return nil;}

    if (dic[@"FileInfo"] && [dic[@"FileInfo"] isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mdic setValue:@[dic[@"FileInfo"]] forKey:@"FileInfo"];
        dic = mdic.copy;
    }
    return dic;
}

@end

@implementation QCloudWorkflowFileInfo

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"BasicInfo" : [QCloudWorkflowBasicInfo class],
        @"MediaInfo" : [QCloudWorkflowMediaInfo class],
        @"ImageInfo" : [QCloudWorkflowImageInfo class],
    };
}

@end

@implementation QCloudWorkflowResultInfo

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"ObjectInfo" : [QCloudWorkflowObjectInfo class],
        @"SpriteObjectInfo" : [QCloudWorkflowSpriteObjectInfo class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {

    if (!dic) {return dic;}

    if (![dic isKindOfClass:[NSDictionary class]]) {return nil;}

    if (dic[@"ObjectInfo"] && [dic[@"ObjectInfo"] isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mdic setValue:@[dic[@"ObjectInfo"]] forKey:@"ObjectInfo"];
        dic = mdic.copy;
    }
    if (dic[@"SpriteObjectInfo"] && [dic[@"SpriteObjectInfo"] isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mdic setValue:@[dic[@"SpriteObjectInfo"]] forKey:@"SpriteObjectInfo"];
        dic = mdic.copy;
    }
    return dic;
}

@end

@implementation QCloudWorkflowJudgementInfo

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"JudgementResult" : [QCloudWorkflowJudgementResult class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {

    if (!dic) {return dic;}

    if (![dic isKindOfClass:[NSDictionary class]]) {return nil;}

    if (dic[@"JudgementResult"] && [dic[@"JudgementResult"] isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mdic setValue:@[dic[@"JudgementResult"]] forKey:@"JudgementResult"];
        dic = mdic.copy;
    }
    return dic;
}

@end

@implementation QCloudWorkflowBasicInfo

@end

@implementation QCloudWorkflowMediaInfo

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Video" : [QCloudWorkflowexecutionResultVideo class],
        @"Audio" : [QCloudWorkflowexecutionResultAudio class],
        @"Format" : [QCloudWorkflowexecutionResultFormat class],
    };
}

@end

@implementation QCloudWorkflowImageInfo

@end

@implementation QCloudWorkflowObjectInfo

@end

@implementation QCloudWorkflowexecutionResultVideo

@end

@implementation QCloudWorkflowexecutionResultAudio

@end

@implementation QCloudWorkflowexecutionResultFormat

@end

@implementation QCloudWorkflowSpriteObjectInfo

@end

@implementation QCloudWorkflowJudgementResult

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"InputObjectInfo" : [QCloudWorkflowInputObjectInfo class],
    };
}

@end

@implementation QCloudWorkflowInputObjectInfo

@end

@implementation QCloudWorkflowExecutionTopology

@end
