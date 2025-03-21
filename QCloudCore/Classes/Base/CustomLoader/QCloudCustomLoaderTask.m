//
//  QCloudCustomLoaderTask.m
//  Pods-QCloudCOSXMLDemo
//
//  Created by garenwang on 2024/12/26.
//

#import "QCloudCustomLoaderTask.h"
#import "QCloudCustomSession.h"
#import "QCloudError.h"

@interface QCloudCustomLoaderTask ()
@property (nonatomic,strong)NSMutableURLRequest * httpRequest;
@property (nonatomic,strong)QCloudCustomSession * session;
@end

@implementation QCloudCustomLoaderTask
@synthesize response = _response;
@synthesize originalRequest = _originalRequest;
@synthesize currentRequest = _currentRequest;
@synthesize countOfBytesSent = _countOfBytesSent;
@synthesize countOfBytesExpectedToSend = _countOfBytesExpectedToSend;


- (instancetype)initWithHTTPRequest:(NSMutableURLRequest *)httpRequest
                           fromFile:(NSURL *)fromFile
                            session:(QCloudCustomSession *)session{
    @throw [NSException exceptionWithName:QCloudErrorDomain reason:@"请在子类中实现" userInfo:nil];
}

-(void)resume{
    @throw [NSException exceptionWithName:QCloudErrorDomain reason:@"请在子类中实现" userInfo:nil];
}
- (void)cancel{
    @throw [NSException exceptionWithName:QCloudErrorDomain reason:@"请在子类中实现" userInfo:nil];
}
@end
