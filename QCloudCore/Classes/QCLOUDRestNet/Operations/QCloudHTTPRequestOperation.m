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
        
        [[QCloudHTTPSessionManager shareClient] executeRestHTTPReqeust:self.httpRequest];
        
    }
}
@end
