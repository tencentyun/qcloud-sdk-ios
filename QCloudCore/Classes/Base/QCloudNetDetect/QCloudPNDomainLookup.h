//
//  PNDomainLook.h
//  PhoneNetSDK
//
//  Created by mediaios on 2019/2/28.
//  Copyright © 2019 mediaios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QCloudPhoneNetSDKHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCloudPNDomainLookup : NSObject
+ (instancetype)shareInstance;
- (void)lookupDomain:(NSString * _Nonnull)domain completeHandler:(NetLookupResultHandler _Nonnull)handler;
@end

NS_ASSUME_NONNULL_END
