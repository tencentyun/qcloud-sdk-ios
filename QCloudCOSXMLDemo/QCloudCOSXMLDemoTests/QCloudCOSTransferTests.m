//
//  QCloudCOSTransferTests.m
//  QCloudCOSXMLDemo
//
//  Created by Dong Zhao on 2017/5/23.
//  Copyright © 2017年 Tencent. All rights reserved.
//


#import <XCTest/XCTest.h>
#import <QCloudCOSXML/QCloudCOSXML.h>

#import "QCloudTestTempVariables.h"
#import "QCloudCOSXMLTestUtility.h"
#define HTTPServiceKey @"HTTPService"
#define TRANSFER_TEST_BUCKET_KEY @"tf"
#import "SecretStorage.h"
#import <QCloudCOSXMLService.h>
#import <QCloudGenerateSnapshotConfiguration.h>
#import "QCloudDeleteObjectTaggingRequest.h"

@interface QCloudCOSTransferTests : XCTestCase <QCloudSignatureProvider>
@property (nonatomic, strong) NSMutableArray *tempFilePathArray;
@property (nonatomic, strong) NSString *appID;
@property (nonatomic, strong) NSString *ownerID;
@property (nonatomic, strong) NSString *authorizedUIN;
@property (nonatomic, strong) NSString *ownerUIN;
@end
static QCloudBucket *gTransferTestBucket;
static QCloudBucket *gSourceTestBucket;
@implementation QCloudCOSTransferTests
//tfbtcbd17401092652216-1253960454 ap-beijing
//tfbtcbd174010922223-1253960454 ap-beijing
+ (void)setUp {
    gTransferTestBucket =  [[QCloudBucket alloc]init];//[[QCloudCOSXMLTestUtility sharedInstance] createTestBucketWithPrefix:TRANSFER_TEST_BUCKET_KEY];
    gTransferTestBucket.name = @"tfbtcbd174010922223-1253960454";
    gTransferTestBucket.location = @"ap-beijing";
    gSourceTestBucket =  [[QCloudBucket alloc]init];//[[QCloudCOSXMLTestUtility sharedInstance] createTestBucketWithPrefix:TRANSFER_TEST_BUCKET_KEY];
    gSourceTestBucket.location = @"ap-beijing";
    gSourceTestBucket.name = @"tfbtcbd17401092652216-1253960454";
}

+(void)tearDown{
//    [[QCloudCOSXMLTestUtility sharedInstance] deleteTestBucket:gTransferTestBucket];
//    [[QCloudCOSXMLTestUtility sharedInstance] deleteTestBucket:gSourceTestBucket];
}
- (void)setUp {
    [super setUp];
    self.appID = [SecretStorage sharedInstance].appID;
    self.ownerID = [SecretStorage sharedInstance].uin;
    self.authorizedUIN = [SecretStorage sharedInstance].uin;
    self.ownerUIN = [SecretStorage sharedInstance].uin;
    self.tempFilePathArray = [[NSMutableArray alloc] init];
    //    static dispatch_once_t onceToken;
    //    dispatch_once(&onceToken, ^{
    //        [QCloudTestTempVariables sharedInstance].testBucket = [[QCloudCOSXMLTestUtility sharedInstance] createTestBucket];
    //    });
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
    if ([QCloudCOSXMLService hasServiceForKey:HTTPServiceKey]) {
        return;
    }
    QCloudServiceConfiguration *configuration = [QCloudServiceConfiguration new];
    configuration.appID = self.appID;
    configuration.signatureProvider = self;
    QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.useHTTPS = YES;
    endpoint.regionName = [SecretStorage sharedInstance].region;
    configuration.endpoint = endpoint;

    [QCloudCOSTransferMangerService registerCOSTransferMangerWithConfiguration:configuration withKey:HTTPServiceKey];
    [QCloudCOSXMLService registerCOSXMLWithConfiguration:configuration withKey:HTTPServiceKey];
}

- (void)test001_SpecialCharacterFileNameBigFileUpoload {
    QCloudCOSXMLUploadObjectRequest *put = [QCloudCOSXMLUploadObjectRequest new];
    int randomNumber = arc4random() % 100;
    NSURL *url = [NSURL fileURLWithPath:[self tempFileWithSize:15 * 1024 * 1024 + randomNumber]];
    put.object = @"→↓←→↖↗↙↘! \"#$%&'()*+,-.0123456789:;<=>@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";
    put.bucket = gTransferTestBucket.name;
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

- (void)testMultiUpload {
    QCloudCOSXMLUploadObjectRequest *put = [QCloudCOSXMLUploadObjectRequest new];
    NSURL *url = [NSURL fileURLWithPath:[self tempFileWithSize:20 * 1024 * 1024]];
    __block NSString *object = [NSUUID UUID].UUIDString;
    put.body = url;
    put.object = object;
    put.bucket = gTransferTestBucket.name;
    [put setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"upload %lld totalSend %lld aim %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
    }];
    __block QCloudGetObjectRequest *request = [QCloudGetObjectRequest new];
    request.downloadingURL = [NSURL URLWithString:QCloudTempFilePathWithExtension(@"downding")];
    XCTestExpectation *exp = [self expectationWithDescription:@"testMultiUpload upload object expectation"];
    [put setFinishBlock:^(QCloudUploadObjectResult *result, NSError *error) {
        XCTAssertNotNil(result);
        XCTAssertNotNil([result location]);

        XCTAssertNotNil([result eTag]);
        request.bucket = gTransferTestBucket.name;
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

- (void)testCustomMultiUpload {
    QCloudCOSXMLUploadObjectRequest *put = [QCloudCOSXMLUploadObjectRequest new];
    NSURL *url = [NSURL fileURLWithPath:[self tempFileWithSize:5 * 1024 * 1024]];
    __block NSString *object = [NSUUID UUID].UUIDString;
    put.body = url;
    put.object = object;
    put.mutilThreshold = 10 *1024*1024;
    put.bucket = gTransferTestBucket.name;
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
        request.bucket = gTransferTestBucket.name;
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
    put.bucket = gTransferTestBucket.name;
    put.regionName = gTransferTestBucket.location;
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
    put.bucket = gTransferTestBucket.name;
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
    put.bucket = gTransferTestBucket.name;
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
    [[QCloudCOSTransferMangerService costransfermangerServiceForKey:HTTPServiceKey] UploadObject:put];
    [self waitForExpectationsWithTimeout:18000
                                 handler:^(NSError *_Nullable error) {
                                 }];
}

- (void) testLittleLimitAppendObject {
    QCloudAppendObjectRequest* put = [QCloudAppendObjectRequest new];
    put.object = [NSUUID UUID].UUIDString;
    put.bucket = gTransferTestBucket.name;
    put.body =  [NSURL fileURLWithPath:[self tempFileWithSize:1024*2]];
    
    XCTestExpectation* exp = [self expectationWithDescription:@"delete"];
    
    __block NSDictionary* result = nil;
    __block NSError* error;
    [put setFinishBlock:^(id outputObject, NSError *servererror) {
        result = outputObject;
        error = servererror;
        XCTAssertNotNil(outputObject);
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] AppendObject:put];
    [self waitForExpectationsWithTimeout:80 handler:nil];
    XCTAssertNil(error);
}

- (void) testBucketReferer {
    XCTestExpectation* exp = [self expectationWithDescription:@"put"];
    QCloudPutBucketRefererRequest * reqeust = [[QCloudPutBucketRefererRequest alloc]init];
    reqeust.bucket = gTransferTestBucket.name;
    reqeust.refererType = QCloudBucketRefererTypeWhiteList;
    reqeust.status = QCloudBucketRefererStatusEnabled;
    reqeust.configuration = QCloudBucketRefererConfigurationDeny;
    reqeust.domainList = @[@"*.com",@"*.qq.com"];
    
    __block NSError* errorTem;
    reqeust.finishBlock = ^(id outputObject, NSError *error) {
        QCloudGetBucketRefererRequest * reqeust = [[QCloudGetBucketRefererRequest alloc]init];
        reqeust.bucket = gTransferTestBucket.name;
        reqeust.finishBlock = ^(QCloudBucketRefererInfo * outputObject, NSError *error) {
            XCTAssertNotNil(outputObject);
            errorTem = error;
            [exp fulfill];
        };

        [[QCloudCOSXMLService defaultCOSXML] GetBucketReferer:reqeust];
    };

    [[QCloudCOSXMLService defaultCOSXML] PutBucketReferer:reqeust];
    [self waitForExpectationsWithTimeout:80 handler:nil];
    XCTAssertNil(errorTem);
}

// SSE-C简单上传
- (void)testSimplePut_GetWithSSE {
    QCloudPutObjectRequest *put = [QCloudPutObjectRequest new];
    put.object = @"SSE-Simple-Upload";
    put.bucket = gTransferTestBucket.name;
    put.body = [@"This is test content" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *customKey = @"123456qwertyuioplkjhgfdsazxcvbnm";
        [put setCOSServerSideEncyptionWithCustomerKey:customKey];
    XCTestExpectation *exp = [self expectationWithDescription:@"delete"];
    __block NSError *resultError;
    __block NSDictionary *dic;
    [put setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error, @"put Object fail!");
        if (outputObject) {
            dic = (NSDictionary *)outputObject;
        }
        [exp fulfill];
    }];
    [[QCloudCOSXMLService cosxmlServiceForKey:HTTPServiceKey] PutObject:put];
    [self waitForExpectationsWithTimeout:80 handler:nil];

    __block XCTestExpectation *getObjectExpectation = [self expectationWithDescription:@"Get Object Expectation"];
    QCloudCOSXMLDownloadObjectRequest *getObjectRequest = [[QCloudCOSXMLDownloadObjectRequest alloc] init];
        [getObjectRequest setCOSServerSideEncyptionWithCustomerKey:customKey];
    getObjectRequest.bucket = gTransferTestBucket.name;
    getObjectRequest.object = put.object;
    
    [getObjectRequest setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error, @"Get Object Fail!");
        [getObjectExpectation fulfill];
    }];

    [[QCloudCOSTransferMangerService costransfermangerServiceForKey:HTTPServiceKey] DownloadObject:getObjectRequest];
    [self waitForExpectationsWithTimeout:80 handler:nil];
}


