//
//  DZProgramDefines.m
//  TimeUI
//
//  Created by Stone Dong on 14-1-21.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "QCloudProgrameDefines.h"
#import <objc/runtime.h>




Class DZGetCurrentClassInvocationSEL(NSString* functionString)
{
    
    if (functionString.length == 0) {
        return nil;
    }
    
    NSRange rangeStart = [functionString rangeOfString:@"["];
    NSRange rangeEnd = [functionString rangeOfString:@" "];
    if (rangeStart.location == NSNotFound || rangeEnd.location == NSNotFound) {
        return nil;
    }
    NSInteger start = rangeStart.location + rangeStart.length;
    if (rangeEnd.location - start <= 0) {
        return nil;
    }
    NSRange classRange = NSMakeRange(start, rangeEnd.location - start);
    NSString *classString = [functionString substringWithRange:classRange];
    return NSClassFromString(classString);
}

BOOL DZCheckSuperResponseToSelector(Class cla, SEL selector) {
    Class superClass = class_getSuperclass(cla);
    return class_respondsToSelector(superClass, selector);
}




void   DZEnsureMainThread(void(^mainSafeBlock)())
{
    if (mainSafeBlock == NULL) {
        return;
    }
    if ([NSThread isMainThread]) {
        mainSafeBlock();
    } else {
        dispatch_sync(dispatch_get_main_queue(), mainSafeBlock);
    }
}
