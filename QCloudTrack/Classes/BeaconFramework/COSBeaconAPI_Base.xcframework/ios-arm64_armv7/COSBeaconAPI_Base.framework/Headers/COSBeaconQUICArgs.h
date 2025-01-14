//
//  COSBeaconTransferArgs.h
//  COSBeaconAPI_Base
//
//  Created by jackhuali on 2021/3/2.
//  Copyright © 2021 tencent.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * QUIC转发传递的参数对象
 */
@interface COSBeaconQUICArgs : NSObject

/// 请求实体
@property (nonatomic, copy) NSMutableURLRequest *reqeust;

/// 连接超时时间
@property (nonatomic, assign) NSTimeInterval connectTimeoutMillis;

/// 事件名
@property (nonatomic, copy) NSString *eventCode;

/// 事件appkey
@property (nonatomic, copy) NSString *appKey;

@end

NS_ASSUME_NONNULL_END
