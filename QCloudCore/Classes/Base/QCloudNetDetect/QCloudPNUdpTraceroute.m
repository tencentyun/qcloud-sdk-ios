//
//  QCloudPNUdpTraceroute.m
//  PhoneNetSDK
//
//  Created by mediaios on 2019/3/13.
//  Copyright © 2019 mediaios. All rights reserved.
//

#import "QCloudPNUdpTraceroute.h"
#include <AssertMacros.h>
#import <arpa/inet.h>
#import <netdb.h>
#import <netinet/in.h>
#import <sys/socket.h>
#import <unistd.h>

#import <netinet/in.h>
#import <netinet/tcp.h>

#import <sys/select.h>
#import <sys/time.h>

#import "QCloudPNetQueue.h"
#import "QCloudPhoneTraceRoute.h"

@interface QCloudPNUdpTracerouteDetail:NSObject
@property (readonly) NSUInteger seq;   // 第几跳
@property (nonatomic,copy) NSString * routeIp;  // 中间路由ip
@property (nonatomic) NSTimeInterval *durations;   // 存储时间
@property (readonly) NSUInteger sendTimes;  // 每个路由发几个包

@end


@implementation QCloudPNUdpTracerouteDetail

- (instancetype)init:(NSUInteger)seq
           sendTimes:(NSUInteger)sendTimes
{
    if (self = [super init]) {
        _routeIp = nil;
        _seq = seq;
        _durations = (NSTimeInterval *)calloc(sendTimes, sizeof(NSTimeInterval));
        _sendTimes = sendTimes;
    }
    return self;
}

- (NSString*)description {
    NSMutableString* routeDetail = [[NSMutableString alloc] initWithCapacity:20];
    [routeDetail appendFormat:@"%ld ", (long)_seq];
    if (_routeIp == nil) {
        [routeDetail appendFormat:@":"];
    } else {
        [routeDetail appendFormat:@"%@:", _routeIp];
    }
    for (int i = 0; i < _sendTimes; i++) {
        if (_durations[i] <= 0) {
            [routeDetail appendFormat:@"*"];
        } else {
            [routeDetail appendFormat:@"%.3fms,", _durations[i] * 1000];
        }
    }
    return routeDetail;
}

- (void)dealloc
{
    free(_durations);
}

@end



@interface QCloudPNUdpTraceroute()
{
    int socket_send;
    int socket_recv;
    struct sockaddr_in remote_addr;
}

@property (nonatomic,copy) NSString *host;
@property (atomic) BOOL isStop;
@property (readonly) NSInteger maxTtl;
@property (nonatomic,copy) QCloudPNUdpTracerouteHandler complete;
@property (nonatomic,strong) NSMutableString *traceDetails;

@end

@implementation QCloudPNUdpTraceroute


- (instancetype)init:(NSString *)host
              maxTtl:(NSUInteger)maxTtl
            complete:(QCloudPNUdpTracerouteHandler)complete
{
    if (self = [super init]) {
        _host = host == nil ? @"" : host;
        _maxTtl = maxTtl;
        _complete = complete;
        _isStop = NO;
    }
    return self;
}

- (void)settingUHostSocketAddressWithHost:(NSString *)host
{
    const char *hostaddr = [host UTF8String];
    memset(&remote_addr, 0, sizeof(remote_addr));
    remote_addr.sin_len = sizeof(remote_addr);
    remote_addr.sin_addr.s_addr = inet_addr(hostaddr);
    remote_addr.sin_family = AF_INET;
    remote_addr.sin_port = htons(30006);
    if (remote_addr.sin_addr.s_addr == INADDR_NONE) {
        struct hostent *remoteHost = gethostbyname(hostaddr);
        if (remoteHost == NULL || remoteHost->h_addr == NULL) {
//            NSLog(@"access DNS error..");
            [_traceDetails appendString:@"access DNS error..\n"];
            _complete(_traceDetails);
            return;
        }
        
        remote_addr.sin_addr = *(struct in_addr *)remoteHost->h_addr;
        NSString *remoteIp = [NSString stringWithFormat:@"%s",inet_ntoa(remote_addr.sin_addr)];
        [_traceDetails appendString:[NSString stringWithFormat:@"traceroute to %@ \n",remoteIp]];
//        NSLog(@"traceroute to  %@",remoteIp);
    }
    socket_recv = socket(AF_INET,SOCK_DGRAM,IPPROTO_ICMP);
    socket_send = socket(AF_INET, SOCK_DGRAM, 0);
}

