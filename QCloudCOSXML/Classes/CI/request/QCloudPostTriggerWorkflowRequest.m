//
// QCloudPostTriggerWorkflowRequest.m
//
//  Created by tencent
//  Copyright (c) 2020年 tencent. All rights reserved.

#import "QCloudPostTriggerWorkflowRequest.h"

NS_ASSUME_NONNULL_BEGIN

@implementation QCloudPostTriggerWorkflowRequest

- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseURIMethodASURLParamters,
    ];
    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseXMLSerializerBlock,
        QCloudResponseObjectSerilizerBlock([QCloudTriggerWorkflow class])
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];
    requestSerializer.HTTPMethod = @"post";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {return NO;}
    NSURL *__serverURL = [self.runOnService.configuration.endpoint serverURLWithBucket:self.bucket appID:self.runOnService.configuration.appID regionName:self.regionName];
    NSString * serverUrlString = __serverURL.absoluteString;
    serverUrlString = [serverUrlString stringByReplacingOccurrencesOfString:@".cos." withString:@".ci."];
    __serverURL = [NSURL URLWithString:serverUrlString];
    self.requestData.serverURL = __serverURL.absoluteString;
    [self.requestData setValue:__serverURL.host forHTTPHeaderField:@"Host"];
    NSMutableArray *__pathComponents = [NSMutableArray arrayWithArray:self.requestData.URIComponents];
    [__pathComponents addObject:@"triggerworkflow"];
    self.requestData.URIComponents = __pathComponents;
    if (self.workflowId) {
        [self.requestData setQueryStringParamter:self.workflowId withKey:@"workflowId"];
    }
    if (self.object) {
        [self.requestData setQueryStringParamter:QCloudURLEncodeUTF8(self.object) withKey:@"object"];
    }
    if (self.name) {
        [self.requestData setQueryStringParamter:QCloudURLEncodeUTF8(self.name) withKey:@"name"];
    }
    return YES;
}
- (void)setFinishBlock:(void (^_Nullable)(QCloudTriggerWorkflow * _Nullable result, NSError *_Nullable error))finishBlock{
    [super setFinishBlock:finishBlock];
}
@end

NS_ASSUME_NONNULL_END
