//
//  QCloudBaseTrackService.m
//  QCloudTrack
//
//  Created by garenwang on 2023/12/18.
//

#import "QCloudBaseTrackService.h"

@implementation QCloudBaseTrackService
- (BOOL)isDebug{
#if defined(DEBUG) && DEBUG
    return YES;
#else
    return NO;
#endif
}

- (void)reportWithEventCode:(NSString *)eventCode params:(NSDictionary *)params{
    
}
@end
