//
//  QCloudLoggerOutput.m
//  QCloudCore
//
//  Created by Dong Zhao on 2018/5/29.
//

#import "QCloudLoggerOutput.h"

@implementation QCloudLoggerOutput
- (void) appendLog:(QCloudLogModel *(^)(void))logCreate
{
    [NSException exceptionWithName:@"com.qcloud.logger" reason:@"You must implementation this method in subclass of QCloudLoggerOutput" userInfo:nil];
}
@end
