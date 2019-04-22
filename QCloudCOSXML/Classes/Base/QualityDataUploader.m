//
//  QualityDataUploader.m
//  QCloudCOSXML
//
//  Created by erichmzhang(张恒铭) on 2018/8/23.
//

#import "QualityDataUploader.h"
#import <QCloudCore/QCloudLogger.h>
#import "NSError+QCloudNetworking.h"
#import <QCloudCore/MTA.h>
#import <QCloudCore/MTA+Account.h>
#import <QCloudCore/MTAConfig.h>
static  NSString * kRequestSentKey = @"request_sent";
static  NSString * kRequestFailKey = @"request_failed";
static  NSString * kErrorCodeKey = @"error_code";
static  NSString * kClassNameKey = @"class_name";

@interface NSError(QualityDataUploader)

- (NSDictionary*) toUploadEventParamters ;
@end

@implementation NSError(QualityDataUploader)

- (NSDictionary*) toUploadEventParamters  {
    NSDictionary *userinfoDic = self.userInfo;
    NSString *detailDescription = @"";
    if (userinfoDic) {
        if (userinfoDic[@"Code"]) {
         detailDescription  = userinfoDic[@"Code"];
        }
    }
    return @{kErrorCodeKey:[NSString stringWithFormat:@"%ld %@",(long)self.code,detailDescription]};
    
}
@end

@interface NSString(Quality)
+ (NSString*)stringWithClass:(Class)cls;
@end

@implementation NSString(Quality)
+ (NSString*)stringWithClass:(Class)cls {
    return [NSString stringWithFormat:@"%@",cls];
}
@end


@implementation QualityDataUploader

NSArray * filterUploadEventClass(){
    NSArray *arr = @[@"QCloudPutObjectRequest",@"QCloudInitiateMultipartUploadRequest",@"QCloudUploadPartRequest",@"QCloudCompleteMultipartUploadRequest",@"QCloudAbortMultipfartUploadRequest",@"QCloudGetObjectRequest",@"QCloudListMultipartRequest",@"QCloudAbortMultipfartUploadRequest",@"QCloudPutObjectCopyRequest",@"QCloudUploadPartCopyRequest"];
    return arr;
}

+(BOOL)isNeedQuality:(Class)cls{
    NSString *clas = [NSString stringWithClass:cls] ;
    NSArray *array =filterUploadEventClass();
    if ([array containsObject:clas]) {
        return YES;
    }
    return NO;
}

+(TACMTAErrorCode)internalUploadEvent:(NSString *)eventKey withParamter:(NSDictionary *)paramter {
    TACMTAErrorCode result =  [TACMTA trackCustomKeyValueEvent:eventKey props:paramter];
    QCloudLogDebug(@"%@ :%@",eventKey,paramter);
    return result;
}

+ (void)trackRequestSentWithType:(Class)cls {
    if ([self isNeedQuality:cls]) {
        [self internalUploadEvent:kRequestSentKey withParamter:@{kClassNameKey:[NSString stringWithClass:cls]}];
    }
  
}

+ (void)trackRequestFailWithType:(Class)cls Error:(NSError *)error {
    if ([self isNeedQuality:cls]) {
        NSMutableDictionary *parameters = [error.toUploadEventParamters mutableCopy];
        parameters[kClassNameKey] = [NSString stringWithClass:cls];
        [self internalUploadEvent:kRequestFailKey withParamter:parameters];
    }
 
}





@end
