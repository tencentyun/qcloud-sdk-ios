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

// 禁用主备域名切换。默认不禁用。NO:不禁用 YES:禁用
@property (nonatomic, assign) BOOL disableChangeHost;

/// 是否禁止上传空文件  NO 不禁止。YES 禁止
@property (nonatomic, assign) BOOL disableUploadZeroData;


/// 是否全局禁用HTTPDNSPrefetch功能获取到IP。
@property (nonatomic, assign) BOOL disableGlobalHTTPDNSPrefetch;

/// 是否全局禁用HTTPS验证，默认为NO 不禁用。
@property (nonatomic, assign) BOOL disableGlobalAuthentication;
@end

NS_ASSUME_NONNULL_END
