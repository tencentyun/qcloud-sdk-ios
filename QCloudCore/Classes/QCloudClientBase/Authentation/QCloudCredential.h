//
//  QCloudCredential.h
//  Pods
//
//  Created by Dong Zhao on 2017/5/2.
//
//

#import <Foundation/Foundation.h>

/**
 密钥
 */
@interface QCloudCredential : NSObject

/**
 开发者拥有的项目身份识别 ID，用以身份认证
 */
@property (nonatomic, strong) NSString* secretID;

/**
开发者拥有的项目身份密钥。可以为永久密钥，也可以是临时密钥（参考CAM系统）。
 */
@property (nonatomic, strong) NSString* secretKey;

/**
 签名有效期截止的时间。
 */
@property (nonatomic, strong) NSDate* experationDate;

/**
 改签名是否有效。
 */
@property (nonatomic, assign, readonly) BOOL valid;


/**
 当您使用了CAM系统获取临时密钥的时候，请设置改值，代表回话的ID。
 */
@property (nonatomic, strong) NSString* token;
@end
