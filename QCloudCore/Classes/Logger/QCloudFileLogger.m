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
#import <zlib.h>
#import "QCloudSDKModuleManager.h"
#import "NSObject+QCloudModel.h"
@interface QCloudFileLogger ()
{
}
@property (nonatomic, strong) dispatch_queue_t buildQueue;
@property (nonatomic, strong) NSFileHandle* fileHandler;
@property (nonatomic, strong) NSMutableData* sliceData;
@property (nonatomic, assign) uint64_t sliceSize;
@end

@implementation QCloudFileLogger
@synthesize currentSize = _currentSize;
- (void) commonInit
{
    _buildQueue = dispatch_queue_create("com.tencent.qcloud.logger.build", DISPATCH_QUEUE_SERIAL);
    //
    _sliceSize = 200*1024;
    _sliceData = [NSMutableData dataWithCapacity:(NSUInteger)_sliceSize];
}
- (void) dealloc
{
    [self writeCliceDataToFile];
    [_fileHandler closeFile];
}
- (instancetype) initWithPath:(NSString *)path maxSize:(uint64_t)maxSize
{
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
        NSArray* allModules = [[QCloudSDKModuleManager shareInstance] allModules];
        NSData* modulestring = [allModules qcloud_modelToJSONData];
        [_sliceData appendData:modulestring];
    }
    _fileHandler = [NSFileHandle fileHandleForWritingAtPath:path];
    [_fileHandler seekToEndOfFile];
#if TARGET_OS_IPHONE
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flushAllFiles) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flushAllFiles) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flushAllFiles) name:UIApplicationWillTerminateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flushAllFiles) name:UIApplicationDidEnterBackgroundNotification object:nil];
    //
#endif
    return self;
}


- (void) flushAllFiles
{
    dispatch_async(_buildQueue, ^{
        [self writeCliceDataToFile];
    });
}

- (void) writeCliceDataToFile
{
    if (_sliceData.length) {
        [_fileHandler writeData:_sliceData];
        _sliceData = [NSMutableData dataWithCapacity:(NSUInteger)_sliceSize];
    }
}

- (void) appendLog:(QCloudLogModel *(^)(void))logCreate
{
    dispatch_async(_buildQueue, ^{
        QCloudLogModel* log = logCreate();
        NSString* message = [NSString stringWithFormat:@"%@\n",[log fileDescription]];
        NSData* data = [message dataUsingEncoding:NSUTF8StringEncoding];
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

- (BOOL) isFull
{
    return self.currentSize >= self.maxSize;
}

@end
