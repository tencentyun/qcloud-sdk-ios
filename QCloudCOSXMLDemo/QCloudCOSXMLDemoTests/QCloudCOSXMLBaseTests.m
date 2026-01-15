//
//  QCloudCOSXMLBaseTests.m
//  QCloudCOSXMLDemoTests
//
//  测试 QCloudAbstractRequest+Quality 和 QCloudBizHTTPRequest+COSXML 的分支覆盖
//

#import <XCTest/XCTest.h>
#import <QCloudCore/QCloudCore.h>
#import "QCloudCOSXML.h"
#import "QCloudCOSXMLEndPoint.h"
#import "QCloudLogManager.h"
#import "QCloudCOSStorageClassEnum.h"
#import "QCloudGetServiceRequest+Custom.h"

static NSString * const kServiceWithDetect = @"quality_test_with_detect";
static NSString * const kServiceStrategyDefault = @"strategy_default";
static NSString * const kServiceStrategyAggressive = @"strategy_aggressive";
static NSString * const kServiceStrategyConservative = @"strategy_conservative";

@interface QCloudCOSXMLBaseTests : XCTestCase <QCloudSignatureProvider>
@end

@implementation QCloudCOSXMLBaseTests

- (void)setUp {
    [super setUp];
    
    // 注册开启网络探测的服务
    if (![QCloudCOSXMLService hasCosxmlServiceForKey:kServiceWithDetect]) {
        QCloudServiceConfiguration *config = [QCloudServiceConfiguration new];
        config.appID = @"1253960454";
        QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
        endpoint.regionName = @"ap-chengdu";
        config.endpoint = endpoint;
        config.disableNetworkDetect = NO;
        [QCloudCOSXMLService registerCOSXMLWithConfiguration:config withKey:kServiceWithDetect];
    }
    
    // 注册默认策略服务
    if (![QCloudCOSXMLService hasCosxmlServiceForKey:kServiceStrategyDefault]) {
        QCloudServiceConfiguration *config = [QCloudServiceConfiguration new];
        config.appID = @"1253960454";
        QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
        endpoint.regionName = @"ap-chengdu";
        config.endpoint = endpoint;
        config.networkStrategy = QCloudRequestNetworkStrategyDefault;
        [QCloudCOSXMLService registerCOSXMLWithConfiguration:config withKey:kServiceStrategyDefault];
    }
    
    // 注册激进策略服务
    if (![QCloudCOSXMLService hasCosxmlServiceForKey:kServiceStrategyAggressive]) {
        QCloudServiceConfiguration *config = [QCloudServiceConfiguration new];
        config.appID = @"1253960454";
        QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
        endpoint.regionName = @"ap-chengdu";
        config.endpoint = endpoint;
        config.networkStrategy = QCloudRequestNetworkStrategyAggressive;
        [QCloudCOSXMLService registerCOSXMLWithConfiguration:config withKey:kServiceStrategyAggressive];
    }
    
    // 注册保守策略服务
    if (![QCloudCOSXMLService hasCosxmlServiceForKey:kServiceStrategyConservative]) {
        QCloudServiceConfiguration *config = [QCloudServiceConfiguration new];
        config.appID = @"1253960454";
        QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
        endpoint.regionName = @"ap-chengdu";
        config.endpoint = endpoint;
        config.networkStrategy = QCloudRequestNetworkStrategyConservative;
        [QCloudCOSXMLService registerCOSXMLWithConfiguration:config withKey:kServiceStrategyConservative];
    }
}

#pragma mark - 工具方法

- (NSError *)mockErrorWithCode:(NSInteger)code url:(NSURL *)url {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    if (url) {
        userInfo[@"NSErrorFailingURLKey"] = url;
    }
    return [NSError errorWithDomain:@"TestDomain" code:code userInfo:userInfo];
}

- (QCloudGetObjectRequest *)createRequestWithService:(QCloudCOSXMLService *)service {
    QCloudGetObjectRequest *request = [QCloudGetObjectRequest new];
    request.bucket = @"test-bucket-1253960454";
    request.object = @"test-object";
    request.runOnService = service;
    return request;
}

#pragma mark - QCloudAbstractRequest+Quality 测试

