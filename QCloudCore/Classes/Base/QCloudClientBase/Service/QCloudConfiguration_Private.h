//
//  QCloudConfiguration_Private.h
//  Pods
//
//  Created by Dong Zhao on 2017/4/11.
//
//

#import "QCloudServiceConfiguration.h"
#import "QCloudEndPoint.h"

@interface QCloudConfiguration ()
@property (nonatomic, strong, readonly) NSString *userAgent;
@property (nonatomic, strong) NSString *userAgentProductKey;
@property (nonatomic, strong) NSString *productVersion;
@property (nonatomic, strong) NSString *bridge;
@end
