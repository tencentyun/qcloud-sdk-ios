//
//  QCloudCOSXMLBucketTests.m
//  QCloudCOSXMLDemo
//
//  Created by Dong Zhao on 2017/6/8.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <QCloudCOSXML/QCloudCOSXML.h>
#import <QCloudCore/QCloudServiceConfiguration_Private.h>
#import <QCloudCore/QCloudAuthentationCreator.h>
#import <QCloudCore/QCloudCredential.h>

#import "TestCommonDefine.h"
#import "QCloudCOSXMLServiceUtilities.h"
#import "QCloudTestTempVariables.h"
#import "QCloudCOSXMLTestUtility.h"
#import "SecretStorage.h"
@interface QCloudCOSXMLBucketTests : XCTestCase <QCloudSignatureProvider>
@property (nonatomic, strong) NSString *bucket;
@property (nonatomic, strong) NSString *authorizedUIN;
@property (nonatomic, strong) NSString *ownerUIN;
@property (nonatomic, strong) NSString *appID;
@end

@implementation QCloudCOSXMLBucketTests

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
    if ([QCloudCOSXMLService hasServiceForKey:@"aclService"]) {
        return;
    }
    QCloudServiceConfiguration *configuration = [[QCloudServiceConfiguration alloc] init];
    configuration.appID = kAppID;
    configuration.signatureProvider = self;
    QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.regionName = @"ap-guangzhou";
    configuration.endpoint = endpoint;
    [QCloudCOSXMLService registerCOSXMLWithConfiguration:configuration withKey:@"aclService"];
}

+ (void)setUp {
    [QCloudTestTempVariables sharedInstance].testBucket = [[QCloudCOSXMLTestUtility sharedInstance] createTestBucketWithPrefix:@"bt"];
}

+ (void)tearDown {
    [[QCloudCOSXMLTestUtility sharedInstance] deleteAllTestBuckets];
}

- (void)setUp {
    [super setUp];
    [self setupSpecialCOSXMLShareService];
    self.bucket = [QCloudTestTempVariables sharedInstance].testBucket;
    self.appID = kAppID;
    self.authorizedUIN = @"1131975903";
    self.ownerUIN = @"1278687956";
}

- (void)createTestBucket {
    QCloudPutBucketRequest *request = [QCloudPutBucketRequest new];
    __block NSString *bucketName = [NSString stringWithFormat:@"bucketcanbedelete%i", arc4random() % 1000];
    request.bucket = bucketName;
    XCTestExpectation *exception = [self expectationWithDescription:@"Put new bucket exception"];
    __block NSError *responseError;
    __weak typeof(self) weakSelf = self;
    [request setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error);
        self.bucket = bucketName;
        [QCloudTestTempVariables sharedInstance].testBucket = bucketName;
        responseError = error;
        [exception fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutBucket:request];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    //    [[QCloudCOSXMLTestUtility sharedInstance] deleteTestBucket:self.bucket];
    [super tearDown];
}

- (void)testGetService {
    QCloudGetServiceRequest *request = [[QCloudGetServiceRequest alloc] init];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Get service"];
    [request setFinishBlock:^(QCloudListAllMyBucketsResult *result, NSError *error) {
        XCTAssertNil(error);
        XCTAssert(result);
        XCTAssertNotNil(result.owner);
        XCTAssertNotNil(result.buckets);
        XCTAssert(result.buckets.count > 0, @"buckets not more than zero, it is %lu", (unsigned long)result.buckets.count);
        XCTAssertNotNil(result.buckets.firstObject.name);
        XCTAssertNotNil(result.buckets.firstObject.location);
        XCTAssertNotNil(result.buckets.firstObject.createDate);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetService:request];
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)testPutAndDeleteBucket {
    XCTestExpectation *exception = [self expectationWithDescription:@"Delete bucket exception"];
    __block NSError *responseError;
    QCloudPutBucketRequest *putBucketRequest = [[QCloudPutBucketRequest alloc] init];
    putBucketRequest.bucket = [NSString stringWithFormat:@"bucketcanbedelete%i", arc4random() % 1000];
    [putBucketRequest setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error);
        if (!error) {
            QCloudDeleteBucketRequest *request = [[QCloudDeleteBucketRequest alloc] init];
            request.regionName = putBucketRequest.regionName;
            request.bucket = putBucketRequest.bucket;
            [request setFinishBlock:^(id outputObject, NSError *error) {
                responseError = error;
                [exception fulfill];
            }];
            [[QCloudCOSXMLService defaultCOSXML] DeleteBucket:request];
        } else {
            [exception fulfill];
        }
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutBucket:putBucketRequest];
    [self waitForExpectationsWithTimeout:100 handler:nil];
    XCTAssertNil(responseError);
}

- (void)testMoreRegion {
    XCTestExpectation *exception = [self expectationWithDescription:@"Delete bucket exception"];
    __block NSError *responseError;
    __block QCloudPutBucketRequest *putBucketRequest = [[QCloudPutBucketRequest alloc] init];
    NSString *bucketName = [NSString stringWithFormat:@"bucketcanbedelete%i", arc4random() % 1000];
    NSLog(@"---- %@", bucketName);
    putBucketRequest.bucket = bucketName;

    putBucketRequest.regionName = @"ap-beijing-1";
    ;
    [putBucketRequest setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error);
        if (!error) {
            QCloudGetBucketRequest *request = [[QCloudGetBucketRequest alloc] init];
            request.bucket = bucketName;
            [request setFinishBlock:^(id outputObject, NSError *error) {
                responseError = error;
                [exception fulfill];
            }];
            [[QCloudCOSXMLService defaultCOSXML] GetBucket:request];
        } else {
            [exception fulfill];
        }
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutBucket:putBucketRequest];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

//- (void)testPutBucket {
//    QCloudPutBucketRequest* putBucketRequest = [[QCloudPutBucketRequest alloc] init];
//    putBucketRequest.bucket = @"v4-yfb-bucket";
//    XCTestExpectation* expectation = [self expectationWithDescription:@"putBucket"];
//
//    [putBucketRequest setFinishBlock:^(id outputObject, NSError *error) {
//        [expectation fulfill];
//    }];
//    [[QCloudCOSXMLService defaultCOSXML] PutBucket:putBucketRequest];
//    [self waitForExpectationsWithTimeout:80 handler:nil];
//
//}

