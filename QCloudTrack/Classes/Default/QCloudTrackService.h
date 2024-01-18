//
//  QCloudTrackService.h
//  QCloudTrack
//
//  Created by garenwang on 2023/12/18.
//

#import <Foundation/Foundation.h>
#import "QCloudBaseTrackService.h"
#import "QCloudIReport.h"
NS_ASSUME_NONNULL_BEGIN

@interface QCloudTrackService : NSObject
-(instancetype)init NS_UNAVAILABLE;
-(instancetype)new NS_UNAVAILABLE;

+(QCloudTrackService *)singleService;

-(void)setIsCloseReport:(BOOL)isCloseReport;

-(void)addTrackService:(QCloudBaseTrackService *)service serviceKey:(NSString *)serviceKey;

-(void)setBusinessParams:(NSDictionary *)businessParams;

- (void)reportWithEventCode:(NSString *)eventCode params:(NSDictionary *)params serviceKey:(NSString *)serviceKey;

- (void)reportSimpleDataWithEventParams:(NSDictionary *)params;
@end

NS_ASSUME_NONNULL_END
