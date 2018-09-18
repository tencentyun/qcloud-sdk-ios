//
//  QCloudAbstractRequest+Quality.m
//  QCloudCOSXML
//
//  Created by erichmzhang(张恒铭) on 2018/8/24.
//

#import "QCloudAbstractRequest+Quality.h"
#import <objc/runtime.h>
#import "QualityDataUploader.h"
@implementation QCloudAbstractRequest (Quality)
+ (void) load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self exchangeImplementation];
    });
}

+ (void)exchangeImplementation {
    Class class = [self class];
    SEL originalSelector = @selector(__notifySuccess:);
    SEL swizzledSelector = @selector(__quality__notifySuccess:);
    Method originNotifySuccessMethod = class_getInstanceMethod(class, @selector(__notifySuccess:));
    Method swizzedNotifySuccessMethod = class_getInstanceMethod(class, @selector(__quality__notifySuccess:));

        method_exchangeImplementations(originNotifySuccessMethod, swizzedNotifySuccessMethod);

    
    Method originNotifyErrorMethod = class_getInstanceMethod(class, @selector(__notifyError:));
    Method swizzedNotifyErrorMethod = class_getInstanceMethod(class, @selector(__quality__notifyError:));
    method_exchangeImplementations(originNotifyErrorMethod, swizzedNotifyErrorMethod);
    
    
    
}


- (void)__quality__notifySuccess:(id)object {
    [self __quality__notifySuccess:(id)object];
    [QualityDataUploader trackRequestSuccessWithType:self.class];
}

- (void)__quality__notifyError:(NSError *)error {
    [self __quality__notifyError:error];
    [QualityDataUploader trackRequestFailWithError:error];
}


@end
