//
//  QCloudCustomLoaderTask.h
//  Pods-QCloudCOSXMLDemo
//
//  Created by garenwang on 2024/12/26.
//

#import <Foundation/Foundation.h>
@class QCloudCustomSession;
NS_ASSUME_NONNULL_BEGIN

@interface QCloudCustomLoaderTask : NSURLSessionDataTask

@property (nullable, readwrite, copy) NSHTTPURLResponse *response;
@property (nullable, readwrite, copy) NSURLRequest *currentRequest;
@property (nullable, readwrite, copy) NSURLRequest *originalRequest;
@property (atomic, assign) int64_t countOfBytesSent;
@property (atomic, assign) int64_t countOfBytesExpectedToSend;
/// 子类实现，用于构建自定义task。
/// - Parameters:
///   - httpRequest: SDK 构建好的 NSMutableURLRequest示例对象。
///   - fromFile: 上传文件的本地路径，只有上传文件格式为文件路径时才有值。
///   - session: 自定义session ，QCloudCustomSession的子类实例。
- (instancetype)initWithHTTPRequest:(NSMutableURLRequest *)httpRequest
                           fromFile:(NSURL *)fromFile
                            session:(QCloudCustomSession *)session;

/// 子类实现，用于开启任务。
-(void)resume;

/// 子类实现，用于取消当前任务。
- (void)cancel;
@end

NS_ASSUME_NONNULL_END
