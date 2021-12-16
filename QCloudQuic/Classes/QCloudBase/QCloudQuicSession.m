//
//  QCloudQuicSession.m
//  QCloudCore
//
//  Created by karisli(李雪) on 2019/3/22.
//

#import "QCloudQuicSession.h"
#import "QCloudQuicDataTask.h"
@interface QCloudQuicSession ()

@end
static QCloudQuicSession *quicSession;
id<NSURLSessionDataDelegate> quicDelegate;
@implementation QCloudQuicSession
+ (instancetype)quicSessionDelegate:(id<NSURLSessionDataDelegate>)delegate {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        quicSession = [[QCloudQuicSession alloc] init];

        quicDelegate = delegate;
    });
    return quicSession;
}
- (QCloudQuicDataTask *)quicDataTaskWithRequst:(NSMutableURLRequest *)httpRequst infos:(NSDictionary *)dic {
    id body = dic[@"body"];
    NSString *quicHost = dic[@"quicHost"];
    NSString *quicIp = dic[@"quicIP"];
    QCloudQuicDataTask *quicTask = [[QCloudQuicDataTask alloc] initWithHTTPRequest:httpRequst
                                                                          quicHost:quicHost
                                                                            quicIp:quicIp
                                                                              body:body
                                                                           headers:httpRequst.allHTTPHeaderFields
                                                                       quicSession:self];
    quicTask.quicDelegate = quicDelegate;
    return quicTask;
}


@end
