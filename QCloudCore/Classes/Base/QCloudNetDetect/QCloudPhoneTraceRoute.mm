//
//  UTraceRoute.m
//  PingDemo
//
//  Created by mediaios on 08/08/2018.
//  Copyright © 2018 mediaios. All rights reserved.
//

#import "QCloudPhoneTraceRoute.h"
#import "QCloudPhoneNetSDKConst.h"
#import "QCloudPNetQueue.h"
#import "QCloudCore/QCloudLogger.h"

typedef enum PNetRecTracertIcmpType{
    PNetRecTracertIcmpType_None = 0,
    PNetRecTracertIcmpType_noReply,
    PNetRecTracertIcmpType_routeReceive,
    PNetRecTracertIcmpType_Dest
}PNetRecTracertIcmpType;

@interface QCloudPhoneTraceRoute()
{
    int socket_client;
    struct sockaddr_in  remote_addr;   // server address
}

@property (nonatomic,strong) NSString *host;
@property (nonatomic,assign) BOOL isStopTracert;
@property (nonatomic,assign) PNetRecTracertIcmpType lastRecTracertIcmpType;
@property (nonatomic,strong) NSDate  *sendDate;
@end

@implementation QCloudPhoneTraceRoute

- (instancetype)init
{
    if ([super init]) {
        _isStopTracert = NO;
        _lastRecTracertIcmpType = PNetRecTracertIcmpType_None;
    }
    return self;
}

- (void)stopTracert
{
    self.isStopTracert = YES;
}

- (BOOL)isTracert
{
    return !self.isStopTracert;
}

-(void)settingUHostSocketAddressWithHost: (NSString *)host
{
    const char *hostaddr = [host UTF8String];
    memset(&remote_addr, 0, sizeof(remote_addr));
    remote_addr.sin_addr.s_addr = inet_addr(hostaddr);

    if (remote_addr.sin_addr.s_addr == INADDR_NONE) {
        struct hostent *remoteHost = gethostbyname(hostaddr);
        remote_addr.sin_addr = *(struct in_addr *)remoteHost->h_addr;
    }

    struct timeval timeout;
    timeout.tv_sec = 1;
//      timeout.tv_sec = 0;
//    timeout.tv_usec = 1000*kIcmpPacketTimeoutTime;
    timeout.tv_usec = 0;

    socket_client = socket(AF_INET, SOCK_DGRAM, IPPROTO_ICMP);
    int res = setsockopt(socket_client, SOL_SOCKET, SO_RCVTIMEO, &timeout, sizeof(timeout));
    if (res < 0) {
        QCloudLogWarningPB(@"PhoneNetTracert", @"tracert %s , set timeout error..\n", [host UTF8String]);
    }
    remote_addr.sin_family = AF_INET;
}

- (BOOL)verificationHost:(NSString *)host
{
    NSArray *address = [QCloudPhoneNetDiagnosisHelper resolveHost:host];
    if (address.count > 0) {
        NSString *ipAddress = [address firstObject];
        _host = ipAddress;
    }else{
        QCloudLogWarningPB(@"PhoneNetTracert", @"access %s DNS error , remove this ip..\n",[host UTF8String]);
    }
    
    if (_host == NULL) {
        return NO;
    }
    return YES;
}

- (void)startTracerouteHost:(NSString *)host
{
    if (![self verificationHost:host]) {
        self.isStopTracert = YES;
        QCloudLogWarningPB(@"PhoneNetTracert", @"there is no valid domain in the domain list , traceroute complete..\n");
        return;
    }
    
    [QCloudPNetQueue pnet_trace_async:^{
        [self settingUHostSocketAddressWithHost:self.host];
        [self startTracert:self->socket_client andRemoteAddr:self->remote_addr];
    }];
}

