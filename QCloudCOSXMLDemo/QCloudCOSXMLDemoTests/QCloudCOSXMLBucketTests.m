//
//  QCloudCOSXMLBucketTests.m
//  QCloudCOSXMLDemo
//
//  Created by Dong Zhao on 2017/6/8.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <QCloudCOSXML/QCloudCOSXML.h>
#import <QCloudCore/QCloudConfiguration_Private.h>
#import <QCloudCore/QCloudAuthentationCreator.h>
#import <QCloudCore/QCloudCredential.h>

#import "TestCommonDefine.h"
#import "QCloudCOSXMLServiceUtilities.h"
#import "QCloudTestTempVariables.h"
#import "QCloudCOSXMLTestUtility.h"
#import "SecretStorage.h"

#define COS_TEST_BUCKET_KEY @"bucket"

@interface QCloudCOSXMLBucketTests : XCTestCase <QCloudSignatureProvider>
@property (nonatomic, strong) NSString *authorizedUIN;
@property (nonatomic, strong) NSString *ownerUIN;
@property (nonatomic, strong) NSString *appID;
@end
static QCloudBucket *gCosxmlTestBucket;
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
    configuration.appID = self.appID;
    configuration.signatureProvider = self;
    QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.regionName = @"ap-beijing";
    configuration.endpoint = endpoint;
    [QCloudCOSXMLService registerCOSXMLWithConfiguration:configuration withKey:@"aclService"];
}

+ (void)setUp {
    gCosxmlTestBucket = [[QCloudCOSXMLTestUtility sharedInstance] createTestBucketWithPrefix:COS_TEST_BUCKET_KEY];
}

+ (void)tearDown {
    [[QCloudCOSXMLTestUtility sharedInstance] deleteTestBucket:gCosxmlTestBucket];
}

