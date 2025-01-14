//
//  QimeiServiceConfig.h
//  QimeiSDK
//
//  Created by pariszhao on 2020/12/17.
//  Copyright © 2020 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//QimeiService配置项
@interface QimeiServiceConfig : NSObject

//是否采集idfa,默认采集
@property (nonatomic, assign) BOOL collectIdfa;

//是否采集idfv，默认采集
@property (nonatomic, assign) BOOL collectIdfv;

//是否开启jsBridge，默认开启
//开启jsBridge之后，web可以通过特定的jsapi访问Qimei信息
@property (nonatomic, assign) BOOL openJsBridge;

@end

NS_ASSUME_NONNULL_END