//
- (void)testGetObject {
    QCloudPutObjectRequest *put = [QCloudPutObjectRequest new];

    put.object = @"SSE-Simple-Upload";
    put.bucket = gTransferTestBucket.name;
    put.body = [NSURL fileURLWithPath:[self tempFileWithSize:100*1024*1024]];
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
    [[QCloudCOSXMLService cosxmlServiceForKey:HTTPServiceKey] PutObject:put];
    [self waitForExpectationsWithTimeout:1000 handler:nil];

    __block XCTestExpectation *getObjectExpectation = [self expectationWithDescription:@"Get Object Expectation"];
    __block QCloudCOSXMLDownloadObjectRequest *getObjectRequest = [[QCloudCOSXMLDownloadObjectRequest alloc] init];
    getObjectRequest.resumableDownload = YES;
    getObjectRequest.bucket = gTransferTestBucket.name;
    getObjectRequest.downloadingURL = [NSURL URLWithString:QCloudTempFilePathWithExtension(@"downding")];
    getObjectRequest.object = put.object;
    [getObjectRequest setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error, @"Get Object Fail!");
        XCTAssertEqual(QCloudFileSize(getObjectRequest.downloadingURL.relativePath),[ outputObject[@"Content-Length"] integerValue]);
        [getObjectExpectation fulfill];
    }];

    [[QCloudCOSTransferMangerService costransfermangerServiceForKey:HTTPServiceKey] DownloadObject:getObjectRequest];
    [self waitForExpectationsWithTimeout:1000 handler:nil];
}
// SSE-C uploadObject 简单上传
- (void)testSimplePut_GetObjectUseUploadObjectWithSSE {
    __block XCTestExpectation *Expectation = [self expectationWithDescription:@"Put Object Expectation"];
    __block QCloudCOSXMLUploadObjectRequest *uploadObjectRequest = [[QCloudCOSXMLUploadObjectRequest alloc] init];
    uploadObjectRequest.bucket = gTransferTestBucket.name;
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
    [[QCloudCOSTransferMangerService costransfermangerServiceForKey:HTTPServiceKey] UploadObject:uploadObjectRequest];
    [self waitForExpectationsWithTimeout:10 handler:nil];

    __block XCTestExpectation *GetObjectExpectation = [self expectationWithDescription:@"Put Object Expectation"];
    QCloudCOSXMLDownloadObjectRequest *downloadRequest = [[QCloudCOSXMLDownloadObjectRequest alloc] init];
    downloadRequest.bucket = gTransferTestBucket.name;
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
    [[QCloudCOSTransferMangerService costransfermangerServiceForKey:HTTPServiceKey] DownloadObject:downloadRequest];
    [self waitForExpectationsWithTimeout:10 handler:nil];
}

