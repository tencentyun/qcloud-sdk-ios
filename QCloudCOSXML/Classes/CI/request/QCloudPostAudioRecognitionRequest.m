//
//  QCloudPostAudioRecognitionRequest.m
//  QCloudPostAudioRecognitionRequest
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

#import "QCloudPostAudioRecognitionRequest.h"
#import <QCloudCore/QCloudSignatureFields.h>
#import <QCloudCore/QCloudCore.h>
#import <QCloudCore/QCloudServiceConfiguration_Private.h>


NS_ASSUME_NONNULL_BEGIN
@implementation QCloudPostAudioRecognitionRequest
- (void)dealloc {
}
- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.politicsScore = -1;
    self.terrorismScore = -1;
    self.adsScore = -1;
    self.pornScore = -1;
    self.callbackType = 1;
    return self;
}
- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseURIMethodASURLParamters,
        QCloudURLFuseWithXMLParamters,
        QCloudURLFuseContentMD5Base64StyleHeaders,
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseXMLSerializerBlock,
        QCloudResponseObjectSerilizerBlock([QCloudPostAudioRecognitionResult class])
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"post";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }

    if (!self.object && !self.url) {
        if (error != NULL) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[object and url] is invalid (nil), it must have some value. please check it"]];
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
    
    NSString * serverUrlString = __serverURL.absoluteString;
    
    serverUrlString = [serverUrlString stringByReplacingOccurrencesOfString:@".cos." withString:@".ci."];
    
    __serverURL = [NSURL URLWithString:serverUrlString];
    
    self.requestData.serverURL = __serverURL.absoluteString;
    [self.requestData setValue:__serverURL.host forHTTPHeaderField:@"Host"];

    NSMutableDictionary * input = NSMutableDictionary.new;
    if (self.object) {
        [input setObject:self.object forKey:@"Object"];
    }else if (self.url) {
        [input setObject:self.url forKey:@"Url"];
    }
    if (self.dataId) {
        [input setObject:self.dataId forKey:@"DataId"];
    }
    
    if (self.userInfo) {
        [input setObject:[self.userInfo qcloud_modelToJSONData] forKey:@"UesrInfo"];
    }
    
    NSMutableDictionary * conf = @{
    }.mutableCopy;
    
    if(self.callback){
        [conf setObject:self.callback forKey:@"Callback"];
    }
    
    if(self.bizType){
        [conf setObject:self.bizType forKey:@"BizType"];
    }
    
    [conf addEntriesFromDictionary:@{@"CallbackVersion":@"Detail"}];
    
    if(self.callbackType){
        [conf addEntriesFromDictionary:@{@"CallbackType":@(self.callbackType).stringValue}];
    }
    
    NSMutableDictionary * freeze = [NSMutableDictionary new];
    if(self.pornScore > -1){
        [freeze setObject:@(self.pornScore).stringValue forKey:@"PornScore"];
    }
    
    if(self.adsScore > -1){
        [freeze setObject:@(self.adsScore).stringValue forKey:@"AdsScore"];
    }
    
    if(self.terrorismScore > -1){
        [freeze setObject:@(self.terrorismScore).stringValue forKey:@"TerrorismScore"];
    }
    
    if(self.politicsScore > -1){
        [freeze setObject:@(self.politicsScore).stringValue forKey:@"PoliticsScore"];
    }
    
    if(freeze.allKeys.count > 0){
        [conf addEntriesFromDictionary:@{@"Freeze":freeze}];
    }
    
    
    NSDictionary * params =@{
        @"Input":input.copy,
        @"Conf":conf
    };
    
    [self.requestData setParameter:params withKey:@"Request"];

    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    [__pathComponents addObject:@"audio/auditing"];
    self.requestData.URIComponents = __pathComponents;

    return YES;
}

- (void)setFinishBlock:(void (^_Nullable)(QCloudPostAudioRecognitionResult *_Nullable result, NSError *_Nullable error))finishBlock {
    [super setFinishBlock:finishBlock];
}

- (QCloudSignatureFields *)signatureFields {
    QCloudSignatureFields *fileds = [QCloudSignatureFields new];
    return fileds;
}
@end
NS_ASSUME_NONNULL_END
