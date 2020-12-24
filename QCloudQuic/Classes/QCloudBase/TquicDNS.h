//
//  TquicDNS.h
//  QCloudQuic
//
//  Created by karisli(李雪) on 2019/6/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TquicDNS : NSObject
+ (instancetype)shareDNS;
- (NSString *)resolveHostForDomain:(NSString *)domain;
- (void)setIP:(NSString *)ip forDomain:(NSString *)domain;
- (NSString *)queryIpForDomain:(NSString *)domain;
@end

NS_ASSUME_NONNULL_END
