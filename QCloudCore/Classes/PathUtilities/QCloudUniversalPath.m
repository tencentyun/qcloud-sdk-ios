//
//  QCloudUniversalPath.m
//  QCloudCore
//
//  Created by erichmzhang(张恒铭) on 2018/7/20.
//

#import "QCloudUniversalPath.h"

@interface QCloudUniversalPath()
@end

@implementation QCloudUniversalPath
- (instancetype)initWithStrippedURL:(NSString *)strippedURL {
    self = [super init];
    _originURL = strippedURL;
    return self;
}
@end
