//
//  NSError+QCloudNetworking.m
//  QCloudNetworking
//
//  Created by tencent on 16/2/19.
//  Copyright © 2016年 QCloudTernimalLab. All rights reserved.
//

#import "NSError+QCloudNetworking.h"
#import "NSObject+QCloudModel.h"
NSString* const kQCloudNetworkDomain = @"com.tencent.qcloud.networking";
NSString* const kQCloudNetworkErrorObject = @"kQCloudNetworkErrorObject";
@implementation NSError (QCloudNetworking)

+ (NSError*) qcloud_errorWithCode:(int)code message:(NSString*)message
{
    message = message ? message : @"未知错误!";
    NSError* error = [NSError errorWithDomain:kQCloudNetworkDomain code:code userInfo:@{NSLocalizedDescriptionKey:message}];
    return error;
}

+ (BOOL)isNetworkErrorAndRecoverable:(NSError *)error {
    
    static NSSet* kQCloudNetworkNotRecoverableCode;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kQCloudNetworkNotRecoverableCode = [NSSet setWithObjects:
                                                @(NSURLErrorCancelled),
                                                @(NSURLErrorBadURL),

                                                @(NSURLErrorSecureConnectionFailed),
                                                @(NSURLErrorServerCertificateHasBadDate),
                                                @(NSURLErrorServerCertificateUntrusted),
                                                @(NSURLErrorServerCertificateHasUnknownRoot),
                                                @(NSURLErrorServerCertificateNotYetValid),
                                                @(NSURLErrorClientCertificateRejected),
                                                @(NSURLErrorClientCertificateRequired),
                                                @(NSURLErrorCannotLoadFromNetwork),
                                                nil];
    });
    
    if([error.domain isEqualToString:NSURLErrorDomain]) {
        if (![kQCloudNetworkNotRecoverableCode containsObject:[NSNumber numberWithLong:error.code]]) {
            return YES;
        }
    }
    if ([error.domain isEqualToString:kQCloudNetworkDomain]) {
        if (error.userInfo && error.userInfo[@"Code"]) {
            NSString *serverCode = error.userInfo[@"Code"];
            if ([serverCode isEqualToString:@"InvalidDigest"]
                || [serverCode isEqualToString:@"BadDigest"]
                || [serverCode isEqualToString:@"InvalidSHA1Digest"]
                || [serverCode isEqualToString:@"RequestTimeOut"]) {
                return YES;
            }
        }
        
        if (error.code == QCloudNetworkErrorCodeMD5NotMatch) {
            return YES;
        }
    }
    
    return NO;
}

@end

@implementation QCloudCommonNetworkError

+ (NSError*) toError:(NSDictionary *)userInfo
{
    NSNumber* code = [userInfo objectForKey:@"code"];
    if (!code) {
        return [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeContentError message:@"内容错误，无法从返回的错误信息中解析内容"];
    }
    int errorCode = (int)[code intValue];
    NSMutableDictionary* info = [NSMutableDictionary new];
    QCloudCommonNetworkError* object = [self qcloud_modelWithDictionary:userInfo];
    
    NSString* message = object.message?: @"未知错误!";
    info[NSLocalizedDescriptionKey]=message;
    NSError* error  =  [NSError errorWithDomain:kQCloudNetworkDomain code:errorCode userInfo:@{NSLocalizedDescriptionKey:message,
                                                                                               kQCloudNetworkErrorObject:object}];
    return error;
}

@end
