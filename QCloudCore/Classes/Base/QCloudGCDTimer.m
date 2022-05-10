//
//  QCloudGCDTimer.m
//  AOPKit
//
//  Created by karisli(李雪) on 2021/8/2.
//

#import "QCloudGCDTimer.h"
NS_ASSUME_NONNULL_BEGIN
@implementation QCloudGCDTimer

static NSMutableDictionary *timers_;
dispatch_semaphore_t semaphore_;

/**
 load 与 initialize区别，这里选用initialize
 */
+(void)initialize{
    
    //GCD一次性函数
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timers_ = [NSMutableDictionary dictionary];
        semaphore_ = dispatch_semaphore_create(1);
    });
}

+ (NSString* _Nullable)timerTask:(void(^)(void))task
                 start:(NSTimeInterval) start
              interval:(NSTimeInterval) interval
               repeats:(BOOL) repeats
                 async:(BOOL)async{
    
    /**
     对参数做一些限制
     1.如果task不存在，那就没有执行的必要（!task）
     2.开始时间必须大于当前时间
     3.当需要重复执行时，重复间隔时间必须 >0
     以上条件必须满足，定时器才算是比较合理，否则没必要执行
     */
    if (!task || start < 0 || (interval <= 0 && repeats)) {
        
        return nil;
    }
    //if (!task || start < 0 || (interval <= 0 && repeats)) return nil; (上面的代码有人可能会写成这样，都一样，这是if的语法，里面只有一行时候可以省略{}，其他的没区别)
    
    /**
     队列
     asyc：YES 全局队列 dispatch_get_global_queue(0, 0) 可以简单理解为其他线程(非主线程)
     asyc：NO 主队列 dispatch_get_main_queue() 可以理解为主线程
     */
    dispatch_queue_t queue = async ? dispatch_get_global_queue(0, 0) : dispatch_get_main_queue();
    
    /**
     创建定时器 dispatch_source_t timer
     */
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_semaphore_wait(semaphore_, DISPATCH_TIME_FOREVER);
    // 定时器的唯一标识
    NSString *timerName = [NSString stringWithFormat:@"%zd", timers_.count];
    // 存放到字典中
    timers_[timerName] = timer;
    dispatch_semaphore_signal(semaphore_);
    
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        //定时任务
        task();
        //如果不需要重复，执行一次即可
        if (!repeats) {
            
            [self canelTimer:timerName];
        }
    });
    //启动定时器
    dispatch_resume(timer);
    
    return timerName;
}

+ (NSString* _Nullable)timerTask:(id)target
              selector:(SEL)selector
                 start:(NSTimeInterval)start
              interval:(NSTimeInterval)interval
               repeats:(BOOL)repeats
                 async:(BOOL)async{
    
    if (!target || !selector) return nil;
    
    return [self timerTask:^{
        
        if ([target respondsToSelector:selector]) {
            //（这是消除警告的处理）
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [target performSelector:selector];
#pragma clang diagnostic pop
        }
        
    } start:start interval:interval repeats:repeats async:async];
    
    

}

+(void)canelTimer:(NSString*) timerName{
    
    if (timerName.length == 0) {
        
        return;
    }
    
    dispatch_semaphore_wait(semaphore_, DISPATCH_TIME_FOREVER);
    
    dispatch_source_t timer = timers_[timerName];
    if (timer) {
        dispatch_source_cancel(timer);
        [timers_ removeObjectForKey:timerName];
    }
    
    dispatch_semaphore_signal(semaphore_);

}

@end
NS_ASSUME_NONNULL_END
