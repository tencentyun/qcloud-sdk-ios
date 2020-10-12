//
//  SecretStorage.h
//  QCloudCOSXMLDemoTests
//
//  Created by karisli(李雪) on 2019/1/22.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SecretStorage : NSObject
+ (instancetype)sharedInstance;

@property (nonatomic, copy) NSString* appID;
@property (nonatomic, copy) NSString* secretID;
@property (nonatomic, copy) NSString* secretKey;

@end

NS_ASSUME_NONNULL_END