- (void)testGetBucket {
    QCloudGetBucketRequest *request = [QCloudGetBucketRequest new];
    request.bucket = self.bucket;
    request.maxKeys = 1000;
    request.prefix = @"0";
    request.delimiter = @"0";
    request.encodingType = @"url";

    request.prefix = request.delimiter = request.encodingType = nil;
    XCTestExpectation *exp = [self expectationWithDescription:@"delete"];

    __block QCloudListBucketResult *listResult;
    [request setFinishBlock:^(QCloudListBucketResult *_Nonnull result, NSError *_Nonnull error) {
        listResult = result;
        XCTAssertNil(error);
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetBucket:request];
    [self waitForExpectationsWithTimeout:100 handler:nil];

    XCTAssertNotNil(listResult);
    NSString *listResultName = listResult.name;
    NSString *expectListResultName = [NSString stringWithFormat:@"%@-%@", self.bucket, self.appID];
    XCTAssert([listResultName isEqualToString:expectListResultName]);
}

- (void)testCORS1_PutBucketCORS {
    QCloudPutBucketCORSRequest *putCORS = [QCloudPutBucketCORSRequest new];
    QCloudCORSConfiguration *cors = [QCloudCORSConfiguration new];

    QCloudCORSRule *rule = [QCloudCORSRule new];
    rule.identifier = @"sdk";
    rule.allowedHeader = @[ @"origin", @"host", @"accept", @"content-type", @"authorization" ];
    rule.exposeHeader = @"ETag";
    rule.allowedMethod = @[ @"GET", @"PUT", @"POST", @"DELETE", @"HEAD" ];
    rule.maxAgeSeconds = 3600;
    rule.allowedOrigin = @"*";

    cors.rules = @[ rule ];

    putCORS.corsConfiguration = cors;
    putCORS.bucket = self.bucket;
    __block NSError *localError;
    XCTestExpectation *exp = [self expectationWithDescription:@"putacl"];
    [putCORS setFinishBlock:^(id outputObject, NSError *error) {
        localError = error;
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutBucketCORS:putCORS];
    [self waitForExpectationsWithTimeout:20 handler:nil];
    XCTAssertNil(localError);
}

//- (void)testCORS2_GetBucketCORS {
//    QCloudPutBucketCORSRequest *putCORS = [QCloudPutBucketCORSRequest new];
//    QCloudCORSConfiguration *putCors = [QCloudCORSConfiguration new];
//
//    QCloudCORSRule *rule = [QCloudCORSRule new];
//    rule.identifier = @"sdk1";
//    rule.allowedHeader = @[ @"origin", @"accept", @"content-type", @"authorization" ];
//    rule.exposeHeader = @"ETag";
//    rule.allowedMethod = @[ @"GET", @"PUT", @"POST", @"DELETE", @"HEAD" ];
//    rule.maxAgeSeconds = 3600;
//    rule.allowedOrigin = @"*";
//
//    putCors.rules = @[ rule ];
//
//    putCORS.corsConfiguration = putCors;
//    putCORS.bucket = self.bucket;
//    __block NSError *localError1;
//
//    __block QCloudCORSConfiguration *cors;
//    __block XCTestExpectation *exp = [self expectationWithDescription:@"delete"];
//
//    [putCORS setFinishBlock:^(id outputObject, NSError *error) {
//        QCloudGetBucketCORSRequest *corsReqeust = [QCloudGetBucketCORSRequest new];
//        corsReqeust.bucket = self.bucket;
//
//        [corsReqeust setFinishBlock:^(QCloudCORSConfiguration *_Nonnull result, NSError *_Nonnull error) {
//            XCTAssertNil(error);
//            cors = result;
//            [exp fulfill];
//        }];
//
//        [[QCloudCOSXMLService defaultCOSXML] GetBucketCORS:corsReqeust];
//    }];
//
//    [[QCloudCOSXMLService defaultCOSXML] PutBucketCORS:putCORS];
//    [self waitForExpectationsWithTimeout:120
//                                 handler:^(NSError *_Nullable error) {
//                                     NSLog(@"请求超时");
//                                 }];
//    XCTAssertNotNil(cors);
//    XCTAssert([[[cors.rules firstObject] identifier] isEqualToString:@"sdk1"]);
//    XCTAssertEqual(1, cors.rules.count);
//    XCTAssertEqual([cors.rules.firstObject.allowedMethod count], 5);
//    XCTAssert([cors.rules.firstObject.allowedMethod containsObject:@"PUT"]);
//    XCTAssert([cors.rules.firstObject.allowedHeader count] == 4);
//    XCTAssert([cors.rules.firstObject.exposeHeader isEqualToString:@"ETag"]);
//}

- (void)testCORS3_OpetionObject {
    QCloudOptionsObjectRequest *request = [[QCloudOptionsObjectRequest alloc] init];
    request.bucket = self.bucket;
    request.origin = @"http://www.qcloud.com";
    request.accessControlRequestMethod = @"GET";
    request.accessControlRequestHeaders = @"origin";
    request.object = [[QCloudCOSXMLTestUtility sharedInstance] uploadTempObjectInBucket:self.bucket];
    XCTestExpectation *exp = [self expectationWithDescription:@"option object"];

    __block id resultError;
    [request setFinishBlock:^(id outputObject, NSError *error) {
        resultError = error;
        [exp fulfill];
    }];

    [[QCloudCOSXMLService defaultCOSXML] OptionsObject:request];

    [self waitForExpectationsWithTimeout:80
                                 handler:^(NSError *_Nullable error) {

                                 }];
    XCTAssertNil(resultError);
}

- (void)testCORS4_DeleteBucketCORS {
    QCloudDeleteBucketCORSRequest *deleteCORS = [QCloudDeleteBucketCORSRequest new];
    deleteCORS.bucket = self.bucket;

    NSLog(@"test");

    __block NSError *localError;
    XCTestExpectation *exp = [self expectationWithDescription:@"putacl"];
    //    [deleteCORS setFinishBlock:^(id outputObject, NSError *error) {
    //        localError = error;
    //        [exp fulfill];
    //    }];
    //    [[QCloudCOSXMLService defaultCOSXML] DeleteBucketCORS:deleteCORS];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"after");
        [exp fulfill];
    });
    [self waitForExpectationsWithTimeout:80 handler:nil];
    XCTAssertNil(localError);
}

