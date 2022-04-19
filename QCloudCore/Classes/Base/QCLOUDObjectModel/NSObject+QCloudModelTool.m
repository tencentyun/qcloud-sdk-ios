//
//  NSObject+QCloudModelTool.m
//  QCloudCore
//
//  Created by karisli(李雪) on 2021/8/2.
//

#import "NSObject+QCloudModelTool.h"
#import "NSObject+QCloudModel.h"
@implementation NSObject (QCloudModelTool)
+ (NSArray *)jsonsToModelsWithJsons:(NSArray *)jsons {
    NSMutableArray *models = [NSMutableArray array];
    for (NSDictionary *json in jsons) {
        id model = [[self class] qcloud_modelWithDictionary:json];
        if (model) {
            [models addObject:model];
        }
    }
    return models;
}
@end
