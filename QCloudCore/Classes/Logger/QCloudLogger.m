//
//  QCloudLogger.m
//  Pods
//
//  Created by Dong Zhao on 2017/3/14.
//
//

#import "QCloudLogger.h"
#import "QCloudLogModel.h"
#import "QCloudFileUtils.h"
#import <time.h>
#import <xlocale.h>
#import "QCloudFileLogger.h"
#if TARGET_OS_IOS
#import <UIKit/UIKit.h>
#endif

#define QCloudEachLogFileSize  10*1024*1024


@interface NSDate (QCloudEasy)

@end

@implementation NSDate( QCloudEasy)

- (NSString*) qcloud_string
{
    time_t pubdate = [self timeIntervalSince1970];
    struct tm *cTime = localtime(&pubdate);
    return [NSString stringWithFormat:@"%d-%02d-%02d-%02d-%02d-%02d",1900+cTime->tm_year,1+cTime->tm_mon, cTime->tm_mday, cTime->tm_hour, cTime->tm_min, cTime->tm_sec];
}

+ (NSString*) qcloud_todayString
{
    time_t pubdate = [[NSDate date] timeIntervalSince1970];
    struct tm *cTime = localtime(&pubdate);
    return [NSString stringWithFormat:@"%d-%02d-%02d",1900+cTime->tm_year,1+cTime->tm_mon, cTime->tm_mday];
}

+ (NSDate*) qcloud_dateWithString:(NSString*)str
{
    struct tm  sometime;
    const char *formatString = "%Y-%m-%d";
    (void) strptime_l([str UTF8String], formatString, &sometime, NULL);
    return [NSDate dateWithTimeIntervalSince1970: mktime(&sometime)];
}

@end



NSString* const kQCloudLogExtension = @"log";
@interface QCloudLogger () <QCloudFileLoggerDelegate>
@property (nonatomic, strong) QCloudFileLogger* currentFileLogger;
@end

@implementation QCloudLogger
{
    NSMutableArray* _loggerOutputs;
}

+ (instancetype)sharedLogger
{
    static QCloudLogger* logger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        logger = [QCloudLogger new];
        char* level = getenv("QCloudLogLevel");
        if (NULL != level && strlen(level) > 0) {
            int logLevel = atoi(level);
            if (logLevel >= QCloudLogLevelNone && logLevel <= QCloudLogLevelDebug) {
                logger.logLevel = logLevel;
            } else {
                logger.logLevel = QCloudLogLevelInfo;
            }
        } else {
            logger.logLevel = QCloudLogLevelInfo;
        }
        
    });
    return logger;
}



- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _loggerOutputs = [NSMutableArray new];
    _currentFileLogger = [[QCloudFileLogger alloc] initWithPath:[self avilableLogFilePath] maxSize:QCloudEachLogFileSize];
    _currentFileLogger.delegate = self;
    [_loggerOutputs addObject:_currentFileLogger];
    _maxStoarageSize = 70*1024*1024;
    _keepDays = 3;
    //
#if TARGET_OS_IOS
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tryCleanLogs) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tryCleanLogs) name:UIApplicationWillTerminateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tryCleanLogs) name:UIApplicationDidEnterBackgroundNotification object:nil];
#elif TARGET_OS_MAC
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tryCleanLogs) name:NSApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tryCleanLogs) name:NSApplicationWillTerminateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tryCleanLogs) name:NSApplicationWillHideNotification object:nil];

#endif
    return self;
}

- (NSArray<NSString*>*) allLogFiles
{
    NSString* logDir = self.logDirctoryPath;
    NSDirectoryEnumerator<NSString *> * enumertor = [[NSFileManager defaultManager] enumeratorAtPath:logDir];
    NSString* file = nil;
    NSMutableArray* files = [NSMutableArray new];
    while (file = [enumertor nextObject]) {
        if ([file.pathExtension isEqualToString:kQCloudLogExtension]) {
            [files addObject:file];
        }
    }
    return files;
}

