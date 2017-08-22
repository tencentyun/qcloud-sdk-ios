//
//  QCloudHTTPBodyPart.m
//  QCloudNetworking
//
//  Created by tencent on 16/2/18.
//  Copyright © 2016年 QCloudTernimalLab. All rights reserved.
//

#import "QCloudHTTPBodyPart.h"

static NSString * const kQCloudMultipartFormCRLF = @"\r\n";
static NSString* QCloudMultiPartFormInitialBoundary(NSString* boundary) {
    return [NSString stringWithFormat:@"--%@%@",boundary, kQCloudMultipartFormCRLF];
}

static inline NSString * QCloudMultipartFormEncapsulationBoundary(NSString *boundary) {
    return [NSString stringWithFormat:@"%@--%@%@", kQCloudMultipartFormCRLF, boundary, kQCloudMultipartFormCRLF];
}

static inline NSString * QCloudMultipartFormFinalBoundary(NSString *boundary) {
    return [NSString stringWithFormat:@"%@--%@--%@", kQCloudMultipartFormCRLF, boundary, kQCloudMultipartFormCRLF];
}


typedef OBJC_ENUM(NSInteger, QCloudHTTPPartReadStatus ) {
    QCloudHTTPPartReadEncapsulationBoundary = 1,
    QCloudHTTPPartReadHeader = 2,
    QCloudHTTPPartReadBody = 3,
    QCloudHTTPPartReadFinalBoundary = 4
};
    

@interface QCloudHTTPBodyPart ()
@property (nonatomic, strong)   NSData* streamData;
@property (nonatomic, strong)   NSURL* streamURL;
@property (nonatomic, strong)   NSMutableDictionary* headers;
@end

@implementation QCloudHTTPBodyPart
{
    QCloudHTTPPartReadStatus _readStatus;
    NSInputStream* _inputStream;
    NSMutableDictionary* _headers;
    NSData* _encapsulationData;
    NSData* _headerData;
    NSData* _finalData;
    unsigned long long _bodyLength;
    //
    unsigned long long _readBodyLength;
    unsigned long long _phaseReadOffset;
    //
    NSNumber* _fileOffset;
    //
}

- (void) dealloc
{
    
}
- (void) commonInit
{
    _stringEncoding = NSUTF8StringEncoding;
    _headers = [NSMutableDictionary new];
    [self transitionToNextStatus];
}

- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    [self commonInit];
    return self;
}

- (instancetype) initWithData:(NSData*)data
{
    self = [super init];
    if (!self) {
        return self;
    }
    _bodyLength = data.length;
    [self commonInit];
    _inputStream = [[NSInputStream alloc] initWithData:data];
    _streamData = data;
    return self;

}
- (instancetype) initWithURL:(NSURL*)url withContentLength:(unsigned long long)length
{
    self = [super init];
    if (!self) {
        return self;
    }
    [self commonInit];
    _bodyLength = length;
    _inputStream = [[NSInputStream alloc] initWithURL:url];
    _streamURL = url;
    return self;
}

- (instancetype) initWithURL:(NSURL *)url offetSet:(uint64_t)offset withContentLength:(unsigned long long)length
{
    self = [self initWithURL:url withContentLength:length];
    if (!self) {
        return self;
    }
    _fileOffset = @(offset);
    return self;
}

