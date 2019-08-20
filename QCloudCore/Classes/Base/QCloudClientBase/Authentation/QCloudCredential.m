//
//  QCloudCredential.m
//  Pods
//
//  Created by Dong Zhao on 2017/5/2.
//
//

#import "QCloudCredential.h"
#import "NSDate+QCLOUD.h"
@implementation QCloudCredential

/**
 Use the time after fix to compare,avoid time skew caused by Device
 */
- (BOOL) valid
{
    if (!self.experationDate) {
        return YES;
    }
    NSDate *date = [NSDate date];
    if ([NSDate qcloud_getTimeDeviation]) {
        date = [NSDate qcloud_calibrateTime];
    }
    if ([date compare:self.experationDate] == NSOrderedDescending) {
        return NO;
    }
    return YES;
}
@end
