//
//  TquicNetRequest.m
//  TquicNet
//
//  Created by karisli(李雪) on 2019/3/18.
//  Copyright © 2019 tencentyun.com. All rights reserved.
//

#import "TquicConnection.h"
#import <Tquic/tnet_quic_request.h>
#include <iostream>
#include <fstream>
#include <memory>
#include <string>
#include <vector>
#include <chrono>
#import "TquicResponse.h"
#import "TquicRequest.h"
#import "QCloudQuicConfig.h"
//每次发送的字节数
static const int64_t sentByte = 32768;
class TnetAsyncDelegate : public TnetRequestDelegate{
    public:
//    std::shared_ptr<TnetQuicRequest> request_sp;
    std::weak_ptr<TnetQuicRequest> request_sp;
    bool isComplete;
    
    protected:
    TquicRequestDidConnectBlock didConnectionBlock_;
    TquicRequesDidReceiveResponseBlock didReceiveResponse_;
    TquicRequestDidSendBodyDataBlock didSendBodyData_;
    TquicRequestDidReceiveDataBlock didReceiveData_;
    TquicRequesDidCompleteWithErrorBlock didCompleteWithError_;
    TquicRequest *quicReqeust_;
    
    private:
        int first_time_;
        int64_t totolSentBytes;
        
    public:
    TnetAsyncDelegate() {
        first_time_ = 1;
    
    }
    TnetAsyncDelegate(TquicRequest *quicRequest,TquicRequestDidConnectBlock didConnectionBlock,TquicRequesDidReceiveResponseBlock didReceiveResponse,TquicRequestDidReceiveDataBlock didReceiveData, TquicRequestDidSendBodyDataBlock didSentBodyData,TquicRequesDidCompleteWithErrorBlock  didCompleteWithError){
    first_time_ = 1;
    totolSentBytes = 0;
    isComplete = NO;
    this->didConnectionBlock_ =  didConnectionBlock;
    this->didReceiveResponse_ = didReceiveResponse;
    this->didSendBodyData_ = didSentBodyData;
    this->didReceiveData_ = didReceiveData;
    this->didCompleteWithError_ = didCompleteWithError;
    this->quicReqeust_ = quicRequest;
    }

    ~TnetAsyncDelegate() override {
    }


#pragma mark URLRequest::Delegate methods
    //连接建立成功的回调
    void  OnConnect(int error_code) override{
        
        if (this->didConnectionBlock_ !=nullptr) {
             this->didConnectionBlock_(nil);
        }
        
        //设置header 头部
        NSArray *allkeys = this->quicReqeust_.quicAllHeaderFields.allKeys;
        NSDictionary *kvs = [NSMutableDictionary new];
        for (NSString *key in allkeys) {
            id value = [this->quicReqeust_.quicAllHeaderFields objectForKey:key];
            if([value isKindOfClass:[NSNumber class]]){
                value = [NSString stringWithFormat:@"%@",value];
            }
            if (value == NULL || key == NULL) {
                continue;
            }
            const char* cValue = [value UTF8String];
            const char* ukey = [[key lowercaseString] UTF8String];
            if(auto sp = request_sp.lock()) {
                sp->AddHeaders(ukey, cValue);
            }else{
                return;
            }
            [kvs setValue:[[NSString alloc] initWithUTF8String:cValue] forKey:key];
        }
        NSLog(@"Tquic send headers: %@", kvs);
        
        if (this->quicReqeust_.body) {
            NSData *data = nil;
            if ([this->quicReqeust_.body isKindOfClass:[NSURL class]]) {
                NSURL *fileURl = this->quicReqeust_.body;
                data = [NSData dataWithContentsOfURL:fileURl];
            }else if([this->quicReqeust_.body isKindOfClass:[NSData class]]){
                data = (NSData *)this->quicReqeust_.body;
            }
            
            if (data.length<=sentByte) {
                char *c = (char*)malloc(data.length * sizeof(char));
                [data getBytes:c range:NSMakeRange(0, data.length)];
                NSLog(@"Tquic SendRequest with size: %lu and end", (unsigned long)data.length);
                if(auto sp = request_sp.lock()) {
                    sp->SendRequest(c, (int)data.length, true);
                }else{
                    return;
                }
            
                totolSentBytes+=data.length;
                free(c);
                //小于32768的情况
                if (this->didSendBodyData_ != NULL) {
                     this->didSendBodyData_(data.length,data.length,data.length);
                }
               
            }else{
                //读取字节发送
                int sliceNumber  = (data.length%sentByte)?((int)(data.length/sentByte) +1):(int)(data.length/sentByte);
                int64_t totolLength = data.length;
                int64_t resetLength = totolLength;
                int i = 0;
                while (sliceNumber && resetLength) {
                    if (sliceNumber == 1) {
                        char *c = (char*)malloc(resetLength * sizeof(char));
                        [data getBytes:c range:NSMakeRange(i*sentByte, resetLength)];
                       
                        NSLog(@"Tquic SendRequest with size: %lld and end",resetLength);
                        if(auto sp = request_sp.lock()) {
                            sp->SendRequest(c, (int)resetLength, true);
                        }else{
                            return;
                        }
                        totolSentBytes+=resetLength;
                        free(c);
                        if (this->didSendBodyData_ != NULL) {
                             this->didSendBodyData_(resetLength,totolSentBytes,data.length);
                        }
                        resetLength = resetLength - resetLength;
                    }else{
                        char *c = (char*)malloc(sentByte * sizeof(char));
                        [data getBytes:c range:NSMakeRange(i*sentByte, sentByte)];
                        NSLog(@"Tquic SendRequest with size: %lld",sentByte);
                        if(auto sp = request_sp.lock()) {
                            sp->SendRequest(c, sentByte, false);
                        }else{
                            return;
                        }
                        totolSentBytes+=sentByte;
                        resetLength = resetLength - sentByte;
                        free(c);
                        if (this->didSendBodyData_ != NULL ) {
                            this->didSendBodyData_(sentByte,totolSentBytes,data.length);
                        }
                        
                    }
                    sliceNumber --;
                    i++;
                }
            }
            
        }else {
            if(auto sp = request_sp.lock()) {
                sp->SendRequest([@"" UTF8String], 0, true);
            }
        }
           //在这里发送request
    }
    // 收到数据并且输出
    void OnDataRecv(const char* buf,const int buf_len)  override{
       
        //第一次是头部
        if (first_time_ == 1) {
            NSString *responseStr = [[NSString alloc] initWithBytes:buf length:buf_len encoding:8];
            TquicResponse *response = [[TquicResponse alloc]initWithQuicResponseStr:responseStr];
            first_time_ = 0;

            NSLog(@"Tquic OnDataRecv :%@",responseStr);
            if (this->didReceiveResponse_ !=nullptr) {
                 this->didReceiveResponse_(response);
            }
           
        } else {
            NSData *didReceiveData = [[NSData alloc]initWithBytes:buf length:buf_len];
            first_time_ = 0;
            NSLog(@"Tquic OnDataRecv with length: %d",buf_len);
            if (this->didReceiveData_ != nullptr ) {
                 this->didReceiveData_(didReceiveData);
            }
           
        }
        
}