- (BOOL) hasBytesAvailable
{
    // Allows `read:maxLength:` to be called again if `AFMultipartFormFinalBoundary` doesn't fit into the available buffer
    if (_readStatus == QCloudHTTPPartReadFinalBoundary) {
        return YES;
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wcovered-switch-default"
    switch (_inputStream.streamStatus) {
        case NSStreamStatusNotOpen:
        case NSStreamStatusOpening:
        case NSStreamStatusOpen:
        case NSStreamStatusReading:
        case NSStreamStatusWriting:
            return YES;
        case NSStreamStatusAtEnd:
        case NSStreamStatusClosed:
        case NSStreamStatusError:
        default:
            return NO;
    }
#pragma clang diagnostic pop
}

- (void) setValue:(id)value forHeaderKey:(NSString *)key
{
    NSAssert(_readStatus == QCloudHTTPPartReadEncapsulationBoundary, @"can't modify bodypart when reading it");
    NSParameterAssert(value);
    NSParameterAssert(key);
    _headers[key] = value;
}

- (void) setHasInitialBoundary:(BOOL)hasInitialBoundary
{
    NSAssert(_readStatus == QCloudHTTPPartReadEncapsulationBoundary, @"can't modify bodypart when reading it");
    _hasInitialBoundary = hasInitialBoundary;
}


- (void) setHasFinalBoundary:(BOOL)hasFinalBoundary
{
    NSAssert(_readStatus == QCloudHTTPPartReadEncapsulationBoundary, @"can't modify bodypart when reading it");
    _hasFinalBoundary = hasFinalBoundary;
 
}


- (NSString *)stringForHeaders {
    NSMutableString *headerString = [NSMutableString string];
    for (NSString *field in [_headers allKeys]) {
        [headerString appendString:[NSString stringWithFormat:@"%@: %@%@", field, [_headers valueForKey:field], kQCloudMultipartFormCRLF]];
    }
    [headerString appendString:kQCloudMultipartFormCRLF];
    return [NSString stringWithString:headerString];
}


- (NSData*) headersData
{
    _headerData = [[self stringForHeaders] dataUsingEncoding:self.stringEncoding];
    return _headerData;
}

- (NSData*) encapsulationBoundaryData
{
       _encapsulationData = [([self hasInitialBoundary] ? QCloudMultiPartFormInitialBoundary(self.boundary) : QCloudMultipartFormEncapsulationBoundary(self.boundary)) dataUsingEncoding:self.stringEncoding];
    return _encapsulationData;
}

- (NSData*) finalBoundaryData
{
    
    _finalData =  ([self hasFinalBoundary] ? [QCloudMultipartFormFinalBoundary(self.boundary) dataUsingEncoding:self.stringEncoding] : [NSData data]);
    return _finalData;
}

- (unsigned long long) contentLength
{
    unsigned long long contentLength = 0;
    contentLength += [self encapsulationBoundaryData].length;
    contentLength += [self headersData].length;
    contentLength += _bodyLength;
    contentLength += [self finalBoundaryData].length;
    return contentLength;
}
- (NSInteger)read:(uint8_t *)buffer
        maxLength:(NSUInteger)length;
{
    NSUInteger bytesReadLength = 0;
    if (_readStatus == QCloudHTTPPartReadEncapsulationBoundary) {
        bytesReadLength += [self readData:[self encapsulationBoundaryData] intoBuffer:buffer maxLength:length];
    }
    
    if (bytesReadLength >= length) {
        return bytesReadLength;
    }

   
    if (_readStatus ==QCloudHTTPPartReadHeader) {
        bytesReadLength += [self readData:[self headersData] intoBuffer:&buffer[bytesReadLength] maxLength:(length - bytesReadLength)];
    }
    
    if (bytesReadLength >= length) {
        return bytesReadLength;
    }
    
    if (_readStatus == QCloudHTTPPartReadBody) {
        NSInteger bodyReadLength = 0;
        NSUInteger currentStepMaxRead = length - bytesReadLength;
        NSUInteger bodyMaxRead = 0;
        if (_bodyLength > _readBodyLength) {
           bodyMaxRead  = (NSUInteger)(_bodyLength - _readBodyLength);
        }
        NSUInteger willReadMaxLength = MIN(currentStepMaxRead, bodyMaxRead);
        bodyReadLength = [_inputStream read:&buffer[bytesReadLength] maxLength:willReadMaxLength];
        if (bodyReadLength  == -1) {
            return -1;
        } else {
            _readBodyLength += bodyReadLength;
            bytesReadLength  += bodyReadLength;
            if ([_inputStream streamStatus] >= NSStreamStatusAtEnd || _readBodyLength == _bodyLength) {
                [self transitionToNextStatus];
            }
        }
    }
    
    if (bytesReadLength >= length) {
        return bytesReadLength;
    }
    if (_readStatus == QCloudHTTPPartReadFinalBoundary) {
        bytesReadLength += [self readData:[self finalBoundaryData] intoBuffer:&buffer[bytesReadLength] maxLength:length - bytesReadLength];
    }
    
    return bytesReadLength;

}

- (NSInteger)readData:(NSData *)data
           intoBuffer:(uint8_t *)buffer
            maxLength:(NSUInteger)length
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
    NSRange range = NSMakeRange((NSUInteger)_phaseReadOffset, MIN([data length] - ((NSUInteger)_phaseReadOffset), length));
    [data getBytes:buffer range:range];
#pragma clang diagnostic pop
    
    _phaseReadOffset += range.length;
    
    if (((NSUInteger)_phaseReadOffset) >= [data length]) {
        [self transitionToNextStatus];
    }
    
    return (NSInteger)range.length;
}

