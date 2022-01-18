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
                            headers:(nonnull NSDictionary *)headers
                        quicSession:(QCloudQuicSession *)quicSession {
    if (self = [super init]) {
        id bodyData = nil;
        if (body && !(body == [NSNull null])) {
            bodyData = body;
        } else if (httpRequest.HTTPBody) {
            bodyData = httpRequest.HTTPBody;
        }
        
 
        
        //
        NSMutableDictionary *quicHeaders = [NSMutableDictionary dictionary];
        [httpRequest.allHTTPHeaderFields enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if([key isEqualToString:@"path"]){
                [quicHeaders setValue:obj forKey:@":path"];
            }else if ([key isEqualToString:@"method"]){
                [quicHeaders setValue:obj forKey:@":method"];
            }
            else if ([key isEqualToString:@"scheme"]){
                [quicHeaders setValue:obj forKey:@":scheme"];
            }else{
                [quicHeaders setValue:obj forKey:key];
            }
        }];
        quicHeaders[@":method"] = httpRequest.HTTPMethod;
        quicHeaders[@":scheme"] = httpRequest.URL.scheme;
        NSString *path = httpRequest.URL.path;
     
        quicHeaders[@":authority"]= quicHost;
        quicHeaders[@"vod-forward-cos"]= quicHost;
        [quicHeaders removeObjectForKey:@"Host"];
        if (httpRequest.URL.query) {
            path = [NSString stringWithFormat:@"%@?%@",path,httpRequest.URL.query];
        }
        if (path.length!=0) {
            if (![[path substringToIndex:1] isEqualToString:@"/"]) {
                path = [NSString stringWithFormat:@"/?%@",httpRequest.URL.query];
            }
        }else{
            path = @"/";
        }
        
        quicHeaders[@":path"] = path;
        if([httpRequest.HTTPMethod isEqualToString:@"POST"] && body == [NSNull null]){
            quicHeaders[@"content-length"] = @"0";
        }
        
        TquicRequest *req = [[TquicRequest alloc] initWithURL:httpRequest.URL
                                                         host:quicHost
                                                   httpMethod:httpRequest.HTTPMethod
                                                           ip:quicIp
                                                         body:bodyData
                                                 headerFileds:[quicHeaders copy]];
        _manager = [TquicConnection new];
        __weak typeof(self) weakSelf = self;
        [_manager tquicConnectWithQuicRequest:req
                                   didConnect:^(NSError * _Nonnull error) {
            __strong typeof(weakSelf) strngSelf = weakSelf;
                                       
            if(error){
                if ([strngSelf.quicDelegate respondsToSelector:@selector(URLSession:task:didCompleteWithError:)]) {
                    [strngSelf.quicDelegate URLSession:quicSession task:strngSelf didCompleteWithError:error];
                }
            }
        } didReceiveResponse:^(TquicResponse *_Nonnull response) {
            __strong typeof(weakSelf) strngSelf = weakSelf;
            strngSelf.response = [[NSHTTPURLResponse alloc] initWithURL:httpRequest.URL
                                                             statusCode:response.statusCode
                                                            HTTPVersion:response.httpVersion
                                                           headerFields:[response.allHeaderFields copy]];
            if ([strngSelf.quicDelegate respondsToSelector:@selector(URLSession:dataTask:didReceiveResponse:completionHandler:)]) {
                [strngSelf.quicDelegate URLSession:quicSession dataTask:strngSelf didReceiveResponse:strngSelf.response completionHandler:nil];
            }
        }
                               didReceiveData:^(NSData *_Nonnull data) {
            __strong typeof(weakSelf) strngSelf = weakSelf;
            if ([strngSelf.quicDelegate respondsToSelector:@selector(URLSession:dataTask:didReceiveData:)]) {
                [strngSelf.quicDelegate URLSession:quicSession dataTask:strngSelf didReceiveData:data];
            }
        }
                              didSendBodyData:^(int64_t bytesSent, int64_t totolSentBytes, int64_t totalBytesExpectedToSend) {
            __strong typeof(weakSelf) strngSelf = weakSelf;
            if ([strngSelf.quicDelegate respondsToSelector:@selector(URLSession:task:didSendBodyData:totalBytesSent:totalBytesExpectedToSend:)]) {
                [strngSelf.quicDelegate URLSession:quicSession
                                              task:strngSelf
                                   didSendBodyData:bytesSent
                                    totalBytesSent:totolSentBytes
                          totalBytesExpectedToSend:totalBytesExpectedToSend];
            }
        }
                  RequestDidCompleteWithError:^(NSError *_Nonnull error) {
            __strong typeof(weakSelf) strngSelf = weakSelf;
            strngSelf.originalRequest = [[NSURLRequest alloc] initWithURL:httpRequest.URL];
            if ([strngSelf.quicDelegate respondsToSelector:@selector(URLSession:task:didCompleteWithError:)]) {
                [strngSelf.quicDelegate URLSession:quicSession task:strngSelf didCompleteWithError:error];
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
