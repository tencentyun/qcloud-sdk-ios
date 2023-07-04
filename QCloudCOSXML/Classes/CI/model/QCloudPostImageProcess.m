//
//
//  QCloudPostImageProcess.m
//
//  QCloudCOSXML
//
//
//
//  Created by garenwang on
//
//  2023-06-13 09:54:21 +0000.
//

#import "QCloudPostImageProcess.h"

@implementation QCloudPostImageProcess

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"JobsDetail" : [QCloudPostImageProcessJobsDetail class],
    };
}

@end

@implementation QCloudPostImageProcessJobsDetail

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Input" : [QCloudPostImageProcessInput class],
        @"Operation" : [QCloudPostImageProcessOperation class],
    };
}

@end

@implementation QCloudPostImageProcessInput

@end

@implementation QCloudPostImageProcessOperation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"PicProcess" : [QCloudPicProcess class],
        @"Output" : [QCloudInputPostImageProcessOperation class],
        @"PicProcessResult" : [QCloudPutObjectProcessResults class],
    };
}

@end

@implementation QCloudInputPostImageProcess

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Input" : [QCloudInputPostImageProcessInput class],
        @"Operation" : [QCloudInputPostImageProcessOperation class],
        @"CallBackMqConfig" : [QCloudCallBackMqConfig class],
    };
}

@end

@implementation QCloudInputPostImageProcessInput

@end

@implementation QCloudInputPostImageProcessOperation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"PicProcess" : [QCloudPicProcess class],
        @"Output" : [QCloudInputPostImageProcessOutput class],
    };
}

@end

@implementation QCloudInputPostImageProcessOutput

@end

