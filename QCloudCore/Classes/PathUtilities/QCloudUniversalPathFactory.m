//
//  QCloudUniversalPathFactory.m
//  QCloudCore
//
//  Created by erichmzhang(张恒铭) on 2018/7/20.
//

#import "QCloudUniversalPathFactory.h"
#import "QCloudMediaPath.h"
#import "QCloudSandboxPath.h"
#import "QCloudBundlePath.h"
#import "QCloudFileUtils.h"


NSString * const kMediaURLPrefix = @"/var/mobile/Media/DCIM";
#define  kBundlePath  [NSBundle mainBundle].bundlePath
@interface NSString(UniversalPathExtension)

@end

@implementation NSString(UniversalPathExtension)



- (BOOL)isBundlePath {
    return [self containsString:kBundlePath];
    
}

- (BOOL)isSandboxPath {
    return [self containsString:QCloudApplicationDirectory()];
}

- (BOOL)isMediaPath {
    return [self containsString:kMediaURLPrefix];
}
@end


@implementation QCloudUniversalPathFactory
+ (QCloudUniversalPath *) universalPathWithURL:(NSURL *)url {
    QCloudUniversalPath *result ;
    NSString *strippedURL;
    NSString *absoluteString = url.absoluteString;
    if (!url && ![url isKindOfClass:NSURL.class]) {
        QCloudLogDebug(@"Nil paramater url!");
        return nil;
    }
    if ([absoluteString isMediaPath]) {
        strippedURL = absoluteString;
        result = [[QCloudMediaPath alloc] initWithStrippedURL:strippedURL];
        result.type = QCLOUD_UNIVERSAL_PATH_TYPE_MEDIA;
    } else if ([absoluteString isBundlePath]) {
        NSRange range = [absoluteString rangeOfString:kBundlePath];
        strippedURL = [absoluteString substringFromIndex:range.location + range.length];
        result = [[QCloudBundlePath alloc] initWithStrippedURL:strippedURL];
        result.type = QCLOUD_UNIVERSAL_PATH_TYPE_BUNDLE;
    } else if ([absoluteString isSandboxPath]) {
        //sandbox
        NSRange range = [absoluteString rangeOfString:QCloudApplicationDirectory()];
        strippedURL = [absoluteString substringFromIndex:range.location + range.length];
        result = [[QCloudSandboxPath alloc] initWithStrippedURL:strippedURL];
        result.type = QCLOUD_UNIVERSAL_PATH_TYPE_SANDBOX;
    } else {
        //Unknown, not stripped
        strippedURL = absoluteString;
        result = [[QCloudUniversalFixedPath alloc] initWithStrippedURL:strippedURL];
        result.type = QCLOUD_UNIVERSAL_PATH_TYPE_FIXED;
    }
    QCloudLogDebug(@"Origin URL is %@ , stripped URL is %@",absoluteString,strippedURL);
    return result;
}





@end
