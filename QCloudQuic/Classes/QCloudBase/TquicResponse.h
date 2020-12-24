//
//  TquicResponse.h
//  TquicNet
//
//  Created by karisli(李雪) on 2019/3/19.
//  Copyright © 2019 tencentyun.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TquicResponse : NSObject
@property (readonly) NSInteger statusCode;
@property (readonly, copy) NSDictionary *allHeaderFields;
@property (readonly, copy) NSString *httpVersion;
- (instancetype)initWithQuicResponseStr:(NSString *)quiResponseStr;
- (nullable instancetype)initWithStatusCode:(NSInteger)statusCode
                                HTTPVersion:(nullable NSString *)HTTPVersion
                               headerFields:(nullable NSDictionary<NSString *, NSString *> *)headerFields
    API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0));
@end

NS_ASSUME_NONNULL_END
