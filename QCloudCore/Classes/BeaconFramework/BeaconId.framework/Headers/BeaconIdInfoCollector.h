//
//  BeaconIdInfoCollector.h
//  BeaconAPI_Base
//
//  Created by jackhuali on 2020/4/22.
//  Copyright © 2020 tencent.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BeaconIdInfoCollector : NSObject

/// 采集指纹，会在内存缓存，内存有值时，直接返回内存的指纹
+ (nullable NSString *)collectBeaconIdInfo;

@end

NS_ASSUME_NONNULL_END