- (void)testNotifyError_WithURL {
    QCloudGetObjectRequest *request = [self createRequestWithService:[QCloudCOSXMLService cosxmlServiceForKey:kServiceWithDetect]];
    NSError *error = [self mockErrorWithCode:500 url:[NSURL URLWithString:@"https://tfbtcbd174010922223-1253960454.cos.ap-beijing.myqcloud.com/5B9F68EE-25B9-4371-B463-1A61A010B42B?tagging&VersionId="]];
    
    XCTestExpectation *exp = [self expectationWithDescription:@"testNotifyError_WithURL"];
    [request setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNotNil(error);
        XCTAssertEqual(error.code, 500);
        [exp fulfill];
    }];
    
    [request notifyError:error];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testNotifyError_NoURL {
    QCloudGetObjectRequest *request = [self createRequestWithService:[QCloudCOSXMLService cosxmlServiceForKey:kServiceWithDetect]];
    NSError *error = [self mockErrorWithCode:500 url:[NSURL URLWithString:@"file://tfbtcbd174010922223-1253960454.xxx.aaa-beijing.myqcloud.com/5B9F68EE-25B9-4371-B463-1A61A010B42B?tagging&VersionId="]];
    
    XCTestExpectation *exp = [self expectationWithDescription:@"testNotifyError_NoURL"];
    [request setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNotNil(error);
        XCTAssertEqual(error.code, 500);
        [exp fulfill];
    }];
    
    [request notifyError:error];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}

#pragma mark - QCloudBizHTTPRequest+COSXML 网络策略测试

#pragma mark cos_buildRequestData 分支测试

/// 默认策略 → 不修改 endpoint
- (void)testBuildRequestData_Default {
    QCloudGetObjectRequest *request = [self createRequestWithService:[QCloudCOSXMLService cosxmlServiceForKey:kServiceStrategyDefault]];
    
    NSError *error = nil;
    BOOL result = [request buildRequestData:&error];
    
    XCTAssertTrue(result);
    XCTAssertNil(error);
}

/// 激进策略 + 首次请求
- (void)testBuildRequestData_Aggressive_First {
    QCloudGetObjectRequest *request = [self createRequestWithService:[QCloudCOSXMLService cosxmlServiceForKey:kServiceStrategyAggressive]];
    request.requestRetry = NO;
    
    NSError *error = nil;
    BOOL result = [request buildRequestData:&error];
    
    XCTAssertTrue(result);
    XCTAssertNil(error);
}

/// 激进策略 + 重试
- (void)testBuildRequestData_Aggressive_Retry {
    QCloudGetObjectRequest *request = [self createRequestWithService:[QCloudCOSXMLService cosxmlServiceForKey:kServiceStrategyAggressive]];
    request.requestRetry = YES;
    
    NSError *error = nil;
    BOOL result = [request buildRequestData:&error];
    
    XCTAssertTrue(result);
    XCTAssertNil(error);
    XCTAssertFalse(request.enableQuic);
}

/// 保守策略 + 首次请求
- (void)testBuildRequestData_Conservative_First {
    QCloudGetObjectRequest *request = [self createRequestWithService:[QCloudCOSXMLService cosxmlServiceForKey:kServiceStrategyConservative]];
    request.requestRetry = NO;
    
    NSError *error = nil;
    BOOL result = [request buildRequestData:&error];
    
    XCTAssertTrue(result);
    XCTAssertNil(error);
    XCTAssertFalse(request.enableQuic);
}

/// 保守策略 + 重试
- (void)testBuildRequestData_Conservative_Retry {
    QCloudGetObjectRequest *request = [self createRequestWithService:[QCloudCOSXMLService cosxmlServiceForKey:kServiceStrategyConservative]];
    request.requestRetry = YES;
    
    NSError *error = nil;
    BOOL result = [request buildRequestData:&error];
    
    XCTAssertTrue(result);
    XCTAssertNil(error);
}

/// 激进策略 + 指定 networkType
- (void)testBuildRequestData_Aggressive_NetworkType {
    QCloudGetObjectRequest *request = [self createRequestWithService:[QCloudCOSXMLService cosxmlServiceForKey:kServiceStrategyAggressive]];
    request.requestRetry = NO;
    request.networkType = QCloudRequestNetworkQuic;
    
    NSError *error = nil;
    BOOL result = [request buildRequestData:&error];
    
    XCTAssertTrue(result);
    XCTAssertNil(error);
    XCTAssertTrue(request.enableQuic);
}

/// 保守策略 + 重试 + 指定 networkType
- (void)testBuildRequestData_Conservative_Retry_NetworkType {
    QCloudGetObjectRequest *request = [self createRequestWithService:[QCloudCOSXMLService cosxmlServiceForKey:kServiceStrategyConservative]];
    request.requestRetry = YES;
    request.networkType = QCloudRequestNetworkHttp;
    
    NSError *error = nil;
    BOOL result = [request buildRequestData:&error];
    
    XCTAssertTrue(result);
    XCTAssertNil(error);
    XCTAssertFalse(request.enableQuic);
}

