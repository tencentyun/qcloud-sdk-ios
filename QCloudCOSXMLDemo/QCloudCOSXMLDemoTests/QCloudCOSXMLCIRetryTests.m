//
//  QCloudCOSXMLCIRetryTests.m
//  QCloudCOSXMLDemoTests
//
//  Created by 摩卡 on 2025/12/10.
//  Copyright © 2025 Tencent. All rights reserved.
//
//  CI 域名切换测试用例
//
//  测试规则说明：
//  | 状态码 | 有 x-ci-request-id | 是否切换域名 | 是否重试 |
//  |--------|-------------------|--------------|----------|
//  | 2xx    | 是                | 否           | 否       |
//  | 3xx    | 是                | 否           | 否       |
//  | 3xx    | 否                | 是           | 是       |
//  | 4xx    | 是/否             | 否           | 否       |
//  | 5xx    | 是                | 否           | 是       |
//  | 5xx    | 否                | 是           | 是       |
//  | timeout/shutdown | -       | 是           | 是       |
//
//  域名切换规则：
//  - CI 主域名：*.ci.{region}.myqcloud.com
//  - CI 备用域名：*.ci.{region}.tencentci.cn
//  - 切换条件：响应不含 x-ci-request-id 且满足重试条件
//

#import <XCTest/XCTest.h>
#import "QCloudCOSXML.h"
#import "SecretStorage.h"
#import "QCloudCOSXMLEndPoint.h"
#import "QCloudDescribeDatasetRequest.h"
#import "QCloudCOSXMLService+MateData.h"

#pragma mark - QCloudDescribeDatasetRequest 子类（用于测试）

@interface QCloudDescribeDatasetTestRequest : QCloudDescribeDatasetRequest
@end

@implementation QCloudDescribeDatasetTestRequest

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    
    // 添加 x-ci-code 请求头，用于测试服务器识别返回对应的状态码
    if (self.datasetname) {
        [self.requestData setValue:self.datasetname forHTTPHeaderField:@"x-ci-code"];
    }
    
    return YES;
}

@end

#pragma mark - 测试类

@interface QCloudCOSXMLCIRetryTests : XCTestCase <QCloudSignatureProvider>
@property (nonatomic, strong) NSString *appID;
@end

@implementation QCloudCOSXMLCIRetryTests

#pragma mark - 签名

- (void)signatureWithFields:(QCloudSignatureFields *)fileds
                    request:(QCloudBizHTTPRequest *)request
                 urlRequest:(NSMutableURLRequest *)urlRequst
                  compelete:(QCloudHTTPAuthentationContinueBlock)continueBlock {
    QCloudCredential *credential = [QCloudCredential new];
    credential.secretID = [SecretStorage sharedInstance].secretID;
    credential.secretKey = [SecretStorage sharedInstance].secretKey;
    QCloudAuthentationV5Creator *creator = [[QCloudAuthentationV5Creator alloc] initWithCredential:credential];
    QCloudSignature *signature = [creator signatureForData:urlRequst];
    continueBlock(signature, nil);
}

#pragma mark - 服务初始化

- (void)setupCIRetryService {
    // CI 域名切换开启的 Service
    if (![QCloudCOSXMLService hasCosxmlServiceForKey:@"ci_sdk_retry"]) {
        QCloudServiceConfiguration *configuration = [QCloudServiceConfiguration new];
        configuration.appID = self.appID;
        configuration.signatureProvider = self;
        QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
        endpoint.useHTTPS = NO;
        endpoint.regionName = @"ap-beijing";
        configuration.endpoint = endpoint;

        [QCloudCOSXMLService registerCOSXMLWithConfiguration:configuration withKey:@"ci_sdk_retry"];
    }
    
    // CI 域名切换关闭的 Service
    if (![QCloudCOSXMLService hasCosxmlServiceForKey:@"ci_sdk_retry_disable"]) {
        QCloudServiceConfiguration *configuration = [QCloudServiceConfiguration new];
        configuration.appID = self.appID;
        configuration.signatureProvider = self;
        QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
        endpoint.useHTTPS = NO;
        endpoint.regionName = @"ap-beijing";
        configuration.endpoint = endpoint;
        configuration.disableChangeHost = YES;

        [QCloudCOSXMLService registerCOSXMLWithConfiguration:configuration withKey:@"ci_sdk_retry_disable"];
    }
}

- (void)setUp {
    [super setUp];
    self.appID = @"1253960454";
    [self setupCIRetryService];
}

#pragma mark - 请求创建

