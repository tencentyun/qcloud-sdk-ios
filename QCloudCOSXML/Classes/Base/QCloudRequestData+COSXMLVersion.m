//

#import "QCloudRequestData+COSXMLVersion.h"
#import <QCloudCore/QCloudSDKModuleManager.h>

static NSString* const kCOSXMLModuleName = @"QCloudCOSXML";
@implementation QCloudRequestData (COSXMLVersion)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(loadDefaultHTTPHeaders);
        SEL swizzledSelector = @selector(swizzle_loadDefaultHTTPHeaders);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)swizzle_loadDefaultHTTPHeaders
{
    [self swizzle_loadDefaultHTTPHeaders];
    static NSDictionary* httpHeaders;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __block NSString* versionString ;
        NSArray* modules = [[QCloudSDKModuleManager shareInstance] allModules];
        [modules enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            QCloudSDKModule* module = obj;
            if ([module.name isEqualToString:kCOSXMLModuleName]) {
                versionString = module.version;
                *stop = YES;
            }
        }];
        NSString*  userAgent = [NSString stringWithFormat:@"cos-xml-ios-sdk-v%@",versionString];
        httpHeaders = @{@"Connection":@"keep-alive",
                        HTTPHeaderUserAgent : userAgent};

    });
    [httpHeaders enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self setValue:obj forHTTPHeaderField:key];
    }];
}
@end

