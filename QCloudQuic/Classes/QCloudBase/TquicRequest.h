//
//  TquicRequest.h
//  TquicNet
//
//  Created by karisli(李雪) on 2019/3/20.
//  Copyright © 2019 tencentyun.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TquicRequest<BodyType> : NSObject
@property (nonatomic, strong, readonly) NSMutableDictionary *quicAllHeaderFields;
@property (nonatomic, copy, readonly) NSString *ip;
@property (nonatomic, copy, readonly) NSString *host;
@property (nonatomic, copy, readonly) NSString *httpMethod;

@property (nonatomic, strong) BodyType body;
- (instancetype)init __attribute__((unavailable("call other method instead")));
+ (instancetype)new __attribute__((unavailable("call other method instead")));
- (instancetype)initWithURL:(NSURL *)url
                       host:(NSString *)host
                 httpMethod:(NSString *)httpMethod
                         ip:(NSString *)ip
                       body:(BodyType)body
               headerFileds:(NSDictionary *)headerFileds;
@end

NS_ASSUME_NONNULL_END
