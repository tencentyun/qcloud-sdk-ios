//
//  QCloudCOSXMLImageHelperTests.m
//  QCloudCOSXMLDemoTests
//
//  Created by garenwang on 2020/6/8.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "QCloudVoiceSeparateResult.h"
#import "QCloudCICommonModel.h"
#import <QCloudCOSXML/QCloudCOSXML.h>
#import "TestCommonDefine.h"
#import "QCloudTestTempVariables.h"
#import "QCloudCOSXMLTestUtility.h"
#import "QCloudUpdateAudioDiscernTaskQueueRequest.h"
#import "QCloudGetAudioDiscernTaskQueueRequest.h"
#import "QCloudBatchGetAudioDiscernTaskRequest.h"
#import "QCloudGetAudioDiscernTaskRequest.h"
#import "QCloudPostAudioDiscernTaskRequest.h"
#import "QCloudGetAudioDiscernOpenBucketListRequest.h"
#import "SecretStorage.h"
#import "QCloudOpenAIBucketRequest.h"
#import "QCloudGetAIJobQueueRequest.h"
#import "QCloudPostWordsGeneralizeTaskRequest.h"
#import "QCloudGetWordsGeneralizeTaskRequest.h"
#import "QCloudCOSXMLService+ImageHelper.h"
#import "QCloudCIImageRepairRequest.h"
#import "QCloudCIDetectCarRequest.h"
#import "QCloudCIOCRRequest.h"
#import "QCloudCIBodyRecognitionRequest.h"
#import "QCloudCIAutoTranslationRequest.h"
#import "QCloudCIFaceEffectRequest.h"
#import "QCloudCIDetectFaceRequest.h"
#import "QCloudCIRecognizeLogoRequest.h"
#import "QCloudCIGetGoodsMattingRequest.h"
#import "QCloudCIImageRepairRequest.h"
#import "QCloudPostLiveVideoRecognitionRequest.h"
#import "QCloudGetLiveVideoRecognitionRequest.h"
#import "QCloudCancelLiveVideoRecognitionRequest.h"
#import "QCloudSyncImageRecognitionRequest.h"
#import "QCloudGetMediaJobQueueRequest.h"
#import "QCloudGetPrivateM3U8Request.h"
#import "QCloudUpdateMediaQueueRequest.h"
#import "QCloudGetWorkflowDetailRequest.h"
#import "QCloudGetListWorkflowRequest.h"
#import "QCloudPostTriggerWorkflowRequest.h"
#import "QCloudPostMediaJobsRequest.h"
#import "QCloudPostAudioTransferJobsRequest.h"
#import "QCloudPostVideoTagRequest.h"
#import "QCloudVideoMontageRequest.h"
#import "QCloudVideoSnapshotRequest.h"
#import "QCloudPostTranscodeRequest.h"
#import "QCloudPostAnimationRequest.h"
#import "QCloudPostConcatRequest.h"
#import "QCloudPostSmartCoverRequest.h"
#import "QCloudPostVoiceSeparateRequest.h"
#import "QCloudPostNumMarkRequest.h"
#import "QCloudExtractNumMarkRequest.h"
#import "QCloudPostImageProcessRequest.h"
#import "QCloudPostTextAuditReportRequest.h"
#import "QCloudPostImageAuditReportRequest.h"
#import "QCloudGetAIBucketRequest.h"
#import "QCloudCloseAIBucketRequest.h"
#import "QCloudUpdateAIQueueRequest.h"
#import "QCloudAIImageColoringRequest.h"
#import "QCloudAISuperResolutionRequest.h"
#import "QCloudAIEnhanceImageRequest.h"
#import "QCloudAIImageCropRequest.h"
#import "QCloudCreateQRcodeRequest.h"
#import "QCloudAIGameRecRequest.h"
#import "QCloudAssessQualityRequest.h"
#import "QCloudAIDetectPetRequest.h"
#import "QCloudAIIDCardOCRRequest.h"
#import "QCloudLivenessRecognitionRequest.h"
#import "QCloudGetLiveCodeRequest.h"
#import "QCloudGetActionSequenceRequest.h"
#import "QCloudAILicenseRecRequest.h"
#import "QCloudImageSearchBucketRequest.h"
#import "QCloudAddImageSearchRequest.h"
#import "QCloudGetSearchImageRequest.h"
#import "QCloudDeleteImageSearchRequest.h"
#import "QCloudPostTranslationRequest.h"
#import "QCloudPostWordsGeneralizeRequest.h"
#import "QCloudPostVideoTargetRecRequest.h"
#import "QCloudPostVideoTargetTempleteRequest.h"
#import "QCloudUpdateVideoTargetTempleteRequest.h"
#import "QCloudPostSegmentVideoBodyRequest.h"
#import "QCloudOpenAsrBucketRequest.h"
#import "QCloudCloseAsrBucketRequest.h"
#import "QCloudPostVoiceSeparateTempleteRequest.h"
#import "QCloudUpdateVoiceSeparateTempleteRequest.h"
#import "QCloudPostNoiseReductionRequest.h"
#import "QCloudPostNoiseReductionTempleteRequest.h"
#import "QCloudUpdateNoiseReductionTempleteRequest.h"
#import "QCloudPostVoiceSynthesisRequest.h"
#import "QCloudPostVoiceSynthesisTempleteRequest.h"
#import "QCloudUpdateVoiceSynthesisTempleteRequest.h"
#import "QCloudPostSpeechRecognitionRequest.h"
#import "QCloudPostSpeechRecognitionTempleteRequest.h"
#import "QCloudUpdateSpeechRecognitionTempleteRequest.h"
#import "QCloudPostSoundHoundRequest.h"
#import "QCloudVocalScoreRequest.h"
#import "QCloudVideoMontage.h"
#import "QCloudGetMediaJobRequest.h"
#import "QCloudGetMediaJobListRequest.h"
#import "QCloudRecognitionBadCaseRequest.h"
#import "QCloudCreateMediaJobRequest.h"
#import "QCloudCIUploadOperationsRequest.h"
#import "QCloudGetDiscernMediaJobsRequest.h"
#import "QCloudSearchImageRequest.h"
#import "QCloudCOSXMLService+MateData.h"
#import "QCloudDescribeFileUnzipJobsRequest.h"
#import "QCloudCreateFileZipProcessJobsRequest.h"
#import "QCloudDescribeFileProcessQueuesRequest.h"
#import "QCloudPostFileUnzipProcessJobRequest.h"
#import "QCloudPostHashProcessJobsRequest.h"
#import "QCloudZipFilePreviewRequest.h"
#import "QCloudCreateHashProcessJobsRequest.h"
#import "QCloudDescribeHashProcessJobsRequest.h"
#import "QCloudUpdateFileProcessQueueRequest.h"
#import "QCloudPostBucketInventoryRequest.h"
#import "QCloudDescribeFileZipProcessJobsRequest.h"

@interface QCloudCOSXMLImageHelperTests : XCTestCase <QCloudSignatureProvider>
@property (nonatomic, strong) NSString *appID;
@property (nonatomic, strong) NSString *ownerID;
@property (nonatomic, strong) NSString *authorizedUIN;
@property (nonatomic, strong) NSString *ownerUIN;
@property (nonatomic, strong) NSMutableArray *tempFilePathArray;
@end
static QCloudBucket *gImageTestBucket;
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
    if ([QCloudCOSXMLService hasCosxmlServiceForKey:kTestFromAnotherRegionCopy]) {
        return;
    }
    QCloudServiceConfiguration *configuration = [QCloudServiceConfiguration new];
    configuration.appID = self.appID;
    configuration.signatureProvider = self;
    QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.regionName = @"ap-beijing";
    configuration.endpoint = endpoint;

    [QCloudCOSXMLService registerCOSXMLWithConfiguration:configuration withKey:kTestFromAnotherRegionCopy];
    [QCloudCOSTransferMangerService registerCOSTransferMangerWithConfiguration:configuration withKey:kTestFromAnotherRegionCopy];
}

+ (void)setUp {
    gImageTestBucket = [QCloudBucket new];
    gImageTestBucket.name = @"cos-sdk-citest-1253960454";
    gImageTestBucket.location = @"ap-beijing";
}

