//
//  QCloudQuicDataTask.m
//  QCloudCore
//
//  Created by karisli(李雪) on 2019/3/22.
//

#import "QCloudQuicDataTask.h"
#import "QCloudQuicSession.h"
#import "Tquicnet.h"

@implementation QCloudQuicDataTask
@synthesize response = _response;
@synthesize originalRequest = _originalRequest;

- (instancetype)initWithHTTPRequest:(NSMutableURLRequest *)httpRequest
                           quicHost:(NSString *)quicHost
                             quicIp:(NSString *)quicIp
                               body:(id)body
                        quicSession:(QCloudQuicSession *)quicSession {
    if (self = [super init]) {
        id bodyData = nil;
        if (body && !(body == [NSNull null])) {
            bodyData = body;
        } else if (httpRequest.HTTPBody) {
            bodyData = httpRequest.HTTPBody;
        }
        TquicRequest *req = [[TquicRequest alloc] initWithURL:httpRequest.URL
                                                         host:quicHost
                                                   httpMethod:httpRequest.HTTPMethod
                                                           ip:quicIp
                                                         body:bodyData
                                                 headerFileds:httpRequest.allHTTPHeaderFields];
        _manager = [TquicConnection new];
        __weak typeof(self) weakSelf = self;
        [_manager tquicConnectWithQuicRequest:req session:quicSession
            didReceiveResponse:^(TquicResponse *_Nonnull response) {
                __strong typeof(weakSelf) strngSelf = weakSelf;
                strngSelf.response = [[NSHTTPURLResponse alloc] initWithURL:httpRequest.URL
                                                                 statusCode:response.statusCode
                                                                HTTPVersion:response.httpVersion
                                                               headerFields:[response.allHeaderFields copy]];
                if ([strngSelf.delegate respondsToSelector:@selector(URLSession:dataTask:didReceiveResponse:completionHandler:)]) {
                    [strngSelf.delegate URLSession:quicSession dataTask:strngSelf didReceiveResponse:strngSelf.response completionHandler:nil];
                }
            }
            didReceiveData:^(NSData *_Nonnull data) {
                __strong typeof(weakSelf) strngSelf = weakSelf;
                if ([strngSelf.delegate respondsToSelector:@selector(URLSession:dataTask:didReceiveData:)]) {
                    [strngSelf.delegate URLSession:quicSession dataTask:strngSelf didReceiveData:data];
                }
            }
            didSendBodyData:^(int64_t bytesSent, int64_t totolSentBytes, int64_t totalBytesExpectedToSend) {
                __strong typeof(weakSelf) strngSelf = weakSelf;
                if ([strngSelf.delegate respondsToSelector:@selector(URLSession:task:didSendBodyData:totalBytesSent:totalBytesExpectedToSend:)]) {
                    [strngSelf.delegate URLSession:quicSession
                                              task:strngSelf
                                   didSendBodyData:bytesSent
                                    totalBytesSent:totolSentBytes
                          totalBytesExpectedToSend:totalBytesExpectedToSend];
                }
            }
            RequestDidCompleteWithError:^(NSError *_Nonnull error) {
                __strong typeof(weakSelf) strngSelf = weakSelf;
                strngSelf.originalRequest = [[NSURLRequest alloc] initWithURL:httpRequest.URL];
                if ([strngSelf.delegate respondsToSelector:@selector(URLSession:task:didCompleteWithError:)]) {
                    [strngSelf.delegate URLSession:quicSession task:strngSelf didCompleteWithError:error];
                }
            }];
    }
    return self;
}
- (void)setResponse:(NSHTTPURLResponse *)response {
    _response = response;
}
- (NSHTTPURLResponse *)response {
    return _response;
}

- (NSURLRequest *)currentRequest {
    return _originalRequest;
}

- (void)setOriginalRequest:(NSURLRequest *)originalRequest {
    _originalRequest = originalRequest;
}
- (NSURLRequest *)originalRequest {
    return _originalRequest;
}
- (void)cancel {
    [_manager cancleRequest];
}
- (void)start {
    [_manager startRequest];
}
- (void)dealloc {
    //    _manager = nil;
    NSLog(@"QCloudQuicDataTask dealloc");
}

@end
