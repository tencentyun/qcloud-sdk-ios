//
//  QCloudCOSTransferTests.m
//  QCloudCOSXMLDemo
//
//  Created by Dong Zhao on 2017/5/23.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import "TestCommonDefine.h"

#import <XCTest/XCTest.h>
#import <QCloudCOSXML/QCloudCOSXML.h>

#import "QCloudTestTempVariables.h"
#import "QCloudCOSXMLTestUtility.h"
#define kHTTPServiceKey @"HTTPService"
#import "SecretStorage.h"
@interface QCloudCOSTransferTests : XCTestCase <QCloudSignatureProvider>
@property (nonatomic, strong) NSString *bucket;
@property (nonatomic, strong) NSMutableArray *tempFilePathArray;

@end

@implementation QCloudCOSTransferTests

+ (void)setUp {
    [QCloudTestTempVariables sharedInstance].testBucket = [[QCloudCOSXMLTestUtility sharedInstance] createTestBucketWithPrefix:@"tf"];
}

+ (void)tearDown {
    [[QCloudCOSXMLTestUtility sharedInstance] deleteAllTestBuckets];
}

- (void)setUp {
    [super setUp];
    self.tempFilePathArray = [[NSMutableArray alloc] init];
    //    static dispatch_once_t onceToken;
    //    dispatch_once(&onceToken, ^{
    //        [QCloudTestTempVariables sharedInstance].testBucket = [[QCloudCOSXMLTestUtility sharedInstance] createTestBucket];
    //    });
    self.bucket = [QCloudTestTempVariables sharedInstance].testBucket;
    [self registerHTTPTransferManager];
}

- (void)tearDown {
    [super tearDown];
    NSFileManager *manager = [NSFileManager defaultManager];

    for (NSString *tempFilePath in self.tempFilePathArray) {
        if ([manager fileExistsAtPath:tempFilePath]) {
            [manager removeItemAtPath:tempFilePath error:nil];
        }
    }
}

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

#pragma mark -tool
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

- (void)registerHTTPTransferManager {
    if ([QCloudCOSXMLService hasServiceForKey:kHTTPServiceKey]) {
        return;
    }
    QCloudServiceConfiguration *configuration = [QCloudServiceConfiguration new];
    configuration.appID = kAppID;
    configuration.signatureProvider = self;
    QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.useHTTPS = YES;
    endpoint.regionName = kRegion;
    configuration.endpoint = endpoint;

    [QCloudCOSTransferMangerService registerCOSTransferMangerWithConfiguration:configuration withKey:kHTTPServiceKey];
    [QCloudCOSXMLService registerCOSXMLWithConfiguration:configuration withKey:kHTTPServiceKey];
}

- (void)testMultiUpload {
    QCloudCOSXMLUploadObjectRequest *put = [QCloudCOSXMLUploadObjectRequest new];

    int randomNumber = arc4random() % 100;

    NSURL *url = [NSURL fileURLWithPath:[self tempFileWithSize:100 * 1024 * 1024]];
    __block NSString *object = [NSUUID UUID].UUIDString;
    put.body = url;
    put.object = object;
    put.bucket = self.bucket;

    //    put.enableMD5Verification = NO;

    [put setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"upload %lld totalSend %lld aim %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
    }];
    __block QCloudGetObjectRequest *request = [QCloudGetObjectRequest new];
    request.downloadingURL = [NSURL URLWithString:QCloudTempFilePathWithExtension(@"downding")];
    XCTestExpectation *exp = [self expectationWithDescription:@"testMultiUpload upload object expectation"];
    __block QCloudUploadObjectResult *result;
    [put setFinishBlock:^(QCloudUploadObjectResult *result, NSError *error) {
        XCTAssertNotNil(result);
        XCTAssertNotNil([result location]);

        XCTAssertNotNil([result eTag]);
        request.bucket = self.bucket;

        request.object = object;
        request.enableMD5Verification = YES;
        //        [request setFinishBlock:^(id outputObject, NSError *error) {
        //            QCloudLogInfo(@"outputObject%@",outputObject);
        //            XCTAssertNil(error);
        [exp fulfill];
        //        }];
        //        [request setDownProcessBlock:^(int64_t bytesDownload, int64_t totalBytesDownload, int64_t totalBytesExpectedToDownload) {
        //            NSLog(@"⏬⏬⏬⏬DOWN [Total]%lld  [Downloaded]%lld [Download]%lld", totalBytesExpectedToDownload, totalBytesDownload,
        //            bytesDownload);
        //        }];
        //        [[QCloudCOSXMLService defaultCOSXML] GetObject:request];
    }];

    [[QCloudCOSTransferMangerService defaultCOSTransferManager] UploadObject:put];
    [self waitForExpectationsWithTimeout:18000
                                 handler:^(NSError *_Nullable error) {
                                 }];
}

- (void)testMultiUploadWithIntelligentTiering {
    QCloudCOSXMLUploadObjectRequest *put = [QCloudCOSXMLUploadObjectRequest new];
    int randomNumber = arc4random() % 100;
    NSURL *url = [NSURL fileURLWithPath:[self tempFileWithSize:3 * 1024 * 1024]];
    __block NSString *object = [NSUUID UUID].UUIDString;
    put.body = url;
    put.object = object;
    put.bucket = @"karis-maz";
    put.storageClass = QCloudCOSStorageMAZ_INTELLIGENT_TIERING;
    [put setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"upload %lld totalSend %lld aim %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
    }];
    XCTestExpectation *exp = [self expectationWithDescription:@"testMultiUpload upload object expectation"];
    __block QCloudUploadObjectResult *result;
    [put setFinishBlock:^(QCloudUploadObjectResult *result, NSError *error) {
        XCTAssertNotNil(result);
        XCTAssertNotNil([result location]);
        XCTAssertNil(error);
        [exp fulfill];
    }];
    [[QCloudCOSTransferMangerService defaultCOSTransferManager] UploadObject:put];
    [self waitForExpectationsWithTimeout:200
                                 handler:^(NSError *_Nullable error) {
                                 }];
}

- (void)testMultiUploadWithDeepArchive {
    QCloudCOSXMLUploadObjectRequest *put = [QCloudCOSXMLUploadObjectRequest new];
    int randomNumber = arc4random() % 100;
    NSURL *url = [NSURL fileURLWithPath:[self tempFileWithSize:3 * 1024 * 1024]];
    __block NSString *object = [NSUUID UUID].UUIDString;
    put.body = url;
    put.object = @"deep-archive";
    put.bucket = self.bucket;
    put.storageClass = QCloudCOSStorageDEEP_ARCHIVE;
    [put setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"upload %lld totalSend %lld aim %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
    }];
    XCTestExpectation *exp = [self expectationWithDescription:@"testMultiUpload upload object expectation"];
    __block QCloudUploadObjectResult *result;
    [put setFinishBlock:^(QCloudUploadObjectResult *result, NSError *error) {
        XCTAssertNotNil(result);
        XCTAssertNotNil([result location]);
        XCTAssertNil(error);
        [exp fulfill];
    }];
    [[QCloudCOSTransferMangerService defaultCOSTransferManager] UploadObject:put];
    [self waitForExpectationsWithTimeout:200
                                 handler:^(NSError *_Nullable error) {
                                 }];
}

