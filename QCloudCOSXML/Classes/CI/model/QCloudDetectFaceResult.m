//
//  QCloudOpenAIBucketResult.m
//  QCloudCOSXML
//
//  Created by garenwang on 2022/8/23.
//

#import "QCloudDetectFaceResult.h"

@implementation QCloudDetectFaceResult
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{
        @"FaceInfos": [QCloudDetectFaceInfoResult class],
    };
}
@end

@implementation QCloudDetectFaceInfoResult

@end