- (void)testGetBucketLocation {
    QCloudGetBucketLocationRequest *locationReq = [QCloudGetBucketLocationRequest new];
    locationReq.bucket = self.bucket;
    XCTestExpectation *exp = [self expectationWithDescription:@"delete"];
    __block QCloudBucketLocationConstraint *location;

    [locationReq setFinishBlock:^(QCloudBucketLocationConstraint *_Nonnull result, NSError *_Nonnull error) {
        location = result;
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetBucketLocation:locationReq];
    [self waitForExpectationsWithTimeout:100 handler:nil];
    XCTAssertNotNil(location);
    NSString *currentLocation;

#ifdef CNNORTH_REGION
    currentLocation = @"ap-guangzhou";
#else
    currentLocation = @"ap-beijing";
#endif
    XCTAssert([location.locationConstraint isEqualToString:kRegion]);
}

- (void)testPut_And_Get_BucketACL {
    QCloudPutBucketACLRequest *putACL = [QCloudPutBucketACLRequest new];
    putACL.runOnService = [QCloudCOSXMLService cosxmlServiceForKey:@"aclService"];
    //    NSString *ownerIdentifier = [NSString stringWithFormat:@"qcs::cam::uin/%@:uin/%@", self.authorizedUIN,self.authorizedUIN];
    //    NSString *grantString = [NSString stringWithFormat:@"id=\"%@\"",ownerIdentifier];
    //    putACL.grantFullControl = grantString;
    //    putACL.grantRead = grantString;
    //    putACL.grantWrite = grantString;

    QCloudACLPolicy *policy = [QCloudACLPolicy new];
    putACL.accessControlPolicy = policy;
    QCloudACLOwner *o = [QCloudACLOwner new];
    o.identifier = @"qcs::cam::uin/1278687956:uin/1278687956";
    policy.owner = o;

    QCloudAccessControlList *list = [QCloudAccessControlList new];
    policy.accessControlList = list;

    NSMutableArray<QCloudACLGrant *> *ACLGrants = [NSMutableArray array];

    list.ACLGrants = ACLGrants;

    QCloudACLGrant *g1 = [QCloudACLGrant new];
    QCloudACLGrantee *t1 = [QCloudACLGrantee new];
    t1.identifier = @"qcs::cam::uin/100011548427:uin/100011548427";
    g1.grantee = t1;
    g1.permission = QCloudCOSPermissionRead;

    QCloudACLGrant *g2 = [QCloudACLGrant new];
    QCloudACLGrantee *t2 = [QCloudACLGrantee new];
    t2.identifier = @"qcs::cam::uin/100011548427:uin/100011548427";
    g2.grantee = t2;
    g2.permission = QCloudCOSPermissionWrite;

    [ACLGrants addObject:g1];
    [ACLGrants addObject:g2];
    putACL.bucket = self.bucket;
    XCTestExpectation *exp = [self expectationWithDescription:@"putacl"];
    __block NSError *localError;
    [putACL setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error);
        QCloudGetBucketACLRequest *getBucketACLRequest = [[QCloudGetBucketACLRequest alloc] init];
        getBucketACLRequest.bucket = self.bucket;
        [getBucketACLRequest setFinishBlock:^(QCloudACLPolicy *result, NSError *error) {
            XCTAssertNil(error);
            XCTAssertNotNil(result);
            NSString *ownerIdentifiler = [NSString identifierStringWithID:self.ownerUIN:self.ownerUIN];
            XCTAssert([result.owner.identifier isEqualToString:ownerIdentifiler], @"result Owner Identifier is%@", result.owner.identifier);
            [exp fulfill];
        }];
        [[QCloudCOSXMLService defaultCOSXML] GetBucketACL:getBucketACLRequest];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutBucketACL:putACL];
    [self waitForExpectationsWithTimeout:100 handler:nil];
    XCTAssertNil(localError);
}

- (void)testHeadBucket {
    QCloudHeadBucketRequest *request = [QCloudHeadBucketRequest new];
    request.bucket = self.bucket;
    XCTestExpectation *exp = [self expectationWithDescription:@"putacl"];
    __block NSError *resultError;
    [request setFinishBlock:^(id outputObject, NSError *error) {
        resultError = error;
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] HeadBucket:request];
    [self waitForExpectationsWithTimeout:20 handler:nil];
    XCTAssertNil(resultError);
}

- (void)testListMultipartUpload {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    QCloudCOSXMLUploadObjectRequest *uploadObjectRequest = [[QCloudCOSXMLUploadObjectRequest alloc] init];
    uploadObjectRequest.bucket = self.bucket;
    uploadObjectRequest.object = @"object-aborted";
    uploadObjectRequest.body = [NSURL URLWithString:[QCloudTestUtility tempFileWithSize:5 unit:QCLOUD_TEST_FILE_UNIT_MB]];
    __weak QCloudCOSXMLUploadObjectRequest *weakRequest = uploadObjectRequest;
    __block NSString *uploadID;
    [uploadObjectRequest setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        if (totalBytesSent > totalBytesExpectedToSend * 0.5) {
            [weakRequest cancel];
        }
    }];
    uploadObjectRequest.initMultipleUploadFinishBlock
        = ^(QCloudInitiateMultipartUploadResult *multipleUploadInitResult, QCloudCOSXMLUploadObjectResumeData resumeData) {
              uploadID = multipleUploadInitResult.uploadId;
          };
    [uploadObjectRequest setFinishBlock:^(QCloudUploadObjectResult *result, NSError *error) {
        dispatch_semaphore_signal(semaphore);
    }];
    [[QCloudCOSTransferMangerService defaultCOSTransferManager] UploadObject:uploadObjectRequest];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    QCloudListMultipartRequest *request = [[QCloudListMultipartRequest alloc] init];
    request.bucket = self.bucket;
    request.object = uploadObjectRequest.object;
    request.uploadId = uploadID;

    XCTestExpectation *expectation = [self expectationWithDescription:@"test"];
    [request setFinishBlock:^(QCloudListPartsResult *_Nonnull result, NSError *_Nonnull error) {
        XCTAssertNil(error);
        XCTAssert(result);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] ListMultipart:request];
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)testListBucketUploads {
    QCloudListBucketMultipartUploadsRequest *uploads = [QCloudListBucketMultipartUploadsRequest new];
    uploads.bucket = self.bucket;
    uploads.maxUploads = 1000;
    __block NSError *localError;
    __block QCloudListMultipartUploadsResult *multiPartUploadsResult;
    XCTestExpectation *exp = [self expectationWithDescription:@"putacl"];
    [uploads setFinishBlock:^(QCloudListMultipartUploadsResult *result, NSError *error) {
        multiPartUploadsResult = result;
        localError = error;
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] ListBucketMultipartUploads:uploads];
    [self waitForExpectationsWithTimeout:20 handler:nil];

    XCTAssertNil(localError);
    XCTAssert(multiPartUploadsResult.maxUploads == 1000);
    NSString *expectedBucketString = [NSString stringWithFormat:@"%@-%@", self.bucket, self.appID];
    XCTAssert([multiPartUploadsResult.bucket isEqualToString:expectedBucketString]);
    XCTAssert(multiPartUploadsResult.maxUploads == 1000);
    if (multiPartUploadsResult.uploads.count) {
        QCloudListMultipartUploadContent *firstContent = [multiPartUploadsResult.uploads firstObject];
        XCTAssert([firstContent.owner.displayName isEqualToString:@"1278687956"]);
        XCTAssert([firstContent.initiator.displayName isEqualToString:@"1278687956"]);
        XCTAssertNotNil(firstContent.uploadID);
        XCTAssertNotNil(firstContent.key);
    }
}

