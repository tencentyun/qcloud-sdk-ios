//
//  QCloudAudioAsrqueueResult.m
//  QCloudCOSXML
//
//  Created by garenwang on 2022/7/22.
//

#import "QCloudAudioAsrqueueResult.h"

@implementation QCloudAudioAsrqueueResult
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"QueueList": [QCloudAudioAsrqueueQueueListItem class],
        @"NonExistPIDs": [QCloudAudioAsrqueueResultNonExistPIDs class]
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

@implementation QCloudAudioAsrqueueResultNonExistPIDs
@end

@implementation QCloudAudioAsrqueueQueueListItem
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"NotifyConfig": [QCloudAudioAsrqueueNotifyConfig class],
    };
}
@end

@implementation QCloudAudioAsrqueueNotifyConfig

@end

@implementation QCloudAudioAsrqueueUpdateResult
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Queue": [QCloudAudioAsrqueueQueueListItem class]
    };
}
@end

