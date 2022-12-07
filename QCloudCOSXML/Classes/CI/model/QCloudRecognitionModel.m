//
//  QCloudRecognitionModel.m
//  QCloudCOSXML
//
//  Created by garenwang on 2022/3/22.
//

#import "QCloudRecognitionModel.h"

@implementation QCloudRecognitionOcrResults
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Location" : [QCloudRecognitionLocationInfo class]
    };
}

@end

@implementation QCloudRecognitionObjectResults
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Location" : [QCloudRecognitionLocationInfo class]
    };
}

@end

@implementation QCloudRecognitionResultsItemInfo

@end

@implementation QCloudRecognitionLabels
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"PornInfo": [QCloudRecognitionLabels class],
        @"AdsInfo": [QCloudRecognitionLabels class],
        @"TerrorismInfo": [QCloudRecognitionLabels class],
        @"PoliticsInfo": [QCloudRecognitionLabels class],
    };
}
@end

@implementation QCloudRecognitionLocationInfo

@end

@implementation QCloudRecognitionSectionItemInfo
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"LibResults": [QCloudRecognitionSectionItemLibResults class],
    };
}
@end

@implementation QCloudRecognitionSectionItemLibResults

@end

@implementation QCloudRecognitionLabelsItem

@end

@implementation QCloudRecognitionItemInfo

@end