- (void)testHTTPSMultipleUpload {
    QCloudCOSXMLUploadObjectRequest *put = [QCloudCOSXMLUploadObjectRequest new];
    int randomNumber = arc4random() % 100;
    NSURL *url = [NSURL fileURLWithPath:[self tempFileWithSize:15 * 1024 * 1024 + randomNumber]];
    put.object = [NSUUID UUID].UUIDString;
    put.bucket = self.bucket;
    put.body = url;
    [put setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"upload %lld totalSend %lld aim %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
    }];
    XCTestExpectation *exp = [self expectationWithDescription:@"delete33"];
    __block id result;
    [put setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNotNil(outputObject);
        [exp fulfill];
    }];
    [[QCloudCOSTransferMangerService costransfermangerServiceForKey:kHTTPServiceKey] UploadObject:put];
    [self waitForExpectationsWithTimeout:18000
                                 handler:^(NSError *_Nullable error) {
                                 }];
}
// SSE-C简单上传
- (void)testSimplePut_GetWithSSE {
    QCloudPutObjectRequest *put = [QCloudPutObjectRequest new];

    put.object = @"SSE-Simple-Upload";
    put.bucket = self.bucket;
    put.body = [@"This is test content" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *customKey = @"123456qwertyuioplkjhgfdsazxcvbnm";
    //    [put setCOSServerSideEncyptionWithCustomerKey:customKey];
    XCTestExpectation *exp = [self expectationWithDescription:@"delete"];
    __block NSError *resultError;
    __block NSDictionary *dic;
    [put setFinishBlock:^(id outputObject, NSError *error) {
        NSLog(@"region test%@", outputObject);
        XCTAssertNil(error, @"put Object fail!");
        if (outputObject) {
            dic = (NSDictionary *)outputObject;
        }
        [exp fulfill];
    }];
    [[QCloudCOSXMLService cosxmlServiceForKey:kHTTPServiceKey] PutObject:put];
    [self waitForExpectationsWithTimeout:80 handler:nil];

    __block XCTestExpectation *getObjectExpectation = [self expectationWithDescription:@"Get Object Expectation"];
    QCloudCOSXMLDownloadObjectRequest *getObjectRequest = [[QCloudCOSXMLDownloadObjectRequest alloc] init];
    //    [getObjectRequest setCOSServerSideEncyptionWithCustomerKey:customKey];
    getObjectRequest.bucket = self.bucket;
    getObjectRequest.object = put.object;
    [getObjectRequest setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error, @"Get Object Fail!");
        [getObjectExpectation fulfill];
    }];

    [[QCloudCOSTransferMangerService costransfermangerServiceForKey:kHTTPServiceKey] DownloadObject:getObjectRequest];
    [self waitForExpectationsWithTimeout:80 handler:nil];
}
// SSE-C uploadObject 简单上传
- (void)testSimplePut_GetObjectUseUploadObjectWithSSE {
    __block XCTestExpectation *Expectation = [self expectationWithDescription:@"Put Object Expectation"];
    __block QCloudCOSXMLUploadObjectRequest *uploadObjectRequest = [[QCloudCOSXMLUploadObjectRequest alloc] init];
    uploadObjectRequest.bucket = self.bucket;
    uploadObjectRequest.object = @"SSE-Simple-Upload";
    uploadObjectRequest.body = [@"This is test content" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *customKey = @"123456qwertyuioplkjhgfdsazxcvbnm";

    [uploadObjectRequest setCOSServerSideEncyptionWithCustomerKey:customKey];
    NSLog(@"customHeaders: %@", uploadObjectRequest.customHeaders);
    [uploadObjectRequest setFinishBlock:^(QCloudUploadObjectResult *result, NSError *error) {
        XCTAssertNotNil(result);
        XCTAssertNotNil([result location]);
        XCTAssertNil(error, @"put Object fail!");
        [Expectation fulfill];
    }];
    [[QCloudCOSTransferMangerService costransfermangerServiceForKey:kHTTPServiceKey] UploadObject:uploadObjectRequest];
    [self waitForExpectationsWithTimeout:10 handler:nil];

    __block XCTestExpectation *GetObjectExpectation = [self expectationWithDescription:@"Put Object Expectation"];
    QCloudCOSXMLDownloadObjectRequest *downloadRequest = [[QCloudCOSXMLDownloadObjectRequest alloc] init];
    downloadRequest.bucket = self.bucket;
    //设置下载的路径 URL，如果设置了，文件将会被下载到指定路径中
    downloadRequest.object = @"SSE-Simple-Upload";
    downloadRequest.downloadingURL = [NSURL fileURLWithPath:[QCloudTempDir() stringByAppendingPathComponent:downloadRequest.object]];
    [downloadRequest setCOSServerSideEncyptionWithCustomerKey:customKey];
    [downloadRequest setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error, @"Get Object Fail!");
        [GetObjectExpectation fulfill];
    }];
    [downloadRequest setDownProcessBlock:^(int64_t bytesDownload, int64_t totalBytesDownload, int64_t totalBytesExpectedToDownload) {
        QCloudLogInfo(@"bytesDownload: %lld  totalBytesDownload :%lld  totalBytesExpectedToDownload:%lld ", bytesDownload, totalBytesDownload,
                      totalBytesExpectedToDownload);
    }];
    [[QCloudCOSTransferMangerService costransfermangerServiceForKey:kHTTPServiceKey] DownloadObject:downloadRequest];
    [self waitForExpectationsWithTimeout:10 handler:nil];
}

