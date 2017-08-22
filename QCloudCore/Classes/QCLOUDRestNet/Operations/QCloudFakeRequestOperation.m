//
//  QCloudFakeRequestOperation.m
//  Pods
//
//  Created by Dong Zhao on 2017/6/21.
//
//

#import "QCloudFakeRequestOperation.h"
#import "QCloudAbstractRequest_FackRequest.h"
@implementation QCloudFakeRequestOperation
- (void) main
{
    @autoreleasepool {
        QCloudRequestFinishBlock originFinishBlock = self.request.finishBlock;
        
        __weak typeof(self) weakSelf = self;
        [self.request setFinishBlock:^(id outputObject, NSError *error) {
            if ([weakSelf.delagte respondsToSelector:@selector(requestOperationFinish:)]) {
                [weakSelf.delagte requestOperationFinish:weakSelf];
            }
            if (originFinishBlock) {
                originFinishBlock(outputObject, error);
            }
        }];
        [self.request fackStart];
    }
}


@end
