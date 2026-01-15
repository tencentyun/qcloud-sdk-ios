//
//  QCloudPhonePing.m
//  PingDemo
//
//  Created by mediaios on 03/08/2018.
//  Copyright © 2018 mediaios. All rights reserved.
//

#import "QCloudPhonePing.h"
#import "QCloudPhoneNetSDKConst.h"
#import "QCloudPNetQueue.h"
#import "QCloudCore/QCloudLogger.h"

@interface QCloudPhonePing()
{
    int socket_client;
    struct sockaddr_in remote_addr;
}
@property (nonatomic,assign) BOOL isPing;

@property (nonatomic,assign) BOOL isStopPingThread;
@property (nonatomic,strong) NSString *host;
@property (nonatomic,strong) NSDate   *sendDate;
@property (nonatomic,assign) int pingPacketCount;
@end

@implementation QCloudPhonePing

- (instancetype)init
{
    if ([super init]) {
        
        _isStopPingThread = NO;
    }
    return self;
}

- (void)stopPing
{
    self.isStopPingThread = YES;
    [self reporterPingResWithSorceIp:self.host ttl:0 timeMillSecond:0 seq:0 icmpId:0 dataSize:0 pingStatus:PhoneNetPingStatusFinished];
}

- (BOOL)isPing
{
    return !self.isStopPingThread;
}

- (BOOL)settingUHostSocketAddressWithHost:(NSString *)host
{
        const char *hostaddr = [host UTF8String];
        memset(&remote_addr, 0, sizeof(remote_addr));
        remote_addr.sin_addr.s_addr = inet_addr(hostaddr);
        
        if (remote_addr.sin_addr.s_addr == INADDR_NONE) {
            struct hostent *remoteHost = gethostbyname(hostaddr);
            if (remoteHost == NULL || remoteHost->h_addr == NULL) {
                QCloudLogWarningPB(@"PhoneNetPing", @"access %s DNS error, remove this ip..\n",[host UTF8String]);
                return NO;
            }
            remote_addr.sin_addr = *(struct in_addr *)remoteHost->h_addr;
        }
        
        struct timeval timeout;
        timeout.tv_sec = 1;
        timeout.tv_usec = 0;
        socket_client = socket(AF_INET,SOCK_DGRAM,IPPROTO_ICMP);
        int res = setsockopt(socket_client, SOL_SOCKET, SO_RCVTIMEO, &timeout, sizeof(timeout));
        if (res < 0) {
            QCloudLogWarningPB(@"PhoneNetPing", @"ping %s , set timeout error..\n",[host UTF8String]);
        }
        remote_addr.sin_family = AF_INET;

    return YES;
}

- (NSString *)convertDomainToIp:(NSString *)host
{
    const char *hostaddr = [host UTF8String];
    memset(&remote_addr, 0, sizeof(remote_addr));
    remote_addr.sin_addr.s_addr = inet_addr(hostaddr);
    
    if (remote_addr.sin_addr.s_addr == INADDR_NONE) {
        struct hostent *remoteHost = gethostbyname(hostaddr);
        if (remoteHost == NULL || remoteHost->h_addr == NULL) {
            QCloudLogWarningPB(@"PhoneNetPing", @"access %s DNS error, remove this ip..\n",[host UTF8String]);
            return NULL;
        }
        remote_addr.sin_addr = *(struct in_addr *)remoteHost->h_addr;
        return [NSString stringWithFormat:@"%s",inet_ntoa(remote_addr.sin_addr)];
    }
    return host;
}

- (void)startPingHosts:(NSString *)host packetCount:(int)count
{
    if ([self settingUHostSocketAddressWithHost:host]) {
        self.host = [self convertDomainToIp:host];
    }
    
    if (self.host == NULL) {
        self.isStopPingThread = YES;
        QCloudLogWarningPB(@"PhoneNetPing", @"There is no valid domain...\n");
        return;
    }
    
    if (count > 0) {
        _pingPacketCount = count;
    }
    
    [QCloudPNetQueue pnet_ping_async:^{
        [self sendAndrecevPingPacket];
    }];
}