/// 激进策略 + 指定 endpoint
- (void)testBuildRequestData_Aggressive_Endpoint {
    QCloudGetObjectRequest *request = [self createRequestWithService:[QCloudCOSXMLService cosxmlServiceForKey:kServiceStrategyAggressive]];
    request.requestRetry = NO;
    QCloudCOSXMLEndPoint *customEndpoint = [[QCloudCOSXMLEndPoint alloc] init];
    customEndpoint.regionName = @"ap-beijing";
    customEndpoint.useHTTPS = YES;
    request.endpoint = customEndpoint;
    
    NSError *error = nil;
    BOOL result = [request buildRequestData:&error];
    
    XCTAssertTrue(result);
    XCTAssertNil(error);
}

/// 保守策略 + 重试 + 指定 endpoint
- (void)testBuildRequestData_Conservative_Retry_Endpoint {
    QCloudGetObjectRequest *request = [self createRequestWithService:[QCloudCOSXMLService cosxmlServiceForKey:kServiceStrategyConservative]];
    request.requestRetry = YES;
    QCloudCOSXMLEndPoint *customEndpoint = [[QCloudCOSXMLEndPoint alloc] init];
    customEndpoint.regionName = @"ap-beijing";
    customEndpoint.useHTTPS = YES;
    request.endpoint = customEndpoint;
    
    NSError *error = nil;
    BOOL result = [request buildRequestData:&error];
    
    XCTAssertTrue(result);
    XCTAssertNil(error);
}

#pragma mark - QCloudCOSXMLEndPoint 测试

/// 测试默认初始化
- (void)testEndPoint_Init {
    QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    
    XCTAssertTrue(endpoint.isPrefixURL);
    XCTAssertEqualObjects(endpoint.serviceName, @"myqcloud.com");
    XCTAssertTrue(endpoint.useHTTPS);  // 父类默认值
}

/// 测试 serverURLLiteral 优先返回
- (void)testEndPoint_ServerURLLiteral {
    NSURL *literalURL = [NSURL URLWithString:@"https://custom.example.com"];
    QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] initWithLiteralURL:literalURL];
    
    NSURL *result = [endpoint serverURLWithBucket:@"test-bucket" appID:@"1253960454" regionName:@"ap-beijing"];
    
    XCTAssertEqualObjects(result.host, @"custom.example.com");
}

/// 测试标准 URL 构建 (isPrefixURL = YES)
- (void)testEndPoint_ServerURL_PrefixURL {
    QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.regionName = @"ap-beijing";
    endpoint.isPrefixURL = YES;
    
    NSURL *result = [endpoint serverURLWithBucket:@"test-bucket" appID:@"1253960454" regionName:nil];
    
    XCTAssertEqualObjects(result.absoluteString, @"https://test-bucket-1253960454.cos.ap-beijing.myqcloud.com");
}

/// 测试非前缀 URL 构建 (isPrefixURL = NO)
- (void)testEndPoint_ServerURL_NotPrefixURL {
    QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.regionName = @"ap-beijing";
    endpoint.isPrefixURL = NO;
    
    NSURL *result = [endpoint serverURLWithBucket:@"test-bucket" appID:@"1253960454" regionName:nil];
    
    XCTAssertEqualObjects(result.absoluteString, @"https://ap-beijing.cos.myqcloud.com/test-bucket-1253960454");
}

/// 测试 HTTP 协议
- (void)testEndPoint_ServerURL_HTTP {
    QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.regionName = @"ap-beijing";
    endpoint.useHTTPS = NO;
    
    NSURL *result = [endpoint serverURLWithBucket:@"test-bucket" appID:@"1253960454" regionName:nil];
    
    XCTAssertTrue([result.absoluteString hasPrefix:@"http://"]);
}

/// 测试自定义 suffix (isPrefixURL = YES)
- (void)testEndPoint_ServerURL_Suffix_PrefixURL {
    QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.regionName = @"ap-beijing";
    endpoint.suffix = @"custom.suffix.com";
    endpoint.isPrefixURL = YES;
    
    NSURL *result = [endpoint serverURLWithBucket:@"test-bucket" appID:@"1253960454" regionName:nil];
    
    XCTAssertEqualObjects(result.absoluteString, @"https://test-bucket-1253960454.custom.suffix.com");
}

/// 测试自定义 suffix (isPrefixURL = NO)
- (void)testEndPoint_ServerURL_Suffix_NotPrefixURL {
    QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.regionName = @"ap-beijing";
    endpoint.suffix = @"custom.suffix.com";
    endpoint.isPrefixURL = NO;
    
    NSURL *result = [endpoint serverURLWithBucket:@"test-bucket" appID:@"1253960454" regionName:nil];
    
    XCTAssertEqualObjects(result.absoluteString, @"https://custom.suffix.com/test-bucket-1253960454");
}

