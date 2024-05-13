//
//
//  QCloudTriggerWorkflow.m
//
//  QCloudCOSXML
//
//
//
//  Created by garenwang on
//
//  2023-06-13 02:21:18 +0000.
//

#import "QCloudTriggerWorkflow.h"

@implementation QCloudListWorkflow

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"MediaWorkflowList" : [QCloudMediaWorkflowList class],
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    
    NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    if ([mdic[@"MediaWorkflowList"] isKindOfClass:[NSDictionary class]]) {
        [mdic setValue:@[mdic[@"MediaWorkflowList"]] forKey:@"MediaWorkflowList"];
    }
    return mdic.mutableCopy;
}

@end

@implementation QCloudTriggerWorkflow

@end

@implementation QCloudMediaWorkflowList

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Topology" : [QCloudWorkflowExecutionTopology class],
    };
}

@end

