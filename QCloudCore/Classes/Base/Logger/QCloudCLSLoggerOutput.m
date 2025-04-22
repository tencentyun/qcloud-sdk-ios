//
//  QCloudCLSLoggerOutput.m
//  QCloudCore
//
//  Created by garenwang on 2025/4/7.
//

#import "QCloudCLSLoggerOutput.h"
#import "QCloudLogModel.h"
#import "NSDate+QCloud.h"
NSString * const QCloudTrackCosSdkLog = @"qcloud_track_cos_sdk_log";
@interface QCloudCLSLoggerOutput ()
@property (nonatomic,strong)id clsService;
@property (nonatomic, strong) dispatch_queue_t buildQueue;

@end


@implementation QCloudCLSLoggerOutput
- (instancetype)initWithTopicId:(NSString *)topicId endpoint:(NSString *)endPoint {
    if (self = [super init]) {
        Class trackServiceClass = NSClassFromString(@"QCloudCLSTrackService");
        if (trackServiceClass) {
            SEL initSelector = NSSelectorFromString(@"initWithTopicId:endpoint:");
            if ([trackServiceClass instancesRespondToSelector:initSelector]) {
                _clsService = [[trackServiceClass alloc] performSelector:initSelector withObject:topicId withObject:endPoint];
            }
        }
        _buildQueue = dispatch_queue_create("com.tencent.qcloud.logger.cls.build", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}


- (void)setupPermanentCredentialsSecretId:(NSString *)secretId secretKey:(NSString *)secretKey { // id 参数
    Class cla = NSClassFromString(@"QCloudClsSessionCredentials");
    if (!cla) {
        return;
    }
    id credentials = [[cla alloc]init];
    // 或更安全的版本（检查属性是否存在）
    SEL secretIdSelector = NSSelectorFromString(@"setSecretId:");
    if ([credentials respondsToSelector:secretIdSelector]) {
        [credentials setValue:secretId forKey:@"secretId"];
    }

    SEL secretKeySelector = NSSelectorFromString(@"setSecretKey:");
    if ([credentials respondsToSelector:secretKeySelector]) {
        [credentials setValue:secretKey forKey:@"secretKey"];
    }
    
    SEL selector = NSSelectorFromString(@"setupPermanentCredentials:");
    if ([_clsService respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [_clsService performSelector:selector withObject:credentials];
#pragma clang diagnostic pop
    }
}

- (void)setupCredentialsRefreshBlock:(QCloudCredential * _Nonnull (^)(void))refreshBlock {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (refreshBlock) {
            SEL selector = NSSelectorFromString(@"setupCredentialsRefreshBlock:");
            if ([_clsService respondsToSelector:selector]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [_clsService performSelector:selector withObject:^id _Nonnull{
                    
                    QCloudCredential *credential = refreshBlock();
                    if (!credential) {
                        return nil;
                    }
                    Class cla = NSClassFromString(@"QCloudClsSessionCredentials");
                    if (!cla) {
                        return nil;
                    }
                    id credentials = [[cla alloc]init];
                    // 或更安全的版本（检查属性是否存在）
                    SEL secretIdSelector = NSSelectorFromString(@"setSecretId:");
                    if ([credentials respondsToSelector:secretIdSelector]) {
                        [credentials setValue:credential.secretID forKey:@"secretId"];
                    }

                    SEL secretKeySelector = NSSelectorFromString(@"setSecretKey:");
                    if ([credentials respondsToSelector:secretKeySelector]) {
                        [credentials setValue:credential.secretKey forKey:@"secretKey"];
                    }
                    
                    SEL tokenSelector = NSSelectorFromString(@"setToken:");
                    if ([credentials respondsToSelector:tokenSelector]) {
                        [credentials setValue:credential.token forKey:@"token"];
                    }
                    
                    SEL expiredTimeSelector = NSSelectorFromString(@"setExpiredTime:");
                    if ([credentials respondsToSelector:expiredTimeSelector]) {
                        [credentials setValue:@([credential.expirationDate timeIntervalSince1970]) forKey:@"expiredTime"];
                    }
                    
                    return credentials;
                }];
        #pragma clang diagnostic pop
            }
        }
    });
}

- (void)appendLog:(QCloudLogModel * (^)(void))logCreate {
    QCloudWeakSelf(self);
    dispatch_async(_buildQueue, ^{
        QCloudStrongSelf(self);
        QCloudLogModel *log = logCreate();
        if (log.level <= [QCloudLogger sharedLogger].logClsLevel) {
            NSMutableDictionary *params = [NSMutableDictionary new];
            params[@"level"] = [QCloudLogModel descriptionForLogLevel:log.level]?:@"";
            params[@"category"] = [QCloudLogModel descriptionForLogCategory:log.category]?:@"";
            params[@"timestamp"] = @([log.date timeIntervalSince1970]).stringValue?:@"";
            params[@"threadName"] = log.threadName?:@"";
            params[@"tag"] = log.tag?:@"";
            params[@"message"] = log.message?:@"";
            params[@"deviceID"] = QCloudLogger.sharedLogger.deviceID?:@"";
            params[@"deviceModel"] = QCloudLogger.sharedLogger.deviceModel?:@"";
            params[@"appVersion"] = QCloudLogger.sharedLogger.appVersion?:@"";
            [QCloudLogger.sharedLogger.extendInfo enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if (obj && key) {
                    [params setObject:obj forKey:key];
                }
            }];

            // 动态调用 reportWithEventCode:params:
            SEL selector = NSSelectorFromString(@"reportWithEventCode:params:");
            if ([strongself.clsService respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [strongself.clsService performSelector:selector withObject:QCloudTrackCosSdkLog withObject:params];
#pragma clang diagnostic pop
            }
        }
    });
}
@end
