//
//  QCloudHTTPTaskDelayManager.m
//  CLSLogger
//
//  Created by wjielai on 2020/4/29.
//

#import "QCloudHTTPTaskDelayManager.h"

@implementation QCloudHTTPTaskDelayManager {
    NSInteger initDelay;
    NSInteger maxDelay;
    NSInteger currentDelay;
}

- (instancetype)initWithStart:(NSInteger)startBackoff max:(NSInteger)maxBackoff {
    self = [super init];
    if (self) {
        initDelay = startBackoff;
        maxDelay = maxBackoff;
        currentDelay = 0;
    }
    return self;
}

- (void)reset {
    @synchronized(self) {
        currentDelay = 0;
    }
}

- (void)increase {
    @synchronized(self) {
        NSInteger cd = currentDelay;
        currentDelay = MIN(MAX(cd * 2, initDelay), maxDelay);
    }
}

- (NSInteger)getDelay {
    @synchronized(self) {
        return currentDelay;
    }
}

@end
