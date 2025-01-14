//
//  QCloudCustomLoader.h
//  Pods
//
//  Created by garenwang on 2024/12/30.
//

#import <Foundation/Foundation.h>
#import "QCloudCustomSession.h"
#import "QCloudCustomLoaderTask.h"
#import "QCloudHTTPRequest.h"
NS_ASSUME_NONNULL_BEGIN

@protocol QCloudCustomLoader <NSObject>

-(QCloudCustomSession *)session;

-(BOOL)enable:(QCloudHTTPRequest *)httpRequest;

@end

NS_ASSUME_NONNULL_END

