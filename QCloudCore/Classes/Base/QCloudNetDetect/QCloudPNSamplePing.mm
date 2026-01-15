//
//  QCloudPNSamplePing.h
//  PhoneNetSDK
//
//  Created by mediaios on 2019/6/5.
//  Copyright © 2019年 mediaios. All rights reserved.
//

#import "QCloudPNSamplePing.h"
#import "QCloudPhoneNetSDKConst.h"
#import "QCloudPNetQueue.h"
#import "QCloudCore/QCloudLogger.h"

@interface QCloudPNSamplePing()
{
    int lan_scan_socket_client;
    struct sockaddr_in lan_scan_remote_addr;
}

@property (nonatomic,assign) BOOL isStopPingThread;
@property (nonatomic,strong) NSString *scanIp;
@property (nonatomic,assign) int sendPacketCount;
@end

@implementation QCloudPNSamplePing

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
    shutdown(lan_scan_socket_client, SHUT_RDWR);
    close(lan_scan_socket_client);
    [self.delegate simplePing:self finished:self.scanIp];
}

- (BOOL)isPing
{
    return !self.isStopPingThread;
}

- (BOOL)settingUHostSocketAddressWithIp:(NSString *)host
{
    const char *hostaddr = [host UTF8String];
    memset(&lan_scan_remote_addr, 0, sizeof(lan_scan_remote_addr));
    lan_scan_remote_addr.sin_addr.s_addr = inet_addr(hostaddr);
    struct timeval timeout;
    timeout.tv_sec = 0;
    timeout.tv_usec = 1000*200;
    lan_scan_socket_client = socket(AF_INET,SOCK_DGRAM,IPPROTO_ICMP);
    int nZero=0;
    setsockopt(lan_scan_socket_client,SOL_SOCKET,SO_SNDBUF,(char *)&nZero,sizeof(nZero));
    int res = setsockopt(lan_scan_socket_client, SOL_SOCKET, SO_RCVTIMEO, &timeout, sizeof(timeout));
    if (res < 0) {
        QCloudLogWarningPB(@"PhoneNetSimplePing", @"ping %s , set timeout error..\n",[host UTF8String]);
        return YES;
    }
    lan_scan_remote_addr.sin_family = AF_INET;
    
    return YES;
}

- (void)startPingIp:(NSString *)ip packetCount:(int)count
{
    QCloudLogDebugPB(@"PhoneNetSimplePing", @"scan ip %s begin...",[ip UTF8String]);
    if ([self settingUHostSocketAddressWithIp:ip]) {
        self.scanIp = ip;
    }
    
    if (self.scanIp == NULL) {
        self.isStopPingThread = YES;
        QCloudLogWarningPB(@"PhoneNetSimplePing", @"There is no valid ip...\n");
        return;
    }
    
    if (count > 0) {
        _sendPacketCount = count;
    }
    [QCloudPNetQueue pnet_quick_ping_async:^{
        [self sendAndrecevPingPacket];
    }];
}

- (void)sendAndrecevPingPacket
{
    int index = 0;
    do {
        if (self.isStopPingThread) {
            return;
        }
        uint16_t identifier = (uint16_t)(KQCloudPingIcmpIdBeginNum + index);
        UICMPPacket *packet = [QCloudPhoneNetDiagnosisHelper constructPacketWithSeq:index andIdentifier:identifier];
        ssize_t sent = sendto(lan_scan_socket_client, packet, sizeof(UICMPPacket), 0, (struct sockaddr *)&lan_scan_remote_addr, (socklen_t)sizeof(struct sockaddr));
        if (sent < 0) {
            QCloudLogWarningPB(@"PhoneNetSimplePing", @"ping %s , error code:%d, send icmp packet error..\n",[self.scanIp UTF8String],(int)sent);
            [self stopPing];
            break;
        }
        
        BOOL res = NO;
        struct sockaddr_storage ret_addr;
        socklen_t addrLen = sizeof(ret_addr);
        void *buffer = malloc(65535);
        
        size_t bytesRead = recvfrom(lan_scan_socket_client, buffer, 65535, 0, (struct sockaddr *)&ret_addr, &addrLen);
        
        if ((int)bytesRead < 0) {
            [self.delegate simplePing:self didTimeOut:self.scanIp];
            res = YES;
        }else if(bytesRead == 0){
            QCloudLogWarningPB(@"PhoneNetSimplePing", @"ping %s , receive icmp packet error , bytesRead=0",[self.scanIp UTF8String]);
        }else{
            
            if ([QCloudPhoneNetDiagnosisHelper isValidPingResponseWithBuffer:(char *)buffer len:(int)bytesRead]) {
                [self.delegate simplePing:self receivedPacket:self.scanIp];
                [self stopPing];
                break;
            }
        }
        
        if (res) {
            index++;
        }
        usleep(1000);
    } while (!self.isStopPingThread && index < _sendPacketCount);
    
    if (index == _sendPacketCount) {
        [self stopPing];
    }
    
}
@end
