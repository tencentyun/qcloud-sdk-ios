//
//  QCloudWordsGeneralizeInput.m
//  QCloudCOSXML
//
//  Created by garenwang on 2022/8/24.
//

#import "QCloudWordsGeneralizeInput.h"

@implementation QCloudWordsGeneralizeInput
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Input": [QCloudWordsGeneralizeInputObject class],
        @"Operation": [QCloudWordsGeneralizeInputOperation class],
    };
}
@end

@implementation QCloudWordsGeneralizeInputObject

@end

@implementation QCloudWordsGeneralizeInputOperation
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"WordsGeneralize": [QCloudWordsGeneralizeInputGeneralize class],
    };
}
@end

@implementation QCloudWordsGeneralizeInputGeneralize

@end
