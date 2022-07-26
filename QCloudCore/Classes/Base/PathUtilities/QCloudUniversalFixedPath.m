//
//  QCloudUniversalFixedPath.m
//  QCloudCore
//
//  Created by erichmzhang(张恒铭) on 2018/7/20.
//

#import "QCloudUniversalFixedPath.h"

@implementation QCloudUniversalFixedPath
- (NSURL *)fileURL {
    if ([self.originURL hasPrefix:@"file:///"]) {
        return [NSURL URLWithString:self.originURL];
    }else{
        return [NSURL fileURLWithPath:self.originURL];
    }
}
@end
