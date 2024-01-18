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
@property (nonatomic,strong)LogProducerClient *clsClient;
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
    
    LogProducerConfig * config = [[LogProducerConfig alloc]initWithCoreInfo:self.endPoint accessKeyID:self.credentialProvider.getCredentials.secretId accessKeySecret:self.credentialProvider.getCredentials.secretKey securityToken:self.credentialProvider.getCredentials.token];
    [config SetTopic:self.topicId];
    [config SetPackageLogBytes:1024*1024];
    [config SetPackageLogCount:1024];
    [config SetPackageTimeout:3000];
    [config SetMaxBufferLimit:64*1024*1024];
    [config SetSendThreadCount:1];
    [config SetConnectTimeoutSec:10];
    [config SetSendTimeoutSec:10];
    [config SetDestroyFlusherWaitSec:1];
    [config SetDestroySenderWaitSec:1];
    [config SetCompressType:1];
    self.clsClient = [[LogProducerClient alloc]initWithClsLogProducer:config callback:nil];
}

-(void)reportWithEventCode:(NSString *)eventCode params:(NSDictionary *)params{
    
    if (self.isCloseReport) {
        return;
    }
    
    [self setupCLSSDK];
    
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
    Log* log = [[Log alloc] init];
    [log PutContent:eventCode value:paramsString];
    LogProducerResult result = [self.clsClient PostLog:log];
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
