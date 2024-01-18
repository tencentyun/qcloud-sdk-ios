//
//  QCloudCOSXML+Quality.h
//  QCloudCOSXML
//
//  Created by erichmzhang(张恒铭) on 2018/8/23.
//

#import <Foundation/Foundation.h>
#import "QCloudCOSXMLService.h"

extern  NSString *const kQCloudDataAppReleaseKey;

@interface QCloudCOSXMLService (Quality)
+(NSMutableDictionary *)commonParams:(NSString *)appKey;
@end
