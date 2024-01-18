//
//  QCloudClsSessionCredentials.h
//  Pods-QCloudCOSXMLDemo
//
//  Created by garenwang on 2023/12/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QCloudClsSessionCredentials : NSObject

@property (nonatomic,strong)NSString * secretId;
@property (nonatomic,strong)NSString * secretKey;
@property (nonatomic,strong)NSString * token;
// 过期时间点 时间戳 10位
@property (nonatomic,assign)NSInteger expiredTime;

-(BOOL)isValid;

@end

NS_ASSUME_NONNULL_END
