//
//  QCloudAFLoaderSession.h
//  QCloudCOSXMLDemo
//
//  Created by garenwang on 2024/12/30.
//  Copyright © 2024 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QCloudCore/QCloudCustomLoader.h"
#import "AFNetworking/AFNetworking.h"
NS_ASSUME_NONNULL_BEGIN

@interface QCloudAFLoaderSession : QCloudCustomSession

@property (nonatomic,strong)AFURLSessionManager *manager;

+(QCloudAFLoaderSession *)session;

@end

NS_ASSUME_NONNULL_END
