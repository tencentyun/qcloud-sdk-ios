//
//  QCloudEndPoint.m
//  Pods
//
//  Created by Dong Zhao on 2017/3/31.
//
//

#import "QCloudEndPoint.h"
#import "QCloudError.h"
#import "QCloudURLTools.h"

@interface QCloudEndPoint ()
@property (nonatomic, strong) NSURL* serverURLLiteral;
@end

@implementation QCloudEndPoint
- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _useHTTPS = NO;
    return self;
}
- (instancetype) initWithLiteralURL:(NSURL *)url
{
    self = [super init];
    if (!self) {
        return self;
    }
    _serverURLLiteral = url;
    if ([_serverURLLiteral.absoluteString.lowercaseString hasPrefix:QCloudHTTPSScheme]) {
        _useHTTPS = YES;
    } else {
        _useHTTPS = NO;
    }
    return self;
}


- (NSURL*) serverURLLiteral
{
    if (!_serverURLLiteral) {
        return nil;
    }
    NSString* url = _serverURLLiteral.absoluteString;
    if ([url.lowercaseString hasPrefix:QCloudHTTPSScheme]) {
        url = [url substringFromIndex:QCloudHTTPSScheme.length];
    } else if ([url.lowercaseString hasPrefix:QCloudHTTPScheme]) {
        url = [url substringFromIndex:QCloudHTTPScheme.length];
    }
    if (self.useHTTPS) {
        url = [QCloudHTTPSScheme stringByAppendingString:url];
    } else {
        url = [QCloudHTTPScheme stringByAppendingString:url];
    }
    return [NSURL URLWithString:url];
}

-(NSURL *)serverURLWithBucket:(NSString *)bucket appID:(NSString *)appID regionName:(NSString *)regionName{
    NSString* msg = @"请在子类中实现该方法，在父类中该方法不关心具体业务的拼装！！！";
    @throw [NSException exceptionWithName:QCloudErrorDomain reason:msg userInfo:@{NSLocalizedDescriptionKey:msg}];
}

- (instancetype) copyWithZone:(NSZone *)zone
{
    QCloudEndPoint* endpoint = [[[self class] allocWithZone:zone] init];
    endpoint.useHTTPS = self.useHTTPS;
    endpoint.serviceName = self.serviceName;
    endpoint.regionName = self.regionName;
    endpoint.serverURLLiteral = _serverURLLiteral;
    return endpoint;
}
@end
