//
//  UIImage+QCloudBunle.m
//  Pods
//
//  Created by Dong Zhao on 2017/3/20.
//
//
#if TARGET_OS_IOS

#import "UIImage+QCloudBundle.h"
#import "QCloudMainBundle.h"
@implementation UIImage (QCloudBunle)

+ (UIImage*) qcloudImageNamed:(NSString *)name class:(Class)cla
{
    NSBundle* bundle = QCloudMainBundle();
    if (!bundle) {
        NSString* path = [[NSBundle bundleForClass:cla] pathForResource:@"QCloudBundle" ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:path];
    }
    return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
}

@end
#endif

