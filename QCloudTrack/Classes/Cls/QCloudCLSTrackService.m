//
//  QCloudCLSTrackService.m
//  QCloudTrack
//
//  Created by garenwang on 2023/12/18.
//

#import "QCloudCLSTrackService.h"

@interface QCloudCLSTrackService ()
@property (nonatomic,strong)NSString * topicId;
@property (nonatomic,strong)NSString * endPoint;
@property (nonatomic,strong)QCloudClsLifecycleCredentialProvider * credentialProvider;
@property (nonatomic,strong)id clsClient;
@end

@implementation QCloudCLSTrackService

- (instancetype)initWithTopicId:(NSString *)topicId endpoint:(NSString *)endPoint{
    self = [super init];
    if (self) {
        self.topicId = topicId;
        self.endPoint = endPoint;
    }
    return self;
}

-(void)setupPermanentCredentials:(QCloudClsSessionCredentials *)credentials{
    self.credentialProvider = [[QCloudClsLifecycleCredentialProvider alloc]initWithPermanentCredentials:credentials];
}

-(void)setupCredentialsRefreshBlock:(QCloudCredentialRefreshBlock)refreshBlock{
    self.credentialProvider = [[QCloudClsLifecycleCredentialProvider alloc]initWithCredentialsRefresh:refreshBlock];
}

-(void)setupCLSSDK{
    Class LogProducerConfigClass = NSClassFromString(@"LogProducerConfig");
    if (!LogProducerConfigClass) {
        NSLog(@"请在podfile中依赖：TencentCloudLogProducer");
        return;
    }
    
    id config = [[LogProducerConfigClass alloc] init];
    // 获取 initWithCoreInfo:accessKeyID:accessKeySecret:securityToken: 方法的选择器
    SEL initWithCoreInfoSelector = NSSelectorFromString(@"initWithCoreInfo:accessKeyID:accessKeySecret:securityToken:");

    // 使用反射调用 initWithCoreInfo:accessKeyID:accessKeySecret:securityToken: 方法
    if (![config respondsToSelector:initWithCoreInfoSelector]) {
        NSLog(@"请在podfile中依赖：TencentCloudLogProducer");
    }
    
    NSString *endPoint = self.endPoint;
    NSString *accessKeyID = self.credentialProvider.getCredentials.secretId;
    NSString *accessKeySecret = self.credentialProvider.getCredentials.secretKey;
    NSString *securityToken = self.credentialProvider.getCredentials.token;

    NSMethodSignature *signature = [config methodSignatureForSelector:initWithCoreInfoSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:initWithCoreInfoSelector];
    [invocation setTarget:config];
    [invocation setArgument:&endPoint atIndex:2];
    [invocation setArgument:&accessKeyID atIndex:3];
    [invocation setArgument:&accessKeySecret atIndex:4];
    [invocation setArgument:&securityToken atIndex:5];
    [invocation invoke];

    // 获取返回值
    id initializedConfig;
    [invocation getReturnValue:&initializedConfig];
    config = initializedConfig;
    
    if ([config respondsToSelector:NSSelectorFromString(@"SetTopic:")]) {
        [config performSelector:NSSelectorFromString(@"SetTopic:") withObject:self.topicId];
    }
    
    if ([config respondsToSelector:NSSelectorFromString(@"SetPackageLogBytes:")]) {
        [config performSelector:NSSelectorFromString(@"SetPackageLogBytes:") withObject:@(1024*1024)];
    }
    if ([config respondsToSelector:NSSelectorFromString(@"SetPackageLogCount:")]) {
        [config performSelector:NSSelectorFromString(@"SetPackageLogCount:") withObject:@1024];
    }
    if ([config respondsToSelector:NSSelectorFromString(@"SetPackageTimeout:")]) {
        [config performSelector:NSSelectorFromString(@"SetPackageTimeout:") withObject:@3000];
    }
    if ([config respondsToSelector:NSSelectorFromString(@"SetMaxBufferLimit:")]) {
        [config performSelector:NSSelectorFromString(@"SetMaxBufferLimit:") withObject:@(64*1024*1024)];
    }
    if ([config respondsToSelector:NSSelectorFromString(@"SetSendThreadCount:")]) {
        [config performSelector:NSSelectorFromString(@"SetSendThreadCount:") withObject:@1];
    }
    if ([config respondsToSelector:NSSelectorFromString(@"SetConnectTimeoutSec:")]) {
        [config performSelector:NSSelectorFromString(@"SetConnectTimeoutSec:") withObject:@10];
    }
    if ([config respondsToSelector:NSSelectorFromString(@"SetSendTimeoutSec:")]) {
        [config performSelector:NSSelectorFromString(@"SetSendTimeoutSec:") withObject:@10];
    }
    if ([config respondsToSelector:NSSelectorFromString(@"SetDestroyFlusherWaitSec:")]) {
        [config performSelector:NSSelectorFromString(@"SetDestroyFlusherWaitSec:") withObject:@1];
    }
    if ([config respondsToSelector:NSSelectorFromString(@"SetDestroySenderWaitSec:")]) {
        [config performSelector:NSSelectorFromString(@"SetDestroySenderWaitSec:") withObject:@1];
    }
    if ([config respondsToSelector:NSSelectorFromString(@"SetCompressType:")]) {
        [config performSelector:NSSelectorFromString(@"SetCompressType:") withObject:@1];
    }
    
    Class LogProducerClient = NSClassFromString(@"LogProducerClient");
    if (!LogProducerClient) {
        NSLog(@"请在podfile中依赖：TencentCloudLogProducer");
        return;
    }
    id clsClient = [[LogProducerConfigClass alloc] init];
    // 获取 initWithCoreInfo:accessKeyID:accessKeySecret:securityToken: 方法的选择器
    SEL clsinitWithCoreInfoSelector = NSSelectorFromString(@"initWithClsLogProducer:callback:");

    // 使用反射调用 initWithCoreInfo:accessKeyID:accessKeySecret:securityToken: 方法
    if (![clsClient respondsToSelector:clsinitWithCoreInfoSelector]) {
        NSLog(@"请在podfile中依赖：TencentCloudLogProducer");
    }
    self.clsClient = [clsClient performSelector:clsinitWithCoreInfoSelector withObject:config withObject:nil];
}

