//
//  QCloudLogModel.h
//  Pods
//
//  Created by Dong Zhao on 2017/3/15.
//
//

#import <Foundation/Foundation.h>
/**
 `QCloudLogLevel` enum specifies different levels of logging that could be used to limit or display more messages in logs.
 */
typedef NS_ENUM(uint8_t, QCloudLogLevel) {
    /**
     Log level that disables all logging.
     */
    QCloudLogLevelNone = 1,
    /**
     Log level that if set is going to output error messages to the log.
     */
    QCloudLogLevelError = 2,
    /**
     Log level that if set is going to output the following messages to log:
     - Errors
     - Warnings
     */
    QCloudLogLevelWarning = 3,
    /**
     Log level that if set is going to output the following messages to log:
     - Errors
     - Warnings
     - Informational messages
     */
    QCloudLogLevelInfo = 4,
    /**
     Log level that if set is going to output the following messages to log:
     - Errors
     - Warnings
     - Informational messages
     - Debug messages
     */

    QCloudLogLevelDebug = 5,
    /**
     Log level that if set is going to output the following messages to log:
     - Errors
     - Warnings
     - Informational messages
     - Debug messages
     - Verbose
     */
    QCloudLogLevelVerbose = 6,

};

typedef NS_ENUM(uint8_t, QCloudLogCategory) {
    QCloudLogCategoryNone,
    /**
     操作过程日志（如上传分片开始、网络请求发起）
     */
    QCloudLogCategoryProcess,
    /**
     操作结果日志（如上传成功、下载失败）
     */
    QCloudLogCategoryResult,
    /**
     网络层日志（如请求、响应、http性能）
     */
    QCloudLogCategoryNetwork,
    /**
     网络探测日志（如网络连接导致失败时的探测）
     */
    QCloudLogCategoryProbe,
    /**
     错误堆栈日志（如异常捕获）
     */
    QCloudLogCategoryError,
};

@interface QCloudLogModel : NSObject
@property (nonatomic, assign) QCloudLogLevel level;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign) QCloudLogCategory category;
@property (nonatomic, strong) NSString *tag;

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *file;
@property (nonatomic, assign) int line;
@property (nonatomic, assign) BOOL simpleLog;
@property (nonatomic, strong) NSString *funciton;
@property (nonatomic, strong) NSString *threadName;

/**
 生成用于写文件的Log信息

 @return 写入文件的Log信息
 */
- (NSString *)fileDescription;

+ (NSString *)descriptionForLogCategory:(QCloudLogCategory)logCategory;

+ (NSString *)descriptionForLogLevel:(QCloudLogLevel)logLevel;
@end
