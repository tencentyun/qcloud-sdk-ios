//
//  QCloudSTSPolicyTests.m
//  QCloudCOSXMLDemoTests
//
//  Created by karisli(李雪) on 2019/1/3.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "TestCommonDefine.h"

#import <XCTest/XCTest.h>
#import <QCloudCOSXML/QCloudCOSXML.h>

#import "QCloudTestTempVariables.h"
#import "QCloudCOSXMLTestUtility.h"
#define kSTSPolicyServiceKey @"STSPolicyServiceKey"
#define kTestSTSBucket @"9899-1253653367"
#define kTestSTSRegion @"ap-beijing-1"
#define kTestSTSCopyOringeRegion @"ap-beijing-1"
@interface QCloudSTSPolicyTests : XCTestCase<QCloudSignatureProvider>
@property (nonatomic,strong)NSString *region;
@property (nonatomic, strong) NSString* bucket;
@property (nonatomic, strong) NSString* authorizedUIN;
@property (nonatomic, strong) NSString* ownerUIN;
@property (nonatomic, strong) NSString* appID;
@property (nonatomic, strong) NSMutableArray* tempFilePathArray;
@end

@implementation QCloudSTSPolicyTests
//- (void) signatureWithFields:(QCloudSignatureFields*)fileds
//                     request:(QCloudBizHTTPRequest*)request
//                  urlRequest:(NSMutableURLRequest*)urlRequst
//                   compelete:(QCloudHTTPAuthentationContinueBlock)continueBlock
//{
//    //取出参数
//    NSMutableURLRequest *stsrequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://127.0.0.1:3000/sts"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
//    NSMutableArray *array = [NSMutableArray array];
//    NSMutableDictionary *paramas = [NSMutableDictionary dictionary];
//    stsrequest.HTTPMethod = @"POST";
//    [stsrequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [stsrequest setHTTPBody:[NSJSONSerialization dataWithJSONObject:request.scopesArray options:NSJSONWritingPrettyPrinted error:nil]];
//    
//    NSLog(@"stsrequest Body:  %@",[[NSString alloc]initWithData:stsrequest.HTTPBody encoding:NSUTF8StringEncoding]);
//    [[[NSURLSession sharedSession] dataTaskWithRequest:stsrequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        QCloudLogDebug(@"sts responsedata:%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
//        if (data && !error) {
//            id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//            NSDictionary *dic = (NSDictionary *)obj;
//            QCloudCredential* credential = [QCloudCredential new];
//            credential.secretID  = dic[@"credentials"][@"tmpSecretId"];
//            credential.secretKey = dic[@"credentials"][@"tmpSecretKey"];
//            credential.token = (NSString *)dic[@"credentials"][@"sessionToken"];
//            credential.startDate = [NSDate dateWithTimeIntervalSince1970:[dic[@"startTime"] integerValue]];
//            credential.experationDate = [NSDate dateWithTimeIntervalSince1970:[dic[@"expiredTime"]integerValue]];
//            QCloudAuthentationV5Creator* creator = [[QCloudAuthentationV5Creator alloc] initWithCredential:credential];
//            QCloudSignature* signature =  [creator signatureForData:urlRequst];
//            continueBlock(signature, nil);
//        }
//    }] resume];
//}
//- (void)registerSTSPolicyTransferManager {
//    QCloudServiceConfiguration* configuration = [QCloudServiceConfiguration new];
//    configuration.signatureProvider = self;
//    QCloudCOSXMLEndPoint* endpoint = [[QCloudCOSXMLEndPoint alloc] init];
//    endpoint.useHTTPS = YES;
//    configuration.appID = kAppID;
//    endpoint.regionName = kTestSTSRegion;
//    configuration.endpoint = endpoint;
//    [QCloudCOSTransferMangerService registerCOSTransferMangerWithConfiguration:configuration withKey:kSTSPolicyServiceKey];
//    [QCloudCOSXMLService registerCOSXMLWithConfiguration:configuration withKey:kSTSPolicyServiceKey];
//    
//    QCloudServiceConfiguration* configuration1 = [QCloudServiceConfiguration new];
//    configuration1.signatureProvider = self;
//    configuration1.appID = kAppID;
//    QCloudCOSXMLEndPoint* endpoint1 = [[QCloudCOSXMLEndPoint alloc] init];
//    endpoint1.useHTTPS = YES;
//    endpoint1.regionName = @"ap-guangzhou";
//    configuration1.endpoint = endpoint1;
//    [QCloudCOSTransferMangerService registerCOSTransferMangerWithConfiguration:configuration1 withKey:kTestSTSCopyOringeRegion];
//    [QCloudCOSXMLService registerCOSXMLWithConfiguration:configuration1 withKey:kTestSTSCopyOringeRegion];
//}
//
//- (void)setUp {
//    // Put setup code here. This method is called before the invocation of each test method in the class.
//     [super setUp];
//    [self registerSTSPolicyTransferManager];
//     self.tempFilePathArray   = self.tempFilePathArray = [[NSMutableArray alloc] init];
//    self.bucket = [[QCloudCOSXMLTestUtility sharedInstance] createTestBucketWithCosSerVice:[QCloudCOSXMLService cosxmlServiceForKey:kSTSPolicyServiceKey ] withPrefix:@"sts"];
//    self.appID = kAppID;
//    self.authorizedUIN = @"1131975903";
//    self.ownerUIN = @"1278687956";
//    
//}
//
//-(QCloudCOSXMLService *)cosxmlService{
//    return [QCloudCOSXMLService cosxmlServiceForKey:kSTSPolicyServiceKey];
//}
//-(QCloudCOSTransferMangerService *)transferService{
//    return [QCloudCOSTransferMangerService costransfermangerServiceForKey:kSTSPolicyServiceKey];
//}
//#pragma mark - bucket相关
//-(void)testGetBucket{
//    QCloudGetBucketRequest* request = [QCloudGetBucketRequest new];
//    request.bucket = self.bucket;
//    request.maxKeys = 1000;
//    request.prefix = @"0";
//    request.delimiter = @"0";
//    request.encodingType = @"url";
//    
//    request.prefix = request.delimiter = request.encodingType = nil;
//    XCTestExpectation* exp = [self expectationWithDescription:@"delete"];
//    
//    __block QCloudListBucketResult* listResult;
//    [request setFinishBlock:^(QCloudListBucketResult * _Nonnull result, NSError * _Nonnull error) {
//        listResult = result;
//        XCTAssertNil(error);
//        [exp fulfill];
//    }];
//    [[self cosxmlService] GetBucket:request];
//    [self waitForExpectationsWithTimeout:100 handler:nil];
//    
//    XCTAssertNotNil(listResult);
//    NSString* listResultName = listResult.name;
//    NSString* expectListResultName = [NSString stringWithFormat:@"%@",self.bucket];
//    XCTAssert([listResultName isEqualToString:expectListResultName]);
//}
//
//-(void)testPUTBucket{
//    XCTestExpectation* exception = [self expectationWithDescription:@"Delete bucket exception"];
//    __block NSError* responseError ;
//    QCloudPutBucketRequest* putBucketRequest = [[QCloudPutBucketRequest alloc] init];
//    putBucketRequest.bucket = [NSString stringWithFormat:@"bucketcanbedelete%i-%@",arc4random()%1000,kAppID];
//    [putBucketRequest setFinishBlock:^(id outputObject, NSError* error) {
//        XCTAssertNil(error);
//        
//            [exception fulfill];
//    }];
//    [[self cosxmlService] PutBucket:putBucketRequest];
//    [self waitForExpectationsWithTimeout:100 handler:nil];
//    XCTAssertNil(responseError);
//}
//
//-(void)testHeadBucket{
//    QCloudHeadBucketRequest* request = [QCloudHeadBucketRequest new];
//    request.bucket = self.bucket;
//    XCTestExpectation* exp = [self expectationWithDescription:@"putacl"];
//    __block NSError* resultError;
//    [request setFinishBlock:^(id outputObject, NSError* error) {
//        resultError = error;
//        [exp fulfill];
//    }];
//    [[self cosxmlService] HeadBucket:request];
//    [self waitForExpectationsWithTimeout:20 handler:nil];
//    XCTAssertNil(resultError);
//}
//
//-(void)testPut_GET_BucketACL{
//    QCloudPutBucketACLRequest* putACL = [QCloudPutBucketACLRequest new];
//    putACL.runOnService = [QCloudCOSXMLService cosxmlServiceForKey:kSTSPolicyServiceKey];
//    NSString *ownerIdentifier = [NSString stringWithFormat:@"qcs::cam::uin/%@:uin/%@", self.authorizedUIN,self.authorizedUIN];
//    NSString *grantString = [NSString stringWithFormat:@"id=\"%@\"",ownerIdentifier];
//    putACL.grantFullControl = grantString;
//    putACL.grantRead = grantString;
//    putACL.grantWrite = grantString;
//    putACL.bucket = self.bucket;
//    XCTestExpectation* exp = [self expectationWithDescription:@"putacl"];
//    __block NSError* localError;
//    [putACL setFinishBlock:^(id outputObject, NSError *error) {
//        XCTAssertNil(error);
//        QCloudGetBucketACLRequest* getBucketACLRequest = [[QCloudGetBucketACLRequest alloc] init];
//        getBucketACLRequest.bucket = self.bucket;
//        [getBucketACLRequest setFinishBlock:^(QCloudACLPolicy* result, NSError* error) {
//            XCTAssertNil(error);
//            XCTAssertNotNil(result);
//            NSString* ownerIdentifiler = [NSString identifierStringWithID:self.ownerUIN :self.ownerUIN];
//            XCTAssert([result.owner.identifier isEqualToString:ownerIdentifiler],@"result Owner Identifier is%@",result.owner.identifier);
//            [exp fulfill];
//        }];
//        [[self cosxmlService] GetBucketACL:getBucketACLRequest];
//    }];
//    [[self cosxmlService] PutBucketACL:putACL];
//    [self waitForExpectationsWithTimeout:100 handler:nil];
//    XCTAssertNil(localError);
//}
//
//-(void)testPUT_GET_DELETE_BucketCORS{
//    QCloudPutBucketCORSRequest* putCORS = [QCloudPutBucketCORSRequest new];
//    QCloudCORSConfiguration* putCors = [QCloudCORSConfiguration new];
//    
//    QCloudCORSRule* rule = [QCloudCORSRule new];
//    rule.identifier = @"sdk";
//    rule.allowedHeader = @[@"origin",@"accept",@"content-type",@"authorization"];
//    rule.exposeHeader = @"ETag";
//    rule.allowedMethod = @[@"GET",@"PUT",@"POST", @"DELETE", @"HEAD"];
//    rule.maxAgeSeconds = 3600;
//    rule.allowedOrigin = @"*";
//    
//    putCors.rules = @[rule];
//    
//    putCORS.corsConfiguration = putCors;
//    putCORS.bucket = self.bucket;
//    __block NSError* localError1;
//    
//    
//    __block QCloudCORSConfiguration* cors;
//    __block XCTestExpectation* exp = [self expectationWithDescription:@"delete"];
//    
//    
//    [putCORS setFinishBlock:^(id outputObject, NSError *error) {
//        
//        QCloudGetBucketCORSRequest* corsReqeust = [QCloudGetBucketCORSRequest new];
//        corsReqeust.bucket = self.bucket;
//        [corsReqeust setFinishBlock:^(QCloudCORSConfiguration * _Nonnull result, NSError * _Nonnull error) {
//            XCTAssertNil(error);
//            cors = result;
//         
//            QCloudDeleteBucketCORSRequest* deleteCORS = [QCloudDeleteBucketCORSRequest new];
//            deleteCORS.bucket = self.bucket;
//            [deleteCORS setFinishBlock:^(id outputObject, NSError *error) {
//                NSLog(@"deleteCORS outputObject%@",outputObject);
//                XCTAssertNil(error);
//                XCTAssertNotNil(outputObject);
//                [exp fulfill];
//            }];
//            [[self cosxmlService] DeleteBucketCORS:deleteCORS];
//        }];
//        
//        [[self cosxmlService] GetBucketCORS:corsReqeust];
//    }];
//    
//    
//    [[self cosxmlService] PutBucketCORS:putCORS];
//    [self waitForExpectationsWithTimeout:200 handler:^(NSError * _Nullable error) {
//    }];
//    XCTAssertNotNil(cors);
//    XCTAssert([[[cors.rules firstObject] identifier] isEqualToString:@"sdk"]);
//    XCTAssertEqual(1, cors.rules.count);
//    XCTAssertEqual([cors.rules.firstObject.allowedMethod count], 5);
//    XCTAssert([cors.rules.firstObject.allowedMethod containsObject:@"PUT"]);
//    XCTAssert([cors.rules.firstObject.allowedHeader count] == 4);
//    XCTAssert([cors.rules.firstObject.exposeHeader isEqualToString:@"ETag"]);
//}
//
//-(void)testPUT_GET_DELETE_Lifecycle{
//    QCloudPutBucketLifecycleRequest* request = [QCloudPutBucketLifecycleRequest new];
//    request.bucket = self.bucket;
//    __block QCloudLifecycleConfiguration* configuration = [[QCloudLifecycleConfiguration alloc] init];
//    QCloudLifecycleRule* rule = [[QCloudLifecycleRule alloc] init];
//    rule.identifier = @"id1";
//    rule.status = QCloudLifecycleStatueEnabled;
//    QCloudLifecycleRuleFilter* filter = [[QCloudLifecycleRuleFilter alloc] init];
//    filter.prefix = @"0";
//    rule.filter = filter;
//    
//    QCloudLifecycleTransition* transition = [[QCloudLifecycleTransition alloc] init];
//    transition.days = 100;
//    transition.storageClass = QCloudCOSStorageStandardIA;
//    rule.transition = transition;
//    request.lifeCycle = configuration;
//    request.lifeCycle.rules = @[rule];
//    XCTestExpectation* exception = [self expectationWithDescription:@"Put Bucket Life cycle exception"];
//    [request setFinishBlock:^(id outputObject, NSError* putLifecycleError) {
//        XCTAssertNil(putLifecycleError);
//        //Get Configuration
//        XCTAssertNil(putLifecycleError);
//        
//        QCloudGetBucketLifecycleRequest* request = [QCloudGetBucketLifecycleRequest new];
//        request.bucket = self.bucket;
//        [request setFinishBlock:^(QCloudLifecycleConfiguration* getLifecycleReuslt,NSError* getLifeCycleError) {
//            XCTAssertNil(getLifeCycleError);
//            XCTAssertNotNil(getLifecycleReuslt);
//            XCTAssert(getLifecycleReuslt.rules.count==configuration.rules.count);
//            XCTAssert([getLifecycleReuslt.rules.firstObject.identifier isEqualToString:configuration.rules.firstObject.identifier]);
//            XCTAssert(getLifecycleReuslt.rules.firstObject.status==configuration.rules.firstObject.status);
//            
//            //delete configuration
//            QCloudDeleteBucketLifeCycleRequest* request = [[QCloudDeleteBucketLifeCycleRequest alloc ] init];
//            request.bucket = self.bucket;
//            [request setFinishBlock:^(QCloudLifecycleConfiguration* deleteResult, NSError* deleteError) {
//                XCTAssert(deleteResult);
//                XCTAssertNil(deleteError);
//                [exception fulfill];
//            }];
//            [[self cosxmlService] DeleteBucketLifeCycle:request];
//            //delete configuration end
//            
//        }];
//        [[self cosxmlService] GetBucketLifecycle:request];
//        //Get configuration end
//    }];
//    [[self cosxmlService] PutBucketLifecycle:request];
//    [self waitForExpectationsWithTimeout:100 handler:nil];
//}
//
//-(void)testListMutipartUploads{
//    QCloudListBucketMultipartUploadsRequest* uploads = [QCloudListBucketMultipartUploadsRequest new];
//    uploads.bucket = self.bucket;
//    uploads.maxUploads = 1000;
//    __block NSError* localError;
//    __block QCloudListMultipartUploadsResult* multiPartUploadsResult;
//    XCTestExpectation* exp = [self expectationWithDescription:@"putacl"];
//    [uploads setFinishBlock:^(QCloudListMultipartUploadsResult* result, NSError *error) {
//        multiPartUploadsResult = result;
//        localError = error;
//        [exp fulfill];
//    }];
//    [[self cosxmlService] ListBucketMultipartUploads:uploads];
//    [self waitForExpectationsWithTimeout:20 handler:nil];
//    
//    XCTAssertNil(localError);
//    XCTAssert(multiPartUploadsResult.maxUploads==1000);
//    NSString* expectedBucketString = [NSString stringWithFormat:@"%@",self.bucket];
//    XCTAssert([multiPartUploadsResult.bucket isEqualToString:expectedBucketString]);
//    XCTAssert(multiPartUploadsResult.maxUploads == 1000);
//    if (multiPartUploadsResult.uploads.count) {
//        QCloudListMultipartUploadContent* firstContent = [multiPartUploadsResult.uploads firstObject];
//        XCTAssert([firstContent.owner.displayName isEqualToString:@"1278687956"]);
//        XCTAssert([firstContent.initiator.displayName isEqualToString:@"1278687956"]);
//        XCTAssertNotNil(firstContent.uploadID);
//        XCTAssertNotNil(firstContent.key);
//    }
//}
//#pragma mark - object相关
//
//-(void)testSampleUpload{
//    QCloudCOSXMLUploadObjectRequest* put = [QCloudCOSXMLUploadObjectRequest new];
//    NSURL* url = [NSURL fileURLWithPath:[self tempFileWithSize:15*1024]];
//    __block NSString *object = [NSUUID UUID].UUIDString;
//    put.object = object;
//    put.bucket = self.bucket;
//    put.body =  url;
//    [put setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
//        NSLog(@"upload %lld totalSend %lld aim %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
//    }];
//    __block QCloudGetObjectRequest* request = [QCloudGetObjectRequest new];
//    request.downloadingURL = [NSURL URLWithString:QCloudTempFilePathWithExtension(@"downding")];
//    XCTestExpectation* exp = [self expectationWithDescription:@"testMultiUpload upload object expectation"];
//    __block QCloudUploadObjectResult* result;
//    [put setFinishBlock:^(QCloudUploadObjectResult *result, NSError *error) {
//        XCTAssertNotNil(result);
//        XCTAssertNotNil([result location]);
//        request.bucket = self.bucket;
//        request.object = object;
//        request.enableMD5Verification = YES;
//        [request setFinishBlock:^(id outputObject, NSError *error) {
//            QCloudLogInfo(@"outputObject%@",outputObject);
//            XCTAssertNil(error);
//            [exp fulfill];
//        }];
//        [request setDownProcessBlock:^(int64_t bytesDownload, int64_t totalBytesDownload, int64_t totalBytesExpectedToDownload) {
//            NSLog(@"⏬⏬⏬⏬DOWN [Total]%lld  [Downloaded]%lld [Download]%lld", totalBytesExpectedToDownload, totalBytesDownload, bytesDownload);
//        }];
//        [[self cosxmlService] GetObject:request];
//    }];
//    [[self transferService] UploadObject:put];
//    [self waitForExpectationsWithTimeout:100 handler:^(NSError * _Nullable error) {
//    }];
//}
//-(void)testMutiPartUpload{
//    QCloudCOSXMLUploadObjectRequest* put = [QCloudCOSXMLUploadObjectRequest new];
//    int randomNumber = arc4random()%100;
//    NSURL* url = [NSURL fileURLWithPath:[self tempFileWithSize:15*1024*1024 + randomNumber]];
//    __block NSString *object = [NSUUID UUID].UUIDString;
//    put.object = object;
//    put.bucket = self.bucket;
//    put.body =  url;
//    [put setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
//        NSLog(@"upload %lld totalSend %lld aim %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
//    }];
//    __block QCloudGetObjectRequest* request = [QCloudGetObjectRequest new];
//    request.downloadingURL = [NSURL URLWithString:QCloudTempFilePathWithExtension(@"downding")];
//    XCTestExpectation* exp = [self expectationWithDescription:@"testMultiUpload upload object expectation"];
//    __block QCloudUploadObjectResult* result;
//    [put setFinishBlock:^(QCloudUploadObjectResult *result, NSError *error) {
//        XCTAssertNotNil(result);
//        XCTAssertNotNil([result location]);
//        XCTAssertNotNil([result eTag]);
//        request.bucket = self.bucket;
//        request.object = object;
//        request.enableMD5Verification = YES;
//        [request setFinishBlock:^(id outputObject, NSError *error) {
//            QCloudLogInfo(@"outputObject%@",outputObject);
//            XCTAssertNil(error);
//            [exp fulfill];
//        }];
//        [request setDownProcessBlock:^(int64_t bytesDownload, int64_t totalBytesDownload, int64_t totalBytesExpectedToDownload) {
//            NSLog(@"⏬⏬⏬⏬DOWN [Total]%lld  [Downloaded]%lld [Download]%lld", totalBytesExpectedToDownload, totalBytesDownload, bytesDownload);
//        }];
//        [[self cosxmlService] GetObject:request];
//    }];
//    [[self transferService] UploadObject:put];
//    [self waitForExpectationsWithTimeout:18000 handler:^(NSError * _Nullable error) {
//    }];
//}
//
//-(void)testHeadObject{
//    NSString* object = [self uploadTempObject];
//    QCloudHeadObjectRequest* headerRequest = [QCloudHeadObjectRequest new];
//    headerRequest.object = object;
//    headerRequest.bucket = self.bucket;
//    
//    XCTestExpectation* exp = [self expectationWithDescription:@"header"];
//    __block id resultError;
//    [headerRequest setFinishBlock:^(NSDictionary* result, NSError *error) {
//        resultError = error;
//        [exp fulfill];
//    }];
//    
//    [[self cosxmlService] HeadObject:headerRequest];
//    [self waitForExpectationsWithTimeout:80 handler:^(NSError * _Nullable error) {
//        
//    }];
//    XCTAssertNil(resultError);
//}
//
//-(void)testGetObject{
//    QCloudPutObjectRequest* put = [QCloudPutObjectRequest new];
//    NSString* object =  [NSUUID UUID].UUIDString;
//    put.object =object;
//    put.bucket = self.bucket;
//    NSURL* fileURL = [NSURL fileURLWithPath:[self tempFileWithSize:1024*1024*3]];
//    put.body = fileURL;
//    
//    
//    XCTestExpectation* exp = [self expectationWithDescription:@"delete"];
//    __block QCloudGetObjectRequest* request = [QCloudGetObjectRequest new];
//    request.downloadingURL = [NSURL URLWithString:QCloudTempFilePathWithExtension(@"downding")];
//    
//    [put setFinishBlock:^(id outputObject, NSError *error) {
//        request.bucket = self.bucket;
//        request.object = object;
//        
//        [request setFinishBlock:^(id outputObject, NSError *error) {
//            XCTAssertNil(error);
//            [exp fulfill];
//        }];
//        [request setDownProcessBlock:^(int64_t bytesDownload, int64_t totalBytesDownload, int64_t totalBytesExpectedToDownload) {
//            NSLog(@"⏬⏬⏬⏬DOWN [Total]%lld  [Downloaded]%lld [Download]%lld", totalBytesExpectedToDownload, totalBytesDownload, bytesDownload);
//        }];
//        [[self cosxmlService] GetObject:request];
//        
//    }];
//    [[self cosxmlService] PutObject:put];
//    
//    [self waitForExpectationsWithTimeout:80 handler:nil];
//    
//    XCTAssertEqual(QCloudFileSize(request.downloadingURL.path), QCloudFileSize(fileURL.path));
//}
//
//-(void)testPutCopy{
//    NSString* copyObjectSourceName = @"testSampleCopy";
//    QCloudPutObjectRequest* put = [QCloudPutObjectRequest new];
//    put.object = copyObjectSourceName;
//    put.bucket = self.bucket;
//    put.body =  [@"4324ewr325" dataUsingEncoding:NSUTF8StringEncoding];
//    __block XCTestExpectation* exception = [self expectationWithDescription:@"Put Object Copy Exception"];
//    __block NSError* putObjectCopyError;
//    __block NSError* resultError;
//    __block QCloudCopyObjectResult* copyObjectResult;
//    [put setFinishBlock:^(id outputObject, NSError *error) {
//        NSURL* serviceURL = [[self cosxmlService].configuration.endpoint serverURLWithBucket:self.bucket appID:self.appID regionName:kTestSTSRegion];
//        NSMutableString* objectCopySource = [serviceURL.absoluteString mutableCopy] ;
//        [objectCopySource appendFormat:@"/%@",copyObjectSourceName];
//        objectCopySource = [[objectCopySource substringFromIndex:8] mutableCopy];
//        QCloudPutObjectCopyRequest* request = [[QCloudPutObjectCopyRequest alloc] init];
//        request.bucket = self.bucket;
//        request.object = @"copyedObject";
//        request.objectCopySource = objectCopySource;
//        
//        [request setFinishBlock:^(QCloudCopyObjectResult* result, NSError* error) {
//            putObjectCopyError = result;
//            resultError = error;
//            [exception fulfill];
//        }];
//        [[self cosxmlService] PutObjectCopy:request];
//    }];
//    [[self cosxmlService] PutObject:put];
//    [self waitForExpectationsWithTimeout:100 handler:nil];
//    XCTAssertNil(resultError);
//}
//
////-(void)testUploadPartCopy{
////
////    XCTestExpectation* uploadExpectation = [self expectationWithDescription:@"upload temp object"];
////    QCloudCOSXMLUploadObjectRequest* uploadObjectRequest = [[QCloudCOSXMLUploadObjectRequest alloc] init];
////    NSString* tempFileName =  @"test/subtest/30MBTempFile";
////    uploadObjectRequest.bucket = self.bucket;
////    uploadObjectRequest.object = tempFileName;
////    uploadObjectRequest.body = [NSURL fileURLWithPath:[self tempFileWithSize:30*1024*1024]];
////    [uploadObjectRequest setFinishBlock:^(QCloudUploadObjectResult *result, NSError *error) {
////        XCTAssertNil(error,@"error occures on uploading");
////        QCloudCOSXMLCopyObjectRequest* request = [[QCloudCOSXMLCopyObjectRequest alloc] init];
////        
////        request.bucket = [[QCloudCOSXMLTestUtility sharedInstance] createTestBucketWithCosSerVice:[QCloudCOSXMLService cosxmlServiceForKey:kSTSPolicyServiceKey] withPrefix:@"sts"];
////        request.object = @"copy-result-test";
////        request.sourceBucket = self.bucket;
////        request.sourceObject = tempFileName;
////        request.sourceAPPID = [self cosxmlService].configuration.appID;
////        request.sourceRegion= [self cosxmlService].configuration.endpoint.regionName;
////        [request setFinishBlock:^(QCloudCopyObjectResult* result, NSError* error) {
////            XCTAssertNil(error);
////            [uploadExpectation fulfill];
////        }];
////        [[self transferService] CopyObject:request];
////    }];
////    [[self transferService] UploadObject:uploadObjectRequest];
////    [self waitForExpectationsWithTimeout:10000 handler:nil];
////}
//
//-(void)testPUT_GET_ObjectACL{
//    QCloudPutObjectACLRequest* request = [QCloudPutObjectACLRequest new];
//    request.object = [self uploadTempObject];
//    request.bucket = self.bucket;
//    NSString *ownerIdentifier = [NSString stringWithFormat:@"qcs::cam::uin/%@:uin/%@",self.authorizedUIN, self.authorizedUIN];
//    NSString *grantString = [NSString stringWithFormat:@"id=\"%@\"",ownerIdentifier];
//    request.grantFullControl = grantString;
//    XCTestExpectation* exp = [self expectationWithDescription:@"acl"];
//    __block NSError* localError;
//    [request setFinishBlock:^(id outputObject, NSError *error) {
//        XCTAssertNil(error);
//       ;
//        QCloudGetObjectACLRequest* getRequest = [QCloudGetObjectACLRequest new];
//        getRequest.bucket = self.bucket; //存储桶名称(cos v5 的 bucket格式为：xxx-appid, 如 test-1253960454)
//        getRequest.object = request.object;
//        [getRequest setFinishBlock:^(QCloudACLPolicy * _Nonnull policy, NSError * _Nonnull error) {
//            //从 QCloudACLPolicy 对象中获取封装好的 ACL 的具体信息
//            [exp fulfill];
//        }];
//        [[self cosxmlService] GetObjectACL:getRequest];
//    }];
//    
//    [[self cosxmlService] PutObjectACL:request];
//    [self waitForExpectationsWithTimeout:1000 handler:nil];
//    
//}
//
//
////-(void)testSampleCopy{
////    NSString *bucket = [[QCloudCOSXMLTestUtility sharedInstance] createTestBucketWithCosSerVice:[QCloudCOSXMLService cosxmlServiceForKey:kSTSPolicyServiceKey] withPrefix:@"sts"];
////    XCTestExpectation* uploadExpectation = [self expectationWithDescription:@"upload temp object"];
////    QCloudCOSXMLUploadObjectRequest* uploadObjectRequest = [[QCloudCOSXMLUploadObjectRequest alloc] init];
////    NSString* tempFileName =  @"test/subtest/1MBTpFile";
////    uploadObjectRequest.bucket = self.bucket;
////    uploadObjectRequest.object = tempFileName;
////    uploadObjectRequest.body = [NSURL fileURLWithPath:[self tempFileWithSize:1*1024*1024]];
////    [uploadObjectRequest setFinishBlock:^(QCloudUploadObjectResult *result, NSError *error) {
////        XCTAssertNotNil(result);
////        XCTAssertNil(error);
////        QCloudCOSXMLCopyObjectRequest* request = [[QCloudCOSXMLCopyObjectRequest alloc] init];
////        request.bucket = bucket;
////        request.object = @"copy-result-sts";
////        request.sourceBucket = self.bucket;
////        request.sourceObject = tempFileName;
////        request.sourceAPPID = [self cosxmlService].configuration.appID;
////        request.sourceRegion= [self cosxmlService].configuration.endpoint.regionName;
////        
////        [request setFinishBlock:^(QCloudCopyObjectResult* result, NSError* error) {
////            XCTAssertNil(error);
////            [uploadExpectation fulfill];
////        }];
////        [[self transferService] CopyObject:request];
////    }];
////    [[self transferService] UploadObject:uploadObjectRequest];
////   
////    [self waitForExpectationsWithTimeout:100 handler:nil];
////}
//
//
//
//-(void)testPostObjectRestore{
//    
//}
//
//-(void)testDeleteObject{
//    
//    NSString* object = [self uploadTempObject];
//    QCloudDeleteObjectRequest* deleteObjectRequest = [QCloudDeleteObjectRequest new];
//    deleteObjectRequest.bucket = self.bucket;
//    deleteObjectRequest.object = object;
//    
//    XCTestExpectation* exp = [self expectationWithDescription:@"delete"];
//    
//    __block NSError* localError;
//    [deleteObjectRequest setFinishBlock:^(id outputObject, NSError *error) {
//        localError = error;
//        [exp fulfill];
//    }];
//    [[self cosxmlService] DeleteObject:deleteObjectRequest];
//    
//    [self waitForExpectationsWithTimeout:80 handler:^(NSError * _Nullable error) {
//        
//    }];
//    
//    XCTAssertNil(localError);
//}
//
//-(void)testDeleteMultipleObjects{
//    NSString* object1 = [self uploadTempObject];
//    NSString* object2 = [self uploadTempObject];
//    
//    QCloudDeleteMultipleObjectRequest* delteRequest = [QCloudDeleteMultipleObjectRequest new];
//    delteRequest.bucket = self.bucket;
//
//    QCloudDeleteObjectInfo* object = [QCloudDeleteObjectInfo new];
//    object.key = object1;
//
//    QCloudDeleteObjectInfo* deleteObject2 = [QCloudDeleteObjectInfo new];
//    deleteObject2.key = object2;
//
//    QCloudDeleteInfo* deleteInfo = [QCloudDeleteInfo new];
//    deleteInfo.quiet = NO;
//    deleteInfo.objects = @[ object,deleteObject2];
//
//    delteRequest.deleteObjects = deleteInfo;
//    XCTestExpectation* exp = [self expectationWithDescription:@"delete"];
//
//    __block NSError* localError;
//    __block QCloudDeleteResult* deleteResult = nil;
//    [delteRequest setFinishBlock:^(QCloudDeleteResult* outputObject, NSError *error) {
//        localError = error;
//        deleteResult = outputObject;
//        [exp fulfill];
//    }];
//
//
//    [[self cosxmlService] DeleteMultipleObject:delteRequest];
//
//    [self waitForExpectationsWithTimeout:80 handler:^(NSError * _Nullable error) {
//
//    }];
//
//    XCTAssertNotNil(deleteResult);
//    XCTAssertEqual(2, deleteResult.deletedObjects.count);
//    QCloudDeleteResultRow* firstrow =  deleteResult.deletedObjects[0];
//    QCloudDeleteResultRow* secondRow = deleteResult.deletedObjects[1];
//    XCTAssert([firstrow.key isEqualToString:object1]);
//    XCTAssert([secondRow.key isEqualToString:object2]);
//    XCTAssertNil(localError);
//}
//
//
//-(void)testUploadPartCopyFromAnotherRegion{
//    
//    
//    XCTestExpectation* uploadExpectation = [self expectationWithDescription:@"upload temp object"];
//    QCloudCOSXMLUploadObjectRequest* uploadObjectRequest = [[QCloudCOSXMLUploadObjectRequest alloc] init];
//    NSString* tempFileName =  @"test/subtest/20MBTempFile";
//    uploadObjectRequest.bucket = [[QCloudCOSXMLTestUtility sharedInstance] createTestBucketWithCosSerVice:[QCloudCOSXMLService cosxmlServiceForKey:kTestSTSCopyOringeRegion] withPrefix:@"sts"];
//    uploadObjectRequest.object = tempFileName;
//    uploadObjectRequest.body = [NSURL fileURLWithPath:[self tempFileWithSize:20*1024*1024]];
//    [uploadObjectRequest setFinishBlock:^(QCloudUploadObjectResult *result, NSError *error) {
//        XCTAssertNil(error,@"error occures on uploading");
//        QCloudCOSXMLCopyObjectRequest* request = [[QCloudCOSXMLCopyObjectRequest alloc] init];
//        request.bucket = self.bucket;
//        request.object = @"copy-result-test-sts";
//        request.sourceBucket =  uploadObjectRequest.bucket;
//        request.sourceObject = tempFileName;
//        request.sourceAPPID = kAppID;
//        request.sourceRegion= kRegion;
//        [request setFinishBlock:^(QCloudCopyObjectResult* result, NSError* error) {
//            XCTAssertNil(error);
//            [uploadExpectation fulfill];
//        }];
//        
//        [ [self transferService]CopyObject:request];
//    }];
//    [[QCloudCOSTransferMangerService costransfermangerServiceForKey:kTestSTSCopyOringeRegion] UploadObject:uploadObjectRequest];
//    
//   
//    [self waitForExpectationsWithTimeout:10000 handler:nil];
//}
//
//
//- (NSString*) uploadTempObject
//{
//    QCloudPutObjectRequest* put = [QCloudPutObjectRequest new];
//    put.object = [NSUUID UUID].UUIDString;
//    put.bucket = self.bucket;
//    put.body =  [@"1234jdjdjdjjdjdjyuehjshgdytfakjhsghgdhg" dataUsingEncoding:NSUTF8StringEncoding];
//    
//    XCTestExpectation* exp = [self expectationWithDescription:@"delete"];
//    
//    [put setFinishBlock:^(id outputObject, NSError *error) {
//        [exp fulfill];
//    }];
//    [[self cosxmlService] PutObject:put];
//    
//    [self waitForExpectationsWithTimeout:80 handler:^(NSError * _Nullable error) {
//        
//    }];
//    return put.object;
//}
//- (NSString*) tempFileWithSize:(int)size
//{
//    NSString* file4MBPath = QCloudPathJoin(QCloudTempDir(), [NSUUID UUID].UUIDString);
//    
//    if (!QCloudFileExist(file4MBPath)) {
//        [[NSFileManager defaultManager] createFileAtPath:file4MBPath contents:[NSData data] attributes:nil];
//    }
//    NSFileHandle* handler = [NSFileHandle fileHandleForWritingAtPath:file4MBPath];
//    [handler truncateFileAtOffset:size];
//    [handler closeFile];
//    [self.tempFilePathArray  addObject:file4MBPath];
//    
//    return file4MBPath;
//}
//
//
//+ (void)tearDown {
//    [[QCloudCOSXMLTestUtility sharedInstance] deleteAllTestBuckets];
//}

@end