- (void) transitionToNextStatus {
//    if (![[NSThread currentThread] isMainThread]) {
//        [self transitionToNextStatus];
//        return;
//    }
    
    switch (_readStatus) {
        case QCloudHTTPPartReadEncapsulationBoundary:
        {
            _readStatus = QCloudHTTPPartReadHeader;
            break;
        }
        case QCloudHTTPPartReadHeader: {
            [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
            [_inputStream open];
            if (_fileOffset) {
                [_inputStream setProperty:_fileOffset forKey:NSStreamFileCurrentOffsetKey];
            }
            _readBodyLength = 0;
            _readStatus = QCloudHTTPPartReadBody;
            break;
        }
            
        case QCloudHTTPPartReadBody: {

            [_inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
            [_inputStream close];
            _readStatus = QCloudHTTPPartReadFinalBoundary;
            break;
        }
        case QCloudHTTPPartReadFinalBoundary:
        default:
            _readStatus = QCloudHTTPPartReadEncapsulationBoundary;
            break;
    }
    _phaseReadOffset = 0;
}

- (NSError*) streamError
{
    return _inputStream.streamError;
}

- (void) setHeaderValueWithMap:(NSDictionary*)dictionary
{
    for (NSString* key in dictionary.allKeys) {
        [self setValue:dictionary[key] forHeaderKey:key];
    }
}

- (BOOL) isEqual:(QCloudHTTPBodyPart*)object
{
    
    if (![object isKindOfClass:[QCloudHTTPBodyPart class]]) {
        return NO;
    }
    if ((self.streamData || self.streamData) && ![self.streamData isEqualToData:object.streamData]) {
        return NO;
    }
    if ((self.streamURL || object.streamURL) && [self.streamURL.absoluteString caseInsensitiveCompare:object.streamURL.absoluteString] != NSOrderedSame) {
        return NO;
    }
    if (self.stringEncoding != object.stringEncoding) {
        return NO;
    }
    if ((object.boundary || self.boundary) && ![self.boundary isEqualToString:self.self.boundary]) {
        return NO;
    }
    if (_headers.count != object.headers.count) {
        return NO;
    }
    if (![self.headers isEqualToDictionary:object.headers]) {
        return NO;
    }
    return YES;

}
#ifdef DEBUG
- (NSString*) description
{
    NSMutableString* str = [NSMutableString new];
    [str appendFormat:@"[FORM DATA PART] %@\n %@ \n ",[super description], _headers];
    if (self.streamURL) {
        [str appendFormat:@"[URL]:%@", self.streamURL];
    }
    if (self.streamData) {
        [str appendFormat:@"[Data]:%lu", (unsigned long)self.streamData.length];
    }
    return str;
}
#endif
@end
