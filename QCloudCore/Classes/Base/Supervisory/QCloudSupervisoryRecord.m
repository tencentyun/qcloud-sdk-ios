//
//  QCloudSupervisoryRecord.m
//  Pods
//
//  Created by Dong Zhao on 2017/4/7.
//
//

#import "QCloudSupervisoryRecord.h"

@implementation QCloudSupervisoryRecord
- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _logDate = [NSDate date];
    return self;
}
@end

@implementation QCloudSupervisoryNetworkRecord
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.type = QCloudSupervisoryRecordTypeNetwork;
    }
    return self;
}
@end
