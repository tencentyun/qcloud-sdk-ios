//
//  PNDomainLook.m
//  PhoneNetSDK
//
//  Created by mediaios on 2019/2/28.
//  Copyright © 2019 mediaios. All rights reserved.
//

#import "QCloudPNDomainLookup.h"
#import "QCloudPhoneNetSDKConst.h"
#import "QCloudPhoneNetDiagnosisHelper.h"
#import "QCloudPNetTools.h"
#import "QCloudCore/QCloudLogger.h"

@interface QCloudPNDomainLookup()
{
    int socket_client;
    struct sockaddr_in remote_addr;
}

@end

@implementation QCloudPNDomainLookup

static QCloudPNDomainLookup *QCloudPNDomainLookup_instance = NULL;
- (instancetype)init
{
    if (self = [super init]) {}
    return self;
}

+ (instancetype)shareInstance
{
    if (QCloudPNDomainLookup_instance == NULL) {
        QCloudPNDomainLookup_instance = [[QCloudPNDomainLookup alloc] init];
    }
    return QCloudPNDomainLookup_instance;
}

- (void)lookupDomain:(NSString * _Nonnull)domain completeHandler:(NetLookupResultHandler _Nonnull)handler;
{
    if (![QCloudPNetTools validDomain:domain]) {
        QCloudLogWarningPB(@"PhoneNetSDKLookup", @"your setting domain invalid..\n");
        handler(nil,[PNError errorWithInvalidArgument:@"domain invalid"]);
        return;
    }
    const char *hostaddr = [domain UTF8String];
    memset(&remote_addr, 0, sizeof(remote_addr));
    remote_addr.sin_addr.s_addr = inet_addr(hostaddr);
    
    if (remote_addr.sin_addr.s_addr == INADDR_NONE) {
        struct hostent *remoteHost = gethostbyname(hostaddr);
        if (remoteHost == NULL || remoteHost->h_addr == NULL) {
            QCloudLogWarningPB(@"PhoneNetSDKLookup", @"DNS parsing error...\n");
            handler(nil,[PNError errorWithInvalidCondition:[NSString stringWithFormat:@"DNS Parsing failure"]]);
            return;
        }
        
        NSMutableArray *mutArray = [NSMutableArray array];
        for (int i = 0; remoteHost->h_addr_list[i]; i++) {
            QCloudLogDebugPB(@"PhoneNetSDKLookup", @"IP addr %d , name: %s , addr:%s  \n",i+1,remoteHost->h_name,inet_ntoa(*(struct in_addr*)remoteHost->h_addr_list[i]));
            [mutArray addObject:[DomainLookUpRes  instanceWithName:[NSString stringWithUTF8String:remoteHost->h_name]  address:[NSString stringWithUTF8String:inet_ntoa(*(struct in_addr*)remoteHost->h_addr_list[i])]]];
        }
        handler(mutArray,nil);
        return;
    }
    
    QCloudLogWarningPB(@"PhoneNetSDKLookup", @"your setting domain error..\n");
    handler(nil,[PNError errorWithInvalidCondition:@"domain error"]);
    return;
}
@end
