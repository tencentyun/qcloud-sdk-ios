//
//  QCloudSupervisorySession.m
//  Pods
//
//  Created by Dong Zhao on 2017/4/7.
//
//

#import "QCloudSupervisorySession.h"
#import "QCloudFCUUID.h"

@interface QCloudSupervisorySession ()
{
    NSMutableArray* _recordArray;
}
@end

@implementation QCloudSupervisorySession
@synthesize traceIdentifier = _traceIdentifier;
@synthesize beginDate = _beginDate;

- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _beginDate = [NSDate date];
    _recordArray = [NSMutableArray new];
    _deviceUUID = [QCloudFCUUID uuidForDevice];
    _traceIdentifier = [[NSUUID UUID] UUIDString];
    return self;
}

- (void) markFinish
{
    _endDate = [NSDate date];
}

- (void) appendRecord:(QCloudSupervisoryRecord *)record
{
    if (!record) {
        return;
    }
    [_recordArray addObject:record];
}

- (NSArray<QCloudSupervisoryRecord*>*) records
{
    return [_recordArray copy];
}

@end