    // The connection closed with the error_code, need to re-connect.
    void OnConnectionClose(int error_code, const char* error_detail) override{
            NSError *error;
            if (error_code != 0 && error_code != 25) {
                error = [[NSError alloc] initWithDomain:NSURLErrorDomain code:error_code userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"%s",error_detail]}];
               
            }
            if (!isComplete) {
                isComplete = YES;
                if (this->didCompleteWithError_ !=nullptr) {
                     this->didCompleteWithError_(error);
                }
            }
        }

    // This request has received all the data and finished.
    void OnRequestFinish(int stream_error) override{
        if(auto sp = request_sp.lock()) {
            sp->CloseConnection();
        }
        NSError *error = nil;
        if (stream_error != 0) {
            error = [[NSError alloc] initWithDomain:NSURLErrorDomain code:stream_error userInfo:nil];
        }

        NSLog(@"Tquic OnRequestCompleted with error: %@", error);
        if (!isComplete) {
            isComplete = YES;
            if (this->didCompleteWithError_ != nullptr) {
                this->didCompleteWithError_(error);
            }
        }
    }
};


@interface TquicConnection (){
    
    std::shared_ptr<TnetQuicRequest>request_sp;
    std::shared_ptr<TnetAsyncDelegate>tquic_delegate_sp;
}
@property (nonatomic,strong)TquicRequest *quicReqeust;

@end


@implementation TquicConnection

-(void)tquicConnectWithQuicRequest:(TquicRequest *)quicRequest
                        didConnect:(TquicRequestDidConnectBlock)didConnect
                        didReceiveResponse:(TquicRequesDidReceiveResponseBlock)didReceiveResponse
                        didReceiveData:(TquicRequestDidReceiveDataBlock)didReceiveData didSendBodyData:(TquicRequestDidSendBodyDataBlock)didSendBodyData RequestDidCompleteWithError:(TquicRequesDidCompleteWithErrorBlock)requestDidCompleteWithError{
     [self onHandleQuicRequest:quicRequest didConnect:didConnect didReceiveResponse:didReceiveResponse didReceiveData:didReceiveData didSendBodyData:didSendBodyData RequestDidCompleteWithError:requestDidCompleteWithError];
    
}

