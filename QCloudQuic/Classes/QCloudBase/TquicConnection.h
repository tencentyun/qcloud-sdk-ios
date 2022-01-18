//
//  TquicRequest.h
//  Tquic
//
//  Created by karisli(李雪) on 2019/3/18.
//  Copyright © 2019 tencentyun.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TquicRequest;
@class TquicResponse;
NS_ASSUME_NONNULL_BEGIN
typedef void (^TquicRequestDidConnectBlock)(NSError *error);
typedef void (^TquicRequesDidReceiveResponseBlock)(TquicResponse *response);

typedef void (^TquicRequestDidReceiveDataBlock)(NSData *data);
typedef void (^TquicRequestDidSendBodyDataBlock)(int64_t bytesSent, int64_t totolSentBytes, int64_t totalBytesExpectedToSend);
typedef void (^TquicRequesDidCompleteWithErrorBlock)(NSError *error);
@interface TquicConnection : NSObject

@property (nonatomic, assign) BOOL connect;
- (void)tquicConnectWithQuicRequest:(TquicRequest *)quicRequest
                 didConnect:(TquicRequestDidConnectBlock)didConnect
                 didReceiveResponse:(TquicRequesDidReceiveResponseBlock)didReceiveResponse
                     didReceiveData:(TquicRequestDidReceiveDataBlock)didReceiveData
                    didSendBodyData:(TquicRequestDidSendBodyDataBlock)didSendBodyData
        RequestDidCompleteWithError:(TquicRequesDidCompleteWithErrorBlock)requestDidCompleteWithError;
- (void)cancleRequest;
- (void)startRequest;

@end

NS_ASSUME_NONNULL_END
