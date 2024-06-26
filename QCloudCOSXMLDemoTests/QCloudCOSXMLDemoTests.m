//
//  QCloudCOSXMLDemoTests.m
//  QCloudCOSXMLDemoTests
//
//  Created by Dong Zhao on 2017/2/24.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <QCloudCOSXML/QCloudCOSXML.h>

#import "TestCommonDefine.h"
#import "QCloudTestTempVariables.h"
#import "QCloudCOSXMLTestUtility.h"
#import "SecretStorage.h"
#define kCOSDemoBucketKey @"demo"
@interface QCloudCOSXMLDemoTests : XCTestCase <QCloudSignatureProvider>
@property (nonatomic, strong) NSString *appID;
@property (nonatomic, strong) NSString *ownerID;
@property (nonatomic, strong) NSString *authorizedUIN;
@property (nonatomic, strong) NSString *ownerUIN;
@property (nonatomic, strong) NSMutableArray *tempFilePathArray;

@end
static QCloudBucket *demoTestBucket;
@implementation QCloudCOSXMLDemoTests
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
    if ([QCloudCOSXMLService hasServiceForKey:kTestFromAnotherRegionCopy]) {
        return;
    }
    QCloudServiceConfiguration *configuration = [QCloudServiceConfiguration new];
    configuration.appID = self.appID;
    configuration.signatureProvider = self;
    QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.regionName = @"ap-guangzhou";
    configuration.endpoint = endpoint;

    [QCloudCOSXMLService registerCOSXMLWithConfiguration:configuration withKey:kTestFromAnotherRegionCopy];
    [QCloudCOSTransferMangerService registerCOSTransferMangerWithConfiguration:configuration withKey:kTestFromAnotherRegionCopy];
}

+ (void)setUp {
    demoTestBucket = [[QCloudCOSXMLTestUtility sharedInstance] createTestBucketWithPrefix:kCOSDemoBucketKey];
}

+ (void)tearDown {
    [[QCloudCOSXMLTestUtility sharedInstance] deleteTestBucket:demoTestBucket];
}

- (void)setUp {
    [super setUp];
    [self setupSpecialCOSXMLShareService];

    self.appID = [SecretStorage sharedInstance].appID;
    self.ownerID = @"1278687956";
    self.authorizedUIN = @"1131975903";
    self.ownerUIN = @"1278687956";
    self.tempFilePathArray = [NSMutableArray array];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    //    [[QCloudCOSXMLTestUtility sharedInstance] deleteTestBucket:demoTestBucket.name];
    [self.tempFilePathArray enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSFileManager *manager = [NSFileManager defaultManager];
        if ([manager fileExistsAtPath:obj]) {
            [manager removeItemAtPath:obj error:nil];
        }
    }];
    [super tearDown];
}