// SSE-C uploadObject 简单上传
- (void)testDownloadObjectWithSSE {
    __block XCTestExpectation *Expectation = [self expectationWithDescription:@"Put Object Expectation"];
    __block QCloudCOSXMLUploadObjectRequest *uploadObjectRequest = [[QCloudCOSXMLUploadObjectRequest alloc] init];
    uploadObjectRequest.bucket = self.bucket;
    uploadObjectRequest.object = @"SSE-Simple-Upload";
    uploadObjectRequest.body = [@"This is test content" dataUsingEncoding:NSUTF8StringEncoding];

    NSString *customKey = @"123456qwertyuioplkjhgfdsazxcvbnm";
    [uploadObjectRequest setCOSServerSideEncyptionWithCustomerKey:customKey];
    [uploadObjectRequest setFinishBlock:^(QCloudUploadObjectResult *result, NSError *error) {
        XCTAssertNil(error, @"put Object fail!");
        [Expectation fulfill];
    }];

    [[QCloudCOSTransferMangerService costransfermangerServiceForKey:kHTTPServiceKey] UploadObject:uploadObjectRequest];
    [self waitForExpectationsWithTimeout:10 handler:nil];

    __block XCTestExpectation *downloadObjectExp = [self expectationWithDescription:@"download Object Expectation"];
    QCloudCOSXMLDownloadObjectRequest *downloadRequest = [[QCloudCOSXMLDownloadObjectRequest alloc] init];
    downloadRequest.bucket = self.bucket;
    //设置下载的路径 URL，如果设置了，文件将会被下载到指定路径中
    downloadRequest.object = @"SSE-Simple-Upload";
    downloadRequest.downloadingURL = [NSURL fileURLWithPath:[QCloudTempDir() stringByAppendingPathComponent:downloadRequest.object]];
    [downloadRequest setCOSServerSideEncyptionWithCustomerKey:customKey];
    [downloadRequest setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error, @"Get Object Fail!");
        [downloadObjectExp fulfill];
    }];
    [downloadRequest setDownProcessBlock:^(int64_t bytesDownload, int64_t totalBytesDownload, int64_t totalBytesExpectedToDownload) {
        QCloudLogInfo(@"testDownloadObject bytesDownload: %lld  totalBytesDownload :%lld  totalBytesExpectedToDownload:%lld ", bytesDownload,
                      totalBytesDownload, totalBytesExpectedToDownload);
    }];
    [[QCloudCOSTransferMangerService costransfermangerServiceForKey:kHTTPServiceKey] DownloadObject:downloadRequest];
    [self waitForExpectationsWithTimeout:10 handler:nil];
}
- (void)testHeadObjectWithSSE {
    __block XCTestExpectation *Expectation = [self expectationWithDescription:@"Put Object Expectation"];
    __block QCloudCOSXMLUploadObjectRequest *uploadObjectRequest = [[QCloudCOSXMLUploadObjectRequest alloc] init];

    uploadObjectRequest.bucket = self.bucket;
    uploadObjectRequest.object = @"SSE-part-Upload";
    uploadObjectRequest.body = [NSURL fileURLWithPath:[self tempFileWithSize:2 * 1024 * 1024]];
    NSString *customKey = @"123456qwertyuioplkjhgfdsazxcvbnm";

    [uploadObjectRequest setCOSServerSideEncyptionWithCustomerKey:customKey];

    [uploadObjectRequest setFinishBlock:^(QCloudUploadObjectResult *result, NSError *error) {
        QCloudLogInfo(@"__originHTTPURLResponse__:  %@", result.__originHTTPURLResponse__.allHeaderFields);
        XCTAssertNil(error, @"put Object fail!");
        [Expectation fulfill];
    }];
    [[QCloudCOSTransferMangerService costransfermangerServiceForKey:kHTTPServiceKey] UploadObject:uploadObjectRequest];
    [self waitForExpectationsWithTimeout:80 handler:nil];

    __block XCTestExpectation *headObjectExpectation = [self expectationWithDescription:@"Put Object Expectation"];
    QCloudHeadObjectRequest *headObjectRequest = [[QCloudHeadObjectRequest alloc] init];
    [headObjectRequest setCOSServerSideEncyptionWithCustomerKey:customKey];
    [headObjectRequest setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error);
        [headObjectExpectation fulfill];
    }];
    headObjectRequest.bucket = self.bucket;
    headObjectRequest.object = @"SSE-part-Upload";
    [[QCloudCOSXMLService cosxmlServiceForKey:kHTTPServiceKey] HeadObject:headObjectRequest];
    [self waitForExpectationsWithTimeout:80 handler:nil];
}
////SSE-C分块上传
- (void)testMultiplePut_GetObjectWithSSE {
    __block XCTestExpectation *Expectation = [self expectationWithDescription:@"Put Object Expectation"];
    __block QCloudCOSXMLUploadObjectRequest *uploadObjectRequest = [[QCloudCOSXMLUploadObjectRequest alloc] init];
    uploadObjectRequest.enableMD5Verification = NO;
    uploadObjectRequest.bucket = self.bucket;
    uploadObjectRequest.object = @"SSE-part-Upload";
    uploadObjectRequest.body = [NSURL fileURLWithPath:[self tempFileWithSize:2 * 1024 * 1024]];
    NSString *customKey = @"123456qwertyuioplkjhgfdsazxcvbnm";

    [uploadObjectRequest setCOSServerSideEncyptionWithCustomerKey:customKey];

    [uploadObjectRequest setFinishBlock:^(QCloudUploadObjectResult *result, NSError *error) {
        QCloudLogInfo(@"__originHTTPURLResponse__:  %@", result.__originHTTPURLResponse__.allHeaderFields);
        XCTAssertNil(error, @"put Object fail!");
        [Expectation fulfill];
    }];
    [[QCloudCOSTransferMangerService costransfermangerServiceForKey:kHTTPServiceKey] UploadObject:uploadObjectRequest];
    [self waitForExpectationsWithTimeout:100 handler:nil];

    __block XCTestExpectation *getObjecExpectation = [self expectationWithDescription:@"Put Object Expectation"];
    QCloudGetObjectRequest *getObjectRequest = [[QCloudGetObjectRequest alloc] init];
    getObjectRequest.bucket = self.bucket;

    getObjectRequest.object = @"SSE-part-Upload";
    [getObjectRequest setCOSServerSideEncyptionWithCustomerKey:customKey];
    [getObjectRequest setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error, @"Get Object Fail!");
        [getObjecExpectation fulfill];
    }];
    [getObjectRequest setDownProcessBlock:^(int64_t bytesDownload, int64_t totalBytesDownload, int64_t totalBytesExpectedToDownload) {
        QCloudLogInfo(@"bytesDownload: %lld  totalBytesDownload :%lld  totalBytesExpectedToDownload:%lld ", bytesDownload, totalBytesDownload,
                      totalBytesExpectedToDownload);
    }];
    [[QCloudCOSXMLService cosxmlServiceForKey:kHTTPServiceKey] GetObject:getObjectRequest];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}
