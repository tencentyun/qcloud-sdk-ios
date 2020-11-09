//
//  COSXML.m
//  COSXML
//
//  Created by tencent
//  Copyright (c) 2015年 tencent. All rights reserved.
//
//   ██████╗  ██████╗██╗      ██████╗ ██╗   ██╗██████╗     ████████╗███████╗██████╗ ███╗   ███╗██╗███╗   ██╗ █████╗ ██╗         ██╗      █████╗
//   ██████╗
//  ██╔═══██╗██╔════╝██║     ██╔═══██╗██║   ██║██╔══██╗    ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║████╗  ██║██╔══██╗██║         ██║ ██╔══██╗██╔══██╗
//  ██║   ██║██║     ██║     ██║   ██║██║   ██║██║  ██║       ██║   █████╗  ██████╔╝██╔████╔██║██║██╔██╗ ██║███████║██║         ██║ ███████║██████╔╝
//  ██║▄▄ ██║██║     ██║     ██║   ██║██║   ██║██║  ██║       ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║██║╚██╗██║██╔══██║██║         ██║ ██╔══██║██╔══██╗
//  ╚██████╔╝╚██████╗███████╗╚██████╔╝╚██████╔╝██████╔╝       ██║   ███████╗██║  ██║██║ ╚═╝ ██║██║██║ ╚████║██║  ██║███████╗    ███████╗██║
//  ██║██████╔╝
//   ╚══▀▀═╝  ╚═════╝╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝        ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝    ╚══════╝╚═╝ ╚═╝╚═════╝
//
//
//                                                                              _             __                 _                _
//                                                                             (_)           / _|               | |              | |
//                                                          ___  ___ _ ____   ___  ___ ___  | |_ ___  _ __    __| | _____   _____| | ___  _ __   ___ _
//                                                          __ ___
//                                                         / __|/ _ \ '__\ \ / / |/ __/ _ \ |  _/ _ \| '__|  / _` |/ _ \ \ / / _ \ |/ _ \| '_ \ / _ \
//                                                         '__/ __|
//                                                         \__ \  __/ |   \ V /| | (_|  __/ | || (_) | |    | (_| |  __/\ V /  __/ | (_) | |_) |  __/
//                                                         |  \__
//                                                         |___/\___|_|    \_/ |_|\___\___| |_| \___/|_|     \__,_|\___| \_/ \___|_|\___/| .__/
//                                                         \___|_|  |___/
//    ______ ______ ______ ______ ______ ______ ______ ______                                                                            | |
//   |______|______|______|______|______|______|______|______|                                                                           |_|
//

#import "QCloudCOSXMLService.h"
#import "QCloudCOSXMLService+Configuration.h"
#import "QCloudCOSXMLService+Private.h"
#if TARGET_OS_IOS
#import "QCloudLogManager.h"
#endif
QCloudThreadSafeMutableDictionary *QCloudCOSXMLServiceCache() {
    static QCloudThreadSafeMutableDictionary *CloudcosxmlService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CloudcosxmlService = [QCloudThreadSafeMutableDictionary new];
    });
    return CloudcosxmlService;
}
@implementation QCloudCOSXMLService
@synthesize sessionManager = _sessionManager;
static QCloudCOSXMLService *COSXMLService = nil;

+ (QCloudCOSXMLService *)defaultCOSXML {
    @synchronized(self) {
        if (!COSXMLService) {
            @throw [NSException exceptionWithName:QCloudErrorDomain reason:@"您没有配置默认的OCR服务配置，请配置之后再调用该方法" userInfo:nil];
        }
        return COSXMLService;
    }
}

+ (QCloudCOSXMLService *)registerDefaultCOSXMLWithConfiguration:(QCloudServiceConfiguration *)configuration {
    @synchronized(self) {
        if (COSXMLService) {
            @throw [NSException
                exceptionWithName:QCloudErrorDomain
                           reason:[NSString stringWithFormat:
                                                @"默认的COSXMLService已存在，如有新的配置，请通过 registerCOSXMLWithConfiguration:withKey:重新注册"]
                         userInfo:nil];
        }
        COSXMLService = [[QCloudCOSXMLService alloc] initWithConfiguration:configuration];
        if (!configuration.isCloseShareLog) {
#if TARGET_OS_IOS
            [QCloudLogManager sharedInstance];
#endif
        }
    }
    return COSXMLService;
}

+ (QCloudCOSXMLService *)cosxmlServiceForKey:(NSString *)key {
    QCloudCOSXMLService *cosxmlService = [QCloudCOSXMLServiceCache() objectForKey:key];
    if (!cosxmlService) {
        @throw [NSException exceptionWithName:QCloudErrorDomain
                                       reason:[NSString stringWithFormat:@"您没有配置Key为%@的OCR服务配置，请配置之后再调用该方法", key]
                                     userInfo:nil];
    }
    return cosxmlService;
}

+ (void)removeCOSXMLWithKey:(NSString *)key {
    [QCloudCOSXMLServiceCache() removeObjectForKey:key];
}

+ (QCloudCOSXMLService *)registerCOSXMLWithConfiguration:(QCloudServiceConfiguration *)configuration withKey:(NSString *)key;
{
    if ([self hasServiceForKey:key]) {
        @throw [NSException
            exceptionWithName:QCloudErrorDomain
                       reason:[NSString
                                  stringWithFormat:
                                      @"key: %@ COSXMLService已存在，如有新的配置，请通过 registerCOSXMLWithConfiguration:withKey:重新注册", key]
                     userInfo:nil];
    }
    QCloudCOSXMLService *cosxmlService = [[QCloudCOSXMLService alloc] initWithConfiguration:configuration];
    [QCloudCOSXMLServiceCache() setObject:cosxmlService forKey:key];
    return cosxmlService;
}
- (NSString *)getURLWithBucket:(NSString *)bucket
                        object:(NSString *)object
             withAuthorization:(BOOL)withAuthorization
                    regionName:(NSString *)regionName {
    NSParameterAssert(bucket);
    NSParameterAssert(object);
    __block NSMutableString *resultURL = [[NSMutableString alloc] init];
    NSString *bucketURL = [[self.configuration.endpoint serverURLWithBucket:bucket appID:self.configuration.appID
                                                                 regionName:regionName] absoluteString];
    [resultURL appendString:bucketURL];
    [resultURL appendFormat:@"/%@", object];
    if (withAuthorization) {
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        NSMutableURLRequest *fakeURLRequest = [[NSMutableURLRequest alloc] init];
        [fakeURLRequest setHTTPMethod:@"GET"];
        [fakeURLRequest setURL:[NSURL URLWithString:resultURL]];
        [self.configuration.signatureProvider signatureWithFields:nil
                                                          request:nil
                                                       urlRequest:fakeURLRequest
                                                        compelete:^(QCloudSignature *signature, NSError *error) {
                                                            NSString *sign = signature.signature;
                                                            sign = QCloudURLEncodeUTF8(sign);
                                                            [resultURL appendFormat:@"?sign=%@", sign];
                                                            dispatch_semaphore_signal(semaphore);
                                                        }];
        dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC));
    }
    return [resultURL copy];
}

+ (BOOL)hasServiceForKey:(NSString *)key {
    if (nil == [QCloudCOSXMLServiceCache() objectForKey:key]) {
        return NO;
    } else {
        return YES;
    }
}

@end
