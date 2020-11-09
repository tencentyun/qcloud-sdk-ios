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

@interface QCloudCOSXMLImageHelperTests : XCTestCase <QCloudSignatureProvider>
@property (nonatomic, strong) NSString *bucket;
@property (nonatomic, strong) NSString *appID;
@property (nonatomic, strong) NSString *ownerID;
@property (nonatomic, strong) NSString *authorizedUIN;
@property (nonatomic, strong) NSString *ownerUIN;
@property (nonatomic, strong) NSMutableArray *tempFilePathArray;
@end

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
    [QCloudTestTempVariables sharedInstance].testBucket = [[QCloudCOSXMLTestUtility sharedInstance] createTestBucketWithPrefix:@"dt"];
}

+ (void)tearDown {
    [[QCloudCOSXMLTestUtility sharedInstance] deleteAllTestBuckets];
}

- (void)setUp {
    [super setUp];
    [self setupSpecialCOSXMLShareService];

    self.appID = @"1253653367";
    self.ownerID = @"1278687956";
    self.authorizedUIN = @"1131975903";
    self.ownerUIN = @"1278687956";
    self.bucket = [QCloudTestTempVariables sharedInstance].testBucket;
    self.tempFilePathArray = [NSMutableArray array];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    //    [[QCloudCOSXMLTestUtility sharedInstance] deleteTestBucket:self.bucket];
    [self.tempFilePathArray enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSFileManager *manager = [NSFileManager defaultManager];
        if ([manager fileExistsAtPath:obj]) {
            [manager removeItemAtPath:obj error:nil];
        }
    }];
    [super tearDown];
}

- (void)testSetupWaterMark {
    QCloudPutObjectWatermarkRequest *put = [QCloudPutObjectWatermarkRequest new];
    put.object = @"objectName";
    put.bucket = [QCloudTestTempVariables sharedInstance].testBucket;
    put.body = [@"123456789" dataUsingEncoding:NSUTF8StringEncoding];
    QCloudPicOperations *op = [[QCloudPicOperations alloc] init];
    op.is_pic_info = NO;
    QCloudPicOperationRule *rule = [[QCloudPicOperationRule alloc] init];
    rule.fileid = @"test";
    rule.text = @"123"; // 水印文字只能是 [a-zA-Z0-9]
    rule.type = QCloudPicOperationRuleText;
    op.rule = @[ rule ];
    put.picOperations = op;
    [put setFinishBlock:^(id outputObject, NSError *error) {

    }];
    [[QCloudCOSXMLService defaultCOSXML] PutWatermarkObject:put];
}

- (void)testRecognition {
    //
    QCloudGetRecognitionObjectRequest *request = [QCloudGetRecognitionObjectRequest new];
    request.bucket = [QCloudTestTempVariables sharedInstance].testBucket;
    ; //存储桶名称(cos v5 的 bucket格式为：xxx-appid, 如 test-1253960454)
    request.object = @"objectName";
    request.detectType = QCloudRecognitionPorn | QCloudRecognitionAds; // 支持多种类型同时审核
    [request setFinishBlock:^(QCloudGetRecognitionObjectResult *_Nullable outputObject, NSError *_Nullable error) {
        NSLog(@"%@", outputObject);
    }];

    [[QCloudCOSXMLService defaultCOSXML] GetRecognitionObject:request];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^ {
        // Put the code you want to measure the time of here.
    }];
}

@end
