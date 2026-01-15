//
//  QCloudPNetMLanScanner.h
//  PhoneNetSDK
//
//  Created by mediaios on 2019/6/5.
//  Copyright © 2019年 mediaios. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class QCloudPNetMLanScanner;
@protocol QCloudPNetMLanScannerDelegate <NSObject>

@optional

/**
 @brief Show active ip in LAN

 @param scanner  The instance of `QCloudPNetMLanScanner`
 @param ip Active ip (Accessible device ip)
 */
- (void) scanMLan:(QCloudPNetMLanScanner *)scanner activeIp:(NSString *)ip;


/**
 @brief Show the percentage of scan progress, which is a decimal of 0-1

 @param scanner The instance of `QCloudPNetMLanScanner`
 @param percent The percentage of scan progress
 */
- (void) scanMlan:(QCloudPNetMLanScanner *)scanner percent:(float)percent;

/**
 @brief Scan all ip ends in the LAN

 @param scanner The instance of `QCloudPNetMLanScanner`
 */
- (void) finishedScanMlan:(QCloudPNetMLanScanner *)scanner;

@end

@interface QCloudPNetMLanScanner : NSObject

@property (nonatomic,weak) id<QCloudPNetMLanScannerDelegate> delegate;


/**
 @brief Get a `QCloudPNetMLanScanner` instance

 @return A `QCloudPNetMLanScanner` instance
 */
+ (instancetype)shareInstance;


/**
 @brief Start scanning ip in the LAN
 */
- (void)scan;


/**
 @brief Stop lan scanning
 */
- (void)stop;


/**
 @brief Get the status of the current LAN ip scan

 @return YES: scanning; NO: is not scanning
 */
- (BOOL)isScanning;

@end

NS_ASSUME_NONNULL_END
