//
//  QCloudAutoTranslationResult.m
//  QCloudCOSXML
//
//  Created by garenwang on 2022/8/23.
//

#import "QCloudAutoTranslationResult.h"

@implementation QCloudAutoTranslationResult
+ (NSDictionary *)modelCustomPropertyMapper
{
  return @{
      @"text" :@"__text",
  };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    
    NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    if ([mdic[@"QueueList"] isKindOfClass:[NSDictionary class]]) {
        [mdic setValue:@[mdic[@"QueueList"]] forKey:@"QueueList"];
    }
    return mdic.mutableCopy;
}

@end

