//
//  QCloudCOSXMLIntergrationSpeedTestTests.m
//  QCloudCOSXMLIntergrationSpeedTestTests
//
//  Created by erichmzhang(张恒铭) on 25/12/2017.
//  Copyright © 2017 erichmzhang(张恒铭). All rights reserved.
//

#import <XCTest/XCTest.h>
#import <QCloudCOSXML/QCloudCOSXML.h>
#import <QCloudCore/QCloudCore.h>
#import <QCloudCore/QCloudTestUtility.h>
#import "TestCommonDefine.h"

#define TEST_REGION @"ap-guangzhou"
#define TEST_BUCKET @"xy3"
#define TEST_SERVICE_KEY @"TESTSERVICEKEY"
@interface QCloudCOSXMLIntergrationSpeedTestTests : XCTestCase<QCloudSignatureProvider>
@property (nonatomic, copy) NSString* bucket;
@property (nonatomic, copy) NSString* region;
@end

@implementation QCloudCOSXMLIntergrationSpeedTestTests


- (void) signatureWithFields:(QCloudSignatureFields*)fileds
                     request:(QCloudBizHTTPRequest*)request
                  urlRequest:(NSMutableURLRequest*)urlRequst
                   compelete:(QCloudHTTPAuthentationContinueBlock)continueBlock
{
    QCloudCredential* credential = [QCloudCredential new];
    credential.secretID = @"AKIDPiqmW3qcgXVSKN8jngPzRhvxzYyDL5qP";
    credential.secretKey = @"EH8oHoLgpmJmBQUM1Uoywjmv7EFzd5OJ";
    QCloudAuthentationV5Creator* creator = [[QCloudAuthentationV5Creator alloc] initWithCredential:credential];
    QCloudSignature* signature =  [creator signatureForData:urlRequst];
    continueBlock(signature, nil);
}


+ (void)setUp {

}

- (void)setUp {
    [super setUp];
    QCloudServiceConfiguration* configuration = [QCloudServiceConfiguration new];
    configuration.appID = @"1253653367";
    configuration.signatureProvider = self;
    QCloudCOSXMLEndPoint* endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.regionName = TEST_REGION;
    configuration.endpoint = endpoint;
    
    [QCloudCOSXMLService registerCOSXMLWithConfiguration:configuration withKey:TEST_SERVICE_KEY];
    [QCloudCOSTransferMangerService registerCOSTransferMangerWithConfiguration:configuration withKey:TEST_SERVICE_KEY];
    self.bucket = TEST_BUCKET;
}


- (void)runFileUploadTestWithSizeInMB:(NSInteger)sizeInMB totalCount:(NSInteger)count {
    __block NSUInteger successCount = 0;
    __block NSUInteger totalCount = (NSUInteger)count;
    __block double   averageTimeSpent = 0.0f;
    NSMutableArray* tempFilePathArray = [NSMutableArray array];
    for (NSInteger i = 0; i < totalCount; i ++) {
        [tempFilePathArray addObject:[QCloudTestUtility tempFileWithSize:sizeInMB unit:QCLOUD_TEST_FILE_UNIT_MB]];
    }
    for (NSInteger i = 0; i < totalCount; i++) {
        
        XCTestExpectation* tempExpectation = [self expectationWithDescription:@"TempExpectation"];
        QCloudCOSXMLUploadObjectRequest* uploadObjectRequest = [[QCloudCOSXMLUploadObjectRequest alloc] init];
        uploadObjectRequest.bucket = self.bucket;
        uploadObjectRequest.body  = [NSURL fileURLWithPath:tempFilePathArray[i]];
        uploadObjectRequest.object = [tempFilePathArray[i] lastPathComponent];
        __block NSDate* startDate = [NSDate date];
        [uploadObjectRequest setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            NSLog(@"%i th request bytesSent:%lli totoalBytesSent:%i totalBytesExpectedToSent:%i",i,bytesSent,totalBytesSent,totalBytesExpectedToSend);
        }];
        
        [uploadObjectRequest setFinishBlock:^(QCloudUploadObjectResult *result, NSError *error) {
            XCTAssertNil(error);
            if ( nil == error) {
                successCount ++;
                NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:startDate];
                averageTimeSpent = ( averageTimeSpent * i + timeInterval ) / (i+1) ;
            }
            [tempExpectation fulfill];
        }];
        [[QCloudCOSTransferMangerService costransfermangerServiceForKey:TEST_SERVICE_KEY] UploadObject:uploadObjectRequest];
        [self waitForExpectationsWithTimeout:5000 handler:nil];
        [NSThread sleepForTimeInterval:3.0f];
    }
    
    XCTAssert(successCount == totalCount,@"Success Count is %lu, total count is %lu",successCount,totalCount);
    NSLog(@"Success Count is %lu, total count is %lu",successCount,totalCount);
    for (NSString* path in tempFilePathArray) {
        [[NSFileManager defaultManager ]removeItemAtPath:path error:nil];
        QCloudDeleteObjectRequest* deleteObjectRequest = [[QCloudDeleteObjectRequest alloc] init];
        deleteObjectRequest.bucket = self.bucket;
        deleteObjectRequest.object = path.lastPathComponent;
        [[QCloudCOSXMLService defaultCOSXML] DeleteObject:deleteObjectRequest];
    }
    
    XCTFail(@"Average time spent in success is %f",averageTimeSpent);
}

