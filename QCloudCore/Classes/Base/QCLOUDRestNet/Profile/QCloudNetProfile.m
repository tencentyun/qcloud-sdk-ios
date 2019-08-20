//
//  QCloudNetProfile.m
//  Pods
//
//  Created by Dong Zhao on 2017/3/22.
//
//

#import "QCloudNetProfile.h"
#import "QCloudLogger.h"
@interface QCloudNetProfilePoint : NSObject
@property (nonatomic, assign) int64_t uploadBytes;
@property (nonatomic, assign) int64_t downloadBytes;
@property (atomic, assign) NSTimeInterval pointTime;
@end

@implementation QCloudNetProfilePoint

@end





@implementation QCloudNetProfileLevel
- (instancetype) initWithInterval:(NSTimeInterval)interval
{
    self = [super init];
    if (!self) {
        return self;
    }
    _interval = interval;
    _downloadPoints = [NSMutableArray new];
    _uploadPoints = [NSMutableArray new];
    return self;
}

- (void) pointDownload:(QCloudNetProfilePoint*)downloadPoint
{
        CFTimeInterval current = CFAbsoluteTimeGetCurrent();
        for (QCloudNetProfilePoint* point in [_downloadPoints copy]) {
            if (current - point.pointTime > self.interval) {
                [_downloadPoints removeObject:point];
            }
        }
        [_downloadPoints addObject:downloadPoint];
}

- (int64_t) downloadSpeed
{
        CFTimeInterval current = CFAbsoluteTimeGetCurrent();
        for (QCloudNetProfilePoint* point in [_downloadPoints copy]) {
            if (current - point.pointTime > self.interval) {
                [_downloadPoints removeObject:point];
            }
        }
        if (_downloadPoints.count == 0) {
            return 0;
        }
        QCloudNetProfilePoint* beginPoint = _downloadPoints.firstObject;
        QCloudNetProfilePoint* lastPoint  =_downloadPoints.lastObject;
        NSTimeInterval time = lastPoint.pointTime - beginPoint.pointTime;
        if (time == 0) {
            time = 0.5;
        }
        int64_t total = 0;
        for (QCloudNetProfilePoint* point  in _downloadPoints) {
            total += point.downloadBytes;
        }
        return total/time;
}

- (int64_t) uploadSpped
{
        CFTimeInterval current = CFAbsoluteTimeGetCurrent();
        for (QCloudNetProfilePoint* point in [_uploadPoints copy]) {
            if (current - point.pointTime > self.interval) {
                [_uploadPoints removeObject:point];
            }
        }
        if (_uploadPoints.count == 0) {
            return 0;
        }
        QCloudNetProfilePoint* beginPoint = _uploadPoints.firstObject;
        QCloudNetProfilePoint* lastPoint  =_uploadPoints.lastObject;
        NSTimeInterval time = lastPoint.pointTime - beginPoint.pointTime;
        if (time == 0) {
            time = 0.5;
        }
        int64_t total = 0;
        for (QCloudNetProfilePoint* point  in _uploadPoints) {
            total += point.uploadBytes;
        }
        return total/time;
}
- (void) pointUpload:(QCloudNetProfilePoint*)downloadPoint{
        CFTimeInterval current = CFAbsoluteTimeGetCurrent();
        for (QCloudNetProfilePoint* point in [_uploadPoints copy]) {
            if (current - point.pointTime > self.interval) {
                [_uploadPoints removeObject:point];
            }
        }
        [_uploadPoints addObject:downloadPoint];
}

@end


typedef NS_ENUM(NSInteger, QCloudNetSpeedLevel) {
   QCloudNetSpeedLevel1s,
    QCloudNetSpeedLevel1m,
    QCloudNetSpeedLevel30m
};

@interface QCloudNetProfile ()
{
    CFTimeInterval _checkPointInterval;
    dispatch_source_t _timer;
    //
    NSMutableArray* _sppedLevels;
    //
    CFTimeInterval _lastCheckPointTimeInterval;
    dispatch_queue_t _readWriteQueue;
}


@end
@implementation QCloudNetProfile

+ (QCloudNetProfile*) shareProfile
{
    static QCloudNetProfile* profile;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        profile = [QCloudNetProfile new];
    });
    return profile;
}

- (void) checkSpeed
{
    dispatch_sync(_readWriteQueue, ^{
        for (QCloudNetProfileLevel* level in self->_sppedLevels) {
            QCloudLogDebug(@"%f download spped %lld bytes/s", level.interval, level.downloadSpeed);
            QCloudLogDebug(@"%f upload speed %lld bytes/s", level.interval, level.uploadSpped);
        }
    });
}
- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
//#ifdef DEBUG
//    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0));
//    _checkPointInterval = 0.5;
//
//    if (_timer) {
//        __weak typeof(self) weakSelf = self;
//        dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW,_checkPointInterval * NSEC_PER_SEC ), _checkPointInterval * NSEC_PER_SEC, (1ull * NSEC_PER_SEC) / 10.0);
//        dispatch_source_set_event_handler(_timer, ^{
//            [weakSelf checkSpeed];
//        });
//        dispatch_resume(_timer);
//    }
//#endif
    //
    _readWriteQueue = dispatch_queue_create("com.tencent.network.profile.level", DISPATCH_QUEUE_CONCURRENT);
    _sppedLevels = [NSMutableArray new];
    [_sppedLevels addObject:[[QCloudNetProfileLevel alloc] initWithInterval:1]];
    [_sppedLevels addObject: [[QCloudNetProfileLevel alloc] initWithInterval:30]];
    [_sppedLevels addObject:[[QCloudNetProfileLevel alloc] initWithInterval:60]];
    return self;
}

- (void) pointDownload:(int64_t)bytes
{
    dispatch_barrier_async(_readWriteQueue, ^{
        for (QCloudNetProfileLevel* level in self->_sppedLevels) {
            QCloudNetProfilePoint* point = [QCloudNetProfilePoint new];
            point.pointTime = CFAbsoluteTimeGetCurrent();
            point.downloadBytes = bytes;
            [level pointDownload:point];
        }
    });
}

- (void) pointUpload:(int64_t)bytes
{
    dispatch_barrier_async(_readWriteQueue, ^{
        for (QCloudNetProfileLevel* level in self->_sppedLevels) {
            QCloudNetProfilePoint* point = [QCloudNetProfilePoint new];
            point.pointTime = CFAbsoluteTimeGetCurrent();
            point.uploadBytes = bytes;
            [level pointUpload:point];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kQCloudNetProfileUploadSpeedUpdate object:self->_sppedLevels];
    });
}



@end
