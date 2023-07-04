//
//  QCloudRecognitionBadCaseRequest.m
//  QCloudRecognitionBadCaseRequest
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








#import "QCloudRecognitionBadCaseRequest.h"
#import <QCloudCore/QCloudSignatureFields.h>
#import <QCloudCore/QCloudCore.h>


NS_ASSUME_NONNULL_BEGIN
@implementation QCloudRecognitionBadCaseRequest

- (void) configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer  responseSerializer:(QCloudResponseSerializer *)responseSerializer
{
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseURIMethodASURLParamters,
        QCloudURLFuseWithXMLParamters,
        QCloudURLFuseContentMD5Base64StyleHeaders,
    ];

    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseXMLSerializerBlock,
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];

    requestSerializer.HTTPMethod = @"post";
}


- (BOOL) buildRequestData:(NSError *__autoreleasing *)error{
    if (![super buildRequestData:error]) {
        return NO;
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
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    
    if(self.contentType != 0){
        [params addEntriesFromDictionary:@{@"ContentType":@(self.contentType).stringValue}];
    }
    
    if(self.text){
        [params addEntriesFromDictionary:@{@"Text":self.text}];
    }
    
    if(self.url){
        [params addEntriesFromDictionary:@{@"Url":self.url}];
    }
    
    if(self.label){
        [params addEntriesFromDictionary:@{@"Label":self.label}];
    }
    
    if(self.suggestedLabel){
        [params addEntriesFromDictionary:@{@"SuggestedLabel":self.suggestedLabel}];
    }
    
    if(self.jobId){
        [params addEntriesFromDictionary:@{@"JobId":self.jobId}];
    }
    
    if(self.moderationTime){
        [params addEntriesFromDictionary:@{@"ModerationTime":self.moderationTime}];
    }
    
    
    [self.requestData setParameter:params withKey:@"Request"];

    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    [__pathComponents addObject:@"report/badcase"];
    self.requestData.URIComponents = __pathComponents;

    return YES;
}

@end
NS_ASSUME_NONNULL_END
