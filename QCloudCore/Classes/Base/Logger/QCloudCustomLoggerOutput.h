//
//  QCloudCustomLoggerOutput.h
//  QCloudCore
//
//  Created by garenwang on 2025/4/11.
//

#import <QCloudCore/QCloudCore.h>
NS_ASSUME_NONNULL_BEGIN

typedef void(^QCloudCustomLoggerOutputCallBack)(QCloudLogModel * model,NSDictionary *extendInfo);
@interface QCloudCustomLoggerOutput : QCloudLoggerOutput
@property (nonatomic,strong)QCloudCustomLoggerOutputCallBack callback;
@end

NS_ASSUME_NONNULL_END
