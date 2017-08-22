//
//  QCloudFileOffsetStream.m
//  Pods
//
//  Created by Dong Zhao on 2017/5/22.
//
//

#import "QCloudFileOffsetStream.h"
#import "QCloudFileUtils.h"
@interface NSStream ()
@property (readwrite) NSStreamStatus streamStatus;
@property (readwrite, copy) NSError *streamError;
@end

@interface NSInputStream ()
- (void) open;
- (void) close;
@end
@interface QCloudFileOffsetStream ()
@property (nonatomic, assign) NSUInteger contentLength;
@property (nonatomic, assign) NSUInteger readLength;
@property (nonatomic, assign) NSStreamStatus status;
@property (nonatomic, strong) NSFileHandle* fileReadHandler;
@property (nonatomic, strong) NSString* path;
@end

@implementation QCloudFileOffsetStream
@synthesize streamError;
@synthesize streamStatus;

- (instancetype) initWithFileAtPath:(NSString *)path offset:(NSUInteger)offset slice:(NSUInteger)sliceLength
{
    self = [super init];
    if (!self) {
        return nil;
    }
    _offset = offset;
    _sliceLength = sliceLength;
    _contentLength = QCloudFileSize(path);
    _path = path;
    return self;
}


- (void) open
{
    _fileReadHandler = [NSFileHandle fileHandleForReadingAtPath:self.path];
    [_fileReadHandler seekToFileOffset:_offset];
    self.status = NSStreamStatusOpen;
    _readLength = 0;
}

- (NSInteger)read:(uint8_t *)buffer maxLength:(NSUInteger)len
{
    if (self.status == NSStreamStatusClosed) {
        return 0;
    }
    NSUInteger ureadLength = _sliceLength - _readLength ;
    NSUInteger willReadLength = MIN(ureadLength, len);
    if (willReadLength <= 0) {
        return 0;
    }
    NSData* data = [_fileReadHandler readDataOfLength:willReadLength];
    memcpy(buffer, [data bytes], willReadLength);
    _readLength += willReadLength;
    return willReadLength;
}

- (NSError*) streamError
{
    return nil;
}

- (NSStreamStatus) streamStatus
{
    if (![self hasBytesAvailable]) {
        self.status = NSStreamStatusAtEnd;
    }
    return self.status;
}

- (void) close
{
    [_fileReadHandler closeFile];
    _fileReadHandler = nil;
    self.status = NSStreamStatusClosed;
    _readLength = 0;
}
- (BOOL)getBuffer:(uint8_t * _Nullable * _Nonnull)buffer length:(NSUInteger *)len
{
    return NO;
}
- (BOOL) hasBytesAvailable
{
    if (_offset+_readLength >= _contentLength) {
        return NO;
    }
    if (_readLength >= _sliceLength) {
        return NO;
    }
    if (_offset + _readLength < _sliceLength) {
        return YES;
    }
    return NO;
}

- (id)propertyForKey:(__unused NSString *)key {
    return nil;
}

- (BOOL)setProperty:(__unused id)property
             forKey:(__unused NSString *)key
{
    return NO;
}

- (void)scheduleInRunLoop:(__unused NSRunLoop *)aRunLoop
                  forMode:(__unused NSString *)mode
{}

- (void)removeFromRunLoop:(__unused NSRunLoop *)aRunLoop
                  forMode:(__unused NSString *)mode
{}


#pragma mark - Undocumented CFReadStream Bridged Methods

- (void)_scheduleInCFRunLoop:(__unused CFRunLoopRef)aRunLoop
                     forMode:(__unused CFStringRef)aMode
{}

- (void)_unscheduleFromCFRunLoop:(__unused CFRunLoopRef)aRunLoop
                         forMode:(__unused CFStringRef)aMode
{}

- (BOOL)_setCFClientFlags:(__unused CFOptionFlags)inFlags
                 callback:(__unused CFReadStreamClientCallBack)inCallback
                  context:(__unused CFStreamClientContext *)inContext {
    return NO;
}



@end
