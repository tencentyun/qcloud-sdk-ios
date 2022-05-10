//
//  QCloudGCDTimer.h
//  AOPKit
//
//  Created by karisli(李雪) on 2021/8/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QCloudGCDTimer : NSObject

/**
 Block方式的定时器
 
 @param task 任务（这里使用block）
 @param start 开始时间
 @param interval 间隔
 @param repeats 时候否重复调用
 @param async 是否子线程
 @return 定时器标识（最终取消定时器是需要根据此标识取消的）
 */
+ (NSString* _Nullable)timerTask:(void(^)(void))task
                 start:(NSTimeInterval) start
              interval:(NSTimeInterval) interval
               repeats:(BOOL) repeats
                  async:(BOOL)async;

/**
 Target方式的定时器
 
 @param target 目标对象（这里使用方法）
 @param selector 调用方法
 @param start 开始时间
 @param interval 间隔
 @param repeats 是否重复调用
 @param async 是否子线程
 @return 定时其标识（最终取消定时器是需要根据此标识取消的）
 */
+ (NSString* _Nullable)timerTask:(id)target
              selector:(SEL)selector
                 start:(NSTimeInterval)start
              interval:(NSTimeInterval)interval
               repeats:(BOOL)repeats
                 async:(BOOL)async;

/**
 取消定时器
 
 @param timerName 定时器标识
 */
+(void)canelTimer:(NSString*) timerName;

NS_ASSUME_NONNULL_END
@end
