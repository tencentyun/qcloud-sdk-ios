//
//  DZProgramDefines.m
//  TimeUI
//
//  Created by Stone Dong on 14-1-21.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "QCloudProgrameDefines.h"
#import <objc/runtime.h>



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
