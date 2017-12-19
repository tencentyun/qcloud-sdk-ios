//
//  QCloudUploadObjectMultiSliceOperation.m
//  Pods
//
//  Created by Dong Zhao on 2017/4/14.
//
//

#import "QCloudUploadObjectMultiSliceOperation.h"
#import "QCloudUploadObjectRequest.h"
#import "QCloudNetEnv.h"
@interface QCloudUploadObjectRequest ()
- (void) start;
@end

@interface QCloudUploadObjectMultiSliceOperation ()
@property (nonatomic, strong,readonly) QCloudUploadObjectRequest* multiSliceRequest;
@end
@implementation QCloudUploadObjectMultiSliceOperation

- (QCloudUploadObjectRequest*) multiSliceRequest
{
    return (QCloudUploadObjectRequest*) self.request;
}
- (void) main
{
    @autoreleasepool {
        QCloudRequestFinishBlock originFinishBlock = self.multiSliceRequest.finishBlock;
        
        __weak typeof(self) weakSelf = self;
        [self.multiSliceRequest setFinishBlock:^(id outputObject, NSError *error) {
            if ([weakSelf.delagte respondsToSelector:@selector(requestOperationFinish:)]) {
                [weakSelf.delagte requestOperationFinish:weakSelf];
            }
            if (originFinishBlock) {
                originFinishBlock(outputObject, error);
            }
        }];
        
        
        if (![[QCloudNetEnv shareEnv] isReachable] ) {
            NSError* nonetwork = [NSError errorWithDomain:@"com.tencent.qcloud.networ.error" code:-222 userInfo:@{NSLocalizedDescriptionKey:@"当前无网络连接"}] ;
            [self.multiSliceRequest onError:nonetwork];
            return;
        }
        [self.multiSliceRequest start];
    }
}
@end
