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
    configuration.appID = self.appID;
    configuration.signatureProvider = self;
    QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.regionName = @"ap-guangzhou";
    configuration.endpoint = endpoint;

    [QCloudCOSXMLService registerCOSXMLWithConfiguration:configuration withKey:kTestFromAnotherRegionCopy];
    [QCloudCOSTransferMangerService registerCOSTransferMangerWithConfiguration:configuration withKey:kTestFromAnotherRegionCopy];
}

+ (void)setUp {
    imageTestBucket = [QCloudBucket new];
    imageTestBucket.name = @"ci-1253960454";
}

+ (void)tearDown {
//    [[QCloudCOSXMLTestUtility sharedInstance] deleteTestBucket:imageTestBucket];
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

- (void)tearDown {;
    [self.tempFilePathArray enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSFileManager *manager = [NSFileManager defaultManager];
        if ([manager fileExistsAtPath:obj]) {
            [manager removeItemAtPath:obj error:nil];
        }
    }];
    [super tearDown];
}
////云上数据 处理
//- (void)testCloudDataDetail {
//    XCTestExpectation* exp = [self expectationWithDescription:@"Recognition"];
//    QCloudCICloudDataOperationsRequest *put = [QCloudCICloudDataOperationsRequest new];
//    NSError * localError;
////    [put buildRequestData:&localError];
////    XCTAssertNotNil(localError);
//    put.object = @"ci.png";
//    put.regionName = @"ap-guangzhou";
//    put.bucket = imageTestBucket.name;
//    [put buildRequestData:&localError];
//    XCTAssertNotNil(localError);
//    
//    [put buildRequestData:&localError];
//    XCTAssertNotNil(localError);
//
//    
//    QCloudPicOperations *op = [[QCloudPicOperations alloc] init];
//    op.is_pic_info = NO;
//    QCloudPicOperationRule *rule = [[QCloudPicOperationRule alloc] init];
//    rule.fileid = @"test";
//    rule.text = @"123"; // 水印文字只能是 [a-zA-Z0-9]
//    rule.type = QCloudPicOperationRuleText;
//    op.rule = @[ rule ];
//    
//    [put setFinishBlock:^(QCloudPutObjectWatermarkResult *outputObject, NSError *error) {
//        XCTAssertNotNil(outputObject);
//        XCTAssertNil(error);
//        [exp fulfill];
//    }];
//    [[QCloudCOSXMLService defaultCOSXML] CloudDataOperations:put];
//    [self waitForExpectationsWithTimeout:100 handler:nil];
//}
//
//
////图片标签
//- (void)testPicRecognition{
//    XCTestExpectation* exp = [self expectationWithDescription:@"Recognition"];
//    QCloudCIPicRecognitionRequest *request = [QCloudCIPicRecognitionRequest new];
//    
//    NSError * localError;
//    [request buildRequestData:&localError];
//    XCTAssertNotNil(localError);
//    //
//    request.bucket = imageTestBucket.name;
//    request.object = @"ci.png";
//    
//    [request setFinishBlock:^(QCloudCIPicRecognitionResults *_Nullable outputObject, NSError *_Nullable error) {
//        XCTAssertNil(error);
//        XCTAssertNotNil(outputObject);
//        [exp fulfill];
//    }];
//
//    [[QCloudCOSXMLService defaultCOSXML] CIPicRecognition:request];
//    [self waitForExpectationsWithTimeout:100 handler:nil];
//}
//
////二维码识别
//- (void)testQRCodeRecognition{
//    XCTestExpectation* exp = [self expectationWithDescription:@"Recognition"];
//    QCloudQRCodeRecognitionRequest *put = [QCloudQRCodeRecognitionRequest new];
//    // 存储桶名称，格式为 BucketName-APPID
//    put.bucket = imageTestBucket.name;
//        
//    // 对象键，是对象在 COS 上的完整路径，如果带目录的话，格式为 "dir1/object1"
//    put.object = @"qrcode.png";
//
//    QCloudPicOperations *op = [[QCloudPicOperations alloc] init];
//    // 是否返回原图信息。0表示不返回原图信息，1表示返回原图信息，默认为0
//    op.is_pic_info = NO;
//    QCloudPicOperationRule * rule = [[QCloudPicOperationRule alloc]init];
//    rule.fileid = @"test";
//    //二维码识别的rule
//    rule.rule = @"QRcode/cover/1";
//    // 处理结果的文件路径名称，如以/开头，则存入指定文件夹中，否则，存入原图文件存储的同目录
//    rule.fileid = @"test";
//    op.rule = @[ rule ];
//    put.picOperations = op;
//    [put setFinishBlock:^(QCloudCIObject * _Nonnull result, NSError * _Nonnull error) {
//        //从result.qrcodeInfos中获取二维码信息
//        NSLog(@"result = %@",result.qrcodeInfos);
//        XCTAssertNil(error);
//        XCTAssertNotNil(result);
//        [exp fulfill];
//    }];
//    [[QCloudCOSXMLService defaultCOSXML] CIQRCodeRecognition:put];
//    [self waitForExpectationsWithTimeout:100 handler:nil];
//}
////上传时添加盲水印
//- (void)testSetupBlindWaterMark {
//    XCTestExpectation* exp = [self expectationWithDescription:@"Recognition"];
//    QCloudPutObjectWatermarkRequest *put = [QCloudPutObjectWatermarkRequest new];
//    
//    NSError * localError;
//    [put buildRequestData:&localError];
//    XCTAssertNotNil(localError);
//    put.object = @"1.png";
//    
//    [put buildRequestData:&localError];
//    XCTAssertNotNil(localError);
//    put.bucket = imageTestBucket.name;
//    
//    [put buildRequestData:&localError];
//    XCTAssertNotNil(localError);
//    put.body = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"image" ofType:@"png"]];
//    
//    QCloudPicOperations *op = [[QCloudPicOperations alloc] init];
//    op.is_pic_info = NO;
//    QCloudPicOperationRule *rule = [[QCloudPicOperationRule alloc] init];
//    rule.fileid = @"test";
//    rule.imageURL = @"http://ci-1253960454.cos.ap-guangzhou.myqcloud.com/protection_blind_watermark_icon.png";
//    rule.type = QCloudPicOperationRuleFull;
//    rule.actionType =QCloudPicOperationRuleActionPut;
//    op.rule = @[ rule ];
//    
//    NSDictionary * dic = [put.scopesArray firstObject];
//    NSString * action = dic[@"action"];
//    XCTAssertTrue([action isEqualToString:@"name/cos:PutObject"]);
//    
//    [put buildRequestData:&localError];
//    XCTAssertNotNil(localError);
//    put.picOperations = op;
//    
//    [put setFinishBlock:^(id outputObject, NSError *error) {
//        [exp fulfill];
//    }];
//    [[QCloudCOSXMLService defaultCOSXML] PutWatermarkObject:put];
//    [self waitForExpectationsWithTimeout:100 handler:nil];
//}
//
////下载时添加盲水印
//- (void)testGetObject {
//    XCTestExpectation *exp = [self expectationWithDescription:@"delete"];
//    __block QCloudGetObjectRequest *request = [QCloudGetObjectRequest new];
//    request.downloadingURL = [NSURL URLWithString:QCloudTempFilePathWithExtension(@"png")];
//    request.bucket = imageTestBucket.name;
//    request.object = @"protection_image.png";
//    request.watermarkRule = @"watermark/3/type/2/image/aHR0cDovL2NpLTEyNTM2NTMzNjcuY29zLmFwLWd1YW5nemhvdS5teXFjbG91ZC5jb20vcHJvdGVjdGlvbl9ibGluZF93YXRlcm1hcmtfaWNvbi5wbmc=";
//    [request setFinishBlock:^(id outputObject, NSError *error) {
//        XCTAssertNil(error);
//        [exp fulfill];
//    }];
//    [request setDownProcessBlock:^(int64_t bytesDownload, int64_t totalBytesDownload, int64_t totalBytesExpectedToDownload) {
//        NSLog(@"⏬⏬⏬⏬DOWN [Total]%lld  [Downloaded]%lld [Download]%lld", totalBytesExpectedToDownload, totalBytesDownload, bytesDownload);
//    }];
//    [[QCloudCOSXMLService defaultCOSXML] GetObject:request];
//    
//    [self waitForExpectationsWithTimeout:80 handler:nil];
//
//}
////提取盲水印
//- (void)testExtraBlindWaterMark {
//    XCTestExpectation* exp = [self expectationWithDescription:@"Recognition"];
//    QCloudPutObjectWatermarkRequest *put = [QCloudPutObjectWatermarkRequest new];
//    
//    NSError * localError;
//    [put buildRequestData:&localError];
//    XCTAssertNotNil(localError);
//    put.object = @"1.png";
//    
//    [put buildRequestData:&localError];
//    XCTAssertNotNil(localError);
//    put.bucket = imageTestBucket.name;
//    
//    [put buildRequestData:&localError];
//    XCTAssertNotNil(localError);
//    put.body = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"image" ofType:@"png"]];
//    
//    QCloudPicOperations *op = [[QCloudPicOperations alloc] init];
//    op.is_pic_info = NO;
//    QCloudPicOperationRule *rule = [[QCloudPicOperationRule alloc] init];
//    rule.fileid = @"watermark.png";
//    rule.imageURL = @"http://ci-1253960454.cos.ap-guangzhou.myqcloud.com/protection_blind_watermark_icon.png";
//    rule.type = QCloudPicOperationRuleFull;
//    rule.actionType =QCloudPicOperationRuleActionPut;
//    op.rule = @[ rule ];
//    
//    NSDictionary * dic = [put.scopesArray firstObject];
//    NSString * action = dic[@"action"];
//    XCTAssertTrue([action isEqualToString:@"name/cos:PutObject"]);
//    
//    [put buildRequestData:&localError];
//    XCTAssertNotNil(localError);
//    put.picOperations = op;
//    
//    [put setFinishBlock:^(id outputObject, NSError *error) {
//        [exp fulfill];
//    }];
//    [[QCloudCOSXMLService defaultCOSXML] PutWatermarkObject:put];
//    [self waitForExpectationsWithTimeout:100 handler:nil];
//}
//
////图片审核
//- (void)testPicReview {
//    XCTestExpectation* exp = [self expectationWithDescription:@"Recognition"];
//    QCloudGetRecognitionObjectRequest *request = [QCloudGetRecognitionObjectRequest new];
//    
//    NSError * localError;
//    [request buildRequestData:&localError];
//    XCTAssertNotNil(localError);
//    request.bucket = imageTestBucket.name;
//    
//    [request buildRequestData:&localError];
//    XCTAssertNotNil(localError);
//    request.object = @"ci.png";
//    
//    [request buildRequestData:&localError];
//    XCTAssertNotNil(localError);
//    request.detectType = QCloudRecognitionPorn | QCloudRecognitionAds; // 支持多种类型同时审核
//    
//    NSDictionary * dic = [request.scopesArray firstObject];
//    NSString * action = dic[@"action"];
//    XCTAssertTrue([action isEqualToString:@"name/cos:GetObject"]);
//    
//    [request setFinishBlock:^(QCloudGetRecognitionObjectResult *_Nullable outputObject, NSError *_Nullable error) {
//        NSLog(@"%@", outputObject);
//        [exp fulfill];
//    }];
//
//    [[QCloudCOSXMLService defaultCOSXML] GetRecognitionObject:request];
//    [self waitForExpectationsWithTimeout:100 handler:nil];
//}
//
//- (void)testSetupWaterMark {
//    XCTestExpectation* exp = [self expectationWithDescription:@"Recognition"];
//    QCloudPutObjectWatermarkRequest *put = [QCloudPutObjectWatermarkRequest new];
//    
//    NSError * localError;
//    [put buildRequestData:&localError];
//    XCTAssertNotNil(localError);
//    put.object = @"objectName";
//    
//    [put buildRequestData:&localError];
//    XCTAssertNotNil(localError);
//    put.bucket = imageTestBucket.name;
//    
//    [put buildRequestData:&localError];
//    XCTAssertNotNil(localError);
//    put.body = [@"123456789" dataUsingEncoding:NSUTF8StringEncoding];
//    
//    QCloudPicOperations *op = [[QCloudPicOperations alloc] init];
//    op.is_pic_info = NO;
//    QCloudPicOperationRule *rule = [[QCloudPicOperationRule alloc] init];
//    rule.fileid = @"test";
//    rule.text = @"123"; // 水印文字只能是 [a-zA-Z0-9]
//    rule.type = QCloudPicOperationRuleText;
//    op.rule = @[ rule ];
//    
//    NSDictionary * dic = [put.scopesArray firstObject];
//    NSString * action = dic[@"action"];
//    XCTAssertTrue([action isEqualToString:@"name/cos:PutObject"]);
//    
//    [put buildRequestData:&localError];
//    XCTAssertNotNil(localError);
//    put.picOperations = op;
//    
//    [put setFinishBlock:^(id outputObject, NSError *error) {
//        [exp fulfill];
//    }];
//    [[QCloudCOSXMLService defaultCOSXML] PutWatermarkObject:put];
//    [self waitForExpectationsWithTimeout:100 handler:nil];
//}
//
//
//
//
//
////文档预览
//-(void)testQCloudGetFilePreviewRequest{
//    XCTestExpectation* exp = [self expectationWithDescription:@"QCloudGetFilePreviewRequest"];
//    
//    QCloudGetFilePreviewRequest *request = [[QCloudGetFilePreviewRequest alloc]init];
//    
//    NSError * localError;
//    [request buildRequestData:&localError];
//    XCTAssertNotNil(localError);
//    
//    request.bucket = imageTestBucket.name;
//    [request buildRequestData:&localError];
//    XCTAssertNotNil(localError);
//    
//    request.object = @"test";
//    [request buildRequestData:&localError];
//    XCTAssertNotNil(localError);
//    
//    request.page = 0;
//    request.regionName = [SecretStorage sharedInstance].region;
//    
//    NSDictionary *dic = [request.scopesArray firstObject];
//    NSString * action = dic[@"action"];
//    XCTAssertTrue([action isEqualToString:@"name/cos:GetObject"]);
//    
//    [request setFinishBlock:^(QCloudGetFilePreviewResult * _Nullable result, NSError * _Nullable error) {
//        [exp fulfill];
//    }];
//    [[QCloudCOSXMLService defaultCOSXML] GetFilePreviewObject:request];
//    
//    [self waitForExpectationsWithTimeout:100 handler:nil];
//}
//

@end
