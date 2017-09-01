//
//  QCloudBizHTTPRequest.m
//  Pods
//
//  Created by Dong Zhao on 2017/3/13.
//
//

#import "QCloudBizHTTPRequest.h"
#import "QCloudServiceConfiguration.h"

#import "NSError+QCloudNetworking.h"
#import "QCloudNetResponse.h"
#import "QCloudObjectModel.h"
#import "QCloudSignatureFields.h"
#import "QCloudHTTPSessionManager.h"
#import "QCloudService.h"

NS_ASSUME_NONNULL_BEGIN

QCloudResponseSerializerBlock QCloudResponseObjectSerilizerBlock(Class modelClass) {
    return ^(NSHTTPURLResponse* response,  id inputData, NSError* __autoreleasing* error) {
        if (![inputData isKindOfClass:[NSDictionary class]]){
            if (error != NULL) {
                *error = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeDecodeError message:[NSString stringWithFormat:@"希望获得字典类型数据,但是得到%@", [inputData class]]];
            }
            return (id)nil;
        }
        return [modelClass qcloud_modelWithDictionary:inputData];
    };
}



QCloudResponseSerializerBlock QCloudResponseCOSNormalRSPSerilizerBlock = ^(NSHTTPURLResponse* response,  id inputData, NSError* __autoreleasing* error) {
    NSError* localError;
    QCloudNetResponse* transformData = QCloudResponseObjectSerilizerBlock([QCloudNetResponse class])(response, inputData, &localError);
    if (localError) {
        if (error != NULL) {
            *error = localError;
        }
        return (id)nil;
    }
    if (![transformData isKindOfClass:[QCloudNetResponse class]]) {
        if(error != NULL) {
            *error = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeDecodeError message:[NSString stringWithFormat:@"希望获得QCloudNetResponse类型数据,但是得到%@", inputData]];
        }
        return (id)nil;
    }
    if (transformData.code != 0) {
        if (error != NULL) {
            *error = [NSError qcloud_errorWithCode:transformData.code message:transformData.message];
        }
        return (id)nil;
    }
    return (id)(transformData.data);
};

@implementation QCloudBizHTTPRequest


- (void) loadConfigureBlock
{
    __weak typeof(self) weakSelf = self;
    [self setConfigureBlock:^(QCloudRequestSerializer *requestSerializer, QCloudResponseSerializer *responseSerializer) {
        [weakSelf configureReuqestSerializer:requestSerializer responseSerializer:responseSerializer];
    }];
}

- (void) configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer  responseSerializer:(QCloudResponseSerializer *)responseSerializer
{
    [requestSerializer setSerializerBlocks:[self customRequestSerizliers]];
    [responseSerializer setSerializerBlocks:[self customResponseSerializers]];
}
- (NSArray*) customResponseSerializers
{
    return @[];
}

- (NSArray*)customRequestSerizliers
{
    return @[];
}


- (BOOL) buildRequestData:(NSError *__autoreleasing *)error
{
    BOOL ret = [super buildRequestData:error];
    if (!ret) {
        return ret;
    }
    
    return YES;
}
- (BOOL) customBuildRequestData:(NSError *__autoreleasing *)error
{
    return YES;
}

- (QCloudSignatureFields*) signatureFields
{
    return [QCloudSignatureFields new];
}

- (BOOL) prepareInvokeURLRequest:(NSMutableURLRequest *)urlRequest error:(NSError* __autoreleasing*)error
{
    
    NSAssert(self.runOnService, @"RUN ON SERVICE is nil%@", self.runOnService);
    __block dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block NSError* localError;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self.runOnService loadAuthorizationForBiz:self urlRequest:urlRequest compelete:^(QCloudSignature * _Nonnull signature, NSError * _Nonnull error) {
            if (error) {
                localError = error;
            } else {
                if (signature.signature) {
                    [urlRequest setValue:signature.signature forHTTPHeaderField:@"Authorization"];
                } else {
                    // null authorization
                }
            }
            dispatch_semaphore_signal(semaphore);
        }];
    });

    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    if (localError) {
        if (NULL != error) {
            *error = localError;
        }
        return NO;
    } else {
        return YES;
    }
}
- (void) loadQCloudSignature {
    
}


@end

NS_ASSUME_NONNULL_END
