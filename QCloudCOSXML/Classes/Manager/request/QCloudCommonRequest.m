//
//  QCloudCommonRequest.m
//  QCloudCommonRequest
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

#import "QCloudCommonRequest.h"
#import <QCloudCore/QCloudSignatureFields.h>
#import <QCloudCore/QCloudCore.h>
#import <QCloudCore/QCloudConfiguration_Private.h>

NS_ASSUME_NONNULL_BEGIN
@implementation QCloudCommonRequest

- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSMutableArray *customRequestSerilizers = [NSMutableArray new];
    [customRequestSerilizers addObject:QCloudURLFuseURIMethodASURLParamters];
    if (self.requestContentType == QCloudContentXML) {
        [customRequestSerilizers addObject:QCloudURLFuseWithXMLParamters];
    }
    if (self.requestContentType == QCloudContentJSON) {
        [customRequestSerilizers addObject:QCloudURLFuseWithJSONParamters];
    }
    [customRequestSerilizers addObject:QCloudURLFuseContentMD5Base64StyleHeaders];
    
    NSMutableArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
    ].mutableCopy;
    
    if (self.responseContentType == QCloudContentXML) {
        [responseSerializers addObject:QCloudResponseXMLSerializerBlock];
    }
    
    if (self.responseContentType == QCloudContentJSON) {
        [responseSerializers addObject:QCloudResponseJSONSerilizerBlock];
    }
    
    if (self.responseContentClass) {
        QCloudResponseObjectSerilizerBlock(self.responseContentClass);
    }
    
    [requestSerializer setSerializerBlocks:customRequestSerilizers.copy];
    [responseSerializer setSerializerBlocks:responseSerializers.copy];
    if (!self.method) {
        self.method = @"get";
    }
    requestSerializer.HTTPMethod = self.method;
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {return NO;}
    self.requestData.needChangeHost = NO;
    self.requestData.serverURL = self.URL;
    
    [self.requestData setValue:[NSURL URLWithString:self.URL].host forHTTPHeaderField:@"Host"];

    [self.customHeaders enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self.requestData setValue:obj forHTTPHeaderField:key];
    }];
    
    [self.headers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        [self.requestData setValue:obj forHTTPHeaderField:key];
    }];
    
    [self.queries enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        [self.requestData setQueryStringParamter:obj withKey:key];
    }];

    if (self.responseContentType != QCloudContentStream) {
        self.requestData.directBody = [self.body qcloud_modelToJSONData];
    }else{
        self.requestData.directBody = self.body;
    }
    
    return YES;
}
- (void)setFinishBlock:(void (^_Nullable)( id _Nullable result, NSError *_Nullable error))finishBlock{
    [super setFinishBlock:finishBlock];
}
@end


NS_ASSUME_NONNULL_END
