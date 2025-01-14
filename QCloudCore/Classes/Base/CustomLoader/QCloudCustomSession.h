//
//  QCloudCustomSession.h
//  Pods-QCloudCOSXMLDemo
//
//  Created by garenwang on 2024/12/26.
//

#import <Foundation/Foundation.h>

@class QCloudCustomLoaderTask;
NS_ASSUME_NONNULL_BEGIN


@interface QCloudCustomSession : NSURLSession
@property (nonatomic,
           weak)id<NSURLSessionTaskDelegate, NSURLSessionDataDelegate>customDelegate;

/// 需要子类实现，由COS SDK 进行回调。
/// - Parameters:
///   - request: SDK 传出来的请求实例。
///   - fromFile: 以文件路径进行上传时的本地文件路径。
-(QCloudCustomLoaderTask *)taskWithRequset:(NSMutableURLRequest *)request
                                  fromFile:(NSURL *)fromFile;


/// 以下方法无需子类实现。供业务层调用，用于将自定义网络相应数据传给COS SDK。
/******************************************************************************/

/// 处理数据任务接收到响应时的情况
/// - Parameters:
///   - task: 自定义Task QCloudCustomLoaderTask子类
///   - response:请求响应数据
///   - completionHandler: 完成回调
- (void)customTask:(QCloudCustomLoaderTask *)task didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler;


/// 监控上传任务的进度
/// - Parameters:
///   - task: 自定义Task QCloudCustomLoaderTask子类
///   - bytesSent: 当前发送数据
///   - totalBytesSent: 总共发送数据
///   - totalBytesExpectedToSend: 总共待发送数据
- (void)customTask:(QCloudCustomLoaderTask *)task didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend;


/// 接受到数据
/// - Parameters:
///   - task: 自定义Task QCloudCustomLoaderTask子类
///   - data: 接受到的数据
- (void)customTask:(QCloudCustomLoaderTask *)task didReceiveData:(NSData *)data;


/// 任务完成
/// - Parameters:
///   - task: 自定义Task QCloudCustomLoaderTask子类
///   - error: 错误信息， SDK内会根据error 中的错误信息判断是否需要重试。
- (void)customTask:(QCloudCustomLoaderTask *)task didCompleteWithError:(NSError *)error;


/// 处理身份验证
/// - Parameters:
///   - task: 自定义Task QCloudCustomLoaderTask子类
///   - challenge: NSURLAuthenticationChallenge
///   - completionHandler: 完成回调
- (void)customTask:(QCloudCustomLoaderTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *_Nonnull)challenge
 completionHandler:(void (^_Nonnull)(NSURLSessionAuthChallengeDisposition disposition,
                                     NSURLCredential *_Nullable credential))completionHandler;


/// 收集性能参数
/// - Parameters:
///   - task: 自定义Task QCloudCustomLoaderTask子类
///   - metrics: NSURLSessionTaskMetrics 请求性能参数
- (void)customTask:(QCloudCustomLoaderTask *)task didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics API_AVAILABLE(ios(10.0));


/// 处理重定向
/// - Parameters:
///   - task: 自定义Task QCloudCustomLoaderTask子类
///   - response: 请求响应
///   - request: 重定向的请求
///   - completionHandler: 完成回调
- (void)customTask:(QCloudCustomLoaderTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler;
@end

NS_ASSUME_NONNULL_END