- (QCloudDescribeDatasetTestRequest *)createDescribeDatasetRequestWithKey:(NSString *)key {
    QCloudDescribeDatasetTestRequest *request = [QCloudDescribeDatasetTestRequest new];
    request.regionName = @"ap-beijing";
    request.datasetname = key;
    request.timeoutInterval = 10;
    return request;
}

#pragma mark - 域名切换开启测试

/// 2xx 有 x-ci-request-id - 不切换域名，不重试
- (void)testCI_2xx {
    NSArray *array = @[@"200r", @"200", @"204r", @"204", @"206r", @"206"];
    XCTestExpectation *exp = [self expectationWithDescription:@"CI 2xx 测试"];
    __block int count = 0;
    for (NSString *key in array) {
        QCloudDescribeDatasetRequest *request = [self createDescribeDatasetRequestWithKey:key];
        [request setFinishBlock:^(QCloudDescribeDatasetResponse *outputObject, NSError *error) {
            NSHTTPURLResponse *response = error ? [error __originHTTPURLResponse__] : [outputObject __originHTTPURLResponse__];
            if (!response) return;
            XCTAssertTrue(request.retryCount == 0, @"2xx 不应重试, key=%@", key);
            XCTAssertTrue([response.URL.host containsString:@"myqcloud"], @"2xx 不应切换域名, key=%@", key);
            @synchronized (self) {
                count++;
                if (count == array.count) {
                    [exp fulfill];
                }
            }
        }];
        [[QCloudCOSXMLService cosxmlServiceForKey:@"ci_sdk_retry"] DescribeDataset:request];
    }
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

/// 3xx 测试 - 有 requestId 不切换，无 requestId 切换
- (void)testCI_3xx {
    NSArray *array = @[@"301r", @"301", @"302r", @"302", @"307r", @"307"];
    XCTestExpectation *exp = [self expectationWithDescription:@"CI 3xx 测试"];
    __block int count = 0;
    for (NSString *key in array) {
        QCloudDescribeDatasetRequest *request = [self createDescribeDatasetRequestWithKey:key];
        [request setFinishBlock:^(QCloudDescribeDatasetResponse *outputObject, NSError *error) {
            NSHTTPURLResponse *response = error ? [error __originHTTPURLResponse__] : [outputObject __originHTTPURLResponse__];
            if (!response) return;
            if ([key containsString:@"r"]) {
                XCTAssertTrue(request.retryCount == 0, @"3xx 有 requestId 不应重试, key=%@", key);
                XCTAssertTrue([response.URL.host containsString:@"myqcloud"], @"3xx 有 requestId 不应切换域名, key=%@", key);
            } else {
                XCTAssertTrue(request.retryCount > 0, @"3xx 无 requestId 应重试, key=%@", key);
                XCTAssertTrue(![response.URL.host containsString:@"myqcloud"], @"3xx 无 requestId 应切换域名, key=%@", key);
            }
            @synchronized (self) {
                count++;
                if (count == array.count) {
                    [exp fulfill];
                }
            }
        }];
        [[QCloudCOSXMLService cosxmlServiceForKey:@"ci_sdk_retry"] DescribeDataset:request];
    }
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

/// 4xx - 不切换域名，不重试（无论是否有 requestId）
- (void)testCI_4xx {
    NSArray *array = @[@"400r", @"400", @"403r", @"403", @"404r", @"404", @"405r", @"405", @"409r", @"409"];
    XCTestExpectation *exp = [self expectationWithDescription:@"CI 4xx 测试"];
    __block int count = 0;
    for (NSString *key in array) {
        QCloudDescribeDatasetRequest *request = [self createDescribeDatasetRequestWithKey:key];
        [request setFinishBlock:^(QCloudDescribeDatasetResponse *outputObject, NSError *error) {
            NSHTTPURLResponse *response = error ? [error __originHTTPURLResponse__] : [outputObject __originHTTPURLResponse__];
            if (!response) return;
            XCTAssertTrue(request.retryCount == 0, @"4xx 不应重试, key=%@", key);
            XCTAssertTrue([response.URL.host containsString:@"myqcloud"], @"4xx 不应切换域名, key=%@", key);
            @synchronized (self) {
                count++;
                if (count == array.count) {
                    [exp fulfill];
                }
            }
        }];
        [[QCloudCOSXMLService cosxmlServiceForKey:@"ci_sdk_retry"] DescribeDataset:request];
    }
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

/// 5xx 测试 - 有 requestId 不切换但重试，无 requestId 切换并重试
- (void)testCI_5xx {
    NSArray *array = @[@"500r", @"500", @"502r", @"502", @"503r", @"503", @"504r", @"504"];
    XCTestExpectation *exp = [self expectationWithDescription:@"CI 5xx 测试"];
    __block int count = 0;
    for (NSString *key in array) {
        QCloudDescribeDatasetRequest *request = [self createDescribeDatasetRequestWithKey:key];
        [request setFinishBlock:^(QCloudDescribeDatasetResponse *outputObject, NSError *error) {
            NSHTTPURLResponse *response = error ? [error __originHTTPURLResponse__] : [outputObject __originHTTPURLResponse__];
            if (!response) return;
            XCTAssertTrue(request.retryCount == 3, @"5xx 应重试, key=%@", key);
            if ([key containsString:@"r"]) {
                XCTAssertTrue([response.URL.host containsString:@"myqcloud"], @"5xx 有 requestId 不应切换域名, key=%@", key);
            } else {
                XCTAssertTrue(![response.URL.host containsString:@"myqcloud"], @"5xx 无 requestId 应切换域名, key=%@", key);
            }
            @synchronized (self) {
                count++;
                if (count == array.count) {
                    [exp fulfill];
                }
            }
        }];
        [[QCloudCOSXMLService cosxmlServiceForKey:@"ci_sdk_retry"] DescribeDataset:request];
    }
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

/// timeout/shutdown - 切换域名，重试
- (void)testCI_TimeoutAndShutdown {
    NSArray *array = @[@"timeout", @"shutdown"];
    XCTestExpectation *exp = [self expectationWithDescription:@"CI timeout/shutdown"];
    __block int count = 0;
    for (NSString *key in array) {
        QCloudDescribeDatasetRequest *request = [self createDescribeDatasetRequestWithKey:key];
        request.timeoutInterval = 10;
        [request setFinishBlock:^(QCloudDescribeDatasetResponse *outputObject, NSError *error) {
            NSHTTPURLResponse *response = error ? [error __originHTTPURLResponse__] : [outputObject __originHTTPURLResponse__];
            // 超时场景从 error.userInfo 中获取失败的 URL
            NSString *host = nil;
            if (error) {
                host = error.domain;
            } else {
                NSHTTPURLResponse *response = [outputObject __originHTTPURLResponse__];
                host = response.URL.host;
            }
            if (!host) return;
            XCTAssertTrue(request.retryCount == 3, @"timeout/shutdown 应重试, key=%@", key);
            XCTAssertTrue(![response.URL.host containsString:@"myqcloud"], @"timeout/shutdown 应切换域名, key=%@", key);
            @synchronized (self) {
                count++;
                if (count == array.count) {
                    [exp fulfill];
                }
            }
        }];
        [[QCloudCOSXMLService cosxmlServiceForKey:@"ci_sdk_retry"] DescribeDataset:request];
    }
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

#pragma mark - 域名切换关闭测试（disableChangeHost = YES）

/// 2xx 禁用域名切换 - 不切换域名，不重试
- (void)testCI_2xx_DisableChangeHost {
    NSArray *array = @[@"200r", @"200", @"204r", @"204", @"206r", @"206"];
    XCTestExpectation *exp = [self expectationWithDescription:@"CI 2xx 禁用域名切换"];
    __block int count = 0;
    for (NSString *key in array) {
        QCloudDescribeDatasetRequest *request = [self createDescribeDatasetRequestWithKey:key];
        [request setFinishBlock:^(QCloudDescribeDatasetResponse *outputObject, NSError *error) {
            NSHTTPURLResponse *response = error ? [error __originHTTPURLResponse__] : [outputObject __originHTTPURLResponse__];
            if (!response) return;
            XCTAssertTrue(request.retryCount == 0, @"2xx 不应重试, key=%@", key);
            XCTAssertTrue([response.URL.host containsString:@"myqcloud"], @"禁用域名切换时不应切换域名, key=%@", key);
            @synchronized (self) {
                count++;
                if (count == array.count) {
                    [exp fulfill];
                }
            }
        }];
        [[QCloudCOSXMLService cosxmlServiceForKey:@"ci_sdk_retry_disable"] DescribeDataset:request];
    }
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

/// 3xx 禁用域名切换 - 不切换域名，不重试
- (void)testCI_3xx_DisableChangeHost {
    NSArray *array = @[@"301r", @"301", @"302r", @"302", @"307r", @"307", @"308r", @"308"];
    XCTestExpectation *exp = [self expectationWithDescription:@"CI 3xx 禁用域名切换"];
    __block int count = 0;
    for (NSString *key in array) {
        QCloudDescribeDatasetRequest *request = [self createDescribeDatasetRequestWithKey:key];
        [request setFinishBlock:^(QCloudDescribeDatasetResponse *outputObject, NSError *error) {
            NSHTTPURLResponse *response = error ? [error __originHTTPURLResponse__] : [outputObject __originHTTPURLResponse__];
            if (!response) return;
            XCTAssertTrue(request.retryCount == 0, @"禁用域名切换时 3xx 不应重试, key=%@", key);
            XCTAssertTrue([response.URL.host containsString:@"myqcloud"], @"禁用域名切换时不应切换域名, key=%@", key);
            @synchronized (self) {
                count++;
                if (count == array.count) {
                    [exp fulfill];
                }
            }
        }];
        [[QCloudCOSXMLService cosxmlServiceForKey:@"ci_sdk_retry_disable"] DescribeDataset:request];
    }
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

/// 4xx 禁用域名切换 - 不切换域名，不重试
- (void)testCI_4xx_DisableChangeHost {
    NSArray *array = @[@"400r", @"400", @"403r", @"403", @"404r", @"404"];
    XCTestExpectation *exp = [self expectationWithDescription:@"CI 4xx 禁用域名切换"];
    __block int count = 0;
    for (NSString *key in array) {
        QCloudDescribeDatasetRequest *request = [self createDescribeDatasetRequestWithKey:key];
        [request setFinishBlock:^(QCloudDescribeDatasetResponse *outputObject, NSError *error) {
            NSHTTPURLResponse *response = error ? [error __originHTTPURLResponse__] : [outputObject __originHTTPURLResponse__];
            if (!response) return;
            XCTAssertTrue(request.retryCount == 0, @"4xx 不应重试, key=%@", key);
            XCTAssertTrue([response.URL.host containsString:@"myqcloud"], @"禁用域名切换时不应切换域名, key=%@", key);
            @synchronized (self) {
                count++;
                if (count == array.count) {
                    [exp fulfill];
                }
            }
        }];
        [[QCloudCOSXMLService cosxmlServiceForKey:@"ci_sdk_retry_disable"] DescribeDataset:request];
    }
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

/// 5xx 禁用域名切换 - 不切换域名，重试
- (void)testCI_5xx_DisableChangeHost {
    NSArray *array = @[@"500r", @"500", @"503r", @"503", @"504r", @"504"];
    XCTestExpectation *exp = [self expectationWithDescription:@"CI 5xx 禁用域名切换"];
    __block int count = 0;
    for (NSString *key in array) {
        QCloudDescribeDatasetRequest *request = [self createDescribeDatasetRequestWithKey:key];
        [request setFinishBlock:^(QCloudDescribeDatasetResponse *outputObject, NSError *error) {
            NSHTTPURLResponse *response = error ? [error __originHTTPURLResponse__] : [outputObject __originHTTPURLResponse__];
            if (!response) return;
            XCTAssertTrue(request.retryCount == 3, @"5xx 应重试, key=%@", key);
            XCTAssertTrue([response.URL.host containsString:@"myqcloud"], @"禁用域名切换时不应切换域名, key=%@", key);
            @synchronized (self) {
                count++;
                if (count == array.count) {
                    [exp fulfill];
                }
            }
        }];
        [[QCloudCOSXMLService cosxmlServiceForKey:@"ci_sdk_retry_disable"] DescribeDataset:request];
    }
    [self waitForExpectationsWithTimeout:240 handler:nil];
}

/// timeout/shutdown 禁用域名切换 - 不切换域名，重试
- (void)testCI_TimeoutAndShutdown_DisableChangeHost {
    NSArray *array = @[@"timeout", @"shutdown"];
    XCTestExpectation *exp = [self expectationWithDescription:@"CI timeout/shutdown 禁用域名切换"];
    __block int count = 0;
    for (NSString *key in array) {
        QCloudDescribeDatasetRequest *request = [self createDescribeDatasetRequestWithKey:key];
        [request setFinishBlock:^(QCloudDescribeDatasetResponse *outputObject, NSError *error) {
            // 超时场景从 error.userInfo 中获取失败的 URL
            NSString *host = nil;
            if (error) {
                host = error.domain;
            } else {
                NSHTTPURLResponse *response = [outputObject __originHTTPURLResponse__];
                host = response.URL.host;
            }
            if (!host) return;
            XCTAssertTrue(request.retryCount == 3, @"timeout/shutdown 应重试, key=%@", key);
            XCTAssertTrue([host containsString:@"myqcloud"], @"禁用域名切换时不应切换域名, key=%@", key);
            @synchronized (self) {
                count++;
                if (count == array.count) {
                    [exp fulfill];
                }
            }
        }];
        [[QCloudCOSXMLService cosxmlServiceForKey:@"ci_sdk_retry_disable"] DescribeDataset:request];
    }
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

@end
