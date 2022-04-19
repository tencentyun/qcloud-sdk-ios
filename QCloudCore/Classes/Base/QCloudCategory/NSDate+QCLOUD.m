//
//  NSDate+QCLOUD.m
//  QCloudCore
//
//  Created by karisli(李雪) on 2018/12/18.
//

#import "NSDate+QCLOUD.h"
#import "QCloudLogger.h"
static NSTimeInterval _timeDeviation = 0.0;
@implementation NSDate (QCLOUD)
+ (NSDate *)qcloud_calibrateTime {
    QCloudLogDebug(@"fix skew time %@", [self qcloud_stringFromDate:[[NSDate date] dateByAddingTimeInterval:-1 * _timeDeviation]]);
    return [[NSDate date] dateByAddingTimeInterval:-1 * _timeDeviation];
}
+ (void)qcloud_setTimeDeviation:(NSTimeInterval)timeDeviation {
    @synchronized(self) {
        _timeDeviation = timeDeviation;
    }
}
+ (NSTimeInterval)qcloud_getTimeDeviation {
    @synchronized(self) {
        return _timeDeviation;
    }
}
+ (NSString *)qcloud_stringFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //创建一个日期格式化器
    dateFormatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";               //指定转date得日期格式化形式
    return [dateFormatter stringFromDate:date];                      // 2015-11-20
}

+ (NSString *)qcloud_stringFromDate_24:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //创建一个日期格式化器
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";               //指定转date得日期格式化形式
    return [dateFormatter stringFromDate:date];                      // 2015-11-20
}

+ (NSDate *)localDate {
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date dateByAddingTimeInterval:interval];
    return localeDate;
}
@end
