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

//部分业务无法使用qq.com域名，需要将自己的域名映射到https://snowflake.qq.com/ola
@property (nonatomic, copy) NSString *domain;

@end

NS_ASSUME_NONNULL_END
