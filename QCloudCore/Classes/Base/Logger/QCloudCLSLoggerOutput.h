//
//  QCloudCLSLoggerOutput.h
//  QCloudCore
//
//  Created by garenwang on 2025/4/7.
//

#import <QCloudCore/QCloudCore.h>
NS_ASSUME_NONNULL_BEGIN

@interface QCloudCLSLoggerOutput : QCloudLoggerOutput

@property (nonatomic,strong,readonly)id clsService;
- (instancetype)initWithTopicId:(NSString *)topicId endpoint:(NSString *)endPoint;

- (void)setupPermanentCredentialsSecretId:(NSString *)secretId secretKey:(NSString *)secretKey;

- (void)setupCredentialsRefreshBlock:(QCloudCredential * _Nonnull (^)(void))refreshBlock;

@end

NS_ASSUME_NONNULL_END
