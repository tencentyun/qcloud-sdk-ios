//
//  QualityDataUploader.m
//  QCloudCOSXML
//
//  Created by erichmzhang(张恒铭) on 2018/8/23.
//

#import "QualityDataUploader.h"
#import <QCloudCore/QCloudCore.h>
#define AppKey @"I79GMXS2ZR8Y"

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
    NSArray *arr = @[@"QCloudHeadObjectRequest",
                     @"QCloudPutObjectRequest",
                     @"QCloudUploadPartRequest",
                     @"QCloudGetObjectRequest",
                     @"QCloudPutObjectCopyRequest",
                     @"QCloudUploadPartCopyRequest"];
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

+(BOOL)isErrorInsterested:(NSError *)error {
    return [NSError isNetworkErrorAndRecoverable:error];
}

+(void)internalUploadEvent:(NSString *)eventKey withParamter:(NSDictionary *)paramter {
    Class cls = NSClassFromString(@"TACMTA");
    if (cls) {
        [self invokeClassMethod:cls sel:NSSelectorFromString(@"trackCustomKeyValueEvent:props:appkey:isRealTime:")
            withObjects:@[eventKey, paramter, AppKey, @(NO)]];
    }
}

+ (void)trackRequestSentWithType:(Class)cls {
    if ([self isNeedQuality:cls]) {
        [self internalUploadEvent:kRequestSentKey withParamter:@{kClassNameKey:[NSString stringWithClass:cls]}];
    }
  
}

+ (void)trackRequestFailWithType:(Class)cls Error:(NSError *)error {
    if ([self isNeedQuality:cls] && [self isErrorInsterested:error]) {
        NSMutableDictionary *parameters = [error.toUploadEventParamters mutableCopy];
        parameters[kClassNameKey] = [NSString stringWithClass:cls];
        [self internalUploadEvent:kRequestFailKey withParamter:parameters];
    }
 
}

//可以传多个参数的方法
+ (NSInteger)invokeClassMethod:(Class) cls sel:(SEL)selector withObjects:(NSArray *)objects
{
    NSInteger returnValue = -1;
    
    // 方法签名
    NSMethodSignature *signature = [NSClassFromString(@"TACMTA") methodSignatureForSelector:selector];
    if (signature == nil) {
        return returnValue;
    }
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    if (signature.numberOfArguments < 1) {
        return returnValue;
    }
    
    invocation.target = cls;
    invocation.selector = selector;
    
    // 设置参数
    NSInteger paramsCount = signature.numberOfArguments - 2; // 除self、_cmd以外的参数个数
    paramsCount = MIN(paramsCount, objects.count);
    for (NSInteger i = 0; i < paramsCount; i++) {
        id object = objects[i];
        if ([object isKindOfClass:[NSNull class]]) continue;
        [invocation setArgument:&object atIndex:i + 2];
    }
    
    // 调用方法
    [invocation invoke];
    
    // 获取返回值
    if (signature.methodReturnLength) {
        [invocation getReturnValue:&returnValue];
    }
    
    return returnValue;
}



@end
