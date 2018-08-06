//
//  QCloudUniversalFixedPath.m
//  QCloudCore
//
//  Created by erichmzhang(张恒铭) on 2018/7/20.
//

#import "QCloudUniversalFixedPath.h"

@implementation QCloudUniversalFixedPath
- (NSURL *)fileURL {
    return [NSURL fileURLWithPath:self.originURL];
}
@end