- (void)setUp {
    [super setUp];
    [self setupSpecialCOSXMLShareService];
    self.appID = [SecretStorage sharedInstance].appID;
    self.authorizedUIN = [SecretStorage sharedInstance].uin;
    self.ownerUIN = [SecretStorage sharedInstance].uin;
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
        gCosxmlTestBucket.name = bucketName;
        [QCloudTestTempVariables sharedInstance].testBucket = bucketName;
        responseError = error;
        [exception fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutBucket:request];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    //    [[QCloudCOSXMLTestUtility sharedInstance] deleteTestBucket:gCosxmlTestBucket.name];
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
    putBucketRequest.regionName = @"ap-beijing";
    putBucketRequest.bucket = [NSString stringWithFormat:@"newbucketcanbedelete%i", arc4random() % 1000];
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
    NSString *bucketName = [NSString stringWithFormat:@"newbucketcanbedelete%i", arc4random() % 1000];
    NSLog(@"---- %@", bucketName);
    putBucketRequest.bucket = bucketName;

    putBucketRequest.regionName = @"ap-beijing-1";
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

- (void)testPutBucket {
    QCloudPutBucketRequest* putBucketRequest = [[QCloudPutBucketRequest alloc] init];
    putBucketRequest.bucket = @"v4-yfb-bucket";
    XCTestExpectation* expectation = [self expectationWithDescription:@"putBucket"];

    [putBucketRequest setFinishBlock:^(id outputObject, NSError *error) {
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutBucket:putBucketRequest];
    [self waitForExpectationsWithTimeout:80 handler:nil];

}

- (void)testGetBucket {
    QCloudGetBucketRequest *request = [QCloudGetBucketRequest new];
    request.bucket = gCosxmlTestBucket.name;
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
    XCTAssert([listResultName isEqualToString:gCosxmlTestBucket.name]);
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
    putCORS.bucket = gCosxmlTestBucket.name;
    __block NSError *localError;
    XCTestExpectation *exp = [self expectationWithDescription:@"testCORS1_PutBucketCORS"];
    [putCORS setFinishBlock:^(id outputObject, NSError *error) {
        localError = error;
        
        QCloudGetBucketCORSRequest *corsReqeust = [QCloudGetBucketCORSRequest new];
        corsReqeust.bucket = gCosxmlTestBucket.name;
        
        [corsReqeust setFinishBlock:^(QCloudCORSConfiguration *_Nonnull result, NSError *_Nonnull error) {
            XCTAssertNil(error);
            
            [exp fulfill];
        }];
        
        [[QCloudCOSXMLService defaultCOSXML] GetBucketCORS:corsReqeust];
        
        
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutBucketCORS:putCORS];
    [self waitForExpectationsWithTimeout:20 handler:nil];
    XCTAssertNil(localError);
}

- (void)testCORS2_GetBucketCORS {
    QCloudPutBucketCORSRequest *putCORS = [QCloudPutBucketCORSRequest new];
    QCloudCORSConfiguration *putCors = [QCloudCORSConfiguration new];

    QCloudCORSRule *rule = [QCloudCORSRule new];
    rule.identifier = @"sdk1";
    rule.allowedHeader = @[ @"origin", @"accept", @"content-type", @"authorization" ];
    rule.exposeHeader = @"ETag";
    rule.allowedMethod = @[ @"GET", @"PUT", @"POST", @"DELETE", @"HEAD" ];
    rule.maxAgeSeconds = 3600;
    rule.allowedOrigin = @"*";

    putCors.rules = @[ rule ];

    putCORS.corsConfiguration = putCors;
    putCORS.bucket = gCosxmlTestBucket.name;
    __block NSError *localError1;

    __block QCloudCORSConfiguration *cors;
    __block XCTestExpectation *exp = [self expectationWithDescription:@"delete"];

    [putCORS setFinishBlock:^(id outputObject, NSError *error) {
        QCloudGetBucketCORSRequest *corsReqeust = [QCloudGetBucketCORSRequest new];
        corsReqeust.bucket = gCosxmlTestBucket.name;

        [corsReqeust setFinishBlock:^(QCloudCORSConfiguration *_Nonnull result, NSError *_Nonnull error) {
            XCTAssertNil(error);
            cors = result;
            [exp fulfill];
        }];

        [[QCloudCOSXMLService defaultCOSXML] GetBucketCORS:corsReqeust];
    }];

    [[QCloudCOSXMLService defaultCOSXML] PutBucketCORS:putCORS];
    [self waitForExpectationsWithTimeout:120
                                 handler:^(NSError *_Nullable error) {
                                     NSLog(@"请求超时");
                                 }];
    XCTAssertNotNil(cors);
    XCTAssert([[[cors.rules firstObject] identifier] isEqualToString:@"sdk1"]);
    XCTAssertEqual(1, cors.rules.count);
    XCTAssertEqual([cors.rules.firstObject.allowedMethod count], 5);
    XCTAssert([cors.rules.firstObject.allowedMethod containsObject:@"PUT"]);
    XCTAssert([cors.rules.firstObject.allowedHeader count] == 4);
    XCTAssert([cors.rules.firstObject.exposeHeader isEqualToString:@"ETag"]);
}

- (void)testCORS3_OpetionObject {
    QCloudOptionsObjectRequest *request = [[QCloudOptionsObjectRequest alloc] init];
    request.bucket = gCosxmlTestBucket.name;
    request.origin = @"http://www.qcloud.com";
    request.accessControlRequestMethod = @"GET";
    request.accessControlRequestHeaders = @"origin";
    request.object = [[QCloudCOSXMLTestUtility sharedInstance] uploadTempObjectInBucket:gCosxmlTestBucket.name];
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
    
    NSError * lError;
    [deleteCORS buildRequestData:&lError];
    XCTAssertNotNil(lError);
    
    deleteCORS.bucket = gCosxmlTestBucket.name;
    deleteCORS.bucket = gCosxmlTestBucket.name;


    NSLog(@"test");

    __block NSError *localError;
    XCTestExpectation *exp = [self expectationWithDescription:@"testCORS4_DeleteBucketCORS"];
    [deleteCORS setFinishBlock:^(id outputObject, NSError *error) {
        localError = error;
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] DeleteBucketCORS:deleteCORS];
    [self waitForExpectationsWithTimeout:80 handler:nil];
    XCTAssertNil(localError);
}

- (void)testGetBucketLocation {
    QCloudGetBucketLocationRequest *locationReq = [QCloudGetBucketLocationRequest new];
    locationReq.bucket = gCosxmlTestBucket.name;
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
    currentLocation = @"ap-beijing";
#else
    currentLocation = @"ap-beijing";
#endif
    XCTAssert([location.locationConstraint isEqualToString:[SecretStorage sharedInstance].region]);
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
    o.identifier = [NSString stringWithFormat:@"qcs::cam::uin/%@:uin/%@",self.ownerUIN,self.ownerUIN];
    policy.owner = o;

    QCloudAccessControlList *list = [QCloudAccessControlList new];
    policy.accessControlList = list;

    NSMutableArray<QCloudACLGrant *> *aclGrants = [NSMutableArray array];

    list.ACLGrants = aclGrants;

    QCloudACLGrant *g1 = [QCloudACLGrant new];
    QCloudACLGrantee *t1 = [QCloudACLGrantee new];
    t1.identifier = [NSString stringWithFormat:@"qcs::cam::uin/%@:uin/%@",self.ownerUIN,self.ownerUIN];
    g1.grantee = t1;
    g1.permission = QCloudCOSPermissionRead;

    QCloudACLGrant *g2 = [QCloudACLGrant new];
    QCloudACLGrantee *t2 = [QCloudACLGrantee new];
    t2.identifier = @"qcs::cam::uin/100011548427:uin/100011548427";
    g2.grantee = t2;
    g2.permission = QCloudCOSPermissionWrite;

    [aclGrants addObject:g1];
    [aclGrants addObject:g2];
    putACL.bucket = gCosxmlTestBucket.name;
    XCTestExpectation *exp = [self expectationWithDescription:@"putacl"];
    __block NSError *localError;
    [putACL setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error);
        QCloudGetBucketACLRequest *getBucketACLRequest = [[QCloudGetBucketACLRequest alloc] init];
        getBucketACLRequest.bucket = gCosxmlTestBucket.name;
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
    request.bucket = gCosxmlTestBucket.name;
    XCTestExpectation *exp = [self expectationWithDescription:@"testHeadBucket"];

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
    uploadObjectRequest.bucket = gCosxmlTestBucket.name;
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
    request.bucket = gCosxmlTestBucket.name;
    request.object = uploadObjectRequest.object;
    request.uploadId = uploadID;

    NSArray * actions = @[@"name/cos:InitiateMultipartUpload",
                          @"name/cos:ListParts",
                          @"name/cos:UploadPart",
                          @"name/cos:CompleteMultipartUpload",
                          @"name/cos:AbortMultipartUpload"
    ];
    
    for (NSDictionary * dic in request.scopesArray) {
        NSString *action = dic[@"action"];
        XCTAssertTrue([actions containsObject:action]);
    }
    
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
    uploads.bucket = gCosxmlTestBucket.name;
    uploads.maxUploads = 1000;
    __block NSError *localError;
    __block QCloudListMultipartUploadsResult *multiPartUploadsResult;
    XCTestExpectation *exp = [self expectationWithDescription:@"testListBucketUploads"];
    [uploads setFinishBlock:^(QCloudListMultipartUploadsResult *result, NSError *error) {
        multiPartUploadsResult = result;
        localError = error;
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] ListBucketMultipartUploads:uploads];
    [self waitForExpectationsWithTimeout:20 handler:nil];

    for (NSDictionary * dic in uploads.scopesArray) {
        NSString * action = dic[@"action"];
        XCTAssertTrue([action isEqualToString:@"name/cos:ListMultipartUploads"]);
        NSLog(@"%@",action);
    }
    
    XCTAssertNil(localError);
    XCTAssert(multiPartUploadsResult.maxUploads == 1000);
    XCTAssert([multiPartUploadsResult.bucket isEqualToString:gCosxmlTestBucket.name]);
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
    request.bucket = gCosxmlTestBucket.name;
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
        request.bucket = gCosxmlTestBucket.name;
        [request setFinishBlock:^(QCloudLifecycleConfiguration *getLifecycleReuslt, NSError *getLifeCycleError) {
            XCTAssertNil(getLifeCycleError);
            XCTAssertNotNil(getLifecycleReuslt);
            XCTAssert(getLifecycleReuslt.rules.count == configuration.rules.count);
            XCTAssert([getLifecycleReuslt.rules.firstObject.identifier isEqualToString:configuration.rules.firstObject.identifier]);
            XCTAssert(getLifecycleReuslt.rules.firstObject.status == configuration.rules.firstObject.status);

            // delete configuration
            QCloudDeleteBucketLifeCycleRequest *request = [[QCloudDeleteBucketLifeCycleRequest alloc] init];
            request.bucket = gCosxmlTestBucket.name;
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
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Put Bucket Versioning"];
    
    QCloudPutBucketVersioningRequest *request = [[QCloudPutBucketVersioningRequest alloc] init];
    request.bucket = gCosxmlTestBucket.name;
    request.regionName = gCosxmlTestBucket.location;
    QCloudBucketVersioningConfiguration *configuration = [[QCloudBucketVersioningConfiguration alloc] init];
    request.configuration = configuration;
    configuration.status = QCloudCOSBucketVersioningStatusEnabled;
    
    [request setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error);

        QCloudGetBucketVersioningRequest *request = [[QCloudGetBucketVersioningRequest alloc] init];
        request.bucket = gCosxmlTestBucket.name;
        [request setFinishBlock:^(QCloudBucketVersioningConfiguration *result, NSError *error) {
            XCTAssert(result);
            XCTAssertNil(error);
            [expectation fulfill];
        }];
        [[QCloudCOSXMLService defaultCOSXML] GetBucketVersioning:request];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutBucketVersioning:request];
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)testPut_Get_Delte_BucketReplication {
   __block NSString *sourceBucket = gCosxmlTestBucket.name;
     __block NSString *destinationBucket = @"replication-destination";
     __block NSString *destinationRegion = @"ap-beijing";
    
     // enable bucket versioning first
    
     XCTestExpectation *putReplicationExpectation = [self expectationWithDescription:@"Put Bucket Versioning first "];
     // put bucket replication
     QCloudPutBucketReplicationRequest *request = [[QCloudPutBucketReplicationRequest alloc] init];
     request.bucket = sourceBucket;
     QCloudBucketReplicationConfiguation *configuration = [[QCloudBucketReplicationConfiguation alloc] init];
     configuration.role = [NSString identifierStringWithID:self.appID:self.appID];
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
         
         if ([error.userInfo[@"Code"] isEqualToString:@"InvalidBucketState"]) {
//             需要开启桶多版本状态
             [putReplicationExpectation fulfill];
             return;
         }
         
         XCTAssertNil(error);
         sleep(5);
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
                 [putReplicationExpectation fulfill];
             }];
             [[QCloudCOSXMLService defaultCOSXML] DeleteBucketReplication:request];
             // delete bucket replication end
         }];
         dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
         dispatch_semaphore_wait(semaphore, 5 * NSEC_PER_SEC);
         [[QCloudCOSXMLService defaultCOSXML] GetBucketReplication:request];
        
         // get bucket replication end
     }];
    
     // put bucket replication end
     [[QCloudCOSXMLService defaultCOSXML] PutBucketRelication:request];
     [self waitForExpectationsWithTimeout:80 handler:nil];
}
//
- (void)testNewPut_Get_DeleteBucketReplication {
    NSMutableString* tempBucket = [@"bucketcanbedelete" mutableCopy];
    NSDate *newDate = [NSDate date];
    long int timeSp = (long)[newDate timeIntervalSince1970];

    [tempBucket appendString:[NSString stringWithFormat:@"%ld", timeSp]];
    [tempBucket appendFormat:@"%i", arc4random() % 3000];
    
    // Put a temp bucket for testing first.
    XCTestExpectation* putBucketExpectation = [self expectationWithDescription:@"Put temp bucket"];
    QCloudPutBucketRequest* putBucketRequest = [[QCloudPutBucketRequest alloc] init];
    putBucketRequest.bucket = tempBucket;
    [putBucketRequest setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error,@"Put Bucket error!");
        [putBucketExpectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutBucket:putBucketRequest];
    [self waitForExpectationsWithTimeout:80 handler:nil];


    // Then enable replication for source bucket;
    XCTestExpectation* putReplicationExpectation = [self expectationWithDescription:@"put replication expectation"];
    QCloudPutBucketReplicationRequest* request = [[QCloudPutBucketReplicationRequest alloc] init];
    // 存储桶名称，格式为 BucketName-APPID
    request.bucket = tempBucket;

    // 说明所有跨地域配置信息
    QCloudBucketReplicationConfiguation* replConfiguration =
                                [[QCloudBucketReplicationConfiguation alloc] init];

    // 发起者身份标示
    replConfiguration.role = @"qcs::cam::uin/100000000001:uin/100000000001";

    // 具体配置信息
    QCloudBucketReplicationRule* rule = [[QCloudBucketReplicationRule alloc] init];

    // 用来标注具体 Rule 的名称
    rule.identifier = @"identifier";
    rule.status = QCloudCOSXMLStatusEnabled;

    // 资源标识符
    QCloudBucketReplicationDestination* destination = [[QCloudBucketReplicationDestination alloc] init];
    NSString* destinationBucket = @"destinationbucket-1250000000";

    // 目标存储桶所在地域
    NSString* region = @"ap-beijing";
    destination.bucket = [NSString stringWithFormat:@"qcs::cos:%@::%@",region,destinationBucket];

    // 目标存储桶信息
    rule.destination = destination;

    // 前缀匹配策略，不可重叠，重叠返回错误。前缀匹配根目录为空
    rule.prefix = @"prefix1";
    replConfiguration.rule = @[rule];
    request.configuation = replConfiguration;

    [request setFinishBlock:^(id outputObject, NSError* error) {

        // outputObject 包含所有的响应 http 头部
        NSDictionary* info = (NSDictionary *) outputObject;
        [putReplicationExpectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutBucketRelication:request];
    [self waitForExpectationsWithTimeout:80 handler:nil];


}

- (void)testPUT_GETBucketDomain {
         XCTestExpectation* expectation = [self expectationWithDescription:@" bucket domain" ];
        QCloudPutBucketDomainRequest *req = [QCloudPutBucketDomainRequest new];
        req.bucket = gCosxmlTestBucket.name;
        req.regionName = [SecretStorage sharedInstance].region;
        QCloudDomainConfiguration *config = [QCloudDomainConfiguration new];
        QCloudDomainRule *rule = [QCloudDomainRule new];
        rule.status = QCloudDomainStatueEnabled;
        rule.name = @"www.example.com";
//        rule.replace = QCloudCOSDomainReplaceTypeCname;
        rule.type = QCloudCOSDomainTypeRest;
        config.rules = @[rule];
        req.domain  = config;
        [req setFinishBlock:^(id outputObject, NSError *error) {
            
            if ([error.userInfo[@"Code"] isEqualToString:@"DomainAuditFailed"]) {
                XCTAssertNil(nil);
            }else{
                XCTAssertNotNil(outputObject);
                XCTAssertNil(error);
            }
           
            QCloudGetBucketDomainRequest *getReq =  [QCloudGetBucketDomainRequest new];
        
            NSError * localError;
            [getReq buildRequestData:&localError];
            XCTAssertNotNil(localError);
            getReq.bucket = gCosxmlTestBucket.name;
            [getReq buildRequestData:&localError];
            XCTAssertNotNil(localError);
            getReq.regionName = [SecretStorage sharedInstance].region;
            [getReq setFinishBlock:^(QCloudDomainConfiguration * _Nonnull result, NSError * _Nonnull error) {
                QCloudLogDebug(@"%@",result);
                [expectation fulfill];
            }];
            [[QCloudCOSXMLService defaultCOSXML]GetBucketDomain:getReq];
           
        }];
        [[QCloudCOSXMLService defaultCOSXML]PutBucketDomain:req];
        [self waitForExpectationsWithTimeout:1000 handler:nil];
}

-(void)testPut_Get_DelBucketWebsite{
    XCTestExpectation* expectation = [self expectationWithDescription:@" bucket domain" ];
    NSString *bucket = gCosxmlTestBucket.name;
    NSString * regionName = gCosxmlTestBucket.location;

    NSString *indexDocumentSuffix = @"index.html";
    NSString *errorDocKey = @"error.html";
    NSString *derPro = @"https";
    int errorCode = 451;
    NSString * replaceKeyPrefixWith = @"404.html";
    QCloudPutBucketWebsiteRequest *putReq = [QCloudPutBucketWebsiteRequest new];
    putReq.bucket = bucket;
    putReq.regionName = [SecretStorage sharedInstance].region;;
    QCloudWebsiteConfiguration *config = [QCloudWebsiteConfiguration new];

    QCloudWebsiteIndexDocument *indexDocument = [QCloudWebsiteIndexDocument new];
    indexDocument.suffix = indexDocumentSuffix;
    config.indexDocument = indexDocument;

    QCloudWebisteErrorDocument *errDocument = [QCloudWebisteErrorDocument new];
    errDocument.key = errorDocKey;
    config.errorDocument = errDocument;


    QCloudWebsiteRedirectAllRequestsTo *redir = [QCloudWebsiteRedirectAllRequestsTo new];
    redir.protocol  = @"https";
    config.redirectAllRequestsTo = redir;


    QCloudWebsiteRoutingRule *rule = [QCloudWebsiteRoutingRule new];
    QCloudWebsiteCondition *contition = [QCloudWebsiteCondition new];
    contition.httpErrorCodeReturnedEquals = errorCode;
    rule.condition = contition;

    QCloudWebsiteRedirect *webRe = [QCloudWebsiteRedirect new];
    webRe.protocol = @"https";
    webRe.replaceKeyPrefixWith = replaceKeyPrefixWith;
    rule.redirect = webRe;

    QCloudWebsiteRoutingRules *routingRules = [QCloudWebsiteRoutingRules new];
    routingRules.routingRule = @[rule];
    config.rules = routingRules;
    putReq.websiteConfiguration  = config;


    [putReq setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);
        QCloudGetBucketWebsiteRequest *getReq = [QCloudGetBucketWebsiteRequest new];
        getReq.bucket = bucket;
        getReq.regionName = regionName;
        [getReq setFinishBlock:^(QCloudWebsiteConfiguration * _Nonnull result, NSError * _Nonnull error) {
            XCTAssertNil(error);
            XCTAssertNotNil(result);
            XCTAssertEqualObjects(result.errorDocument.key, errorDocKey);
            XCTAssertEqualObjects(result.indexDocument.suffix, indexDocumentSuffix);
            XCTAssertEqualObjects(result.redirectAllRequestsTo.protocol,derPro);
            QCloudDeleteBucketWebsiteRequest *delReq = [QCloudDeleteBucketWebsiteRequest new];
            
            NSError * localError;
            [delReq buildRequestData:&localError];
            XCTAssertNotNil(localError);
            
            delReq.bucket = bucket;
            delReq.regionName = regionName;
            [delReq setFinishBlock:^(id outputObject, NSError *error) {
                XCTAssertNil(error);
                XCTAssertNotNil(outputObject);
                [expectation fulfill];
            }];
            [[QCloudCOSXMLService defaultCOSXML] DeleteBucketWebsite:delReq];

        }];
        [[QCloudCOSXMLService defaultCOSXML] GetBucketWebsite:getReq];
    }];

    [[QCloudCOSXMLService defaultCOSXML] PutBucketWebsite:putReq];
    [self waitForExpectationsWithTimeout:200 handler:nil];
}
//
-(void)testPUT_GETBucketLogging{
    XCTestExpectation* exp = [self expectationWithDescription:@"Put Bucket Versioning first "];
    QCloudPutBucketLoggingRequest *request = [QCloudPutBucketLoggingRequest new];
    QCloudBucketLoggingStatus *status = [QCloudBucketLoggingStatus new];
    QCloudLoggingEnabled *loggingEnabled = [QCloudLoggingEnabled new];
    loggingEnabled.targetBucket = gCosxmlTestBucket.name;
    loggingEnabled.targetPrefix = @"mylogs";
    status.loggingEnabled = loggingEnabled;
    request.bucketLoggingStatus = status;
    request.bucket = gCosxmlTestBucket.name;
    request.regionName = gCosxmlTestBucket.location;
    [request setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);
        NSLog(@"logging result = %@",outputObject);

        QCloudGetBucketLoggingRequest *getReq = [QCloudGetBucketLoggingRequest new];
        getReq.bucket = gCosxmlTestBucket.name;
        getReq.regionName = gCosxmlTestBucket.location;
        [getReq setFinishBlock:^(QCloudBucketLoggingStatus * _Nonnull result, NSError * _Nonnull error) {
            NSLog(@"getReq result = %@",result.loggingEnabled.targetBucket);
            XCTAssertNil(error);
             XCTAssertNotNil(result);
            [exp fulfill];
        }];
        [[QCloudCOSXMLService defaultCOSXML]GetBucketLogging:getReq];

    }];
    [[QCloudCOSXMLService defaultCOSXML] PutBucketLogging:request];
     [self waitForExpectationsWithTimeout:100 handler:nil];

}