- (void)testaPut_Get_Delete_BucketLifeCycle {
    QCloudPutBucketLifecycleRequest *request = [QCloudPutBucketLifecycleRequest new];
    request.bucket = self.bucket;
    __block QCloudLifecycleConfiguration *configuration = [[QCloudLifecycleConfiguration alloc] init];
    QCloudLifecycleRule *rule = [[QCloudLifecycleRule alloc] init];
    rule.identifier = @"id1";
    rule.status = QCloudLifecycleStatueEnabled;
    QCloudLifecycleRuleFilter *filter = [[QCloudLifecycleRuleFilter alloc] init];
    filter.prefix = @"0";
    rule.filter = filter;

    QCloudLifecycleTransition *transition = [[QCloudLifecycleTransition alloc] init];
    transition.days = 100;
    transition.storageClass = QCloudCOSStorageStandardIA;
    rule.transition = transition;
    request.lifeCycle = configuration;
    request.lifeCycle.rules = @[ rule ];
    XCTestExpectation *exception = [self expectationWithDescription:@"Put Bucket Life cycle exception"];
    [request setFinishBlock:^(id outputObject, NSError *putLifecycleError) {
        XCTAssertNil(putLifecycleError);
        // Get Configuration
        XCTAssertNil(putLifecycleError);

        QCloudGetBucketLifecycleRequest *request = [QCloudGetBucketLifecycleRequest new];
        request.bucket = self.bucket;
        [request setFinishBlock:^(QCloudLifecycleConfiguration *getLifecycleReuslt, NSError *getLifeCycleError) {
            XCTAssertNil(getLifeCycleError);
            XCTAssertNotNil(getLifecycleReuslt);
            XCTAssert(getLifecycleReuslt.rules.count == configuration.rules.count);
            XCTAssert([getLifecycleReuslt.rules.firstObject.identifier isEqualToString:configuration.rules.firstObject.identifier]);
            XCTAssert(getLifecycleReuslt.rules.firstObject.status == configuration.rules.firstObject.status);

            // delete configuration
            QCloudDeleteBucketLifeCycleRequest *request = [[QCloudDeleteBucketLifeCycleRequest alloc] init];
            request.bucket = self.bucket;
            [request setFinishBlock:^(QCloudLifecycleConfiguration *deleteResult, NSError *deleteError) {
                XCTAssert(deleteResult);
                XCTAssertNil(deleteError);
                [exception fulfill];
            }];
            [[QCloudCOSXMLService defaultCOSXML] DeleteBucketLifeCycle:request];
            // delete configuration end
        }];
        [[QCloudCOSXMLService defaultCOSXML] GetBucketLifecycle:request];
        // Get configuration end
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutBucketLifecycle:request];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

- (void)testPut_And_Get_BucketVersioning {
    QCloudPutBucketVersioningRequest *request = [[QCloudPutBucketVersioningRequest alloc] init];
    request.bucket = @"xiaodaxiansource";
    QCloudBucketVersioningConfiguration *configuration = [[QCloudBucketVersioningConfiguration alloc] init];
    request.configuration = configuration;
    configuration.status = QCloudCOSBucketVersioningStatusEnabled;
    XCTestExpectation *expectation = [self expectationWithDescription:@"Put Bucket Versioning"];
    [request setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error);

        QCloudGetBucketVersioningRequest *request = [[QCloudGetBucketVersioningRequest alloc] init];
        request.bucket = self.bucket;
        [request setFinishBlock:^(QCloudBucketVersioningConfiguration *result, NSError *error) {
            XCTAssert(result);
            XCTAssertNil(error);
            [expectation fulfill];
        }];
        [[QCloudCOSXMLService defaultCOSXML] GetBucketVersioning:request];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutBucketVersioning:request];
    [self waitForExpectationsWithTimeout:80 handler:nil];

    //
    QCloudPutBucketVersioningRequest *suspendRequest = [[QCloudPutBucketVersioningRequest alloc] init];
    suspendRequest.bucket = self.bucket;
    QCloudBucketVersioningConfiguration *suspendConfiguration = [[QCloudBucketVersioningConfiguration alloc] init];
    request.configuration = suspendConfiguration;
    suspendConfiguration.status = QCloudCOSBucketVersioningStatusSuspended;
    [[QCloudCOSXMLService defaultCOSXML] PutBucketVersioning:request];
}

- (void)testPut_Get_Delte_BucketReplication {
    __block NSString *sourceBucket = @"xiaodaxiansource";
    __block NSString *destinationBucket = @"replication-destination";
    __block NSString *destinationRegion = @"ap-beijing";

    // enable bucket versioning first
    QCloudPutBucketVersioningRequest *destinationPutBucketVersioningRequest = [[QCloudPutBucketVersioningRequest alloc] init];
    destinationPutBucketVersioningRequest.bucket = destinationBucket;
    QCloudBucketVersioningConfiguration *configuration = [[QCloudBucketVersioningConfiguration alloc] init];
    destinationPutBucketVersioningRequest.configuration = configuration;
    configuration.status = QCloudCOSBucketVersioningStatusEnabled;
    XCTestExpectation *putDestinationBucketVersioningExpectation = [self expectationWithDescription:@"Put Bucket Versioning first "];
    [destinationPutBucketVersioningRequest setFinishBlock:^(id outputObject, NSError *error) {
        [putDestinationBucketVersioningExpectation fulfill];
        XCTAssertNil(error);
    }];
    __block NSString *previousRegion = [QCloudCOSXMLService defaultCOSXML].configuration.endpoint.regionName;
    [QCloudCOSXMLService defaultCOSXML].configuration.endpoint.regionName = destinationRegion;
    [[QCloudCOSXMLService defaultCOSXML] PutBucketVersioning:destinationPutBucketVersioningRequest];
    [self waitForExpectationsWithTimeout:10
                                 handler:^(NSError *_Nullable error) {
                                     [QCloudCOSXMLService defaultCOSXML].configuration.endpoint.regionName = previousRegion;
                                 }];

    QCloudPutBucketVersioningRequest *request = [[QCloudPutBucketVersioningRequest alloc] init];
    request.bucket = sourceBucket;
    //    QCloudBucketVersioningConfiguration* configuration = [[QCloudBucketVersioningConfiguration alloc] init];
    request.configuration = configuration;
    configuration.status = QCloudCOSBucketVersioningStatusEnabled;
    XCTestExpectation *expectation = [self expectationWithDescription:@"Put Bucket Versioning"];
    [request setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error);

        // put bucket replication
        QCloudPutBucketReplicationRequest *request = [[QCloudPutBucketReplicationRequest alloc] init];
        request.bucket = sourceBucket;
        QCloudBucketReplicationConfiguation *configuration = [[QCloudBucketReplicationConfiguation alloc] init];
        configuration.role = [NSString identifierStringWithID:@"1278687956":@"1278687956"];
        QCloudBucketReplicationRule *rule = [[QCloudBucketReplicationRule alloc] init];

        rule.identifier = [NSUUID UUID].UUIDString;
        rule.status = QCloudCOSXMLStatusEnabled;

        QCloudBucketReplicationDestination *destination = [[QCloudBucketReplicationDestination alloc] init];
        // qcs:id/0:cos:[region]:appid/[AppId]:[bucketname]
        //        NSString* destinationBucket = destinationBucket;
        destination.bucket = [NSString stringWithFormat:@"qcs:id/0:cos:%@:appid/%@:%@", destinationRegion, self.appID, destinationBucket];
        rule.destination = destination;
        configuration.rule = @[ rule ];
        request.configuation = configuration;
        [request setFinishBlock:^(id outputObject, NSError *error) {
            XCTAssertNil(error);
            // get bucket replication
            QCloudGetBucketReplicationRequest *request = [[QCloudGetBucketReplicationRequest alloc] init];
            request.bucket = sourceBucket;
            [request setFinishBlock:^(QCloudBucketReplicationConfiguation *result, NSError *error) {
                XCTAssertNil(error);
                XCTAssertNotNil(result);

                // delete bucket replication
                QCloudDeleteBucketReplicationRequest *request = [[QCloudDeleteBucketReplicationRequest alloc] init];
                request.bucket = sourceBucket;
                [request setFinishBlock:^(id outputObject, NSError *error) {
                    XCTAssertNil(error);
                    [expectation fulfill];
                }];
                [[QCloudCOSXMLService defaultCOSXML] DeleteBucketReplication:request];
                // delete bucket replication end
            }];
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            dispatch_semaphore_wait(semaphore, 5 * NSEC_PER_SEC);
            [[QCloudCOSXMLService defaultCOSXML] GetBucketReplication:request];

            // get bucket replication end
        }];
        [[QCloudCOSXMLService defaultCOSXML] PutBucketRelication:request];
        // put bucket replication end
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutBucketVersioning:request];
    [self waitForExpectationsWithTimeout:80 handler:nil];

    //
    //    QCloudPutBucketVersioningRequest* suspendRequest = [[QCloudPutBucketVersioningRequest alloc] init];
    //    suspendRequest.bucket = self.bucket;
    //    QCloudBucketVersioningConfiguration* suspendConfiguration = [[QCloudBucketVersioningConfiguration alloc] init];
    //    request.configuration = suspendConfiguration;
    //    suspendConfiguration.status = QCloudCOSBucketVersioningStatusSuspended;
    //    [[QCloudCOSXMLService defaultCOSXML] PutBucketVersioning:request];
}
//
//- (void)testNewPut_Get_DeleteBucketReplication {
//    NSString* tempBucket = @"bucketcanbedeleteReplication";
//    NSString* tempRegionName = @"ap-guangzhou";
//    QCloudCOSXMLEndPoint* endpoint = [[QCloudCOSXMLEndPoint alloc] init];
//    endpoint.regionName = tempRegionName;
//    QCloudServiceConfiguration* tempServiceConfiguration = [[QCloudServiceConfiguration alloc] init];
//    tempServiceConfiguration.endpoint = endpoint;
//    QCloudCOSXMLService* tempService = [[QCloudCOSXMLService alloc] initWithConfiguration:tempServiceConfiguration];
//
//
//
//    // Put a temp bucket for testing first.
//    XCTestExpectation* putBucketExpectation = [self expectationWithDescription:@"Put temp bucket"];
//    QCloudPutBucketRequest* putBucketRequest = [[QCloudPutBucketRequest alloc] init];
//    putBucketRequest.bucket = tempBucket;
//    [putBucketRequest setFinishBlock:^(id outputObject, NSError *error) {
//        XCTAssertNil(error,@"Put Bucket error!");
//        [putBucketExpectation fulfill];
//    }];
//    [tempService PutBucket:putBucketRequest];
//    [self waitForExpectationsWithTimeout:80 handler:nil];
//
//
//    // Then enable replication for source bucket;
//    XCTestExpectation* putReplicationExpectation = [self expectationWithDescription:@"put replication expectation"];
//    QCloudPutBucketReplicationRequest* putBucketReplicationRequest = [[QCloudPutBucketReplicationRequest alloc] init];
//    putBucketReplicationRequest.bucket = self.bucket;
//    QCloudBucketReplicationConfiguation* putReplicationConfiguration = [[QCloudBucketReplicationConfiguation alloc] init];
//    putBucketReplicationRequest.configuation = putReplicationConfiguration;
//    putReplicationConfiguration.status = QCloudCOSBucketVersioningStatusEnabled;
//    [putBucketReplicationRequest setFinishBlock:^(id outputObject, NSError *error) {
//        XCTAssertNil(error,@"")
//        [putReplicationExpectation fulfill];
//    }];
//    [[QCloudCOSXMLService defaultCOSXML] PutBucketRelication:putBucketReplicationRequest];
//
//
//}

