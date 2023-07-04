//
// QCloudGetListWorkflowRequest.m
//
//  Created by tencent
//  Copyright (c) 2020年 tencent. All rights reserved.

#import "QCloudGetListWorkflowRequest.h"

NS_ASSUME_NONNULL_BEGIN

@implementation QCloudGetListWorkflowRequest

- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseURIMethodASURLParamters,
    ];
    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseXMLSerializerBlock,
        QCloudResponseObjectSerilizerBlock([QCloudListWorkflow class])
    ];
    [requestSerializer setSerializerBlocks:customRequestSerilizers];
    [responseSerializer setSerializerBlocks:responseSerializers];
    requestSerializer.HTTPMethod = @"get";
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
    [__pathComponents addObject:@"workflow"];
    if (self.ids) {
        [self.requestData setQueryStringParamter:self.ids withKey:@"ids"];
    }
    if (self.name) {
        [self.requestData setQueryStringParamter:self.name withKey:@"name"];
    }
    if (self.pageNumber) {
        [self.requestData setQueryStringParamter:self.pageNumber withKey:@"pageNumber"];
    }
    if (self.pageSize) {
        [self.requestData setQueryStringParamter:self.pageSize withKey:@"pageSize"];
    }
    self.requestData.URIComponents = __pathComponents;
    return YES;
}
- (void)setFinishBlock:(void (^_Nullable)(QCloudListWorkflow * _Nullable result, NSError *_Nullable error))finishBlock{
    [super setFinishBlock:finishBlock];
}
@end

NS_ASSUME_NONNULL_END
