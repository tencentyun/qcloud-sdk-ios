//
//  NSException+Quality.m
//  QCloudCOSXML
//
//  Created by karisli(李雪) on 2021/1/5.
//

#import "NSException+Quality.h"
#import <objc/runtime.h>
#import <QCloudCore/QCloudCore.h>
#import "QualityDataUploader.h"
@implementation NSException (Quality)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self changeImplementation];
    });
}

+ (void)changeImplementation {
    Class class = object_getClass((id)self);
    Method originMethod = class_getClassMethod(class, @selector(exceptionWithName:reason:userInfo:));
    Method replacedMethod = class_getClassMethod(class, @selector(qcloud_exceptionWithName:reason:userInfo:));
    method_exchangeImplementations(originMethod, replacedMethod);
}

+ (NSException *)qcloud_exceptionWithName:(NSExceptionName)name reason:(NSString *)reason userInfo:(NSDictionary *)userInfo {
    NSException *exp = [self qcloud_exceptionWithName:name reason:reason userInfo:userInfo];
    if ([name isEqualToString:QCloudErrorDomain]) {
        [QualityDataUploader trackSDKExceptionWithException:exp];
    }
    return exp;
}

@end
