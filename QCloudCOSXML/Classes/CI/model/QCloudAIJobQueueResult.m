//
//  QCloudAIJobQueueResult.m
//  QCloudCOSXML
//
//  Created by garenwang on 2022/7/22.
//

#import "QCloudAIJobQueueResult.h"

@implementation QCloudAIJobQueueResult
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"QueueList": [QCloudAIJobQueueResultQueueListItem class],
        @"NonExistPIDs": [QCloudAIJobQueueResultNonExistPIDs class]
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

@implementation QCloudAIJobQueueResultNonExistPIDs
@end

@implementation QCloudAIJobQueueResultQueueListItem
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"NotifyConfig": [QCloudAIJobQueueResultNotifyConfig class],
    };
}
@end

@implementation QCloudAIJobQueueResultNotifyConfig

@end

@implementation QCloudAIJobQueueResultUpdateResult
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Queue": [QCloudAIJobQueueResultQueueListItem class]
    };
}
@end