- (void)testCopySmallFileWithSSE {
    NSString *tempBucket = [[QCloudCOSXMLTestUtility sharedInstance] createTestBucketWithPrefix:@"tf"];
    NSString *tempFileName = @"30MBTempFile";

    XCTestExpectation *uploadChineseNameSmallFileExpectation = [self expectationWithDescription:@"upload temp object"];

    QCloudCOSXMLUploadObjectRequest *uploadObjectRequest1 = [[QCloudCOSXMLUploadObjectRequest alloc] init];

    NSString *customKey = @"123456qwertyuioplkjhgfdsazxcvbnm";

    [uploadObjectRequest1 setCOSServerSideEncyptionWithCustomerKey:customKey];
    uploadObjectRequest1.bucket = tempBucket;
    uploadObjectRequest1.object = @"copy小文件 SSEC";
    uploadObjectRequest1.body = [NSURL fileURLWithPath:[self tempFileWithSize:1024]];
    [uploadObjectRequest1 setFinishBlock:^(QCloudUploadObjectResult *result, NSError *error) {
        QCloudLogInfo(@"tttt  %@", result.__originHTTPURLResponse__.allHeaderFields);
        XCTAssertNil(error, @"error occures on uploading");
        [uploadChineseNameSmallFileExpectation fulfill];
    }];
    [[QCloudCOSTransferMangerService costransfermangerServiceForKey:kHTTPServiceKey] UploadObject:uploadObjectRequest1];
    [self waitForExpectationsWithTimeout:80 handler:nil];

    QCloudCOSXMLCopyObjectRequest *request = [[QCloudCOSXMLCopyObjectRequest alloc] init];
    [request setCOSServerSideEncyptionWithCustomerKey:customKey];
    request.bucket = self.bucket;
    request.object = [NSString stringWithFormat:@"copy-%@", tempFileName];
    request.sourceBucket = tempBucket;
    request.sourceObject = uploadObjectRequest1.object;
    request.sourceAPPID = [QCloudCOSXMLService defaultCOSXML].configuration.appID;
    request.sourceRegion = [QCloudCOSXMLService defaultCOSXML].configuration.endpoint.regionName;
    XCTestExpectation *expectation = [self expectationWithDescription:@"Put Object Copy"];
    [request setFinishBlock:^(QCloudCopyObjectResult *result, NSError *error) {
        NSLog(@"resulttest %@", result.__originHTTPURLResponse__.allHeaderFields);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudCOSTransferMangerService costransfermangerServiceForKey:kHTTPServiceKey] CopyObject:request];
    [self waitForExpectationsWithTimeout:10000 handler:nil];
}
- (void)testCopyBigFileWithSSE {
    NSString *tempBucket = [[QCloudCOSXMLTestUtility sharedInstance] createTestBucketWithPrefix:@"tf"];
    NSString *tempFileName = @"30MBTempFile";

    XCTestExpectation *uploadChineseNameBigFileExpectation = [self expectationWithDescription:@"upload temp object"];
    NSString *customKey = @"123456qwertyuioplkjhgfdsazxcvbnm";

    QCloudCOSXMLUploadObjectRequest *uploadObjectRequest2 = [[QCloudCOSXMLUploadObjectRequest alloc] init];

    [uploadObjectRequest2 setCOSServerSideEncyptionWithCustomerKey:customKey];
    uploadObjectRequest2.bucket = tempBucket;
    uploadObjectRequest2.object = @"中文名Copy大文件";
    uploadObjectRequest2.body = [NSURL fileURLWithPath:[self tempFileWithSize:30 * 1024 * 1024]];
    [uploadObjectRequest2 setFinishBlock:^(QCloudUploadObjectResult *result, NSError *error) {
        NSLog(@"allHeaderFields:  %@", result.__originHTTPURLResponse__.allHeaderFields);
        XCTAssertNil(error, @"error occures on uploading");
        [uploadChineseNameBigFileExpectation fulfill];
    }];
    [[QCloudCOSTransferMangerService costransfermangerServiceForKey:kHTTPServiceKey] UploadObject:uploadObjectRequest2];
    [self waitForExpectationsWithTimeout:600 handler:nil];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Put Object Copy"];

    QCloudCOSXMLCopyObjectRequest *request = [[QCloudCOSXMLCopyObjectRequest alloc] init];
    [request setCOSServerSideEncyptionWithCustomerKey:customKey];
    request.bucket = self.bucket;
    request.object = [NSString stringWithFormat:@"copy-%@", tempFileName];
    request.sourceBucket = tempBucket;
    request.sourceObject = uploadObjectRequest2.object;
    request.sourceAPPID = [QCloudCOSXMLService defaultCOSXML].configuration.appID;
    request.sourceRegion = [QCloudCOSXMLService defaultCOSXML].configuration.endpoint.regionName;
    NSLog(@"customHeaders %@", request.customHeaders);
    [request setFinishBlock:^(QCloudCopyObjectResult *result, NSError *error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudCOSTransferMangerService costransfermangerServiceForKey:kHTTPServiceKey] CopyObject:request];
    [self waitForExpectationsWithTimeout:10000 handler:nil];
}