//
- (void)testPUT_GET_Delete_ListBucketInventory{

    XCTestExpectation* exp = [self expectationWithDescription:@"Put Bucket Versioning first "];
    QCloudPutBucketInventoryRequest *putReq = [QCloudPutBucketInventoryRequest new];
    putReq.bucket= gCosxmlTestBucket.name;
    putReq.inventoryID = @"list1";
    QCloudInventoryConfiguration *config = [QCloudInventoryConfiguration new];
    config.identifier = @"list1";
    config.isEnabled = @"True";
    QCloudInventoryDestination *des = [QCloudInventoryDestination new];
    QCloudInventoryBucketDestination *btDes =[QCloudInventoryBucketDestination new];
    btDes.cs = @"CSV";
    btDes.account = @"1253960454";
    btDes.bucket  = @"qcs::cos:ap-beijing::cos-sdk-citest-1253960454";
    btDes.prefix = @"list1";
    QCloudInventoryEncryption *enc = [QCloudInventoryEncryption new];
    enc.ssecos = @"";
    btDes.encryption = enc;
    des.bucketDestination = btDes;
    config.destination = des;
    QCloudInventorySchedule *sc = [QCloudInventorySchedule new];
    sc.frequency = @"Daily";
    config.schedule = sc;
    QCloudInventoryFilter *fileter = [QCloudInventoryFilter new];
    fileter.prefix = @"myPrefix";
    config.filter = fileter;
    config.includedObjectVersions = QCloudCOSIncludedObjectVersionsAll;
    QCloudInventoryOptionalFields *fields = [QCloudInventoryOptionalFields new];
    fields.field = @[ @"Size",@"LastModifiedDate",@"ETag",@"StorageClass",@"IsMultipartUploaded",@"ReplicationStatus"];
    config.optionalFields = fields;
    putReq.inventoryConfiguration = config;
    [putReq setFinishBlock:^(id outputObject, NSError *error) {
//        XCTAssertNil(error);
//        XCTAssertNotNil(outputObject);
        NSLog(@"Inventory outputObject %@",outputObject);
        QCloudGetBucketInventoryRequest *getReq = [QCloudGetBucketInventoryRequest new];
        getReq.bucket = gCosxmlTestBucket.name;
        getReq.inventoryID = @"list1";
        [getReq setFinishBlock:^(QCloudInventoryConfiguration * _Nonnull result, NSError * _Nonnull error) {
//            XCTAssertNotNil(result);
            NSLog(@"outputObject result %@",result.optionalFields.field);
//            XCTAssertNil(error);
            QCloudListBucketInventoryConfigurationsRequest *req = [QCloudListBucketInventoryConfigurationsRequest new];
            NSError * localeError;
            [req buildRequestData:&localeError];
//            XCTAssertNotNil(localeError);
            
            req.bucket = gCosxmlTestBucket.name;
            [req setFinishBlock:^(QCloudListInventoryConfigurationResult * _Nonnull result, NSError * _Nonnull error) {
//                XCTAssertNil(error);
//                XCTAssertNotNil(result);
                QCloudInventoryConfiguration *config = result.inventoryConfiguration[0];
//                XCTAssertNotNil(config.optionalFields);
                QCloudDeleteBucketInventoryRequest *delReq = [QCloudDeleteBucketInventoryRequest new];
                delReq.bucket = gCosxmlTestBucket.name;
                delReq.inventoryID = @"list1";
                [delReq setFinishBlock:^(id outputObject, NSError *error) {
//                    XCTAssertNotNil(outputObject);
//                    XCTAssertNil(error);
                    [exp fulfill];
                }];
                [[QCloudCOSXMLService defaultCOSXML] DeleteBucketInventory:delReq];
            }];
            [[QCloudCOSXMLService defaultCOSXML]ListBucketInventory:req];

    }];
    [[QCloudCOSXMLService defaultCOSXML] GetBucketInventory:getReq];

    }];
    [[QCloudCOSXMLService defaultCOSXML] PutBucketInventory:putReq];
  [self waitForExpectationsWithTimeout:100 handler:nil];
}