/// 测试 bucket 已包含 appID 后缀
- (void)testEndPoint_ServerURL_BucketWithAppID {
    QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.regionName = @"ap-beijing";
    
    NSURL *result = [endpoint serverURLWithBucket:@"test-bucket-1253960454" appID:@"1253960454" regionName:nil];
    
    // 应该不会重复添加 appID
    XCTAssertEqualObjects(result.absoluteString, @"https://test-bucket-1253960454.cos.ap-beijing.myqcloud.com");
}

/// 测试使用参数中的 regionName 而非 endpoint 的 regionName
- (void)testEndPoint_ServerURL_ParameterRegion {
    QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.regionName = @"ap-beijing";
    
    NSURL *result = [endpoint serverURLWithBucket:@"test-bucket" appID:@"1253960454" regionName:@"ap-shanghai"];
    
    XCTAssertTrue([result.absoluteString containsString:@"ap-shanghai"]);
}

/// 测试无 appID 的情况
- (void)testEndPoint_ServerURL_NoAppID {
    QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.regionName = @"ap-beijing";
    
    NSURL *result = [endpoint serverURLWithBucket:@"test-bucket" appID:nil regionName:nil];
    
    XCTAssertEqualObjects(result.absoluteString, @"https://test-bucket.cos.ap-beijing.myqcloud.com");
}

/// 测试 copyWithZone
- (void)testEndPoint_Copy {
    QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.regionName = @"ap-beijing";
    endpoint.serviceName = @"custom.service.com";
    endpoint.isPrefixURL = NO;
    endpoint.suffix = @"test.suffix";
    endpoint.useHTTPS = NO;
    
    QCloudCOSXMLEndPoint *copied = [endpoint copy];
    
    XCTAssertEqualObjects(copied.regionName, @"ap-beijing");
    XCTAssertEqualObjects(copied.serviceName, @"custom.service.com");
    XCTAssertFalse(copied.isPrefixURL);
    XCTAssertEqualObjects(copied.suffix, @"test.suffix");
    XCTAssertFalse(copied.useHTTPS);
}

/// 测试非 myqcloud.com 的 serviceName 不校验 regionName
- (void)testEndPoint_CustomServiceName {
    QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.serviceName = @"tencentcos.cn";
    endpoint.regionName = @"ap-beijing";
    
    NSURL *result = [endpoint serverURLWithBucket:@"test-bucket" appID:@"1253960454" regionName:nil];
    
    XCTAssertTrue([result.absoluteString containsString:@"tencentcos.cn"]);
}

/// 测试非法 regionName (setRegionName: 断言校验)
- (void)testEndPoint_IllegalRegionName {
    QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    
    // 包含非法字符的 regionName，会触发 NSAssert
    XCTAssertThrows(endpoint.regionName = @"ap-beijing@#$", @"非法 regionName 应触发断言");
}

/// 测试非法 bucket 名称
- (void)testEndPoint_IllegalBucketName {
    QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.regionName = @"ap-beijing";
    
    // 包含非法字符的 bucket，会触发 NSAssert 并返回 nil
    XCTAssertThrows([endpoint serverURLWithBucket:@"test@bucket" appID:@"1253960454" regionName:nil], @"非法 bucket 应触发断言");
}

/// 测试 serverURLWithBucket 中参数 regionName 非法
- (void)testEndPoint_IllegalParameterRegionName {
    QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.regionName = @"ap-beijing";
    
    // 参数中传入非法 regionName，会触发 NSAssert
    XCTAssertThrows([endpoint serverURLWithBucket:@"test-bucket" appID:@"1253960454" regionName:@"ap-shanghai@#$"], @"非法参数 regionName 应触发断言");
}

/// 测试非 myqcloud.com 时不校验非法 regionName
- (void)testEndPoint_CustomServiceName_IllegalRegion {
    QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.serviceName = @"tencentcos.cn";
    
    // 非 myqcloud.com 时，setter 不校验 regionName
    endpoint.regionName = @"custom-region@test";
    
    // regionName 应该被设置成功
    XCTAssertEqualObjects(endpoint.regionName, @"custom-region@test");
}

#pragma mark - QCloudCOSXMLService+Configuration 测试

static NSString * const kServiceWithSignatureProvider = @"service_with_signature_provider";

