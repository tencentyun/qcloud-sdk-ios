//
//  TquicResponse.m
//  TquicNet
//
//  Created by karisli(李雪) on 2019/3/19.
//  Copyright © 2019 tencentyun.com. All rights reserved.
//

#import "TquicResponse.h"
@interface TquicResponse ()
@property (nonatomic, readwrite) NSInteger statusCode;
@property (readwrite, copy) NSDictionary *allHeaderFields;
@property (readwrite, copy) NSString *httpVersion;
@end
@implementation NSString (filteCharacter)

- (NSString *)filteCharacter {
    NSString *temp = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [self stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [self stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}

@end

@implementation TquicResponse
- (instancetype)initWithStatusCode:(NSInteger)statusCode
                       HTTPVersion:(NSString *)HTTPVersion
                      headerFields:(NSDictionary<NSString *, NSString *> *)headerFields {
    if (self = [super init]) {
        self.statusCode = statusCode;
        self.allHeaderFields = headerFields;
        self.httpVersion = HTTPVersion;
    }
    return self;
}
- (instancetype)initWithQuicResponseStr:(NSString *)quiResponseStr {
    if (self = [super init]) {
        NSMutableDictionary *allHedares = [NSMutableDictionary dictionary];
        NSArray *tempArray = [quiResponseStr componentsSeparatedByString:@"\n"];
        NSMutableArray *headersArray = [tempArray mutableCopy];
        NSArray *baseInfo = [tempArray[0] componentsSeparatedByString:@" "];
        if (baseInfo.count < 3) {
            @throw [NSException exceptionWithName:@"com.tencent.qcloud.quic.error" reason:@"服务器响应格式不合法" userInfo:nil];
        }
        quiResponseStr = [quiResponseStr filteCharacter];
        for (int i = 1; i < tempArray.count; i++) {
            headersArray[i - 1] = tempArray[i];
        }

        for (int i = 0; i < headersArray.count; i++) {
            NSString *header = headersArray[i];
            header = [header filteCharacter];
            NSArray *headerArr = [header componentsSeparatedByString:@": "];
            if (headerArr.count > 1) {
                NSString *key = headerArr[0];
                NSString *value = headerArr[1];
                value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                allHedares[key] = [NSString stringWithFormat:@"%@", value];
            }
        }
        self.allHeaderFields = [allHedares copy];
        self.httpVersion = baseInfo[0];
        self.statusCode = [baseInfo[1] integerValue];
    }
    return self;
}

@end
