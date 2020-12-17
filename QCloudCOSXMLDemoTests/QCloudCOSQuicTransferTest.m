//
//  QCloudCOSQuicTransferTest.m
//  QCloudCOSXMLDemoTests
//
//  Created by wjielai on 2020/5/14.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <QCloudCore/QCloudCore.h>
#import <QCloudCOSXML/QCloudCOSXML.h>
#import "SecretStorage.h"
#import "TestCommonDefine.h"

#define ServiceKey @"QUIC"

#define QUIC_BUCKET @"demo-ap-shanghai"
#define QUIC_BUCKET_REGION @"ap-shanghai"

@interface QCloudCOSQuicTransferTest : XCTestCase <QCloudSignatureProvider>

@end

@implementation QCloudCOSQuicTransferTest

- (void)signatureWithFields:(QCloudSignatureFields *)fileds
                    request:(QCloudBizHTTPRequest *)request
                 urlRequest:(NSMutableURLRequest *)urlRequst
                  compelete:(QCloudHTTPAuthentationContinueBlock)continueBlock {
    QCloudCredential *credential = [QCloudCredential new];
    credential.secretID = [SecretStorage.sharedInstance secretID];
    credential.secretKey = [SecretStorage.sharedInstance secretKey];
    QCloudAuthentationV5Creator *creator = [[QCloudAuthentationV5Creator alloc] initWithCredential:credential];
    QCloudSignature *signature = [creator signatureForData:urlRequst];
    //    [urlRequst setValue:[NSString stringWithFormat:@"%@-%@.cos.%@.myqcloud.com", QUIC_BUCKET, kAppID, QUIC_BUCKET_REGION]
    //    forHTTPHeaderField:@"Host"];
    continueBlock(signature, nil);
}

- (void)setupSpecialCOSXMLShareService {
    if ([QCloudCOSXMLService hasServiceForKey:ServiceKey]) {
        return;
    }
    QCloudServiceConfiguration *configuration = [[QCloudServiceConfiguration alloc] init];
    configuration.appID = kAppID;
    configuration.signatureProvider = self;
    QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.regionName = QUIC_BUCKET_REGION;
    endpoint.useHTTPS = YES;
    configuration.endpoint = endpoint;
    [QCloudCOSXMLService registerCOSXMLWithConfiguration:configuration withKey:ServiceKey];
    [QCloudCOSTransferMangerService registerCOSTransferMangerWithConfiguration:configuration withKey:ServiceKey];
}

- (void)setUp {
    [super setUp];
    [self setupSpecialCOSXMLShareService];

    [[QCloudHttpDNS shareDNS] setIp:@"101.227.219.151"
                          forDomain:[NSString stringWithFormat:@"%@-%@.cos.%@.myqcloud.com", QUIC_BUCKET, kAppID, QUIC_BUCKET_REGION]];
}

- (NSString *)tempFileWithSize:(int)size {
    NSString *file4MBPath = QCloudPathJoin(QCloudTempDir(), [NSUUID UUID].UUIDString);

    if (!QCloudFileExist(file4MBPath)) {
        [[NSFileManager defaultManager] createFileAtPath:file4MBPath contents:[NSData data] attributes:nil];
    }
    NSFileHandle *handler = [NSFileHandle fileHandleForWritingAtPath:file4MBPath];
    [handler truncateFileAtOffset:size];
    [handler closeFile];

    return file4MBPath;
}

//- (void) testSimpleUpload {
//    XCTestExpectation* exp = [self expectationWithDescription:@"testSimpleUpload"];
//
//    QCloudCOSXMLUploadObjectRequest * request = [QCloudCOSXMLUploadObjectRequest new];
//    request.bucket = QUIC_BUCKET;
//    request.object = @"quic_small_object";
//    request.enableQuic = YES;
//    request.body = [NSURL fileURLWithPath:[self tempFileWithSize:1*1024*1024]];
//
//    [request setFinishBlock:^(QCloudUploadObjectResult * _Nullable result, NSError * _Nullable error) {
//        XCTAssertNil(error);
//        [exp fulfill];
//    }];
//    [[QCloudCOSTransferMangerService costransfermangerServiceForKey:ServiceKey] UploadObject:request];
//
//    [self waitForExpectationsWithTimeout:100 handler:nil];
//
//}
//
//- (void) testMultiUpload {
//    XCTestExpectation* exp = [self expectationWithDescription:@"testMultiUpload"];
//
//    QCloudCOSXMLUploadObjectRequest * request = [QCloudCOSXMLUploadObjectRequest new];
//    request.bucket = QUIC_BUCKET;
//    request.object = @"quic_large_object";
//    request.enableQuic = YES;
//    request.body = [NSURL fileURLWithPath:[self tempFileWithSize:20*1024*1024]];
//
//    [request setFinishBlock:^(QCloudUploadObjectResult * _Nullable result, NSError * _Nullable error) {
//        XCTAssertNil(error);
//        [exp fulfill];
//    }];
//    [[QCloudCOSTransferMangerService costransfermangerServiceForKey:ServiceKey] UploadObject:request];
//
//    [self waitForExpectationsWithTimeout:100 handler:nil];
//
//}
//
//- (void) testDownload {
//    XCTestExpectation* exp = [self expectationWithDescription:@"testDownload"];
//
//    QCloudCOSXMLDownloadObjectRequest * request = [QCloudCOSXMLDownloadObjectRequest new];
//    request.bucket = QUIC_BUCKET;
//    request.object = @"quic_large_object";
//    request.enableQuic = YES;
//
//    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
//        XCTAssertNil(error);
//        [exp fulfill];
//    }];
//    [[QCloudCOSTransferMangerService costransfermangerServiceForKey:ServiceKey] DownloadObject:request];
//
//    [self waitForExpectationsWithTimeout:100 handler:nil];
//
//}
//
//- (void) testDelete {
//    XCTestExpectation* exp = [self expectationWithDescription:@"testDelete"];
//
//    QCloudDeleteObjectRequest * request = [QCloudDeleteObjectRequest new];
//    request.bucket = QUIC_BUCKET;
//    request.object = @"quic_small_object";
//    request.enableQuic = YES;
//
//    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
//        XCTAssertNil(error);
//        [exp fulfill];
//    }];
//    [[QCloudCOSXMLService cosxmlServiceForKey:ServiceKey] DeleteObject:request];
//
//    [self waitForExpectationsWithTimeout:100 handler:nil];
//}

@end
