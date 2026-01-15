//
//  QCloudCOSXMLRetryTests.m
//  QCloudCOSXMLDemoTests
//
//  Created by garenwang on 2020/6/8.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "QCloudCOSXML.h"
#import "TestCommonDefine.h"
#import "QCloudTestTempVariables.h"
#import "QCloudCOSXMLTestUtility.h"
#import "QCloudCOSXMLService+MateData.h"
#import "SecretStorage.h"
#import "QCloudCOSXMLEndPoint.h"
#define kCOSImageBucketKey @"imgBucket"
#import "QCloudBucket.h"
#import "QCloudHTTPRetryHanlder.h"

@interface QCloudCOSXMLRetryTests : XCTestCase <QCloudSignatureProvider>
@property (nonatomic, strong) NSString *appID;
@property (nonatomic, strong) NSString *ownerID;
@property (nonatomic, strong) NSString *authorizedUIN;
@property (nonatomic, strong) NSString *ownerUIN;
@property (nonatomic, strong) NSMutableArray *tempFilePathArray;
@end
static QCloudBucket *imageTestBucket;
@implementation QCloudCOSXMLRetryTests

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

- (void)setupSpecialCOSXMLShareService {
    if ([QCloudCOSXMLService hasCosxmlServiceForKey:@"cos_sdk_retry"]) {
        return;
    }
    QCloudServiceConfiguration *configuration = [QCloudServiceConfiguration new];
    configuration.appID = self.appID;
    configuration.signatureProvider = self;
    QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.useHTTPS = NO;
    endpoint.regionName = @"ap-chengdu";
    configuration.endpoint = endpoint;

    [QCloudCOSXMLService registerCOSXMLWithConfiguration:configuration withKey:@"cos_sdk_retry"];
    [QCloudCOSTransferMangerService registerCOSTransferMangerWithConfiguration:configuration withKey:@"cos_sdk_retry"];
    
    if ([QCloudCOSXMLService hasCosxmlServiceForKey:@"cos_sdk_retry_disable"]) {
        return;
    }
    QCloudServiceConfiguration *configuration1 = [QCloudServiceConfiguration new];
    configuration1.appID = self.appID;
    configuration1.signatureProvider = self;
    QCloudCOSXMLEndPoint *endpoint1 = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint1.useHTTPS = NO;
    endpoint1.regionName = @"ap-chengdu";
    configuration1.endpoint = endpoint1;
    configuration1.disableChangeHost = YES;

    [QCloudCOSXMLService registerCOSXMLWithConfiguration:configuration1 withKey:@"cos_sdk_retry_disable"];
    [QCloudCOSTransferMangerService registerCOSTransferMangerWithConfiguration:configuration1 withKey:@"cos_sdk_retry_disable"];
}

+ (void)setUp {
    imageTestBucket = [QCloudBucket new];
    imageTestBucket.name = @"cos-sdk-err-retry-1253960454";
}

+ (void)tearDown {
}

- (void)setUp {
    [super setUp];
    [self setupSpecialCOSXMLShareService];

    self.appID = @"1253960454";
    self.ownerID = @"1278687956";
    self.authorizedUIN = @"1131975903";
    self.ownerUIN = @"1278687956";
    self.tempFilePathArray = [NSMutableArray array];
}

#pragma mark - 2xx Success Cases

