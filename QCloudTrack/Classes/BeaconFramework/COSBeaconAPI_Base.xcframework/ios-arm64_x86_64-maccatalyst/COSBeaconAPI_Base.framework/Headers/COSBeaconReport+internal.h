//
//  COSBeaconReport+internal.h
//  COSBeaconAPI_Base
//
//  Created by naikunwang on 2022/3/24.
//  Copyright © 2022 tencent.com. All rights reserved.
//

#import "COSBeaconReport.h"

NS_ASSUME_NONNULL_BEGIN

@interface COSBeaconReport (internal)
/// 上报灯塔内置事件
- (COSBeaconReportResult *)reportInternalEvent:(COSBeaconEvent *)event;
@end

NS_ASSUME_NONNULL_END
