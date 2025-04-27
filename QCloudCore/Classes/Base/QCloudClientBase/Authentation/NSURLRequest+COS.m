//
//  NSMutableURLRequest+COS.m
//  QCloudCore
//
//  Created by garenwang on 2025/4/24.
//

#import "NSURLRequest+COS.h"
#import <objc/runtime.h>
@implementation NSURLRequest (COS)
- (void)setShouldSignedList:(NSArray *)shouldSignedList{
    objc_setAssociatedObject(self, @"shouldSignedList", shouldSignedList, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)shouldSignedList{
    return objc_getAssociatedObject(self, @"shouldSignedList");
}
@end
