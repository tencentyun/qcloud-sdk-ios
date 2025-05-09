//
//  QCloudAFLoaderTask.m
//  QCloudCOSXMLDemo
//
//  Created by garenwang on 2024/12/30.
//  Copyright © 2024 Tencent. All rights reserved.
//

#import "QCloudAFLoaderTask.h"
#import "QCloudAFLoaderSession.h"
#import "AFNetworking/AFNetworking.h"
@interface QCloudAFLoaderTask ()

@property (nonatomic,strong)QCloudCustomSession *customSession;
@property (nonatomic,strong)NSMutableURLRequest *httpRequest;
@property (nonatomic,strong)NSURL *fromFile;
@property (nonatomic,strong)NSURLSessionDataTask *task;

@end

@implementation QCloudAFLoaderTask
- (instancetype)initWithHTTPRequest:(NSMutableURLRequest *)httpRequest
                           fromFile:(NSURL *)fromFile
                            session:(QCloudCustomSession *)session{
    self = [super init];
    if (self) {
        self.fromFile = fromFile;
        self.httpRequest = httpRequest;
        self.currentRequest = httpRequest;
        self.originalRequest = httpRequest;
        self.customSession = session;
    }
    return self;
}

-(void)resume{
    QCloudWeakSelf(self);
    if (!self.fromFile) {
        self.task = [[[QCloudAFLoaderSession session] manager] dataTaskWithRequest:self.httpRequest uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
            QCloudStrongSelf(self);
            [strongself.customSession customTask:self didSendBodyData:uploadProgress.completedUnitCount totalBytesSent:uploadProgress.totalUnitCount totalBytesExpectedToSend:uploadProgress.totalUnitCount];
    
        } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
            QCloudStrongSelf(self);
            [strongself.customSession customTask:self didSendBodyData:downloadProgress.completedUnitCount totalBytesSent:downloadProgress.totalUnitCount totalBytesExpectedToSend:downloadProgress.totalUnitCount];
        } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            QCloudStrongSelf(self);
            [strongself.customSession customTask:strongself didReceiveResponse:response completionHandler:nil];
            [strongself.customSession customTask:strongself didReceiveData:responseObject];
            [strongself.customSession customTask:strongself didCompleteWithError:error];
        }];
        [self.task resume];
    }else{
        self.task = [[[QCloudAFLoaderSession session] manager] uploadTaskWithRequest:self.httpRequest fromFile:self.fromFile progress:^(NSProgress * _Nonnull uploadProgress) {
            QCloudStrongSelf(self);
            [strongself.customSession customTask:strongself didSendBodyData:uploadProgress.completedUnitCount totalBytesSent:uploadProgress.totalUnitCount totalBytesExpectedToSend:uploadProgress.totalUnitCount];
        } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            QCloudStrongSelf(self);
            [strongself.customSession customTask:strongself didReceiveResponse:response completionHandler:nil];
            [strongself.customSession customTask:strongself didReceiveData:responseObject];
            [strongself.customSession customTask:strongself didCompleteWithError:error];
        }];
        [self.task resume];
    }
}

- (void)cancel{
    [self.task cancel];
}
@end
