//
//  QCloudQuicSession.h
//  QCloudCore
//
//  Created by karisli(李雪) on 2019/3/22.
//

#import <Foundation/Foundation.h>

@class QCloudQuicDataTask;

NS_ASSUME_NONNULL_BEGIN

@interface QCloudQuicSession<BodyType> : NSURLSession

+ (instancetype)quicSessionDelegate:(nullable id<NSURLSessionDataDelegate>)delegate;
@property (nullable, readonly, retain) id<NSURLSessionDataDelegate> delegate;
@property (nonatomic)NSInteger port;
@property (nonatomic)NSInteger tcp_port;
- (QCloudQuicDataTask *)quicDataTaskWithRequst:(NSMutableURLRequest *)httpRequs infos:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
