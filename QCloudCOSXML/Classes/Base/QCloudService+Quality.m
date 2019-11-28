//
//  QCloudService+Quality.m
//  QCloudCOSXML
//
//  Created by erichmzhang(张恒铭) on 2018/8/27.
//

#import "QCloudService+Quality.h"
#import "QualityDataUploader.h"
#import <objc/runtime.h>
@implementation QCloudService (Quality)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self changeImplementation];
    });
    
}

+ (void) changeImplementation {
    Class class = [self class];
    
    Method originMethod = class_getInstanceMethod(class, @selector(performRequest:isHaveBody:));
    Method replacedMethod = class_getInstanceMethod(class,  @selector(__quality_performRequest:isHaveBody:));
    method_exchangeImplementations(originMethod, replacedMethod);
    
    originMethod = class_getInstanceMethod(class, @selector(performRequest:isHaveBody:withFinishBlock:));
    replacedMethod = class_getInstanceMethod(class,  @selector(__quality_performRequest:isHaveBody:withFinishBlock:));
    method_exchangeImplementations(originMethod, replacedMethod);
}

- (int) __quality_performRequest:(QCloudBizHTTPRequest*)httpRequst isHaveBody:(BOOL)body {
    int result = [self __quality_performRequest:httpRequst isHaveBody:body];
    [QualityDataUploader trackRequestSentWithType:object_getClass(httpRequst)];
    return result;
}

- (int) __quality_performRequest:(QCloudBizHTTPRequest*)httpRequst isHaveBody:(BOOL)body withFinishBlock:(QCloudRequestFinishBlock)block {
    int result = [self __quality_performRequest:httpRequst isHaveBody:body withFinishBlock:block];
    [QualityDataUploader trackRequestSentWithType:object_getClass(httpRequst)];
    return result;
}

@end
