//
//  GetObject.m
//  GetObject
//
//  Created by tencent
//  Copyright (c) 2015年 tencent. All rights reserved.
//
//   ██████╗  ██████╗██╗      ██████╗ ██╗   ██╗██████╗     ████████╗███████╗██████╗ ███╗   ███╗██╗███╗   ██╗ █████╗ ██╗         ██╗      █████╗ ██████╗
//  ██╔═══██╗██╔════╝██║     ██╔═══██╗██║   ██║██╔══██╗    ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║████╗  ██║██╔══██╗██║         ██║     ██╔══██╗██╔══██╗
//  ██║   ██║██║     ██║     ██║   ██║██║   ██║██║  ██║       ██║   █████╗  ██████╔╝██╔████╔██║██║██╔██╗ ██║███████║██║         ██║     ███████║██████╔╝
//  ██║▄▄ ██║██║     ██║     ██║   ██║██║   ██║██║  ██║       ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║██║╚██╗██║██╔══██║██║         ██║     ██╔══██║██╔══██╗
//  ╚██████╔╝╚██████╗███████╗╚██████╔╝╚██████╔╝██████╔╝       ██║   ███████╗██║  ██║██║ ╚═╝ ██║██║██║ ╚████║██║  ██║███████╗    ███████╗██║  ██║██████╔╝
//   ╚══▀▀═╝  ╚═════╝╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝        ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝    ╚══════╝╚═╝  ╚═╝╚═════╝
//
//
//                                                                              _             __                 _                _
//                                                                             (_)           / _|               | |              | |
//                                                          ___  ___ _ ____   ___  ___ ___  | |_ ___  _ __    __| | _____   _____| | ___  _ __   ___ _ __ ___
//                                                         / __|/ _ \ '__\ \ / / |/ __/ _ \ |  _/ _ \| '__|  / _` |/ _ \ \ / / _ \ |/ _ \| '_ \ / _ \ '__/ __|
//                                                         \__ \  __/ |   \ V /| | (_|  __/ | || (_) | |    | (_| |  __/\ V /  __/ | (_) | |_) |  __/ |  \__
//                                                         |___/\___|_|    \_/ |_|\___\___| |_| \___/|_|     \__,_|\___| \_/ \___|_|\___/| .__/ \___|_|  |___/
//    ______ ______ ______ ______ ______ ______ ______ ______                                                                            | |
//   |______|______|______|______|______|______|______|______|                                                                           |_|
//


#import "QCloudGetObjectRequest+Custom.h"
#import <QCloudCore/NSObject+HTTPHeadersContainer.h>
#import <objc/runtime.h>
@interface QCloudBizHTTPRequest()
- (void)__notifySuccess:(id)object;
@end

@implementation  QCloudGetObjectRequest (Custom)
- (void) __notifySuccess:(id)object
{
    if (!self.enableMD5Verification || ((NSObject*)object).__originHTTPURLResponse__ == nil) {
        [super __notifySuccess:object];
        return ;
    }

    NSString* MD5FromETag = [((NSObject*)object).__originHTTPURLResponse__ allHeaderFields][@"eTag"];
    if (MD5FromETag) {
        MD5FromETag =[MD5FromETag substringWithRange:NSMakeRange(1, MD5FromETag.length-2)];
    }
    NSString* localMD5String ;
    if (self.downloadingURL) {
        localMD5String = [QCloudEncrytFileMD5(self.downloadingURL.path) lowercaseString];
    } else {
        if ([object isKindOfClass:[NSData class]]) {
            localMD5String = [QCloudEncrytNSDataMD5(object) lowercaseString];
        }
    }
    NSError* resultError;
    if ( ![localMD5String isEqualToString:MD5FromETag]) {
        NSMutableString* errorMessageString = [[NSMutableString alloc] init];
        [errorMessageString appendFormat:@"下载过程中MD5校验与本地不一致，建议删除文件重新下载, 本地计算的 MD5 值:%@, 返回的 ETag值:%@",localMD5String,MD5FromETag];
        if ( [((NSObject*)object).__originHTTPURLResponse__ allHeaderFields][@"x-cos-request-id"]!= nil) {
            NSString* requestID = [((NSObject*)object).__originHTTPURLResponse__ allHeaderFields][@"x-cos-request-id"];
            [errorMessageString appendFormat:@", Request id:%@",requestID];
        }
        resultError = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeMD5NotMatch message:errorMessageString];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        self.finishBlock(object, resultError);
    });
    
    [self.benchMarkMan benginWithKey:kRNBenchmarkLogicOnly];
    if ([self.delegate respondsToSelector:@selector(QCloudHTTPRequestDidFinished:succeedWithObject:)]){
        [self.delegate QCloudHTTPRequestDidFinished:self succeedWithObject:object];
    }
    
    
    [self.benchMarkMan markFinishWithKey:kRNBenchmarkLogicOnly];
}

- (BOOL)enableMD5Verification {
    NSNumber* number = objc_getAssociatedObject(self, @selector(enableMD5Verification));
    return [number boolValue];
}

- (void)setEnableMD5Verification:(BOOL)enableMD5Verification {
    NSNumber* number = [NSNumber numberWithBool:enableMD5Verification];
    objc_setAssociatedObject(self, @selector(enableMD5Verification), number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
