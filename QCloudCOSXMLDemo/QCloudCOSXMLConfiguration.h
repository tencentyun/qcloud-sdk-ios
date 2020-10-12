//
//  QCloudCOSXMLConfiguration.h
//  QCloudCOSXMLDemo
//
//  Created by erichmzhang(张恒铭) on 26/04/2018.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QCloudCOSXML/QCloudCOSXML.h>


@interface QCloudCOSXMLConfiguration : NSObject
+ (instancetype)sharedInstance ;

@property (nonatomic, readonly) NSArray* availableRegions;
@property (nonatomic, copy)     NSString*            currentRegion;

/// 当前桶名称，之前是根据区域固定，现在是列表中点击动态改变
@property (nonatomic, copy)     NSString*            currentBucket;

@property (nonatomic, weak)     QCloudCOSXMLService*     currentService;
@property (nonatomic, weak)     QCloudCOSTransferMangerService* currentTransferManager;


- (NSString*)bucketInRegion:(NSString*)region;
@end
