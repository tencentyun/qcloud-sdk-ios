//
//  COSBeaconMsfSendArgs.h
//  COSBeaconAPI_Base
//
//  Created by 吴小二哥 on 2021/4/27.
//  Copyright © 2021 tencent.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 转发Msf携带的参数对象
 */
@interface COSBeaconMsfSendArgs : NSObject
/// 业务上报的事件的二进制内容
@property (nonatomic, strong) NSData *data;
/// 请求命令字
@property (nonatomic, copy) NSString *command;

@end

NS_ASSUME_NONNULL_END
