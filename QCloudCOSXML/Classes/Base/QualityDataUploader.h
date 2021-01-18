//
//  QualityDataUploader.h
//  QCloudCOSXML
//
//  Created by erichmzhang(张恒铭) on 2018/8/23.
//

#import <Foundation/Foundation.h>
@class QCloudAbstractRequest;

@interface QualityDataUploader : NSObject
+ (void)startWithAppkey:(NSString *)appkey;
+ (void)trackSDKRequestSuccessWithRequest:(QCloudAbstractRequest *)request;
+ (void)trackSDKRequestFailWithRequest:(QCloudAbstractRequest *)request error:(NSError *)error;
+ (void)trackSDKExceptionWithException:(NSException *)exception;
+ (void)trackNormalEventWithKey:(NSString *)key props:(NSDictionary *)props;
@end
