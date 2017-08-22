//
//  QCloudHTTPMultiDataStream.m
//  QCloudNetworking
//
//  Created by tencent on 16/2/18.
//  Copyright © 2016年 QCloudTernimalLab. All rights reserved.
//

#import "QCloudHTTPMultiDataStream.h"
#import "QCloudHTTPBodyPart.h"
static NSString * QCloudCreateMultipartFormBoundary() {
    return [NSString stringWithFormat:@"Boundary+%08X%08X", arc4random(), arc4random()];
}
@interface NSStream ()
@property (readwrite) NSStreamStatus streamStatus;
@property (readwrite, copy) NSError *streamError;
@end

@implementation QCloudHTTPMultiDataStream
{
    NSMutableArray* _bodyParts;
    QCloudHTTPBodyPart* _currentHTTPBodyPart;
    NSEnumerator* _partEnumerator;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wimplicit-atomic-properties"
@synthesize streamStatus;
@synthesize streamError;
#pragma clang diagnostic pop

- (void) dealloc
{
    
}
- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _stringEncoding = NSUTF8StringEncoding;
    _bodyParts = [NSMutableArray new];
    _boundary = QCloudCreateMultipartFormBoundary();
    return self;
}

- (instancetype) initWithStringEncoding:(NSStringEncoding)encoding
{
    self = [self init];
    if (!self) {
        return self;
    }
    _stringEncoding = encoding;
    return self;
}

- (BOOL) hasData
{
    return _bodyParts.count?YES:NO;
}

- (void) setStringEncoding:(NSStringEncoding)stringEncoding
{
    _stringEncoding = stringEncoding;
    for (QCloudHTTPBodyPart* p  in _bodyParts) {
        p.stringEncoding = stringEncoding;
    }
}
- (void) appendBodyPart:(QCloudHTTPBodyPart*)bodyPart
{
    NSParameterAssert(bodyPart);
    bodyPart.stringEncoding = self.stringEncoding;
    bodyPart.boundary = self.boundary;
    if ([_bodyParts containsObject:bodyPart]) {
        return;
    }
    [_bodyParts addObject:bodyPart];
}

- (void) insertBodyPart:(QCloudHTTPBodyPart *)bodyPart
{
    NSParameterAssert(bodyPart);
    bodyPart.stringEncoding = self.stringEncoding;
    bodyPart.boundary = self.boundary;
    if ([_bodyParts containsObject:bodyPart]) {
        return;
    }
    [_bodyParts insertObject:bodyPart atIndex:0];
    
    
}
- (void)setInitialAndFinalBoundaries {
    if ([_bodyParts count] > 0) {
        for (QCloudHTTPBodyPart *bodyPart in _bodyParts) {
            bodyPart.hasInitialBoundary = NO;
            bodyPart.hasFinalBoundary = NO;
        }
        
        [[_bodyParts firstObject] setHasInitialBoundary:YES];
        [[_bodyParts lastObject] setHasFinalBoundary:YES];
    }
}


- (BOOL)isEmpty {
    return [_bodyParts count] == 0;
}

#pragma mark - NSInputStream

- (NSInteger)read:(uint8_t *)buffer
        maxLength:(NSUInteger)length
{
    if ([self streamStatus] == NSStreamStatusClosed) {
        return 0;
    }
    
    NSInteger totalNumberOfBytesRead = 0;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
    while ((NSUInteger)totalNumberOfBytesRead < length) {
        if (!_currentHTTPBodyPart || ![_currentHTTPBodyPart hasBytesAvailable])
        {
            if (!(_currentHTTPBodyPart = [_partEnumerator nextObject])) {
                break;
            }
        } else {
            NSUInteger maxLength = length - (NSUInteger)totalNumberOfBytesRead;
            NSInteger numberOfBytesRead = [_currentHTTPBodyPart read:&buffer[totalNumberOfBytesRead] maxLength:maxLength];
            if (numberOfBytesRead == -1) {
                self.streamError = _currentHTTPBodyPart.streamError;
                break;
            } else {
                totalNumberOfBytesRead += numberOfBytesRead;
            }
        }
    }
#pragma clang diagnostic pop
    
    return totalNumberOfBytesRead;
}

- (BOOL)getBuffer:(__unused uint8_t **)buffer
           length:(__unused NSUInteger *)len
{
    return NO;
}

- (BOOL)hasBytesAvailable {
    return [self streamStatus] == NSStreamStatusOpen;
}

#pragma mark - NSStream

- (void)open {
    if (self.streamStatus == NSStreamStatusOpen) {
        return;
    }
    
    self.streamStatus = NSStreamStatusOpen;
    
    [self setInitialAndFinalBoundaries];
    _partEnumerator = [_bodyParts objectEnumerator];
}

- (void)close {
    self.streamStatus = NSStreamStatusClosed;
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

- (unsigned long long)contentLength {
    unsigned long long length = 0;
    for (QCloudHTTPBodyPart *bodyPart in _bodyParts) {
        length += [bodyPart contentLength];
    }
    return length;
}

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


#ifdef DEBUG

- (NSString*) description
{
    NSMutableString* str = [NSMutableString new];
    for (QCloudHTTPBodyPart* part in _bodyParts) {
        [str appendFormat:@"%@\n",part];
    }
    return str;
}
#endif
@end
