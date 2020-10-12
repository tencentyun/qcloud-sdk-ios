//
//  QCloudTestTempVariables.h
//  QCloudCOSXMLDemoTests
//
//  Created by erichmzhang(张恒铭) on 13/11/2017.
//  Copyright © 2017 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QCloudTestTempVariables : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, copy) NSString* testBucket;

@end
