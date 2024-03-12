//
//  QCloudCLSTrackService.h
//  QCloudTrack
//
//  Created by garenwang on 2023/12/18.
//

#import <Foundation/Foundation.h>
#import "QCloudBaseTrackService.h"
#import "QCloudClsSessionCredentials.h"
#import "QCloudClsLifecycleCredentialProvider.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCloudCLSTrackService : QCloudBaseTrackService
- (instancetype)initWithTopicId:(NSString *)topicId endpoint:(NSString *)endPoint;

-(void)setupPermanentCredentials:(QCloudClsSessionCredentials *)credentials;

-(void)setupCredentialsRefreshBlock:(QCloudCredentialRefreshBlock)refreshBlock;
@end

NS_ASSUME_NONNULL_END
