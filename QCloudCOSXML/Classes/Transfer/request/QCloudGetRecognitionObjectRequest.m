//
//  QCloudGetRecognitionObjectResult.m
//  QCloudGetRecognitionObjectResult
//
//  Created by tencent
//  Copyright (c) 2020年 tencent. All rights reserved.
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

#import "QCloudGetRecognitionObjectRequest.h"
#import <QCloudCore/QCloudSignatureFields.h>
#import <QCloudCore/QCloudCore.h>
#import <QCloudCore/QCloudServiceConfiguration_Private.h>
#import "QCloudGetObjectRequest+Custom.h"
#import "QCloudGetRecognitionObjectResult.h"


NS_ASSUME_NONNULL_BEGIN
@implementation QCloudGetRecognitionObjectRequest
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
    ];
    
    NSArray* responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseXMLSerializerBlock,
        QCloudResponseObjectSerilizerBlock([QCloudGetRecognitionObjectResult class])
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];
    
    requestSerializer.HTTPMethod = @"get";
}



- (BOOL) buildRequestData:(NSError *__autoreleasing *)error
{
    if (![super buildRequestData:error]) {
        return NO;
    }
    if (self.responseContentType) {
        [self.requestData setValue:self.responseContentType forHTTPHeaderField:@"response-content-type"];
    }
    if (self.responseContentLanguage) {
        [self.requestData setValue:self.responseContentLanguage forHTTPHeaderField:@"response-content-language"];
    }
    if (self.responseContentExpires) {
        [self.requestData setValue:self.responseContentExpires forHTTPHeaderField:@"response-expires"];
    }
    if (self.responseCacheControl) {
        [self.requestData setValue:self.responseCacheControl forHTTPHeaderField:@"response-cache-control"];
    }
    if (self.responseContentDisposition) {
        [self.requestData setValue:self.responseContentDisposition forHTTPHeaderField:@"response-content-disposition"];
    }
    if (self.responseContentEncoding) {
        [self.requestData setValue:self.responseContentEncoding forHTTPHeaderField:@"response-content-encoding"];
    }
    if (self.localCacheDownloadOffset) {
        self.range = [NSString stringWithFormat:@"bytes=%lld-", self.localCacheDownloadOffset];
    }
    if (self.range) {
        [self.requestData setValue:self.range forHTTPHeaderField:@"Range"];
    }
    if (self.ifModifiedSince) {
        [self.requestData setValue:self.ifModifiedSince forHTTPHeaderField:@"If-Modified-Since"];
    }
    if (self.ifUnmodifiedModifiedSince) {
        [self.requestData setValue:self.ifUnmodifiedModifiedSince forHTTPHeaderField:@"If-Unmodified-Since"];
    }
    if (self.ifMatch) {
        [self.requestData setValue:self.ifMatch forHTTPHeaderField:@"If-Match"];
    }
    if (self.ifNoneMatch) {
        [self.requestData setValue:self.ifNoneMatch forHTTPHeaderField:@"If-None-Match"];
    }
    [self.requestData setParameter:self.versionID withKey:@"versionId"];
    
    
    if (!self.object || ([self.object isKindOfClass:NSString.class] && ((NSString*)self.object).length == 0)) {
        if (error != NULL) {
            *error = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid message:[NSString stringWithFormat:@"InvalidArgument:paramter[object] is invalid (nil), it must have some value. please check it"]];
            return NO;
        }
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
    
    [self.requestData setQueryStringParamter:@"sensitive-content-recognition" withKey:@"ci-process"];
    
    if ([self getDetectType].length == 0) {
        if (error != NULL) {
            *error = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid message:[NSString stringWithFormat:@"InvalidArgument:paramter[detect-type] is invalid (nil), it must have some value. please check it"]];
            return NO;
        }
    }
    
    [self.requestData setQueryStringParamter:[self getDetectType] withKey:@"detect-type"];
    
    NSMutableArray* __pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    if(self.object) [__pathComponents addObject:self.object];
    self.requestData.URIComponents = __pathComponents;
    if (![self customBuildRequestData:error]) return NO;
    for (NSString* key  in self.customHeaders.allKeys.copy) {
        [self.requestData setValue:self.customHeaders[key] forHTTPHeaderField:key];
    }
    return YES;
}

- (void) setFinishBlock:(void(^_Nullable)(QCloudGetRecognitionObjectResult* _Nullable result, NSError* _Nullable error))finishBlock{
    [super setFinishBlock:finishBlock];
}

- (QCloudSignatureFields*) signatureFields
{
    QCloudSignatureFields* fileds = [QCloudSignatureFields new];
    
    return fileds;
}
-(NSArray<NSMutableDictionary *> *)scopesArray{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSArray *separatetmpArray = [self.requestData.serverURL componentsSeparatedByString:@"://"];
    NSString *str = separatetmpArray[1];
    NSArray *separateArray = [str  componentsSeparatedByString:@"."];
    dic[@"bucket"] = separateArray[0];
    dic[@"region"] = self.runOnService.configuration.endpoint.regionName;
    dic[@"prefix"] = self.object;
    dic[@"action"] =  @"name/cos:GetObject";
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:dic];
    return [array copy];
}

-(NSString *)getDetectType{
    NSMutableArray * detecyTypes = [NSMutableArray arrayWithCapacity:0];
    if (_detectType & QCloudRecognitionPorn) {
        [detecyTypes addObject:@"porn"];
    }
    
    if (_detectType & QCloudRecognitionTerrorist) {
        [detecyTypes addObject:@"terrorist"];
    }
    
    if (_detectType & QCloudRecognitionPolitics) {
        [detecyTypes addObject:@"politics"];
    }
    
    if (_detectType & QCloudRecognitionAds) {
        [detecyTypes addObject:@"ads"];
    }
    
    return [detecyTypes componentsJoinedByString:@","];
}

@end
NS_ASSUME_NONNULL_END