- (void) fileLoggerDidFull:(QCloudFileLogger *)logger
{
    if (logger != _currentFileLogger) {
        return;
    }
    NSString* nextLogPath = [self avilableLogFilePath];
    if (_currentFileLogger.isFull) {
        QCloudFileLogger * fileLogger =[[QCloudFileLogger alloc] initWithPath:nextLogPath maxSize:QCloudEachLogFileSize];
        fileLogger.delegate = self;
        _currentFileLogger = fileLogger;
    }
}

- (NSString*) avilableLogFilePath
{
    NSArray* allLogFiles = [self allLogFiles];
    allLogFiles = [allLogFiles sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    NSString* lastLog = allLogFiles.lastObject;
    NSString* todayLogPrefix = [NSDate qcloud_todayString];
    NSString* readyLogName = [[NSDate date] qcloud_string];
    NSString* logName = nil;
    
    NSString* lastLogPath = nil;
    if (lastLog) {
        lastLogPath = QCloudPathJoin(self.logDirctoryPath, lastLog);
    }
    if (!lastLog) {
        logName = [readyLogName stringByAppendingPathExtension:kQCloudLogExtension];
    } else {
        if ([lastLog hasPrefix:todayLogPrefix]) {
            if (QCloudFileSize(lastLogPath) >= QCloudEachLogFileSize) {
                logName = [readyLogName stringByAppendingPathExtension:kQCloudLogExtension];
            }else {
                logName = lastLog;
            }
        } else {
            logName = [readyLogName stringByAppendingPathExtension:kQCloudLogExtension];
        }
    }
    return QCloudPathJoin(self.logDirctoryPath, logName);
}

- (void) tryCleanLogs
{
    NSArray* allLogFiles = [self allLogFiles];
    allLogFiles = [allLogFiles sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj2 compare:obj1];
    }];
    
    NSString* logDir = self.logDirctoryPath;
    uint64_t totalSize = 0;
    NSString* agoDateString = [[NSDate dateWithTimeIntervalSinceNow:-self.keepDays*24*60*60] qcloud_string];
    
    for (NSString* logName in allLogFiles) {
        NSString* path = QCloudPathJoin(logDir, logName);
        totalSize += QCloudFileSize(path);
        NSString* dateString = [[logName stringByDeletingPathExtension] componentsSeparatedByString:@"_"].firstObject;
        
        if (totalSize>self.maxStoarageSize || [dateString compare:agoDateString] == NSOrderedAscending) {
            QCloudRemoveFileByPath(path);
        }
    }
}

- (NSString*) logDirctoryPath
{
    NSString* path =QCloudPathJoin(QCloudPathJoin(QCloudPathJoin(QCloudApplicationLibaryPath(),@"Caches"),@"qcloud") ,@"logs");
    QCloudEnsurePathExist(path);
    return path;
}

- (void)logMessageWithLevel:(QCloudLogLevel)level
                        cmd:(const char*)cmd
                       line:(int)line
                       file:(const char*)file
                     format:(NSString *)format, ... NS_FORMAT_FUNCTION(5, 6)
{
    if (level > self.logLevel || level == QCloudLogLevelNone || !format) {
        return;
    }
    va_list args;
    va_start(args, format);
    NSString* message =[[NSString alloc] initWithFormat:format arguments:args];
    QCloudLogModel*(^CreateLog)(void) = ^(void) {
        QCloudLogModel* log = [QCloudLogModel new];
        log.message= message;
        log.date = [NSDate date];
        log.level = level;
        log.funciton = [NSString stringWithCString:cmd encoding:NSUTF8StringEncoding];
        log.file = [NSString stringWithCString:file encoding:NSUTF8StringEncoding];
        log.line = line;
        return log;
    };
    if (level <= QCloudLogLevelDebug) {
        QCloudLogModel* model = CreateLog();
        NSLog(@"%@",[model debugDescription]);
    }
    for (QCloudLoggerOutput* output in _loggerOutputs) {
        [output appendLog:CreateLog];
    }
    va_end(args);
}

- (void) addLogger:(QCloudLoggerOutput *)output
{
    if (!output) {
        return;
    }
    [_loggerOutputs addObject:output];
}

- (void) removeLogger:(QCloudLoggerOutput *)output
{
    [_loggerOutputs removeObject:output];
}
@end
