//
//  QCloudLogger.h
//  Pods
//
//  Created by Dong Zhao on 2017/3/14.
//
//

#import <Foundation/Foundation.h>
#import "QCloudLogModel.h"
#import "QCloudLoggerOutput.h"

#define QCloudLog(level, c, t, frmt, ...) \
    [[QCloudLogger sharedLogger] logMessageWithLevel:level category:c tag:t cmd:__PRETTY_FUNCTION__ line:__LINE__ file:__FILE__ format:(frmt), ##__VA_ARGS__]

#define QCloudLogError(frmt, ...) QCloudLog(QCloudLogLevelError, QCloudLogCategoryNone, @"", (frmt), ##__VA_ARGS__)

#define QCloudLogWarning(frmt, ...) QCloudLog(QCloudLogLevelWarning, QCloudLogCategoryNone, @"", (frmt), ##__VA_ARGS__)

#define QCloudLogInfo(frmt, ...) QCloudLog(QCloudLogLevelInfo, QCloudLogCategoryNone, @"", (frmt), ##__VA_ARGS__)

#define QCloudLogDebug(frmt, ...) QCloudLog(QCloudLogLevelDebug, QCloudLogCategoryNone, @"", (frmt), ##__VA_ARGS__)

#define QCloudLogVerbose(frmt, ...) QCloudLog(QCloudLogLevelVerbose, QCloudLogCategoryNone, @"", (frmt), ##__VA_ARGS__)


#define QCloudLogErrorP(tag,frmt, ...) QCloudLog(QCloudLogLevelError,QCloudLogCategoryProcess,tag, (frmt), ##__VA_ARGS__)

#define QCloudLogWarningP(tag,frmt, ...) QCloudLog(QCloudLogLevelWarning,QCloudLogCategoryProcess,tag, (frmt), ##__VA_ARGS__)

#define QCloudLogInfoP(tag,frmt, ...) QCloudLog(QCloudLogLevelInfo,QCloudLogCategoryProcess,tag, (frmt), ##__VA_ARGS__)

#define QCloudLogDebugP(tag,frmt, ...) QCloudLog(QCloudLogLevelDebug,QCloudLogCategoryProcess,tag, (frmt), ##__VA_ARGS__)

#define QCloudLogVerboseP(tag,frmt, ...) QCloudLog(QCloudLogLevelVerbose,QCloudLogCategoryProcess,tag, (frmt), ##__VA_ARGS__)


#define QCloudLogErrorR(tag,frmt, ...) QCloudLog(QCloudLogLevelError,QCloudLogCategoryResult,tag, (frmt), ##__VA_ARGS__)

#define QCloudLogWarningR(tag,frmt, ...) QCloudLog(QCloudLogLevelWarning,QCloudLogCategoryResult,tag, (frmt), ##__VA_ARGS__)

#define QCloudLogInfoR(tag,frmt, ...) QCloudLog(QCloudLogLevelInfo,QCloudLogCategoryResult,tag, (frmt), ##__VA_ARGS__)

#define QCloudLogDebugR(tag,frmt, ...) QCloudLog(QCloudLogLevelDebug,QCloudLogCategoryResult,tag, (frmt), ##__VA_ARGS__)

#define QCloudLogVerboseR(tag,frmt, ...) QCloudLog(QCloudLogLevelVerbose,QCloudLogCategoryResult,tag, (frmt), ##__VA_ARGS__)


#define QCloudLogErrorN(tag,frmt, ...) QCloudLog(QCloudLogLevelError,QCloudLogCategoryNetwork,tag, (frmt), ##__VA_ARGS__)

#define QCloudLogWarningN(tag,frmt, ...) QCloudLog(QCloudLogLevelWarning,QCloudLogCategoryNetwork,tag, (frmt), ##__VA_ARGS__)

#define QCloudLogInfoN(tag,frmt, ...) QCloudLog(QCloudLogLevelInfo,QCloudLogCategoryNetwork,tag, (frmt), ##__VA_ARGS__)

#define QCloudLogDebugN(tag,frmt, ...) QCloudLog(QCloudLogLevelDebug,QCloudLogCategoryNetwork,tag, (frmt), ##__VA_ARGS__)

#define QCloudLogVerboseN(tag,frmt, ...) QCloudLog(QCloudLogLevelVerbose,QCloudLogCategoryNetwork,tag, (frmt), ##__VA_ARGS__)


#define QCloudLogErrorPB(tag,frmt, ...) QCloudLog(QCloudLogLevelError,QCloudLogCategoryProbe,tag, (frmt), ##__VA_ARGS__)

#define QCloudLogWarningPB(tag,frmt, ...) QCloudLog(QCloudLogLevelWarning,QCloudLogCategoryProbe,tag, (frmt), ##__VA_ARGS__)

#define QCloudLogInfoPB(tag,frmt, ...) QCloudLog(QCloudLogLevelInfo,QCloudLogCategoryProbe,tag, (frmt), ##__VA_ARGS__)

#define QCloudLogDebugPB(tag,frmt, ...) QCloudLog(QCloudLogLevelDebug,QCloudLogCategoryProbe,tag, (frmt), ##__VA_ARGS__)

#define QCloudLogVerbosePB(tag,frmt, ...) QCloudLog(QCloudLogLevelVerbose,QCloudLogCategoryProbe,tag, (frmt), ##__VA_ARGS__)


#define QCloudLogErrorE(tag,frmt, ...) QCloudLog(QCloudLogLevelError,QCloudLogCategoryError,tag, (frmt), ##__VA_ARGS__)

#define QCloudLogWarningE(tag,frmt, ...) QCloudLog(QCloudLogLevelWarning,QCloudLogCategoryError,tag, (frmt), ##__VA_ARGS__)

#define QCloudLogInfoE(tag,frmt, ...) QCloudLog(QCloudLogLevelInfo,QCloudLogCategoryError,tag, (frmt), ##__VA_ARGS__)

#define QCloudLogDebugE(tag,frmt, ...) QCloudLog(QCloudLogLevelDebug,QCloudLogCategoryError,tag, (frmt), ##__VA_ARGS__)

#define QCloudLogVerboseE(tag,frmt, ...) QCloudLog(QCloudLogLevelVerbose,QCloudLogCategoryError,tag, (frmt), ##__VA_ARGS__)


#define QCloudLogException(exception)                                                \
    QCloudLogError(@"",@"Caught \"%@\" with reason \"%@\"%@", exception.name, exception, \
                   [exception callStackSymbols] ? [NSString stringWithFormat:@":\n%@.", [exception callStackSymbols]] : @"")

#define QCloudLogTrance() QCloudLog(QCloudLogLevelDebug,QCloudLogCategoryNone,@"", @"%@", [NSThread callStackSymbols])

@interface QCloudLogger : NSObject


/// 日志加密Key，不指定则不加密日志。
@property (nonatomic, strong) NSData *aesKey;

/// 日志加密IV，不指定则不加密日志。
@property (nonatomic, strong) NSData *aesIv;

/// 扩展信息，用于日志上报
@property (nonatomic, strong) NSDictionary *extendInfo;

/// 设备ID
@property (nonatomic, strong) NSString *deviceID;

/// 机型
@property (nonatomic, strong) NSString *deviceModel;

/// APP版本
@property (nonatomic, strong) NSString *appVersion;

/// 控制台输出的日志级别
@property (nonatomic, assign) QCloudLogLevel logLevel;

@property (nonatomic, assign) QCloudLogLevel logFileLevel;

@property (nonatomic, assign) QCloudLogLevel logClsLevel;

/// 本地日志路径
@property (nonatomic, strong, readonly) NSString *logDirctoryPath;

@property (nonatomic, assign) uint64_t maxStoarageSize;

/// 日志保存天数
@property (nonatomic, assign) float keepDays;

///--------------------------------------
#pragma mark - Shared Logger
///--------------------------------------

/**
 A shared instance of `QCloudLogger` that should be used for all logging.

 @return An shared singleton instance of `QCloudLogger`.
 */
+ (instancetype)sharedLogger;

///--------------------------------------
#pragma mark - Logging Messages
///--------------------------------------

- (void)logMessageWithLevel:(QCloudLogLevel)level category:(QCloudLogCategory)category tag:(NSString *)tag cmd:(const char *)commandInfo line:(int)line file:(const char *)file format:(NSString *)format, ...;

/**
 增加一个输出源

 @param output 输出源
 */
- (void)addLogger:(QCloudLoggerOutput *)output;

/**
 删除一个输出源

 @param output 删除一个输出源
 */
- (void)removeLogger:(QCloudLoggerOutput *)output;
@end
