//
//  QCloudQuicConfig.m
//  QCloudQuic
//
//  Created by karisli(李雪) on 2021/11/22.
//

#import "QCloudQuicConfig.h"
static QCloudQuicConfig*_config;
@implementation QCloudQuicConfig
+ (QCloudQuicConfig *)shareConfig{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _config = [QCloudQuicConfig new];
    });
    return _config;
}

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return self;
    }
    // 设置连接超时时间，单位为ms，默认为4000ms
    self.connect_timeout_millisec_ = 2000;

    // 设置连接空闲时间，单位为ms，默认值为与服务端协商值，一般为90000ms
    self.idle_timeout_millisec_ = 1000;
    self.port = 443;
    self.tcp_port = 80;
    self.race_type = QCloudRaceTypeOnlyQUIC;
    self.congestion_type = QCloudCongestionTypeBBR;
    self.is_custom = NO;
    self.use_session_reuse_ = YES;
    return self;
}
@end
