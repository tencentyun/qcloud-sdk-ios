//
//  QCloudIReport.h
//  Pods
//
//  Created by garenwang on 2023/12/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol QCloudIReport <NSObject>

-(void)reportWithEventCode:(NSString *)eventCode params:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