-(void)testPUT_GET_DeleteBucketTagging{

    XCTestExpectation *exp = [self expectationWithDescription:@"bucket tagging exp"];
    QCloudPutBucketTaggingRequest *putReq = [QCloudPutBucketTaggingRequest new];
    putReq.bucket = gCosxmlTestBucket.name;
    QCloudTagging *taggings = [QCloudTagging new];
    QCloudTag *tag1 = [QCloudTag new];
    QCloudTagSet *tagSet = [QCloudTagSet new];
    taggings.tagSet = tagSet;
    tag1.key = @"age";
    tag1.value = @"20";
    QCloudTag *tag2 = [QCloudTag new];
    tag2.key = @"name";
    tag2.value = @"karis";
    tagSet.tag = @[tag1,tag2];
    putReq.taggings = taggings;

    [putReq setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);

        QCloudGetBucketTaggingRequest *getReq = [QCloudGetBucketTaggingRequest new];
        getReq.bucket = gCosxmlTestBucket.name;
        [getReq setFinishBlock:^(QCloudTagging * _Nonnull result, NSError * _Nonnull error) {
            XCTAssertNil(error);
            XCTAssertNotNil(result);
            XCTAssertEqual(result.tagSet.tag.count, tagSet.tag.count);
            QCloudDeleteBucketTaggingRequest *delReq = [QCloudDeleteBucketTaggingRequest new];
            
            NSError * localError;
            [delReq buildRequestData:&localError];
            XCTAssertNotNil(localError);
            
            delReq.bucket =  gCosxmlTestBucket.name;
            [delReq setFinishBlock:^(id outputObject, NSError *error) {
                XCTAssertNil(error);
                XCTAssertNotNil(outputObject);
                 [exp fulfill];
            }];
            [[QCloudCOSXMLService defaultCOSXML] DeleteBucketTagging:delReq];


        }];
        [[QCloudCOSXMLService defaultCOSXML] GetBucketTagging:getReq];

    }];
    [[QCloudCOSXMLService defaultCOSXML] PutBucketTagging:putReq];
    [self waitForExpectationsWithTimeout:200 handler:nil];

    
}