// SSE-C uploadObject 简单上传
- (void)testDownloadObjectWithSSE {
    __block XCTestExpectation *Expectation = [self expectationWithDescription:@"Put Object Expectation"];
    __block QCloudCOSXMLUploadObjectRequest *uploadObjectRequest = [[QCloudCOSXMLUploadObjectRequest alloc] init];
    uploadObjectRequest.bucket = gTransferTestBucket.name;
    uploadObjectRequest.object = @"SSE-Simple-Upload";
    uploadObjectRequest.body = [@"This is test content" dataUsingEncoding:NSUTF8StringEncoding];

    NSString *customKey = @"123456qwertyuioplkjhgfdsazxcvbnm";
    [uploadObjectRequest setCOSServerSideEncyptionWithCustomerKey:customKey];
    [uploadObjectRequest setFinishBlock:^(QCloudUploadObjectResult *result, NSError *error) {
        XCTAssertNil(error, @"put Object fail!");
        [Expectation fulfill];
    }];

    [[QCloudCOSTransferMangerService costransfermangerServiceForKey:HTTPServiceKey] UploadObject:uploadObjectRequest];
    [self waitForExpectationsWithTimeout:10 handler:nil];

    __block XCTestExpectation *downloadObjectExp = [self expectationWithDescription:@"download Object Expectation"];
    QCloudCOSXMLDownloadObjectRequest *downloadRequest = [[QCloudCOSXMLDownloadObjectRequest alloc] init];
    downloadRequest.bucket = gTransferTestBucket.name;
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
    [[QCloudCOSTransferMangerService costransfermangerServiceForKey:HTTPServiceKey] DownloadObject:downloadRequest];
    [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testDownloadObjectCancel {

    __block XCTestExpectation *downloadObjectExp = [self expectationWithDescription:@"download Object Expectation"];
    QCloudCOSXMLDownloadObjectRequest *downloadRequest = [[QCloudCOSXMLDownloadObjectRequest alloc] init];
    downloadRequest.bucket = @"cos-sdk-citest-1253960454";
    downloadRequest.regionName = @"ap-beijing";
    downloadRequest.resumableDownload = YES;
    //设置下载的路径 URL，如果设置了，文件将会被下载到指定路径中
    downloadRequest.object = @"002拆条版_i8b0719f990bf11ed9c7b525400c90418.mp4";
    downloadRequest.downloadingURL = [NSURL fileURLWithPath:[QCloudTempDir() stringByAppendingPathComponent:downloadRequest.object]];
    [downloadRequest setFinishBlock:^(id outputObject, NSError *error) {
        NSLog(@"123");
    }];
    __weak QCloudCOSXMLDownloadObjectRequest * weakRequest = downloadRequest;
    [downloadRequest setDownProcessBlock:^(int64_t bytesDownload, int64_t totalBytesDownload, int64_t totalBytesExpectedToDownload) {
        
        if(totalBytesDownload > 100){
            [weakRequest cancel];
            QCloudCOSXMLDownloadObjectRequest *resumeRequest = [[QCloudCOSXMLDownloadObjectRequest alloc] init];
            resumeRequest.bucket = @"cos-sdk-citest-1253960454";
            resumeRequest.regionName = @"ap-beijing";
            resumeRequest.resumableDownload = YES;
            //设置下载的路径 URL，如果设置了，文件将会被下载到指定路径中
            resumeRequest.object = @"002拆条版_i8b0719f990bf11ed9c7b525400c90418.mp4";
            resumeRequest.downloadingURL = [NSURL fileURLWithPath:[QCloudTempDir() stringByAppendingPathComponent:resumeRequest.object]];
            [resumeRequest setFinishBlock:^(id outputObject, NSError *error) {
                XCTAssertNil(error);
                XCTAssertNotNil(outputObject);
                [downloadObjectExp fulfill];
            }];
            [[QCloudCOSTransferMangerService costransfermangerServiceForKey:HTTPServiceKey] DownloadObject:resumeRequest];
            
        }
    }];
    [[QCloudCOSTransferMangerService costransfermangerServiceForKey:HTTPServiceKey] DownloadObject:downloadRequest];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

- (void)testHeadObjectWithSSE {
    __block XCTestExpectation *Expectation = [self expectationWithDescription:@"Put Object Expectation"];
    __block QCloudCOSXMLUploadObjectRequest *uploadObjectRequest = [[QCloudCOSXMLUploadObjectRequest alloc] init];

    uploadObjectRequest.bucket = gTransferTestBucket.name;
    uploadObjectRequest.enableVerification = NO;
    uploadObjectRequest.object = @"SSE-part-Upload";
    uploadObjectRequest.body = [NSURL fileURLWithPath:[self tempFileWithSize:2 * 1024 * 1024]];
//    NSString *customKey = @"123456qwertyuioplkjhgfdsazxcvbnm";
//
//    [uploadObjectRequest setCOSServerSideEncyptionWithCustomerKey:customKey];

    [uploadObjectRequest setFinishBlock:^(QCloudUploadObjectResult *result, NSError *error) {
        QCloudLogInfo(@"__originHTTPURLResponse__:  %@", result.__originHTTPURLResponse__.allHeaderFields);
        XCTAssertNil(error, @"put Object fail!");
        [Expectation fulfill];
    }];
    [[QCloudCOSTransferMangerService costransfermangerServiceForKey:HTTPServiceKey] UploadObject:uploadObjectRequest];
    [self waitForExpectationsWithTimeout:80 handler:nil];

    __block XCTestExpectation *headObjectExpectation = [self expectationWithDescription:@"Put Object Expectation"];
    QCloudHeadObjectRequest *headObjectRequest = [[QCloudHeadObjectRequest alloc] init];
//    [headObjectRequest setCOSServerSideEncyptionWithCustomerKey:customKey];
    [headObjectRequest setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error);
        [headObjectExpectation fulfill];
    }];
    headObjectRequest.bucket = gTransferTestBucket.name;
    headObjectRequest.object = @"SSE-part-Upload";
    [[QCloudCOSXMLService cosxmlServiceForKey:HTTPServiceKey] HeadObject:headObjectRequest];
    [self waitForExpectationsWithTimeout:80 handler:nil];
}
////SSE-C分块上传
- (void)testMultiplePut_GetObjectWithSSE {
    __block XCTestExpectation *expectation = [self expectationWithDescription:@"Put Object Expectation"];
    __block QCloudCOSXMLUploadObjectRequest *uploadObjectRequest = [[QCloudCOSXMLUploadObjectRequest alloc] init];
    uploadObjectRequest.enableVerification = NO;
    uploadObjectRequest.bucket = gTransferTestBucket.name;
    uploadObjectRequest.object = @"SSE-part-Upload";
    uploadObjectRequest.body = [NSURL fileURLWithPath:[self tempFileWithSize:2 * 1024 * 1024]];
    NSString *customKey = @"123456qwertyuioplkjhgfdsazxcvbnm";

    [uploadObjectRequest setCOSServerSideEncyptionWithCustomerKey:customKey];

    [uploadObjectRequest setFinishBlock:^(QCloudUploadObjectResult *result, NSError *error) {
        QCloudLogInfo(@"__originHTTPURLResponse__:  %@", result.__originHTTPURLResponse__.allHeaderFields);
        XCTAssertNil(error, @"put Object fail!");
        if(error){
            [expectation fulfill];
            return;
        }
        QCloudGetObjectRequest *getObjectRequest = [[QCloudGetObjectRequest alloc] init];
        getObjectRequest.bucket = gTransferTestBucket.name;

        getObjectRequest.object = @"SSE-part-Upload";
        [getObjectRequest setCOSServerSideEncyptionWithCustomerKey:customKey];
        [getObjectRequest setFinishBlock:^(id outputObject, NSError *error) {
            XCTAssertNil(error, @"Get Object Fail!");
            [expectation fulfill];
        }];
        [getObjectRequest setDownProcessBlock:^(int64_t bytesDownload, int64_t totalBytesDownload, int64_t totalBytesExpectedToDownload) {
            QCloudLogInfo(@"bytesDownload: %lld  totalBytesDownload :%lld  totalBytesExpectedToDownload:%lld ", bytesDownload, totalBytesDownload,
                          totalBytesExpectedToDownload);
        }];
        [[QCloudCOSXMLService cosxmlServiceForKey:HTTPServiceKey] GetObject:getObjectRequest];
    }];
    [[QCloudCOSTransferMangerService costransfermangerServiceForKey:HTTPServiceKey] UploadObject:uploadObjectRequest];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}
- (void)testCopySmallFileWithSSE {
    NSString *tempFileName = @"30MBTempFile";

    XCTestExpectation *uploadChineseNameSmallFileExpectation = [self expectationWithDescription:@"upload temp object"];

    QCloudCOSXMLUploadObjectRequest *uploadObjectRequest1 = [[QCloudCOSXMLUploadObjectRequest alloc] init];

    NSString *customKey = @"123456qwertyuioplkjhgfdsazxcvbnm";

    [uploadObjectRequest1 setCOSServerSideEncyptionWithCustomerKey:customKey];
    uploadObjectRequest1.enableVerification = NO;
    uploadObjectRequest1.bucket = gSourceTestBucket.name;
    uploadObjectRequest1.object = @"copy小文件 SSEC";
    uploadObjectRequest1.body = [NSURL fileURLWithPath:[self tempFileWithSize:1024]];
    [uploadObjectRequest1 setFinishBlock:^(QCloudUploadObjectResult *result, NSError *error) {
        QCloudLogInfo(@"tttt  %@", result.__originHTTPURLResponse__.allHeaderFields);
        XCTAssertNil(error, @"error occures on uploading");
        [uploadChineseNameSmallFileExpectation fulfill];
    }];
    [[QCloudCOSTransferMangerService costransfermangerServiceForKey:HTTPServiceKey] UploadObject:uploadObjectRequest1];
    [self waitForExpectationsWithTimeout:80 handler:nil];

    QCloudCOSXMLCopyObjectRequest *request = [[QCloudCOSXMLCopyObjectRequest alloc] init];
    [request setCOSServerSideEncyptionWithCustomerKey:customKey];
    request.bucket = gTransferTestBucket.name;
    request.object = [NSString stringWithFormat:@"copy-%@", tempFileName];
    request.sourceBucket = gSourceTestBucket.name;
    request.sourceObject = uploadObjectRequest1.object;
    request.sourceAPPID = [QCloudCOSXMLService defaultCOSXML].configuration.appID;
    request.sourceRegion = gSourceTestBucket.location;
    XCTestExpectation *expectation = [self expectationWithDescription:@"Put Object Copy"];
    [request setFinishBlock:^(QCloudCopyObjectResult *result, NSError *error) {
        NSLog(@"resulttest %@", result.__originHTTPURLResponse__.allHeaderFields);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudCOSTransferMangerService costransfermangerServiceForKey:HTTPServiceKey] CopyObject:request];
    [self waitForExpectationsWithTimeout:10000 handler:nil];
}

- (void)testCopyBigFileWithSSE {
    NSString *tempFileName = @"30MBTempFile";

    XCTestExpectation *uploadChineseNameBigFileExpectation = [self expectationWithDescription:@"upload temp object"];
    NSString *customKey = @"123456qwertyuioplkjhgfdsazxcvbnm";

    QCloudCOSXMLUploadObjectRequest *uploadObjectRequest2 = [[QCloudCOSXMLUploadObjectRequest alloc] init];
    uploadObjectRequest2.enableVerification = NO;
    [uploadObjectRequest2 setCOSServerSideEncyptionWithCustomerKey:customKey];
    uploadObjectRequest2.bucket = gSourceTestBucket.name;
    uploadObjectRequest2.object = @"中文名Copy大文件";
    uploadObjectRequest2.body = [NSURL fileURLWithPath:[self tempFileWithSize:30 * 1024 * 1024]];
    [uploadObjectRequest2 setFinishBlock:^(QCloudUploadObjectResult *result, NSError *error) {
        NSLog(@"allHeaderFields:  %@", result.__originHTTPURLResponse__.allHeaderFields);
        XCTAssertNil(error, @"error occures on uploading");
        [uploadChineseNameBigFileExpectation fulfill];
    }];
    [[QCloudCOSTransferMangerService costransfermangerServiceForKey:HTTPServiceKey] UploadObject:uploadObjectRequest2];
    [self waitForExpectationsWithTimeout:600 handler:nil];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Put Object Copy"];

    QCloudCOSXMLCopyObjectRequest *request = [[QCloudCOSXMLCopyObjectRequest alloc] init];
    [request setCOSServerSideEncyptionWithCustomerKey:customKey];
    request.bucket = gTransferTestBucket.name;
    request.object = [NSString stringWithFormat:@"copy-%@", tempFileName];
    request.sourceBucket = gSourceTestBucket.name;
    request.sourceObject = uploadObjectRequest2.object;
    request.sourceAPPID = [QCloudCOSXMLService defaultCOSXML].configuration.appID;
    request.sourceRegion = gSourceTestBucket.location;
    NSLog(@"customHeaders %@", request.customHeaders);
    [request setFinishBlock:^(QCloudCopyObjectResult *result, NSError *error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudCOSTransferMangerService costransfermangerServiceForKey:HTTPServiceKey] CopyObject:request];
    [self waitForExpectationsWithTimeout:10000 handler:nil];
}

////SSE-C简单上传
- (void)testSimplePut_GetWithSSEKMS {
//
    QCloudPutObjectRequest* put = [QCloudPutObjectRequest new];
    put.object = @"SSEKMS-Simple-Upload";
    put.bucket =gTransferTestBucket.name;
    put.body =  [@"This is test content" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *arrJsonStr = @"{\"key\":\"value\"}";
    [put setCOSServerSideEncyptionWithKMSCustomKey:nil jsonStr:arrJsonStr];
    XCTestExpectation* exp = [self expectationWithDescription:@"delete"];
    __block NSError* resultError;
    __block  NSDictionary *dic;
    [put setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error,@"put Object fail!");
        if (outputObject) {
            dic = (NSDictionary *)outputObject;
        }
        [exp fulfill];
    }];
    [[QCloudCOSXMLService cosxmlServiceForKey:HTTPServiceKey] PutObject:put];
    [self waitForExpectationsWithTimeout:80 handler:nil];

    __block XCTestExpectation* getObjectExpectation = [self expectationWithDescription:@"Get Object Expectation"];
    QCloudGetObjectRequest* getObjectRequest = [[QCloudGetObjectRequest alloc] init];
    getObjectRequest.bucket = gTransferTestBucket.name;
    getObjectRequest.object = @"SSEKMS-Simple-Upload";
    [getObjectRequest setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error,@"Get Object Fail!");
        [getObjectExpectation fulfill];
    }];
    [[QCloudCOSXMLService cosxmlServiceForKey:HTTPServiceKey] GetObject:getObjectRequest];
    [self waitForExpectationsWithTimeout:80 handler:nil];
}
- (void)testSimplePut_Get_Head_Object_copy_WithSSEKMS {
    __block XCTestExpectation* putObejctExpectation = [self expectationWithDescription:@"Put Object Expectation"];
    QCloudCOSXMLUploadObjectRequest* uploadObjectRequest = [[QCloudCOSXMLUploadObjectRequest alloc] init];

    uploadObjectRequest.bucket = gSourceTestBucket.name;
    uploadObjectRequest.object = @"SSEKMS-Simple-Upload";
    uploadObjectRequest.body = [NSURL fileURLWithPath:[self tempFileWithSize:1024*1024]];
    NSString *arrJsonStr = @"{\"key\":\"value\"}";
    [uploadObjectRequest setCOSServerSideEncyptionWithKMSCustomKey:nil jsonStr:arrJsonStr];
    [uploadObjectRequest setFinishBlock:^(QCloudUploadObjectResult *result, NSError *error) {
        NSLog(@"QCloudUploadObjectResult result  %@ ",result.__originHTTPURLResponse__.allHeaderFields);
        XCTAssertNil(error);
        [putObejctExpectation fulfill];
    }];
    [[QCloudCOSTransferMangerService costransfermangerServiceForKey:HTTPServiceKey] UploadObject:uploadObjectRequest];
    [self waitForExpectationsWithTimeout:100 handler:nil];

    __block XCTestExpectation* getObjecExpectation = [self expectationWithDescription:@"get Object Expectation"];
    QCloudGetObjectRequest* getObjectRequest = [[QCloudGetObjectRequest alloc] init];
    getObjectRequest.enableMD5Verification = NO;
    getObjectRequest.bucket = uploadObjectRequest.bucket;
    getObjectRequest.object = uploadObjectRequest.object;
    [getObjectRequest setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error,@"Get Object Fail!");
        [getObjecExpectation fulfill];
    }];
    [[QCloudCOSXMLService cosxmlServiceForKey:HTTPServiceKey] GetObject:getObjectRequest];
    [self waitForExpectationsWithTimeout:80 handler:nil];

    __block XCTestExpectation* headObjectExpectation = [self expectationWithDescription:@"Put Object Expectation"];
    QCloudHeadObjectRequest* headObjectRequest = [[QCloudHeadObjectRequest alloc] init];
    [headObjectRequest setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error);
        [headObjectExpectation fulfill];
    }];
    headObjectRequest.bucket = uploadObjectRequest.bucket;
    headObjectRequest.object = uploadObjectRequest.object;
    [[QCloudCOSXMLService cosxmlServiceForKey:HTTPServiceKey] HeadObject:headObjectRequest];
    [self waitForExpectationsWithTimeout:80 handler:nil];


    QCloudCOSXMLCopyObjectRequest* request = [[QCloudCOSXMLCopyObjectRequest alloc] init];
    [request setCOSServerSideEncyptionWithCustomerKey:nil];
    request.bucket = gTransferTestBucket.name;
    request.object = uploadObjectRequest.object;
    request.sourceBucket = gSourceTestBucket.name;
    request.sourceObject = uploadObjectRequest.object;
    request.sourceAPPID = [QCloudCOSXMLService defaultCOSXML].configuration.appID;
    request.sourceRegion= [QCloudCOSXMLService defaultCOSXML].configuration.endpoint.regionName;
    XCTestExpectation* expectation = [self expectationWithDescription:@"Put Object Copy"];
    [request setFinishBlock:^(QCloudCopyObjectResult* result, NSError* error) {
        NSLog(@"resulttest %@",result.__originHTTPURLResponse__.allHeaderFields);
        [expectation fulfill];
    }];
    [[QCloudCOSTransferMangerService costransfermangerServiceForKey:HTTPServiceKey] CopyObject:request];
    [self waitForExpectationsWithTimeout:10000 handler:nil];


}

