//
//  QCloudAFLoader.m
//  QCloudCOSXMLDemo
//
//  Created by garenwang on 2024/12/30.
//  Copyright © 2024 Tencent. All rights reserved.
//

#import "QCloudAFLoader.h"
#import "QCloudAFLoaderSession.h"
@implementation QCloudAFLoader
-(QCloudCustomSession *)session{
    return [QCloudAFLoaderSession session];
}

-(BOOL)enable:(QCloudHTTPRequest *)httpRequest{
    return YES;
}
@end
