//
//  QCloudClsLifecycleCredentialProvider.h
//  Pods-QCloudCOSXMLDemo
//
//  Created by garenwang on 2023/12/26.
//

#import <Foundation/Foundation.h>
#import "QCloudClsSessionCredentials.h"
NS_ASSUME_NONNULL_BEGIN

typedef QCloudClsSessionCredentials* _Nonnull (^QCloudCredentialRefreshBlock)(void);

@interface QCloudClsLifecycleCredentialProvider : NSObject

/// 使用永久凭证初始化凭证提供器
-(instancetype)initWithPermanentCredentials:(QCloudClsSessionCredentials *) credentials;

/// 使用刷新回调初始化凭证提供器
-(instancetype)initWithCredentialsRefresh:(QCloudCredentialRefreshBlock) refreshBlock;

/// 手动更新永久密钥
-(void)updatePermanentCredentials:(QCloudClsSessionCredentials *) credentials;

/// 获取凭证 临时密钥自动刷新 永久密钥直接返回
-(QCloudClsSessionCredentials *)getCredentials;

/// 强制临时密钥失效
-(void)forceInvalidationCredential;

@end

NS_ASSUME_NONNULL_END
