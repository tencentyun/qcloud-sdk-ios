//
//  QCloudBizHTTPRequest+COSXML.m
//  QCloudCOSXML
//
//  Created by garenwang on 2025/3/28.
//

#import "QCloudBizHTTPRequest+COSXML.h"
#import <QCloudCore/QCloudHTTPRetryHanlder.h>
#import "QCloudCOSXMLEndPoint.h"
@implementation QCloudBizHTTPRequest (COSXML)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        SEL originalSelector = @selector(buildRequestData:);
        SEL swizzledSelector = @selector(cos_buildRequestData:);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        BOOL didAddMethod
            = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (BOOL)cos_buildRequestData:(NSError *__autoreleasing *)error{
    BOOL ret = [self cos_buildRequestData:error];
    
    if (!ret) {
        return ret;
    }
    if (self.runOnService.configuration.networkStrategy != QCloudRequestNetworkStrategyDefault){
        NSString * bucket = nil;
        if ([self respondsToSelector:@selector(bucket)]) {
            bucket = [self performSelector:@selector(bucket)];
        }else if ([self respondsToSelector:@selector(bucketName)]) {
            bucket = [self performSelector:@selector(bucketName)];
        }else if ([self respondsToSelector:@selector(BucketName)]) {
            bucket = [self performSelector:@selector(BucketName)];
        }
        
        NSString * appId = self.runOnService.configuration.appID;
        
        NSString * regionName = self.regionName;
        if (!regionName) {
            regionName = self.runOnService.configuration.endpoint.regionName;
        }
        BOOL useHTTPS = self.runOnService.configuration.endpoint.useHTTPS;
        if (self.endpoint) {
            useHTTPS = self.endpoint.useHTTPS;
        }
    
        if (self.requestRetry) {
            if (self.runOnService.configuration.networkStrategy == QCloudRequestNetworkStrategyConservative){
                if (self.networkType != QCloudRequestNetworkNone) {
                    self.enableQuic = self.networkType == QCloudRequestNetworkQuic;
                }else {
                    self.enableQuic = self.runOnService.configuration.enableQuic;
                }
                if (self.endpoint) {
                    self.requestData.endpoint = self.endpoint;
                }else{
                    self.requestData.endpoint = self.runOnService.configuration.endpoint;
                }
                
            }else if (self.runOnService.configuration.networkStrategy == QCloudRequestNetworkStrategyAggressive){
                self.enableQuic = NO;
                QCloudCOSXMLEndPoint * endpoint = [[QCloudCOSXMLEndPoint alloc]init];
                endpoint.useHTTPS = useHTTPS;
                endpoint.regionName = regionName;
                self.requestData.endpoint = endpoint;
            }
        }else{
            if (self.runOnService.configuration.networkStrategy == QCloudRequestNetworkStrategyConservative){
                self.enableQuic = NO;
                QCloudCOSXMLEndPoint * endpoint = [[QCloudCOSXMLEndPoint alloc]init];
                endpoint.useHTTPS = useHTTPS;
                endpoint.regionName = regionName;
                self.requestData.endpoint = endpoint;
            }else if (self.runOnService.configuration.networkStrategy == QCloudRequestNetworkStrategyAggressive){
                
                if (self.networkType != QCloudRequestNetworkNone) {
                    self.enableQuic = self.networkType == QCloudRequestNetworkQuic;
                }else {
                    self.enableQuic = self.runOnService.configuration.enableQuic;
                }
                
                if (self.endpoint) {
                    self.requestData.endpoint = self.endpoint;
                }else{
                    self.requestData.endpoint = self.runOnService.configuration.endpoint;
                }
            }
        }
    
        self.requestData.bucket = bucket;
        self.requestData.appId = appId;
        self.requestData.region = regionName;
    }
    QCloudLogDebugP(@"HTTP",@"buildRequestData——当前策略：%@，是否已重试：%@", QCloudNetworkSituationToString(self.runOnService.configuration.networkStrategy),self.requestRetry?@"是":@"否");
    return YES;
}

- (void)notifyError:(NSError *)error {
    QCloudRequestFinishBlock finishBlock = self.finishBlock;
    BOOL is4XX = error.code >= 400 && error.code <500;
    QCloudLogDebugP(@"HTTP",@"notifyError——当前策略：%@，是否已重试：%@", QCloudNetworkSituationToString(self.runOnService.configuration.networkStrategy),self.requestRetry?@"是":@"否");
    
    if (is4XX || self.runOnService.configuration.networkStrategy == QCloudRequestNetworkStrategyDefault ||
        self.requestRetry ) {
        [super notifyError:error];
    }else{
        [self.retryPolicy reset];
        [self.requestData clean];
        [self setValue:@(NO) forKey:@"isRetry"];
        self.retryCount = 0;
        self.requestRetry = YES;
        self.finishBlock = finishBlock;
        [self.runOnService requestFinishWithRequestId:self.requestID];
        self.priority = QCloudAbstractRequestPriorityHigh;
        [self.runOnService performRequest:self];
    }
}
@end
