//
//  QCloudFileLogger.m
//  Pods
//
//  Created by Dong Zhao on 2017/3/15.
//
//

#import "QCloudFileLogger.h"
#import "QCloudLogModel.h"
#import "QCloudFileUtils.h"
#import "QCloudLogger.h"
#import <zlib.h>
#if TARGET_OS_IOS
#import <UIKit/UIKit.h>
#endif

#import "QCloudSDKModuleManager.h"
#import "NSObject+QCloudModel.h"
@interface QCloudFileLogger () {
    dispatch_source_t _timer;
}
@property (nonatomic, strong) dispatch_queue_t buildQueue;
@property (nonatomic, strong) NSFileHandle *fileHandler;
@property (nonatomic, strong) NSMutableData *sliceData;
@property (nonatomic, assign) uint64_t sliceSize;
@end

@implementation QCloudFileLogger
@synthesize currentSize = _currentSize;
- (void)commonInit {
    _buildQueue = dispatch_queue_create("com.tencent.qcloud.logger.build", DISPATCH_QUEUE_SERIAL);
    //
    _sliceSize = 200 * 1024;
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _buildQueue);
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        [self writeCliceDataToFile];
    });
    _sliceData = [NSMutableData dataWithCapacity:(NSUInteger)_sliceSize];
}
- (void)dealloc {
    [self writeCliceDataToFile];
    [_fileHandler closeFile];
    dispatch_source_cancel(_timer);
}
- (instancetype)initWithPath:(NSString *)path maxSize:(uint64_t)maxSize {
    self = [super init];
    if (!self) {
        return self;
    }
    [self commonInit];
    _maxSize = maxSize;
    _path = path;
    _currentSize = QCloudFileSize(path);
    if (!QCloudFileExist(path)) {
        [[NSFileManager defaultManager] createFileAtPath:path contents:[NSData data] attributes:nil];
        NSArray *allModules = [[QCloudSDKModuleManager shareInstance] allModules];
        NSData *modulestring = [allModules qcloud_modelToJSONData];
        [_sliceData appendData:modulestring];
    }
    dispatch_resume(_timer);
    _fileHandler = [NSFileHandle fileHandleForWritingAtPath:path];
    [_fileHandler seekToEndOfFile];
#if TARGET_OS_IOS
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(flushAllFiles)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(flushAllFiles)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flushAllFiles) name:UIApplicationWillTerminateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(flushAllFiles)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    //
#elif TARGET_OS_MAC
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(flushAllFiles)
                                                 name:NSApplicationWillResignActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flushAllFiles) name:NSApplicationWillTerminateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flushAllFiles) name:NSApplicationWillHideNotification object:nil];
#endif
    return self;
}

- (void)flushAllFiles {
    dispatch_async(_buildQueue, ^{
        [self writeCliceDataToFile];
    });
}

- (void)writeCliceDataToFile {
    if (_sliceData.length) {
        @try {
            [_fileHandler writeData:_sliceData];
            _sliceData = [NSMutableData dataWithCapacity:(NSUInteger)_sliceSize];
        } @catch (NSException *exception) {
            QCloudLogError(@"no space left on device");
        }
       
    }
}

- (void)appendLog:(QCloudLogModel * (^)(void))logCreate {
    dispatch_async(_buildQueue, ^{
        QCloudLogModel *log = logCreate();
        NSString *message = [NSString stringWithFormat:@"%@\n", [log fileDescription]];
        NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
        self->_currentSize += data.length;
        [self->_sliceData appendData:data];
        //
        if (self.currentSize >= self.maxSize) {
            [self writeCliceDataToFile];
            if ([self.delegate respondsToSelector:@selector(fileLoggerDidFull:)]) {
                [self.delegate fileLoggerDidFull:self];
            }
        } else {
            if (self->_sliceData.length >= self->_sliceSize) {
                [self writeCliceDataToFile];
            }
        }
    });
}

- (BOOL)isFull {
    return self.currentSize >= self.maxSize;
}

@end
