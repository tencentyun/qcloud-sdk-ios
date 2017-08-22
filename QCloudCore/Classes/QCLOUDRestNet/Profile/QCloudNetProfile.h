//
//  QCloudNetProfile.h
//  Pods
//
//  Created by Dong Zhao on 2017/3/22.
//
//

#import <Foundation/Foundation.h>

@interface QCloudNetProfile : NSObject
+ (QCloudNetProfile*) shareProfile;
- (void) pointDownload:(int64_t)bytes;
- (void) pointUpload:(int64_t)bytes;
@end
