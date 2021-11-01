//
//  BeaconEventUploader.h
//  Beacon
//
//  Created by dong kerry on 12-3-5.
//  Copyright (c) 2012年 tencent.com. All rights reserved.
//

@class BeaconEventRecord;

/**
  事件上报器:内部开启轮询,定时查询本地的事件并上报
 */
@interface BeaconEventUploader : NSObject
/// 上报 url
@property (atomic, retain) NSString *uploadUrl;

/// 默认上报器（主通道），内部会开启定时器轮询上报
+ (BeaconEventUploader *)defaultUploader;

/// 无论数据库存储的事件有多少条都立即上报，且如果定时器没有开启，则开启定时器轮询
- (void)uploadImmediately;

/// 事件不入DB，直接进行上报
- (void)uploadEventsInMemory:(NSArray<BeaconEventRecord *> *)eventRecords;

/// 如果定时器没有开启，则开启定时器轮询
- (void)openTimerAgain;

@end