//- (void)testBucketReplication2_GetBucektReplication {
//    QCloudGetBucketReplicationRequest* request = [[QCloudGetBucketReplicationRequest alloc] init];
//    request.bucket = @"xiaodaxiansource";
//
//    XCTestExpectation* expectation = [self expectationWithDescription:@"Get bucke replication" ];
//    [request setFinishBlock:^(QCloudBucketReplicationConfiguation* result, NSError* error) {
//        XCTAssertNil(error);
//        XCTAssertNotNil(result);
//        [expectation fulfill];
//    }];
//    [[QCloudCOSXMLService defaultCOSXML] GetBucketReplication:request];
//    [self waitForExpectationsWithTimeout:80 handler:nil];
//}
//
//- (void)testBucketReplication3_DeleteBucketReplication {
//    QCloudDeleteBucketReplicationRequest* request = [[QCloudDeleteBucketReplicationRequest alloc] init];
//    request.bucket = @"xiaodaxiansource";
//    XCTestExpectation* expectation = [self expectationWithDescription:@"delete bucket replication" ];
//    [request setFinishBlock:^(id outputObject, NSError* error) {
//        XCTAssertNil(error);
//        [expectation fulfill];
//    }];
//    [[QCloudCOSXMLService defaultCOSXML] DeleteBucketReplication:request];
//    [self waitForExpectationsWithTimeout:80 handler:nil];
//
//}

