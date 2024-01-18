//
//  QCloudAbstractRequest+Quality.m
//  QCloudCOSXML
//
//  Created by erichmzhang(张恒铭) on 2018/8/24.
//

#import "QCloudAbstractRequest+Quality.h"
#import <objc/runtime.h>
#import <QCloudCore/QualityDataUploader.h>
#import "QCloudCOSXMLVersion.h"
#import "QCloudCOSXMLService+Quality.h"
@implementation QCloudAbstractRequest (Quality)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self exchangeImplementation];
    });
}

+ (void)exchangeImplementation {
    Class class = [self class];
    Method originNotifyErrorMethod = class_getInstanceMethod(class, @selector(__notifyError:));
    Method swizzedNotifyErrorMethod = class_getInstanceMethod(class, @selector(__quality__notifyError:));
    Method originNotifySuccessMethod = class_getInstanceMethod(class, @selector(__notifySuccess:));
    Method swizzedNotifySuccessMethod = class_getInstanceMethod(class, @selector(__quality__notifySuccess:));

    method_exchangeImplementations(originNotifyErrorMethod, swizzedNotifyErrorMethod);
    method_exchangeImplementations(originNotifySuccessMethod, swizzedNotifySuccessMethod);
}

- (void)__quality__notifyError:(NSError *)error {
    [self __quality__notifyError:error];
    [QualityDataUploader trackSDKRequestFailWithRequest:self error:error params:[QCloudCOSXMLService commonParams:kQCloudDataAppReleaseKey]];
}

- (void)__quality__notifySuccess:(id)object {
    [self __quality__notifySuccess:object];
    [QualityDataUploader trackSDKRequestSuccessWithRequest:self params:[QCloudCOSXMLService commonParams:kQCloudDataAppReleaseKey]];
}

@end
