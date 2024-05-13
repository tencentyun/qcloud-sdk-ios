//
//  QCloudBatchimageRecognitionRequest.m
//  QCloudBatchimageRecognitionRequest
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

#import "QCloudBatchimageRecognitionRequest.h"
#import <QCloudCore/QCloudSignatureFields.h>
#import <QCloudCore/QCloudCore.h>
#import <QCloudCore/QCloudServiceConfiguration_Private.h>
#import "QCloudBatchImageRecognitionResult.h"

NS_ASSUME_NONNULL_BEGIN
@implementation QCloudBatchimageRecognitionRequest
- (void)dealloc {
}
- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.callbackType = 1;
    self.politicsScore = -1;
    self.terrorismScore = -1;
    self.adsScore = -1;
    self.pornScore = -1;
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
        QCloudResponseObjectSerilizerBlock([QCloudBatchImageRecognitionResult class])
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"post";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }

    for (QCloudBatchRecognitionImageInfo * info in self.input) {
        if (!info.Object && !info.Url && !info.Content ) {
            if (error != NULL) {
                *error = [NSError
                    qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                                 message:[NSString stringWithFormat:
                                                       @"InvalidArgument:paramter[object,url or Content] is invalid (nil), it must have some value. please check it"]];
                return NO;
            }
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
    
    NSMutableArray * inputs = [NSMutableArray new];
    for (QCloudBatchRecognitionImageInfo * info in self.input) {
        NSMutableDictionary * infoDic = [NSMutableDictionary new];
        if(info.Url){
            [infoDic setObject:info.Url forKey:@"Url"];
        }
        if(info.Object){
            [infoDic setObject:info.Object forKey:@"Object"];
        }
        
        if(info.Content){
            [infoDic setObject:info.Content forKey:@"Content"];
        }
        
        if(info.Interval > 0){
            [infoDic setObject:@(info.Interval) forKey:@"Interval"];
        }
        
        if(info.MaxFrames > 0){
            [infoDic setObject:@(info.MaxFrames) forKey:@"MaxFrames"];
        }
        
        if(info.LargeImageDetect > 0){
            [infoDic setObject:@(info.LargeImageDetect) forKey:@"LargeImageDetect"];
        }
        
        if(info.DataId){
            [infoDic setObject:info.DataId forKey:@"DataId"];
        }
        
        if(info.UserInfo > 0){
            [infoDic setObject:[info.UserInfo qcloud_modelToJSONObject] forKey:@"UserInfo"];
        }
        
        if(info.Encryption > 0){
            [infoDic setObject:[info.Encryption qcloud_modelToJSONObject] forKey:@"Encryption"];
        }
        [inputs addObject:infoDic];
    }
    
    
    NSMutableDictionary * conf = NSMutableDictionary.new;
    if(self.bizType){
        [conf addEntriesFromDictionary:@{@"BizType":self.bizType}];
    }
    [conf addEntriesFromDictionary:@{@"Async":@(self.async).stringValue}];
    
    if(self.callback){
        [conf addEntriesFromDictionary:@{@"Callback":self.callback}];
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
        @"Input":inputs,
        @"Conf":conf
    };
    
    [self.requestData setParameter:params withKey:@"Request"];

    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    [__pathComponents addObject:@"image/auditing"];
    self.requestData.URIComponents = __pathComponents;

    return YES;
}

- (void)setFinishBlock:(void (^_Nullable)(QCloudBatchImageRecognitionResult *_Nullable result, NSError *_Nullable error))finishBlock {
    [super setFinishBlock:finishBlock];
}

- (QCloudSignatureFields *)signatureFields {
    QCloudSignatureFields *fileds = [QCloudSignatureFields new];

    return fileds;
}

@end
NS_ASSUME_NONNULL_END