- (void)testPUT_GETBucketDomain {
    //     XCTestExpectation* expectation = [self expectationWithDescription:@" bucket domain" ];
    //    QCloudPutBucketDomainRequest *req = [QCloudPutBucketDomainRequest new];
    //    req.bucket = @"000001-1253653367";
    //    req.regionName = @"ap-chengdu";
    //    QCloudDomainConfiguration *config = [QCloudDomainConfiguration new];
    //    QCloudDomainRule *rule = [QCloudDomainRule new];
    //    rule.status = QCloudDomainStatueEnabled;
    //    rule.name = @"www.baidu.com";
    //    rule.replace = QCloudCOSDomainReplaceTypeTxt;
    //    rule.type = QCloudCOSDomainTypeRest;
    //    config.rules = @[rule];
    //    req.domain  = config;
    //    [req setFinishBlock:^(id outputObject, NSError *error) {
    //        XCTAssertNotNil(outputObject);
    //        XCTAssertNil(error);
    //
    //        if (!error) {
    //            QCloudGetBucketDomainRequest *getReq =  [QCloudGetBucketDomainRequest new];
    //            getReq.bucket = @"000001-1253653367";
    //            getReq.regionName = @"ap-chengdu";
    //            [getReq setFinishBlock:^(QCloudDomainConfiguration * _Nonnull result, NSError * _Nonnull error) {
    //                QCloudLogDebug(@"%@",result);
    //                [expectation fulfill];
    //            }];
    //             [[QCloudCOSXMLService defaultCOSXML]GetBucketDomain:getReq];
    //        }
    //    }];
    //      [[QCloudCOSXMLService defaultCOSXML]PutBucketDomain:req];
    //    [self waitForExpectationsWithTimeout:1000 handler:nil];
}

