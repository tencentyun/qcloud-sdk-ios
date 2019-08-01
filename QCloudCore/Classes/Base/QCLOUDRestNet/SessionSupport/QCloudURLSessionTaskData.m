//
//  QCloudURLSessionTaskData.m
//  QCloudTernimalLab_CommonLogic
//
//  Created by tencent on 5/12/16.
//  Copyright © 2016 QCloudTernimalLab. All rights reserved.
//

#import "QCloudURLSessionTaskData.h"
#import "QCloudHTTPRetryHanlder.h"
#import <objc/runtime.h>
#import "QCloudFileUtils.h"

@interface QCloudURLSessionTaskData ()
{
    NSMutableData* _cacheData;
    NSFileHandle* _writeFileHandler;
    int64_t _initDataLength;
}
@end


@implementation QCloudURLSessionTaskData
@synthesize uploadTempFilePath = _uploadTempFilePath;
- (void) dealloc
{
    if (self.uploadTempFilePath) {
        QCloudRemoveFileByPath(self.uploadTempFilePath);
    }
    if (_writeFileHandler) {
        [_writeFileHandler closeFile];
    }
}

- (void) closeWrite
{
    if (_writeFileHandler) {
        [_writeFileHandler closeFile];
    }
}
- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _cacheData = [NSMutableData new];
    return self;
}

- (instancetype) initWithDowndingFileHandler:(NSFileHandle*)fileHandler
{
    self = [self init];
    if (!self) {
        return self;
    }
    _cacheData = [NSMutableData new];
    _writeFileHandler = fileHandler;
    _initDataLength = _writeFileHandler.offsetInFile;
    _forbidenWirteToFile = NO;
    return self;
}

- (NSString*) uploadTempFilePath
{
    if (!_uploadTempFilePath) {
        _uploadTempFilePath = QCloudTempFilePathWithExtension(@"uploadpart");
    }
    return _uploadTempFilePath;
}
- (NSUInteger) totalRecivedLength
{
    if (_writeFileHandler) {
        return [_writeFileHandler offsetInFile] - _initDataLength;
    } else {
        return _cacheData.length;
    }
}

- (void) restData
{
    if (_writeFileHandler) {
        [_writeFileHandler seekToFileOffset:0];
    } else {
        _cacheData = [NSMutableData new];
    }
}

- (NSData*) data
{
    return [_cacheData copy];
}

- (void) appendData:(NSData*)data
{
    if (_writeFileHandler && !_forbidenWirteToFile) {
        @synchronized (_writeFileHandler) {
            [_writeFileHandler writeData:data];
        }
    } else {
        @synchronized (_cacheData) {
            [_cacheData appendData:data];
        }
    }
}
@end