-(void)startTracert:(int)socketClient andRemoteAddr:(struct sockaddr_in)remoteAddr {
    if (self.isStopTracert) {
        return;
    }

    int ttl = 1;
    int consecutivePacketLossCount = 0;
    PNetRecTracertIcmpType rec = PNetRecTracertIcmpType_noReply;
    QCloudLogDebugPB(@"PhoneNetTracert", @"begin tracert ip: %s ", [self.host UTF8String]);

    self.lastRecTracertIcmpType = PNetRecTracertIcmpType_None;
    __block QCloudPTracerRouteResModel *last_record;
    do {
        int setTtlRes = setsockopt(socketClient, IPPROTO_IP, IP_TTL, &ttl, sizeof(ttl));
        if (setTtlRes < 0) {
            QCloudLogDebugPB(@"PhoneNetTracert", @"set TTL for icmp packet error..");
            return; // 或者采取其他措施
        }

        uint16_t identifier = (uint16_t)(5000 + ttl);
        PICMPPacket_Tracert *packet = [QCloudPhoneNetDiagnosisHelper constructTracertICMPPacketWithSeq:ttl andIdentifier:identifier];

        QCloudPTracerRouteResModel *record = [[QCloudPTracerRouteResModel alloc] init:ttl count:QCloudTracertSendIcmpPacketTimes];

        for (int trytime = 0; trytime < QCloudTracertSendIcmpPacketTimes; trytime++) {
            _sendDate = [NSDate date];
            size_t sent = sendto(socketClient, packet, sizeof(PICMPPacket_Tracert), 0, (struct sockaddr *)&remoteAddr, sizeof(struct sockaddr_in));
            if ((int)sent < 0) {
                QCloudLogDebugPB(@"PhoneNetTracert", @"send icmp packet failed, error info :%s", strerror(errno));
                break;
            }
            rec = [self receiverRemoteIpTracertRes:ttl packetSeq:trytime record:record];

            if (rec == PNetRecTracertIcmpType_noReply && self.lastRecTracertIcmpType == PNetRecTracertIcmpType_noReply) {
                consecutivePacketLossCount++;
                if (consecutivePacketLossCount == QCloudTracertRouteCount_noRes * QCloudTracertSendIcmpPacketTimes) {
                    QCloudLogDebugPB(@"PhoneNetTracert", @"%d consecutive routes are not responding ,and end the tracert ip: %s", QCloudTracertRouteCount_noRes, [self.host UTF8String]);
                    rec = PNetRecTracertIcmpType_Dest;

                    record.dstIp = self.host;
                    record.status = Enum_Traceroute_Status_finish;
                    break;
                }
            } else {
                consecutivePacketLossCount = 0;
            }
            self.lastRecTracertIcmpType = rec;

            if (self.isStopTracert) {
                break;
            }
        }

        last_record = record;
        [self.delegate tracerouteWithUCTraceRoute:self tracertResult:record];

    } while (++ttl <= QCloudTracertMaxTTL && (rec == PNetRecTracertIcmpType_routeReceive || rec == PNetRecTracertIcmpType_noReply) && !self.isStopTracert);

    shutdown(socketClient, SHUT_RDWR);
    self.isStopTracert = YES;
    [self.delegate tracerouteWithUCTraceRoute:self tracertResult:last_record];
}

-(PNetRecTracertIcmpType)receiverRemoteIpTracertRes: (int)ttl packetSeq: (int)seq record: (QCloudPTracerRouteResModel *)record
{
    PNetRecTracertIcmpType res = PNetRecTracertIcmpType_routeReceive;
    char buff[200];
    socklen_t addrLen = sizeof(struct sockaddr_in);
    record.dstIp = self.host;
    size_t resultLen = recvfrom(socket_client, buff, sizeof(buff), 0, (struct sockaddr *)&remote_addr, &addrLen);
    if ((int)resultLen < 0) {
        res = PNetRecTracertIcmpType_noReply;
    } else {
        NSString *remoteAddress = nil;
        char ip[INET_ADDRSTRLEN] = { 0 };
        inet_ntop(AF_INET, &((struct sockaddr_in *)&remote_addr)->sin_addr.s_addr, ip, sizeof(ip));
        remoteAddress = [NSString stringWithUTF8String:ip];

        if ([QCloudPhoneNetDiagnosisHelper isTimeoutPacket: buff len:(int)resultLen] && ![remoteAddress isEqualToString: self.host]) {
            NSTimeInterval duration = [[NSDate date] timeIntervalSinceDate:_sendDate];
            record.durations[seq] = duration;
            record.ip = remoteAddress;
        } else if ([QCloudPhoneNetDiagnosisHelper isEchoReplayPacket: buff len:(int)resultLen] && [remoteAddress isEqualToString: self.host]) {
            NSTimeInterval duration = [[NSDate date] timeIntervalSinceDate:_sendDate];
            record.durations[seq] = duration;
            record.ip = remoteAddress;
            record.status = Enum_Traceroute_Status_finish;
            res = PNetRecTracertIcmpType_Dest;
        }
    }
    return res;
}
@end