//-(void)testPut_Get_DelBucketWebsite{
//    XCTestExpectation* expectation = [self expectationWithDescription:@" bucket domain" ];
//    NSString *bucket = @"000001-1253653367";
//    NSString * regionName = @"ap-chengdu";
//
//    NSString *indexDocumentSuffix = @"index.html";
//    NSString *errorDocKey = @"error.html";
//    NSString *derPro = @"https";
//    int errorCode = 451;
//    NSString * replaceKeyPrefixWith = @"404.html";
//    QCloudPutBucketWebsiteRequest *putReq = [QCloudPutBucketWebsiteRequest new];
//    putReq.bucket = bucket;
//    putReq.regionName = @"ap-chengdu";;
//    QCloudWebsiteConfiguration *config = [QCloudWebsiteConfiguration new];
//
//    QCloudWebsiteIndexDocument *indexDocument = [QCloudWebsiteIndexDocument new];
//    indexDocument.suffix = indexDocumentSuffix;
//    config.indexDocument = indexDocument;
//
//    QCloudWebisteErrorDocument *errDocument = [QCloudWebisteErrorDocument new];
//    errDocument.key = errorDocKey;
//    config.errorDocument = errDocument;
//
//
//    QCloudWebsiteRedirectAllRequestsTo *redir = [QCloudWebsiteRedirectAllRequestsTo new];
//    redir.protocol  = @"https";
//    config.redirectAllRequestsTo = redir;
//
//
//    QCloudWebsiteRoutingRule *rule = [QCloudWebsiteRoutingRule new];
//    QCloudWebsiteCondition *contition = [QCloudWebsiteCondition new];
//    contition.httpErrorCodeReturnedEquals = errorCode;
//    rule.condition = contition;
//
//    QCloudWebsiteRedirect *webRe = [QCloudWebsiteRedirect new];
//    webRe.protocol = @"https";
//    webRe.replaceKeyPrefixWith = replaceKeyPrefixWith;
//    rule.redirect = webRe;
//
//    QCloudWebsiteRoutingRules *routingRules = [QCloudWebsiteRoutingRules new];
//    routingRules.routingRule = @[rule];
//    config.rules = routingRules;
//    putReq.websiteConfiguration  = config;
//
//
//    [putReq setFinishBlock:^(id outputObject, NSError *error) {
//        XCTAssertNil(error);
//        XCTAssertNotNil(outputObject);
//        if (!error) {
//            QCloudGetBucketWebsiteRequest *getReq = [QCloudGetBucketWebsiteRequest new];
//            getReq.bucket = bucket;
//            getReq.regionName = regionName;
//            [getReq setFinishBlock:^(QCloudWebsiteConfiguration * _Nonnull result, NSError * _Nonnull error) {
//                XCTAssertNil(error);
//                XCTAssertNotNil(result);
//                XCTAssertEqualObjects(result.errorDocument.key, errorDocKey);
//                XCTAssertEqualObjects(result.indexDocument.suffix, indexDocumentSuffix);
//                XCTAssertEqualObjects(result.redirectAllRequestsTo.protocol,derPro);
//                if (!error) {
//                    QCloudDeleteBucketWebsiteRequest *delReq = [QCloudDeleteBucketWebsiteRequest new];
//                    delReq.bucket = bucket;
//                    delReq.regionName = regionName;
//                    [delReq setFinishBlock:^(id outputObject, NSError *error) {
//                        XCTAssertNil(error);
//                        XCTAssertNotNil(outputObject);
//                        [expectation fulfill];
//                    }];
//                    [[QCloudCOSXMLService defaultCOSXML] DeleteBucketWebsite:delReq];
//                }
//
//
//            }];
//            [[QCloudCOSXMLService defaultCOSXML] GetBucketWebsite:getReq];
//        }
//
//
//    }];
//
//    [[QCloudCOSXMLService defaultCOSXML] PutBucketWebsite:putReq];
//    [self waitForExpectationsWithTimeout:200 handler:nil];
//}
//
//-(void)testPUT_GETBucketLogging{
//    XCTestExpectation* exp = [self expectationWithDescription:@"Put Bucket Versioning first "];
//    QCloudPutBucketLoggingRequest *request = [QCloudPutBucketLoggingRequest new];
//    QCloudBucketLoggingStatus *status = [QCloudBucketLoggingStatus new];
//    QCloudLoggingEnabled *loggingEnabled = [QCloudLoggingEnabled new];
//    loggingEnabled.targetBucket = @"1504078136-1253653367";
//    loggingEnabled.targetPrefix = @"mylogs";
//    status.loggingEnabled = loggingEnabled;
//    request.bucketLoggingStatus = status;
//    request.bucket = @"1504078136-1253653367";
//    [request setFinishBlock:^(id outputObject, NSError *error) {
//        XCTAssertNil(error);
//        XCTAssertNotNil(outputObject);
//        NSLog(@"logging result = %@",outputObject);
//
//        QCloudGetBucketLoggingRequest *getReq = [QCloudGetBucketLoggingRequest new];
//        getReq.bucket = @"1504078136-1253653367";
//        [getReq setFinishBlock:^(QCloudBucketLoggingStatus * _Nonnull result, NSError * _Nonnull error) {
//            NSLog(@"getReq result = %@",result.loggingEnabled.targetBucket);
//            XCTAssertNil(error);
//             XCTAssertNotNil(result);
//            [exp fulfill];
//        }];
//        [[QCloudCOSXMLService defaultCOSXML]GetBucketLogging:getReq];
//
//    }];
//    [[QCloudCOSXMLService defaultCOSXML] PutBucketLogging:request];
//     [self waitForExpectationsWithTimeout:100 handler:nil];
//
//}
//
//- (void)testPUT_GET_Delete_ListBucketInventory{
//
//    XCTestExpectation* exp = [self expectationWithDescription:@"Put Bucket Versioning first "];
//    QCloudPutBucketInventoryRequest *putReq = [QCloudPutBucketInventoryRequest new];
//    putReq.bucket= @"1504078136-1253653367";
//    putReq.inventoryID = @"list1";
//    QCloudInventoryConfiguration *config = [QCloudInventoryConfiguration new];
//    config.identifier = @"list1";
//    config.isEnabled = @"True";
//    QCloudInventoryDestination *des = [QCloudInventoryDestination new];
//    QCloudInventoryBucketDestination *btDes =[QCloudInventoryBucketDestination new];
//    btDes.cs = @"CSV";
//    btDes.account = @"1278687956";
//    btDes.bucket  = @"qcs::cos:ap-guangzhou::1504078136-1253653367";
//    btDes.prefix = @"list1";
//    QCloudInventoryEncryption *enc = [QCloudInventoryEncryption new];
//    enc.ssecos = @"";
//    btDes.encryption = enc;
//    des.bucketDestination = btDes;
//    config.destination = des;
//    QCloudInventorySchedule *sc = [QCloudInventorySchedule new];
//    sc.frequency = @"Daily";
//    config.schedule = sc;
//    QCloudInventoryFilter *fileter = [QCloudInventoryFilter new];
//    fileter.prefix = @"myPrefix";
//    config.filter = fileter;
//    config.includedObjectVersions = QCloudCOSIncludedObjectVersionsAll;
//    QCloudInventoryOptionalFields *fields = [QCloudInventoryOptionalFields new];
//    fields.field = @[ @"Size",@"LastModifiedDate",@"ETag",@"StorageClass",@"IsMultipartUploaded",@"ReplicationStatus"];
//    config.optionalFields = fields;
//    putReq.inventoryConfiguration = config;
//    [putReq setFinishBlock:^(id outputObject, NSError *error) {
//        XCTAssertNil(error);
//        XCTAssertNotNil(outputObject);
//        NSLog(@"Inventory outputObject %@",outputObject);
//        QCloudGetBucketInventoryRequest *getReq = [QCloudGetBucketInventoryRequest new];
//        getReq.bucket = @"1504078136-1253653367";
//        getReq.inventoryID = @"list1";
//        [getReq setFinishBlock:^(QCloudInventoryConfiguration * _Nonnull result, NSError * _Nonnull error) {
//            XCTAssertNotNil(result);
//            NSLog(@"outputObject result %@",result.optionalFields.field);
//            XCTAssertNil(error);
//            QCloudListBucketInventoryConfigurationsRequest *req = [QCloudListBucketInventoryConfigurationsRequest new];
//            req.bucket = @"1504078136-1253653367";
//            [req setFinishBlock:^(QCloudListInventoryConfigurationResult * _Nonnull result, NSError * _Nonnull error) {
//                XCTAssertNil(error);
//                XCTAssertNotNil(result);
//                QCloudInventoryConfiguration *config = result.inventoryConfiguration[0];
//                XCTAssertNotNil(config.optionalFields);
//                QCloudDeleteBucketInventoryRequest *delReq = [QCloudDeleteBucketInventoryRequest new];
//                delReq.bucket = @"1504078136-1253653367";
//                delReq.inventoryID = @"list1";
//                [delReq setFinishBlock:^(id outputObject, NSError *error) {
//                    XCTAssertNotNil(outputObject);
//                    XCTAssertNil(error);
//                    [exp fulfill];
//                }];
//                [[QCloudCOSXMLService defaultCOSXML] DeleteBucketInventory:delReq];
//            }];
//            [[QCloudCOSXMLService defaultCOSXML]ListBucketInventory:req];
//
//    }];
//    [[QCloudCOSXMLService defaultCOSXML] GetBucketInventory:getReq];
//
//    }];
//    [[QCloudCOSXMLService defaultCOSXML] PutBucketInventory:putReq];
//  [self waitForExpectationsWithTimeout:100 handler:nil];
//}