-(void)reportWithEventCode:(NSString *)eventCode params:(NSDictionary *)params{
    
    if (self.isCloseReport) {
        return;
    }
    if([self.credentialProvider needRefresh]){
        [self setupCLSSDK];
    }
    [self _reportWithEventCode:eventCode params:params];
}


-(void)_reportWithEventCode:(NSString *)eventCode params:(NSDictionary *)params{
    if (!eventCode || !params || ![params isKindOfClass:NSDictionary.class]) {
        return;
    }
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:NULL];
    if (!jsonData) {
        return;
    }
    NSString * paramsString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    if (!paramsString) {
        return;
    }
    Class Log = NSClassFromString(@"Log");
    if (!Log) {
        return;
    }
    id log = [[Log alloc]init];
    [log performSelector:NSSelectorFromString(@"PutContent:value:") withObject:eventCode withObject:paramsString];
    id result = [self.clsClient performSelector:NSSelectorFromString(@"PostLog:") withObject:log];
    if (self.isDebug) {
        NSMutableArray * array = [NSMutableArray new];
        for (NSString *key in params.allKeys) {
            [array addObject:[NSString stringWithFormat:@"%@=%@, ", key, params[key]]];
        }
        NSString * mapAsString = [[NSString alloc]initWithFormat:@"{%@}",[array componentsJoinedByString:@","]];
        NSString *logString = [NSString stringWithFormat:@"cls_post_result:eventCode: %@, topicId: %@, params: %@ => result: %ld", eventCode, self.topicId, mapAsString, (long)result];
        NSLog(@"%@", logString);
    }
}
@end
