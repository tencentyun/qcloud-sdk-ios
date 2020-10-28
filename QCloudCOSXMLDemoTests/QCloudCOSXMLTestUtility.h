//
//  QCloudCOSXMLTestUtility.h
//  QCloudCOSXMLDemo
//
//  Created by erichmzhang(张恒铭) on 01/12/2017.
//  Copyright © 2017 Tencent. All rights reserved.
//

#import "QCloudCOSXMLVersion.h"


//#if QCloudCoreModuleVersionNumber >= 502000
#import <QCloudCore/QCloudTestUtility.h>
#import <QCloudCOSXML/QCloudCOSXML.h>
@interface QCloudCOSXMLTestUtility : QCloudTestUtility
@property (nonatomic,strong)QCloudCOSXMLService *cosxmlService;
+ (instancetype)sharedInstance;
- (NSString*)createTestBucket:(NSString *)bucketName;
- (NSString*)createTestBucketWithPrefix:(NSString *)prefix;

- (void)deleteTestBucket:(NSString*)bucket;

- (void)deleteAllTestBuckets;
-(NSString *)createTestBucketWithCosSerVice:(QCloudCOSXMLService *)service withPrefix:(NSString *)prefix;

- (NSString*)uploadTempObjectInBucket:(NSString*)bucket;
@end
//#endif

