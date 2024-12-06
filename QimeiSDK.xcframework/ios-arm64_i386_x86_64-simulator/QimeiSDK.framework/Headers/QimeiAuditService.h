//
//  QimeiAuditService.h
//  QimeiAudit
//
//  Created by pariszhao on 2021/3/29.
//  Copyright © 2021 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QimeiAuditService : NSObject

+ (instancetype)shareInstance;

- (void)startWithAppkey:(nonnull NSString *)appkey;

- (NSString *)tick;

@end

NS_ASSUME_NONNULL_END


// 摄像头检测
FOUNDATION_EXPORT const char* _Nullable kCameraDefaultId;

  /// 开始检测摄像头环境，在开始视频之后再调用
  /// - Parameter camera_id: 传入当前AVCaptureDevice的uniqueID，如果不清楚传入默认值kCameraDefaultId
FOUNDATION_EXPORT void camera_detect(const char* _Nullable camera_id);


