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
@end

NS_ASSUME_NONNULL_END