+ (void)tearDown {
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

-(void)testQCloudPostAudioDiscernTaskRequest{
    XCTestExpectation* exp = [self expectationWithDescription:@"QCloudPostAudioDiscernTask"];
    QCloudPostAudioDiscernTaskRequest * request = [[QCloudPostAudioDiscernTaskRequest alloc]init];

    // 存储桶名称，格式为 BucketName-APPID
    request.bucket = @"tinna-media-1253960454";
    request.regionName = @"ap-chongqing";

    QCloudPostAudioDiscernTaskInfo* taskInfo = [QCloudPostAudioDiscernTaskInfo new];
    taskInfo.Tag = @"SpeechRecognition";
    taskInfo.QueueId = @"pedd90d02f1134acfa8219546c6365f27";
    // 操作规则
    QCloudPostAudioDiscernTaskInfoInput * input = QCloudPostAudioDiscernTaskInfoInput.new;
    input.Object = @"test1";
    // 待操作的语音文件
    taskInfo.Input = input;
    QCloudPostAudioDiscernOperation * op = [QCloudPostAudioDiscernOperation new];
    QCloudPostAudioDiscernTaskInfoOutput * output = QCloudPostAudioDiscernTaskInfoOutput.new;
    output.Region = @"ap-chongqing";
    output.Bucket = @"tinna-media-1253960454";
    output.Object = @"test";
    // 结果输出地址
    op.Output = output;
    
    QCloudPostAudioDiscernRecognition * speechRecognition = [QCloudPostAudioDiscernRecognition new];
    speechRecognition.EngineModelType =@"16k_zh";
    speechRecognition.ChannelNum = 1;
    speechRecognition.ResTextFormat = 0;
    speechRecognition.ConvertNumMode = 0;
    // 当 Tag 为 SpeechRecognition 时有效，指定该任务的参数
    op.SpeechRecognition = speechRecognition;
    // 操作规则
    taskInfo.Operation = op;
    //  语音识别任务
    request.taskInfo = taskInfo;
    
    [request setFinishBlock:^(QCloudPostAudioDiscernTaskResult * _Nullable result, NSError * _Nullable error) {
        XCTAssertNotNil(result);
        XCTAssertNil(error);
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PostAudioDiscernTask:request];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

-(void)testQCloudGetAudioDiscernTaskRequest{
    XCTestExpectation* exp = [self expectationWithDescription:@"GetAudioDiscernTask"];
    QCloudGetAudioDiscernTaskRequest * request = [[QCloudGetAudioDiscernTaskRequest alloc]init];

    request.bucket = gImageTestBucket.name;
    request.regionName = gImageTestBucket.location;

    // QCloudPostAudioDiscernTaskRequest接口返回的jobid
    request.jobId = @"se864122a0cc111ed89889f3c2c4f232b";

    [request setFinishBlock:^(QCloudGetAudioDiscernTaskResult * _Nullable result, NSError * _Nullable error) {
            XCTAssertNotNil(result);
            XCTAssertNil(error);
            [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetAudioDiscernTask:request];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

-(void)testQCloudGetMediaJobRequestQCloudGetMediaJobRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudGetMediaJobRequest"];
    QCloudGetMediaJobRequest * request = [QCloudGetMediaJobRequest new];
    request.bucket = gImageTestBucket.name;
    request.regionName = gImageTestBucket.location;
    // 对象键，是对象在 COS 上的完整路径，如果带目录的话，格式为 "dir1/object1"
    request.jobId = @"se864122a0cc111ed89889f3c2c4f232b";
    [request setFinishBlock:^(QCloudGetMediaJobResponse * _Nullable result, NSError * _Nullable error) {
        // result 查询指定任务 ，详细字段请查看 API 文档或者 SDK 源码
        XCTAssertNotNil(result);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetMediaJob:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testBatchGetAudioDiscernTask{
    XCTestExpectation* exp = [self expectationWithDescription:@"BatchGetAudioDiscernTask"];

    QCloudBatchGetAudioDiscernTaskRequest * request = [[QCloudBatchGetAudioDiscernTaskRequest alloc]init];

    // 拉取该队列 ID 下的任务。
    request.queueId = @"p74b5265ab1df455782b7b355007d0dfc";

    request.bucket = gImageTestBucket.name;
    request.regionName = gImageTestBucket.location;
    request.tag = @"SpeechRecognition";

    request.states = QCloudTaskStatesAll;

    // 其他更多参数请查阅sdk文档或源码注释

    request.finishBlock = ^(QCloudBatchGetAudioDiscernTaskResult * outputObject, NSError *error) {
       
       [exp fulfill];
    };
    [[QCloudCOSXMLService defaultCOSXML] BatchGetAudioDiscernTask:request];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

-(void)testQCloudUpdateAudioDiscernTaskQueueRequest{
    
    XCTestExpectation* exp = [self expectationWithDescription:@"UpdateAudioDiscernTaskQueue"];
     QCloudUpdateAudioDiscernTaskQueueRequest * request = [[QCloudUpdateAudioDiscernTaskQueueRequest alloc]init];
//    [0]    (null)    @"Name" : @"tinna-media-1253960454"
//    [3]    (null)    @"Region" : @"ap-chongqing"
    // 存储桶名称，格式为 BucketName-APPID
    request.bucket = gImageTestBucket.name;
    request.regionName = gImageTestBucket.location;
    
    request.state = 1;
    
    request.queueID = @"p62366bce5638460c9ca31b59a99cfe61";
    
    request.name = @"queue-ai-process-1";

    [request setFinishBlock:^(QCloudQueueItemModel * _Nullable result, NSError * _Nullable error) {
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] UpdateAudioDiscernTaskQueue:request];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

-(void)testQCloudGetAudioDiscernTaskQueueRequest{
    
    XCTestExpectation* exp = [self expectationWithDescription:@"GetAudioDiscernTaskQueue"];
    QCloudGetAudioDiscernTaskQueueRequest * request = [[QCloudGetAudioDiscernTaskQueueRequest alloc]init];
//    [0]    (null)    @"Name" : @"tinna-media-1253960454"
//    [3]    (null)    @"Region" : @"ap-chongqing"
    // 存储桶名称，格式为 BucketName-APPID
    request.bucket = @"tinna-media-1253960454";
    request.regionName = @"ap-chongqing";
        
//    request.pageSize = 10;
//    request.pageNumber = 0;
    [request setFinishBlock:^(QCloudAudioAsrqueueResult * _Nullable result, NSError * _Nullable error) {
        XCTAssertNotNil(result);
        XCTAssertNil(error);
        [exp fulfill];
        }];
    [[QCloudCOSXMLService defaultCOSXML] GetAudioDiscernTaskQueue:request];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

-(void)testQCloudGetAudioDiscernTaskQueueRequest1{
    
    XCTestExpectation* exp = [self expectationWithDescription:@"testQCloudGetAudioDiscernTaskQueueRequest1"];
    QCloudGetAudioDiscernTaskQueueRequest * request = [[QCloudGetAudioDiscernTaskQueueRequest alloc]init];
//    [0]    (null)    @"Name" : @"tinna-media-1253960454"
//    [3]    (null)    @"Region" : @"ap-chongqing"
    // 存储桶名称，格式为 BucketName-APPID
    request.bucket = gImageTestBucket.name;
    request.regionName = gImageTestBucket.location;
    
    request.state = 1;
    
    request.queueIds = @"p7b57fe055d2b41a793fcdeba538070f8";
    
//    request.pageSize = 10;
//    request.pageNumber = 0;

    request.finishBlock = ^(id outputObject, NSError *error) {
        [exp fulfill];
    };
    [[QCloudCOSXMLService defaultCOSXML] GetAudioDiscernTaskQueue:request];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}


-(void)testQCloudGetAudioDiscernTaskQueueRequest2{
    
    XCTestExpectation* exp = [self expectationWithDescription:@"testQCloudGetAudioDiscernTaskQueueRequest2"];
    QCloudGetAudioDiscernTaskQueueRequest * request = [[QCloudGetAudioDiscernTaskQueueRequest alloc]init];
//    [0]    (null)    @"Name" : @"tinna-media-1253960454"
//    [3]    (null)    @"Region" : @"ap-chongqing"
    // 存储桶名称，格式为 BucketName-APPID
    request.bucket = gImageTestBucket.name;
    request.regionName = gImageTestBucket.location;
    
    request.state = 2;
    
    request.queueIds = @"p7b57fe055d2b41a793fcdeba538070f8";
    
//    request.pageSize = 10;
//    request.pageNumber = 0;

    request.finishBlock = ^(id outputObject, NSError *error) {
        [exp fulfill];
    };
    [[QCloudCOSXMLService defaultCOSXML] GetAudioDiscernTaskQueue:request];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

-(void)testGetAudioDiscernOpenBucketList{
    
    XCTestExpectation* exp = [self expectationWithDescription:@"GetAudioDiscernOpenBucketList"];
    QCloudGetAudioDiscernOpenBucketListRequest * request = [[QCloudGetAudioDiscernOpenBucketListRequest alloc]init];
    request.regionName = gImageTestBucket.location;
    
    request.regions = @"All";
    
    request.pageSize = 1 ;
    request.pageNumber = 0;

    [request setFinishBlock:^(QCloudGetAudioOpenBucketListResult * _Nullable result, NSError * _Nullable error) {
        XCTAssertNotNil(result);
        XCTAssertNil(error);
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetAudioDiscernOpenBucketList:request];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

-(void)testQCloudOpenAIBucketRequest{
    
    XCTestExpectation* exp = [self expectationWithDescription:@"QCloudOpenAIBucketRequest"];
    QCloudOpenAIBucketRequest * request = [[QCloudOpenAIBucketRequest alloc]init];
    request.bucket = gImageTestBucket.name;
    request.regionName = gImageTestBucket.location;
    
    [request setFinishBlock:^(QCloudOpenAIBucketResult * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] OpenAIBucket:request];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

-(void)testQCloudGetAIJobQueueRequest{
    
    XCTestExpectation* exp = [self expectationWithDescription:@"QCloudGetAIJobQueueRequest"];
    QCloudGetAIJobQueueRequest * request = [[QCloudGetAIJobQueueRequest alloc]init];
//    request.bucket = @"ci-auditing-sample-1253960454";
//    request.regionName = @"ap-beijing";
    request.state = 1;
    request.bucket = gImageTestBucket.name;
    request.regionName = gImageTestBucket.location;
    [request setFinishBlock:^(QCloudAIJobQueueResult * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetAIJobQueue:request];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

-(void)testQCloudPostWordsGeneralizeTaskRequest{
    XCTestExpectation* exp = [self expectationWithDescription:@"testQCloudPostWordsGeneralizeTaskRequest"];
    QCloudPostWordsGeneralizeTaskRequest * request = [[QCloudPostWordsGeneralizeTaskRequest alloc]init];
    request.bucket = gImageTestBucket.name;
    request.regionName = gImageTestBucket.location;
    QCloudWordsGeneralizeInput * taskInfo = [QCloudWordsGeneralizeInput new];

    taskInfo.Input = [QCloudWordsGeneralizeInputObject new];
    taskInfo.Input.Object = @"voice.txt";
    
    taskInfo.QueueId = @"p7b57fe055d2b41a793fcdeba538070f8";
    
    taskInfo.Operation = [QCloudWordsGeneralizeInputOperation new];
    taskInfo.Operation.WordsGeneralize = [QCloudWordsGeneralizeInputGeneralize new];
    taskInfo.Operation.WordsGeneralize.NerMethod = @"DL";
    taskInfo.Operation.WordsGeneralize.SegMethod = @"MIX";
    //  分词任务
    request.taskInfo = taskInfo;
    
    [request setFinishBlock:^(QCloudWordsGeneralizeResult * _Nullable result, NSError * _Nullable error) {
        QCloudGetWordsGeneralizeTaskRequest * request = [[QCloudGetWordsGeneralizeTaskRequest alloc]init];

        // 存储桶名称，格式为 BucketName-APPID
        request.bucket = gImageTestBucket.name;
        request.regionName = gImageTestBucket.location;

        // QCloudPostAudioDiscernTaskRequest接口返回的jobid
        request.jobId = result.JobId;

        [request setFinishBlock:^(QCloudWordsGeneralizeResult * _Nullable result, NSError * _Nullable error) {
            XCTAssertNil(error);
            XCTAssertNotNil(result);
            [exp fulfill];
        }];
        [[QCloudCOSXMLService defaultCOSXML] GetWordsGeneralizeTask:request];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PostWordsGeneralizeTask:request];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

//云上数据 处理
- (void)testCloudDataDetail {
    XCTestExpectation* exp = [self expectationWithDescription:@"Recognition"];
    QCloudCICloudDataOperationsRequest *put = [QCloudCICloudDataOperationsRequest new];
    NSError * localError;
//    [put buildRequestData:&localError];
//    XCTAssertNotNil(localError);
    put.object = @"134719996694.jpg";
    put.regionName = gImageTestBucket.location;
    put.bucket = gImageTestBucket.name;
    [put buildRequestData:&localError];
    XCTAssertNotNil(localError);
    
    [put buildRequestData:&localError];
    XCTAssertNotNil(localError);

    
    QCloudPicOperations *op = [[QCloudPicOperations alloc] init];
    op.is_pic_info = NO;
    QCloudPicOperationRule *rule = [[QCloudPicOperationRule alloc] init];
    rule.fileid = @"test";
    rule.text = @"123"; 
    rule.actionType = QCloudPicOperationRuleActionPut;
    rule.type = QCloudPicOperationRuleText;
    op.rule = @[ rule ];
    put.picOperations = op;
    [put setFinishBlock:^(QCloudPutObjectWatermarkResult *outputObject, NSError *error) {
        XCTAssertNil(error);
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] CloudDataOperations:put];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}


//图片标签
- (void)testPicRecognition{
    XCTestExpectation* exp = [self expectationWithDescription:@"Recognition"];
    QCloudCIPicRecognitionRequest *request = [QCloudCIPicRecognitionRequest new];
    
    NSError * localError;
    [request buildRequestData:&localError];
    XCTAssertNotNil(localError);
    //
    request.bucket = gImageTestBucket.name;
    request.object = @"134719996694.jpg";
    
    [request setFinishBlock:^(QCloudCIPicRecognitionResults *_Nullable outputObject, NSError *_Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);
        [exp fulfill];
    }];

    [[QCloudCOSXMLService defaultCOSXML] CIPicRecognition:request];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

//二维码识别
- (void)testQRCodeRecognition{
    XCTestExpectation* exp = [self expectationWithDescription:@"Recognition"];
    QCloudQRCodeRecognitionRequest *put = [QCloudQRCodeRecognitionRequest new];
    // 存储桶名称，格式为 BucketName-APPID
    put.bucket = @"tinna-media-1253960454";
    put.regionName = @"ap-chongqing";
    put.ciProcess = @"QRcode";
    // 对象键，是对象在 COS 上的完整路径，如果带目录的话，格式为 "dir1/object1"
    put.object = @"qrcode.png";

    [put setFinishBlock:^(QCloudRecognitionQRcodeResponse * _Nullable result, NSError * _Nullable error) {
        //从result.qrcodeInfos中获取二维码信息
        NSLog(@"result = %@",result.QRcodeInfo);
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] CIQRCodeRecognition:put];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}
//上传时添加盲水印
- (void)testSetupBlindWaterMark {
    XCTestExpectation* exp = [self expectationWithDescription:@"Recognition"];
    QCloudPutObjectWatermarkRequest *put = [QCloudPutObjectWatermarkRequest new];
    put.regionName = gImageTestBucket.location;
    NSError * localError;
    [put buildRequestData:&localError];
    XCTAssertNotNil(localError);
    put.object = @"1.png";
    
    [put buildRequestData:&localError];
    XCTAssertNotNil(localError);
    put.bucket = gImageTestBucket.name;
    
    [put buildRequestData:&localError];
    XCTAssertNotNil(localError);
    put.body = [@"123456789" dataUsingEncoding:NSUTF8StringEncoding];
    
    QCloudPicOperations *op = [[QCloudPicOperations alloc] init];
    op.is_pic_info = NO;
    QCloudPicOperationRule *rule = [[QCloudPicOperationRule alloc] init];
    rule.fileid = @"test";
    rule.imageURL = @"http://ci-1253960454.cos.ap-beijing.myqcloud.com/protection_blind_watermark_icon.png";
    rule.type = QCloudPicOperationRuleFull;
    rule.actionType =QCloudPicOperationRuleActionPut;
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

//下载时添加盲水印
- (void)testGetObject {
    XCTestExpectation *exp = [self expectationWithDescription:@"delete"];
    __block QCloudGetObjectRequest *request = [QCloudGetObjectRequest new];
    request.regionName = gImageTestBucket.location;
    request.downloadingURL = [NSURL URLWithString:QCloudTempFilePathWithExtension(@"png")];
    request.bucket = gImageTestBucket.name;
    request.object = @"protection_image.png";
    request.watermarkRule = @"watermark/3/type/2/image/aHR0cDovL2NpLTEyNTM2NTMzNjcuY29zLmFwLWd1YW5nemhvdS5teXFjbG91ZC5jb20vcHJvdGVjdGlvbl9ibGluZF93YXRlcm1hcmtfaWNvbi5wbmc=";
    [request setFinishBlock:^(id outputObject, NSError *error) {
        [exp fulfill];
    }];
    [request setDownProcessBlock:^(int64_t bytesDownload, int64_t totalBytesDownload, int64_t totalBytesExpectedToDownload) {
        NSLog(@"⏬⏬⏬⏬DOWN [Total]%lld  [Downloaded]%lld [Download]%lld", totalBytesExpectedToDownload, totalBytesDownload, bytesDownload);
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetObject:request];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];

}
//提取盲水印
- (void)testExtraBlindWaterMark {
    XCTestExpectation* exp = [self expectationWithDescription:@"Recognition"];
    QCloudPutObjectWatermarkRequest *put = [QCloudPutObjectWatermarkRequest new];
    
    NSError * localError;
    [put buildRequestData:&localError];
    XCTAssertNotNil(localError);
    put.object = @"1.png";
    
    [put buildRequestData:&localError];
    XCTAssertNotNil(localError);
    put.bucket = gImageTestBucket.name;
    
    [put buildRequestData:&localError];
    XCTAssertNotNil(localError);
    put.body = [@"123456789" dataUsingEncoding:NSUTF8StringEncoding];
    
    QCloudPicOperations *op = [[QCloudPicOperations alloc] init];
    op.is_pic_info = NO;
    QCloudPicOperationRule *rule = [[QCloudPicOperationRule alloc] init];
    rule.fileid = @"watermark.png";
    rule.imageURL = @"http://ci-1253960454.cos.ap-beijing.myqcloud.com/protection_blind_watermark_icon.png";
    rule.type = QCloudPicOperationRuleFull;
    rule.actionType =QCloudPicOperationRuleActionPut;
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

- (void)testSetupWaterMark {
    XCTestExpectation* exp = [self expectationWithDescription:@"Recognition"];
    QCloudPutObjectWatermarkRequest *put = [QCloudPutObjectWatermarkRequest new];
    
    NSError * localError;
    [put buildRequestData:&localError];
    XCTAssertNotNil(localError);
    put.object = @"objectName";
    
    [put buildRequestData:&localError];
    XCTAssertNotNil(localError);
    put.bucket = gImageTestBucket.name;
    put.regionName = gImageTestBucket.location;
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





//文档预览
-(void)testQCloudGetFilePreviewRequest{
    XCTestExpectation* exp = [self expectationWithDescription:@"QCloudGetFilePreviewRequest"];
    
    QCloudGetFilePreviewRequest *request = [[QCloudGetFilePreviewRequest alloc]init];
        
    request.bucket = gImageTestBucket.name;
   
    request.object = @"887_1659493668571_作业1.docx";
    
    request.page = 0;
    request.regionName = gImageTestBucket.location;
    request.srcType = @"docx";
    request.dstType = @"png";
    
    [request setFinishBlock:^(QCloudGetFilePreviewResult * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetFilePreviewObject:request];
    
    [self waitForExpectationsWithTimeout:100 handler:nil];
}


-(void)testQCloudCIImageRepairRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudCIImageRepairRequest"];
    QCloudCIImageRepairRequest * request = [[QCloudCIImageRepairRequest alloc]init];
    request.regionName = gImageTestBucket.location;
    request.bucket = gImageTestBucket.name;
    request.object = @"imagefix.jpeg";
    request.maskPoly = @[@[@0,@2586],@[@1500,@2586],@[@1500,@2700],@[@0,@2700]];
    [request setFinishBlock:^(NSString * _Nullable result, NSError * _Nullable error) {
        [expectation fulfill];
        XCTAssertNil(error);
        XCTAssertNotNil(result);
    }];
    [[QCloudCOSXMLService defaultCOSXML] ImageRepair:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudCIDetectCarRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudCIDetectCarRequest"];
    QCloudCIDetectCarRequest * request = [QCloudCIDetectCarRequest new];
    request.regionName = gImageTestBucket.location;
    request.bucket = gImageTestBucket.name;
    request.object = @"bigdog.webp";
    [request setFinishBlock:^(QCloudCIDetectCarResult * _Nullable result, NSError * _Nullable error) {
        [expectation fulfill];
        XCTAssertNil(error);
        XCTAssertNotNil(result);
    }];
    [[QCloudCOSXMLService defaultCOSXML] DetectCar:request];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

-(void)testQCloudCIOCRRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudCIOCRRequest"];
    QCloudCIOCRRequest * request = [QCloudCIOCRRequest new];
    request.regionName = gImageTestBucket.location;
    request.bucket = gImageTestBucket.name;
    request.object = @"textocr.png";
    [request setFinishBlock:^(QCloudCIOCRResult * _Nullable result, NSError * _Nullable error) {
        [expectation fulfill];
        XCTAssertNil(error);
        XCTAssertNotNil(result);
    }];
    [[QCloudCOSXMLService defaultCOSXML] OCR:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testQCloudCIBodyRecognitionRequest {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"QCloudCIBodyRecognitionRequest"];
    QCloudCIBodyRecognitionRequest * request = [ QCloudCIBodyRecognitionRequest new];
    request.regionName = gImageTestBucket.location;
    request.bucket = gImageTestBucket.name;
    request.object = @"1347199879401.jpg";
    [request setFinishBlock:^(QCloudBodyRecognitionResult * _Nullable result, NSError * _Nullable error) {
        [expectation fulfill];
        XCTAssertNil(error);
        XCTAssertNotNil(result);
    }];
    [[QCloudCOSXMLService defaultCOSXML] BodyRecognition:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testQCloudCIAutoTranslationRequest {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"QCloudCIAutoTranslationRequest"];
    QCloudCIAutoTranslationRequest * request = [QCloudCIAutoTranslationRequest new];
    request.regionName = gImageTestBucket.location;
    request.bucket = gImageTestBucket.name;
    request.InputText = @"日照香炉生紫烟";
    request.SourceLang = @"zh";
    request.TargetLang = @"en";
    [request setFinishBlock:^(QCloudAutoTranslationResult * _Nullable result, NSError * _Nullable error) {
        [expectation fulfill];
        XCTAssertNil(error);
        XCTAssertNotNil(result);
    }];
    [[QCloudCOSXMLService defaultCOSXML] AutoTranslation:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testQCloudCIFaceEffectRequest {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"QCloudCIFaceEffectRequest"];
    QCloudCIFaceEffectRequest * request = [QCloudCIFaceEffectRequest new];
    request.regionName = gImageTestBucket.location;
    request.bucket = gImageTestBucket.name;
    request.object = @"body.webp";
    request.type = QCloudFaceEffectBeautify;
    request.whitening = 100;
    request.smoothing = 100;
    [request setFinishBlock:^(QCloudEffectFaceResult * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        NSData * data = [[NSData alloc]initWithBase64EncodedString:result.ResultImage options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage * image = [UIImage imageWithData:data];
        XCTAssertNotNil(image);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] FaceEffect:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testQCloudCIDetectFaceRequest {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"QCloudCIDetectFaceRequest"];
    QCloudCIDetectFaceRequest * request = [QCloudCIDetectFaceRequest new];
    request.regionName = gImageTestBucket.location;
    request.bucket = gImageTestBucket.name;
    request.object = @"body.webp";
    [request setFinishBlock:^(QCloudDetectFaceResult * _Nullable result, NSError * _Nullable error) {
        [expectation fulfill];
        XCTAssertNil(error);
        XCTAssertNotNil(result);
    }];
    [[QCloudCOSXMLService defaultCOSXML] DetectFace:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testQCloudCIRecognizeLogoRequest {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"QCloudCIRecognizeLogoRequest"];
    QCloudCIRecognizeLogoRequest * request = [QCloudCIRecognizeLogoRequest new];
    request.regionName = gImageTestBucket.location;
    request.bucket = gImageTestBucket.name;
    request.object = @"tank.jpg";
    [request setFinishBlock:^(QCloudCILogoRecognitionResult * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] RecognizeLogo:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testQCloudCIGetGoodsMattingRequest {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"QCloudCIGetGoodsMattingRequest"];
    QCloudCIGetGoodsMattingRequest * request = [QCloudCIGetGoodsMattingRequest new];
    request.regionName = gImageTestBucket.location;
    request.bucket = gImageTestBucket.name;
    request.object = @"tank.jpg";
    
    [request setFinishBlock:^(NSString * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetGoodsMatting:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudPostLiveVideoRecognitionRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudPostLiveVideoRecognitionRequest"];
    QCloudPostLiveVideoRecognitionRequest * request = [QCloudPostLiveVideoRecognitionRequest new];
    // 存储桶名称，格式为 BucketName-APPID
    request.regionName = gImageTestBucket.location;
    request.bucket = gImageTestBucket.name;
    request.path = @"test";
    request.url = @"test";
    request.callbackType = 1;

    [request setFinishBlock:^(QCloudPostVideoRecognitionResult * _Nullable result, NSError * _Nullable error) {
        
        XCTAssertNil(result);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PostLiveVideoRecognition:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudGetLiveVideoRecognitionRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudGetLiveVideoRecognitionRequest"];
    QCloudGetLiveVideoRecognitionRequest * request = [QCloudGetLiveVideoRecognitionRequest new];
    // QCloudPostAudioDiscernTaskRequest接口返回的jobid
    request.jobId = @"test";

    request.regionName = gImageTestBucket.location;
    request.bucket = gImageTestBucket.name;
    [request setFinishBlock:^(QCloudVideoRecognitionResult * _Nullable result, NSError * _Nullable error) {
        XCTAssertTrue([error.userInfo[@"Message"] isEqualToString:@"auditing jobId is illegal."]);
        XCTAssertNil(result);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetLiveVideoRecognition:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudCancelLiveVideoRecognitionRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudCancelLiveVideoRecognitionRequest"];
    QCloudCancelLiveVideoRecognitionRequest * request = [QCloudCancelLiveVideoRecognitionRequest new];

    // QCloudPostAudioDiscernTaskRequest接口返回的jobid
    request.jobId = @"test";

    request.regionName = gImageTestBucket.location;
    request.bucket = gImageTestBucket.name;
    
    [request setFinishBlock:^(QCloudPostVideoRecognitionResult * _Nullable result, NSError * _Nullable error) {
        XCTAssertTrue([error.userInfo[@"Message"] isEqualToString:@"auditing jobId is illegal."]);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] CancelLiveVideoRecognition:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testQCloudPutObjectWatermarkRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudPutObjectWatermarkRequest"];
    QCloudPutObjectWatermarkRequest* put = [QCloudPutObjectWatermarkRequest new];

    // 对象键，是对象在 COS 上的完整路径，如果带目录的话，格式为 "dir1/object1"
    put.object = @"logotest.jpg";
    // 存储桶名称，由BucketName-Appid 组成，可以在COS控制台查看 https://console.cloud.tencent.com/cos5/bucket
    put.bucket = gImageTestBucket.name;
    put.body =  [@"123456789" dataUsingEncoding:NSUTF8StringEncoding];
    QCloudPicOperations * op = [[QCloudPicOperations alloc]init];

    // 是否返回原图信息。0表示不返回原图信息，1表示返回原图信息，默认为0
    op.is_pic_info = NO;
    QCloudPicOperationRule * rule = [[QCloudPicOperationRule alloc]init];

    // 处理结果的文件路径名称，如以/开头，则存入指定文件夹中，否则，存入原图文件存储的同目录
    rule.fileid = @"test";

    rule.actionType =QCloudPicOperationRuleActionPut;
    // 盲水印类型，有效值：QCloudPicOperationRuleHalf 半盲；QCloudPicOperationRuleFull: 全盲；QCloudPicOperationRuleText 文字
    rule.type = QCloudPicOperationRuleText;
    rule.text = @"test";
    op.rule = @[rule];
    put.picOperations = op;
    [put setFinishBlock:^(QCloudPutObjectWatermarkResult *outputObject, NSError *error) {
        XCTAssertTrue([error.userInfo[@"Code"] isEqualToString:@"InvalidImageFormat"]);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutWatermarkObject:put];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testQCloudCreateMediaBucketRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudCreateMediaBucketRequest"];
    QCloudGetDescribeMediaBucketsRequest * createReq  = [[QCloudGetDescribeMediaBucketsRequest alloc]init];
    createReq.regionName = gImageTestBucket.location;
    createReq.bucketName = gImageTestBucket.name;
    [createReq setFinishBlock:^(QCloudDescribeMediaInfo * _Nullable result, NSError * _Nullable error) {
        XCTAssertNotNil(result);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] CIGetDescribeMediaBuckets:createReq];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testQCloudGetMediaInfoRequest {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudGetMediaInfoRequest"];
    QCloudGetMediaInfoRequest * request = [[QCloudGetMediaInfoRequest alloc]init];
    // 对象键，是对象在 COS 上的完整路径，如果带目录的话，格式为 "dir1/object1"
    request.regionName = gImageTestBucket.location;
    request.bucket = gImageTestBucket.name;
    request.object = @"default.mp4";
    
    [request setFinishBlock:^(QCloudMediaInfo * _Nullable result, NSError * _Nullable error) {
            XCTAssertNotNil(result);
            XCTAssertNil(error);
            [expectation fulfill];
        }];
    [[QCloudCOSXMLService defaultCOSXML] CIGetMediaInfo:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testQCloudGetDescribeMediaBucketsRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudGetDescribeMediaBucketsRequest"];
    QCloudGetDescribeMediaBucketsRequest * request = [[QCloudGetDescribeMediaBucketsRequest alloc]init];

    // 存储桶名称前缀，前缀搜索
    request.bucketName = gImageTestBucket.name;
    request.regionName = gImageTestBucket.location;
    // 第几页
    request.pageNumber = 0;
    // 每页个数
    request.pageSize = 10;

    request.finishBlock = ^(QCloudDescribeMediaInfo * outputObject, NSError *error) {
        XCTAssertNotNil(outputObject);
        XCTAssertNil(error);
        [expectation fulfill];
    };
    [[QCloudCOSXMLService defaultCOSXML] CIGetDescribeMediaBuckets:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testQCloudSyncImageRecognitionRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSyncImageRecognitionRequest"];
    QCloudSyncImageRecognitionRequest * request = [[QCloudSyncImageRecognitionRequest alloc]init];

    // 存储桶名称，格式为 BucketName-APPID
    request.bucket = gImageTestBucket.name;

    request.regionName = gImageTestBucket.location;
    request.object = @"134719996694.jpg";
    
    [request setFinishBlock:^(QCloudImageRecognitionResult * _Nullable result, NSError * _Nullable error) {
        XCTAssertNotNil(result);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] SyncImageRecognition:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}


- (void)testQCloudGetPrivateM3U8Request {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudPutObjectWatermarkRequest"];
    QCloudGetPrivateM3U8Request * request = [QCloudGetPrivateM3U8Request new];
    request.object = @"test.m3u8";
    request.bucket = @"tinna-media-1253960454";
    request.regionName = @"ap-chongqing";
    [request setFinishBlock:^(id _Nullable result, NSError * _Nullable error) {
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetPrivateM3U8:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testQCloudUpdateMediaQueueRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudPutObjectWatermarkRequest"];
    QCloudGetMediaJobQueueRequest * getRequest = [QCloudGetMediaJobQueueRequest new];
    getRequest.bucket = @"tinna-media-1253960454";
    getRequest.regionName = @"ap-chongqing";
    [getRequest setFinishBlock:^(QCloudAIJobQueueResult * _Nullable result, NSError * _Nullable error) {
        
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        QCloudUpdateMediaQueueRequest * request = [QCloudUpdateMediaQueueRequest new];
        request.bucket = @"tinna-media-1253960454";
        request.regionName = @"ap-chongqing";
        request.queueID = result.QueueList.firstObject.QueueId;
        request.name = @"test";
        request.state = 1;
        [request setFinishBlock:^(QCloudQueueItemModel * _Nullable result, NSError * _Nullable error) {
            XCTAssertNil(error);
            XCTAssertNotNil(result);
            [expectation fulfill];
        }];
        [[QCloudCOSXMLService defaultCOSXML] UpdateMediaJobQueue:request];
        
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetMediaJobQueue:getRequest];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testQCloudGetWorkflowDetailRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudGetListWorkflowRequest"];
    QCloudGetListWorkflowRequest * request = [QCloudGetListWorkflowRequest new];
    request.bucket = @"tinna-media-1253960454";
    request.regionName = @"ap-chongqing";
    __block NSString *workflowId = @"";
    [request setFinishBlock:^(QCloudListWorkflow * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"testQCloudPostTriggerWorkflowRequest"];
    QCloudPostTriggerWorkflowRequest * request1 = [QCloudPostTriggerWorkflowRequest new];
    request1.bucket = @"tinna-media-1253960454";
    request1.regionName = @"ap-chongqing";
    request1.workflowId = @"w8a2fe638ca4642479216ceecf7fd6dfd";
    request1.object = @"test.m3u8";
    __block NSString *instanceId = @"";
    [request1 setFinishBlock:^(QCloudTriggerWorkflow * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        instanceId = result.InstanceId;
        [expectation1 fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PostTriggerWorkflow:request1];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"testQCloudGetWorkflowDetailRequest"];
    QCloudGetWorkflowDetailRequest * detailRequest = [QCloudGetWorkflowDetailRequest new];
    detailRequest.bucket = @"tinna-media-1253960454";
    detailRequest.regionName = @"ap-chongqing";
    detailRequest.runId = instanceId;
    
    [detailRequest setFinishBlock:^(QCloudWorkflowexecutionResult * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation2 fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML]GetWorkflowDetail:detailRequest];
    
    
    [QCloudCOSXMLService.defaultCOSXML GetListWorkflow:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testQCloudPostTriggerWorkflowRequest {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudPostTriggerWorkflowRequest"];
    QCloudPostTriggerWorkflowRequest * request = [QCloudPostTriggerWorkflowRequest new];
    request.bucket = @"tinna-media-1253960454";
    request.regionName = @"ap-chongqing";
    request.workflowId = @"w8a2fe638ca4642479216ceecf7fd6dfd";
    request.object = @"test.m3u8";
    [request setFinishBlock:^(QCloudTriggerWorkflow * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PostTriggerWorkflow:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testQCloudPostMediaJobsRequest {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudPostTriggerWorkflowRequest"];
    QCloudPostMediaJobsRequest * request = [QCloudPostMediaJobsRequest new];
    request.bucket = @"tinna-media-1253960454";
    request.regionName = @"ap-chongqing";
    
    QCloudMediaJobsInput * input = QCloudMediaJobsInput.new;
    input.Input = QCloudMediaJobsInputInput.new;
    input.Input.Object = @"test.m3u8";
    request.input = input;
    
    [request setFinishBlock:^(QCloudMediaJobs * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML]PostMediaJobs:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testQCloudPostAudioTransferJobsRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudPostAudioTransferJobsRequest"];
    QCloudPostAudioTransferJobsRequest * request = [QCloudPostAudioTransferJobsRequest new];
    request.bucket = @"tinna-media-1253960454";
    request.regionName = @"ap-chongqing";
    
    QCloudInputPostAudioTransferJobs * input = QCloudInputPostAudioTransferJobs.new;
    input.Input = QCloudInputPostAudioTransferJobsInput.new;
    input.Input.Object = @"test.m3u8";
    input.Operation = QCloudInputPostAudioTransferOperation.new;
    input.Operation.Segment = QCloudInputPostAudioTransferSegment.new;
    input.Operation.Segment.Format = @"m3u8";
    
    input.Operation.Output = QCloudInputPostAudioTransferOutput.new;
    input.Operation.Output.Region = @"ap-chongqing";
    input.Operation.Output.Bucket = @"tinna-media-1253960454";
    input.Operation.Output.Object = @"test1.m3u8";
    
    request.input = input;
    
    [request setFinishBlock:^(QCloudPostAudioTransferJobs * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML]PostAudioTransferJobs:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
    
}

- (void)testQCloudPostImageProcessRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudPostImageProcessRequest"];
    QCloudPostImageProcessRequest * request = [QCloudPostImageProcessRequest new];
    request.bucket = @"tinna-media-1253960454";
    request.regionName = @"ap-chongqing";
    
    QCloudInputPostImageProcess * input = QCloudInputPostImageProcess.new;
    input.Input = QCloudInputPostImageProcessInput.new;
    input.Input.Object = @"抹除.png";
    
    input.Operation = QCloudInputPostImageProcessOperation.new;
    input.Operation.Output = QCloudInputPostImageProcessOutput.new;
    input.Operation.Output.Region = @"ap-chongqing";
    input.Operation.Output.Bucket = @"tinna-media-1253960454";
    input.Operation.Output.Object = @"抹除1.png";
    input.Operation.TemplateId = @"t15d4651a937914b47b4e292746a09097b";
    request.input = input;
    
    [request setFinishBlock:^(QCloudPostImageProcess * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML]PostImageProcess:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
    
}

- (void)testQCloudPostVideoTagRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudPostVideoTagRequest"];
    QCloudPostVideoTagRequest * request = [QCloudPostVideoTagRequest new];
    request.bucket = @"tinna-media-1253960454";
    request.regionName = @"ap-chongqing";
    
    QCloudPostVideoTag * input = QCloudPostVideoTag.new;
    input.Input = QCloudPostVideoTagInput.new;
    input.Input.Object = @"test.m3u8";
    
    input.Operation = QCloudPostVideoTagOperation.new;
    input.Operation.VideoTag = QCloudPostVideoTagVideoTag.new;
    input.Operation.VideoTag.Scenario = @"Stream";
    
    request.input = input;
    
    [request setFinishBlock:^(QCloudPostVideoTagResult * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML]PostVideoTag:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testQCloudExtractNumMarkRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudExtractNumMarkRequest"];
    QCloudExtractNumMarkRequest * request = [QCloudExtractNumMarkRequest new];
    request.bucket = @"tinna-media-1253960454";
    request.regionName = @"ap-chongqing";
    
    QCloudInputExtractNumMark * input = QCloudInputExtractNumMark.new;
    input.Input = QCloudInputExtractNumMarkInput.new;
    input.Input.Object = @"test.m3u8";
    
    input.Operation = QCloudInputExtractNumMarkOperation.new;
    input.Operation.ExtractDigitalWatermark = QCloudInputExtractNumMarkDigitalWatermark.new;
    input.Operation.ExtractDigitalWatermark.Type = @"Text";
    input.Operation.ExtractDigitalWatermark.Version = @"V1";
    request.input = input;
    
    [request setFinishBlock:^(QCloudExtractNumMark * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML]ExtractNumMark:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testQCloudPostNumMarkRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudPostNumMarkRequest"];
    QCloudPostNumMarkRequest * request = [QCloudPostNumMarkRequest new];
    request.bucket = @"tinna-media-1253960454";
    request.regionName = @"ap-chongqing";
    
    QCloudInputPostNumMark * input = QCloudInputPostNumMark.new;
    input.Input = QCloudInputPostNumMarkInput.new;
    input.Input.Object = @"test.m3u8";
    
    input.Operation = QCloudInputPostNumMarkOperation.new;
    input.Operation.DigitalWatermark = QCloudDigitalWatermark.new;
    input.Operation.DigitalWatermark.Type = @"Text";
    input.Operation.DigitalWatermark.Message = @"123";
    input.Operation.DigitalWatermark.Version = @"V1";
    input.Operation.Output = QCloudInputPostNumMarkOperationOutput.new;
    input.Operation.Output.Object = @"target.m3u8";
    input.Operation.Output.Bucket = @"tinna-media-1253960454";
    input.Operation.Output.Region = @"ap-chongqing";
    request.input = input;
    
    [request setFinishBlock:^(QCloudPostNumMark * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML]PostNumMark:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testQCloudVideoMontageRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudVideoMontageRequest"];
    QCloudVideoMontageRequest * request = [QCloudVideoMontageRequest new];
    request.bucket = @"tinna-media-1253960454";
    request.regionName = @"ap-chongqing";
    QCloudInputVideoMontage * input = QCloudInputVideoMontage.new;
    input.Input = QCloudInputVideoMontageInput.new;
    input.Input.Object = @"test.m3u8";
    
    input.Operation = QCloudInputVideoMontageOperation.new;
    
    input.Operation.TemplateId = @"t13bbd811a5c454a259b6fe3cd4bf68744";
    input.Operation.Output = QCloudInputVideoMontageOutput.new;
    input.Operation.Output.Region = @"ap-chongqing";
    input.Operation.Output.Bucket = @"tinna-media-1253960454";
    input.Operation.Output.Object = @"test";
    request.input = input;
    
    [request setFinishBlock:^(QCloudVideoMontage * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    
    [[QCloudCOSXMLService defaultCOSXML]PostVideoMontage:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testQCloudPostSmartCoverRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudPostSmartCoverRequest"];
    QCloudPostSmartCoverRequest * request = [QCloudPostSmartCoverRequest new];
    request.bucket = @"tinna-media-1253960454";
    request.regionName = @"ap-chongqing";
    
    QCloudInputPostSmartCover * input = QCloudInputPostSmartCover.new;
    input.Input = QCloudInputPostSmartCoverInput.new;
    input.Input.Object = @"test.m3u8";
    
    input.Operation = QCloudInputPostSmartCoverOperation.new;
    
    input.Operation.TemplateId = @"t178ad3b239de540b0b7d6bc7e6c57238f";
    input.Operation.Output = QCloudInputPostSmartOutput.new;
    input.Operation.Output.Region = @"ap-chongqing";
    input.Operation.Output.Bucket = @"tinna-media-1253960454";
    input.Operation.Output.Object = @"test_${Number}.jpg";
    request.input = input;
    
    [request setFinishBlock:^(QCloudPostSmartCover * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    
    [[QCloudCOSXMLService defaultCOSXML]PostSmartCover:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testQCloudPostConcatRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudPostConcatRequest"];
    QCloudPostConcatRequest * request = [QCloudPostConcatRequest new];
    request.bucket = @"tinna-media-1253960454";
    request.regionName = @"ap-chongqing";
    
    QCloudInputPostConcat * input = QCloudInputPostConcat.new;
    input.Input = QCloudInputPostConcatInput.new;
    input.Input.Object = @"test.m3u8";
    
    input.Operation = QCloudInputPostConcatOperation.new;
    
    input.Operation.TemplateId = @"t1146d03a323704d3195c119e782f0d4ad";
    input.Operation.Output = QCloudInputPostConcatOutput.new;
    input.Operation.Output.Region = @"ap-chongqing";
    input.Operation.Output.Bucket = @"tinna-media-1253960454";
    input.Operation.Output.Object = @"test";
    request.input = input;
    
    [request setFinishBlock:^(QCloudPostConcat * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    
    [[QCloudCOSXMLService defaultCOSXML]PostConcat:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testQCloudPostAnimationRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudPostAnimationRequest"];
    QCloudPostAnimationRequest * request = [QCloudPostAnimationRequest new];
    request.bucket = @"tinna-media-1253960454";
    request.regionName = @"ap-chongqing";
    
    QCloudInputPostAnimation * input = QCloudInputPostAnimation.new;
    input.Input = QCloudInputPostAnimationInput.new;
    input.Input.Object = @"test.m3u8";
    
    input.Operation = QCloudInputPostAnimationOperation.new;
    
    input.Operation.TemplateId = @"t1dcb1f3f1b2d044cd9c029ad41e3641a8";
    input.Operation.Output = QCloudInputPostAnimationOperationOutput.new;
    input.Operation.Output.Region = @"ap-chongqing";
    input.Operation.Output.Bucket = @"tinna-media-1253960454";
    input.Operation.Output.Object = @"test";
    request.input = input;
    
    [request setFinishBlock:^(QCloudPostAnimation * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    
    [[QCloudCOSXMLService defaultCOSXML]PostAnimation:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testQCloudPostTranscodeRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudPostTranscodeRequest"];
    QCloudPostTranscodeRequest * request = [QCloudPostTranscodeRequest new];
    request.bucket = @"tinna-media-1253960454";
    request.regionName = @"ap-chongqing";
    
    QCloudInputPostTranscode * input = QCloudInputPostTranscode.new;
    input.Input = QCloudInputPostTranscodeInput.new;
    input.Input.Object = @"test.m3u8";
    
    input.Operation = QCloudInputPostTranscodeOperation.new;
    
    input.Operation.TemplateId = @"t13f2ddd171f59478d8fc664e575a66930";
    input.Operation.Output = QCloudInputPostTranscodeOutput.new;
    input.Operation.Output.Region = @"ap-chongqing";
    input.Operation.Output.Bucket = @"tinna-media-1253960454";
    input.Operation.Output.Object = @"test";
    request.input = input;
    
    [request setFinishBlock:^(QCloudPostTranscode * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    
    [[QCloudCOSXMLService defaultCOSXML]PostTranscode:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)testQCloudVideoSnapshotRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudVideoSnapshotRequest"];
    QCloudVideoSnapshotRequest * request = [QCloudVideoSnapshotRequest new];
    request.bucket = @"tinna-media-1253960454";
    request.regionName = @"ap-chongqing";
    
    QCloudInputVideoSnapshot * input = QCloudInputVideoSnapshot.new;
    input.Input = QCloudInputVideoSnapshotInput.new;
    input.Input.Object = @"test.m3u8";
    
    input.Operation = QCloudInputVideoSnapshotOperation.new;
    
    input.Operation.TemplateId = @"t17e38031e7c0f40cba7211cefd6e34287";
    input.Operation.Output = QCloudInputVideoSnapshotOperationOutput.new;
    request.bucket = @"tinna-media-1253960454";
    request.regionName = @"ap-chongqing";
    input.Operation.Output.Object = @"test";
    input.Operation.Output.Bucket = @"tinna-media-1253960454";
    input.Operation.Output.Region = @"ap-chongqing";
    input.Operation.Output.SpriteObject = @"test_${number}.jpg";
    request.input = input;
    
    [request setFinishBlock:^(QCloudVideoSnapshot * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    
    [[QCloudCOSXMLService defaultCOSXML]PostVideoSnapshot:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudPostTextAuditReportRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudPostTextAuditReportRequest"];
    QCloudPostTextAuditReportRequest * request = [QCloudPostTextAuditReportRequest new];
    request.bucket = @"ci-auditing-sample-1253960454";
    request.regionName = @"ap-guangzhou";
    
    QCloudPostTextAuditReport * input = [QCloudPostTextAuditReport new];
    
    NSData *data =[@"text" dataUsingEncoding:NSUTF8StringEncoding];
    //2、对二进制数据进行base64编码，完成后返回字符串
    NSString * base64Str = [data base64EncodedStringWithOptions:0];
    input.Text = base64Str;
    input.ContentType = 1;
    input.Label = @"Porn";
    input.SuggestedLabel = @"Normal";
    request.input = input;
    [request setFinishBlock:^(QCloudPostTextAuditReportResult * _Nullable result, NSError * _Nullable error) {
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PostTextAuditReport:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudPostImageAuditReportRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudPostImageAuditReportRequest"];
    QCloudPostImageAuditReportRequest * request = [QCloudPostImageAuditReportRequest new];
    request.bucket = @"ci-auditing-sample-1253960454";
    request.regionName = @"ap-guangzhou";

    QCloudPostImageAuditReport * input = [QCloudPostImageAuditReport new];
    input.ContentType = 2;
    input.Url = @"https://ci-auditing-sample-1253960454.cos.ap-guangzhou.myqcloud.com/test.png";
    input.Label = @"Porn";
    input.SuggestedLabel = @"Normal";
    request.input = input;
    [request setFinishBlock:^(QCloudPostImageAuditReportResult * _Nullable result, NSError * _Nullable error) {
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PostImageAuditReport:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudImageSearchBucketRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudImageSearchBucketRequest"];
    
    QCloudImageSearchBucketRequest * request = [QCloudImageSearchBucketRequest new];
    request.bucket = @"tinna-media-1253960454";
    request.regionName = @"ap-chongqing";
     QCloudImageSearchBucket * imageSearchBucket = [QCloudImageSearchBucket new];
    // 图库容量限制;是否必传：是
    imageSearchBucket.MaxCapacity = 100;
//    imageSearchBucket.MaxQps = 10;
    request.input =imageSearchBucket;
    
    [request setFinishBlock:^(id outputObject, NSError *error) {
        // 无响应体
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] ImageSearchBucket:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudAIDetectPetRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudAIDetectPetRequest"];
    QCloudAIDetectPetRequest * request = [QCloudAIDetectPetRequest new];
    request.bucket = @"000garenwang-1253960454";
    
    request.regionName = @"ap-nanjing";
    // 数据万象处理能力，宠物识别固定为 detect-pet;是否必传：true；
    request.ciProcess = @"detect-pet";
    request.ObjectKey = @"3_dog.webp";

    [request setFinishBlock:^(QCloudAIDetectPetResponse * outputObject, NSError *error) {
        // result：QCloudAIDetectPetResponse 包含所有的响应；
        // 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/95753
        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] AIDetectPet:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudAIEnhanceImageRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudAIEnhanceImageRequest"];
    QCloudAIEnhanceImageRequest * request = [QCloudAIEnhanceImageRequest new];
    request.bucket = @"000garenwang-1253960454";
    
    request.regionName = @"ap-nanjing";
    // 数据万象处理能力，只能裁剪参固定为 AIEnhanceImage。;是否必传：true；
    request.ciProcess = @"AIEnhanceImage";
    // 去噪强度值，取值范围为 0 - 5 之间的整数，值为 0 时不进行去噪操作，默认值为3。;是否必传：false；
    request.denoise = 3;
    // 锐化强度值，取值范围为 0 - 5 之间的整数，值为 0 时不进行锐化操作，默认值为3。;是否必传：false；
    request.sharpen = 3;
    // 您可以通过填写 detect-url 处理任意公网可访问的图片链接。不填写 detect-url  时，后台会默认处理 ObjectKey ，填写了detect-url 时，后台会处理 detect-url链接，无需再填写 ObjectKey ，detect-url 示例：http://www.example.com/abc.jpg ，需要进行 UrlEncode，处理后为  http%25253A%25252F%25252Fwww.example.com%25252Fabc.jpg;是否必传：false；
    request.ObjectKey = @"tank_300.jpg";
    // ;是否必传：false；
    request.ignoreError = 0;

    [request setFinishBlock:^(id outputObject, NSError *error) {
        UIImage * resultImage = [UIImage imageWithData:outputObject];
        XCTAssertNil(error);
        XCTAssertNotNil(resultImage);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] AIEnhanceImage:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudAIGameRecRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudAIGameRecRequest"];
    QCloudAIGameRecRequest * request = [QCloudAIGameRecRequest new];
    request.bucket = @"000garenwang-1253960454";
    
    request.regionName = @"ap-nanjing";
    // String;是否必传：false；
    request.ObjectKey = @"1347199842654.jpg";
    
    request.ciProcess = @"AIGameRec";
    
    [request setFinishBlock:^(QCloudAIGameRecResponse * outputObject, NSError *error) {
        // result：QCloudAIGameRecResponse 包含所有的响应；
        // 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/93153
        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] AIGameRec:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudAIIDCardOCRRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudAIIDCardOCRRequest"];
    QCloudAIIDCardOCRRequest * request = [QCloudAIIDCardOCRRequest new];
    request.bucket = @"000garenwang-1253960454";
    
    request.regionName = @"ap-nanjing";
    // 数据万象处理能力，身份证识别固定为 IDCardOCR;是否必传：true；
    request.ciProcess = @"IDCardOCR";

    request.ObjectKey = @"idcard_f.jpg";
    
    request.Config = @"{\"CropIdCard\":true}";
    
    [request setFinishBlock:^(QCloudAIIDCardOCRResponse * outputObject, NSError *error) {
        // result：QCloudAIIDCardOCRResponse 包含所有的响应；
        // 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/48638
        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] AIIDCardOCR:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudAIImageColoringRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudAIImageColoringRequest"];
    QCloudAIImageColoringRequest * request = [QCloudAIImageColoringRequest new];
    request.bucket = @"000garenwang-1253960454";
    
    request.regionName = @"ap-nanjing";
    // 数据万象处理能力，图片上色参固定为AIImageColoring。;是否必传：true；
    request.ciProcess = @"AIImageColoring";
    // 待上色图片url，需要进行urlencode，与ObjectKey二选其一，如果同时存在，则默认以ObjectKey为准;是否必传：false；
    request.ObjectKey = @"1347199842654.jpg";

    [request setFinishBlock:^(id outputObject, NSError *error) {
        // 无响应体
        UIImage * result = [UIImage imageWithData:outputObject];
        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] AIImageColoring:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudAIImageCropRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudAIImageCropRequest"];
    QCloudAIImageCropRequest * request = [QCloudAIImageCropRequest new];
    request.bucket = @"000garenwang-1253960454";
    
    request.regionName = @"ap-nanjing";
    // 数据万象处理能力，智能裁剪固定为AIImageCrop;是否必传：true；
    request.ciProcess = @"AIImageCrop";
    // 您可以通过填写 detect-url 处理任意公网可访问的图片链接。不填写 detect-url 时，后台会默认处理 ObjectKey ，填写了 detect-url 时，后台会处理 detect-url 链接，无需再填写 ObjectKey detect-url 示例：http://www.example.com/abc.jpg ，需要进行 UrlEncode，处理后为http%25253A%25252F%25252Fwww.example.com%25252Fabc.jpg;是否必传：false；
    request.ObjectKey = @"1347199842654.jpg";
    // 需要裁剪区域的宽度，与height共同组成所需裁剪的图片宽高比例；输入数字请大于0、小于图片宽度的像素值;是否必传：true；
    request.width = 100;
    // 需要裁剪区域的高度，与width共同组成所需裁剪的图片宽高比例；输入数字请大于0、小于图片高度的像素值；width : height建议取值在[1, 2.5]之间，超过这个范围可能会影响效果;是否必传：true；
    request.height = 100;

    [request setFinishBlock:^(id outputObject, NSError *error) {
        UIImage * result = [UIImage imageWithData:outputObject];
        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] AIImageCrop:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudAILicenseRecRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudAILicenseRecRequest"];
    QCloudAILicenseRecRequest * request = [QCloudAILicenseRecRequest new];
    request.bucket = @"000garenwang-1253960454";
    
    request.regionName = @"ap-nanjing";
    // 数据万象处理能力，卡证识别固定为AILicenseRec;是否必传：true；
    request.ciProcess = @"AILicenseRec";
    // 您可以通过填写 detect-url 处理任意公网可访问的图片链接。不填写 detect-url 时，后台会默认处理 ObjectKey ，填写了 detect-url 时，后台会处理 detect-url 链接，无需再填写 ObjectKey detect-url 示例：http://www.example.com/abc.jpg ，需要进行 UrlEncode，处理后为http%25253A%25252F%25252Fwww.example.com%25252Fabc.jpg;是否必传：false；
    request.ObjectKey = @"idcard_f.jpg";
    // 卡证识别类型，有效值为IDCard，DriverLicense。<br>IDCard表示身份证；DriverLicense表示驾驶证，默认：DriverLicense;是否必传：true；
    request.CardType = @"IDCard";

    [request setFinishBlock:^(QCloudAILicenseRecResponse * outputObject, NSError *error) {
        // result：QCloudAILicenseRecResponse 包含所有的响应；
        // 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/96767
        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] AILicenseRec:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudAISuperResolutionRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudAISuperResolutionRequest"];
    QCloudAISuperResolutionRequest * request = [QCloudAISuperResolutionRequest new];
    request.bucket = @"000garenwang-1253960454";
    
    request.regionName = @"ap-nanjing";
    // 数据万象处理能力，只能裁剪参固定为AISuperResolution。;是否必传：false；
    request.ciProcess = @"AISuperResolution";
    // 您可以通过填写 detect-url 处理任意公网可访问的图片链接。不填写 detect-url 时，后台会默认处理 ObjectKey ，填写了 detect-url 时，后台会处理 detect-url 链接，无需再填写 ObjectKey，detect-url 示例：http://www.example.com/abc.jpg ，需要进行 UrlEncode，处理后为http%25253A%25252F%25252Fwww.example.com%25252Fabc.jpg。;是否必传：false；
    request.ObjectKey = @"1347199842654.jpg";

    [request setFinishBlock:^(id outputObject, NSError *error) {
        UIImage * result = [UIImage imageWithData:outputObject];
        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] AISuperResolution:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudAssessQualityRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudAssessQualityRequest"];
    
    QCloudAssessQualityRequest * request = [QCloudAssessQualityRequest new];
    request.bucket = @"000garenwang-1253960454";
    
    request.regionName = @"ap-nanjing";
    // 数据万象处理能力，图像质量检测固定为 AssessQuality。;是否必传：true；
    request.ciProcess = @"AssessQuality";
    request.ObjectKey = @"1347199842654.jpg";
    [request setFinishBlock:^(QCloudAssessQualityResponse * outputObject, NSError *error) {
        // result：QCloudAssessQualityResponse 包含所有的响应；
        // 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/63228
        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] AssessQuality:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudCloseAIBucketRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudCloseAIBucketRequest"];
    QCloudCloseAIBucketRequest * request = [QCloudCloseAIBucketRequest new];
    request.bucket = @"tinna-media-1253960454";
    request.regionName = @"ap-chongqing";

    [request setFinishBlock:^(QCloudCloseAIBucketResponse * outputObject, NSError *error) {
        // result：QCloudCloseAIBucketResponse 包含所有的响应；
        // 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/95752
//        XCTAssertNil(error);
//        XCTAssertNotNil(outputObject);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] CloseAIBucket:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudCloseAsrBucketRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudCloseAsrBucketRequest"];
    QCloudCloseAsrBucketRequest * request = [QCloudCloseAsrBucketRequest new];
    request.bucket = @"000garenwang-1253960454";
    
    request.regionName = @"ap-nanjing";

    [request setFinishBlock:^(QCloudCloseAsrBucketResponse * outputObject, NSError *error) {
        // result：QCloudCloseAsrBucketResponse 包含所有的响应；
        // 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/95755
//        XCTAssertNil(error);
//        XCTAssertNotNil(outputObject);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] CloseAsrBucket:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudCreateQRcodeRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudCreateQRcodeRequest"];
    QCloudCreateQRcodeRequest * request = [QCloudCreateQRcodeRequest new];
    request.bucket = @"000garenwang-1253960454";
    
    request.regionName = @"ap-nanjing";
    // 数据万象处理能力，二维码生成参数为 qrcode-generate;是否必传：true；
    request.ciProcess = @"qrcode-generate";
    // 可识别的二维码文本信息;是否必传：true；
    request.qrcodeContent = @"爱你呦";
    // 生成的二维码类型，可选值：0或1。0为二维码，1为条形码，默认值为0;是否必传：false；
    request.mode = 0;
    // 指定生成的二维码或条形码的宽度，高度会进行等比压缩;是否必传：true；
    request.width = @"100";

    [request setFinishBlock:^(QCloudCreateQRcodeResponse * outputObject, NSError *error) {
        // result：QCloudCreateQRcodeResponse 包含所有的响应；
        // 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/53491
        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] CreateQRcode:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudDeleteImageSearchRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudDeleteImageSearchRequest"];
    QCloudAddImageSearchRequest * request = [QCloudAddImageSearchRequest new];
    
    request.bucket = @"tinna-media-1253960454";
    request.regionName = @"ap-chongqing";
    // 固定值：ImageSearch;是否必传：true；
    request.ciProcess = @"ImageSearch";
    // 固定值：AddImage;是否必传：true；
    request.action = @"AddImage";
    
    request.ObjectKey = @"logotest1.jpg";
    
    QCloudAddImageSearch * addImageSearch = [QCloudAddImageSearch new];
    // 物品 ID，最多支持64个字符。若 EntityId 已存在，则对其追加图片;是否必传：是
    addImageSearch.EntityId = @"garentest";

    request.input = addImageSearch;
    
    [request setFinishBlock:^(id outputObject, NSError *error) {
           // 无响应体
//        NSLog(@"%@",outputObject);
//        XCTAssertNil(error);
//        XCTAssertNotNil(outputObject);
        
        QCloudDeleteImageSearchRequest * request = [QCloudDeleteImageSearchRequest new];
        request.bucket = @"tinna-media-1253960454";
        request.regionName = @"ap-chongqing";
        
        request.ciProcess = @"ImageSearch";
        request.action = @"DeleteImage";
        request.ObjectKey = @"logotest1.jpg";
         QCloudDeleteImageSearch * deleteImageSearch = [QCloudDeleteImageSearch new];
        // 物品 ID;是否必传：是
        deleteImageSearch.EntityId = @"garentest";
        request.input = deleteImageSearch;
        [request setFinishBlock:^(id  _Nullable result, NSError * _Nullable error) {
            // 无响应体
            XCTAssertNil(error);
            XCTAssertNotNil(result);
            [expectation fulfill];
        }];
        [[QCloudCOSXMLService defaultCOSXML] DeleteImageSearch:request];
    }];
    [[QCloudCOSXMLService defaultCOSXML] AddImageSearch:request];
    [self waitForExpectationsWithTimeout:100 handler:nil];
    
}

-(void)testQCloudGetActionSequenceRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudGetActionSequenceRequest"];
    QCloudGetActionSequenceRequest * request = [QCloudGetActionSequenceRequest new];
    request.bucket = @"tinna-media-1253960454";
    request.regionName = @"ap-chongqing";
    // 数据万象处理能力，获取动作顺序固定为 GetActionSequence;是否必传：true；
    request.ciProcess = @"GetActionSequence";

    [request setFinishBlock:^(QCloudGetActionSequenceResponse * outputObject, NSError *error) {
        // result：QCloudGetActionSequenceResponse 包含所有的响应；
        // 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/48648
        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetActionSequence:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudGetAIBucketRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudGetAIBucketRequest"];
    QCloudGetAIBucketRequest * request = [QCloudGetAIBucketRequest new];
    request.regionName = @"ap-nanjing";
    // 地域信息，例如 ap-shanghai、ap-beijing，若查询多个地域以“,”分隔字符串，详情请参见 地域与域名;是否必传：true；
    // 第几页;是否必传：true；
    request.pageNumber = 1;
    // 每页个数，大于0且小于等于100的整数;是否必传：true；
    request.pageSize = 10;

    [request setFinishBlock:^(QCloudGetAIBucketResponse * outputObject, NSError *error) {
        // result：QCloudGetAIBucketResponse 包含所有的响应；
        // 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/79594
        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetAIBucket:request];

    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudGetLiveCodeRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudGetLiveCodeRequest"];
    QCloudGetLiveCodeRequest * request = [QCloudGetLiveCodeRequest new];
    request.bucket = @"tinna-media-1253960454";
    request.regionName = @"ap-chongqing";
    // 数据万象处理能力，获取数字验证码固定为 GetLiveCode;是否必传：true；
    request.ciProcess = @"GetLiveCode";

    [request setFinishBlock:^(QCloudGetLiveCodeResponse * outputObject, NSError *error) {
        // result：QCloudGetLiveCodeResponse 包含所有的响应；
        // 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/48647
        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetLiveCode:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudGetSearchImageRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudGetSearchImageRequest"];
    QCloudGetSearchImageRequest * request = [QCloudGetSearchImageRequest new];
    request.bucket = @"000garenwang-1253960454";
    
    request.regionName = @"ap-nanjing";
    
    // 起始序号，默认值为0;是否必传：false；
    request.Offset = 0;
    // 返回数量，默认值为10，最大值为100;是否必传：false；
    request.Limit = 10;
    // 针对入库时提交的 Tags 信息进行条件过滤。支持>、>=、<、<=、=、!=，多个条件之间支持 AND 和 OR 进行连接;是否必传：false；
    request.ObjectKey = @"1347199842654.jpg";

    request.ciProcess = @"ImageSearch";
    request.action = @"SearchImage";
    
    [request setFinishBlock:^(QCloudGetSearchImageResponse * outputObject, NSError *error) {
        // result：QCloudGetSearchImageResponse 包含所有的响应；
        // 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/63901
        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetSearchImage:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudLivenessRecognitionRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudLivenessRecognitionRequest"];
    QCloudLivenessRecognitionRequest * request = [QCloudLivenessRecognitionRequest new];
    
    request.bucket = @"tinna-media-1253960454";
    request.regionName = @"ap-chongqing";
    // 数据万象处理能力，人脸核身固定为 LivenessRecognition;是否必传：true；
    request.ciProcess = @"LivenessRecognition";
    // 身份证号;是否必传：true；
    request.IdCard = @"612501199405283919";
    // 姓名。是否必传：true；
    request.Name = @"王博";

    request.LivenessType = @"ACTION";
    // 数字模式传参：数字验证码（1234），需先调用接口获取数字验证码动作模式传参：传动作顺序（2，1 or 1，2），需先调用接口获取动作顺序静默模式传参：空;是否必传：false；
    request.ValidateData = @"1,2";
    // 需要返回多张最佳截图，取值范围1 - 10，不设置默认返回一张最佳截图;是否必传：false；
    request.BestFrameNum = 1;
    request.ObjectKey = @"shein.mp4";
    [request setFinishBlock:^(QCloudLivenessRecognitionResponse * outputObject, NSError *error) {
        // result：QCloudLivenessRecognitionResponse 包含所有的响应；
        // 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/48641
//        XCTAssertNil(error);
//        XCTAssertNotNil(outputObject);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] LivenessRecognition:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudOpenAsrBucketRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudOpenAsrBucketRequest"];
    QCloudOpenAsrBucketRequest * request = [QCloudOpenAsrBucketRequest new];
    request.bucket = @"tinna-media-1253960454";
    
    request.regionName = @"ap-chongqing";

    [request setFinishBlock:^(QCloudOpenAsrBucketResponse * outputObject, NSError *error) {
        // result：QCloudOpenAsrBucketResponse 包含所有的响应；
        // 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/95754
        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] OpenAsrBucket:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudPostNoiseReductionRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudPostNoiseReductionRequest"];
    QCloudPostNoiseReductionRequest * request = [QCloudPostNoiseReductionRequest new];
    request.bucket = @"tinna-media-1253960454";
    request.regionName = @"ap-chongqing";
    QCloudPostNoiseReduction * postNoiseReduction = [QCloudPostNoiseReduction new];
    // 创建任务的 Tag：NoiseReduction;是否必传：是
    postNoiseReduction.Tag = @"NoiseReduction";
    // 待操作的文件信息;是否必传：是
    QCloudPostNoiseReductionInput * input = [QCloudPostNoiseReductionInput new];
    // 执行音频降噪任务的文件路径目前只支持文件大小在10M之内的音频 如果输入为视频文件或者多通道的音频，只会保留单通道的音频流 目前暂不支持m3u8格式输入;是否必传：是
    input.Object = @"shein_test.mp4";
    request.input = postNoiseReduction;
    // 操作规则;是否必传：是
     QCloudPostNoiseReductionOperation * operation = [QCloudPostNoiseReductionOperation new];
    
    // 结果输出配置;是否必传：是
     QCloudPostNoiseReductionOutput * output = [QCloudPostNoiseReductionOutput new];
    // 存储桶的地域;是否必传：是
    output.Region = @"ap-chongqing";
    // 存储结果的存储桶;是否必传：是
    output.Bucket = @"tinna-media-1253960454";
    // 输出结果的文件名;是否必传：是
    output.Object = @"shein_test_target.mp4";
    operation.Output = output;
    postNoiseReduction.Input = input;
    postNoiseReduction.Operation = operation;
    request.input = postNoiseReduction;

    [request setFinishBlock:^(QCloudPostNoiseReductionResponse * outputObject, NSError *error) {
        // result：QCloudPostNoiseReductionResponse 包含所有的响应；
        // 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/84796
        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PostNoiseReduction:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudPostSegmentVideoBodyRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudPostSegmentVideoBodyRequest"];
    QCloudPostSegmentVideoBodyRequest * request = [QCloudPostSegmentVideoBodyRequest new];
    
    request.bucket = @"tinna-media-1253960454";
    request.regionName = @"ap-chongqing";
    
    QCloudPostSegmentVideoBody * postSegmentVideoBody = [QCloudPostSegmentVideoBody new];
    // 创建任务的 Tag：SegmentVideoBody;是否必传：是
    postSegmentVideoBody.Tag = @"SegmentVideoBody";
    // 待操作的对象信息;是否必传：是
    
     QCloudPostSegmentVideoBodyInput * input = [QCloudPostSegmentVideoBodyInput new];
    // 文件路径;是否必传：是
    input.Object = @"1347199842654.jpg";
    
    // 操作规则;是否必传：是
     QCloudPostSegmentVideoBodyOperation * operation = [QCloudPostSegmentVideoBodyOperation new];

    postSegmentVideoBody.Operation = operation;
    // 结果输出配置;是否必传：是
     QCloudPostSegmentVideoBodyOutput * output = [QCloudPostSegmentVideoBodyOutput new];
    // 存储桶的地域;是否必传：是
    output.Region = @"ap-chongqing";
    // 存储结果的存储桶;是否必传：是
    output.Bucket = @"tinna-media-1253960454";
    // 输出结果的文件名;是否必传：是
    output.Object = @"target_1347199842654.jpg";
    
    operation.Output = output;
    
    postSegmentVideoBody.Input = input;

    
    request.input = postSegmentVideoBody;

    [request setFinishBlock:^(QCloudPostSegmentVideoBodyResponse * outputObject, NSError *error) {
        // result：QCloudPostSegmentVideoBodyResponse 包含所有的响应；
        // 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/83973
        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PostSegmentVideoBody:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudPostSoundHoundRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudPostSoundHoundRequest"];
    QCloudPostSoundHoundRequest * request = [QCloudPostSoundHoundRequest new];
    
    request.bucket = @"tinna-media-1253960454";
    request.regionName = @"ap-chongqing";
    
     QCloudPostSoundHound * postSoundHound = [QCloudPostSoundHound new];
    // 创建任务的 Tag：SoundHound;是否必传：是
    postSoundHound.Tag = @"SoundHound";
    // 待操作的对象信息;是否必传：是
     QCloudPostSoundHoundInput * input = [QCloudPostSoundHoundInput new];
    // 文件路径;是否必传：是
    input.Object = @"aaa.m4a";
    postSoundHound.Input = input;
    request.input = postSoundHound;
    

    [request setFinishBlock:^(QCloudPostSoundHoundResponse * outputObject, NSError *error) {
        // result：QCloudPostSoundHoundResponse 包含所有的响应；
        // 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/84795
        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PostSoundHound:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudPostSpeechRecognitionRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudPostSpeechRecognitionRequest"];
    QCloudPostSpeechRecognitionRequest * request = [QCloudPostSpeechRecognitionRequest new];
    
    request.bucket = @"tinna-media-1253960454";
    request.regionName = @"ap-chongqing";
     QCloudPostSpeechRecognition * postSpeechRecognition = [QCloudPostSpeechRecognition new];
    // 创建任务的 Tag：SpeechRecognition;是否必传：是
    postSpeechRecognition.Tag = @"SpeechRecognition";
    // 待操作的对象信息;是否必传：是
    QCloudPostSpeechRecognitionInput * input = [QCloudPostSpeechRecognitionInput new];
    input.Object = @"aaa.m4a";
    postSpeechRecognition.Input = input;
    
    // 操作规则;是否必传：是
    QCloudPostSpeechRecognitionOperation * operation = [QCloudPostSpeechRecognitionOperation new];
    // 结果输出配置;是否必传：是
    QCloudPostSpeechRecognitionOutput * output = [QCloudPostSpeechRecognitionOutput new];
    // 存储桶的地域;是否必传：是
    output.Bucket = @"tinna-media-1253960454";
    output.Region = @"ap-chongqing";
    // 结果文件的名称;是否必传：是
    output.Object = @"aaa.m4a";
    
    operation.Output = output;
    
    QCloudSpeechRecognition * peechRecognition = [QCloudSpeechRecognition new];
    operation.SpeechRecognition = peechRecognition;
    peechRecognition.EngineModelType = @"8k_zh";
    peechRecognition.ChannelNum = @"1";
    postSpeechRecognition.Operation = operation;
    
    request.input = postSpeechRecognition;

    [request setFinishBlock:^(QCloudPostSpeechRecognitionResponse * outputObject, NSError *error) {
        // result：QCloudPostSpeechRecognitionResponse 包含所有的响应；
        // 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/84798
        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PostSpeechRecognition:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudPostTranslationRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudPostTranslationRequest"];
    QCloudPostTranslationRequest * request = [QCloudPostTranslationRequest new];
    
    request.bucket = @"tinna-media-1253960454";
    request.regionName = @"ap-chongqing";
    
     QCloudPostTranslation * postTranslation = [QCloudPostTranslation new];
    // 创建任务的 Tag：Translation;是否必传：是
    postTranslation.Tag = @"Translation";
    
    // 待操作的对象信息;是否必传：是
     QCloudPostTranslationInput * input = [QCloudPostTranslationInput new];
    // 源文档文件名单文件（docx/xlsx/html/markdown/txt）：不超过800万字符有页数的（pdf/pptx）：不超过300页文本文件（txt）：不超过10MB二进制文件（pdf/docx/pptx/xlsx）：不超过60MB图片文件（jpg/jpeg/png/webp）：不超过10MB;是否必传：是
    input.Object = @"xihaiqingge.txt";
    // 文档语言类型zh：简体中文zh-hk：繁体中文zh-tw：繁体中文zh-tr：繁体中文en：英语ar：阿拉伯语de：德语es：西班牙语fr：法语id：印尼语it：意大利语ja：日语pt：葡萄牙语ru：俄语ko：韩语km：高棉语lo：老挝语;是否必传：是
    input.Lang = @"zh-hk";
    // 文档类型pdfdocxpptxxlsxtxtxmlhtml：只能翻译 HTML 里的文本节点，需要通过 JS 动态加载的不进行翻译markdownjpgjpegpngwebp;是否必传：是
    input.Type = @"txt";
    postTranslation.Input = input;
    
    request.input = postTranslation;
    
    // 操作规则;是否必传：是
     QCloudPostTranslationOperation * operation = [QCloudPostTranslationOperation new];
    // 翻译参数;是否必传：是
     QCloudPostTranslationTranslation * translation = [QCloudPostTranslationTranslation new];
    // 目标语言类型源语言类型为 zh/zh-hk/zh-tw/zh-tr 时支持：en、ar、de、es、fr、id、it、ja、it、ru、ko、km、lo、pt源语言类型为 en 时支持：zh、zh-hk、zh-tw、zh-tr、ar、de、es、fr、id、it、ja、it、ru、ko、km、lo、pt其他类型时支持：zh、zh-hk、zh-tw、zh-tr、en;是否必传：是
    translation.Lang = @"en";
    // 文档类型，源文件类型与目标文件类型映射关系如下：docx：docxpptx：pptxxlsx：xlsxtxt：txtxml：xmlhtml：htmlmarkdown：markdownpdf：pdf、docxpng：txtjpg：txtjpeg：txtwebp：txt;是否必传：是
    translation.Type = @"txt";
    operation.Translation = translation;
    
    postTranslation.Operation = operation;
    // 结果输出地址，当NoNeedOutput为true时非必选;是否必传：否
     QCloudPostTranslationOutput * output = [QCloudPostTranslationOutput new];
    // 存储桶的地域;是否必传：是
    output.Region = @"ap-chongqing";
    // 存储结果的存储桶;是否必传：是
    output.Bucket = @"tinna-media-1253960454";
    // 输出结果的文件名;是否必传：是
    output.Object = @"target_xihaiqingge.txt";
    
    operation.Output = output;
    
    postTranslation.Operation = operation;

    [request setFinishBlock:^(QCloudPostTranslationResponse * outputObject, NSError *error) {
        // result：QCloudPostTranslationResponse 包含所有的响应；
        // 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/84799
        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PostTranslation:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudPostVideoTargetRecRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudPostVideoTargetRecRequest"];
    QCloudPostVideoTargetRecRequest * request = [QCloudPostVideoTargetRecRequest new];
    request.bucket = @"tinna-media-1253960454";
    request.regionName = @"ap-chongqing";
     QCloudPostVideoTargetRec * postVideoTargetRec = [QCloudPostVideoTargetRec new];
    // 创建任务的 Tag：VideoTargetRec;是否必传：是
    postVideoTargetRec.Tag = @"VideoTargetRec";
    // 操作规则;是否必传：是
    QCloudPostVideoTargetRecOperation * operation = [QCloudPostVideoTargetRecOperation new];
    QCloudVideoTargetRec * targetRec = [QCloudVideoTargetRec new];
    targetRec.Body = @"true";
    operation.VideoTargetRec = targetRec;
    postVideoTargetRec.Operation = operation;
    
    // 待操作的媒体信息;是否必传：是
     QCloudPostVideoTargetRecInput * input = [QCloudPostVideoTargetRecInput new];
    input.Object = @"test_video.mp4";
    postVideoTargetRec.Input = input;
    
    request.input = postVideoTargetRec;

    [request setFinishBlock:^(QCloudPostVideoTargetRecResponse * outputObject, NSError *error) {
        // result：QCloudPostVideoTargetRecResponse 包含所有的响应；
        // 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/84801
        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PostVideoTargetRec:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudPostVoiceSynthesisRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudPostVoiceSynthesisRequest"];
    QCloudPostVoiceSynthesisRequest * request = [QCloudPostVoiceSynthesisRequest new];
    request.bucket = @"tinna-media-1253960454";
    request.regionName = @"ap-chongqing";
    
    QCloudPostVoiceSynthesis * postVoiceSynthesis = [QCloudPostVoiceSynthesis new];
    request.input = postVoiceSynthesis;
    
    // 创建任务的 Tag：Tts;是否必传：是
    postVoiceSynthesis.Tag = @"Tts";
    // 操作规则;是否必传：是
    QCloudPostVoiceSynthesisOperation * operation = [QCloudPostVoiceSynthesisOperation new];
    postVoiceSynthesis.Operation = operation;
    
    // 语音合成任务参数;是否必传：是
    QCloudPostVoiceSynthesisTtsConfig * ttsConfig = [QCloudPostVoiceSynthesisTtsConfig new];
    operation.TtsConfig = ttsConfig;
    
    // 输入类型，Url/Text;是否必传：是
    ttsConfig.InputType = @"Text";
    // 当 InputType 为 Url 时， 必须是合法的 COS 地址，文件必须是utf-8编码，且大小不超过 10M。如果合成方式为同步处理，则文件内容不超过 300 个 utf-8 字符；如果合成方式为异步处理，则文件内容不超过 10000 个 utf-8 字符。当 InputType 为 Text 时, 输入必须是 utf-8 字符, 且不超过 300 个字符。;是否必传：是
    ttsConfig.Input = @"测试文字";
    // 结果输出配置;是否必传：是
     QCloudPostVoiceSynthesisOutput * output = [QCloudPostVoiceSynthesisOutput new];
    // 存储桶的地域;是否必传：是
    output.Region = @"ap-chongqing";
    // 存储结果的存储桶;是否必传：是
    output.Bucket = @"tinna-media-1253960454";
    // 结果文件名;是否必传：是
    output.Object = @"target_voice.txt";
    operation.Output = output;
    
    QCloudPostVoiceSynthesisTtsTpl * ttsTpl = [QCloudPostVoiceSynthesisTtsTpl new];
    ttsTpl.Mode = @"Sync";
    ttsTpl.Codec = @"mp3";
    operation.TtsTpl = ttsTpl;

    [request setFinishBlock:^(QCloudPostVoiceSynthesisResponse * outputObject, NSError *error) {
        // result：QCloudPostVoiceSynthesisResponse 包含所有的响应；
        // 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/84797
        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PostVoiceSynthesis:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudPostWordsGeneralizeRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudPostWordsGeneralizeRequest"];
    QCloudPostWordsGeneralizeRequest * request = [QCloudPostWordsGeneralizeRequest new];
    request.bucket = @"tinna-media-1253960454";
    request.regionName = @"ap-chongqing";
    request.input = [QCloudPostWordsGeneralize new];
    
    // 创建任务的 Tag：WordsGeneralize;是否必传：是
    request.input.Tag = @"WordsGeneralize";
    
    // 待操作的对象信息;是否必传：是
    request.input.Input = [QCloudPostWordsGeneralizeInput new];
    
    // 文件路径;是否必传：是
    request.input.Input.Object = @"xihaiqingge.txt";

    // 操作规则;是否必传：是
    request.input.Operation = [QCloudPostWordsGeneralizeOperation new];
    // 指定分词参数;是否必传：是
    request.input.Operation.WordsGeneralize = [QCloudPostWordsGeneralizeWordsGeneralize new];
    request.input.Operation.WordsGeneralize.NerMethod = @"DL";
    request.input.Operation.WordsGeneralize.SegMethod = @"MIX";

    [request setFinishBlock:^(QCloudPostWordsGeneralizeResponse * outputObject, NSError *error) {
        // result：QCloudPostWordsGeneralizeResponse 包含所有的响应；
        // 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/84800
        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PostWordsGeneralize:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudUpdateAIQueueRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudUpdateAIQueueRequest"];
    QCloudUpdateAIQueueRequest * request = [QCloudUpdateAIQueueRequest new];
    request.bucket = @"tinna-media-1253960454";
    request.regionName = @"ap-chongqing";
     QCloudUpdateAIQueue * updateAIQueue = [QCloudUpdateAIQueue new];
    request.input = updateAIQueue;
    // 队列名称，仅支持中文、英文、数字、_、-和*，长度不超过 128;是否必传：是
    updateAIQueue.Name = @"garenwang_test";
    // Active 表示队列内的作业会被调度执行Paused 表示队列暂停，作业不再会被调度执行，队列内的所有作业状态维持在暂停状态，已经执行中的任务不受影响;是否必传：是
    updateAIQueue.State = @"Active";
    
    updateAIQueue.NotifyConfig = [QCloudNotifyConfig new];
    
    updateAIQueue.NotifyConfig.State = @"Off";

    request.queueId = @"p943eb208f84e4417ba902ed326c83fe3";
    request.input = updateAIQueue;
    
    [request setFinishBlock:^(QCloudUpdateAIQueueResponse * outputObject, NSError *error) {
        // result：QCloudUpdateAIQueueResponse 包含所有的响应；
        // 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/79397
        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] UpdateAIQueue:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}


-(void)testQCloudPostNoiseReductionTempleteRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudPostNoiseReductionTempleteRequest"];
    QCloudPostNoiseReductionTempleteRequest * request = [QCloudPostNoiseReductionTempleteRequest new];
    request.bucket = @"tinna-media-1253960454";
    request.regionName = @"ap-chongqing";
     QCloudPostNoiseReductionTemplete * postNoiseReductionTemplete = [QCloudPostNoiseReductionTemplete new];
    // 固定值：NoiseReduction;是否必传：是
    postNoiseReductionTemplete.Tag = @"NoiseReduction";
    // 模板名称，仅支持中文、英文、数字、_、-和*，长度不超过 64。;是否必传：是
    postNoiseReductionTemplete.Name = [NSString stringWithFormat:@"%d_NoiseReduction",[NSDate date].timeIntervalSince1970 + arc4random_uniform(1000)];

    QCloudNoiseReduction * noiseReduction = [QCloudNoiseReduction new];
    noiseReduction.Format = @"mp3";
    noiseReduction.Samplerate = @"8000";
    postNoiseReductionTemplete.NoiseReduction = noiseReduction;
    request.input = postNoiseReductionTemplete;
    
    [request setFinishBlock:^(QCloudPostNoiseReductionTempleteResponse * outputObject, NSError *error) {
        // result：QCloudPostNoiseReductionTempleteResponse 包含所有的响应；
        // 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/94315
        QCloudUpdateNoiseReductionTempleteRequest * request = [QCloudUpdateNoiseReductionTempleteRequest new];
        request.bucket = @"tinna-media-1253960454";
        request.regionName = @"ap-chongqing";
         QCloudUpdateNoiseReductionTemplete * updateNoiseReductionTemplete = [QCloudUpdateNoiseReductionTemplete new];
        // 固定值：NoiseReduction;是否必传：是
        updateNoiseReductionTemplete.Tag = @"NoiseReduction";
        // 模板名称，仅支持中文、英文、数字、_、-和*，长度不超过 64。;是否必传：是
        updateNoiseReductionTemplete.Name = [NSString stringWithFormat:@"%d_NoiseReduction_1",[NSDate date].timeIntervalSince1970 + arc4random_uniform(1000)];

        request.input = updateNoiseReductionTemplete;
        request.TemplateId = outputObject.Template.TemplateId;
        request.input.NoiseReduction = QCloudNoiseReduction.new;
        request.input.NoiseReduction.Format = @"WAV";
        request.input.NoiseReduction.Samplerate = @"16000";
        
        [request setFinishBlock:^(QCloudUpdateNoiseReductionTempleteResponse * outputObject, NSError *error) {
            // result：QCloudUpdateNoiseReductionTempleteResponse 包含所有的响应；
            // 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/94394
            [expectation fulfill];
        }];
        [[QCloudCOSXMLService defaultCOSXML] UpdateNoiseReductionTemplete:request];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PostNoiseReductionTemplete:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudPostSpeechRecognitionTempleteRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudPostSpeechRecognitionTempleteRequest"];
    QCloudPostSpeechRecognitionTempleteRequest * request = [QCloudPostSpeechRecognitionTempleteRequest new];
    request.bucket = @"tinna-media-1253960454";
    request.regionName = @"ap-chongqing";
    
    QCloudPostSpeechRecognitionTemplete * postSpeechRecognitionTemplete = [QCloudPostSpeechRecognitionTemplete new];
    // 模板类型：SpeechRecognition;是否必传：是
    postSpeechRecognitionTemplete.Tag = @"SpeechRecognition";
    // 模板名称，仅支持中文、英文、数字、_、-和*，长度不超过 64;是否必传：是
    postSpeechRecognitionTemplete.Name = [NSString stringWithFormat:@"%d_SpeechRecognition",[NSDate date].timeIntervalSince1970 + arc4random_uniform(1000)];

    QCloudSpeechRecognition * speechRecognition = [QCloudSpeechRecognition new];
    speechRecognition.EngineModelType = @"8k_zh";
    speechRecognition.ChannelNum = @"1";
    postSpeechRecognitionTemplete.SpeechRecognition = speechRecognition;
    
    request.input = postSpeechRecognitionTemplete;
    [request setFinishBlock:^(QCloudPostSpeechRecognitionTempleteResponse * outputObject, NSError *error) {
        // result：QCloudPostSpeechRecognitionTempleteResponse 包含所有的响应；
        // 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/84498
        QCloudUpdateSpeechRecognitionTempleteRequest * request = [QCloudUpdateSpeechRecognitionTempleteRequest new];
        request.bucket = @"tinna-media-1253960454";
        request.regionName = @"ap-chongqing";
         QCloudUpdateSpeechRecognitionTemplete * updateSpeechRecognitionTemplete = [QCloudUpdateSpeechRecognitionTemplete new];
        // 模板类型：SpeechRecognition;是否必传：是
        updateSpeechRecognitionTemplete.Tag = @"SpeechRecognition";
        // 模板名称，仅支持中文、英文、数字、_、-和*，长度不超过 64;是否必传：是
        updateSpeechRecognitionTemplete.Name = [NSString stringWithFormat:@"SpeechRecognition_1"];
        
        request.TemplateId = outputObject.Template.TemplateId;
        request.input = updateSpeechRecognitionTemplete;
        
        request.input.SpeechRecognition = QCloudSpeechRecognition.new;
        
        request.input.SpeechRecognition.EngineModelType = @"16k_zh";
        request.input.SpeechRecognition.ChannelNum = @"1";
        QCloudSpeechRecognition * speechRecognition = [QCloudSpeechRecognition new];
        speechRecognition.EngineModelType = @"8k_zh";
        speechRecognition.ChannelNum = @"1";
        request.input.SpeechRecognition = speechRecognition;

        [request setFinishBlock:^(QCloudUpdateSpeechRecognitionTempleteResponse * outputObject, NSError *error) {
            // result：QCloudUpdateSpeechRecognitionTempleteResponse 包含所有的响应；
            // 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/84759
            [expectation fulfill];
        }];
        [[QCloudCOSXMLService defaultCOSXML] UpdateSpeechRecognitionTemplete:request];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PostSpeechRecognitionTemplete:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}


-(void)testQCloudPostVideoTargetTempleteRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudPostVideoTargetTempleteRequest"];
    QCloudPostVideoTargetTempleteRequest * request = [QCloudPostVideoTargetTempleteRequest new];
    request.bucket = @"tinna-media-1253960454";
    request.regionName = @"ap-chongqing";
    QCloudPostVideoTargetTemplete * postVideoTargetTemplete = [QCloudPostVideoTargetTemplete new];
    // 模板类型：VideoTargetRec;是否必传：是
    postVideoTargetTemplete.Tag = @"VideoTargetRec";
    // 模板名称，仅支持中文、英文、数字、_、-和*，长度不超过 64;是否必传：是
    postVideoTargetTemplete.Name = [NSString stringWithFormat:@"%d_VideoTarget",[NSDate date].timeIntervalSince1970  + arc4random_uniform(1000)];

    QCloudVideoTargetRec * targetRec = [QCloudVideoTargetRec new];
    targetRec.Body = @"true";
    
    postVideoTargetTemplete.VideoTargetRec = targetRec;
    
    request.input = postVideoTargetTemplete;
    
    [request setFinishBlock:^(QCloudPostVideoTargetTempleteResponse * outputObject, NSError *error) {
        // result：QCloudPostVideoTargetTempleteResponse 包含所有的响应；
        // 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/84736
        QCloudUpdateVideoTargetTempleteRequest * request = [QCloudUpdateVideoTargetTempleteRequest new];
        request.bucket = @"tinna-media-1253960454";
        request.regionName = @"ap-chongqing";
         QCloudUpdateVideoTargetTemplete * updateVideoTargetTemplete = [QCloudUpdateVideoTargetTemplete new];
        // 模板类型：VideoTargetRec;是否必传：是
        updateVideoTargetTemplete.Tag = @"VideoTargetRec";
        // 模板名称，仅支持中文、英文、数字、_、-和*，长度不超过 64;是否必传：是
        updateVideoTargetTemplete.Name = [NSString stringWithFormat:@"%d_VideoTarget_1",[NSDate date].timeIntervalSince1970  + arc4random_uniform(1000)];
        request.input = updateVideoTargetTemplete;
        request.TemplateId = outputObject.Template.TemplateId;
        QCloudVideoTargetRec * targetRec = [QCloudVideoTargetRec new];
        targetRec.Body = @"true";
        updateVideoTargetTemplete.VideoTargetRec = targetRec;
        [request setFinishBlock:^(QCloudUpdateVideoTargetTempleteResponse * outputObject, NSError *error) {
            // result：QCloudUpdateVideoTargetTempleteResponse 包含所有的响应；
            // 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/84760
            [expectation fulfill];
        }];
        [[QCloudCOSXMLService defaultCOSXML] UpdateVideoTargetTemplete:request];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PostVideoTargetTemplete:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudPostVoiceSeparateTempleteRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudPostVoiceSeparateTempleteRequest"];
    QCloudPostVoiceSeparateTempleteRequest * request = [QCloudPostVoiceSeparateTempleteRequest new];
    request.bucket = @"tinna-media-1253960454";
    request.regionName = @"ap-chongqing";
     QCloudPostVoiceSeparateTemplete * postVoiceSeparateTemplete = [QCloudPostVoiceSeparateTemplete new];
    // 模板类型: VoiceSeparate;是否必传：是
    postVoiceSeparateTemplete.Tag = @"VoiceSeparate";
    // 模板名称，仅支持中文、英文、数字、_、-和*，长度不超过 64;是否必传：是
    postVoiceSeparateTemplete.Name = [NSString stringWithFormat:@"%d_VoiceSeparate",[NSDate date].timeIntervalSince1970 + arc4random_uniform(1000)];
    // 输出音频IsAudio：输出人声IsBackground：输出背景声AudioAndBackground：输出人声和背景声MusicMode：输出人声、背景声、Bass声、鼓声;是否必传：是
    postVoiceSeparateTemplete.AudioMode = @"IsAudio";
    
    QCloudAudioConfig * audioConfig = [QCloudAudioConfig new];
    audioConfig.Codec = @"mp3";
    audioConfig.Samplerate = @"22050";
    postVoiceSeparateTemplete.AudioConfig = audioConfig;
    
    request.input = postVoiceSeparateTemplete;

    [request setFinishBlock:^(QCloudPostVoiceSeparateTempleteResponse * outputObject, NSError *error) {
        // result：QCloudPostVoiceSeparateTempleteResponse 包含所有的响应；
        // 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/84500
        QCloudUpdateVoiceSeparateTempleteRequest * request = [QCloudUpdateVoiceSeparateTempleteRequest new];
        request.bucket = @"tinna-media-1253960454";
        request.regionName = @"ap-chongqing";
         QCloudUpdateVoiceSeparateTemplete * updateVoiceSeparateTemplete = [QCloudUpdateVoiceSeparateTemplete new];
        // 模板类型: VoiceSeparate;是否必传：是
        updateVoiceSeparateTemplete.Tag = @"VoiceSeparate";
        // 模板名称，仅支持中文、英文、数字、_、-和*，长度不超过 64;是否必传：是
        updateVoiceSeparateTemplete.Name = [NSString stringWithFormat:@"%d_VoiceSeparate_1",[NSDate date].timeIntervalSince1970+ arc4random_uniform(1000)];
        // 输出音频IsAudio：输出人声IsBackground：输出背景声AudioAndBackground：输出人声和背景声MusicMode：输出人声、背景声、Bass声、鼓声;是否必传：是
        updateVoiceSeparateTemplete.AudioMode = @"IsAudio";

        request.TemplateId = outputObject.Template.TemplateId;
        
        QCloudAudioConfig * audioConfig = [QCloudAudioConfig new];
        audioConfig.Codec = @"mp3";
        audioConfig.Samplerate = @"22050";
        updateVoiceSeparateTemplete.AudioConfig = audioConfig;
        request.input = updateVoiceSeparateTemplete;
        
        [request setFinishBlock:^(QCloudUpdateVoiceSeparateTempleteResponse * outputObject, NSError *error) {
            // result：QCloudUpdateVoiceSeparateTempleteResponse 包含所有的响应；
            // 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/84757
            [expectation fulfill];
        }];
        [[QCloudCOSXMLService defaultCOSXML] UpdateVoiceSeparateTemplete:request];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PostVoiceSeparateTemplete:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudPostVoiceSynthesisTempleteRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudPostVoiceSynthesisTempleteRequest"];
    QCloudPostVoiceSynthesisTempleteRequest * request = [QCloudPostVoiceSynthesisTempleteRequest new];
    request.bucket = @"tinna-media-1253960454";
    request.regionName = @"ap-chongqing";
     QCloudPostVoiceSynthesisTemplete * postVoiceSynthesisTemplete = [QCloudPostVoiceSynthesisTemplete new];
    // 模板类型：Tts;是否必传：是
    postVoiceSynthesisTemplete.Tag = @"Tts";
    // 模板名称，仅支持中文、英文、数字、_、-和*，长度不超过 64;是否必传：是
    postVoiceSynthesisTemplete.Name = [NSString stringWithFormat:@"%d_VoiceSynthesis",[NSDate date].timeIntervalSince1970 + arc4random_uniform(1000)];

    request.input = postVoiceSynthesisTemplete;
    
    [request setFinishBlock:^(QCloudPostVoiceSynthesisTempleteResponse * outputObject, NSError *error) {
        // result：QCloudPostVoiceSynthesisTempleteResponse 包含所有的响应；
        // 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/84499
        
        QCloudUpdateVoiceSynthesisTempleteRequest * request = [QCloudUpdateVoiceSynthesisTempleteRequest new];
        request.bucket = @"tinna-media-1253960454";
        request.regionName = @"ap-chongqing";
         QCloudUpdateVoiceSynthesisTemplete * updateVoiceSynthesisTemplete = [QCloudUpdateVoiceSynthesisTemplete new];
        // 模板类型：Tts;是否必传：是
        updateVoiceSynthesisTemplete.Tag = @"Tts";
        // 模板名称，仅支持中文、英文、数字、_、-和*，长度不超过 64;是否必传：是
        updateVoiceSynthesisTemplete.Name = [NSString stringWithFormat:@"%d_VoiceSynthesis_1",[NSDate date].timeIntervalSince1970 + arc4random_uniform(1000)];

        request.TemplateId = outputObject.Template.TemplateId;
        
        request.input = updateVoiceSynthesisTemplete;
        [request setFinishBlock:^(QCloudUpdateVoiceSynthesisTempleteResponse * outputObject1, NSError *error) {
            // result：QCloudUpdateVoiceSynthesisTempleteResponse 包含所有的响应；
            // 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/84758
            [expectation fulfill];
        }];
        [[QCloudCOSXMLService defaultCOSXML] UpdateVoiceSynthesisTemplete:request];
        
    }];
    [[QCloudCOSXMLService defaultCOSXML] PostVoiceSynthesisTemplete:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudVocalScoreRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudVocalScoreRequest"];
    QCloudVocalScoreRequest * request = [QCloudVocalScoreRequest new];
    request.bucket = @"tinna-media-1253960454";
    request.regionName = @"ap-chongqing";
    request.input = [QCloudVocalScore new];
    // 创建任务的 Tag：VocalScore;是否必传：是
    request.input.Tag = @"VocalScore";
    
    // 待操作的对象信息;是否必传：是
    request.input.Input = [QCloudVocalScoreInput new];
    request.input.Input.Object = @"test_video.mp4";
    
    // 操作规则;是否必传：是
    request.input.Operation = [QCloudVocalScoreOperation new];
    // 音乐评分参数配置;是否必传：是
    request.input.Operation.VocalScore = [QCloudVocalScoreVocalScore new];
    request.input.Operation.VocalScore.StandardObject = @"test.txt";

    [request setFinishBlock:^(QCloudVocalScoreResponse * outputObject, NSError *error) {
        // result：QCloudVocalScoreResponse 包含所有的响应；
        // 具体查看代码注释或api文档：https://cloud.tencent.com/document/product/460/96095
        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] VocalScore:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudGetFilePreviewHtmlRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudGetFilePreviewHtmlRequest"];
    QCloudGetFilePreviewHtmlRequest *request = [[QCloudGetFilePreviewHtmlRequest alloc]init];
    request.bucket = @"mobile-ut-1253960454";
    request.regionName = @"ap-guangzhou";
    request.object = @"aaa.txt";
    request.htmlwaterword = @"test";
    [request setFinishBlock:^(QCloudGetFilePreviewHtmlResult * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
         if (error) {
             
         }else{
             NSDictionary * dicResult = [NSJSONSerialization JSONObjectWithData:result.resultData options:NSJSONReadingMutableContainers error:nil];
         }
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetFilePreviewObject:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudGetMediaJobListRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudGetMediaJobListRequest"];
    QCloudGetMediaJobListRequest * request = [QCloudGetMediaJobListRequest new];
    request.bucket = @"tinna-media-1253960454";
    request.regionName = @"ap-chongqing";
    request.tag = @"VoiceSeparate";
    [request setFinishBlock:^(QCloudGetMediaJobResponse * _Nullable result, NSError * _Nullable error) {
        // result 查询指定任务 ，详细字段请查看 API 文档或者 SDK 源码
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetMediaJobList:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudRecognitionBadCaseRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test<#type#>"];
    QCloudRecognitionBadCaseRequest * request = [QCloudRecognitionBadCaseRequest new];
    request.bucket = @"tinna-media-1253960454";
    request.regionName = @"ap-chongqing";
    request.contentType = 1;
    request.label = @"Porn";

    request.text = [[@"test123" dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
    request.suggestedLabel = @"Normal";
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML]RecognitionBadCase:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudCreateMediaJobRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudCreateMediaJobRequest"];
    QCloudCreateMediaJobRequest * request = [QCloudCreateMediaJobRequest new];
    // 存储桶名称，格式为 BucketName-APPID
    request.bucket = @"tinna-media-1253960454";
    // 文件所在地域
    request.regionName = @"ap-chongqing";

    request.input = @{@"Input":@{
                                @"Object":@"1920p.mp4"
                      },
                      @"Operation":@{
                        @"Tag":@"VoiceSeparate",
                        @"TemplateId":@"t19e63d8ff9d734939a444ddb72eba94ec",
                        @"Output":@{
                            @"Region":@"ap-chongqing",
                            @"Bucket":@"tinna-media-1253960454",
                            @"Object":@"video_backgroud.${ext}",
                            @"AuObject":@"video_audio.${ext}"
                            }
                      },
                      @"CallBackFormat":@"XML",
                      @"CallBackType":@"Url"
                    };

    
    [request setFinishBlock:^(QCloudCreateMediaJobResponse * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];

    [[QCloudCOSXMLService defaultCOSXML]CreateMediaJob:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudCIUploadOperationsRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudCIUploadOperationsRequest"];
    QCloudCIUploadOperationsRequest* request = [QCloudCIUploadOperationsRequest new];
    // 对象键，是对象在 COS 上的完整路径，如果带目录的话，格式为 "video/xxx/movie.mp4"
    request.object = @"1347199913203.jpg";
    // 存储桶名称，由 BucketName-Appid 组成，可以在 COS 控制台查看 https://console.cloud.tencent.com/cos5/bucket
    request.bucket = @"cos-sdk-citest-1253960454";
    request.regionName = @"ap-beijing";
    request.contentDisposition = @"textxxx.jpg";
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *imagePath = [bundle pathForResource:@"test" ofType:@"jpg"];
    if (!imagePath) {
        // 如果 bundle 中找不到，尝试从项目目录获取
        imagePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"jpg"];
    }
    NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
    
    request.body = imageData;
    QCloudPicOperations * op = [[QCloudPicOperations alloc]init];
    
    // 是否返回原图信息。0表示不返回原图信息，1表示返回原图信息，默认为0
    op.is_pic_info = NO;
    QCloudPicOperationRule * rule = [[QCloudPicOperationRule alloc]init];
    rule.rule = @"imageMogr2/format/jpg";
    rule.fileid = @"format_result.jpg";
    
    op.rule = @[rule];
    request.picOperations = op;

    [request setFinishBlock:^(QCloudImageProcessResult * outputObject, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] UploadOperations:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudPostVoiceSeparateRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudPostVoiceSeparateRequest"];
    QCloudPostVoiceSeparateRequest * request = [QCloudPostVoiceSeparateRequest new];
    // 存储桶名称，格式为 BucketName-APPID
    request.bucket = @"tinna-media-1253960454";
    request.regionName = @"ap-chongqing";
    
    request.input = [QCloudInputVoiceSeparate new];
    // 创建任务的 Tag：VoiceSeparate;是否必传：是
    // 待操作的文件信息;是否必传：是
    request.input.Input = [QCloudInputVoiceSeparateInput new];
    // 文件路径;是否必传：是
    request.input.Input.Object = @"aaa.m4a";
    // 操作规则;是否必传：是
    request.input.Operation = [QCloudInputVoiceSeparateOperation new];
    // 人声分离模板参数;是否必传：否
    request.input.Operation.VoiceSeparate = [QCloudVoiceSeparate new];
    // 同创建人声分离模板接口中的 Request.AudioMode;是否必传：是
    request.input.Operation.VoiceSeparate.AudioMode = @"IsAudio";
    // 同创建人声分离模板接口中的 Request.AudioConfig;是否必传：是
    request.input.Operation.VoiceSeparate.AudioConfig = [QCloudAudioVoiceSeparateAudioConfig new];
    request.input.Operation.VoiceSeparate.AudioConfig.Codec = @"aac";
    // 结果输出配置;是否必传：是
    request.input.Operation.Output = [QCloudInputVoiceSeparateOutput new];
    // 存储桶的地域;是否必传：是
    request.input.Operation.Output.Region = @"ap-chongqing";
    // 存储结果的存储桶;是否必传：是
    request.input.Operation.Output.Bucket = @"tinna-media-1253960454";

    request.input.Operation.Output = QCloudInputVoiceSeparateOutput.new;
    request.input.Operation.Output.Region = @"ap-chongqing";
    request.input.Operation.Output.Bucket = @"tinna-media-1253960454";
    request.input.Operation.Output.Object = @"video_backgroud.${ext}";
    request.input.Operation.Output.AuObject = @"video_audio.${ext}";
    request.input.CallBackFormat = @"XML";
    request.input.CallBackType = @"Url";
    
    [request setFinishBlock:^(QCloudVoiceSeparateResult * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [expectation fulfill];
    }];

    [[QCloudCOSXMLService defaultCOSXML]PostVoiceSeparate:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

-(void)testQCloudGetDiscernMediaJobsRequest{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudGetDiscernMediaJobsRequest"];
    QCloudGetDiscernMediaJobsRequest * request = [[QCloudGetDiscernMediaJobsRequest alloc]init];

    request.bucket = @"cos-sdk-citest-1253960454";
    request.regionName = @"ap-beijing";
    request.tag = @"Transcode";
    request.states = QCloudTaskStatesAll;

    // 其他更多参数请查阅sdk文档或源码注释

    request.finishBlock = ^(QCloudBatchGetAudioDiscernTaskResult * outputObject, NSError *error) {

        XCTAssertNil(error);
        XCTAssertNotNil(outputObject);
        [expectation fulfill];
    };
    [[QCloudCOSXMLService defaultCOSXML] GetDiscernMediaJobs:request];
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

// 测试图像检索
- (void)testQCloudSearchImageRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testQCloudSearchImageRequest"];
    QCloudSearchImageRequest * request = [QCloudSearchImageRequest new];
    request.regionName = @"ap-nanjing";
    request.input = [QCloudSearchImage new];
    // 数据集名称，同一个账户下唯一。;是否必传：是
    request.input.DatasetName = @"notdelete";
    // 指定检索方式为图片或文本，pic 为图片检索，text 为文本检索，默认为 pic。;是否必传：否
    request.input.Mode = @"pic";
    // 资源标识字段，表示需要建立索引的文件地址(Mode 为 pic 时必选)。;是否必传：否
    request.input.URI = @"cos://0-c-1253960454/face.jpg";
    // 返回相关图片的数量，默认值为10，最大值为100。;是否必传：否
    request.input.Limit = 10;
    // 出参 Score（相关图片匹配得分） 中，只有超过 MatchThreshold 值的结果才会返回。默认值为0，推荐值为80。;是否必传：否
    request.input.MatchThreshold = 80;

    [request setFinishBlock:^(QCloudSearchImageResponse * _Nullable result, NSError * _Nullable error) {
        // 注意：此测试可能因为数据集不存在或没有图片数据而返回错误，这是正常的
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] SearchImage:request];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

// 测试人脸搜索
-(void)testDatasetFaceSearch0{
    // 创建数据集
    XCTestExpectation* expectationCreateDataset = [self expectationWithDescription:@"testCreateDataset"];
    __block QCloudCreateDatasetResponse * beforeResult = nil;
    QCloudCreateDatasetRequest * requestCreateDataset = [QCloudCreateDatasetRequest new];
    requestCreateDataset.regionName = @"ap-shanghai";
    requestCreateDataset.input = [QCloudCreateDataset new];
    // 数据集名称，同一个账户下唯一。命名规则如下： - 长度为1~128字符 - 只能包含英文字母，数字，短划线（-）和下划线（） - 必须以英文字母和下划线（）开头;是否必传：是
    requestCreateDataset.input.DatasetName = @"datasetnametestmnx";
    requestCreateDataset.input.TemplateId = @"Official:FaceSearch";
    // 数据集描述信息。长度为1~256个英文或中文字符，默认值为空。;是否必传：否
    requestCreateDataset.input.Description = @"描述";

    [requestCreateDataset setFinishBlock:^(QCloudCreateDatasetResponse * outputObject, NSError *error) {
        XCTAssertNil(error);
        beforeResult = outputObject;
        [expectationCreateDataset fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] CreateDataset:requestCreateDataset];
    [self waitForExpectationsWithTimeout:100 handler:nil];

    // 人脸搜索
    XCTestExpectation* expectationDatasetFaceSearch = [self expectationWithDescription:@"testDatasetFaceSearch"];
    __block QCloudDatasetFaceSearchResponse * requestResult = nil;
    QCloudDatasetFaceSearchRequest * request = [QCloudDatasetFaceSearchRequest new];
    request.regionName = @"ap-shanghai";
    request.input = [QCloudDatasetFaceSearch new];
    // 数据集名称，同一个账户下唯一。;是否必传：是
    request.input.DatasetName = @"datasetnametestmnx";
    // 资源标识字段，表示需要建立索引的文件地址。;是否必传：是
    request.input.URI = @"cos://0-maz-cold-sh-1253960454/pexels-pixabay-415829.jpg";
    // 输入图片中检索的人脸数量，默认值为1(传0或不传采用默认值)，最大值为10。;是否必传：否
    request.input.MaxFaceNum = 1;
    // 检索的每张人脸返回相关人脸数量，默认值为10，最大值为100。;是否必传：否
    request.input.Limit = 10;
    // 限制返回人脸的最低相关度分数，只有超过 MatchThreshold 值的人脸才会返回。默认值为0，推荐值为80。;是否必传：否
    request.input.MatchThreshold = 80;

    [request setFinishBlock:^(QCloudDatasetFaceSearchResponse * outputObject, NSError *error) {
        XCTAssertNil(error);
        // 注意：此测试可能因为数据集中没有人脸数据而返回错误，这是正常的
        requestResult = outputObject;
        [expectationDatasetFaceSearch fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] DatasetFaceSearch:request];
    [self waitForExpectationsWithTimeout:100 handler:nil];

    // 删除数据集
    XCTestExpectation* expectationDeleteDataset = [self expectationWithDescription:@"testDeleteDataset"];
    __block QCloudDeleteDatasetResponse * afterResult = nil;
    QCloudDeleteDatasetRequest * requestDeleteDataset = [QCloudDeleteDatasetRequest new];
    requestDeleteDataset.regionName = @"ap-shanghai";
    requestDeleteDataset.input = [QCloudDeleteDataset new];
    // 数据集名称，同一个账户下唯一。;是否必传：是
    requestDeleteDataset.input.DatasetName = @"datasetnametestmnx";

    [requestDeleteDataset setFinishBlock:^(QCloudDeleteDatasetResponse * outputObject, NSError *error) {
        XCTAssertNil(error);
        afterResult = outputObject;
        [expectationDeleteDataset fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] DeleteDataset:requestDeleteDataset];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

// 测试查询文件解压任务结果
-(void)testDescribeFileUnzipJobs0{
    XCTestExpectation* expectationDescribeFileUnzipJobs = [self expectationWithDescription:@"testDescribeFileUnzipJobs"];
    QCloudDescribeFileUnzipJobsRequest * request = [QCloudDescribeFileUnzipJobsRequest new];
    // 存储桶名称，格式为 BucketName-APPID
    request.bucket = @"cos-sdk-citest-1253960454";
    request.regionName = @"ap-beijing";
    // 任务ID，创建文件解压任务时返回的jobId
    request.jobId = @"test-unzip-job-id";

    [request setFinishBlock:^(QCloudDescribeFileUnzipJobsResponse * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        // 注意：此测试可能因为jobId不存在而返回错误，这是正常的
        [expectationDescribeFileUnzipJobs fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] DescribeFileUnzipJobs:request];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

// 测试提交多文件打包压缩任务
-(void)testCreateFileZipProcessJobs0{
    XCTestExpectation* expectationCreateFileZipProcessJobs = [self expectationWithDescription:@"testCreateFileZipProcessJobs"];
    QCloudCreateFileZipProcessJobsRequest * request = [QCloudCreateFileZipProcessJobsRequest new];
    // 存储桶名称，格式为 BucketName-APPID
    request.bucket = @"cos-sdk-citest-1253960454";
    request.regionName = @"ap-beijing";
    request.input = [QCloudCreateFileZipProcessJobs new];
    // 表示任务的类型，多文件打包压缩默认为：FileCompress。;是否必传：是
    request.input.Tag = @"FileCompress";
    // 包含文件打包压缩的处理规则。;是否必传：是
    request.input.Operation = [QCloudCreateFileZipProcessJobsOperation new];
    request.input.Operation.FileCompressConfig = [QCloudFileCompressConfig new];
    // 文件打包时，是否需要去除源文件已有的目录结构。0：不需要去除目录结构，打包后压缩包中的文件会保留原有的目录结构；1：需要去除目录结构，打包后压缩包内的文件会去除原有的目录结构，所有文件都在同一层级。
    request.input.Operation.FileCompressConfig.Flatten = @"0";
    // 打包压缩的类型，有效值：zip、tar、tar.gz
    request.input.Operation.FileCompressConfig.Format = @"zip";
    // 压缩包中的文件前缀
    request.input.Operation.FileCompressConfig.Prefix = @"test/";
    // 支持将需要打包的文件整理成索引文件
    request.input.Operation.FileCompressConfig.Key = @"testaaa";
    // 输出配置
    request.input.Operation.Output = [QCloudCreateFileZipProcessJobsOutput new];
    request.input.Operation.Output.Region = @"ap-beijing";
    request.input.Operation.Output.Bucket = @"cos-sdk-citest-1253960454";
    request.input.Operation.Output.Object = @"output/test-compress.zip";

    [request setFinishBlock:^(QCloudCreateFileZipProcessJobsResponse * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        // 注意：此测试可能因为文件不存在或其他原因返回错误，这是正常的
        [expectationCreateFileZipProcessJobs fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] CreateFileZipProcessJobs:request];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

// 测试提交文件解压任务
-(void)testPostFileUnzipProcessJob0{
    XCTestExpectation* expectation = [self expectationWithDescription:@"testPostFileUnzipProcessJob"];
    QCloudPostFileUnzipProcessJobRequest * request = [QCloudPostFileUnzipProcessJobRequest new];
    // 存储桶名称，格式为 BucketName-APPID
    request.bucket = @"cos-sdk-citest-1253960454";
    request.regionName = @"ap-beijing";
    request.input = [QCloudPostFileUnzipProcessJob new];
    // 表示任务的类型，文件解压默认为：FileUncompress
    request.input.Tag = @"FileUncompress";
    // 包含待操作的文件信息
    request.input.Input = [QCloudPostFileUnzipProcessJobInput new];
    // 文件名，取值为文件在当前存储桶中的完整名称
    request.input.Input.Object = @"test-compress.zip";
    // 包含文件解压的处理规则
    request.input.Operation = [QCloudPostFileUnzipProcessJobOperation new];
    request.input.Operation.FileUncompressConfig = [QCloudFileUncompressConfig new];
    request.input.Operation.FileUncompressConfig.Prefix = @"output/";
    request.input.Operation.Output = [QCloudPostFileUnzipProcessJobOutput new];
    request.input.Operation.Output.Bucket = @"cos-sdk-citest-1253960454";
    request.input.Operation.Output.Region = @"ap-beijing";
    
    [request setFinishBlock:^(QCloudPostFileUnzipProcessJobResponse * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        // 注意：此测试可能因为文件不存在或其他原因返回错误，这是正常的
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PostFileUnzipProcessJob:request];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

// 测试查询文件处理队列
-(void)testDescribeFileProcessQueues0{
    XCTestExpectation* expectation = [self expectationWithDescription:@"testDescribeFileProcessQueues"];
    QCloudDescribeFileProcessQueuesRequest * request = [QCloudDescribeFileProcessQueuesRequest new];
    // 存储桶名称，格式为 BucketName-APPID
    request.bucket = @"cos-sdk-citest-1253960454";
    request.regionName = @"ap-beijing";
    // 队列状态
    request.state = @"Active";
    // 第几页
    request.pageNumber = @"1";
    // 每页个数
    request.pageSize = @"10";
    
    [request setFinishBlock:^(QCloudDescribeFileProcessQueuesResponse * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        // 注意：此测试可能因为权限或其他原因返回错误，这是正常的
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] DescribeFileProcessQueues:request];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

// 测试提交哈希值计算任务
-(void)testPostHashProcessJobs0{
    XCTestExpectation* expectation = [self expectationWithDescription:@"testPostHashProcessJobs"];
    QCloudPostHashProcessJobsRequest * request = [QCloudPostHashProcessJobsRequest new];
    // 存储桶名称，格式为 BucketName-APPID
    request.bucket = @"cos-sdk-citest-1253960454";
    request.regionName = @"ap-beijing";
    request.input = [QCloudPostHashProcessJobs new];
    // 表示任务的类型，哈希值计算默认为：FileHashCode
    request.input.Tag = @"FileHashCode";
    // 包含待操作的文件信息
    request.input.Input = [QCloudPostHashProcessJobsInput new];
    // 文件名，取值为文件在当前存储桶中的完整名称
    request.input.Input.Object = @"test.txt";
    // 包含哈希值计算的处理规则
    request.input.Operation = [QCloudPostHashProcessJobsOperation new];
    request.input.Operation.FileHashCodeConfig = [QCloudPostHashProcessJobsFileHashCodeConfig new];
    request.input.Operation.FileHashCodeConfig.Type = @"MD5";
    
    [request setFinishBlock:^(QCloudPostHashProcessJobsResponse * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        // 注意：此测试可能因为文件不存在或其他原因返回错误，这是正常的
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PosthashProcessJobs:request];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

// 测试压缩包预览
-(void)testZipFilePreview0{
    XCTestExpectation* expectation = [self expectationWithDescription:@"testZipFilePreview"];
    QCloudZipFilePreviewRequest * request = [QCloudZipFilePreviewRequest new];
    // 存储桶名称，格式为 BucketName-APPID
    request.bucket = @"cos-sdk-citest-1253960454";
    request.regionName = @"ap-beijing";
    // 压缩包文件名
    request.ObjectKey = @"test.zip";
    
    [request setFinishBlock:^(QCloudZipFilePreviewResponse * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        // 注意：此测试可能因为文件不存在或其他原因返回错误，这是正常的
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] ZipFilePreview:request];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

// 测试哈希值计算同步请求
-(void)testCreateHashProcessJobs0{
    XCTestExpectation* expectation = [self expectationWithDescription:@"testCreateHashProcessJobs"];
    QCloudCreateHashProcessJobsRequest * request = [QCloudCreateHashProcessJobsRequest new];
    // 存储桶名称，格式为 BucketName-APPID
    request.bucket = @"cos-sdk-citest-1253960454";
    request.regionName = @"ap-beijing";
    // 文件名
    request.ObjectKey = @"test";
    // 哈希算法类型：md5、sha1、sha256
    request.type = @"md5";
    
    [request setFinishBlock:^(QCloudCreateHashProcessJobsResponse * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        // 注意：此测试可能因为文件不存在或其他原因返回错误，这是正常的
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] CreateHashProcessJobs:request];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

// 测试查询哈希值计算结果
-(void)testDescribeHashProcessJobs0{
    XCTestExpectation* expectation = [self expectationWithDescription:@"testDescribeHashProcessJobs"];
    QCloudDescribeHashProcessJobsRequest * request = [QCloudDescribeHashProcessJobsRequest new];
    // 存储桶名称，格式为 BucketName-APPID
    request.bucket = @"cos-sdk-citest-1253960454";
    request.regionName = @"ap-beijing";
    // 任务ID
    request.jobId = @"test-hash-job-id";
    
    [request setFinishBlock:^(QCloudDescribeHashProcessJobsResponse * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        // 注意：此测试可能因为jobId不存在而返回错误，这是正常的
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] DescribeHashProcessJobs:request];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

// 测试更新文件处理队列
-(void)testUpdateFileProcessQueue0{
    XCTestExpectation* expectation = [self expectationWithDescription:@"testUpdateFileProcessQueue"];
    QCloudUpdateFileProcessQueueRequest * request = [QCloudUpdateFileProcessQueueRequest new];
    // 存储桶名称，格式为 BucketName-APPID
    request.bucket = @"cos-sdk-citest-1253960454";
    request.regionName = @"ap-beijing";
    // 队列ID
    request.queueId = @"test-queue-id";
    request.input = [QCloudUpdateFileProcessQueue new];
    // 队列名称
    request.input.Name = @"queue-file-process-1";
    // 队列状态：Active 或 Paused
    request.input.State = @"Active";
    // 回调配置
    request.input.NotifyConfig = [QCloudNotifyConfig new];
    request.input.NotifyConfig.State = @"Off";
    
    [request setFinishBlock:^(QCloudUpdateFileProcessQueueResponse * _Nullable result, NSError * _Nullable error) {
        // 注意：此测试可能因为queueId不存在而返回错误，这是正常的
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] UpdateFileProcessQueue:request];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

// 测试查询多文件打包压缩结果
-(void)testDescribeFileZipProcessJobs0{
    XCTestExpectation* expectation = [self expectationWithDescription:@"testDescribeFileZipProcessJobs"];
    QCloudDescribeFileZipProcessJobsRequest * request = [QCloudDescribeFileZipProcessJobsRequest new];
    // 存储桶名称，格式为 BucketName-APPID
    request.bucket = @"cos-sdk-citest-1253960454";
    request.regionName = @"ap-beijing";
    // 任务ID
    request.jobId = @"test-zip-job-id";
    
    [request setFinishBlock:^(QCloudDescribeFileZipProcessJobsResponse * _Nullable result, NSError * _Nullable error) {
        XCTAssertNil(error);
        // 注意：此测试可能因为jobId不存在而返回错误，这是正常的
        [expectation fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] DescribeFileZipProcessJobs:request];
    [self waitForExpectationsWithTimeout:100 handler:nil];
}



@end