- (void)testMultiplePut_Get_head_Object_copy_WithSSEKMS {
    __block XCTestExpectation* putObejctExpectation = [self expectationWithDescription:@"Put Object Expectation"];
    QCloudCOSXMLUploadObjectRequest* uploadObjectRequest = [[QCloudCOSXMLUploadObjectRequest alloc] init];
    uploadObjectRequest.enableVerification = NO;
    uploadObjectRequest.bucket = gSourceTestBucket.name;
    uploadObjectRequest.object = @"SSE-mutiupload-Upload";
    uploadObjectRequest.body = [NSURL fileURLWithPath:[self tempFileWithSize:20*1024*1024]];
    NSString *arrJsonStr = @"{\"key\":\"value\"}";
    [uploadObjectRequest setCOSServerSideEncyptionWithKMSCustomKey:nil jsonStr:arrJsonStr];
    [uploadObjectRequest setFinishBlock:^(QCloudUploadObjectResult *result, NSError *error) {
        NSLog(@"tMultiple UploadObjectResult result  %@ ",result.__originHTTPURLResponse__.allHeaderFields);
         XCTAssertNil(error);
        [putObejctExpectation fulfill];
    }];
    [[QCloudCOSTransferMangerService costransfermangerServiceForKey:HTTPServiceKey] UploadObject:uploadObjectRequest];
    [self waitForExpectationsWithTimeout:1000 handler:nil];

    __block XCTestExpectation* getObjecExpectation = [self expectationWithDescription:@"get Object Expectation"];
    QCloudGetObjectRequest* getObjectRequest = [[QCloudGetObjectRequest alloc] init];
    getObjectRequest.bucket = uploadObjectRequest.bucket;
    getObjectRequest.object = uploadObjectRequest.object;
    [getObjectRequest setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error,@"Get Object Fail!");
        [getObjecExpectation fulfill];
    }];
    [[QCloudCOSXMLService cosxmlServiceForKey:HTTPServiceKey] GetObject:getObjectRequest];
    [self waitForExpectationsWithTimeout:1000 handler:nil];

    __block XCTestExpectation* headObjectExpectation = [self expectationWithDescription:@"Put Object Expectation"];
    QCloudHeadObjectRequest* headObjectRequest = [[QCloudHeadObjectRequest alloc] init];
    [headObjectRequest setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error);
        [headObjectExpectation fulfill];
    }];
    headObjectRequest.bucket = uploadObjectRequest.bucket;
    headObjectRequest.object = uploadObjectRequest.object;
    [[QCloudCOSXMLService cosxmlServiceForKey:HTTPServiceKey] HeadObject:headObjectRequest];
    [self waitForExpectationsWithTimeout:1000 handler:nil];

    QCloudCOSXMLCopyObjectRequest* request = [[QCloudCOSXMLCopyObjectRequest alloc] init];
    request.bucket = gTransferTestBucket.name;
    request.object = uploadObjectRequest.object;
    request.sourceBucket = gSourceTestBucket.name;
    request.sourceObject = uploadObjectRequest.object;
    request.sourceAPPID = [QCloudCOSXMLService defaultCOSXML].configuration.appID;
    request.sourceRegion= [QCloudCOSXMLService defaultCOSXML].configuration.endpoint.regionName;
    XCTestExpectation* expectation = [self expectationWithDescription:@"Put Object Copy"];
    [request setFinishBlock:^(QCloudCopyObjectResult* result, NSError* error) {
        NSLog(@"resulttest %@",result.__originHTTPURLResponse__.allHeaderFields);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudCOSTransferMangerService costransfermangerServiceForKey:HTTPServiceKey] CopyObject:request];
    [self waitForExpectationsWithTimeout:10000 handler:nil];
}