- (void)testPUT_GETBucketAccelerate {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Put Object Copy"];
    QCloudPutBucketAccelerateRequest *req = [QCloudPutBucketAccelerateRequest new];
    req.bucket = gCosxmlTestBucket.name;
    QCloudBucketAccelerateConfiguration *config = [QCloudBucketAccelerateConfiguration new];
    config.status = QCloudCOSBucketAccelerateStatusEnabled;
    req.configuration = config;
    [req setFinishBlock:^(id _Nullable outputObject, NSError *_Nullable error) {
        if (!error) {
            QCloudGetBucketAccelerateRequest *get = [QCloudGetBucketAccelerateRequest new];
            get.bucket = gCosxmlTestBucket.name;
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
    put.bucket = gCosxmlTestBucket.name;
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
            get.bucket = gCosxmlTestBucket.name;
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

-(void)testGetBucketInventoryRequest{
    QCloudGetBucketInventoryRequest *getReq = [QCloudGetBucketInventoryRequest new];

    // 存储桶名称，格式为 BucketName-APPID
    getReq.bucket = @"examplebucket-1250000000";

    // 清单任务的名称
    getReq.inventoryID = @"list1";
    [getReq setFinishBlock:^(QCloudInventoryConfiguration * _Nonnull result,
                             NSError * _Nonnull error) {

    }];
    [[QCloudCOSXMLService defaultCOSXML] GetBucketInventory:getReq];
}

-(void)testPutBucketPolicy{
    XCTestExpectation *exp = [self expectationWithDescription:@"testPutBucketPolicy"];
    QCloudPutBucketPolicyRequest * request = [QCloudPutBucketPolicyRequest new];
    request.bucket = @"0-1253960454";
    request.regionName = @"ap-chengdu";
    request.policyInfo = @{
        @"Statement": @[
          @{
            @"Principal": @{
              @"qcs": @[
                @"qcs::cam::uin/100000000001:uin/100000000001"
              ]
            },
            @"Effect": @"allow",
            @"Action": @[
              @"name/cos:GetBucket"
            ],
            @"Resource": @[
              @"qcs::cos:ap-beijing:uid/1250000000:examplebucket-1250000000/*"
            ]
          }
        ],
        @"version": @"2.0"
      };
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutBucketPolicy:request];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

-(void)testGetBucketPolicy{
    XCTestExpectation *exp = [self expectationWithDescription:@"testGetBucketPolicy"];
    QCloudGetBucketPolicyRequest * request = [QCloudGetBucketPolicyRequest new];
    request.bucket = @"0-1253960454";
    request.regionName = @"ap-chengdu";
    [request setFinishBlock:^(QCloudBucketPolicyResult * _Nullable outputObject, NSError * _Nullable error) {
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetBucketPolicy:request];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

-(void)testDeleteBucketPolicy{
    XCTestExpectation *exp = [self expectationWithDescription:@"testDeleteBucketPolicy"];
    QCloudDeleteBucketPolicyRequest * request = [QCloudDeleteBucketPolicyRequest new];
    request.bucket = @"0-1253960454";
    request.regionName = @"ap-chengdu";
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] DeleteBucketPolicy:request];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

- (void)testQCloudPutBucketInventoryRequest {
    QCloudPutBucketInventoryRequest *putReq = [QCloudPutBucketInventoryRequest new];

    // 存储桶名称，格式为 BucketName-APPID
    putReq.bucket= @"mobile-ut-1253960454";

    // 清单任务的名称
    putReq.inventoryID = @"list1";
    
    putReq.regionName = @"ap-guangzhou";

    // 用户在请求体中使用 XML 语言设置清单任务的具体配置信息。配置信息包括清单任务分析的对象，
    // 分析的频次，分析的维度，分析结果的格式及存储的位置等信息。
    QCloudInventoryConfiguration *config = [QCloudInventoryConfiguration new];

    // 清单的名称，与请求参数中的 id 对应
    config.identifier = @"list1";

    // 清单是否启用的标识：
    // 如果设置为 true，清单功能将生效
    // 如果设置为 false，将不生成任何清单
    config.isEnabled = @"True";

    // 描述存放清单结果的信息
    QCloudInventoryDestination *des = [QCloudInventoryDestination new];

    QCloudInventoryBucketDestination *btDes =[QCloudInventoryBucketDestination new];

    // 清单分析结果的文件形式，可选项为 CSV 格式
    btDes.cs = @"CSV";

    // 存储桶的所有者 ID
    btDes.account = @"2832742109";

    // 存储桶名称，格式为 BucketName-APPID
    btDes.bucket  = @"qcs::cos:ap-guangzhou::mobile-ut-1253960454";

    // 清单分析结果的前缀
    btDes.prefix = @"list1";

    // COS 托管密钥的加密方式
    QCloudInventoryEncryption *enc = [QCloudInventoryEncryption new];
    enc.ssecos = @"";

    // 为清单结果提供服务端加密的选项
    btDes.encryption = enc;

    // 清单结果导出后存放的存储桶信息
    des.bucketDestination = btDes;

    // 描述存放清单结果的信息
    config.destination = des;

    // 配置清单任务周期
    QCloudInventorySchedule *sc = [QCloudInventorySchedule new];

    // 清单任务周期，可选项为按日或者按周，枚举值：Daily、Weekly
    sc.frequency = @"Daily";
    config.schedule = sc;
    QCloudInventoryFilter *fileter = [QCloudInventoryFilter new];
    fileter.prefix = @"myPrefix";
    config.filter = fileter;
    config.includedObjectVersions = QCloudCOSIncludedObjectVersionsAll;
    QCloudInventoryOptionalFields *fields = [QCloudInventoryOptionalFields new];

    fields.field = @[
                      @"StorageClass",
                     ];

    // 设置清单结果中应包含的分析项目
    config.optionalFields = fields;
    putReq.inventoryConfiguration = config;
    [putReq setFinishBlock:^(id outputObject, NSError *error) {
        NSDictionary * result = (NSDictionary *)outputObject;

    }];
    [[QCloudCOSXMLService defaultCOSXML] PutBucketInventory:putReq];
}

// 测试创建一次性清单任务
- (void)testPostBucketInventory0{
    XCTestExpectation* expectationPostBucketInventory = [self expectationWithDescription:@"testPostBucketInventory"];
    QCloudPostBucketInventoryRequest * putReq = [QCloudPostBucketInventoryRequest new];
    // 存储桶名称，格式为 BucketName-APPID
    putReq.bucket= @"mobile-ut-1253960454";

    // 清单任务的名称
    putReq.inventoryID = @"list1";
    
    putReq.regionName = @"ap-guangzhou";

    // 用户在请求体中使用 XML 语言设置清单任务的具体配置信息。配置信息包括清单任务分析的对象，
    // 分析的频次，分析的维度，分析结果的格式及存储的位置等信息。
    QCloudInventoryConfiguration *config = [QCloudInventoryConfiguration new];

    // 清单的名称，与请求参数中的 id 对应
    config.identifier = @"list1";

    // 描述存放清单结果的信息
    QCloudInventoryDestination *des = [QCloudInventoryDestination new];

    QCloudInventoryBucketDestination *btDes =[QCloudInventoryBucketDestination new];

    // 清单分析结果的文件形式，可选项为 CSV 格式
    btDes.cs = @"CSV";

    // 存储桶的所有者 ID
    btDes.account = @"2832742109";

    // 存储桶名称，格式为 BucketName-APPID
    btDes.bucket  = @"qcs::cos:ap-guangzhou::mobile-ut-1253960454";

    // 清单分析结果的前缀
    btDes.prefix = @"list1";

    // COS 托管密钥的加密方式
    QCloudInventoryEncryption *enc = [QCloudInventoryEncryption new];
    enc.ssecos = @"";

    // 为清单结果提供服务端加密的选项
    btDes.encryption = enc;

    // 清单结果导出后存放的存储桶信息
    des.bucketDestination = btDes;

    // 描述存放清单结果的信息
    config.destination = des;

    QCloudInventoryFilter *fileter = [QCloudInventoryFilter new];
    fileter.prefix = @"myPrefix";
    config.filter = fileter;
    config.includedObjectVersions = QCloudCOSIncludedObjectVersionsAll;
    QCloudInventoryOptionalFields *fields = [QCloudInventoryOptionalFields new];

    fields.field = @[
                      @"StorageClass",
                     ];

    // 设置清单结果中应包含的分析项目
    config.optionalFields = fields;
    putReq.inventoryConfiguration = config;
    [putReq setFinishBlock:^(id _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        // 注意：此测试可能因为权限或其他原因返回错误，这是正常的
        [expectationPostBucketInventory fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PostBucketInventory:putReq];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

-(void)testSyncFunction{
    BOOL result = [[QCloudCOSXMLService defaultCOSXML] doesBucketExist:@"test"];
    XCTAssertFalse(result);
    
    result = [[QCloudCOSXMLService defaultCOSXML] doesObjectExistWithBucket:@"test" object:@"test"];
    XCTAssertFalse(result);
    
    [[QCloudCOSXMLService defaultCOSXML] deleteObjectWithBucket:@"test" object:@"test"];
    
    [[QCloudCOSXMLService defaultCOSXML] deleteVersionWithBucket:@"test" object:@"test" version:@"test"];
    
    [[QCloudCOSXMLService defaultCOSXML] changeObjectStorageClassWithBucket:@"test" object:@"test" storageClass:QCloudCOSStorageStandard];
    
    [[QCloudCOSXMLService defaultCOSXML] updateObjectMedaWithBucket:@"test" object:@"test" meta:@{@"test":@"test"}];
}
@end

