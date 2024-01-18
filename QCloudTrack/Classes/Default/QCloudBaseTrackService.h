//
//  QCloudBaseTrackService.h
//  QCloudTrack
//
//  Created by garenwang on 2023/12/18.
//

#import <Foundation/Foundation.h>
#import "QCloudIReport.h"
NS_ASSUME_NONNULL_BEGIN

@interface QCloudBaseTrackService : NSObject<QCloudIReport>

// 是否是debug模式
@property (nonatomic,assign,readonly)BOOL isDebug;

// 是否关闭上报
@property (nonatomic,assign)BOOL isCloseReport;

@end

NS_ASSUME_NONNULL_END
