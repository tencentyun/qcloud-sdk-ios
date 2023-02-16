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

/// 是否禁止上传空文件  NO 不禁止。YES 禁止
@property (nonatomic, assign) BOOL disableUploadZeroData;
@end

NS_ASSUME_NONNULL_END
