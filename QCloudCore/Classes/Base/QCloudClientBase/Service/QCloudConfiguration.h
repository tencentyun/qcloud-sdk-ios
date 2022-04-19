//
//  QCloudCommenService.h
//  Pods
//
//  Created by karisli(李雪) on 2021/7/14.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface QCloudConfiguration : NSObject

/**
 是否关闭分享Log日志的功能
 */
@property (nonatomic, assign) BOOL isCloseShareLog;

@property (nonatomic, assign) NSTimeInterval timeoutInterval;

@property (nonatomic, assign) BOOL enableQuic;
@end

NS_ASSUME_NONNULL_END
