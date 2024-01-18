//
//  QCloudBeaconTrackService.h
//  QCloudTrack
//
//  Created by garenwang on 2023/12/18.
//

#import <Foundation/Foundation.h>
#import "QCloudBaseTrackService.h"
NS_ASSUME_NONNULL_BEGIN

@interface QCloudBeaconTrackService : QCloudBaseTrackService

- (instancetype)initWithBeaconKey:(NSString *)key;

- (void)updateBeaconKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
