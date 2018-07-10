//
//  QCloudURLTools.m
//  QCloudCore
//
//  Created by Dong Zhao on 2017/11/28.
//

#import "QCloudURLTools.h"
NSString* const QCloudHTTPScheme = @"http://";
NSString* const QCloudHTTPSScheme = @"https://";

NSString* QCloudFormattHTTPURL(NSString* originURL, BOOL useHTTPS) {
    if (!originURL) {
        return nil;
    }
    NSString* schema = useHTTPS ? QCloudHTTPSScheme: QCloudHTTPScheme;
    NSString* origin = originURL;
    if ([originURL.lowercaseString hasPrefix:schema.lowercaseString]) {
        return originURL;
    }
    if ([origin.lowercaseString hasPrefix:QCloudHTTPScheme]){
        origin = [origin substringFromIndex:QCloudHTTPScheme.length];
    } else if ([origin.lowercaseString hasPrefix:QCloudHTTPSScheme]) {
        origin = [origin substringFromIndex:QCloudHTTPSScheme.length];
    }
    return [schema stringByAppendingString:origin];
}

