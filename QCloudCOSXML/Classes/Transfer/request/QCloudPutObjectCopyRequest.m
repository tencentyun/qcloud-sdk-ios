//
//  PutObjectCopy.m
//  PutObjectCopy
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

#import "QCloudPutObjectCopyRequest.h"
#import <QCloudCore/QCloudSignatureFields.h>
#import <QCloudCore/QCloudCore.h>
#import <QCloudCore/QCloudServiceConfiguration_Private.h>
#import "QCloudCopyObjectResult.h"

NS_ASSUME_NONNULL_BEGIN
@implementation QCloudPutObjectCopyRequest
- (void)dealloc {
}
- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    return self;
}
- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseSimple,
        QCloudURLFuseWithXMLParamters,
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseXMLSerializerBlock,

        QCloudResponseAppendHeadersSerializerBlock,

        QCloudResponseObjectSerilizerBlock([QCloudCopyObjectResult class])
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"PUT";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    if (!self.object || ([self.object isKindOfClass:NSString.class] && ((NSString *)self.object).length == 0)) {
        if (error != NULL) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[object] is invalid (nil), it must have some value. please check it"]];
            return NO;
        }
    }
    if (!self.bucket || ([self.bucket isKindOfClass:NSString.class] && ((NSString *)self.bucket).length == 0)) {
        if (error != NULL) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[bucket] is invalid (nil), it must have some value. please check it"]];
            return NO;
        }
    }
    NSURL *__serverURL = [self.runOnService.configuration.endpoint serverURLWithBucket:self.bucket
                                                                                 appID:self.runOnService.configuration.appID
                                                                            regionName:self.regionName];
    self.requestData.serverURL = __serverURL.absoluteString;
    [self.requestData setValue:__serverURL.host forHTTPHeaderField:@"Host"];
    if (self.objectCopySource) {
        [self.requestData setValue:self.objectCopySource forHTTPHeaderField:@"x-cos-copy-source"];
    }
    if (self.metadataDirective) {
        [self.requestData setValue:self.metadataDirective forHTTPHeaderField:@"x-cos-metadata-directive"];
    }
    if (self.objectCopyIfModifiedSince) {
        [self.requestData setValue:self.objectCopyIfModifiedSince forHTTPHeaderField:@"x-cos-copy-source-If-Modified-Since"];
    }
    if (self.objectCopyIfUnmodifiedSince) {
        [self.requestData setValue:self.objectCopyIfUnmodifiedSince forHTTPHeaderField:@"x-cos-copy-source-If-Unmodified-Since"];
    }
    if (self.objectCopyIfMatch) {
        [self.requestData setValue:self.objectCopyIfMatch forHTTPHeaderField:@"x-cos-copy-source-If-Match"];
    }
    if (self.objectCopyIfNoneMatch) {
        [self.requestData setValue:self.objectCopyIfNoneMatch forHTTPHeaderField:@"x-cos-copy-source-If-None-Match"];
    }
    if (self.storageClass) {
        [self.requestData setValue:QCloudCOSStorageClassTransferToString(self.storageClass) forHTTPHeaderField:@"x-cos-storage-class"];
    }
    if (self.accessControlList) {
        [self.requestData setValue:self.accessControlList forHTTPHeaderField:@"x-cos-acl"];
    }
    if (self.grantRead) {
        [self.requestData setValue:self.grantRead forHTTPHeaderField:@"x-cos-grant-read"];
    }
    if (self.grantWrite) {
        [self.requestData setValue:self.grantWrite forHTTPHeaderField:@"x-cos-grant-write"];
    }
    if (self.grantFullControl) {
        [self.requestData setValue:self.grantFullControl forHTTPHeaderField:@"x-cos-grant-full-control"];
    }
    if (self.versionID) {
        [self.requestData setValue:self.versionID forHTTPHeaderField:@"x-cos-version-id"];
    }
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    if (self.object)
        [__pathComponents addObject:self.object];
    self.requestData.URIComponents = __pathComponents;
    for (NSString *key in self.customHeaders.allKeys.copy) {
        [self.requestData setValue:self.customHeaders[key] forHTTPHeaderField:key];
    }
    return YES;
}

- (void)setFinishBlock:(void (^_Nullable)(QCloudCopyObjectResult *_Nullable, NSError *_Nullable))QCloudRequestFinishBlock {
    [super setFinishBlock:QCloudRequestFinishBlock];
}

- (QCloudSignatureFields *)signatureFields {
    QCloudSignatureFields *fileds = [QCloudSignatureFields new];

    return fileds;
}
- (NSArray<NSMutableDictionary *> *)scopesArray {
    NSMutableDictionary *orginDic = [NSMutableDictionary dictionary];
    NSArray *tmpstrsArr = [self.objectCopySource componentsSeparatedByString:@"/"];
    NSString *path = @"";
    for (int i = 1; i < tmpstrsArr.count; i++) {
        if (i == tmpstrsArr.count - 1) {
            path = [path stringByAppendingString:tmpstrsArr[i]];
        } else {
            path = [path stringByAppendingString:tmpstrsArr[i]];
            path = [path stringByAppendingString:@"/"];
        }
    }
    NSArray *hostsArray = [tmpstrsArr[0] componentsSeparatedByString:@"."];
    orginDic[@"bucket"] = hostsArray[0];
    orginDic[@"region"] = hostsArray[2];
    orginDic[@"prefix"] = path;
    orginDic[@"action"] = @"name/cos:GetObject";

    NSMutableDictionary *desDic = [NSMutableDictionary dictionary];
    NSArray *separatetmpArray = [self.requestData.serverURL componentsSeparatedByString:@"://"];
    NSString *str = separatetmpArray[1];
    NSArray *separateArray = [str componentsSeparatedByString:@"."];
    desDic[@"bucket"] = separateArray[0];
    desDic[@"region"] = self.runOnService.configuration.endpoint.regionName;
    desDic[@"prefix"] = self.object;
    desDic[@"action"] = @"name/cos:PutObject";

    NSMutableArray *array = [NSMutableArray array];
    [array addObject:orginDic];
    [array addObject:desDic];
    return [array copy];
}

@end
NS_ASSUME_NONNULL_END
