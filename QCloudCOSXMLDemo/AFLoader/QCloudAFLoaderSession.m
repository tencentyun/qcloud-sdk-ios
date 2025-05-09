//
//  QCloudAFLoaderSession.m
//  QCloudCOSXMLDemo
//
//  Created by garenwang on 2024/12/30.
//  Copyright © 2024 Tencent. All rights reserved.
//

#import "QCloudAFLoaderSession.h"
#import "QCloudAFLoaderTask.h"
@implementation QCloudAFLoaderSession

+(QCloudAFLoaderSession *)session{
    static QCloudAFLoaderSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        session = [[QCloudAFLoaderSession alloc] init];
    
    });
    return session;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        self.manager.responseSerializer = [[AFCompoundResponseSerializer alloc]init];
    }
    return self;
}

-(QCloudCustomLoaderTask *)taskWithRequset:(NSMutableURLRequest *)request
                                  fromFile:(NSURL *)fromFile{
    QCloudAFLoaderTask * task = [[QCloudAFLoaderTask alloc]initWithHTTPRequest:request fromFile:fromFile session:[QCloudAFLoaderSession session]];
    return task;
}
@end
