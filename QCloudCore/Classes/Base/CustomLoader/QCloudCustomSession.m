//
//  QCloudCustomSession.m
//  Pods-QCloudCOSXMLDemo
//
//  Created by garenwang on 2024/12/26.
//

#import "QCloudCustomSession.h"
#import "QCloudCustomLoaderTask.h"
#import "QCloudError.h"
@implementation QCloudCustomSession

-(QCloudCustomLoaderTask *)taskWithRequset:(NSMutableURLRequest *)request
                                  fromFile:(NSURL *)fromFile{
    @throw [NSException exceptionWithName:QCloudErrorDomain reason:@"请在子类中实现" userInfo:nil];
}

- (void)customTask:(QCloudCustomLoaderTask *)task didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    if ([self.customDelegate respondsToSelector:@selector(URLSession:dataTask:didReceiveResponse:completionHandler:)]) {
        task.response = (NSHTTPURLResponse *)response;
        [self.customDelegate URLSession:self dataTask:task didReceiveResponse:response completionHandler:completionHandler];
    }
}

- (void)customTask:(QCloudCustomLoaderTask *)task didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
    if ([self.customDelegate respondsToSelector:@selector(URLSession:task:didSendBodyData:totalBytesSent:totalBytesExpectedToSend:)]) {
        [self.customDelegate URLSession:self task:task didSendBodyData:bytesSent totalBytesSent:totalBytesSent totalBytesExpectedToSend:totalBytesExpectedToSend];
    }
}

- (void)customTask:(QCloudCustomLoaderTask *)task didReceiveData:(NSData *)data{
    if ([self.customDelegate respondsToSelector:@selector(URLSession:dataTask:didReceiveData:)]) {
        [self.customDelegate URLSession:self dataTask:task didReceiveData:data];
    }
}

- (void)customTask:(QCloudCustomLoaderTask *)task didCompleteWithError:(NSError *)error{
    if ([self.customDelegate respondsToSelector:@selector(URLSession:task:didCompleteWithError:)]) {
        [self.customDelegate URLSession:self task:task didCompleteWithError:error];
    }
}

- (void)customTask:(QCloudCustomLoaderTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *_Nonnull)challenge
 completionHandler:(void (^_Nonnull)(NSURLSessionAuthChallengeDisposition disposition,
                                     NSURLCredential *_Nullable credential))completionHandler{
    if ([self.customDelegate respondsToSelector:@selector(URLSession:task:didReceiveChallenge:completionHandler:)]) {
        [self.customDelegate URLSession:self task:task didReceiveChallenge:challenge completionHandler:completionHandler];
    }
}

- (void)customTask:(QCloudCustomLoaderTask *)task didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics API_AVAILABLE(ios(10.0)){
    if ([self.customDelegate respondsToSelector:@selector(URLSession:task:didFinishCollectingMetrics:)]) {
        [self.customDelegate URLSession:self task:task didFinishCollectingMetrics:metrics];
    }
}

- (void)customTask:(QCloudCustomLoaderTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler{
    if ([self.customDelegate respondsToSelector:@selector(URLSession:task:willPerformHTTPRedirection:newRequest:completionHandler:)]) {
        task.currentRequest = request;
        [self.customDelegate URLSession:self task:task willPerformHTTPRedirection:response newRequest:request completionHandler:completionHandler];
    }
}
@end
