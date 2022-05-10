//
//  NSError+QCloudNetworking.m
//  QCloudNetworking
//
//  Created by tencent on 16/2/19.
//  Copyright © 2016年 QCloudTernimalLab. All rights reserved.
//

#import "NSError+QCloudNetworking.h"
#import "NSObject+QCloudModel.h"
NSString *const kQCloudNetworkDomain = @"com.tencent.qcloud.networking";
NSString *const kQCloudNetworkErrorObject = @"kQCloudNetworkErrorObject";
NSString *const kQCloudErrorDetailCode = @"kQCloudErrorDetailCode";

@implementation NSError (QCloudNetworking)

+ (NSError *)qcloud_errorWithCode:(int)code message:(NSString *)message infos:(NSDictionary *)infos{
    message = message ? message : @"未知错误!";
    NSMutableDictionary *paramaters = [NSMutableDictionary dictionary];
    paramaters[NSLocalizedDescriptionKey] = message;
    for (NSString *key in infos.allKeys) {
        paramaters[key] = infos[key];
    }
    NSError *error = [NSError errorWithDomain:kQCloudNetworkDomain code:code userInfo:[paramaters copy]];
    return error;
}

+ (NSError *)qcloud_errorWithCode:(int)code message:(NSString *)message {
    message = message ? message : @"未知错误!";
    NSError *error = [NSError errorWithDomain:kQCloudNetworkDomain code:code userInfo:@{ NSLocalizedDescriptionKey : message }];
    return error;
}

+ (BOOL)isNetworkErrorAndRecoverable:(NSError *)error {
    if ([error.domain isEqualToString:NSURLErrorDomain]) {
        switch (error.code) {
            case NSURLErrorCancelled:
            case NSURLErrorBadURL:
            case NSURLErrorNotConnectedToInternet:
            case NSURLErrorSecureConnectionFailed:
            case NSURLErrorServerCertificateHasBadDate:
            case NSURLErrorServerCertificateUntrusted:
            case NSURLErrorServerCertificateHasUnknownRoot:
            case NSURLErrorServerCertificateNotYetValid:
            case NSURLErrorClientCertificateRejected:
            case NSURLErrorClientCertificateRequired:
            case NSURLErrorCannotLoadFromNetwork:
                return NO;

            default:
                return YES;
        }
    }
    if ([error.domain isEqualToString:kQCloudNetworkDomain]) {
        if (error.userInfo && error.userInfo[@"Code"]) {
            NSString *serverCode = error.userInfo[@"Code"];
            if ([serverCode isEqualToString:@"InvalidDigest"] || [serverCode isEqualToString:@"BadDigest"] ||
                [serverCode isEqualToString:@"InvalidSHA1Digest"] || [serverCode isEqualToString:@"RequestTimeOut"]) {
                return YES;
            }
        }
    }

    return NO;
}

//// InvalidArgument 参数错误
//QCloudNetworkErrorCodeParamterInvalid = 10000,
//// InvalidCredentials 获取签名错误
//QCloudNetworkErrorCodeCredentialNotReady = 10001,
//// 10004 UnsupportOperation: 无法支持的操作
//QCloudNetworkErrorUnsupportOperationError = 10004,
////数据完整性校验失败
//QCloudNetworkErrorCodeNotMatch = 20004,
////文件没有上传完成
//QCloudNetworkErrorCodeImCompleteData = 20005,
//// UserCancelled 用户取消
//QCloudNetworkErrorCodeCanceled = 30000,
//// AlreadyFinished 任务已完成
//QCloudNetworkErrorCodeAlreadyFinish = 30001,
//
///**
// 服务端错误
// */
//// ServerError 服务器返回了不合法的数据
//QCloudNetworkErrorCodeResponseDataTypeInvalid = 40000,

+(NSString *)qcloud_networkErrorCodeTransferToString:(QCloudNetworkErrorCode)code{
    switch (code) {
        case QCloudNetworkErrorCodeParamterInvalid:
            return @"InvalidArgument";
            break;
        case QCloudNetworkErrorCodeCredentialNotReady:
            return @"InvalidCredentials";
            break;
        case QCloudNetworkErrorUnsupportOperationError:
            return @"UnsupportOperation";
            break;
        case QCloudNetworkErrorCodeNotMatch:
            return @"CodeNotMatch";
            break;
        case QCloudNetworkErrorCodeImCompleteData:
            return @"IncompleteData";
        case QCloudNetworkErrorCodeCanceled:
            return @"UserCancelled";
            break;
        case QCloudNetworkErrorCodeAlreadyFinish:
            return @"AlreadyFinished";
            break;
        default:
            break;
    }
    return @"";
}
@end

@implementation QCloudCommonNetworkError

+ (NSError *)toError:(NSDictionary *)userInfo {
    NSNumber *code = [userInfo objectForKey:@"code"];
    if (code == nil) {
        return [NSError qcloud_errorWithCode:QCloudNetworkErrorUnsupportOperationError message:@"内容错误，无法从返回的错误信息中解析内容"];
    }
    int errorCode = (int)[code intValue];
    NSMutableDictionary *info = [NSMutableDictionary new];
    QCloudCommonNetworkError *object = [self qcloud_modelWithDictionary:userInfo];

    NSString *message = object.message ?: @"未知错误!";
    info[NSLocalizedDescriptionKey] = message;
    NSError *error = [NSError errorWithDomain:kQCloudNetworkDomain
                                         code:errorCode
                                     userInfo:@{ NSLocalizedDescriptionKey : message, kQCloudNetworkErrorObject : object }];
    return error;
}

@end
