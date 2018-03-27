//
//  AbortMultipfartUpload.m
//  AbortMultipfartUpload
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








#import "QCloudAbortMultipfartUploadRequest.h"
#import <QCloudCore/QCloudSignatureFields.h>
#import <QCloudCore/QCloudCore.h>
#import <QCloudCore/QCloudServiceConfiguration_Private.h>


NS_ASSUME_NONNULL_BEGIN
@implementation QCloudAbortMultipfartUploadRequest
- (void) dealloc
{
}
-  (instancetype) init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    return self;
}
- (void) configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer  responseSerializer:(QCloudResponseSerializer *)responseSerializer
{

    NSArray* customRequestSerilizers = @[
                                        QCloudURLFuseSimple,
                                        QCloudURLFuseWithURLEncodeParamters,
                                        ];

    NSArray* responseSerializers = @[
                                    QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),

                                    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"delete";
}



- (BOOL) buildRequestData:(NSError *__autoreleasing *)error
{
    if (![super buildRequestData:error]) {
        return NO;
    }
    if (!self.object || ([self.object isKindOfClass:NSString.class] && ((NSString*)self.object).length == 0)) {
        if (error != NULL) {
            *error = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid message:[NSString stringWithFormat:@"paramter[object] is invalid (nil), it must have some value. please check it"]];
            return NO;
        }
    }
    if (!self.bucket || ([self.bucket isKindOfClass:NSString.class] && ((NSString*)self.bucket).length == 0)) {
        if (error != NULL) {
            *error = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid message:[NSString stringWithFormat:@"paramter[bucket] is invalid (nil), it must have some value. please check it"]];
            return NO;
        }
    }
    NSURL* __serverURL = [self.runOnService.configuration.endpoint serverURLWithBucket:self.bucket appID:self.runOnService.configuration.appID];
    self.requestData.serverURL = __serverURL.absoluteString;
    [self.requestData setValue:__serverURL.host forHTTPHeaderField:@"Host"];
    if (!self.uploadId || ([self.uploadId isKindOfClass:NSString.class] && ((NSString*)self.uploadId).length == 0)) {
        if (error != NULL) {
            *error = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid message:[NSString stringWithFormat:@"paramter[uploadId] is invalid (nil), it must have some value. please check it"]];
            return NO;
        }
    }
    [self.requestData setParameter:self.uploadId withKey:@"UploadId"];
    NSMutableArray* __pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    if(self.object) [__pathComponents addObject:self.object];
    self.requestData.URIComponents = __pathComponents;
    return YES;
}

- (QCloudSignatureFields*) signatureFields
{
    QCloudSignatureFields* fileds = [QCloudSignatureFields new];

    return fileds;
}

@end
NS_ASSUME_NONNULL_END
