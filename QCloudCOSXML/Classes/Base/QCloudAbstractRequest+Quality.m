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
    Method originNotifyErrorMethod = class_getInstanceMethod(class, @selector(__notifyError:));
    Method swizzedNotifyErrorMethod = class_getInstanceMethod(class, @selector(__quality__notifyError:));
    method_exchangeImplementations(originNotifyErrorMethod, swizzedNotifyErrorMethod);
    
    
    
}


- (void)__quality__notifyError:(NSError *)error {
    [self __quality__notifyError:error];
    [QualityDataUploader trackRequestFailWithType:self.class Error:error];
}


@end
