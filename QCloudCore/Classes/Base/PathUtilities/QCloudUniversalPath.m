//
//  QCloudUniversalPath.m
//  QCloudCore
//
//  Created by erichmzhang(张恒铭) on 2018/7/20.
//

#import "QCloudUniversalPath.h"
#import <QCloudCore/QCloudCore.h>


@implementation QCloudUniversalPath
- (instancetype)initWithStrippedURL:(NSString *)strippedURL {
    self = [super init];
    _originURL = strippedURL;
    return self;
}
-(NSURL *)fileURL{
    @throw [NSException exceptionWithName:QCloudErrorDomain reason:[NSString stringWithFormat:@"不支持该路径下的文件续传:%@",_originURL] userInfo:nil];
}
@end