- (void)test1MBFileUpload5Times {
    [self runFileUploadTestWithSizeInMB:1 totalCount:5];
}



- (void)test10MBFileUpload5Times {
    [self runFileUploadTestWithSizeInMB:10 totalCount:5];
}

- (void)test50MBFileUpload3Times {
    [self runFileUploadTestWithSizeInMB:50 totalCount:3];
}



- (void)getObjectWithName:(NSString*)name times:(NSInteger)times {
    __block NSInteger successCount = 0;
    __block NSInteger totalTimes = times;
    __block double   averageTimeSpent = 0.0f;
    
    for (int i = 0; i < totalTimes; i++) {
        __block NSDate* startDate = [NSDate date];
        
        QCloudGetObjectRequest* getObjectRequest = [[QCloudGetObjectRequest alloc] init];
        getObjectRequest.bucket = @"xy3";
        getObjectRequest.object = name;
        [getObjectRequest setDownloadingURL:[NSURL fileURLWithPath:[QCloudTempDir() stringByAppendingPathComponent:name]]];
        [getObjectRequest setDownProcessBlock:^(int64_t bytesDownload, int64_t totalBytesDownload, int64_t totalBytesExpectedToDownload) {
            NSLog(@"total bytes download%llu, total bytes expected to download%llu",totalBytesDownload,totalBytesExpectedToDownload);
        }];
        
        XCTestExpectation* expectation = [self expectationWithDescription:@"Download "];
        
        
        
        [getObjectRequest setFinishBlock:^(id outputObject, NSError *error) {
            XCTAssertNil(error);
            if (error == nil) {
                successCount ++;
                NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:startDate];
                averageTimeSpent = ( averageTimeSpent * i + timeInterval ) / (i+1) ;
            }
            [expectation fulfill];
        }];
        NSString* errorString = [NSString stringWithFormat:@"success count %ld, total Count %ld",(long)successCount,(long)totalTimes];
        
        NSLog(errorString);
        [[QCloudCOSXMLService cosxmlServiceForKey:TEST_SERVICE_KEY] GetObject:getObjectRequest];
        [self waitForExpectationsWithTimeout:8000 handler:nil];
        [[NSFileManager defaultManager] removeItemAtPath:getObjectRequest.downloadingURL.path error:nil];
    }
    XCTAssert(successCount == totalTimes,@"success count %ld, total Count %ld",(long)successCount,(long)totalTimes);
    XCTFail(@"Average time spent in success is %f",averageTimeSpent);
    
}

- (void)testGet1MBObject5Times {
    [self getObjectWithName:@"176D2268-E084-4796-B902-9801083B2439" times:5];
}


- (void)testGet10MBObject5Times {
    [self getObjectWithName:@"4FDC8161-7D84-4126-B6AC-2E39B052BB07" times:5];
}


- (void)testGet50MBObject3Times {
    [self getObjectWithName:@"0010BF50-BC00-4C52-8F07-63D5008C2E54" times:3];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end

