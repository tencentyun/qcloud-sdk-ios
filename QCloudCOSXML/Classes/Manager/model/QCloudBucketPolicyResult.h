//
//  QCloudBucketPolicyResult.h
//  QCloudCOSXML
//
//  Created by garenwang on 2023/2/4.
//

#import <Foundation/Foundation.h>
@class QCloudBucketPolicyResultItem;
@class QCloudBucketPolicyResultItemPrincipal;

NS_ASSUME_NONNULL_BEGIN

@interface QCloudBucketPolicyResult : NSObject

/// 权限策略生命列表
@property (strong, nonatomic) NSArray<QCloudBucketPolicyResultItem *> * Statement;

/// 版本号，固定2.0    String    是
@property (strong, nonatomic) NSString * version;
@end

@interface QCloudBucketPolicyResultItem : NSObject

/// 身份信息    ObjectArray    是
@property (strong, nonatomic) QCloudBucketPolicyResultItemPrincipal * Principal;

/// 效力，枚举值：allow、deny    String    是
@property (strong, nonatomic) NSString * Effect;

/// 策略生效的相关 Action 列表，支持通配符*    StringArray    是
@property (strong, nonatomic) NSArray * Action;

/// 相关的资源标识字符串列表
@property (strong, nonatomic) NSArray * Resource;
@end

@interface QCloudBucketPolicyResultItemPrincipal : NSObject

/// 身份信息标识字符串
/// 格式：qcs::cam::uin/100000000001:uin/100000000011
/// 其中100000000001 是主账号，100000000011是子账号    String    是
@property (strong, nonatomic) NSArray * qcs;
@end
NS_ASSUME_NONNULL_END