/// 测试 loadAuthorizationForBiz 方法 - 无签名提供者时断言
- (void)testService_LoadAuthorization_NoProvider {
    // 注册一个没有 signatureProvider 的服务
    NSString *testKey = @"service_no_provider";
    if ([QCloudCOSXMLService hasCosxmlServiceForKey:testKey]) {
        [QCloudCOSXMLService removeCosxmlServiceWithKey:testKey];
    }
    
    QCloudServiceConfiguration *config = [QCloudServiceConfiguration new];
    config.appID = @"1253960454";
    QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.regionName = @"ap-beijing";
    config.endpoint = endpoint;
    // 不设置 signatureProvider
    
    QCloudCOSXMLService *service = [QCloudCOSXMLService registerCOSXMLWithConfiguration:config withKey:testKey];
    
    QCloudGetObjectRequest *request = [QCloudGetObjectRequest new];
    request.bucket = @"test-bucket-1253960454";
    request.object = @"test-object";
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://test.cos.ap-beijing.myqcloud.com/test"]];
    
    // 无 signatureProvider 时会触发断言
    XCTAssertThrows([service loadAuthorizationForBiz:request urlRequest:urlRequest compelete:^(QCloudSignature *signature, NSError *error) {
    }], @"无签名提供者应触发断言");
    
    [QCloudCOSXMLService removeCosxmlServiceWithKey:testKey];
}