- (void)sendAndRec
{
    _traceDetails = [NSMutableString stringWithString:@"\n"];
    [self settingUHostSocketAddressWithHost:_host];
    int ttl = 1;
    in_addr_t ip = 0;
    static NSUInteger conuntinueUnreachableRoutes = 0;
    
    // 如果连续5个路由节点无响应，则终止traceroute.
    do {
        int t  = setsockopt(socket_send, IPPROTO_IP, IP_TTL, &ttl, sizeof(ttl));
        if (t < 0) {
            NSLog(@"error %s\n",strerror(t));
        }
        QCloudPNUdpTracerouteDetail *trace = [self sendData:ttl ip:&ip];
        if (trace.routeIp == nil) {
            conuntinueUnreachableRoutes++;
        }else{
            conuntinueUnreachableRoutes = 0;
        }
        
    } while (++ttl <= _maxTtl && ip != remote_addr.sin_addr.s_addr && !_isStop && conuntinueUnreachableRoutes < 10);
    
    close(socket_send);
    close(socket_recv);
    
    if (!_isStop) {
        _isStop = YES;
    }
    
    [_traceDetails appendString:@"udp traceroute complete...\n"];
    _complete(_traceDetails);
//    NSLog(@"udp traceroute complete...");
}


- (QCloudPNUdpTracerouteDetail *)sendData:(int)ttl ip:(in_addr_t *)ipOut
{
    int err = 0;
    struct sockaddr_in storageAddr;
    socklen_t n = sizeof(struct sockaddr);
    static char msg[24] = {0};
    char buff[100];
    
    QCloudPNUdpTracerouteDetail *trace = [[QCloudPNUdpTracerouteDetail alloc] init:ttl sendTimes:QCloudTracertSendIcmpPacketTimes];
    for (int i = 0; i < 3; i++) {
        NSDate* startTime = [NSDate date];
        ssize_t sent = sendto(socket_send, msg, sizeof(msg), 0, (struct sockaddr*)&remote_addr, sizeof(struct sockaddr));
        if (sent != sizeof(msg)) {
            NSLog(@"error %s",strerror(err));
            break;
        }
        
        struct timeval tv;
        tv.tv_sec = 5;
        tv.tv_usec = 0;
        
        fd_set readfds;
        FD_ZERO(&readfds);  // 初始化套接字集合（清空套接字集合） ,将readfds清零使集合中不含任何fd
        FD_SET(socket_recv,&readfds); // 将readfds加入set集合
        select(socket_recv + 1, &readfds, NULL, NULL,&tv);
        int r = FD_ISSET(socket_recv,&readfds);
        if (r > 0) {
            ssize_t res = recvfrom(socket_recv, buff, sizeof(buff), 0, (struct sockaddr*)&storageAddr, &n);
            if (res < 0) {
                err = errno;
                NSLog(@"recv error %s\n",strerror(err));
                break;
            }else{
                NSTimeInterval duration = [[NSDate date] timeIntervalSinceDate:startTime];
                char ip[16] = {0}; // 存放ip地址
                inet_ntop(AF_INET, &storageAddr.sin_addr.s_addr, ip, sizeof(ip));
                *ipOut = storageAddr.sin_addr.s_addr;
                NSString *routeIp = [NSString stringWithFormat:@"%s",ip];
                trace.routeIp = routeIp;
                trace.durations[i] = duration;
            }
        }

    }
    
    [_traceDetails appendString:trace.description];
    [_traceDetails appendString:@"\n"];
    _complete(_traceDetails);
    return trace;
}

+ (instancetype)start:(NSString * _Nonnull)host
             complete:(QCloudPNUdpTracerouteHandler _Nonnull)complete
{
    QCloudPNUdpTraceroute *udpTrace  = [[QCloudPNUdpTraceroute alloc] init:host maxTtl:QCloudTracertMaxTTL complete:complete];
    [QCloudPNetQueue pnet_async:^{
         [udpTrace sendAndRec];
    }];
    return udpTrace;
}

+ (instancetype)start:(NSString * _Nonnull)host
               maxTtl:(NSUInteger)maxTtl
             complete:(QCloudPNUdpTracerouteHandler _Nonnull)complete
{
    QCloudPNUdpTraceroute *udpTrace  = [[QCloudPNUdpTraceroute alloc] init:host maxTtl:maxTtl complete:complete];
    [QCloudPNetQueue pnet_async:^{
        [udpTrace sendAndRec];
    }];
    return udpTrace;
}

- (void)stopUdpTraceroute
{
    _isStop = YES;
}

- (BOOL)isDoingUdpTraceroute
{
    return !_isStop;
}

@end