////SSE-C简单上传
//- (void)testSimplePut_GetWithSSEKMS {
//
//    QCloudPutObjectRequest* put = [QCloudPutObjectRequest new];
//
//    put.object = @"SSEKMS-Simple-Upload";
//    put.bucket =self.bucket;
//    put.body =  [@"This is test content" dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *arrJsonStr = @"{\"key\":\"value\"}";
//    [put setCOSServerSideEncyptionWithKMSCustomKey:nil jsonStr:arrJsonStr];
//    XCTestExpectation* exp = [self expectationWithDescription:@"delete"];
//    __block NSError* resultError;
//    __block  NSDictionary *dic;
//    [put setFinishBlock:^(id outputObject, NSError *error) {
//        XCTAssertNil(error,@"put Object fail!");
//        if (outputObject) {
//            dic = (NSDictionary *)outputObject;
//        }
//        [exp fulfill];
//    }];
//    [[QCloudCOSXMLService cosxmlServiceForKey:kHTTPServiceKey] PutObject:put];
//    [self waitForExpectationsWithTimeout:80 handler:nil];
//
//    __block XCTestExpectation* getObjectExpectation = [self expectationWithDescription:@"Get Object Expectation"];
//    QCloudGetObjectRequest* getObjectRequest = [[QCloudGetObjectRequest alloc] init];
//    getObjectRequest.bucket = self.bucket;
//    getObjectRequest.object = put.object;
//    [getObjectRequest setFinishBlock:^(id outputObject, NSError *error) {
//        XCTAssertNil(error,@"Get Object Fail!");
//        [getObjectExpectation fulfill];
//    }];
//    [[QCloudCOSXMLService cosxmlServiceForKey:kHTTPServiceKey] GetObject:getObjectRequest];
//    [self waitForExpectationsWithTimeout:80 handler:nil];
//}
//- (void)testSimplePut_Get_Head_Object_copy_WithSSEKMS {
//;
//    NSString* tempBucket = [[QCloudCOSXMLTestUtility sharedInstance] createTestBucketWithPrefix:@"tf"];
//
//    __block XCTestExpectation* putObejctExpectation = [self expectationWithDescription:@"Put Object Expectation"];
//    QCloudCOSXMLUploadObjectRequest* uploadObjectRequest = [[QCloudCOSXMLUploadObjectRequest alloc] init];
//
//    uploadObjectRequest.bucket = tempBucket;
//    uploadObjectRequest.object = @"SSEKMS-Simple-Upload";
//    uploadObjectRequest.body = [NSURL fileURLWithPath:[self tempFileWithSize:1024*1024]];
//    NSString *arrJsonStr = @"{\"key\":\"value\"}";
//    [uploadObjectRequest setCOSServerSideEncyptionWithKMSCustomKey:nil jsonStr:arrJsonStr];
//    [uploadObjectRequest setFinishBlock:^(QCloudUploadObjectResult *result, NSError *error) {
//        NSLog(@"QCloudUploadObjectResult result  %@ ",result.__originHTTPURLResponse__.allHeaderFields);
//        XCTAssertNil(error);
//        [putObejctExpectation fulfill];
//    }];
//    [[QCloudCOSTransferMangerService costransfermangerServiceForKey:kHTTPServiceKey] UploadObject:uploadObjectRequest];
//    [self waitForExpectationsWithTimeout:100 handler:nil];
//
//    __block XCTestExpectation* getObjecExpectation = [self expectationWithDescription:@"get Object Expectation"];
//    QCloudGetObjectRequest* getObjectRequest = [[QCloudGetObjectRequest alloc] init];
//    getObjectRequest.enableMD5Verification = NO;
//    getObjectRequest.bucket = uploadObjectRequest.bucket;
//    getObjectRequest.object = uploadObjectRequest.object;
//    [getObjectRequest setFinishBlock:^(id outputObject, NSError *error) {
//        XCTAssertNil(error,@"Get Object Fail!");
//        [getObjecExpectation fulfill];
//    }];
//    [[QCloudCOSXMLService cosxmlServiceForKey:kHTTPServiceKey] GetObject:getObjectRequest];
//    [self waitForExpectationsWithTimeout:80 handler:nil];
//
//    __block XCTestExpectation* headObjectExpectation = [self expectationWithDescription:@"Put Object Expectation"];
//    QCloudHeadObjectRequest* headObjectRequest = [[QCloudHeadObjectRequest alloc] init];
//    [headObjectRequest setFinishBlock:^(id outputObject, NSError *error) {
//        XCTAssertNil(error);
//        [headObjectExpectation fulfill];
//    }];
//    headObjectRequest.bucket = uploadObjectRequest.bucket;
//    headObjectRequest.object = uploadObjectRequest.object;
//    [[QCloudCOSXMLService cosxmlServiceForKey:kHTTPServiceKey] HeadObject:headObjectRequest];
//    [self waitForExpectationsWithTimeout:80 handler:nil];
//
//
////    QCloudCOSXMLCopyObjectRequest* request = [[QCloudCOSXMLCopyObjectRequest alloc] init];
////    [request setCOSServerSideEncyptionWithKMSCustomKey:nil jsonStr:arrJsonStr ];
////    request.bucket = self.bucket;
////    request.object = uploadObjectRequest.object;
////    request.sourceBucket = tempBucket;
////    request.sourceObject = uploadObjectRequest.object;
////    request.sourceAPPID = [QCloudCOSXMLService defaultCOSXML].configuration.appID;
////    request.sourceRegion= [QCloudCOSXMLService defaultCOSXML].configuration.endpoint.regionName;
////    XCTestExpectation* expectation = [self expectationWithDescription:@"Put Object Copy"];
////    [request setFinishBlock:^(QCloudCopyObjectResult* result, NSError* error) {
////        NSLog(@"resulttest %@",result.__originHTTPURLResponse__.allHeaderFields);
////        XCTAssertNil(error);
////        [expectation fulfill];
////    }];
////    [[QCloudCOSTransferMangerService costransfermangerServiceForKey:kHTTPServiceKey] CopyObject:request];
////    [self waitForExpectationsWithTimeout:10000 handler:nil];
//
//
//}
//
//- (void)testMultiplePut_Get_head_Object_copy_WithSSEKMS {
//    NSString* tempBucket = [[QCloudCOSXMLTestUtility sharedInstance] createTestBucketWithPrefix:@"tf"];
//    __block XCTestExpectation* putObejctExpectation = [self expectationWithDescription:@"Put Object Expectation"];
//    QCloudCOSXMLUploadObjectRequest* uploadObjectRequest = [[QCloudCOSXMLUploadObjectRequest alloc] init];
//
//    uploadObjectRequest.bucket = tempBucket;
//    uploadObjectRequest.object = @"SSE-mutiupload-Upload";
//    uploadObjectRequest.body = [NSURL fileURLWithPath:[self tempFileWithSize:20*1024*1024]];
//    NSString *arrJsonStr = @"{\"key\":\"value\"}";
//    [uploadObjectRequest setCOSServerSideEncyptionWithKMSCustomKey:nil jsonStr:arrJsonStr];
//    [uploadObjectRequest setFinishBlock:^(QCloudUploadObjectResult *result, NSError *error) {
//        NSLog(@"tMultiple UploadObjectResult result  %@ ",result.__originHTTPURLResponse__.allHeaderFields);
//         XCTAssertNil(error);
//        [putObejctExpectation fulfill];
//    }];
//    [[QCloudCOSTransferMangerService costransfermangerServiceForKey:kHTTPServiceKey] UploadObject:uploadObjectRequest];
//    [self waitForExpectationsWithTimeout:1000 handler:nil];
//
//    __block XCTestExpectation* getObjecExpectation = [self expectationWithDescription:@"get Object Expectation"];
//    QCloudGetObjectRequest* getObjectRequest = [[QCloudGetObjectRequest alloc] init];
//    getObjectRequest.bucket = uploadObjectRequest.bucket;
//    getObjectRequest.object = uploadObjectRequest.object;
//    [getObjectRequest setFinishBlock:^(id outputObject, NSError *error) {
//        XCTAssertNil(error,@"Get Object Fail!");
//        [getObjecExpectation fulfill];
//    }];
//    [[QCloudCOSXMLService cosxmlServiceForKey:kHTTPServiceKey] GetObject:getObjectRequest];
//    [self waitForExpectationsWithTimeout:1000 handler:nil];
//
//    __block XCTestExpectation* headObjectExpectation = [self expectationWithDescription:@"Put Object Expectation"];
//    QCloudHeadObjectRequest* headObjectRequest = [[QCloudHeadObjectRequest alloc] init];
//    [headObjectRequest setFinishBlock:^(id outputObject, NSError *error) {
//        XCTAssertNil(error);
//        [headObjectExpectation fulfill];
//    }];
//    headObjectRequest.bucket = uploadObjectRequest.bucket;
//    headObjectRequest.object = uploadObjectRequest.object;
//    [[QCloudCOSXMLService cosxmlServiceForKey:kHTTPServiceKey] HeadObject:headObjectRequest];
//    [self waitForExpectationsWithTimeout:1000 handler:nil];
//
////    QCloudCOSXMLCopyObjectRequest* request = [[QCloudCOSXMLCopyObjectRequest alloc] init];
////    request.bucket = self.bucket;
////    request.object = uploadObjectRequest.object;
////    request.sourceBucket = tempBucket;
////    request.sourceObject = uploadObjectRequest.object;
////    request.sourceAPPID = [QCloudCOSXMLService defaultCOSXML].configuration.appID;
////    request.sourceRegion= [QCloudCOSXMLService defaultCOSXML].configuration.endpoint.regionName;
////    XCTestExpectation* expectation = [self expectationWithDescription:@"Put Object Copy"];
////    [request setFinishBlock:^(QCloudCopyObjectResult* result, NSError* error) {
////        NSLog(@"resulttest %@",result.__originHTTPURLResponse__.allHeaderFields);
////        XCTAssertNil(error);
////        [expectation fulfill];
////    }];
////    [[QCloudCOSTransferMangerService costransfermangerServiceForKey:kHTTPServiceKey] CopyObject:request];
////    [self waitForExpectationsWithTimeout:10000 handler:nil];
//}

