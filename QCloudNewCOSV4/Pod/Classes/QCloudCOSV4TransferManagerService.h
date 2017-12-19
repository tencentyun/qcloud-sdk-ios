//
//  QCloudCOSV4TransferManagerService.h
//  QCloudCOS
//
//  Created by erichmzhang(张恒铭) on 06/11/2017.
//

#import <QCloudCore/QCloudCore.h>

@class QCloudCOSV4UploadObjectRequest;
@interface QCloudCOSV4TransferManagerService : QCloudService
#pragma hidden super selectors
- (int) performRequest:(QCloudBizHTTPRequest *)httpRequst NS_UNAVAILABLE;
- (int) performRequest:(QCloudBizHTTPRequest *)httpRequst withFinishBlock:(QCloudRequestFinishBlock)block NS_UNAVAILABLE;

#pragma Factory
+ (QCloudCOSV4TransferManagerService*)defaultCOSV4TransferManager;
+ (QCloudCOSV4TransferManagerService*)COSV4TransferManagerServiceForKey:(NSString*)key;
+ (QCloudCOSV4TransferManagerService*)registerDefaultCOSV4TransferMangerWithConfiguration:(QCloudServiceConfiguration*)configuration;
+ (QCloudCOSV4TransferManagerService*)registerDefaultCOSV4TransferMangerWithConfiguration:(QCloudServiceConfiguration*)configuration key:(NSString*)key;
- (void)uploadObject:(QCloudCOSV4UploadObjectRequest *)request;
@end
