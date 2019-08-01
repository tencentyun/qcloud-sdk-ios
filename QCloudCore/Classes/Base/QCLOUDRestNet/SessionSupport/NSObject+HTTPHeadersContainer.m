//
//  NSObject+HTTPHeadersContainer.m
//  QCloudCore
//
//  Created by Dong Zhao on 2017/11/28.
//

#import "NSObject+HTTPHeadersContainer.h"
#import <objc/runtime.h>

static void* kQCloudOriginHTTPHeaders = &kQCloudOriginHTTPHeaders;
@implementation NSObject (HTTPHeadersContainer)

- (void) set__originHTTPURLResponse__:(NSHTTPURLResponse *)__originHTTPURLResponse__
{
    objc_setAssociatedObject(self, kQCloudOriginHTTPHeaders, __originHTTPURLResponse__, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSHTTPURLResponse*) __originHTTPURLResponse__
{
    return objc_getAssociatedObject(self, kQCloudOriginHTTPHeaders);
}

- (void)set__originHTTPResponseData__:(NSData *)__originHTTPResponseData__ {
    objc_setAssociatedObject(self, @selector(set__originHTTPResponseData__:), __originHTTPResponseData__, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSData*) __originHTTPResponseData__
{
    return objc_getAssociatedObject(self, @selector(set__originHTTPResponseData__:));
}


@end
