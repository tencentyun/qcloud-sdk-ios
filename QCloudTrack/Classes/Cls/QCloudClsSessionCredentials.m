//
//  QCloudClsSessionCredentials.m
//  Pods-QCloudCOSXMLDemo
//
//  Created by garenwang on 2023/12/26.
//

#import "QCloudClsSessionCredentials.h"

@implementation QCloudClsSessionCredentials

-(BOOL)isValid{
    if (self.expiredTime == 0) {
        return YES;
    }
    if (!self.token) {
        return YES;
    }
    NSTimeInterval current = [[NSDate date] timeIntervalSince1970];
    return current <= self.expiredTime - 60;
}
@end