- (void)testChineseFileNameBigfileUpload {
    QCloudCOSXMLUploadObjectRequest *put = [QCloudCOSXMLUploadObjectRequest new];
    int randomNumber = arc4random() % 100;
    NSURL *url = [NSURL fileURLWithPath:[self tempFileWithSize:15 * 1024 * 1024 + randomNumber]];
    put.object = @"中文名大文件";
    put.bucket = gTransferTestBucket.name;
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
    put.bucket = gTransferTestBucket.name;
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

- (void)testSpecialCharacterFileSmallFileUpload {
    QCloudCOSXMLUploadObjectRequest *put = [QCloudCOSXMLUploadObjectRequest new];
    int randomNumber = arc4random() % 100;
    NSURL *url = [NSURL fileURLWithPath:[self tempFileWithSize:100 + randomNumber]];
    put.object = @"→↓←→↖↗↙↘! \"#$%&'()*+,-.0123456789:;<=>@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";
    put.bucket = gTransferTestBucket.name;
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
    put.bucket = gTransferTestBucket.name;
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
    put.bucket = gTransferTestBucket.name;
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
    put.bucket = gTransferTestBucket.name;
    put.body = url;
    [put setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"upload %lld totalSend %lld aim %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
    }];
    XCTestExpectation *exp = [self expectationWithDescription:@"delete33"];
    __block id result;
    [put setFinishBlock:^(id outputObject, NSError *error) {
        result = outputObject;
        [exp fulfill];
        
        QCloudPutObjectTaggingRequest *putReq = [QCloudPutObjectTaggingRequest new];

        NSError * localError;
        [putReq buildRequestData:&localError];
        XCTAssertNotNil(localError);
        
        // 存储桶名称，格式为 BucketName-APPID
        putReq.bucket = gTransferTestBucket.name;
        
        [putReq buildRequestData:&localError];
        XCTAssertNotNil(localError);
        putReq.object = put.object;
        
        [putReq buildRequestData:&localError];
        XCTAssertNotNil(localError);
        // 标签集合
        QCloudTagging *taggings = [QCloudTagging new];

        QCloudTag *tag1 = [QCloudTag new];

        tag1.key = @"age";
        tag1.value = @"18";
        QCloudTag *tag2 = [QCloudTag new];
        tag2.key = @"name";
        tag2.value = @"garen";

        QCloudTagSet *tagSet = [QCloudTagSet new];
        tagSet.tag = @[tag1,tag2];
        taggings.tagSet = tagSet;

        // 标签集合
        putReq.taggings = taggings;

        [putReq setFinishBlock:^(id outputObject, NSError *error) {
            // outputObject 包含所有的响应 http 头部
            NSDictionary* info = (NSDictionary *) outputObject;
            
            QCloudGetObjectTaggingRequest *getReq = [QCloudGetObjectTaggingRequest new];
            NSError * localError;
            [getReq buildRequestData:&localError];
            XCTAssertNotNil(localError);
            
            // 存储桶名称，格式为 BucketName-APPID
            getReq.bucket = gTransferTestBucket.name;
            
            [getReq buildRequestData:&localError];
            XCTAssertNotNil(localError);
            getReq.object = put.object;
            
            [getReq setFinishBlock:^(QCloudTagging * result, NSError * error) {

                // tag的集合
                QCloudTagSet * tagSet = result.tagSet;
                for (QCloudTag * tag in tagSet.tag) {
                    if ([tag.key isEqualToString:@"age"]) {
                        XCTAssertTrue(tag.value.intValue == 18);
                    }
                    
                    if ([tag.key isEqualToString:@"name"]) {
                        XCTAssertTrue([tag.value isEqualToString:@"garen"]);
                    }
                }
                
                QCloudDeleteObjectTaggingRequest * deleteRequest = [[QCloudDeleteObjectTaggingRequest alloc]init];
                
                deleteRequest.object = put.object;
                
                deleteRequest.bucket = put.bucket;
                
                [deleteRequest setFinishBlock:^(id  _Nullable result, NSError * _Nullable error) {

                    dispatch_async(dispatch_get_main_queue(), ^{
                        XCTAssertNil(error);
                    });
                }];
                
                [[QCloudCOSXMLService defaultCOSXML] DeleteObjectTagging:deleteRequest];
                
            }];
            [[QCloudCOSXMLService defaultCOSXML] GetObjectTagging:getReq];
            
            
        }];
        [[QCloudCOSXMLService defaultCOSXML] PuObjectTagging:putReq];
        
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
    put.bucket = gTransferTestBucket.name;
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
    put.bucket = gTransferTestBucket.name;
    put.regionName = gTransferTestBucket.location;
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
    put.bucket = gTransferTestBucket.name;
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
                if(error.code == 409){
                    [resumeExp fulfill];
                    return;
                }
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
}

- (void)testSimpleUploadObjectWithServerSideEncryption {
    QCloudCOSXMLUploadObjectRequest *put = [QCloudCOSXMLUploadObjectRequest new];
    NSURL *url = [NSURL fileURLWithPath:[self tempFileWithSize:1 * 1024]];
    __block NSString *object = @"testSimpleUploadObjectWithSSE";
    put.object = object;
    put.bucket = gTransferTestBucket.name;
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
        getObjectRequest.bucket = gTransferTestBucket.name;
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
//    put.bucket = gTransferTestBucket.name;
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
//        getObjectRequest.bucket = gTransferTestBucket.name;
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

- (void)testPutObjectCopy {
    NSString *copyObjectSourceName = [NSUUID UUID].UUIDString;
    QCloudPutObjectRequest *put = [QCloudPutObjectRequest new];
    put.object = copyObjectSourceName;
    put.versionID = @"versionID111111";
    put.bucket = gTransferTestBucket.name;
    put.body = [@"4324ewr325" dataUsingEncoding:NSUTF8StringEncoding];
    __block XCTestExpectation *exception = [self expectationWithDescription:@"Put Object Copy Exception"];
    __block NSError *putObjectCopyError;
    __block NSError *resultError;
    __block QCloudCopyObjectResult *copyObjectResult;
    [put setFinishBlock:^(id outputObject, NSError *error) {
        NSURL *serviceURL = [[QCloudCOSXMLService defaultCOSXML].configuration.endpoint serverURLWithBucket:gTransferTestBucket.name
                                                                                                      appID:self.appID
                                                                                                 regionName:put.regionName];
        NSMutableString *objectCopySource = [serviceURL.absoluteString mutableCopy];
        [objectCopySource appendFormat:@"/%@", copyObjectSourceName];
        objectCopySource = [[objectCopySource substringFromIndex:7] mutableCopy];
        QCloudPutObjectCopyRequest *request = [[QCloudPutObjectCopyRequest alloc] init];
        request.bucket = gTransferTestBucket.name;
        request.object = [NSUUID UUID].UUIDString;
        request.objectCopySource = objectCopySource;
        request.versionID = @"versionID111111";
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
    uploadObjectRequest.bucket = gSourceTestBucket.name;
    uploadObjectRequest.object = tempFileName;
    uploadObjectRequest.body = [NSURL fileURLWithPath:[self tempFileWithSize:30 * 1024 * 1024]];
    [uploadObjectRequest setFinishBlock:^(QCloudUploadObjectResult *result, NSError *error) {
        XCTAssertNil(error, @"error occures on uploading");
        [uploadExpectation fulfill];
    }];
    [[QCloudCOSTransferMangerService defaultCOSTransferManager] UploadObject:uploadObjectRequest];
    [self waitForExpectationsWithTimeout:600 handler:nil];
    QCloudCOSXMLCopyObjectRequest *request = [[QCloudCOSXMLCopyObjectRequest alloc] init];

    request.bucket = gTransferTestBucket.name;
    request.object = @"copy-result-test";
    request.sourceBucket = gSourceTestBucket.name;
    request.sourceObject = tempFileName;
    request.sourceAPPID = [QCloudCOSXMLService defaultCOSXML].configuration.appID;
    request.sourceRegion = gSourceTestBucket.location;

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


- (void)testCopyWithChineseNameAndWhiteSpace {
    NSString *tempFileName = @"30MBTempFile";
    XCTestExpectation *uploadWhiteSpaceExpectation = [self expectationWithDescription:@"upload temp object"];
    QCloudCOSXMLUploadObjectRequest *uploadObjectRequest3 = [[QCloudCOSXMLUploadObjectRequest alloc] init];
    uploadObjectRequest3.bucket = gSourceTestBucket.name;
    uploadObjectRequest3.object = tempFileName;
    uploadObjectRequest3.regionName = gSourceTestBucket.location;
    uploadObjectRequest3.body = [NSURL fileURLWithPath:[self tempFileWithSize:30 * 1024 * 1024]];
    [uploadObjectRequest3 setFinishBlock:^(QCloudUploadObjectResult *result, NSError *error) {
        XCTAssertNil(error, @"error occures on uploading");
        if(!error){
            QCloudCOSXMLCopyObjectRequest *request = [[QCloudCOSXMLCopyObjectRequest alloc] init];
                request.bucket = gTransferTestBucket.name;
                request.object = [NSString stringWithFormat:@"copy-%@", tempFileName];
                request.sourceBucket = gSourceTestBucket.name;
                request.sourceObject = tempFileName;
                request.sourceAPPID = [QCloudCOSXMLService defaultCOSXML].configuration.appID;
                request.sourceRegion = gSourceTestBucket.location;
                [request setFinishBlock:^(QCloudCopyObjectResult *result, NSError *error) {
                    XCTAssertNil(error);
                    [uploadWhiteSpaceExpectation fulfill];
                }];
                [[QCloudCOSTransferMangerService defaultCOSTransferManager] CopyObject:request];
            
        }else{
            [uploadWhiteSpaceExpectation fulfill];
        }
       
    }];
    [[QCloudCOSTransferMangerService defaultCOSTransferManager] UploadObject:uploadObjectRequest3];
    [self waitForExpectationsWithTimeout:1000 handler:nil];
}

- (void)testSelectObject {
    XCTestExpectation *uploadWhiteSpaceExpectation = [self expectationWithDescription:@"testSelectObject"];
    QCloudSelectObjectContentRequest *request = [QCloudSelectObjectContentRequest new];
    request.bucket = @"1504078136-1253653367";
    request.regionName = @"ap-beijing";
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
        [uploadWhiteSpaceExpectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] SelectObjectContent:request];
    [self waitForExpectationsWithTimeout:1000 handler:nil];
}

-(void)testQCloudPostObjectRestoreRequest{
    XCTestExpectation* expectation = [self expectationWithDescription:@"testQCloudPostObjectRestoreRequest"];
    QCloudPostObjectRestoreRequest *req = [QCloudPostObjectRestoreRequest new];
    
    NSError * localError;
    
    [req buildRequestData:&localError];
    XCTAssertNotNil(localError);
    req.bucket = gTransferTestBucket.name;
    
    [req buildRequestData:&localError];
    XCTAssertNotNil(localError);
    req.object = @"test";

    req.restoreRequest.days  = 10;

    req.restoreRequest.CASJobParameters.tier =QCloudCASTierStandard;

    [req setFinishBlock:^(id outputObject, NSError *error) {

        [expectation fulfill];

    }];

    [[QCloudCOSXMLService defaultCOSXML] PostObjectRestore:req];
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

-(void)testQCloudGetGenerateSnapshotRequest{
    XCTestExpectation* expectation = [self expectationWithDescription:@"testQCloudPostObjectRestoreRequest"];
    QCloudGetGenerateSnapshotRequest * shotRequest = [QCloudGetGenerateSnapshotRequest new];
    NSError * localError;
    [shotRequest buildRequestData:&localError];
    XCTAssertNotNil(localError);
    shotRequest.bucket = gTransferTestBucket.name;
    
    [shotRequest buildRequestData:&localError];
    XCTAssertNotNil(localError);
    
    shotRequest.generateSnapshotConfiguration = [QCloudGenerateSnapshotConfiguration new];
    shotRequest.generateSnapshotConfiguration.time = 1;
    shotRequest.finishBlock = ^(id outputObject, NSError *error) {
        [expectation fulfill];
    };
    [[QCloudCOSXMLService defaultCOSXML] GetGenerateSnapshot:shotRequest];
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

-(void)testQCloudPicOperations{
    // 测试空规则情况
    QCloudPicOperations * op = [[QCloudPicOperations alloc]init];
    XCTAssertNotNil([op getPicOperationsJson]);
    
    // 测试 is_pic_info 属性
    op.is_pic_info = YES;
    XCTAssertNotNil([op getPicOperationsJson]); // 仍无规则，返回nil
    
    // 测试半盲水印规则 (type=1)
    QCloudPicOperationRule * rule1 = [[QCloudPicOperationRule alloc]init];
    rule1.type = QCloudPicOperationRuleHalf;
    rule1.actionType = QCloudPicOperationRuleActionPut;
    rule1.imageURL = @"http://examplebucket-1250000000.picsh.myqcloud.com/shuiyin.png";
    rule1.fileid = @"output/half_watermark.jpg";
    rule1.level = 1;
    XCTAssertNotNil(rule1.rule);
    
    // 测试全盲水印规则 (type=2)
    QCloudPicOperationRule * rule2 = [[QCloudPicOperationRule alloc]init];
    rule2.type = QCloudPicOperationRuleFull;
    rule2.actionType = QCloudPicOperationRuleActionPut;
    rule2.imageURL = @"http://examplebucket-1250000000.picsh.myqcloud.com/shuiyin2.png";
    rule2.fileid = @"output/full_watermark.jpg";
    rule2.level = 2;
    XCTAssertNotNil(rule2.rule);
    
    // 测试全盲水印 level 边界值
    QCloudPicOperationRule * rule2a = [[QCloudPicOperationRule alloc]init];
    rule2a.type = QCloudPicOperationRuleFull;
    rule2a.actionType = QCloudPicOperationRuleActionPut;
    rule2a.imageURL = @"http://examplebucket-1250000000.picsh.myqcloud.com/shuiyin.png";
    rule2a.fileid = @"output/full_watermark_level0.jpg";
    rule2a.level = 0; // 小于1，应默认为1
    XCTAssertNotNil(rule2a.rule);
    XCTAssertTrue([rule2a.rule containsString:@"/level/1"]);
    
    QCloudPicOperationRule * rule2b = [[QCloudPicOperationRule alloc]init];
    rule2b.type = QCloudPicOperationRuleFull;
    rule2b.actionType = QCloudPicOperationRuleActionPut;
    rule2b.imageURL = @"http://examplebucket-1250000000.picsh.myqcloud.com/shuiyin.png";
    rule2b.fileid = @"output/full_watermark_level5.jpg";
    rule2b.level = 5; // 大于3，应默认为3
    XCTAssertNotNil(rule2b.rule);
    XCTAssertTrue([rule2b.rule containsString:@"/level/3"]);
    
    // 测试文字水印规则 (type=3)
    QCloudPicOperationRule * rule3 = [[QCloudPicOperationRule alloc]init];
    rule3.type = QCloudPicOperationRuleText;
    rule3.actionType = QCloudPicOperationRuleActionPut;
    rule3.fileid = @"output/text_watermark.jpg";
    rule3.text = @"testWatermark123";
    XCTAssertNotNil(rule3.rule);
    XCTAssertTrue([rule3.rule containsString:@"/text/"]);
    
    // 测试提取水印操作
    QCloudPicOperationRule * rule4 = [[QCloudPicOperationRule alloc]init];
    rule4.type = QCloudPicOperationRuleFull;
    rule4.actionType = QCloudPicOperationRuleActionExtrac;
    rule4.imageURL = @"http://examplebucket-1250000000.picsh.myqcloud.com/watermarked.png";
    rule4.fileid = @"output/extracted.jpg";
    rule4.level = 2;
    XCTAssertNotNil(rule4.rule);
    
    // 测试直接指定 rule 字符串
    QCloudPicOperationRule * rule5 = [[QCloudPicOperationRule alloc]init];
    rule5.fileid = @"output/custom_rule.jpg";
    rule5.rule = @"imageMogr2/thumbnail/!50p";
    XCTAssertEqualObjects(rule5.rule, @"imageMogr2/thumbnail/!50p");
    
    // 设置规则并生成JSON
    op.rule = @[rule1, rule2, rule3];
    NSString *json = [op getPicOperationsJson];
    XCTAssertNotNil(json);
    
    // 测试 is_pic_info = NO 的情况
    QCloudPicOperations * op2 = [[QCloudPicOperations alloc]init];
    op2.is_pic_info = NO;
    op2.rule = @[rule5];
    NSString *json2 = [op2 getPicOperationsJson];
    XCTAssertNotNil(json2);
    
    // 测试错误情况：type 无效
    QCloudPicOperationRule * ruleInvalid1 = [[QCloudPicOperationRule alloc]init];
    ruleInvalid1.type = 0; // 无效类型
    ruleInvalid1.fileid = @"output/invalid.jpg";
    XCTAssertNil(ruleInvalid1.rule);
    
    QCloudPicOperationRule * ruleInvalid2 = [[QCloudPicOperationRule alloc]init];
    ruleInvalid2.type = 4; // 超出范围
    ruleInvalid2.fileid = @"output/invalid2.jpg";
    XCTAssertNil(ruleInvalid2.rule);
    
    // 测试错误情况：半盲水印缺少 imageURL
    QCloudPicOperationRule * ruleInvalid3 = [[QCloudPicOperationRule alloc]init];
    ruleInvalid3.type = QCloudPicOperationRuleHalf;
    ruleInvalid3.actionType = QCloudPicOperationRuleActionPut;
    ruleInvalid3.fileid = @"output/no_image.jpg";
    // 未设置 imageURL
    XCTAssertNil(ruleInvalid3.rule);
    
    // 测试错误情况：全盲水印缺少 imageURL
    QCloudPicOperationRule * ruleInvalid4 = [[QCloudPicOperationRule alloc]init];
    ruleInvalid4.type = QCloudPicOperationRuleFull;
    ruleInvalid4.actionType = QCloudPicOperationRuleActionPut;
    ruleInvalid4.fileid = @"output/no_image2.jpg";
    // 未设置 imageURL
    XCTAssertNil(ruleInvalid4.rule);
    
    // 测试错误情况：文字水印缺少 text
    QCloudPicOperationRule * ruleInvalid5 = [[QCloudPicOperationRule alloc]init];
    ruleInvalid5.type = QCloudPicOperationRuleText;
    ruleInvalid5.actionType = QCloudPicOperationRuleActionPut;
    ruleInvalid5.fileid = @"output/no_text.jpg";
    // 未设置 text
    XCTAssertNil(ruleInvalid5.rule);
    
    // 测试错误情况：文字水印包含非法字符
    QCloudPicOperationRule * ruleInvalid6 = [[QCloudPicOperationRule alloc]init];
    ruleInvalid6.type = QCloudPicOperationRuleText;
    ruleInvalid6.actionType = QCloudPicOperationRuleActionPut;
    ruleInvalid6.fileid = @"output/invalid_text.jpg";
    ruleInvalid6.text = @"中文水印"; // 非法字符
    XCTAssertNil(ruleInvalid6.rule);
    
    // 测试错误情况：规则缺少 fileid
    QCloudPicOperationRule * ruleInvalid7 = [[QCloudPicOperationRule alloc]init];
    ruleInvalid7.rule = @"imageMogr2/thumbnail/!50p";
    // 未设置 fileid
    QCloudPicOperations * opInvalid = [[QCloudPicOperations alloc]init];
    opInvalid.rule = @[ruleInvalid7];
    XCTAssertNil([opInvalid getPicOperationsJson]);
    
    // 测试超过5条规则的情况（应只保留前5条）
    QCloudPicOperations * opMany = [[QCloudPicOperations alloc]init];
    NSMutableArray *manyRules = [NSMutableArray array];
    for (int i = 0; i < 7; i++) {
        QCloudPicOperationRule *r = [[QCloudPicOperationRule alloc]init];
        r.fileid = [NSString stringWithFormat:@"output/rule%d.jpg", i];
        r.rule = [NSString stringWithFormat:@"imageMogr2/thumbnail/!%dp", (i+1)*10];
        [manyRules addObject:r];
    }
    opMany.rule = manyRules;
    NSString *jsonMany = [opMany getPicOperationsJson];
    XCTAssertNotNil(jsonMany);
}

- (void)testQCloudGetBucketRequest {
    XCTestExpectation* getObjectExpectation = [self expectationWithDescription:@"testQCloudGetBucketRequest"];
    QCloudGetBucketRequest *getBucketRequest = [[QCloudGetBucketRequest alloc] init];
    getBucketRequest.bucket = @"tinna-media-1253960454";
    getBucketRequest.regionName = @"ap-chongqing";
    getBucketRequest.maxKeys = 1000;
    [getBucketRequest setFinishBlock:^(QCloudListBucketResult *_Nonnull result, NSError *_Nonnull error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [getObjectExpectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetBucket:getBucketRequest];
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)testQCloudGetBucketRequest1 {
    XCTestExpectation* getObjectExpectation = [self expectationWithDescription:@"testQCloudGetBucketRequest1"];
    QCloudGetBucketRequest *getBucketRequest = [[QCloudGetBucketRequest alloc] init];
    getBucketRequest.bucket = @"tinna-media-1253960454";
    getBucketRequest.regionName = @"ap-chongqing";
    [getBucketRequest setFinishBlock:^(QCloudListBucketResult *_Nonnull result, NSError *_Nonnull error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [getObjectExpectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetBucket:getBucketRequest];
    [self waitForExpectationsWithTimeout:80 handler:nil];
}
@end
