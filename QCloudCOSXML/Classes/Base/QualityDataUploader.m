//
//  QualityDataUploader.m
//  QCloudCOSXML
//
//  Created by erichmzhang(张恒铭) on 2018/8/23.
//

#import "QualityDataUploader.h"
#import <QCloudCore/QCloudLogger.h>

static  NSString * kRequestSentKey = @"request_sent";
static  NSString * kRequsetSuccessKey = @"request_success";
static  NSString * kRequestFailKey = @"request_fail";
static  NSString * kUploadFailKey = @"upload_fail";
static  NSString * kUploadSuccessKey = @"upload_success";
static  NSString * kErrorCodeKey = @"error_code";
static  NSString * kErrorDescriptionKey = @"error_description";
static  NSString * kClassNameKey = @"class_name";


@interface NSError(QualityDataUploader)

- (NSDictionary*) toUploadEventParamters ;
@end

@implementation NSError(QualityDataUploader)

- (NSDictionary*) toUploadEventParamters  {
    return @{kErrorCodeKey:[NSString stringWithFormat:@"%ld",(long)self.code],kErrorDescriptionKey:self.description};
    
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
+(TACMTAErrorCode)internalUploadEvent:(NSString *)eventKey withParamter:(NSDictionary *)paramter {
    TACMTAErrorCode result =  [TACMTA trackCustomKeyValueEvent:eventKey props:paramter];
    QCloudLogDebug(@"track event :%@\nParamters:%@\nresult:%@",eventKey,paramter,result);
    return result;
}



+ (void)trackUploadFailWithError:(NSError *)error class:(Class)cls {
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:error.toUploadEventParamters];
    [dict setObject:kClassNameKey forKey:[NSString stringWithClass:cls]];
    [self internalUploadEvent:kUploadFailKey withParamter:dict];
}
+ (void)trackRequestSentWithType:(Class)cls {
    [self internalUploadEvent:kRequestSentKey withParamter:@{kClassNameKey:[NSString stringWithClass:cls]}];
}

+ (void)trackRequestSuccessWithType:(Class)cls {
    [self internalUploadEvent:kRequsetSuccessKey withParamter:@{kClassNameKey:[NSString stringWithClass:cls]}];
}

+ (void)trackRequestFailWithError:(NSError *)error {
    [self internalUploadEvent:kRequestFailKey withParamter:error.toUploadEventParamters];
}





@end
