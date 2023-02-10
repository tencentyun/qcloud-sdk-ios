//
//  QCloudSyncImageRecognitionRequest.m
//  QCloudSyncImageRecognitionRequest
//
//  Created by tencent
//  Copyright (c) 2020年 tencent. All rights reserved.
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

#import "QCloudSyncImageRecognitionRequest.h"
#import <QCloudCore/QCloudSignatureFields.h>
#import <QCloudCore/QCloudCore.h>
#import "QCloudImageRecognitionResult.h"
#import <QCloudCore/QCloudConfiguration_Private.h>

NS_ASSUME_NONNULL_BEGIN
@implementation QCloudSyncImageRecognitionRequest
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
        QCloudURLFuseURIMethodASURLParamters,
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseXMLSerializerBlock,
        QCloudResponseObjectSerilizerBlock([QCloudImageRecognitionResult class])
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"get";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    
    NSURL *__serverURL = [self.runOnService.configuration.endpoint serverURLWithBucket:self.bucket
                                                                                 appID:self.runOnService.configuration.appID
                                                                            regionName:self.regionName];
    
    NSString * serverUrlString = __serverURL.absoluteString;
    
    __serverURL = [NSURL URLWithString:serverUrlString];
    
    self.requestData.serverURL = __serverURL.absoluteString;
    [self.requestData setValue:__serverURL.host forHTTPHeaderField:@"Host"];

    [self.requestData setQueryStringParamter:@"sensitive-content-recognition" withKey:@"ci-process"];

    [self.requestData setQueryStringParamter:[self getDetectType] withKey:@"detect-type"];

    if (!self.object && !self.detectUrl) {
        if (error != NULL) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString
                                         stringWithFormat:
                                             @"InvalidArgument:paramter[object or detectUrl] is invalid (nil), it must have some value. please check it"]];
            return NO;
        }
    }
    
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    if (self.object){
        [__pathComponents addObject:self.object];
    }else if (self.detectUrl){
        [self.requestData setQueryStringParamter:self.detectUrl withKey:@"detect-url"];
    }
    
    if (self.interval) {
        [self.requestData setQueryStringParamter:[NSString stringWithFormat:@"%ld",self.interval] withKey:@"interval"];
    }
    
    if (self.maxFrames) {
        [self.requestData setQueryStringParamter:[NSString stringWithFormat:@"%ld",self.maxFrames] withKey:@"max-frames"];
    }
    
    if (self.bizType) {
        [self.requestData setQueryStringParamter:self.bizType withKey:@"biz-type"];
    }
    
    if (self.largeImageDetect) {
        [self.requestData setQueryStringParamter:self.largeImageDetect withKey:@"large-image-detect"];
    }
    
        
    self.requestData.URIComponents = __pathComponents;
    if (![self customBuildRequestData:error])
        return NO;
    for (NSString *key in self.customHeaders.allKeys.copy) {
        [self.requestData setValue:self.customHeaders[key] forHTTPHeaderField:key];
    }

    return YES;
}

- (void)setFinishBlock:(void (^_Nullable)(QCloudImageRecognitionResult *_Nullable result, NSError *_Nullable error))finishBlock {
    [super setFinishBlock:finishBlock];
}

- (QCloudSignatureFields *)signatureFields {
    QCloudSignatureFields *fileds = [QCloudSignatureFields new];

    return fileds;
}

- (NSString *)getDetectType {
    NSMutableArray *detecyTypes = [NSMutableArray arrayWithCapacity:0];
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
    
    if(detecyTypes.count == 0){
        return @"";
    }

    return [detecyTypes componentsJoinedByString:@","];
}
@end
NS_ASSUME_NONNULL_END