- (void)testChineseFileNameBigfileUpload {
    QCloudCOSXMLUploadObjectRequest *put = [QCloudCOSXMLUploadObjectRequest new];
    int randomNumber = arc4random() % 100;
    NSURL *url = [NSURL fileURLWithPath:[self tempFileWithSize:15 * 1024 * 1024 + randomNumber]];
    put.object = @"中文名大文件";
    put.bucket = self.bucket;
    put.body = url;
    [put setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"upload %lld totalSend %lld aim %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
    }];
    XCTestExpectation *exp = [self expectationWithDescription:@"delete33"];
    __block id result;
    [put setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error);
        result = outputObject;
        [exp fulfill];
    }];
    [put setInitMultipleUploadFinishBlock:^(QCloudInitiateMultipartUploadResult *result, QCloudCOSXMLUploadObjectResumeData resumeData) {
        NSString *uploadID = result.uploadId;
        NSLog(@"UploadID%@", uploadID);
    }];
    [[QCloudCOSTransferMangerService defaultCOSTransferManager] UploadObject:put];
    [self waitForExpectationsWithTimeout:18000
                                 handler:^(NSError *_Nullable error) {
                                 }];
    XCTAssertNotNil(result);
}

- (void)testChineseFileNameSmallFileUpload {
    QCloudCOSXMLUploadObjectRequest *put = [QCloudCOSXMLUploadObjectRequest new];
    int randomNumber = arc4random() % 100;
    NSURL *url = [NSURL fileURLWithPath:[self tempFileWithSize:200 + randomNumber]];
    put.object = @"中文名小文件";
    put.bucket = self.bucket;
    put.body = url;
    [put setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"upload %lld totalSend %lld aim %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
    }];
    XCTestExpectation *exp = [self expectationWithDescription:@"delete33"];
    __block id result;
    [put setFinishBlock:^(id outputObject, NSError *error) {
        result = outputObject;
        [exp fulfill];
    }];
    [[QCloudCOSTransferMangerService defaultCOSTransferManager] UploadObject:put];
    [self waitForExpectationsWithTimeout:18000
                                 handler:^(NSError *_Nullable error) {
                                 }];
    XCTAssertNotNil(result);
}

- (void)testSpecialCharacterFileNameBigFileUpoload {
    QCloudCOSXMLUploadObjectRequest *put = [QCloudCOSXMLUploadObjectRequest new];
    int randomNumber = arc4random() % 100;
    NSURL *url = [NSURL fileURLWithPath:[self tempFileWithSize:15 * 1024 * 1024 + randomNumber]];
    put.object = @"→↓←→↖↗↙↘! \"#$%&'()*+,-.0123456789:;<=>@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";
    put.bucket = self.bucket;
    put.body = url;
    [put setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"upload %lld totalSend %lld aim %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
    }];

    XCTestExpectation *exp = [self expectationWithDescription:@"delete33"];
    __block id result;
    [put setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error);
        result = outputObject;
        [exp fulfill];
    }];
    [[QCloudCOSTransferMangerService defaultCOSTransferManager] UploadObject:put];
    [self waitForExpectationsWithTimeout:18000
                                 handler:^(NSError *_Nullable error) {
                                 }];
    XCTAssertNotNil(result);
}

- (void)testSpecialCharacterFileSmallFileUpload {
    QCloudCOSXMLUploadObjectRequest *put = [QCloudCOSXMLUploadObjectRequest new];
    int randomNumber = arc4random() % 100;
    NSURL *url = [NSURL fileURLWithPath:[self tempFileWithSize:100 + randomNumber]];
    put.object = @"→↓←→↖↗↙↘! \"#$%&'()*+,-.0123456789:;<=>@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";
    put.bucket = self.bucket;
    put.body = url;
    [put setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"upload %lld totalSend %lld aim %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
    }];
    XCTestExpectation *exp = [self expectationWithDescription:@"delete33"];
    __block id result;
    [put setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error);
        result = outputObject;
        [exp fulfill];
    }];
    [[QCloudCOSTransferMangerService defaultCOSTransferManager] UploadObject:put];
    [self waitForExpectationsWithTimeout:18000
                                 handler:^(NSError *_Nullable error) {
                                 }];
    XCTAssertNotNil(result);
}

- (void)testIntegerTimesSliceMultipartUpload {
    QCloudCOSXMLUploadObjectRequest *put = [QCloudCOSXMLUploadObjectRequest new];
    NSURL *url = [NSURL fileURLWithPath:[self tempFileWithSize:50 * 1024 * 1024]];
    put.object = [NSUUID UUID].UUIDString;
    put.bucket = self.bucket;
    put.body = url;
    [put setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"upload %lld totalSend %lld aim %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
    }];
    XCTestExpectation *exp = [self expectationWithDescription:@"delete33"];
    __block id result;
    [put setFinishBlock:^(id outputObject, NSError *error) {
        result = outputObject;
        [exp fulfill];
    }];
    [[QCloudCOSTransferMangerService defaultCOSTransferManager] UploadObject:put];
    [self waitForExpectationsWithTimeout:18000
                                 handler:^(NSError *_Nullable error) {
                                 }];
    XCTAssertNotNil(result);
}

- (void)testChineseObjectName {
    QCloudCOSXMLUploadObjectRequest *put = [QCloudCOSXMLUploadObjectRequest new];
    NSURL *url = [NSURL fileURLWithPath:[self tempFileWithSize:1024]];
    put.object = @"一个文件名→↓←→↖↗↙↘! \"#$%&'()*+,-./0123456789:;<=>@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_";
    put.bucket = self.bucket;
    put.body = url;
    [put setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"upload %lld totalSend %lld aim %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
    }];
    XCTestExpectation *exp = [self expectationWithDescription:@"delete33"];
    __block id result;
    [put setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error);
        result = outputObject;
        [exp fulfill];
    }];
    [[QCloudCOSTransferMangerService defaultCOSTransferManager] UploadObject:put];
    [self waitForExpectationsWithTimeout:18000
                                 handler:^(NSError *_Nullable error) {
                                 }];
    XCTAssertNotNil(result);
}

