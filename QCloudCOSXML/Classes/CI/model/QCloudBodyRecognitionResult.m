//
//  QCloudBodyRecognitionResult.m
//  QCloudCOSXML
//
//  Created by garenwang on 2022/8/23.
//

#import "QCloudBodyRecognitionResult.h"

@implementation QCloudBodyRecognitionLocation

@end


@implementation QCloudBodyRecognitionPedestrianInfo
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Location": [QCloudBodyRecognitionLocation class]
    };
}
@end

@implementation QCloudBodyRecognitionResult
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"PedestrianInfo": [QCloudBodyRecognitionPedestrianInfo class]
    };
}
@end
