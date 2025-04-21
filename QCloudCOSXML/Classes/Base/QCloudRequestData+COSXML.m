//
//  QCloudRequestData+COSXML.m
//  QCloudCOSXML
//
//  Created by garenwang on 2025/3/31.
//

#import "QCloudRequestData+COSXML.h"

@implementation QCloudRequestData (COSXML)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        SEL originalSelector = @selector(setValue:forHTTPHeaderField:);
        SEL swizzledSelector = @selector(cos_setValue:forHTTPHeaderField:);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        BOOL didAddMethod
            = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)cos_setValue:(nonnull id)value forHTTPHeaderField:(nonnull NSString *)field {
    if ([field.lowercaseString isEqualToString:@"host"] && self.serverURL) {
        NSURL * url = [NSURL URLWithString:self.serverURL];
        if ([url.host isEqual:value] || !url.host) {
            [self cos_setValue:value forHTTPHeaderField:field];
        }else{
            [self cos_setValue:url.host forHTTPHeaderField:field];
        }
    }else{
        [self cos_setValue:value forHTTPHeaderField:field];
    }
}

@end
