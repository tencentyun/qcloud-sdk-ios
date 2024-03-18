//
//  QualityDataUploader.h
//  QCloudCOSXML
//
//  Created by erichmzhang(张恒铭) on 2018/8/23.
//

#import <Foundation/Foundation.h>
@class QCloudAbstractRequest;
#pragma mark -error key
extern  NSString *const kQCloudQualityErrorCodeKey;
extern  NSString *const kQCloudQualityErrorTypeServerName;
extern  NSString *const kQCloudQualityErrorTypeClientName;
extern  NSString *const kQCloudQualityErrorMessageKey;
extern  NSString *const kQCloudQualityErrorNameKey;
extern  NSString *const kQCloudQualityServiceNameKey;
extern  NSString *const kQCloudQualityErrorStatusCodeKey;
extern  NSString *const kQCloudQualityErrorTypeKey;
extern  NSString *const kQCloudQualityErrorIDKey;
extern  NSString *const kQCloudRequestAppkeyKey;

@interface QualityDataUploader : NSObject

/// 初始化公共参数
+(void)initCommonParams:(NSMutableDictionary * )commonParams;

/// 设置sdk 上报灯塔 appkey
/// - Parameter appkey: 灯塔appkey
+ (void)startWithAppkey:(NSString *)appkey;


/// SDK 内部使用，上报请求成功信息
+ (void)trackSDKRequestSuccessWithRequest:(QCloudAbstractRequest *)request params:(NSMutableDictionary * )commonParams;

/// SDK 内部使用，上报请求失败信息
+ (void)trackSDKRequestFailWithRequest:(QCloudAbstractRequest *)request error:(NSError *)error params:(NSMutableDictionary * )commonParams;

/// 使用 SDK 内默认 TrackService 上报数据
+ (void)trackNormalEventWithKey:(NSString *)key props:(NSDictionary *)props;

/// 指定 TrackService 上报数据
+ (void)trackNormalEventWithKey:(NSString *)key serviceKey:(NSString *)serviceKey props:(NSDictionary *)props;

/// SDK 内使用 上报基础数据
+ (void)trackBaseInfoToTrachCommonParams:(NSMutableDictionary * )commonParams;
@end