// 200 OK - 正常下载
- (void)test200 {
    NSArray * array = @[@"200r",@"200",@"204r",@"204",@"206r",@"206"];
    XCTestExpectation *exp = [self expectationWithDescription:@"200成功响应"];
    __block int count = 0;
    for (NSString * key in array) {
        QCloudGetObjectRequest *request = [QCloudGetObjectRequest new];
        request.object = key;
        request.bucket = imageTestBucket.name;
        [request setFinishBlock:^(id outputObject, NSError *error) {
            XCTAssertTrue(request.retryCount == 0);
            NSHTTPURLResponse * response = [outputObject __originHTTPURLResponse__];
            XCTAssertTrue([response.URL.host containsString:@"myqcloud"]);
            @synchronized (self) {
                count ++;
                if (count == array.count) {
                    [exp fulfill];
                }
            }
        }];
        [[QCloudCOSXMLService cosxmlServiceForKey:@"cos_sdk_retry"] GetObject:request];
    }
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

- (void)test300 {
    NSArray * array = @[@"301r",@"301",@"302r",@"302"];
    XCTestExpectation *exp = [self expectationWithDescription:@"test300"];
    __block int count = 0;
    for (NSString * key in array) {
        QCloudGetObjectRequest *request = [QCloudGetObjectRequest new];
        request.object = key;
        request.bucket = imageTestBucket.name;
        [request setFinishBlock:^(id outputObject, NSError *error) {
            NSHTTPURLResponse * response = error?[error __originHTTPURLResponse__]:[outputObject __originHTTPURLResponse__];
            if ([key containsString:@"r"]) {
                XCTAssertTrue(request.retryCount == 0);
                XCTAssertTrue([response.URL.host containsString:@"myqcloud"]);
            }else{
                XCTAssertTrue(request.retryCount > 0);
                XCTAssertTrue(![response.URL.host containsString:@"myqcloud"]);
            }
            
            @synchronized (self) {
                count ++;
                if (count == array.count) {
                    [exp fulfill];
                }
            }
        }];
        [[QCloudCOSXMLService cosxmlServiceForKey:@"cos_sdk_retry"] GetObject:request];
    }
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

- (void)test400 {
    NSArray * array = @[@"400r",@"400",@"403r",@"403",@"404r",@"404"];
    XCTestExpectation *exp = [self expectationWithDescription:@"test400"];
    __block int count = 0;
    for (NSString * key in array) {
        QCloudGetObjectRequest *request = [QCloudGetObjectRequest new];
        request.object = key;
        request.bucket = imageTestBucket.name;
        [request setFinishBlock:^(id outputObject, NSError *error) {
            NSHTTPURLResponse * response = error?[error __originHTTPURLResponse__]:[outputObject __originHTTPURLResponse__];
            XCTAssertTrue(request.retryCount == 0);
            XCTAssertTrue([response.URL.host containsString:@"myqcloud"]);
            @synchronized (self) {
                count ++;
                if (count == array.count) {
                    [exp fulfill];
                }
            }
        }];
        [[QCloudCOSXMLService cosxmlServiceForKey:@"cos_sdk_retry"] GetObject:request];
    }
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

- (void)test500 {
    NSArray * array = @[@"500r"];
    XCTestExpectation *exp = [self expectationWithDescription:@"test500"];
    __block int count = 0;
    for (NSString * key in array) {
        QCloudGetObjectRequest *request = [QCloudGetObjectRequest new];
        request.object = key;
        request.bucket = imageTestBucket.name;
        [request setFinishBlock:^(id outputObject, NSError *error) {
            NSHTTPURLResponse * response = error?[error __originHTTPURLResponse__]:[outputObject __originHTTPURLResponse__];
            XCTAssertTrue(request.retryCount > 0);
            if ([key containsString:@"r"]) {
                XCTAssertTrue([response.URL.host containsString:@"myqcloud"]);
            }else{
                XCTAssertTrue(![response.URL.host containsString:@"myqcloud"]);
            }
            @synchronized (self) {
                count ++;
                if (count == array.count) {
                    [exp fulfill];
                }
            }
        }];
        [[QCloudCOSXMLService cosxmlServiceForKey:@"cos_sdk_retry"] GetObject:request];
    }
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

- (void)test207 {
    NSArray * array = @[@"207", @"207r"];
    XCTestExpectation *exp = [self expectationWithDescription:@"test207"];
    __block int count = 0;
    for (NSString * key in array) {
        QCloudGetObjectRequest *request = [QCloudGetObjectRequest new];
        request.object = key;
        request.bucket = imageTestBucket.name;
        [request setFinishBlock:^(id outputObject, NSError *error) {
            NSHTTPURLResponse * response = error?[error __originHTTPURLResponse__]:[outputObject __originHTTPURLResponse__];
            XCTAssertTrue(request.retryCount > 0);
            XCTAssertTrue([response.URL.host containsString:@"myqcloud"]);
            @synchronized (self) {
                count ++;
                if (count == array.count) {
                    [exp fulfill];
                }
            }
        }];
        [[QCloudCOSXMLService cosxmlServiceForKey:@"cos_sdk_retry"] GetObject:request];
    }
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

- (void)testOther {
    NSArray * array = @[@"timeout",@"shutdown"];
    XCTestExpectation *exp = [self expectationWithDescription:@"testOther"];
    __block int count = 0;
    for (NSString * key in array) {
        QCloudGetObjectRequest *request = [QCloudGetObjectRequest new];
        request.object = key;
        request.bucket = imageTestBucket.name;
        [request setFinishBlock:^(id outputObject, NSError *error) {
            NSHTTPURLResponse * response = error?[error __originHTTPURLResponse__]:[outputObject __originHTTPURLResponse__];
            XCTAssertTrue(request.retryCount > 0);
            //XCTAssertTrue(![response.URL.host containsString:@"myqcloud"]);
            @synchronized (self) {
                count ++;
                if (count == array.count) {
                    [exp fulfill];
                }
            }
        }];
        [[QCloudCOSXMLService cosxmlServiceForKey:@"cos_sdk_retry"] GetObject:request];
    }
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

- (void)test200Disable {
    NSArray * array = @[@"200r",@"200",@"204r",@"204",@"206r",@"206"];
    XCTestExpectation *exp = [self expectationWithDescription:@"test200Disable"];
    __block int count = 0;
    for (NSString * key in array) {
        QCloudGetObjectRequest *request = [QCloudGetObjectRequest new];
        request.object = key;
        request.bucket = imageTestBucket.name;
        [request setFinishBlock:^(id outputObject, NSError *error) {
            XCTAssertTrue(request.retryCount == 0);
            NSHTTPURLResponse * response = [outputObject __originHTTPURLResponse__];
            XCTAssertTrue([response.URL.host containsString:@"myqcloud"]);
            @synchronized (self) {
                count ++;
                if (count == array.count) {
                    [exp fulfill];
                }
            }
        }];
        [[QCloudCOSXMLService cosxmlServiceForKey:@"cos_sdk_retry_disable"] GetObject:request];
    }
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

- (void)test300dis {
    NSArray * array = @[@"301r",@"301",@"302r",@"302"];
    XCTestExpectation *exp = [self expectationWithDescription:@"test300dis"];
    __block int count = 0;
    for (NSString * key in array) {
        QCloudGetObjectRequest *request = [QCloudGetObjectRequest new];
        request.object = key;
        request.bucket = imageTestBucket.name;
        [request setFinishBlock:^(id outputObject, NSError *error) {
            NSHTTPURLResponse * response = error?[error __originHTTPURLResponse__]:[outputObject __originHTTPURLResponse__];
            XCTAssertTrue(request.retryCount == 0);
            XCTAssertTrue([response.URL.host containsString:@"myqcloud"]);
            @synchronized (self) {
                count ++;
                if (count == array.count) {
                    [exp fulfill];
                }
            }
        }];
        [[QCloudCOSXMLService cosxmlServiceForKey:@"cos_sdk_retry_disable"] GetObject:request];
    }
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

- (void)test400dis {
    NSArray * array = @[@"400r",@"400",@"403r",@"403",@"404r",@"404"];
    XCTestExpectation *exp = [self expectationWithDescription:@"test400dis"];
    __block int count = 0;
    for (NSString * key in array) {
        QCloudGetObjectRequest *request = [QCloudGetObjectRequest new];
        request.object = key;
        request.bucket = imageTestBucket.name;
        [request setFinishBlock:^(id outputObject, NSError *error) {
            NSHTTPURLResponse * response = error?[error __originHTTPURLResponse__]:[outputObject __originHTTPURLResponse__];
            XCTAssertTrue(request.retryCount == 0);
            XCTAssertTrue([response.URL.host containsString:@"myqcloud"]);
            @synchronized (self) {
                count ++;
                if (count == array.count) {
                    [exp fulfill];
                }
            }
        }];
        [[QCloudCOSXMLService cosxmlServiceForKey:@"cos_sdk_retry_disable"] GetObject:request];
    }
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

- (void)test500dis {
    NSArray * array = @[@"500r"];
    XCTestExpectation *exp = [self expectationWithDescription:@"test500dis"];
    __block int count = 0;
    for (NSString * key in array) {
        QCloudGetObjectRequest *request = [QCloudGetObjectRequest new];
        request.object = key;
        request.bucket = imageTestBucket.name;
        [request setFinishBlock:^(id outputObject, NSError *error) {
            NSHTTPURLResponse * response = error?[error __originHTTPURLResponse__]:[outputObject __originHTTPURLResponse__];
            XCTAssertTrue(request.retryCount > 0);
            XCTAssertTrue([response.URL.host containsString:@"myqcloud"]);
            @synchronized (self) {
                count ++;
                if (count == array.count) {
                    [exp fulfill];
                }
            }
        }];
        [[QCloudCOSXMLService cosxmlServiceForKey:@"cos_sdk_retry_disable"] GetObject:request];
    }
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

- (void)test207dis {
    NSArray * array = @[@"207", @"207r"];
    XCTestExpectation *exp = [self expectationWithDescription:@"test207dis"];
    __block int count = 0;
    for (NSString * key in array) {
        QCloudGetObjectRequest *request = [QCloudGetObjectRequest new];
        request.object = key;
        request.bucket = imageTestBucket.name;
        [request setFinishBlock:^(id outputObject, NSError *error) {
            NSHTTPURLResponse * response = error?[error __originHTTPURLResponse__]:[outputObject __originHTTPURLResponse__];
            XCTAssertTrue(request.retryCount > 0);
            XCTAssertTrue([response.URL.host containsString:@"myqcloud"]);
            @synchronized (self) {
                count ++;
                if (count == array.count) {
                    [exp fulfill];
                }
            }
        }];
        [[QCloudCOSXMLService cosxmlServiceForKey:@"cos_sdk_retry_disable"] GetObject:request];
    }
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

- (void)testOtherdis {
    NSArray * array = @[@"timeout",@"shutdown"];
    XCTestExpectation *exp = [self expectationWithDescription:@"testOther"];
    __block int count = 0;
    for (NSString * key in array) {
        QCloudGetObjectRequest *request = [QCloudGetObjectRequest new];
        request.object = key;
        request.bucket = imageTestBucket.name;
        [request setFinishBlock:^(id outputObject, NSError *error) {
            NSHTTPURLResponse * response = error?[error __originHTTPURLResponse__]:[outputObject __originHTTPURLResponse__];
            XCTAssertTrue(request.retryCount > 0);
            XCTAssertTrue([response.URL.host containsString:@"myqcloud"]);
            @synchronized (self) {
                count ++;
                if (count == array.count) {
                    [exp fulfill];
                }
            }
        }];
        [[QCloudCOSXMLService cosxmlServiceForKey:@"cos_sdk_retry_disable"] GetObject:request];
    }
    [self waitForExpectationsWithTimeout:100 handler:nil];
}
@end
