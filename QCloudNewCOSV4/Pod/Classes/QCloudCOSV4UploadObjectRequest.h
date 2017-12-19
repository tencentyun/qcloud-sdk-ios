//
//  QCloudCOSV4UploadObjectRequest.h
//  QCloudCOS
//
//  Created by erichmzhang(张恒铭) on 06/11/2017.
//

#import "QCloudCOS.h"
#import "QCloudUploadObjectRequest.h"
#import <Foundation/Foundation.h>

@interface QCloudCOSV4UploadObjectRequest : QCloudUploadObjectRequest
@property (nonatomic, weak) QCloudCOSV4Service* transferManager;
@end
