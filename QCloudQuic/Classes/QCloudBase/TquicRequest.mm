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
        NSString *oringeHost = [headerFileds objectForKey:@"Host"];
//        [self.quicAllHeaderFields setValue:oringeHost forKey:@"vod-forward-cos"];
        [self.quicAllHeaderFields setValue:host forKey:@":authority"];
        [self.quicAllHeaderFields setValue:httpMethod forKey:@":method"];
        [self.quicAllHeaderFields setValue:url.scheme forKey:@":scheme"];

        NSString *path = url.path;
        
        if (url.query) {
            path = [NSString stringWithFormat:@"%@?%@",path,url.query];
        }
        if (path.length!=0) {
            if (![[path substringToIndex:1] isEqualToString:@"/"]) {
                path = [NSString stringWithFormat:@"/?%@",url.query];
            }
        }else{
            path = @"/";
        }
       
        [self.quicAllHeaderFields setValue:path forKey:@":path"];
        //移除之前的host
        [self.quicAllHeaderFields removeObjectForKey:@"Host"];
        
    }
    return self;
}

-(void)dealloc{
    NSLog(@"TquicRequest dealloc");
}
@end
