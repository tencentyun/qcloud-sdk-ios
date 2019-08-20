//
//  QCloudMultiDelegateProxy.m
//  TACAuthorization
//
//  Created by Dong Zhao on 2017/12/11.
//

#import "QCloudMultiDelegateProxy.h"
@interface QCloudMultiDelegateProxy ()
@property (nonatomic, strong) NSRecursiveLock* lock;
@property (nonatomic, strong) NSPointerArray* delegates;
@end
@implementation QCloudMultiDelegateProxy
- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _delegates = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsWeakMemory];
    return self;
}

- (void) addDelegate:(id)delegate
{
    [_lock lock];
    NSUInteger index = NSNotFound;
    for (NSUInteger i = 0; i < _delegates.count; i++) {
        id d = [_delegates pointerAtIndex:i];
        if (d == delegate) {
            index = i;
        }
    }
    if (index == NSNotFound) {
        [_delegates addPointer:(void*)delegate];
    }
    [_delegates compact];
    [_lock unlock];
}

- (void) removeDelegate:(id)delegate
{
    [_lock lock];
    NSUInteger index = NSNotFound;
    for (NSUInteger i = 0; i < _delegates.count; i++) {
        id d = [_delegates pointerAtIndex:i];
        if (d == delegate) {
            index = i;
        }
    }
    [_lock unlock];
}

- (id)forwardingTargetForSelector:(SEL)sel
{
    return self;
}

- (NSInvocation *)_copyInvocation:(NSInvocation *)invocation
{
    NSInvocation *copy = [NSInvocation invocationWithMethodSignature:[invocation methodSignature]];
    NSUInteger argCount = [[invocation methodSignature] numberOfArguments];
    
    for (int i = 0; i < argCount; i++)
    {
        char buffer[sizeof(intmax_t)];
        [invocation getArgument:(void *)&buffer atIndex:i];
        [copy setArgument:(void *)&buffer atIndex:i];
    }
    
    return copy;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    [_delegates compact];
    for (NSUInteger index = 0; index<_delegates.count; index++) {
        id object = [_delegates pointerAtIndex:index];
        if ([object respondsToSelector:invocation.selector]) {
            NSInvocation *invocationCopy = [self _copyInvocation:invocation];
            [invocationCopy invokeWithTarget:object];
        }
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    [_delegates compact];
    for (NSUInteger index = 0; index<_delegates.count; index++) {
        id object = [_delegates pointerAtIndex:index];
        if (object) {
            id result = [object methodSignatureForSelector:sel];
            return result;
        }
    }
    return nil;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    [_delegates compact];
    for (NSUInteger index = 0; index<_delegates.count; index++) {
        id object = [_delegates pointerAtIndex:index];
        if ([object respondsToSelector:aSelector]) {
            return YES;
        }
    }
    return NO;
}
@end
