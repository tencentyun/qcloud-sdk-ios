//
//  QCloudBatchGetAudioDiscernTaskRequest.m
//  QCloudBatchGetAudioDiscernTaskRequest
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

#import "QCloudBatchGetAudioDiscernTaskRequest.h"
#import <QCloudCore/QCloudSignatureFields.h>
#import <QCloudCore/QCloudCore.h>
#import <QCloudCore/QCloudServiceConfiguration_Private.h>


NS_ASSUME_NONNULL_BEGIN
@implementation QCloudBatchGetAudioDiscernTaskRequest
- (void)dealloc {
}
- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.states = QCloudTaskStatesAll;
    return self;
}
- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseURIMethodASURLParamters,
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseXMLSerializerBlock,
        QCloudResponseObjectSerilizerBlock([QCloudBatchGetAudioDiscernTaskResult class])
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"get";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    
    if (!self.tag) {
        if (error != NULL) {
            *error = [NSError
                      qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                      message:[NSString stringWithFormat:
                               @"InvalidArgument:paramter[tag] is invalid (nil), it must have some value. please check it"]];
            return NO;
        }
    }
    
    
    NSURL *__serverURL = [self.runOnService.configuration.endpoint serverURLWithBucket:self.bucket
                                                                                 appID:self.runOnService.configuration.appID
                                                                            regionName:self.regionName];
    
    NSString * serverUrlString = __serverURL.absoluteString;
    
    serverUrlString = [serverUrlString stringByReplacingOccurrencesOfString:@".cos." withString:@".ci."];
    
    __serverURL = [NSURL URLWithString:serverUrlString];
    
    self.requestData.serverURL = __serverURL.absoluteString;
    [self.requestData setValue:__serverURL.host forHTTPHeaderField:@"Host"];
    
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    [__pathComponents addObject:@"asr_jobs"];
    self.requestData.URIComponents = __pathComponents;
    if(self.queueId){
        [self.requestData setQueryStringParamter:self.queueId withKey:@"queueId"];
    }

    [self.requestData setQueryStringParamter:self.tag withKey:@"tag"];
    
    [self.requestData setQueryStringParamter:(self.orderByTime == 0 ? @"Desc" : @"Asc") withKey:@"orderByTime"];
    
    if (self.size) {
        [self.requestData setQueryStringParamter:@(self.size).stringValue withKey:@"size"];
    }
    
    if (self.nextToken) {
        [self.requestData setQueryStringParamter:self.nextToken withKey:@"nextToken"];
    }
    
    [self.requestData setQueryStringParamter:QCloudRecognitionEnumTransferToString(self.states) withKey:@"states"];
    
    if (self.startCreationTime) {
        [self.requestData setQueryStringParamter:self.startCreationTime withKey:@"startCreationTime"];
    }
    
    if (self.endCreationTime) {
        [self.requestData setQueryStringParamter:self.endCreationTime withKey:@"endCreationTime"];
    }
    
    return YES;
}

- (void)setFinishBlock:(void (^_Nullable)(QCloudBatchGetAudioDiscernTaskResult *_Nullable result, NSError *_Nullable error))finishBlock {
    [super setFinishBlock:finishBlock];
}

- (QCloudSignatureFields *)signatureFields {
    QCloudSignatureFields *fileds = [QCloudSignatureFields new];

    return fileds;
}

@end
NS_ASSUME_NONNULL_END