- (void)testSmallSizeUpload {
    QCloudCOSXMLUploadObjectRequest *put = [QCloudCOSXMLUploadObjectRequest new];
    NSURL *url = [NSURL fileURLWithPath:[self tempFileWithSize:1024]];
    put.object = [NSUUID UUID].UUIDString;
    put.bucket = self.bucket;
    put.body = url;
    [put setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"upload %lld totalSend %lld aim %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
    }];
    XCTestExpectation *exp = [self expectationWithDescription:@"delete33"];
    __block id result;
    [put setFinishBlock:^(id outputObject, NSError *error) {
        result = outputObject;
        [exp fulfill];
    }];
    [[QCloudCOSTransferMangerService defaultCOSTransferManager] UploadObject:put];
    [self waitForExpectationsWithTimeout:18000
                                 handler:^(NSError *_Nullable error) {
                                 }];
    XCTAssertNotNil(result);
}
- (void)testAbortMultiUpload {
    QCloudCOSXMLUploadObjectRequest *put = [QCloudCOSXMLUploadObjectRequest new];
    int randomNumber = arc4random() % 100;
    NSURL *url = [NSURL fileURLWithPath:[self tempFileWithSize:304 * 1024 * 1024 + randomNumber]];
    put.object = [NSUUID UUID].UUIDString;
    put.bucket = self.bucket;
    put.body = url;

    XCTestExpectation *exp = [self expectationWithDescription:@"UploadObject exp"];
    __block QCloudUploadObjectResult *result;
    [put setFinishBlock:^(id outputObject, NSError *error) {
        result = outputObject;
        [exp fulfill];
    }];

    [put setInitMultipleUploadFinishBlock:^(QCloudInitiateMultipartUploadResult *multipleUploadInitResult,
                                            QCloudCOSXMLUploadObjectResumeData resumeData) {
        XCTAssertNotNil(multipleUploadInitResult.uploadId, @"UploadID is null!");

        QCloudCOSXMLUploadObjectRequest *uploadObjectRequest = [QCloudCOSXMLUploadObjectRequest requestWithRequestData:resumeData];
        XCTAssertNotNil([uploadObjectRequest valueForKey:@"uploadId"], @"request produce from resume data is nil!");
        NSLog(@"pause here");
    }];
    [put setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"upload %lld totalSend %lld aim %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
    }];
    [[QCloudCOSTransferMangerService defaultCOSTransferManager] UploadObject:put];

    XCTestExpectation *hintExp = [self expectationWithDescription:@"abort"];
    __block id abortResult = nil;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [put abort:^(id outputObject, NSError *error) {
            abortResult = outputObject;
            XCTAssertNil(error, @"Abort error is not nil! it is %@", error);
            [hintExp fulfill];
        }];
    });
    [self waitForExpectationsWithTimeout:100000 handler:nil];
    XCTAssertNotNil(abortResult);
}
- (void)testChainesePauseAndResume {
    NSString *file4MBPath = QCloudPathJoin(QCloudTempDir(), @"中文名文件");

    if (!QCloudFileExist(file4MBPath)) {
        [[NSFileManager defaultManager] createFileAtPath:file4MBPath contents:[NSData data] attributes:nil];
    }
    NSFileHandle *handler = [NSFileHandle fileHandleForWritingAtPath:file4MBPath];
    [handler truncateFileAtOffset:30 * 1024 * 1024];
    [handler closeFile];
    [self.tempFilePathArray addObject:file4MBPath];

    QCloudCOSXMLUploadObjectRequest *put = [QCloudCOSXMLUploadObjectRequest new];
    NSURL *url = [NSURL fileURLWithPath:file4MBPath];
    put.object = [NSUUID UUID].UUIDString;
    put.bucket = self.bucket;
    put.body = url;

    __block QCloudUploadObjectResult *result;
    [put setFinishBlock:^(id outputObject, NSError *error) {
        result = outputObject;
    }];

    [put setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"upload %lld totalSend %lld aim %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
    }];
    [[QCloudCOSTransferMangerService defaultCOSTransferManager] UploadObject:put];

    __block QCloudCOSXMLUploadObjectResumeData resumeData = nil;
    XCTestExpectation *resumeExp = [self expectationWithDescription:@"delete2"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSError *error;
        resumeData = [put cancelByProductingResumeData:&error];
        if (resumeData) {
            QCloudCOSXMLUploadObjectRequest *request = [QCloudCOSXMLUploadObjectRequest requestWithRequestData:resumeData];
            [request setFinishBlock:^(QCloudUploadObjectResult *outputObject, NSError *error) {
                result = outputObject;
                NSLog(@"result: %@", result);
                NSLog(@"result.location: %@", result.location);
                NSLog(@"result.eTag: %@", result.eTag);
                XCTAssertNil(error);
                XCTAssertNotNil(outputObject);
                [resumeExp fulfill];
            }];

            [request setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
                NSLog(@"upload %lld totalSend %lld aim %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
            }];
            [[QCloudCOSTransferMangerService defaultCOSTransferManager] UploadObject:request];
        } else {
            [resumeExp fulfill];
        }
    });

    [self waitForExpectationsWithTimeout:80000 handler:nil];
    XCTAssertNotNil(result);
    XCTAssertNotNil(result.location);
    XCTAssertNotNil(result.eTag);
}

- (void)testPauseAndResume {
    QCloudCOSXMLUploadObjectRequest *put = [QCloudCOSXMLUploadObjectRequest new];
    NSURL *url = [NSURL fileURLWithPath:[self tempFileWithSize:30 * 1024 * 1024]];
    put.object = [NSUUID UUID].UUIDString;
    put.bucket = self.bucket;
    put.body = url;

    __block QCloudUploadObjectResult *result;
    [put setFinishBlock:^(id outputObject, NSError *error) {
        result = outputObject;
    }];

    [put setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"upload %lld totalSend %lld aim %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
    }];
    [[QCloudCOSTransferMangerService defaultCOSTransferManager] UploadObject:put];

    __block QCloudCOSXMLUploadObjectResumeData resumeData = nil;
    XCTestExpectation *resumeExp = [self expectationWithDescription:@"delete2"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSError *error;
        resumeData = [put cancelByProductingResumeData:&error];

        if (resumeData) {
            QCloudCOSXMLUploadObjectRequest *request = [QCloudCOSXMLUploadObjectRequest requestWithRequestData:resumeData];
            [request setFinishBlock:^(QCloudUploadObjectResult *outputObject, NSError *error) {
                result = outputObject;
                NSLog(@"result: %@", result);
                NSLog(@"result.location: %@", result.location);
                NSLog(@"result.eTag: %@", result.eTag);
                XCTAssertNil(error);
                XCTAssertNotNil(outputObject);
                [resumeExp fulfill];
            }];

            [request setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
                NSLog(@"upload %lld totalSend %lld aim %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
            }];
            [[QCloudCOSTransferMangerService defaultCOSTransferManager] UploadObject:request];
        } else {
            [resumeExp fulfill];
        }
    });

    [self waitForExpectationsWithTimeout:80000 handler:nil];
    XCTAssertNotNil(result);
    XCTAssertNotNil(result.location);
    XCTAssertNotNil(result.eTag);
}