//-(void)testPUT_GET_DeleteBucketTagging{
//
//    XCTestExpectation *exp = [self expectationWithDescription:@"bucket tagging exp"];
//    QCloudPutBucketTaggingRequest *putReq = [QCloudPutBucketTaggingRequest new];
//    putReq.bucket = @"1504078136-1253653367";
//    QCloudBucketTagging *taggings = [QCloudBucketTagging new];
//    QCloudBucketTag *tag1 = [QCloudBucketTag new];
//    QCloudBucketTagSet *tagSet = [QCloudBucketTagSet new];
//    taggings.tagSet = tagSet;
//    tag1.key = @"age";
//    tag1.value = @"20";
//    QCloudBucketTag *tag2 = [QCloudBucketTag new];
//    tag2.key = @"name";
//    tag2.value = @"karis";
//    tagSet.tag = @[tag1,tag2];
//    putReq.taggings = taggings;
//
//    [putReq setFinishBlock:^(id outputObject, NSError *error) {
//        XCTAssertNil(error);
//        XCTAssertNotNil(outputObject);
//
//        QCloudGetBucketTaggingRequest *getReq = [QCloudGetBucketTaggingRequest new];
//        getReq.bucket = @"1504078136-1253653367";
//        [getReq setFinishBlock:^(QCloudBucketTagging * _Nonnull result, NSError * _Nonnull error) {
//            XCTAssertNil(error);
//            XCTAssertNotNil(result);
//            XCTAssertEqual(result.tagSet.tag.count, tagSet.tag.count);
//            QCloudDeleteBucketTaggingRequest *delReq = [QCloudDeleteBucketTaggingRequest new];
//            delReq.bucket =  @"1504078136-1253653367";
//            [delReq setFinishBlock:^(id outputObject, NSError *error) {
//                XCTAssertNil(error);
//                XCTAssertNotNil(outputObject);
//                 [exp fulfill];
//            }];
//            [[QCloudCOSXMLService defaultCOSXML] DeleteBucketTagging:delReq];
//
//
//        }];
//        [[QCloudCOSXMLService defaultCOSXML] GetBucketTagging:getReq];
//
//    }];
//    [[QCloudCOSXMLService defaultCOSXML] PutBucketTagging:putReq];
//    [self waitForExpectationsWithTimeout:200 handler:nil];
//
//
//}
//-(void)testPUT_GET_DeleteObjectTagging{
//
//
//
//
//}
//
- (void)testPUT_GETBucketAccelerate {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Put Object Copy"];
    QCloudPutBucketAccelerateRequest *req = [QCloudPutBucketAccelerateRequest new];
    req.bucket = self.bucket;
    QCloudBucketAccelerateConfiguration *config = [QCloudBucketAccelerateConfiguration new];
    config.status = QCloudCOSBucketAccelerateStatusEnabled;
    req.configuration = config;
    [req setFinishBlock:^(id _Nullable outputObject, NSError *_Nullable error) {
        if (!error) {
            QCloudGetBucketAccelerateRequest *get = [QCloudGetBucketAccelerateRequest new];
            get.bucket = self.bucket;
            [get setFinishBlock:^(QCloudBucketAccelerateConfiguration *_Nullable result, NSError *_Nullable error) {
                XCTAssertNil(error);
                [expectation fulfill];
            }];
            [[QCloudCOSXMLService defaultCOSXML] GetBucketAccelerate:get];
        } else {
            XCTAssertNil(error);
            [expectation fulfill];
        }
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutBucketAccelerate:req];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

- (void)testPUT_GETBucketIntelligentTiering {
    XCTestExpectation *exp = [self expectationWithDescription:@"IntelligentTiering"];
    QCloudPutBucketIntelligentTieringRequest *put = [QCloudPutBucketIntelligentTieringRequest new];
    put.bucket = self.bucket;
    QCloudIntelligentTieringConfiguration *config = [QCloudIntelligentTieringConfiguration new];
    config.status = QCloudintelligentTieringStatusEnabled;
    QCloudIntelligentTieringTransition *transition = [QCloudIntelligentTieringTransition new];
    transition.days = 30;
    config.transition = transition;
    put.intelligentTieringConfiguration = config;
    [put setFinishBlock:^(id _Nullable outputObject, NSError *_Nullable error) {
        XCTAssertNil(error);
        if (!error) {
            QCloudGetBucketIntelligentTieringRequest *get = [QCloudGetBucketIntelligentTieringRequest new];
            get.bucket = self.bucket;
            [get setFinishBlock:^(QCloudIntelligentTieringConfiguration *_Nonnull result, NSError *_Nonnull error) {
                XCTAssertNil(error);
                XCTAssertEqual(result.status, QCloudintelligentTieringStatusEnabled);
                [exp fulfill];
            }];
            [[QCloudCOSXMLService defaultCOSXML] GetBucketIntelligentTiering:get];
        } else {
            [exp fulfill];
        }
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutBucketIntelligentTiering:put];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}
@end
