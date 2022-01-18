//
//  TquicRequest.m
//  TquicNet
//
//  Created by karisli(李雪) on 2019/3/20.
//  Copyright © 2019 tencentyun.com. All rights reserved.
//

#import "TquicRequest.h"
#import "TquicDNS.h"
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netdb.h>
@interface TquicRequest()
@property (nonatomic,strong,readwrite)NSMutableDictionary *quicAllHeaderFields;
@property (nonatomic,copy,readwrite)NSString *ip;
@property (nonatomic,copy,readwrite)NSString *host;
@property (nonatomic,copy,readwrite)NSString *httpMethod;

@end


@implementation TquicRequest

- (instancetype)initWithURL:(NSURL *)url host:(NSString *)host httpMethod:(NSString *)httpMethod ip:(NSString *)ip body:(id)body headerFileds:(NSDictionary *)headerFileds{
    if (self = [super init]) {
        self.host = host;
        self.ip = ip;
        self.httpMethod = httpMethod;
        self.body = body;
        self.quicAllHeaderFields = [headerFileds mutableCopy];
        if([httpMethod isEqualToString:@"POST"]){
            [self.quicAllHeaderFields setValue:@(0) forKey:@"content-length"];
        }
        
    }
    return self;
}

-(void)dealloc{
    NSLog(@"TquicRequest dealloc");
}
@end
