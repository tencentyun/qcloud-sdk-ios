//
//  QCloudHTTPRetryHanlder.h
//  QCloudNetworking
//
//  Created by tencent on 16/2/24.
//  Copyright © 2016年 QCloudTernimalLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QCloudURLSessionTaskData.h"
typedef void (^QCloudHTTPRetryFunction)(void);
@protocol QCloudHttpRetryHandlerProtocol <NSObject>

- (BOOL)shouldRetry:(QCloudURLSessionTaskData *)task error:(NSError *)error;

@end

// 配置全局重试策略。
// 开启： openConfig = YES; 并设置 maxCount & sleepStep。
// 关闭： openConfig = NO;
@interface QCloudHTTPRetryConfig : NSObject

@property (nonatomic, assign) NSInteger maxCount;

@property (nonatomic, assign) NSTimeInterval sleepStep;

// 默认未开启，使用 QCloudHTTPRetryHanlder 中的 maxCount&sleepStep。
@property (nonatomic, assign) BOOL openConfig;

+ (QCloudHTTPRetryConfig *)globalRetryConfig;

@end

@interface QCloudHTTPRetryHanlder : NSObject {
@protected
    NSSet *_errorCode;
}
+ (QCloudHTTPRetryHanlder *)defaultRetryHandler;

@property (nonatomic, weak) id<QCloudHttpRetryHandlerProtocol> delegate;

// 默认使用 QCloudHTTPRetryConfig.maxCount; 默认值 3
@property (nonatomic, assign) NSInteger maxCount;
/**
   sleeptime = sleepStep * 1^2 ，
 */
// 默认使用 QCloudHTTPRetryConfig.sleepStep; 默认值 1
@property (nonatomic, assign) NSTimeInterval sleepStep;
- (instancetype)initWithMaxCount:(NSInteger)maxCount sleepTime:(NSTimeInterval)sleepStep;

/**
   try to exe fuction if it can be retry
      @param function the function to exe when satify the args
   @param error    the error occur , it contains the args that will be used to judge retrying
      @return if it can be retry then return YES, otherwise return NO;
 */
- (BOOL)retryFunction:(QCloudHTTPRetryFunction)function whenError:(NSError *)error;

- (void)reset;
@end
