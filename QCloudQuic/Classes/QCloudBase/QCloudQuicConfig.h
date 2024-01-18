//
//  QCloudQuicConfig.h
//  QCloudQuic
//
//  Created by karisli(李雪) on 2021/11/22.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, QCloudRaceType) {

    QCloudRaceTypeOnlyQUIC,
    QCloudRaceTypeQUICHTTP,
    QCloudRaceTypeOnlyHTTP
};

typedef NS_ENUM(NSInteger, QCloudCongestionType) {

    QCloudCongestionTypeCubicBytes,
    QCloudCongestionTypeRenoBytes,
    QCloudCongestionTypeBBR,
    QCloudCongestionTypePCC,
    QCloudCongestionTypeGoogCC
};



NS_ASSUME_NONNULL_BEGIN

@interface QCloudQuicConfig : NSObject
+ (QCloudQuicConfig *)shareConfig;

// 设置连接超时时间，单位为ms，默认为4000ms
@property (nonatomic,assign)NSInteger connect_timeout_millisec_;
@property (nonatomic,assign)NSInteger total_timeout_millisec_;
//设置连接空闲时间，单位为ms，默认值为与服务端协商值，一般为90000ms
@property (nonatomic,assign) NSInteger idle_timeout_millisec_;
@property (nonatomic,assign)QCloudRaceType race_type;
@property (nonatomic,assign) bool is_custom;
@property (nonatomic, assign) NSInteger port;
@property (nonatomic, assign) NSInteger tcp_port;
// 设置拥塞算法，默认值即为BBR
@property (nonatomic,assign)QCloudCongestionType congestion_type;

// ConnectWithDomain get ipv6 ip if true, false defaultly.
@property (nonatomic,assign) bool support_v6_; // QCloudQuic/v83版本不生效

@property (nonatomic,assign) bool isCongetionOptimizationEnabled_; // QCloudQuic/v83版本不生效

@property (nonatomic,assign) NSInteger mp_strategy_; // QCloudQuic/v83版本不生效

// The max receive window for a whole session.
// unit is bytes, default is 15 MB, max is 24 MB
// The window size of session must be larger than
// a single stream's size. This size affects all
// the streams within this session.
@property (nonatomic,assign) NSUInteger nSessionMaxRecvWindowSize;

// The max receive window for a single stream
// unit is bytes, default is 6 MB, max is 16 MB
@property (nonatomic,assign) NSUInteger nStreamMaxRecvWindowSize;
// 默认:true
@property (nonatomic,assign) bool use_session_reuse_;
@end

NS_ASSUME_NONNULL_END
