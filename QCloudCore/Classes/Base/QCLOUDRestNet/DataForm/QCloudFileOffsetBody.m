//
//  QCloudFileOffsetBody.m
//  Pods
//
//  Created by Dong Zhao on 2017/5/23.
//
//

#import "QCloudFileOffsetBody.h"

@implementation QCloudFileOffsetBody
- (instancetype) initWithFile:(NSURL *)fileURL offset:(NSUInteger)offset slice:(NSUInteger)slice
{
    self = [super init];
    if (!self) {
        return self;
    }
    _fileURL = fileURL;
    _offset = offset;
    _sliceLength = slice;
    return self;
}

@end