- (void)deleteTestBucket {
    XCTestExpectation *exception = [self expectationWithDescription:@"Delete bucket exception"];

    QCloudGetBucketRequest *request = [[QCloudGetBucketRequest alloc] init];
    request.bucket = [QCloudTestTempVariables sharedInstance].testBucket;
    request.maxKeys = 500;
    [request setFinishBlock:^(QCloudListBucketResult *result, NSError *error) {
        QCloudDeleteMultipleObjectRequest *deleteMultipleObjectRequest = [[QCloudDeleteMultipleObjectRequest alloc] init];
        deleteMultipleObjectRequest.bucket = [QCloudTestTempVariables sharedInstance].testBucket;
        deleteMultipleObjectRequest.deleteObjects = [[QCloudDeleteInfo alloc] init];
        NSMutableArray *deleteObjectInfoArray = [NSMutableArray array];
        deleteMultipleObjectRequest.deleteObjects.objects = deleteObjectInfoArray;
        for (QCloudBucketContents *content in result.contents) {
            QCloudDeleteObjectInfo *info = [[QCloudDeleteObjectInfo alloc] init];
            info.key = content.key;
            [deleteObjectInfoArray addObject:info];
        }
    
        [deleteMultipleObjectRequest setFinishBlock:^(QCloudDeleteResult *result, NSError *error) {
            if (!error) {
                QCloudDeleteBucketRequest *deleteBucketRequest = [[QCloudDeleteBucketRequest alloc] init];
                deleteBucketRequest.bucket = [QCloudTestTempVariables sharedInstance].testBucket;
                [[QCloudCOSXMLService defaultCOSXML] DeleteBucket:deleteBucketRequest];
            } else {
                QCloudLogDebug(error.description);
            }
            [exception fulfill];
        }];
        [[QCloudCOSXMLService defaultCOSXML] DeleteMultipleObject:deleteMultipleObjectRequest];
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetBucket:request];

    [self waitForExpectationsWithTimeout:100 handler:nil];
}

- (void)testRegisterCustomService {
    QCloudServiceConfiguration *configuration = [QCloudServiceConfiguration new];
    configuration.appID = [SecretStorage sharedInstance].appID;
    configuration.signatureProvider = self;

    QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.regionName = @"ap-guangzhou";
    configuration.endpoint = endpoint;

    NSString *serviceKey = @"test";
    [QCloudCOSXMLService registerCOSXMLWithConfiguration:configuration withKey:serviceKey];
    QCloudCOSXMLService *service = [QCloudCOSXMLService cosxmlServiceForKey:serviceKey];
    XCTAssertNotNil(service);
}

- (void)testGetACL {
    QCloudGetObjectACLRequest *request = [QCloudGetObjectACLRequest new];
    request.bucket = demoTestBucket.name;
    request.object = [self uploadTempObject];
    XCTestExpectation *exp = [self expectationWithDescription:@"delete"];
    [request setFinishBlock:^(QCloudACLPolicy *_Nonnull policy, NSError *_Nonnull error) {
        XCTAssertNil(error);
        XCTAssertNotNil(policy);
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetObjectACL:request];
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (NSString *)uploadTempObject {
    QCloudPutObjectRequest *put = [QCloudPutObjectRequest new];
    put.object = [NSUUID UUID].UUIDString;
    put.bucket = demoTestBucket.name;
    put.body = [@"1234jdjdjdjjdjdjyuehjshgdytfakjhsghgdhg" dataUsingEncoding:NSUTF8StringEncoding];

    XCTestExpectation *exp = [self expectationWithDescription:@"delete"];

    [put setFinishBlock:^(id outputObject, NSError *error) {
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutObject:put];

    [self waitForExpectationsWithTimeout:80
                                 handler:^(NSError *_Nullable error) {

                                 }];
    return put.object;
}
- (void)testDeleteObject {
    NSString *object = [self uploadTempObject];
    QCloudDeleteObjectRequest *deleteObjectRequest = [QCloudDeleteObjectRequest new];
    
    NSError * error;
    [deleteObjectRequest buildRequestData:&error];
    XCTAssertNotNil(error);

    
    deleteObjectRequest.object = object;
    
    [deleteObjectRequest buildRequestData:&error];
    XCTAssertNotNil(error);
    
    deleteObjectRequest.bucket = demoTestBucket.name;

    XCTestExpectation *exp = [self expectationWithDescription:@"delete"];

    __block NSError *localError;
    [deleteObjectRequest setFinishBlock:^(id outputObject, NSError *error) {
        localError = error;
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] DeleteObject:deleteObjectRequest];

    [self waitForExpectationsWithTimeout:80
                                 handler:^(NSError *_Nullable error) {

                                 }];

    XCTAssertNil(localError);
}

-  (void)testDeleteObjectWithPrefix{
    XCTestExpectation *exp = [self expectationWithDescription:@"delete"];
    NSString *bucket = [NSString stringWithFormat:@"0-%@",self.appID];
    NSString *region = @"ap-chengdu";
    QCloudGetBucketRequest* request = [QCloudGetBucketRequest new];

    // 存储桶名称，格式为 BucketName-APPID
    request.bucket = bucket;
    request.regionName = region;
    // 单次返回的最大条目数量，默认1000
    request.maxKeys = 100;

    // 前缀匹配，用来规定返回的文件前缀地址
    request.prefix = @"sss/";


    [request setFinishBlock:^(QCloudListBucketResult * result, NSError* error) {
        NSLog(@"result = %@",result);
        if(!error){
            NSMutableArray *deleteInfosArr = [NSMutableArray array];
            for (QCloudBucketContents *content in result.contents) {

                QCloudDeleteObjectInfo *object = [QCloudDeleteObjectInfo new];
                object.key = content.key;
                [deleteInfosArr addObject:object];
            }
            
            QCloudDeleteInfo *deleteInfos = [QCloudDeleteInfo new];
            deleteInfos.objects = [deleteInfosArr copy];
          
            QCloudDeleteMultipleObjectRequest *delteRequest = [QCloudDeleteMultipleObjectRequest new];
            delteRequest.bucket = bucket;
            delteRequest.regionName = region;
            delteRequest.deleteObjects = deleteInfos;
            [delteRequest setFinishBlock:^(QCloudDeleteResult *outputObject, NSError *error) {
                NSLog(@"outputObject = %@",outputObject);
                [exp fulfill];
            }];

            [[QCloudCOSXMLService defaultCOSXML] DeleteMultipleObject:delteRequest];
            
        }
        // result 返回具体信息
        // QCloudListBucketResult.contents 桶内文件数组
        // QCloudListBucketResult.commonPrefixes 桶内文件夹数组

    }];

    [[QCloudCOSXMLService defaultCOSXML] GetBucket:request];
    [self waitForExpectationsWithTimeout:80
                                 handler:^(NSError *_Nullable error) {

                                 }];
}

- (void)testDeleteObjects {
    NSString *object1 = [self uploadTempObject];
    NSString *object2 = [self uploadTempObject];

    QCloudDeleteMultipleObjectRequest *delteRequest = [QCloudDeleteMultipleObjectRequest new];
    delteRequest.bucket = demoTestBucket.name;

    QCloudDeleteObjectInfo *object = [QCloudDeleteObjectInfo new];
    object.key = object1;

    QCloudDeleteObjectInfo *deleteObject2 = [QCloudDeleteObjectInfo new];
    deleteObject2.key = object2;

    QCloudDeleteInfo *deleteInfo = [QCloudDeleteInfo new];
    deleteInfo.quiet = NO;
    deleteInfo.objects = @[ object, deleteObject2 ];

    delteRequest.deleteObjects = deleteInfo;
    
    
    for (NSDictionary * dic in delteRequest.scopesArray) {
        NSString * action = dic[@"action"];
        XCTAssertTrue([action isEqualToString:@"name/cos:DeleteObject"]);
    }
    
    
    XCTestExpectation *exp = [self expectationWithDescription:@"delete"];

    __block NSError *localError;
    __block QCloudDeleteResult *deleteResult = nil;
    [delteRequest setFinishBlock:^(QCloudDeleteResult *outputObject, NSError *error) {
        localError = error;
        deleteResult = outputObject;
        [exp fulfill];
    }];

    [[QCloudCOSXMLService defaultCOSXML] DeleteMultipleObject:delteRequest];

    [self waitForExpectationsWithTimeout:80
                                 handler:^(NSError *_Nullable error) {

                                 }];

    XCTAssertNotNil(deleteResult);
    XCTAssertEqual(2, deleteResult.deletedObjects.count);
    QCloudDeleteResultRow *firstrow = deleteResult.deletedObjects[0];
    QCloudDeleteResultRow *secondRow = deleteResult.deletedObjects[1];
    XCTAssert([firstrow.key isEqualToString:object1]);
    XCTAssert([secondRow.key isEqualToString:object2]);
    XCTAssertNil(localError);
}
- (void)testPutObjectACL {
    QCloudPutObjectACLRequest *request = [QCloudPutObjectACLRequest new];
    request.object = [self uploadTempObject];
    request.bucket = demoTestBucket.name;
    NSString *ownerIdentifier = [NSString stringWithFormat:@"qcs::cam::uin/%@:uin/%@", self.authorizedUIN, self.authorizedUIN];
    NSString *grantString = [NSString stringWithFormat:@"id=\"%@\"", ownerIdentifier];
    request.grantFullControl = grantString;
    XCTestExpectation *exp = [self expectationWithDescription:@"acl"];
    __block NSError *localError;
    [request setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error);
        [exp fulfill];
    }];

    [[QCloudCOSXMLService defaultCOSXML] PutObjectACL:request];
    [self waitForExpectationsWithTimeout:1000 handler:nil];
}

- (void)testLimitACL {

    for (int i = 0; i < 1; i++) {
        QCloudPutBucketACLRequest *request = [QCloudPutBucketACLRequest new];
        NSString *ownerIdentifier = [NSString stringWithFormat:@"qcs::cam::uin/%@:uin/%@", self.authorizedUIN, self.authorizedUIN];
        NSString *grantString = [NSString stringWithFormat:@"id=\"%@\"", ownerIdentifier];
        request.grantFullControl = grantString;
        request.bucket = demoTestBucket.name;
        request.accessControlList = @"private";
        XCTestExpectation *exp = [self expectationWithDescription:@"acl"];
        __block NSError *localError;
        [request setFinishBlock:^(id outputObject, NSError *error) {
            XCTAssertNil(error);
            [exp fulfill];
        }];

        [[QCloudCOSXMLService defaultCOSXML] PutBucketACL:request];
    }

    [self waitForExpectationsWithTimeout:1000 handler:nil];
}
- (void)testPutObject {
    QCloudPutObjectRequest *put = [QCloudPutObjectRequest new];
    put.object = @"1/4.txt";
    put.bucket = demoTestBucket.name;
    NSURL *url = [NSURL fileURLWithPath:[self tempFileWithSize:30 * 1024 * 1024]];
    put.body = url;
    XCTestExpectation *exp = [self expectationWithDescription:@"delete"];
    __block NSError *resultError;
    [put setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNotNil(outputObject);
        XCTAssertNil(error);
        resultError = error;
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutObject:put];
    [self waitForExpectationsWithTimeout:600 handler:nil];
    //
    //    XCTAssertNil(resultError);
    //    QCloudDeleteObjectRequest* deleteObjectRequest = [[QCloudDeleteObjectRequest alloc] init];
    //    deleteObjectRequest.bucket = demoTestBucket.name;
    //    deleteObjectRequest.object = put.object;
    //    [[QCloudCOSXMLService defaultCOSXML] DeleteObject:deleteObjectRequest];
}

- (void)testPutObjectWithACL {
    QCloudPutObjectRequest *put = [QCloudPutObjectRequest new];
    put.object = put.bucket = demoTestBucket.name;
    put.body = [@"1234jdjdjdjjdjdjyuehjshgdytfakjhsghgdhg" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *ownerIdentifier = [NSString stringWithFormat:@"qcs::cam::uin/%@:uin/%@", @"2779643970", @"2779643970"];
    NSString *grantString = [NSString stringWithFormat:@"id=\"%@\"", ownerIdentifier];
    put.grantRead = put.grantFullControl = grantString;
    XCTestExpectation *exp = [self expectationWithDescription:@"delete"];
    __block NSError *resultError;
    [put setFinishBlock:^(id outputObject, NSError *error) {
        resultError = error;
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutObject:put];
    [self waitForExpectationsWithTimeout:80 handler:nil];

    XCTAssertNil(resultError);
    QCloudDeleteObjectRequest *deleteObjectRequest = [[QCloudDeleteObjectRequest alloc] init];
    deleteObjectRequest.bucket = demoTestBucket.name;
    deleteObjectRequest.object = put.object;
    [[QCloudCOSXMLService defaultCOSXML] DeleteObject:deleteObjectRequest];
}

- (void)testInitMultipartUpload {
    QCloudInitiateMultipartUploadRequest *initrequest = [QCloudInitiateMultipartUploadRequest new];
    initrequest.bucket = demoTestBucket.name;
    initrequest.object = [NSUUID UUID].UUIDString;

    NSArray * actions = @[@"name/cos:InitiateMultipartUpload",
                          @"name/cos:ListParts",
                          @"name/cos:UploadPart",
                          @"name/cos:CompleteMultipartUpload",
                          @"name/cos:AbortMultipartUpload"
                        ];
    
    for (NSDictionary * dic in initrequest.scopesArray) {
        NSString * action = dic[@"action"];
        XCTAssertTrue([actions containsObject:action]);
    }
    
    XCTestExpectation *exp = [self expectationWithDescription:@"delete"];
    __block QCloudInitiateMultipartUploadResult *initResult;
    [initrequest setFinishBlock:^(QCloudInitiateMultipartUploadResult *outputObject, NSError *error) {
        initResult = outputObject;
        [exp fulfill];
    }];

    [[QCloudCOSXMLService defaultCOSXML] InitiateMultipartUpload:initrequest];

    [self waitForExpectationsWithTimeout:80
                                 handler:^(NSError *_Nullable error) {
                                 }];
    XCTAssert([initResult.bucket isEqualToString:demoTestBucket.name]);
    XCTAssert([initResult.key isEqualToString:initrequest.object]);
}
- (NSString *)tempFileWithSize:(int)size {
    NSString *file4MBPath = QCloudPathJoin(QCloudTempDir(), [NSUUID UUID].UUIDString);

    if (!QCloudFileExist(file4MBPath)) {
        [[NSFileManager defaultManager] createFileAtPath:file4MBPath contents:[NSData data] attributes:nil];
    }
    NSFileHandle *handler = [NSFileHandle fileHandleForWritingAtPath:file4MBPath];
    [handler truncateFileAtOffset:size];
    [handler closeFile];
    [self.tempFilePathArray addObject:file4MBPath];

    return file4MBPath;
}
- (void)testHeadeObject {
    NSString *object = [self uploadTempObject];
    QCloudHeadObjectRequest *headerRequest = [QCloudHeadObjectRequest new];
    headerRequest.object = object;
    headerRequest.bucket = demoTestBucket.name;

    XCTestExpectation *exp = [self expectationWithDescription:@"header"];
    __block id resultError;
    [headerRequest setFinishBlock:^(NSDictionary *result, NSError *error) {
        resultError = error;
        [exp fulfill];
    }];

    [[QCloudCOSXMLService defaultCOSXML] HeadObject:headerRequest];
    [self waitForExpectationsWithTimeout:80
                                 handler:^(NSError *_Nullable error) {

                                 }];
    XCTAssertNil(resultError);
}

- (void)testGetObject {
    QCloudPutObjectRequest *put = [QCloudPutObjectRequest new];
    NSString *object = [NSUUID UUID].UUIDString;
    put.object = @"test/1/2/3/4/5.jpg";
    put.bucket = demoTestBucket.name;
    NSURL *fileURL = [NSURL fileURLWithPath:[self tempFileWithSize:1024 * 1024 * 3]];
    put.body = fileURL;

    XCTestExpectation *exp = [self expectationWithDescription:@"delete"];
    __block QCloudGetObjectRequest *request = [QCloudGetObjectRequest new];
    request.downloadingURL = [NSURL URLWithString:QCloudTempFilePathWithExtension(@"downding")];

    [put setFinishBlock:^(id outputObject, NSError *error) {
        request.bucket = demoTestBucket.name;
        request.object = @"test/1/2/3/4/5.jpg";

        [request setFinishBlock:^(id outputObject, NSError *error) {
            XCTAssertNil(error);
            [exp fulfill];
        }];
        [request setDownProcessBlock:^(int64_t bytesDownload, int64_t totalBytesDownload, int64_t totalBytesExpectedToDownload) {
            NSLog(@"⏬⏬⏬⏬DOWN [Total]%lld  [Downloaded]%lld [Download]%lld", totalBytesExpectedToDownload, totalBytesDownload, bytesDownload);
        }];
        [[QCloudCOSXMLService defaultCOSXML] GetObject:request];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutObject:put];

    [self waitForExpectationsWithTimeout:80 handler:nil];

    XCTAssertEqual(QCloudFileSize(request.downloadingURL.path), QCloudFileSize(fileURL.path));
}

- (void)testGetObjectWithMD5Verification {
    QCloudCOSXMLUploadObjectRequest *put = [QCloudCOSXMLUploadObjectRequest new];
    NSString *object = [NSUUID UUID].UUIDString;
    put.object = object;
    put.bucket = demoTestBucket.name;
    NSURL *fileURL = [NSURL fileURLWithPath:[self tempFileWithSize:1024 * 1024 * 1]];
    put.body = fileURL;
    NSLog(@"fileURL  %@", fileURL.absoluteString);
    XCTestExpectation *exp = [self expectationWithDescription:@"delete"];
    __block QCloudGetObjectRequest *request = [QCloudGetObjectRequest new];
    request.downloadingURL = [NSURL URLWithString:QCloudTempFilePathWithExtension(@"downding")];
    [put setFinishBlock:^(id outputObject, NSError *error) {
        request.bucket = demoTestBucket.name;
        request.object = object;
        request.enableMD5Verification = YES;
        [request setFinishBlock:^(id outputObject, NSError *error) {
            XCTAssertNil(error);
            [exp fulfill];
        }];
        [request setDownProcessBlock:^(int64_t bytesDownload, int64_t totalBytesDownload, int64_t totalBytesExpectedToDownload) {
            NSLog(@"⏬⏬⏬⏬DOWN [Total]%lld  [Downloaded]%lld [Download]%lld", totalBytesExpectedToDownload, totalBytesDownload, bytesDownload);
        }];
        [[QCloudCOSXMLService defaultCOSXML] GetObject:request];
    }];
    [[QCloudCOSTransferMangerService defaultCOSTransferManager] UploadObject:put];

    [self waitForExpectationsWithTimeout:80 handler:nil];

    XCTAssertEqual(QCloudFileSize(request.downloadingURL.path), QCloudFileSize(fileURL.path));
}
- (void)testGetObjectWithMD5VerificationWithChunked {
    //    QCloudPutObjectRequest* put = [QCloudPutObjectRequest new];
    //    NSString* object =  [NSUUID UUID].UUIDString;
    //    put.object =object;
    //    put.bucket = @"karis1test-1253653367";
    //    NSURL* fileURL = [NSURL fileURLWithPath:[self tempFileWithSize:1024*1024*3]];
    //    put.body = fileURL;
    //    NSLog(@"fileURL  %@",fileURL.absoluteString);
//    XCTestExpectation *exp = [self expectationWithDescription:@"delete"];
//    __block QCloudGetObjectRequest *request = [QCloudGetObjectRequest new];
//
//    request.downloadingURL = [NSURL URLWithString:QCloudTempFilePathWithExtension(@"downding")];
//    //    [put setFinishBlock:^(id outputObject, NSError *error) {
//    request.bucket = @"karis1test-1253653367";
//    request.object = @"multi_tce.txt";
//    request.enableMD5Verification = YES;
//    [request setFinishBlock:^(id outputObject, NSError *error) {
//        //            XCTAssertNil(error);
//        [exp fulfill];
//    }];
//    [request setDownProcessBlock:^(int64_t bytesDownload, int64_t totalBytesDownload, int64_t totalBytesExpectedToDownload) {
//        NSLog(@"⏬⏬⏬⏬DOWN [Total]%lld  [Downloaded]%lld [Download]%lld", totalBytesExpectedToDownload, totalBytesDownload, bytesDownload);
//    }];
//    [[QCloudCOSXMLService defaultCOSXML] GetObject:request];

    //    }];
    //    [[QCloudCOSXMLService defaultCOSXML] PutObject:put];

//    [self waitForExpectationsWithTimeout:80 handler:nil];

    //    XCTAssertEqual(QCloudFileSize(request.downloadingURL.path), QCloudFileSize(fileURL.path));
}

- (void)testPutObjectCopy {
    NSString *copyObjectSourceName = [NSUUID UUID].UUIDString;
    QCloudPutObjectRequest *put = [QCloudPutObjectRequest new];
    put.object = copyObjectSourceName;
    put.versionID = @"versionID111111";
    put.bucket = demoTestBucket.name;
    put.body = [@"4324ewr325" dataUsingEncoding:NSUTF8StringEncoding];
    __block XCTestExpectation *exception = [self expectationWithDescription:@"Put Object Copy Exception"];
    __block NSError *putObjectCopyError;
    __block NSError *resultError;
    __block QCloudCopyObjectResult *copyObjectResult;
    [put setFinishBlock:^(id outputObject, NSError *error) {
        NSURL *serviceURL = [[QCloudCOSXMLService defaultCOSXML].configuration.endpoint serverURLWithBucket:demoTestBucket.name
                                                                                                      appID:self.appID
                                                                                                 regionName:put.regionName];
        NSMutableString *objectCopySource = [serviceURL.absoluteString mutableCopy];
        [objectCopySource appendFormat:@"/%@", copyObjectSourceName];
        objectCopySource = [[objectCopySource substringFromIndex:7] mutableCopy];
        QCloudPutObjectCopyRequest *request = [[QCloudPutObjectCopyRequest alloc] init];
        request.bucket = demoTestBucket.name;
        request.object = [NSUUID UUID].UUIDString;
        request.objectCopySource = objectCopySource;
        request.versionID = @"versionID111111";
        
        NSArray * actions = @[@"name/cos:GetObject",@"name/cos:PutObject"];
        
        for (NSDictionary *dic in request.scopesArray) {
            NSString * action = dic[@"action"];
            XCTAssertTrue([actions containsObject:action]);
        }
        
        [request setFinishBlock:^(QCloudCopyObjectResult *result, NSError *error) {
            putObjectCopyError = result;
            resultError = error;
            [exception fulfill];
        }];
        [[QCloudCOSXMLService defaultCOSXML] PutObjectCopy:request];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutObject:put];
    [self waitForExpectationsWithTimeout:100 handler:nil];
    XCTAssertNil(resultError);
}

- (void)testMultiplePutObjectCopy {

    XCTestExpectation *uploadExpectation = [self expectationWithDescription:@"upload temp object"];
    QCloudCOSXMLUploadObjectRequest *uploadObjectRequest = [[QCloudCOSXMLUploadObjectRequest alloc] init];
    NSString *tempFileName = @"30MBTempFile";
    uploadObjectRequest.bucket = demoTestBucket.name;
    uploadObjectRequest.object = tempFileName;
    uploadObjectRequest.body = [NSURL fileURLWithPath:[self tempFileWithSize:30 * 1024 * 1024]];
    [uploadObjectRequest setFinishBlock:^(QCloudUploadObjectResult *result, NSError *error) {
        XCTAssertNil(error, @"error occures on uploading");
        [uploadExpectation fulfill];
    }];
    [[QCloudCOSTransferMangerService defaultCOSTransferManager] UploadObject:uploadObjectRequest];
    [self waitForExpectationsWithTimeout:600 handler:nil];
    QCloudCOSXMLCopyObjectRequest *request = [[QCloudCOSXMLCopyObjectRequest alloc] init];

    request.bucket = demoTestBucket.name;
    request.object = @"copy-result-test";
    request.sourceBucket = demoTestBucket.name;
    request.sourceObject = tempFileName;
    request.sourceAPPID = [QCloudCOSXMLService defaultCOSXML].configuration.appID;
    request.sourceRegion = [QCloudCOSXMLService defaultCOSXML].configuration.endpoint.regionName;

    XCTestExpectation *expectation = [self expectationWithDescription:@"Put Object Copy"];
    [request setFinishBlock:^(QCloudCopyObjectResult *result, NSError *error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    request.requstsMetricArrayBlock = ^(NSMutableArray *requstMetricArray) {
        QCloudLogDebug(@"testMetric %@", requstMetricArray);
    };
    [[QCloudCOSTransferMangerService defaultCOSTransferManager] CopyObject:request];
    [self waitForExpectationsWithTimeout:10000 handler:nil];
}

- (void)testForInCopyObject {
    NSString *tempBucket = [[QCloudCOSXMLTestUtility sharedInstance] createTestBucketWithPrefix:@"dt"].name;
    NSString *tempFileName = @"30MBTempFile";

    for (int i = 0; i < 5; i++) {
        XCTestExpectation *uploadExpectation = [self expectationWithDescription:@"upload temp object"];
        QCloudCOSXMLUploadObjectRequest *uploadObjectRequest = [[QCloudCOSXMLUploadObjectRequest alloc] init];
        uploadObjectRequest.bucket = tempBucket;
        uploadObjectRequest.object = tempFileName;
        uploadObjectRequest.body = [NSURL fileURLWithPath:[self tempFileWithSize:30 * 1024 * 1024]];
        [uploadObjectRequest setFinishBlock:^(QCloudUploadObjectResult *result, NSError *error) {
            XCTAssertNil(error, @"error occures on uploading");
            [uploadExpectation fulfill];
        }];
        [[QCloudCOSTransferMangerService defaultCOSTransferManager] UploadObject:uploadObjectRequest];
        [self waitForExpectationsWithTimeout:200 handler:nil];
    }

    XCTestExpectation *getBucketExpectation = [self expectationWithDescription:@"get bucket"];
    __block NSArray *contentsArray;
    QCloudGetBucketRequest *getBucketRequest = [[QCloudGetBucketRequest alloc] init];
    getBucketRequest.bucket = tempBucket;
    getBucketRequest.maxKeys = 1000;
    [getBucketRequest setFinishBlock:^(QCloudListBucketResult *_Nonnull result, NSError *_Nonnull error) {
        contentsArray = result.contents;
        XCTAssertNil(error, @"error during get bucket");
        [getBucketExpectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetBucket:getBucketRequest];
    [self waitForExpectationsWithTimeout:120 handler:nil];

    for (QCloudBucketContents *content in contentsArray) {
        QCloudCOSXMLCopyObjectRequest *request = [[QCloudCOSXMLCopyObjectRequest alloc] init];

        request.bucket = demoTestBucket.name;
        request.object = [NSString stringWithFormat:@"copy-%@", tempFileName];
        request.sourceBucket = tempBucket;
        request.sourceObject = content.key;
        request.sourceAPPID = [QCloudCOSXMLService defaultCOSXML].configuration.appID;
        request.sourceRegion = [QCloudCOSXMLService defaultCOSXML].configuration.endpoint.regionName;

        XCTestExpectation *expectation = [self expectationWithDescription:@"Put Object Copy"];
        [request setFinishBlock:^(QCloudCopyObjectResult *result, NSError *error) {
            XCTAssertNil(error);
            [expectation fulfill];
        }];
        [[QCloudCOSTransferMangerService defaultCOSTransferManager] CopyObject:request];
        [self waitForExpectationsWithTimeout:10000 handler:nil];
    }
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
        demoTestBucket.name = bucketName;
        [QCloudTestTempVariables sharedInstance].testBucket = bucketName;
        responseError = error;
        [exception fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutBucket:request];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

- (void)testGetObjectURL {
    NSString *obejctKey = [self uploadTempObject];
    NSString *objectDownloadURL = [[QCloudCOSXMLService defaultCOSXML] getURLWithBucket:demoTestBucket.name
                                                                                 object:obejctKey
                                                                      withAuthorization:YES
                                                                             regionName:@"ap-guangzhou"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:objectDownloadURL]];
    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    XCTestExpectation *expectation = [self expectationWithDescription:@"get object url"];
    [[[NSURLSession sharedSession] downloadTaskWithRequest:request
                                         completionHandler:^(NSURL *_Nullable location, NSURLResponse *_Nullable response, NSError *_Nullable error) {
                                             XCTAssertNil(error);
                                             NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                                             XCTAssert(statusCode > 199 && statusCode < 300,
                                                       @"StatusCode not equal to 2xx! statu code is %ld, response is %@", (long)statusCode, response);
                                             XCTAssert(QCloudFileExist(location.path), @"File not exist!");
                                             [expectation fulfill];
                                         }] resume];
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)testGetPresignedURL {
    NSString *obejctKey = [self uploadTempObject];
    QCloudGetPresignedURLRequest *getPresignedURLRequest = [[QCloudGetPresignedURLRequest alloc] init];
    getPresignedURLRequest.bucket = demoTestBucket.name;
    getPresignedURLRequest.object = obejctKey;
    getPresignedURLRequest.HTTPMethod = @"GET";
    XCTestExpectation *expectation = [self expectationWithDescription:@"GET PRESIGNED URL"];
    [getPresignedURLRequest setFinishBlock:^(QCloudGetPresignedURLResult *result, NSError *error) {
        XCTAssertNil(error, @"error occured in getting presigned URL ! details:%@", error);
        XCTAssertNotNil(result.presienedURL, @"presigned url is nil!");
        NSString *objectDownloadURL = result.presienedURL;
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:objectDownloadURL]];
        [request setHTTPMethod:@"GET"];
        [[[NSURLSession sharedSession]
            downloadTaskWithRequest:request
                  completionHandler:^(NSURL *_Nullable location, NSURLResponse *_Nullable response, NSError *_Nullable error) {
                      NSLog(@"resulttest%@", result.presienedURL);
                      XCTAssertNil(error);
                      NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                      XCTAssert(statusCode > 199 && statusCode < 300, @"StatusCode not equal to 2xx! statu code is %ld, response is %@",
                                (long)statusCode, response);
                      XCTAssert(QCloudFileExist(location.path), @"File not exist!");
                      [expectation fulfill];
                  }] resume];
    }];
    [[QCloudCOSXMLService defaultCOSXML] getPresignedURL:getPresignedURLRequest];
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)testPutObjectWithPresignedURL {
    QCloudGetPresignedURLRequest *getPresignedURLRequest = [[QCloudGetPresignedURLRequest alloc] init];
    getPresignedURLRequest.bucket = demoTestBucket.name;
    getPresignedURLRequest.HTTPMethod = @"PUT";
    getPresignedURLRequest.object = @"testUploadWithPresignedURL";
    XCTestExpectation *expectation = [self expectationWithDescription:@"GET PRESIGNED URL"];

    [getPresignedURLRequest setFinishBlock:^(QCloudGetPresignedURLResult *_Nonnull result, NSError *_Nonnull error) {
        XCTAssertNil(error, @"error occured in getting presigned URL ! details:%@", error);
        XCTAssertNotNil(result.presienedURL, @"presigned url is nil!");

        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:result.presienedURL]];
        request.HTTPMethod = @"PUT";
        request.HTTPBody = [@"testtest" dataUsingEncoding:NSUTF8StringEncoding];
        [[[NSURLSession sharedSession]
            downloadTaskWithRequest:request
                  completionHandler:^(NSURL *_Nullable location, NSURLResponse *_Nullable response, NSError *_Nullable error) {
                      XCTAssertNil(error);
                      NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];

                      XCTAssert(statusCode > 199 && statusCode < 300, @"StatusCode not equal to 2xx! statu code is %ld, response is %@",
                                (long)statusCode, response);
                      [expectation fulfill];
                  }] resume];
    }];
    [[QCloudCOSXMLService defaultCOSXML] getPresignedURL:getPresignedURLRequest];
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)testListObjectVersions {
    QCloudPutBucketVersioningRequest *putBucketVersioningRequest = [[QCloudPutBucketVersioningRequest alloc] init];
    putBucketVersioningRequest.bucket = demoTestBucket.name;
    putBucketVersioningRequest.configuration = [[QCloudBucketVersioningConfiguration alloc] init];
    putBucketVersioningRequest.configuration.status = QCloudCOSBucketVersioningStatusEnabled;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [putBucketVersioningRequest setFinishBlock:^(id outputObject, NSError *error) {
        dispatch_semaphore_signal(semaphore);
    }];
    NSString *tempObject = [self uploadTempObject];
    NSString *tempObject2 = [self uploadTempObject];
    [[QCloudCOSXMLService defaultCOSXML] PutBucketVersioning:putBucketVersioningRequest];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    XCTestExpectation *expectation = [self expectationWithDescription:@"haha"];

    QCloudListObjectVersionsRequest *listObjectRequest = [[QCloudListObjectVersionsRequest alloc] init];
    listObjectRequest.maxKeys = 100;
    listObjectRequest.bucket = demoTestBucket.name;
    
    for (NSDictionary * dic in listObjectRequest.scopesArray) {
        NSString * action = dic[@"action"];
        XCTAssertTrue([action isEqualToString:@"name/cos:GetBucketObjectVersions"]);
    }
    
    [listObjectRequest setFinishBlock:^(QCloudListVersionsResult *_Nonnull result, NSError *_Nonnull error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);

        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] ListObjectVersions:listObjectRequest];
    [self waitForExpectationsWithTimeout:80 handler:nil];
    putBucketVersioningRequest.configuration.status = QCloudCOSBucketVersioningStatusSuspended;
    [[QCloudCOSXMLService defaultCOSXML] PutBucketVersioning:putBucketVersioningRequest];
}

- (void)testPutFolder {
    QCloudPutObjectRequest *putObjectRequest = [[QCloudPutObjectRequest alloc] init];
    putObjectRequest.bucket = demoTestBucket.name;
    putObjectRequest.object = @"testFolder/";
    XCTestExpectation *expectation = [self expectationWithDescription:@"put object"];

    [putObjectRequest setFinishBlock:^(id outputObject, NSError *error) {
        [expectation fulfill];
        XCTAssertNil(error, @"error occur during put object");
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutObject:putObjectRequest];
    [self waitForExpectationsWithTimeout:80 handler:nil];
}
- (void)testUploadPartCopyFromAnotherRegion {
    XCTestExpectation *uploadExpectation = [self expectationWithDescription:@"upload temp object"];
    QCloudCOSXMLUploadObjectRequest *uploadObjectRequest = [[QCloudCOSXMLUploadObjectRequest alloc] init];
    NSString *tempFileName = @"test/subtest/30MBTempFile";
    uploadObjectRequest.bucket = demoTestBucket.name;
    uploadObjectRequest.object = tempFileName;
    uploadObjectRequest.body = [NSURL fileURLWithPath:[self tempFileWithSize:30 * 1024 * 1024]];
    [uploadObjectRequest setFinishBlock:^(QCloudUploadObjectResult *result, NSError *error) {
        XCTAssertNil(error, @"error occures on uploading");
        [uploadExpectation fulfill];
    }];
    [[QCloudCOSTransferMangerService costransfermangerServiceForKey:kTestFromAnotherRegionCopy] UploadObject:uploadObjectRequest];
    [self waitForExpectationsWithTimeout:600 handler:nil];

    QCloudCOSXMLCopyObjectRequest *request = [[QCloudCOSXMLCopyObjectRequest alloc] init];

    request.bucket = demoTestBucket.name;
    request.object = @"copy-result-test";
    request.sourceBucket = uploadObjectRequest.bucket;
    request.sourceObject = tempFileName;
    request.sourceAPPID = self.appID;
    request.sourceRegion = [SecretStorage sharedInstance].region;

    XCTestExpectation *expectation = [self expectationWithDescription:@"Put Object Copy"];
    [request setFinishBlock:^(QCloudCopyObjectResult *result, NSError *error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudCOSTransferMangerService defaultCOSTransferManager] CopyObject:request];
    [self waitForExpectationsWithTimeout:10000 handler:nil];
}

- (void)testSampleCopyFromAnotherRegion {
    XCTestExpectation *uploadExpectation = [self expectationWithDescription:@"upload temp object"];
    QCloudCOSXMLUploadObjectRequest *uploadObjectRequest = [[QCloudCOSXMLUploadObjectRequest alloc] init];
    NSString *tempFileName = @"test/subtest/30MBTempFile";
    uploadObjectRequest.bucket = demoTestBucket.name;
    uploadObjectRequest.regionName = demoTestBucket.location;
    uploadObjectRequest.object = tempFileName;
    uploadObjectRequest.body = [NSURL fileURLWithPath:[self tempFileWithSize:1 * 1024 * 1024]];
    [uploadObjectRequest setFinishBlock:^(QCloudUploadObjectResult *result, NSError *error) {
        XCTAssertNil(error, @"error occures on uploading");
        [uploadExpectation fulfill];
    }];
    [[QCloudCOSTransferMangerService costransfermangerServiceForKey:kTestFromAnotherRegionCopy] UploadObject:uploadObjectRequest];
    [self waitForExpectationsWithTimeout:80 handler:nil];

    QCloudCOSXMLCopyObjectRequest *request = [[QCloudCOSXMLCopyObjectRequest alloc] init];

    request.bucket = demoTestBucket.name;
    request.object = @"copy-result-test";
    request.sourceBucket = uploadObjectRequest.bucket;
    request.sourceObject = tempFileName;
    request.sourceAPPID = self.appID;
    request.sourceRegion = [SecretStorage sharedInstance].region;
    request.regionName = demoTestBucket.location;
    XCTestExpectation *expectation = [self expectationWithDescription:@"Put Object Copy"];
    [request setFinishBlock:^(QCloudCopyObjectResult *result, NSError *error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudCOSTransferMangerService defaultCOSTransferManager] CopyObject:request];
    [self waitForExpectationsWithTimeout:10000 handler:nil];
}

@end
