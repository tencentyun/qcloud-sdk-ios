//
//  QCloudCOSXMLImageHelperTests.m
//  QCloudCOSXMLDemoTests
//
//  Created by garenwang on 2020/6/8.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <QCloudCOSXML/QCloudCOSXML.h>
#import "TestCommonDefine.h"
#import "QCloudTestTempVariables.h"
#import "QCloudCOSXMLTestUtility.h"
#import "SecretStorage.h"
#define kCOSImageBucketKey @"imgBucket"
@interface QCloudCOSXMLImageHelperTests : XCTestCase <QCloudSignatureProvider>
@property (nonatomic, strong) NSString *appID;
@property (nonatomic, strong) NSString *ownerID;
@property (nonatomic, strong) NSString *authorizedUIN;
@property (nonatomic, strong) NSString *ownerUIN;
@property (nonatomic, strong) NSMutableArray *tempFilePathArray;
@end
static QCloudBucket *imageTestBucket;
@implementation QCloudCOSXMLImageHelperTests

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
    configuration.appID = kAppID;
    configuration.signatureProvider = self;
    QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.regionName = @"ap-guangzhou";
    configuration.endpoint = endpoint;

    [QCloudCOSXMLService registerCOSXMLWithConfiguration:configuration withKey:kTestFromAnotherRegionCopy];
    [QCloudCOSTransferMangerService registerCOSTransferMangerWithConfiguration:configuration withKey:kTestFromAnotherRegionCopy];
}

+ (void)setUp {
    imageTestBucket = [[QCloudCOSXMLTestUtility sharedInstance] createTestBucketWithPrefix:kCOSImageBucketKey];
}

+ (void)tearDown {
    [[QCloudCOSXMLTestUtility sharedInstance] deleteTestBucket:imageTestBucket];
}

- (void)setUp {
    [super setUp];
    [self setupSpecialCOSXMLShareService];

    self.appID = @"1253653367";
    self.ownerID = @"1278687956";
    self.authorizedUIN = @"1131975903";
    self.ownerUIN = @"1278687956";
    self.tempFilePathArray = [NSMutableArray array];
}

- (void)tearDown {;
    [self.tempFilePathArray enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSFileManager *manager = [NSFileManager defaultManager];
        if ([manager fileExistsAtPath:obj]) {
            [manager removeItemAtPath:obj error:nil];
        }
    }];
    [super tearDown];
}

- (void)testSetupWaterMark {
    XCTestExpectation* exp = [self expectationWithDescription:@"Recognition"];
    QCloudPutObjectWatermarkRequest *put = [QCloudPutObjectWatermarkRequest new];
    
    NSError * localError;
    [put buildRequestData:&localError];
    XCTAssertNotNil(localError);
    put.object = @"objectName";
    
    [put buildRequestData:&localError];
    XCTAssertNotNil(localError);
    put.bucket = imageTestBucket.name;
    
    [put buildRequestData:&localError];
    XCTAssertNotNil(localError);
    put.body = [@"123456789" dataUsingEncoding:NSUTF8StringEncoding];
    
    QCloudPicOperations *op = [[QCloudPicOperations alloc] init];
    op.is_pic_info = NO;
    QCloudPicOperationRule *rule = [[QCloudPicOperationRule alloc] init];
    rule.fileid = @"test";
    rule.text = @"123"; // 水印文字只能是 [a-zA-Z0-9]
    rule.type = QCloudPicOperationRuleText;
    op.rule = @[ rule ];
    
    NSDictionary * dic = [put.scopesArray firstObject];
    NSString * action = dic[@"action"];
    XCTAssertTrue([action isEqualToString:@"name/cos:PutObject"]);
    
    [put buildRequestData:&localError];
    XCTAssertNotNil(localError);
    put.picOperations = op;
    
    [put setFinishBlock:^(id outputObject, NSError *error) {
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutWatermarkObject:put];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

- (void)testRecognition {
    XCTestExpectation* exp = [self expectationWithDescription:@"Recognition"];
    QCloudGetRecognitionObjectRequest *request = [QCloudGetRecognitionObjectRequest new];
    
    NSError * localError;
    [request buildRequestData:&localError];
    XCTAssertNotNil(localError);
    request.bucket = imageTestBucket.name;
    
    [request buildRequestData:&localError];
    XCTAssertNotNil(localError);
    request.object = @"objectName";
    
    [request buildRequestData:&localError];
    XCTAssertNotNil(localError);
    request.detectType = QCloudRecognitionPorn | QCloudRecognitionAds; // 支持多种类型同时审核
    
    NSDictionary * dic = [request.scopesArray firstObject];
    NSString * action = dic[@"action"];
    XCTAssertTrue([action isEqualToString:@"name/cos:GetObject"]);
    
    [request setFinishBlock:^(QCloudGetRecognitionObjectResult *_Nullable outputObject, NSError *_Nullable error) {
        NSLog(@"%@", outputObject);
        [exp fulfill];
    }];

    [[QCloudCOSXMLService defaultCOSXML] GetRecognitionObject:request];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

-(void)testQCloudGetFilePreviewRequest{
    XCTestExpectation* exp = [self expectationWithDescription:@"QCloudGetFilePreviewRequest"];
    
    QCloudGetFilePreviewRequest *request = [[QCloudGetFilePreviewRequest alloc]init];
    
    NSError * localError;
    [request buildRequestData:&localError];
    XCTAssertNotNil(localError);
    
    request.bucket = imageTestBucket.name;
    [request buildRequestData:&localError];
    XCTAssertNotNil(localError);
    
    request.object = @"test";
    [request buildRequestData:&localError];
    XCTAssertNotNil(localError);
    
    request.page = 0;
    request.regionName = kRegion;
    
    NSDictionary *dic = [request.scopesArray firstObject];
    NSString * action = dic[@"action"];
    XCTAssertTrue([action isEqualToString:@"name/cos:GetObject"]);
    
    [request setFinishBlock:^(QCloudGetFilePreviewResult * _Nullable result, NSError * _Nullable error) {
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetFilePreviewObject:request];
    
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^ {
        // Put the code you want to measure the time of here.
    }];
}

@end
