//
//  COSBeaconCallBackManager.h
//  COSBeaconAPI_Base
//
//  Created by 吴小二哥 on 2021/9/17.
//  Copyright © 2021 tencent.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "COSBeaconResult.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^COSBeaconMsfSendCallback)(COSBeaconMsfSendResult *beaconResult);

/**
 * 长连接Msf回调Manger,Msf是通过代理方式回调手Q端,为了简化手Q接入逻辑,多线程代理回调由灯塔内部处理.
 */
@interface COSBeaconCallBackManager : NSObject

+ (instancetype)sharedInstance;

/**
 * 获取callback记录个数
 */
- (NSInteger)getCallbackMapCount;

/**
 * 灯塔内部存储callback并关联sequenceId
 */
- (void)addCallBack:(COSBeaconMsfSendCallback )beaconCallBack withSequenceId:(NSInteger )sequenceId;

/**
 * msf 回调接入层回调灯塔
 */
- (void)callBackSendResult:(COSBeaconMsfSendResult *)result;

@end

NS_ASSUME_NONNULL_END