-(void)onHandleQuicRequest:(TquicRequest *)quicRequest  didConnect:(TquicRequestDidConnectBlock)didConnect didReceiveResponse:(TquicRequesDidReceiveResponseBlock)didReceiveResponse didReceiveData:(TquicRequestDidReceiveDataBlock)didReceiveData didSendBodyData:(TquicRequestDidSendBodyDataBlock)didSendBodyData RequestDidCompleteWithError:(TquicRequesDidCompleteWithErrorBlock)requestDidCompleteWithError{
    tquic_delegate_sp.reset(new TnetAsyncDelegate (quicRequest,didConnect, didReceiveResponse,didReceiveData,didSendBodyData,requestDidCompleteWithError));
    TnetConfig config = TnetConfig();
    if (quicRequest.body) {
        config.upload_optimize_ = true;
    }
    
    CongestionType congestion_type;
    switch ([QCloudQuicConfig shareConfig].congestion_type) {
        case QCloudCongestionTypeCubicBytes:
            congestion_type = kCubicBytes;
            break;
        case QCloudCongestionTypeRenoBytes:
            congestion_type = kRenoBytes;
            break;
        case QCloudCongestionTypeBBR:
            congestion_type = kBBR;
            break;
        case QCloudCongestionTypePCC:
            congestion_type = kPCC;
            break;
        case QCloudCongestionTypeGoogCC:
            congestion_type = kGoogCC;
            break;
        default:
            break;
    }
    config.congestion_type_ = congestion_type;
    RaceType raceType;
    switch ( [QCloudQuicConfig shareConfig].race_type) {
        case QCloudRaceTypeOnlyQUIC:
            raceType = kOnlyQUIC;
            break;
        case QCloudRaceTypeQUICHTTP:
            raceType = kQUICHTTP;
            break;
        case QCloudRaceTypeOnlyHTTP:
            raceType = kOnlyHTTP;
            break;
    }
    config.race_type = raceType;
    config.total_timeout_millisec_ =[QCloudQuicConfig shareConfig].total_timeout_millisec_;

    config.support_v6_ = [QCloudQuicConfig shareConfig].support_v6_;
    
    config.isCongetionOptimizationEnabled_ = [QCloudQuicConfig shareConfig].isCongetionOptimizationEnabled_;
    config.mp_strategy_ = [QCloudQuicConfig shareConfig].mp_strategy_;
    
    config.connect_timeout_millisec_ = [QCloudQuicConfig shareConfig].connect_timeout_millisec_;
    if ([QCloudQuicConfig shareConfig].nStreamMaxRecvWindowSize > 0) {
        config.nStreamMaxRecvWindowSize = [QCloudQuicConfig shareConfig].nStreamMaxRecvWindowSize;
    }
    
    if ([QCloudQuicConfig shareConfig].nSessionMaxRecvWindowSize > 0) {
        config.nSessionMaxRecvWindowSize = [QCloudQuicConfig shareConfig].nSessionMaxRecvWindowSize;
    }
    config.use_session_reuse_ = [QCloudQuicConfig shareConfig].use_session_reuse_;
    
      // 设置连接空闲时间，单位为ms，默认值为与服务端协商值，一般为90000ms
    config.idle_timeout_millisec_ =  [QCloudQuicConfig shareConfig].idle_timeout_millisec_;
    config.is_custom_ = [QCloudQuicConfig shareConfig].is_custom;
    request_sp.reset(new TnetQuicRequest(tquic_delegate_sp.get(),config));
    tquic_delegate_sp.get()->request_sp = request_sp;
//    tquic_delegate_sp.get()->w_request_sp = request_sp;
    self.quicReqeust = quicRequest;

}

//cancle request
-(void)cancleRequest{
    NSLog(@"garenwang_Tquic cancleRequest: request_sp.use_count = %ld add=%p",request_sp.use_count(),request_sp.get());
    request_sp.get()->CancelRequest();
}

//sent request
-(void)startRequest{
    NSLog(@"Tquic startRequest: %@ (%@)", self.quicReqeust.host, self.quicReqeust.ip);
    if(self.quicReqeust.ip == nil){
        request_sp->ConnectWithDomain([self.quicReqeust.host?:@"" UTF8String], [QCloudQuicConfig shareConfig].port);
    }else{
        request_sp->Connect([self.quicReqeust.host?:@"" UTF8String], [self.quicReqeust.ip?:@"" UTF8String], [QCloudQuicConfig shareConfig].port, [QCloudQuicConfig shareConfig].tcp_port);
    }
//    request_sp.get()->Connect([@"iacc.stgw.qq.com" UTF8String] , [@"101.89.15.244" UTF8String],  [QCloudQuicConfig shareConfig].port, [QCloudQuicConfig shareConfig].tcp_port);
}
-(void)dealloc{
    NSLog(@"TquicConnection connect dealloc address = %@",self);
}
@end
