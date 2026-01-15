//
//  QCloudPNetInfoTool.h
//  PhoneNetSDK
//
//  Created by mediaios on 2018/10/16.
//  Copyright © 2018 mediaios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QCloudPNetInfoTool : NSObject


+ (instancetype)shareInstance;
- (void)refreshNetInfo;

#pragma mark - for wifi
- (NSString*)pGetNetworkType;
- (NSString *)pGetSSID;
- (NSString *)pGetBSSID;
- (NSString *)pGetWifiIpv4;
- (NSString *)pGetSubNetMask;
- (NSString *)pGetWifiIpv6;
- (NSString *)pGetCellIpv4;


@end