/// 测试 loadAuthorizationForBiz 方法 - 有签名提供者
- (void)testService_LoadAuthorization_WithProvider {
    NSString *testKey = @"service_with_provider";
    if ([QCloudCOSXMLService hasCosxmlServiceForKey:testKey]) {
        [QCloudCOSXMLService removeCosxmlServiceWithKey:testKey];
    }
    
    QCloudServiceConfiguration *config = [QCloudServiceConfiguration new];
    config.appID = @"1253960454";
    QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.regionName = @"ap-beijing";
    config.endpoint = endpoint;
    
    // 使用 self 作为签名提供者（需要实现协议）
    config.signatureProvider = (id<QCloudSignatureProvider>)self;
    
    QCloudCOSXMLService *service = [QCloudCOSXMLService registerCOSXMLWithConfiguration:config withKey:testKey];
    
    QCloudGetObjectRequest *request = [QCloudGetObjectRequest new];
    request.bucket = @"test-bucket-1253960454";
    request.object = @"test-object";
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://test.cos.ap-beijing.myqcloud.com/test"]];
    
    XCTestExpectation *exp = [self expectationWithDescription:@"loadAuthorization"];
    
    [service loadAuthorizationForBiz:request urlRequest:urlRequest compelete:^(QCloudSignature *signature, NSError *error) {
        // 验证回调被调用
        XCTAssertNotNil(signature);
        [exp fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5 handler:nil];
    
    [QCloudCOSXMLService removeCosxmlServiceWithKey:testKey];
}

#pragma mark - QCloudSignatureProvider

- (void)signatureWithFields:(QCloudSignatureFields *)fileds
                    request:(QCloudBizHTTPRequest *)request
                 urlRequest:(NSMutableURLRequest *)urlRequst
                  compelete:(QCloudHTTPAuthentationContinueBlock)continueBlock {
    // 模拟签名
    QCloudSignature *signature = [[QCloudSignature alloc] initWithSignature:@"mock-signature" expiration:nil];
    continueBlock(signature, nil);
}

#pragma mark - QCloudCOSStorageClassEnum 测试

/// 测试 QCloudCOSStorageClassDumpFromString - 所有有效值
- (void)testStorageClass_DumpFromString_AllValid {
    XCTAssertEqual(QCloudCOSStorageClassDumpFromString(@"STANDARD"), QCloudCOSStorageStandard);
    XCTAssertEqual(QCloudCOSStorageClassDumpFromString(@"STANDARD_IA"), QCloudCOSStorageStandardIA);
    XCTAssertEqual(QCloudCOSStorageClassDumpFromString(@"ARCHIVE"), QCloudCOSStorageARCHIVE);
    XCTAssertEqual(QCloudCOSStorageClassDumpFromString(@"MAZ_STANDARD"), QCloudCOSStorageMAZ_Standard);
    XCTAssertEqual(QCloudCOSStorageClassDumpFromString(@"MAZ_STANDARD_IA"), QCloudCOSStorageMAZ_StandardIA);
    XCTAssertEqual(QCloudCOSStorageClassDumpFromString(@"INTELLIGENT_TIERING"), QCloudCOSStorageINTELLIGENT_TIERING);
    XCTAssertEqual(QCloudCOSStorageClassDumpFromString(@"MAZ_INTELLIGENT_TIERING"), QCloudCOSStorageMAZ_INTELLIGENT_TIERING);
    XCTAssertEqual(QCloudCOSStorageClassDumpFromString(@"DEEP_ARCHIVE"), QCloudCOSStorageDEEP_ARCHIVE);
    XCTAssertEqual(QCloudCOSStorageClassDumpFromString(@"COLD"), QCloudCOSStorageCOLD);
    XCTAssertEqual(QCloudCOSStorageClassDumpFromString(@"MAZ_COLD"), QCloudCOSStorageMAZ_COLD);
}

/// 测试 QCloudCOSStorageClassDumpFromString - 无效值返回 0
- (void)testStorageClass_DumpFromString_Invalid {
    XCTAssertEqual(QCloudCOSStorageClassDumpFromString(@"INVALID"), 0);
    XCTAssertEqual(QCloudCOSStorageClassDumpFromString(@""), 0);
    XCTAssertEqual(QCloudCOSStorageClassDumpFromString(@"standard"), 0);  // 大小写敏感
}

/// 测试 QCloudCOSStorageClassTransferToString - 所有有效值
- (void)testStorageClass_TransferToString_AllValid {
    XCTAssertEqualObjects(QCloudCOSStorageClassTransferToString(QCloudCOSStorageStandard), @"STANDARD");
    XCTAssertEqualObjects(QCloudCOSStorageClassTransferToString(QCloudCOSStorageStandardIA), @"STANDARD_IA");
    XCTAssertEqualObjects(QCloudCOSStorageClassTransferToString(QCloudCOSStorageARCHIVE), @"ARCHIVE");
    XCTAssertEqualObjects(QCloudCOSStorageClassTransferToString(QCloudCOSStorageMAZ_Standard), @"MAZ_STANDARD");
    XCTAssertEqualObjects(QCloudCOSStorageClassTransferToString(QCloudCOSStorageMAZ_StandardIA), @"MAZ_STANDARD_IA");
    XCTAssertEqualObjects(QCloudCOSStorageClassTransferToString(QCloudCOSStorageINTELLIGENT_TIERING), @"INTELLIGENT_TIERING");
    XCTAssertEqualObjects(QCloudCOSStorageClassTransferToString(QCloudCOSStorageMAZ_INTELLIGENT_TIERING), @"MAZ_INTELLIGENT_TIERING");
    XCTAssertEqualObjects(QCloudCOSStorageClassTransferToString(QCloudCOSStorageDEEP_ARCHIVE), @"DEEP_ARCHIVE");
    XCTAssertEqualObjects(QCloudCOSStorageClassTransferToString(QCloudCOSStorageCOLD), @"COLD");
    XCTAssertEqualObjects(QCloudCOSStorageClassTransferToString(QCloudCOSStorageMAZ_COLD), @"MAZ_COLD");
}

/// 测试 QCloudCOSStorageClassTransferToString - 无效枚举值返回 nil
- (void)testStorageClass_TransferToString_Invalid {
    XCTAssertNil(QCloudCOSStorageClassTransferToString((QCloudCOSStorageClass)999));
    XCTAssertNil(QCloudCOSStorageClassTransferToString((QCloudCOSStorageClass)-1));
}

/// 测试双向转换一致性
- (void)testStorageClass_RoundTrip {
    NSArray *allStrings = @[@"STANDARD", @"STANDARD_IA", @"ARCHIVE", @"MAZ_STANDARD", 
                            @"MAZ_STANDARD_IA", @"INTELLIGENT_TIERING", @"MAZ_INTELLIGENT_TIERING",
                            @"DEEP_ARCHIVE", @"COLD", @"MAZ_COLD"];
    
    for (NSString *str in allStrings) {
        QCloudCOSStorageClass enumValue = QCloudCOSStorageClassDumpFromString(str);
        NSString *backToString = QCloudCOSStorageClassTransferToString(enumValue);
        XCTAssertEqualObjects(backToString, str, @"Round trip failed for %@", str);
    }
}

#pragma mark - QCloudLogManager 测试

#if TARGET_OS_IOS
/// 测试 QCloudLogManager 单例
- (void)testLogManager_SharedInstance {
    QCloudLogManager *manager1 = [QCloudLogManager sharedInstance];
    QCloudLogManager *manager2 = [QCloudLogManager sharedInstance];
    
    XCTAssertNotNil(manager1);
    XCTAssertEqual(manager1, manager2);
}

/// 测试 shouldShowLog 属性
- (void)testLogManager_ShouldShowLog {
    QCloudLogManager *manager = [QCloudLogManager sharedInstance];
    
    // 默认值
    BOOL defaultValue = manager.shouldShowLog;
    
    // 设置为 YES
    manager.shouldShowLog = YES;
    XCTAssertTrue(manager.shouldShowLog);
    
    // 设置为 NO
    manager.shouldShowLog = NO;
    XCTAssertFalse(manager.shouldShowLog);
    
    // 恢复默认值
    manager.shouldShowLog = defaultValue;
}

/// 测试 currentLogs 方法
- (void)testLogManager_CurrentLogs {
    QCloudLogManager *manager = [QCloudLogManager sharedInstance];
    
    NSArray *logs = [manager currentLogs];
    
    // currentLogs 返回数组（可能为空或有内容）
    XCTAssertTrue(logs == nil || [logs isKindOfClass:[NSArray class]]);
}

/// 测试 readLog 方法 - 存在的日志文件
- (void)testLogManager_ReadLog_Exist {
    QCloudLogManager *manager = [QCloudLogManager sharedInstance];
    
    // 获取当前日志列表
    NSArray *logs = [manager currentLogs];
    
    if (logs.count > 0) {
        // 如果有日志文件，读取第一个
        NSString *logPath = [[QCloudLogger sharedLogger].logDirctoryPath stringByAppendingPathComponent:logs.firstObject];
        NSString *content = [manager readLog:logPath];
        
        // 应该能读取到内容（可能为空字符串）
        XCTAssertTrue(content == nil || [content isKindOfClass:[NSString class]]);
    }
}

/// 测试 QCloudLogTableViewController 初始化
- (void)testLogTableViewController_Init {
    NSArray *mockLogs = @[@"log1.txt", @"log2.txt"];
    QCloudLogTableViewController *vc = [[QCloudLogTableViewController alloc] initWithLog:mockLogs];
    
    XCTAssertNotNil(vc);
}
#endif

#pragma mark - QCloudGetServiceRequest+Custom 测试

static NSString * const kServiceCustomMyqcloud = @"service_custom_myqcloud";
static NSString * const kServiceCustomTencentcos = @"service_custom_tencentcos";
static NSString * const kServiceCustomTencentcosWithRegion = @"service_custom_tencentcos_region";
static NSString * const kServiceCustomHTTP = @"service_custom_http";

/// 测试默认 myqcloud.com 服务名 - HTTPS
- (void)testGetServiceRequest_Custom_DefaultMyqcloud_HTTPS {
    NSString *testKey = kServiceCustomMyqcloud;
    if ([QCloudCOSXMLService hasCosxmlServiceForKey:testKey]) {
        [QCloudCOSXMLService removeCosxmlServiceWithKey:testKey];
    }
    
    QCloudServiceConfiguration *config = [QCloudServiceConfiguration new];
    config.appID = @"1253960454";
    QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.regionName = @"ap-beijing";
    endpoint.useHTTPS = YES;
    // serviceName 默认为 myqcloud.com
    config.endpoint = endpoint;
    config.signatureProvider = (id<QCloudSignatureProvider>)self;
    
    QCloudCOSXMLService *service = [QCloudCOSXMLService registerCOSXMLWithConfiguration:config withKey:testKey];
    
    QCloudGetServiceRequest *request = [QCloudGetServiceRequest new];
    request.runOnService = service;
    
    NSError *error = nil;
    BOOL result = [request customBuildRequestData:&error];
    
    XCTAssertTrue(result);
    XCTAssertNil(error);
    // 默认 myqcloud.com 应该使用 service.cos.myqcloud.com
    XCTAssertEqualObjects(request.requestData.serverURL, @"https://service.cos.myqcloud.com");
    
    [QCloudCOSXMLService removeCosxmlServiceWithKey:testKey];
}

/// 测试默认 myqcloud.com 服务名 - HTTP
- (void)testGetServiceRequest_Custom_DefaultMyqcloud_HTTP {
    NSString *testKey = kServiceCustomHTTP;
    if ([QCloudCOSXMLService hasCosxmlServiceForKey:testKey]) {
        [QCloudCOSXMLService removeCosxmlServiceWithKey:testKey];
    }
    
    QCloudServiceConfiguration *config = [QCloudServiceConfiguration new];
    config.appID = @"1253960454";
    QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.regionName = @"ap-beijing";
    endpoint.useHTTPS = NO;  // 使用 HTTP
    config.endpoint = endpoint;
    config.signatureProvider = (id<QCloudSignatureProvider>)self;
    
    QCloudCOSXMLService *service = [QCloudCOSXMLService registerCOSXMLWithConfiguration:config withKey:testKey];
    
    QCloudGetServiceRequest *request = [QCloudGetServiceRequest new];
    request.runOnService = service;
    
    NSError *error = nil;
    BOOL result = [request customBuildRequestData:&error];
    
    XCTAssertTrue(result);
    XCTAssertNil(error);
    // HTTP 协议
    XCTAssertEqualObjects(request.requestData.serverURL, @"http://service.cos.myqcloud.com");
    
    [QCloudCOSXMLService removeCosxmlServiceWithKey:testKey];
}

/// 测试自定义 serviceName (非 myqcloud.com) + 有 regionName
- (void)testGetServiceRequest_Custom_TencentcosWithRegion {
    NSString *testKey = kServiceCustomTencentcosWithRegion;
    if ([QCloudCOSXMLService hasCosxmlServiceForKey:testKey]) {
        [QCloudCOSXMLService removeCosxmlServiceWithKey:testKey];
    }
    
    QCloudServiceConfiguration *config = [QCloudServiceConfiguration new];
    config.appID = @"1253960454";
    QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.serviceName = @"tencentcos.cn";  // 非 myqcloud.com
    endpoint.regionName = @"ap-beijing";
    endpoint.useHTTPS = YES;
    config.endpoint = endpoint;
    config.signatureProvider = (id<QCloudSignatureProvider>)self;
    
    QCloudCOSXMLService *service = [QCloudCOSXMLService registerCOSXMLWithConfiguration:config withKey:testKey];
    
    QCloudGetServiceRequest *request = [QCloudGetServiceRequest new];
    request.runOnService = service;
    
    NSError *error = nil;
    BOOL result = [request customBuildRequestData:&error];
    
    XCTAssertTrue(result);
    XCTAssertNil(error);
    // 非 myqcloud.com + 有 regionName: service.cos.{region}.{serviceName}
    XCTAssertEqualObjects(request.requestData.serverURL, @"https://service.cos.ap-beijing.tencentcos.cn");
    
    [QCloudCOSXMLService removeCosxmlServiceWithKey:testKey];
}

/// 测试自定义 serviceName (非 myqcloud.com) + 无 regionName
- (void)testGetServiceRequest_Custom_TencentcosWithoutRegion {
    NSString *testKey = kServiceCustomTencentcos;
    if ([QCloudCOSXMLService hasCosxmlServiceForKey:testKey]) {
        [QCloudCOSXMLService removeCosxmlServiceWithKey:testKey];
    }
    
    QCloudServiceConfiguration *config = [QCloudServiceConfiguration new];
    config.appID = @"1253960454";
    QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.serviceName = @"tencentcos.cn";  // 非 myqcloud.com
    // 不设置 regionName
    endpoint.useHTTPS = YES;
    config.endpoint = endpoint;
    config.signatureProvider = (id<QCloudSignatureProvider>)self;
    
    QCloudCOSXMLService *service = [QCloudCOSXMLService registerCOSXMLWithConfiguration:config withKey:testKey];
    
    QCloudGetServiceRequest *request = [QCloudGetServiceRequest new];
    request.runOnService = service;
    
    NSError *error = nil;
    BOOL result = [request customBuildRequestData:&error];
    
    XCTAssertTrue(result);
    XCTAssertNil(error);
    // 非 myqcloud.com + 无 regionName: service.cos.{serviceName}
    XCTAssertEqualObjects(request.requestData.serverURL, @"https://service.cos.tencentcos.cn");
    
    [QCloudCOSXMLService removeCosxmlServiceWithKey:testKey];
}

/// 测试自定义 serviceName + HTTP 协议
- (void)testGetServiceRequest_Custom_TencentcosHTTP {
    NSString *testKey = @"service_custom_tencentcos_http";
    if ([QCloudCOSXMLService hasCosxmlServiceForKey:testKey]) {
        [QCloudCOSXMLService removeCosxmlServiceWithKey:testKey];
    }
    
    QCloudServiceConfiguration *config = [QCloudServiceConfiguration new];
    config.appID = @"1253960454";
    QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.serviceName = @"tencentcos.cn";
    endpoint.regionName = @"ap-shanghai";
    endpoint.useHTTPS = NO;  // HTTP
    config.endpoint = endpoint;
    config.signatureProvider = (id<QCloudSignatureProvider>)self;
    
    QCloudCOSXMLService *service = [QCloudCOSXMLService registerCOSXMLWithConfiguration:config withKey:testKey];
    
    QCloudGetServiceRequest *request = [QCloudGetServiceRequest new];
    request.runOnService = service;
    
    NSError *error = nil;
    BOOL result = [request customBuildRequestData:&error];
    
    XCTAssertTrue(result);
    XCTAssertNil(error);
    // HTTP + 非 myqcloud.com + 有 regionName
    XCTAssertEqualObjects(request.requestData.serverURL, @"http://service.cos.ap-shanghai.tencentcos.cn");
    
    [QCloudCOSXMLService removeCosxmlServiceWithKey:testKey];
}

@end
