//
//  QualityDataUploader.h
//  QCloudCOSXML
//
//  Created by erichmzhang(张恒铭) on 2018/8/23.
//

#import <Foundation/Foundation.h>
#import <QCloudCore/MTA.h>

@interface QualityDataUploader : NSObject
+ (void)trackUploadSuccessWithType;
+ (void)trackUploadFailWithError:(NSError *)error;
+ (void)trackRequestSentWithType:(Class)cls;
+ (void)trackRequestSuccessWithType:(Class)cls;
+ (void)trackRequestFailWithError:(NSError *)error;
@end


