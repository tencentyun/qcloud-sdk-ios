//
//  QCloudHTTPRequestOperation.m
//  Pods
//
//  Created by Dong Zhao on 2017/4/14.
//
//

#import "QCloudHTTPRequestOperation.h"
#import "QCloudHTTPRequest.h"
#import "QCloudNetEnv.h"
#import "QCloudHttpDNS.h"
#import "QCloudHTTPSessionManager_Private.h"
#import "QCloudHTTPSessionManager.h"
#import "QCloudURLSessionTaskData.h"
#import "QCloudHTTPRetryHanlder.h"
#import "QCloudLogger.h"
#import "NSError+QCloudNetworking.h"
#import <objc/runtime.h>
#import "QCloudFileUtils.h"
#import "NSError+QCloudNetworking.h"
#import "QCloudFileOffsetBody.h"
#import "NSError+QCloudNetworking.h"

@interface QCloudHTTPRequestOperation ()
@property (nonatomic, strong, readonly) QCloudHTTPRequest* httpRequest;
@property (nonatomic, strong) NSString* tempFilePath;
@end

@implementation QCloudHTTPRequestOperation

- (void) dealloc
{
    QCloudRemoveFileByPath(self.tempFilePath);
}
- (QCloudHTTPRequest*) httpRequest
{
    return (QCloudHTTPRequest*)self.request;
}

- (void) main
{
    @autoreleasepool {
        QCloudRequestFinishBlock originFinishBlock = self.httpRequest.finishBlock;
        if (self.httpRequest.canceled) {
            QCloudRemoveFileByPath(self.tempFilePath);
            if ([self.delagte respondsToSelector:@selector(requestOperationFinish:)]) {
                [self.delagte requestOperationFinish:self];
            }
            if (originFinishBlock) {
                NSError* cancel = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeCanceled message:@"UserCancelled:已经取消了，不再执行"];
                originFinishBlock(nil, cancel);
            }
            return;
        }
        __weak typeof(self) weakSelf = self;
        [self.httpRequest setFinishBlock:^(id outputObject, NSError *error) {
            QCloudRemoveFileByPath(weakSelf.tempFilePath);
            if ([weakSelf.delagte respondsToSelector:@selector(requestOperationFinish:)]) {
                [weakSelf.delagte requestOperationFinish:weakSelf];
            }
            if (originFinishBlock) {
                originFinishBlock(outputObject, error);
            }
        }];
        
        QCloudLogDebug(@"开始执行一个请求:%lld", self.httpRequest.requestID);
       [[QCloudHTTPSessionManager shareClient] executeRestHTTPReqeust:self.httpRequest];
    }
}
@end
