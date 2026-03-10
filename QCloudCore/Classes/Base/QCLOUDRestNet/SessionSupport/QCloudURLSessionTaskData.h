//
//  QCloudURLSessionTaskData.h
//  QCloudTernimalLab_CommonLogic
//
//  Created by tencent on 5/12/16.
//  Copyright © 2016 QCloudTernimalLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QCloudHTTPRetryHanlder;
@class QCloudHTTPRequest;

@interface QCloudURLSessionTaskData : NSObject
@property (nonatomic, assign) int identifier;
@property (nonatomic, strong) QCloudHTTPRetryHanlder *retryHandler;
@property (nonatomic, strong) QCloudHTTPRequest *httpRequest;
@property (nonatomic, assign, readonly) NSUInteger totalRecivedLength;
@property (nonatomic, strong, readonly) NSData *data;
@property (nonatomic, strong) NSHTTPURLResponse *response;
@property (nonatomic, assign) BOOL isTaskCancelledByStatusCodeCheck;
@property (nonatomic, strong, readonly) NSString *uploadTempFilePath;
@property (nonatomic, strong) NSInputStream *bodyStream;
@property (nonatomic, assign) BOOL forbidenWirteToFile;
@property (nonatomic, assign) BOOL forbidenWirteToCache; /// 是否禁止写到缓存中（默认为NO）
- (instancetype)init;
- (instancetype)initWithDowndingFileHandler:(NSFileHandle *)fileHandler;
- (void)restData;
- (void)appendData:(NSData *)data;
- (void)closeWrite;
@end
