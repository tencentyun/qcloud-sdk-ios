//
//  QCloudCustomLoggerOutput.m
//  QCloudCore
//
//  Created by garenwang on 2025/4/11.
//

#import "QCloudCustomLoggerOutput.h"

@interface QCloudCustomLoggerOutput ()
@property(strong,nonatomic)dispatch_queue_t buildQueue;
@end

@implementation QCloudCustomLoggerOutput

- (instancetype)init
{
    self = [super init];
    if (self) {
        _buildQueue = dispatch_queue_create("com.tencent.qcloud.logger.cls.build", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)appendLog:(QCloudLogModel * (^)(void))logCreate {
    QCloudWeakSelf(self);
    dispatch_async(_buildQueue, ^{
        QCloudStrongSelf(self);
        QCloudLogModel *log = logCreate();
        NSMutableDictionary *params = QCloudLogger.sharedLogger.extendInfo?QCloudLogger.sharedLogger.extendInfo.mutableCopy:[NSMutableDictionary new];
        if (QCloudLogger.sharedLogger.deviceID) {
            params[@"deviceID"] = QCloudLogger.sharedLogger.deviceID;
        }
        if (QCloudLogger.sharedLogger.deviceModel) {
            params[@"deviceModel"] = QCloudLogger.sharedLogger.deviceModel;
        }
        if (QCloudLogger.sharedLogger.appVersion) {
            params[@"appVersion"] = QCloudLogger.sharedLogger.appVersion;
        }
        if (self.callback) {
            self.callback(log,params);
        }
    });
}
@end
