//
//  UploadPartCopy.m
//  UploadPartCopy
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








#import "QCloudUploadPartCopyRequest.h"
#import <QCloudCore/QCloudSignatureFields.h>
#import <QCloudCore/QCloudCore.h>
#import <QCloudCore/QCloudServiceConfiguration_Private.h>
#import "QCloudCopyObjectResult.h"


NS_ASSUME_NONNULL_BEGIN
@implementation QCloudUploadPartCopyRequest
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
                                        QCloudURLFuseURIMethodASURLParamters,
                                        QCloudURLFuseWithURLEncodeParamters,
                                        ];

    NSArray* responseSerializers = @[
                                    QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
                                    QCloudResponseXMLSerializerBlock,

                                    QCloudResponseAppendHeadersSerializerBlock,

                                    QCloudResponseObjectSerilizerBlock([QCloudCopyObjectResult class])
                                    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"PUT";
}



- (BOOL) buildRequestData:(NSError *__autoreleasing *)error
{
    if (![super buildRequestData:error]) {
        return NO;
    }
    if (!self.bucket || ([self.bucket isKindOfClass:NSString.class] && ((NSString*)self.bucket).length == 0)) {
        if (error != NULL) {
            *error = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid message:[NSString stringWithFormat:@"InvalidArgument:paramter[bucket] is invalid (nil), it must have some value. please check it"]];
            return NO;
        }
    }
    NSURL* __serverURL = [self.runOnService.configuration.endpoint serverURLWithBucket:self.bucket appID:self.runOnService.configuration.appID regionName:self.regionName];
    self.requestData.serverURL = __serverURL.absoluteString;
    [self.requestData setValue:__serverURL.host forHTTPHeaderField:@"Host"];
    if (!self.object || ([self.object isKindOfClass:NSString.class] && ((NSString*)self.object).length == 0)) {
        if (error != NULL) {
            *error = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid message:[NSString stringWithFormat:@"InvalidArgument:paramter[object] is invalid (nil), it must have some value. please check it"]];
            return NO;
        }
    }
    [self.requestData setParameter:self.uploadID withKey:@"UploadId"];
    [self.requestData setNumberParamter:@(self.partNumber) withKey:@"partNumber"];
    if (!self.source || ([self.source isKindOfClass:NSString.class] && ((NSString*)self.source).length == 0)) {
        if (error != NULL) {
            *error = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid message:[NSString stringWithFormat:@"InvalidArgument:paramter[source] is invalid (nil), it must have some value. please check it"]];
            return NO;
        }
    }
    if (self.source) {
        [self.requestData setValue:self.source forHTTPHeaderField:@"x-cos-copy-source"];
    }
    if (self.sourceRange) {
        [self.requestData setValue:self.sourceRange forHTTPHeaderField:@"x-cos-copy-source-range"];
    }
    if (self.sourceIfModifiedSince) {
        [self.requestData setValue:self.sourceIfModifiedSince forHTTPHeaderField:@"x-cos-copy-source-If-Modified-Since"];
    }
    if (self.sourceIfUnmodifiedSince) {
        [self.requestData setValue:self.sourceIfUnmodifiedSince forHTTPHeaderField:@"x-cos-copy-source-If-Unmodified-Since"];
    }
    if (self.sourceIfMatch) {
        [self.requestData setValue:self.sourceIfMatch forHTTPHeaderField:@"x-cos-copy-source-If-Match"];
    }
    if (self.sourceIfNoneMatch) {
        [self.requestData setValue:self.sourceIfNoneMatch forHTTPHeaderField:@"x-cos-copy-source-If-None-Match"];
    }
    if (self.versionID) {
        [self.requestData setValue:self.versionID forHTTPHeaderField:@"x-cos-version-id"];
    }
    NSMutableArray* __pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    if(self.object) [__pathComponents addObject:self.object];
    self.requestData.URIComponents = __pathComponents;
    for (NSString* key  in self.customHeaders.allKeys.copy) {
    [self.requestData setValue:self.customHeaders[key] forHTTPHeaderField:key];
    }
    return YES;
}
- (void) setFinishBlock:(void (^_Nullable)(QCloudCopyObjectResult* _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock
{
    [super setFinishBlock:QCloudRequestFinishBlock];
}

- (QCloudSignatureFields*) signatureFields
{
    QCloudSignatureFields* fileds = [QCloudSignatureFields new];

    return fileds;
}

-(NSArray<NSMutableDictionary *> *)scopesArray{
    NSMutableArray *array = [NSMutableArray array];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    NSArray *tmpstrsArr = [self.source componentsSeparatedByString:@"/"];
    NSString *path = @"";
    for (int i= 1; i<tmpstrsArr.count; i++) {
        if (i==tmpstrsArr.count-1) {
            path = [path stringByAppendingString:tmpstrsArr[i]];
        }else{
            path = [path stringByAppendingString:tmpstrsArr[i]];
            path = [path stringByAppendingString:@"/"];
        }
    }
    NSArray *hostsArray = [tmpstrsArr[0] componentsSeparatedByString:@"."];
    dic[@"bucket"] = hostsArray[0];
    dic[@"region"] = hostsArray[2];
    dic[@"prefix"] = path;
    dic[@"action"] = @"name/cos:GetObject";
    [array addObject:dic];

    [array addObject:[self getScopeWithAction:@"name/cos:InitiateMultipartUpload"]];
    [array addObject:[self getScopeWithAction:@"name/cos:ListParts"]];
    [array addObject:[self getScopeWithAction:@"name/cos:PutObject"]];
    [array addObject:[self getScopeWithAction:@"name/cos:CompleteMultipartUpload"]];
    [array addObject:[self getScopeWithAction:@"name/cos:AbortMultipartUpload"]];
    
  
    return [array copy];
}
-(NSMutableDictionary *)getScopeWithAction:(NSString *)action{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSArray *separatetmpArray = [self.requestData.serverURL componentsSeparatedByString:@"://"];
    NSString *str = separatetmpArray[1];
    NSArray *separateArray = [str  componentsSeparatedByString:@"."];
    dic[@"bucket"] = separateArray[0];
    dic[@"region"] = self.runOnService.configuration.endpoint.regionName;
    dic[@"prefix"] = self.object;
    dic[@"action"] = action;
    return dic;
}

@end
NS_ASSUME_NONNULL_END
