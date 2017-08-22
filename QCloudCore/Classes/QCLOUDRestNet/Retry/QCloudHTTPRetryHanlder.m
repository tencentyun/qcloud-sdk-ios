//
//  QCloudHTTPRetryHanlder.m
//  QCloudNetworking
//
//  Created by tencent on 16/2/24.
//  Copyright © 2016年 QCloudTernimalLab. All rights reserved.
//

#import "QCloudHTTPRetryHanlder.h"
#import "QCloudLogger.h"
@interface QCloudHTTPRetryHanlder()
@property (nonatomic,strong) NSSet* errorRetryCode;
@end

@implementation QCloudHTTPRetryHanlder
{
    int _currentTryCount;
//    NSSet* _errorRetryCode;
    QCloudHTTPRetryFunction _retryFunction;
}

+ (QCloudHTTPRetryHanlder*) defaultRetryHandler
{
    return [[QCloudHTTPRetryHanlder alloc] initWithMaxCount:0 sleepTime:1];
}
- (instancetype) initWithMaxCount:(NSInteger)maxCount sleepTime:(NSTimeInterval)sleepStep
{
    self = [super init];
    if (!self) {
        return self;
    }
    _maxCount = maxCount;
    _sleepStep = sleepStep;
    _errorCode = [NSSet setWithObjects:@(kCFHostErrorHostNotFound),
                             @(kCFURLErrorDNSLookupFailed),
                       @(kCFSOCKS5ErrorBadState),
                       @(kCFErrorHTTPProxyConnectionFailure),
                       @(kCFErrorHTTPBadProxyCredentials),
                       @(kCFErrorPACFileError),
                       @(kCFErrorPACFileAuth),
                       @(kCFURLErrorCannotConnectToHost),
                       @(kCFURLErrorNetworkConnectionLost),
                       @(kCFURLErrorNotConnectedToInternet),
                       @(kCFURLErrorCallIsActive),
                       @(kCFURLErrorRequestBodyStreamExhausted),
                             nil];
    [self reset];
    return self;
}

- (void) reset
{
    _currentTryCount = 0;
}

- (BOOL) retryFunction:(QCloudHTTPRetryFunction)function whenError:(NSError*)error;
{
    if (!function) {
        return NO;
    }
    if (![self canRetryWhenError:error]) {
        return NO;
    }
    if (function) {
        function();
    }
    _currentTryCount++;
    return YES;
}

- (BOOL) canRetryWhenError:(NSError*)error
{
    
    if (_currentTryCount >= _maxCount) {
        return NO;
    }
    if ([_errorRetryCode  containsObject:@(error.code)]) {
        return YES;
    }
    return NO;
}

@end
