//
// QCloudPostMediaJobsRequest.m
//
//  Created by tencent
//  Copyright (c) 2020年 tencent. All rights reserved.

#import "QCloudPostMediaJobsRequest.h"

NS_ASSUME_NONNULL_BEGIN

@implementation QCloudPostMediaJobsRequest

- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *customRequestSerilizers = @[
        QCloudURLFuseURIMethodASURLParamters,
        QCloudURLFuseWithXMLParamters,
        QCloudURLFuseContentMD5Base64StyleHeaders,
    ];
    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil),
        QCloudResponseXMLSerializerBlock,
        QCloudResponseObjectSerilizerBlock([QCloudMediaJobs class])
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
    [__pathComponents addObject:@"jobs"];
    self.requestData.URIComponents = __pathComponents;
    
    NSMutableDictionary * params = [[self.input qcloud_modelToJSONObject] mutableCopy];
    [params setObject:@"MediaInfo" forKey:@"Tag"];
    [self.requestData setParameter:params withKey:@"Request"];
    
    return YES;
}
- (void)setFinishBlock:(void (^_Nullable)(QCloudMediaJobs * _Nullable result, NSError *_Nullable error))finishBlock{
    [super setFinishBlock:finishBlock];
}
@end



NS_ASSUME_NONNULL_END