- (void)testSimpleUploadObjectWithServerSideEncryption {
    QCloudCOSXMLUploadObjectRequest *put = [QCloudCOSXMLUploadObjectRequest new];
    NSURL *url = [NSURL fileURLWithPath:[self tempFileWithSize:1 * 1024]];
    __block NSString *object = @"testSimpleUploadObjectWithSSE";
    put.object = object;
    put.bucket = self.bucket;
    put.body = url;
    NSString *originalMD5 = QCloudEncrytFileMD5(url.path);
    [put setCOSServerSideEncyption];
    XCTestExpectation *expectation = [self expectationWithDescription:@"simple upload object with server side encryption"];
    [put setFinishBlock:^(QCloudUploadObjectResult *result, NSError *error) {
        XCTAssertNotNil(result, @"upload result is nil!");
        XCTAssertNotNil(result.__originHTTPURLResponse__, @"original responsee data is nil!");
        XCTAssertNotNil(result.__originHTTPURLResponse__.allHeaderFields[@"x-cos-server-side-encryption"],
                        @"cannot found x-cos-server-side-encryption header in reponse");
        XCTAssert([result.__originHTTPURLResponse__.allHeaderFields[@"x-cos-server-side-encryption"] isEqualToString:@"AES256"]);

        QCloudGetObjectRequest *getObjectRequest = [[QCloudGetObjectRequest alloc] init];
        getObjectRequest.bucket = self.bucket;
        getObjectRequest.object = object;
        NSURL *downloadPath = [NSURL fileURLWithPath:[QCloudTempDir() stringByAppendingPathComponent:@"test"]];
        //设置下载的路径 URL，如果设置了，文件将会被下载到指定路径中
        getObjectRequest.downloadingURL = downloadPath;
        [getObjectRequest setFinishBlock:^(id outputObject, NSError *error) {
            XCTAssertNil(error, @"download object fail, error is %@", error);
            XCTAssertNotNil(outputObject[@"x-cos-server-side-encryption"]);
            NSString *downloadedMD5 = QCloudEncrytFileMD5(downloadPath.path);
            XCTAssert([downloadedMD5 isEqualToString:originalMD5], @"downloaded md5 %@  %@is not equal to original md5!", downloadedMD5, originalMD5);
            [expectation fulfill];
        }];
        [[QCloudCOSXMLService defaultCOSXML] GetObject:getObjectRequest];
    }];
    [[QCloudCOSTransferMangerService defaultCOSTransferManager] UploadObject:put];
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

//- (void)testMultipartUploadObjectWithServerSideEncryption {
//    QCloudCOSXMLUploadObjectRequest* put = [QCloudCOSXMLUploadObjectRequest new];
//    NSURL* url = [NSURL fileURLWithPath:[self tempFileWithSize:10*1024*1024]];
//    __block NSString* object = [NSUUID UUID].UUIDString;
//    put.object = object;
//    put.bucket = self.bucket;
//    put.body =  url;
//    NSString* originalMD5 = QCloudEncrytFileMD5(url.path);
//    put.customHeaders = @{@"x-cos-server-side-encryption":@"AES256"};
//    XCTestExpectation* expectation = [self expectationWithDescription:@"simple upload object with server side encryption"];
//    [put setFinishBlock:^(QCloudUploadObjectResult *result, NSError *error) {
//        XCTAssertNotNil(result, @"upload result is nil!");
//        XCTAssertNotNil(result.__originHTTPURLResponse__,@"original responsee data is nil!");
//        XCTAssertNotNil(result.__originHTTPURLResponse__.allHeaderFields[@"x-cos-server-side-encryption"],@"cannot found
//        x-cos-server-side-encryption header in reponse");
//        XCTAssert([result.__originHTTPURLResponse__.allHeaderFields[@"x-cos-server-side-encryption"] isEqualToString:@"AES256"]);
//
//        QCloudGetObjectRequest* getObjectRequest = [[QCloudGetObjectRequest alloc] init];
//        getObjectRequest.bucket = self.bucket;
//        getObjectRequest.object = object;
//        NSURL* downloadPath = [NSURL fileURLWithPath:[QCloudTempDir() stringByAppendingPathComponent:@"temp"]];
//        getObjectRequest.downloadingURL = downloadPath;
//        [getObjectRequest setFinishBlock:^(id outputObject, NSError *error) {
//            XCTAssertNil(error,@"download object fail, error is %@",error);
//            NSString* downloadedMD5 = QCloudEncrytFileMD5(downloadPath.path);
//            XCTAssert([downloadedMD5 isEqualToString:originalMD5],@"downloaded md5 is not equal to original md5!");
//        }];
//        [expectation fulfill];
//    }];
//    [[QCloudCOSTransferMangerService defaultCOSTransferManager] UploadObject:put];
//    [self waitForExpectationsWithTimeout:80 handler:nil];
//}

- (void)testSelectObject {
    QCloudSelectObjectContentRequest *request = [QCloudSelectObjectContentRequest new];
    request.bucket = @"1504078136-1253653367";
    request.regionName = @"ap-guangzhou";
    request.object = @"test.csv";
    request.selectType = @"2";
    QCloudSelectObjectContentConfig *config = [QCloudSelectObjectContentConfig new];
    config.express = @"Select * from";
    config.expressionType = QCloudExpressionTypeSQL;
    QCloudInputSerialization *inputS = [QCloudInputSerialization new];
    config.inputSerialization = inputS;
    inputS.compressionType = QCloudCOSXMLCompressionTypeGZIP;

    QCloudSerializationCSV *csv = [QCloudSerializationCSV new];
    inputS.SerializationCSV = csv;

    csv.inputFileHeaderInfo = QCloudInputFileHeaderInfoIgnore;
    csv.recordDelimiter = @"\\n";
    csv.quoteFields = nil;
    csv.fieldDelimiter = @",";
    csv.quoteCharacter = @"\"";
    csv.quoteEscapeCharacter = @"\"";
    csv.inputComments = @"#";
    csv.inputAllowQuotedRecordDelimiter = @"FALSE";

    QCloudOutputSerialization *outputS = [QCloudOutputSerialization new];
    config.outputSerialization = outputS;
    QCloudSerializationCSV *outCSV = [QCloudSerializationCSV new];
    outputS.SerializationCSV = outCSV;
    outCSV.inputFileHeaderInfo = nil;
    outCSV.quoteFields = QCloudOutputQuoteFieldsAlways;
    outCSV.recordDelimiter = @"\\n";
    outCSV.fieldDelimiter = @",";
    outCSV.quoteCharacter = @"\"";
    outCSV.quoteEscapeCharacter = @"\"";

    config.requestProgress = @"FALSE";

    request.selectObjectContentConfig = config;
    [request setFinishBlock:^(QCloudSelectObjectContentConfig *_Nonnull result, NSError *_Nonnull error) {
        NSLog(@"%@", result);
    }];
    [[QCloudCOSXMLService defaultCOSXML] SelectObjectContent:request];
}

@end