- (void)sendAndrecevPingPacket
{
    [self settingUHostSocketAddressWithHost:self.host];
    int index = 0;
    BOOL isReceiverRemoteIpPingRes = NO;
    
    do {
        uint16_t identifier = (uint16_t)(KQCloudPingIcmpIdBeginNum + index);
        UICMPPacket *packet = [QCloudPhoneNetDiagnosisHelper constructPacketWithSeq:index andIdentifier:identifier];
        _sendDate = [NSDate date];
        ssize_t sent = sendto(socket_client, packet, sizeof(UICMPPacket), 0, (struct sockaddr *)&remote_addr, (socklen_t)sizeof(struct sockaddr));
        if (sent < 0) {
            QCloudLogWarningPB(@"PhoneNetPing", @"ping %s , send icmp packet error..\n",[self.host UTF8String]);
        }

        isReceiverRemoteIpPingRes = [self receiverRemoteIpPingRes];
        
        if (isReceiverRemoteIpPingRes) {
            index++;
        }
        usleep(1000*500);
    } while (!self.isStopPingThread && index < _pingPacketCount && isReceiverRemoteIpPingRes);
    
    if (index == _pingPacketCount) {
        QCloudLogDebugPB(@"PhoneNetPing", @"ping complete..\n");
        /*
         int shutdown(int s, int how); // s is socket descriptor
         int how can be:
         SHUT_RD or 0 Further receives are disallowed
         SHUT_WR or 1 Further sends are disallowed
         SHUT_RDWR or 2 Further sends and receives are disallowed
         */
        shutdown(socket_client, SHUT_RDWR); //
        self.isStopPingThread = YES;
        
        [self reporterPingResWithSorceIp:self.host ttl:0 timeMillSecond:0 seq:0 icmpId:0 dataSize:0 pingStatus:PhoneNetPingStatusFinished];
    }
    
}

- (BOOL)receiverRemoteIpPingRes
{
    BOOL res = NO;
    struct sockaddr_storage ret_addr;
    socklen_t addrLen = sizeof(ret_addr);
    void *buffer = malloc(65535);

        size_t bytesRead = recvfrom(socket_client, buffer, 65535, 0, (struct sockaddr *)&ret_addr, &addrLen);
        
        if ((int)bytesRead < 0) {
            
//            NSLog(@"PhoneNetPing , ping %@ , receive icmp packet timeout..\n",self.host );
            [self reporterPingResWithSorceIp:self.host ttl:0 timeMillSecond:0 seq:0 icmpId:0 dataSize:0 pingStatus:PhoneNetPingStatusDidTimeout];
            
            res = YES;
        }else if(bytesRead == 0){
            QCloudLogWarningPB(@"PhoneNetPing", @"ping %s , receive icmp packet error , bytesRead=0",[self.host UTF8String]);
        }else{
            
            if ([QCloudPhoneNetDiagnosisHelper isValidPingResponseWithBuffer:(char *)buffer len:(int)bytesRead]) {
                
                UICMPPacket *icmpPtr = (UICMPPacket *)[QCloudPhoneNetDiagnosisHelper icmpInpacket:(char *)buffer andLen:(int)bytesRead];
                
                int seq = OSSwapBigToHostInt16(icmpPtr->seq);
                
                NSTimeInterval duration = [[NSDate date] timeIntervalSinceDate:_sendDate];
                
                int ttl = ((PNetIPHeader *)buffer)->timeToLive;
                int size = (int)(bytesRead-sizeof(PNetIPHeader));
                NSString *sorceIp = self.host;
                
                
//                NSLog(@"PhoneNetPing, ping %@ , receive icmp packet..\n",self.host );
                [self reporterPingResWithSorceIp:sorceIp  ttl:ttl timeMillSecond:duration*1000 seq:seq icmpId:OSSwapBigToHostInt16(icmpPtr->identifier) dataSize:size pingStatus:PhoneNetPingStatusDidReceivePacket];
                res = YES;
            }
        
        usleep(500);
    }
    return res;
}

- (void)reporterPingResWithSorceIp:(NSString *)sorceIp ttl:(int)ttl timeMillSecond:(float)timeMillSec seq:(int)seq icmpId:(int)icmpId dataSize:(int)size pingStatus:(PhoneNetPingStatus)status
{
    QCloudPPingResModel *pingResModel = [[QCloudPPingResModel alloc] init];
    pingResModel.status = status;
    pingResModel.IPAddress = sorceIp;
    
    switch (status) {
        case PhoneNetPingStatusDidReceivePacket:
        {
            pingResModel.ICMPSequence = seq;
            pingResModel.timeToLive = ttl;
            pingResModel.timeMilliseconds = timeMillSec;
            pingResModel.dateBytesLength = size;
        }
            break;
        case PhoneNetPingStatusFinished:
        {
            pingResModel.ICMPSequence = _pingPacketCount;
        }
            break;
        case PhoneNetPingStatusDidTimeout:
        {
            pingResModel.ICMPSequence = seq;
        }
            break;
            
        default:
            break;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate pingResultWithUCPing:self pingResult:pingResModel pingStatus:status];
    });
    
}


@end
