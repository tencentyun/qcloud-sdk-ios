//
//  QCloudRequestOperation.m
//  Pods
//
//  Created by Dong Zhao on 2017/3/10.
//
//

#import "QCloudRequestOperation.h"
#import "QCloudHTTPRequest.h"
#import "QCloudNetEnv.h"
#import "QCloudHttpDNS.h"
#import "QCloudHTTPSessionManager_Private.h"
#import "QCloudHTTPSessionManager.h"
#import "QCloudURLSessionTaskData.h"
#import "QCloudHTTPRetryHanlder.h"
#import "QCloudLogger.h"
#import <objc/runtime.h>
@interface QCloudRequestOperation () <QCloudHTTPRequestDelegate>
@property (nonatomic, strong, readonly) QCloudHTTPRequest* httpRequest;
@end
@implementation QCloudRequestOperation
@synthesize request = _request;
- (instancetype) initWithRequest:(QCloudAbstractRequest *)request
{
    self = [super init];
    if (!self) {
        return self;
    }
    _request = request;
    return self;
}

- (QCloudHTTPRequest*) httpRequest
{
    return (QCloudHTTPRequest*)_request;
}

- (void) execute
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self main];
    });
}

- (void) prepareExecute
{
    
}

- (NSComparisonResult) compare:(QCloudRequestOperation*)operation
{
    if (self.request.priority < operation.request.priority) {
        return NSOrderedAscending;
    } else if (self.request.priority > operation.request.priority) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}

- (void) main
{
    @throw [NSException exceptionWithName:@"com.tencent.qcloud" reason:@"您必须实现Main函数才能使用Operation方法" userInfo:nil];
}
@end
