//
//  QCloudCredential.m
//  Pods
//
//  Created by Dong Zhao on 2017/5/2.
//
//

#import "QCloudCredential.h"

@implementation QCloudCredential
- (BOOL) valid
{
    if (!self.validBeginDate) {
        return YES;
    }
    if (!self.experationDate) {
        return YES;
    }
    if ([[NSDate date] compare:self.experationDate] == NSOrderedAscending) {
        return NO;
    }
    return YES;
}
@end
