//
//  UploadPartRequestRetryHandler.m
//  Pods
//
//  Created by erichmzhang(张恒铭) on 2017/7/21.
//
//

#import "QCloudUploadPartRequestRetryHandler.h"

@implementation QCloudUploadPartRequestRetryHandler

- (instancetype)initWithMaxCount:(NSInteger)maxCount sleepTime:(NSTimeInterval)sleepStep {
    self = [super initWithMaxCount:maxCount sleepTime:sleepStep];
    _errorCode = [NSSet setWithObjects:
                  @(kCFURLErrorTimedOut),
                  @(kCFURLErrorNetworkConnectionLost),
                  @(kCFURLErrorNotConnectedToInternet),
                  @(kCFURLErrorCannotConnectToHost),
                  nil];
    return self;
}
@end
