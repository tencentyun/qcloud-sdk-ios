//
//  QCloudCOSXMLModelCoverage.m
//  QCloudCOSXMLDemoTests
//
//  Created by garenwang on 2020/12/16.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TestCommonDefine.h"
#import <XCTest/XCTest.h>
#import <QCloudCOSXML/QCloudCOSXML.h>
#import <QCloudCOSXML/QCloudCompleteMultipartUploadInfo.h>
#import <QCloudCOSXML/QCloudTag.h>
#import <QCloudCOSXML/QCloudGenerateSnapshotRotateTypeEnum.h>
#import <QCloudCOSXML/QCloudInputJSONFileTypeEnum.h>
#import <QCloudCOSXML/QCloudGenerateSnapshotInput.h>
#import <QCloudCOSXML/QCloudCOSIncludedObjectVersionsEnum.h>
#import <QCloudCOSXML/QCloudWebsiteRoutingRules.h>
#import <QCloudCOSXML/QCloudWebsiteRoutingRule.h>
#import <QCloudCOSXML/QCloudRequestProgress.h>
#import <QCloudCOSXML/QCloudPutObjectWatermarkResult.h>
#import <QCloudCOSXML/QCloudGenerateSnapshotOutput.h>
#import <QCloudCOSXML/QCloudGenerateSnapshotResult.h>
#import <QCloudCOSXML/QCloudGenerateSnapshotConfiguration.h>
#import <QCloudCOSXML/QCloudGetFilePreviewResult.h>
#import <QCloudCOSXML/QCloudCILogoRecognitionResult.h>
#import <QCloudCOSXML/QCloudBatchImageRecognitionResult.h>
#import "QCloudCOSXMLService+Configuration.h"
#import "QCloudLogManager.h"
#import "QCloudPostLiveVideoRecognitionRequest.h"
#import "QCloudCIDetectFaceRequest.h"
#import "QCloudCIOCRRequest.h"
#import "QCloudCIDetectCarRequest.h"
#import "QCloudCIGetGoodsMattingRequest.h"
#import "QCloudCIBodyRecognitionRequest.h"
#import "QCloudCIImageRepairRequest.h"
#import "QCloudGetFilePreviewRequest.h"
#import "QCloudCIRecognizeLogoRequest.h"
#import "QCloudAutoTranslationResult.h"
#import "QCloudUpdateAudioDiscernTaskQueueRequest.h"
#import "QCloudQRCodeRecognitionRequest.h"
#import "QCloudPutBucketRefererRequest.h"
#import "QCloudPostVideoRecognitionRequest.h"
#import "QCloudFaceEffectEnum.h"
#import "QCloudPostAudioDiscernTaskInfo.h"
#import "QCloudGetAudioDiscernTaskResult.h"
#import "QCloudAIJobQueueResult.h"
#import "QCloudGetAudioOpenBucketListResult.h"
#import "QCloudGetAIJobQueueRequest.h"
#import "QCloudBatchRecognitionUserInfo.h"
#import "QCloudBatchGetAudioDiscernTaskRequest.h"
#import "QCloudCreateMediaJobResponse.h"
#import "QCloudAILicenseRecResponse.h"
#import "QCloudGetMediaJobResponse.h"
#import "QCloudGetFilePreviewResult.h"
#import "QCloudGetWordsGeneralizeResult.h"
#import "QCloudGetAsrBucketResponse.h"
#import "QCloudPostVideoTagResult.h"
#import "QCloudPostTranscode.h"
#import "QCloudCICommonModel.h"
#import "QCloudWorkflowexecutionResult.h"
#import "QCloudVideoMontage.h"
#import "QCloudPostConcat.h"
#import "QCloudPostVideoTargetRecResponse.h"
#import "QCloudAILicenseRecResponse.h"
#import "QCloudBatchImageRecognitionResult.h"
#import "QCloudVideoRecognitionResult.h"
#import "QCloudPostSmartCover.h"
#import "QCloudPostImageProcess.h"
#import "QCloudVideoSnapshot.h"
#import "QCloudPostSpeechRecognitionResponse.h"
#import "QCloudPostAudioDiscernTaskInfo.h"
#import "QCloudVoiceSeparateResult.h"
#import "QCloudUpdateAIQueueResponse.h"
#import "QCloudPostAnimation.h"
#import "QCloudPostAudioDiscernTaskInfo.h"
#import "QCloudVocalScoreResponse.h"
#import "QCloudGetFilePreviewHtmlResult.h"
#import "QCloudCIUploadOperationsRequest.h"
#import "QCloudCommonModel.h"
#import "QCloudDatasetFaceSearchResponse.h"
#import "QCloudDatasetSimpleQueryResponse.h"
#import "QCloudSearchImageResponse.h"
#import "QCloudPostWordsGeneralizeResponse.h"
#import "QCloudGetMediaJobListRequest.h"
#import "QCloudPostSoundHoundResponse.h"
#import "QCloudUpdateMediaQueueRequest.h"
#import "QCloudCIImageInfo.h"
#import "QCloudCIOriginalInfo.h"
#import "QCloudDescribeDatasetResponse.h"
#import "QCloudUpdateVoiceSynthesisTempleteResponse.h"
#import "QCloudDescribeFileMetaIndexResponse.h"
#import "QCloudCreateDatasetBindingResponse.h"
#import "QCloudDescribeDatasetBindingResponse.h"
#import "QCloudPostVoiceSynthesisTempleteResponse.h"
#import "QCloudDescribeDatasetBindingsResponse.h"
#import "QCloudUpdateDatasetResponse.h"
#import "QCloudDescribeDatasetsResponse.h"
// Manager/model 补充覆盖的 import
#import "QCloudAccessControlList.h"
#import "QCloudACLGrant.h"
#import "QCloudACLGrantee.h"
#import "QCloudCORSConfiguration.h"
#import "QCloudCORSRule.h"
#import "QCloudBucketReplicationConfiguation.h"
#import "QCloudBucketReplicationRule.h"
#import "QCloudBucketReplicationDestination.h"
#import "QCloudLifecycleConfiguration.h"
#import "QCloudLifecycleRule.h"
#import "QCloudIntelligentTieringConfiguration.h"
#import "QCloudIntelligentTieringTransition.h"
#import "QCloudDeleteResult.h"
#import "QCloudDeleteObjectInfo.h"
#import "QCloudOwner.h"
#import "QCloudBucketContents.h"
#import "QCloudListMultipartUploadsResult.h"
#import "QCloudListMultipartUploadContent.h"
#import "QCloudBucketVersioningConfiguration.h"
#import "QCloudBucketAccelerateConfiguration.h"
#import "QCloudNoncurrentVersionExpiration.h"
#import "QCloudNoncurrentVersionTransition.h"
#import "QCloudLifecycleAbortIncompleteMultipartUpload.h"
#import "QCloudLifecycleRuleFilterAnd.h"
#import "QCloudLifecycleTag.h"
#import "QCloudLifecycleTransition.h"
// MateData/model 补充覆盖的 import
#import "QCloudCreateDatasetResponse.h"
#import "QCloudCreateFileMetaIndexResponse.h"
#import "QCloudDeleteDatasetBindingResponse.h"
#import "QCloudDeleteDatasetResponse.h"
#import "QCloudDeleteFileMetaIndexResponse.h"
#import "QCloudUpdateFileMetaIndexResponse.h"
#import "QCloudUpdateFileProcessQueueResponse.h"
#import "QCloudPostSpeechRecognitionTempleteResponse.h"
#import "QCloudPostVoiceSeparateTempleteResponse.h"
#import "QCloudUpdateVoiceSeparateTempleteResponse.h"
#import "QCloudUpdateNoiseReductionTempleteResponse.h"
#import "QCloudPostNoiseReductionTempleteResponse.h"
#import "QCloudPostVideoTargetTempleteResponse.h"
#import "QCloudUpdateVideoTargetTempleteResponse.h"
#import "QCloudUpdateSpeechRecognitionTempleteResponse.h"
#import "QCloudGetAIBucketResponse.h"
#import "QCloudZipFilePreviewResponse.h"
// CI/model Response 补充覆盖
#import "QCloudAIDetectPetResponse.h"
#import "QCloudAIGameRecResponse.h"
#import "QCloudAIIDCardOCRResponse.h"
#import "QCloudAssessQualityResponse.h"
#import "QCloudCloseAIBucketResponse.h"
#import "QCloudCloseAsrBucketResponse.h"
#import "QCloudCreateFileZipProcessJobsResponse.h"
#import "QCloudCreateHashProcessJobsResponse.h"
#import "QCloudCreateQRcodeResponse.h"
#import "QCloudDescribeFileProcessQueuesResponse.h"
#import "QCloudDescribeFileUnzipJobsResponse.h"
#import "QCloudDescribeFileZipProcessJobsResponse.h"
#import "QCloudDescribeHashProcessJobsResponse.h"
#import "QCloudGetActionSequenceResponse.h"
#import "QCloudGetLiveCodeResponse.h"
#import "QCloudLivenessRecognitionResponse.h"
#import "QCloudOpenAsrBucketResponse.h"
#import "QCloudPostFileUnzipProcessJobResponse.h"
#import "QCloudPostHashProcessJobsResponse.h"
#import "QCloudPostNoiseReductionResponse.h"
#import "QCloudPostSegmentVideoBodyResponse.h"
#import "QCloudPostTranslationResponse.h"
#import "QCloudPostVoiceSynthesisResponse.h"
#import "QCloudRecognitionQRcodeResponse.h"
#import "QCloudGetSearchImageResponse.h"

@interface QCloudCOSXMLModelCoverage : XCTestCase

@end

@implementation QCloudCOSXMLModelCoverage

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testTagModel {
    XCTAssert([QCloudTag performSelector:@selector(modelCustomPropertyMapper)]);
    QCloudTag * tag = [QCloudTag new];
    NSDictionary *inputDict = @{ @"Key" : @"testkey",@"Value" : @"testValue"};
    id output = [tag performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    XCTAssertNil(output);
    NSDictionary *transOutput = [tag performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:inputDict];
    XCTAssert([transOutput[@"Key"] isEqualToString:@"testkey"]);
    XCTAssert([transOutput[@"Value"] isEqualToString:@"testValue"]);

    XCTAssert([tag performSelector:@selector(modelCustomTransformToDictionary:) withObject:inputDict]);
}


-(void)testGenerateSnapshotInput{
    XCTAssert([QCloudGenerateSnapshotInput performSelector:@selector(modelCustomPropertyMapper)]);
    QCloudGenerateSnapshotInput * resultInfo = [QCloudGenerateSnapshotInput new];
    NSDictionary *inputDict = @{
        @"Object" : @"ObjectValue",
    };;
    id output = [resultInfo performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    XCTAssertNil(output);
    NSDictionary *transOutput = [resultInfo performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:inputDict];
    XCTAssert([transOutput[@"Object"] isEqualToString:@"ObjectValue"]);
    
    XCTAssert([resultInfo performSelector:@selector(modelCustomTransformToDictionary:) withObject:inputDict]);
}

-(void)testQCloudRequestProgress{
    XCTAssert([QCloudRequestProgress performSelector:@selector(modelCustomPropertyMapper)]);
    QCloudRequestProgress * resultInfo = [QCloudRequestProgress new];
    NSDictionary *inputDict = @{
        @"Enabled" : @"EnabledValue",
    };;
    id output = [resultInfo performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    XCTAssertNil(output);
    NSDictionary *transOutput = [resultInfo performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:inputDict];
    XCTAssert([transOutput[@"Enabled"] isEqualToString:@"EnabledValue"]);
    
    XCTAssert([resultInfo performSelector:@selector(modelCustomTransformToDictionary:) withObject:inputDict]);
}

-(void)testQCloudGenerateSnapshotResult{
    
    XCTAssert([QCloudGenerateSnapshotOutput performSelector:@selector(modelCustomPropertyMapper)]);
    QCloudGenerateSnapshotOutput * shotOutput = [QCloudGenerateSnapshotOutput new];
    NSDictionary *inputDict = @{
        @"Region" : @"RegionValue",
        @"Bucket" : @"BucketValue",
        @"Object" : @"ObjectValue",
    };;
    id output = [shotOutput performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    XCTAssertNil(output);
    NSDictionary *transOutput = [shotOutput performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:inputDict];
    XCTAssert([transOutput[@"Region"] isEqualToString:@"RegionValue"]);
    XCTAssert([transOutput[@"Bucket"] isEqualToString:@"BucketValue"]);
    XCTAssert([transOutput[@"Object"] isEqualToString:@"ObjectValue"]);
    
    XCTAssert([shotOutput performSelector:@selector(modelCustomTransformToDictionary:) withObject:inputDict]);
    
    
    
    XCTAssert([QCloudGenerateSnapshotResult performSelector:@selector(modelCustomPropertyMapper)]);
    QCloudGenerateSnapshotResult * shotResult = [QCloudGenerateSnapshotResult new];
    NSDictionary *inputDict1 = @{
        @"Output" : shotOutput
    };
    id output1 = [shotResult performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    XCTAssertNil(output1);
    NSDictionary *transOutput1 = [shotResult performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:inputDict1];
    
    XCTAssertNotNil(transOutput1[@"Output"]);
    
    XCTAssert([shotResult performSelector:@selector(modelCustomTransformToDictionary:) withObject:inputDict1]);

}

-(void)testQCloudCreateBucketConfiguration{
    XCTAssert([QCloudCreateBucketConfiguration performSelector:@selector(modelCustomPropertyMapper)]);
    QCloudCreateBucketConfiguration * configuration = [QCloudCreateBucketConfiguration new];
    NSDictionary *inputDict = @{
        @"BucketAZConfig" : @"BucketAZConfigValue",
    };;
    id output = [configuration performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    XCTAssertNil(output);
    NSDictionary *transOutput = [configuration performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:inputDict];
    XCTAssert([transOutput[@"BucketAZConfig"] isEqualToString:@"BucketAZConfigValue"]);

    XCTAssert([configuration performSelector:@selector(modelCustomTransformToDictionary:) withObject:inputDict]);
    
}


-(void)testQCloudGenerateSnapshotConfiguration{
    
    
    XCTAssert([QCloudGenerateSnapshotOutput performSelector:@selector(modelCustomPropertyMapper)]);
    QCloudGenerateSnapshotOutput * shotOutput = [QCloudGenerateSnapshotOutput new];
    NSDictionary *inputDict2 = @{
        @"Region" : @"RegionValue",
        @"Bucket" : @"BucketValue",
        @"Object" : @"ObjectValue",
    };;
    id output2 = [shotOutput performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    XCTAssertNil(output2);
    NSDictionary *transOutput2 = [shotOutput performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:inputDict2];
    XCTAssert([transOutput2[@"Region"] isEqualToString:@"RegionValue"]);
    XCTAssert([transOutput2[@"Bucket"] isEqualToString:@"BucketValue"]);
    XCTAssert([transOutput2[@"Object"] isEqualToString:@"ObjectValue"]);

    XCTAssert([shotOutput performSelector:@selector(modelCustomTransformToDictionary:) withObject:inputDict2]);
    
    
    XCTAssert([QCloudGenerateSnapshotInput performSelector:@selector(modelCustomPropertyMapper)]);
    QCloudCreateBucketConfiguration * input = [QCloudCreateBucketConfiguration new];
    NSDictionary *inputDict1 = @{
        @"Object" : @"ObjectValue",
    };;
    id output1 = [input performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    XCTAssertNil(output1);
    NSDictionary *transOutput1 = [input performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:inputDict1];
    XCTAssert([transOutput1[@"Object"] isEqualToString:@"ObjectValue"]);

    XCTAssert([input performSelector:@selector(modelCustomTransformToDictionary:) withObject:inputDict1]);
    
    
    XCTAssert([QCloudGenerateSnapshotConfiguration performSelector:@selector(modelCustomPropertyMapper)]);
    QCloudGenerateSnapshotConfiguration * configuration = [QCloudGenerateSnapshotConfiguration new];
    NSDictionary *inputDict = @{
        @"Time" : @"TimeValue",
        @"Width" : @"WidthValue",
        @"Height" : @"HeightValue",
        @"Input" : input,
        @"Output" : shotOutput,
        @"Mode" : @(QCloudGenerateSnapshotModeExactframe),
        @"Rotate" : @(QCloudGenerateSnapshotRotateTypeAuto),
        @"Format" : @(QCloudGenerateSnapshotFormatJPG),
    };;
    id output = [configuration performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    XCTAssertNil(output);
    NSDictionary *transOutput = [configuration performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:inputDict];
    XCTAssert([transOutput[@"Time"] isEqualToString:@"TimeValue"]);
    XCTAssert([transOutput[@"Width"] isEqualToString:@"WidthValue"]);
    XCTAssert([transOutput[@"Height"] isEqualToString:@"HeightValue"]);
    XCTAssertNotNil(transOutput[@"Input"]);
    XCTAssertNotNil(transOutput[@"Output"]);
    
    XCTAssert([transOutput[@"Mode"] integerValue] == QCloudGenerateSnapshotModeExactframe);
    XCTAssert([transOutput[@"Rotate"] integerValue] == QCloudGenerateSnapshotRotateTypeAuto);
    XCTAssert([transOutput[@"Format"] integerValue] == QCloudGenerateSnapshotFormatJPG);
    XCTAssert([configuration performSelector:@selector(modelCustomTransformToDictionary:) withObject:inputDict.mutableCopy]);
}

-(void)testQCloudGetFilePreviewResult{
    XCTAssert([QCloudGetFilePreviewResult performSelector:@selector(modelCustomPropertyMapper)]);
    QCloudGetFilePreviewResult * shotOutput = [QCloudGetFilePreviewResult new];
    NSDictionary *inputDict2 = @{
        @"X-Total-Page" : @"X-Total-Page-value",
        @"data" : @"dataValue"
    };;
    id output2 = [shotOutput performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    XCTAssertNil(output2);
    NSDictionary *transOutput2 = [shotOutput performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:inputDict2];
    XCTAssert([transOutput2[@"X-Total-Page"] isEqualToString:@"X-Total-Page-value"]);
    XCTAssert([transOutput2[@"data"] isEqualToString:@"dataValue"]);

}

-(void)testQCloudCommonPrefixes{
    XCTAssert([QCloudCommonPrefixes performSelector:@selector(modelCustomPropertyMapper)]);
    QCloudCommonPrefixes * shotOutput = [QCloudCommonPrefixes new];
    NSDictionary *inputDict2 = @{
        @"Prefix" : @"PrefixValue"
    };;
    id output2 = [shotOutput performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    XCTAssertNil(output2);
    NSDictionary *transOutput2 = [shotOutput performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:inputDict2];
    XCTAssert([transOutput2[@"Prefix"] isEqualToString:@"PrefixValue"]);
}

-(void)testCASJobParameters{
    XCTAssert([CASJobParameters performSelector:@selector(modelCustomPropertyMapper)]);
    CASJobParameters * shotOutput = [CASJobParameters new];
    NSDictionary *inputDict2 = @{
        @"Tier" : @1
    };;
    id output2 = [shotOutput performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    XCTAssertNil(output2);
    NSDictionary *transOutput2 = [shotOutput performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:inputDict2];
    XCTAssert([transOutput2[@"Tier"] integerValue] == 1);
    
    XCTAssert([shotOutput performSelector:@selector(modelCustomTransformToDictionary:) withObject:inputDict2.mutableCopy]);
}

-(void)testQCloudSerializationJSON{
    XCTAssert([QCloudSerializationJSON performSelector:@selector(modelCustomPropertyMapper)]);
    QCloudSerializationJSON * shotOutput = [QCloudSerializationJSON new];
    NSDictionary *inputDict2 = @{
        @"OutoutJSONFileType" : @0,
        @"RecordDelimiter" : @"RecordDelimiterValue",
    };;
    id output2 = [shotOutput performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    XCTAssertNil(output2);
    NSDictionary *transOutput2 = [shotOutput performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:inputDict2];
    XCTAssert([transOutput2[@"OutoutJSONFileType"] integerValue] == 0);
    XCTAssert([transOutput2[@"RecordDelimiter"] isEqualToString:@"RecordDelimiterValue"]);
    XCTAssert([shotOutput performSelector:@selector(modelCustomTransformToDictionary:) withObject:inputDict2.mutableCopy]);
}

-(void)testQCloudDeleteResultRow{
    XCTAssert([QCloudDeleteResultRow performSelector:@selector(modelCustomPropertyMapper)]);
    QCloudDeleteResultRow * shotOutput = [QCloudDeleteResultRow new];
    NSDictionary *inputDict2 = @{
        @"Key" : @"KeyValue",
    };;
    id output2 = [shotOutput performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    XCTAssertNil(output2);
    NSDictionary *transOutput2 = [shotOutput performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:inputDict2];
    
    XCTAssert([transOutput2[@"Key"] isEqualToString:@"KeyValue"]);
    
    XCTAssert([shotOutput performSelector:@selector(modelCustomTransformToDictionary:) withObject:inputDict2]);
    
    
    XCTAssert([QCloudDeleteFailedResultRow performSelector:@selector(modelCustomPropertyMapper)]);
    QCloudDeleteFailedResultRow * resultRow = [QCloudDeleteFailedResultRow new];
    NSDictionary *inputDict = @{
        @"Key" : @"KeyValue",
        @"Code" : @"CodeValue",
        @"Message" : @"MessageValue"
    };;
    id output = [resultRow performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    XCTAssertNil(output);
    NSDictionary *transOutput = [resultRow performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:inputDict];
    
    XCTAssert([transOutput[@"Key"] isEqualToString:@"KeyValue"]);
    XCTAssert([transOutput[@"Code"] isEqualToString:@"CodeValue"]);
    XCTAssert([transOutput[@"Message"] isEqualToString:@"MessageValue"]);
    XCTAssert([resultRow performSelector:@selector(modelCustomTransformToDictionary:) withObject:inputDict]);
}

-(void)testQCloudInventoryEncryption{
    XCTAssert([QCloudInventoryEncryption performSelector:@selector(modelCustomPropertyMapper)]);
    QCloudInventoryEncryption * shotOutput = [QCloudInventoryEncryption new];
    NSDictionary *inputDict2 = @{
        @"SSE-COS" : @"SSE-COS-Value",
    };;
    id output2 = [shotOutput performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    XCTAssertNil(output2);
    NSDictionary *transOutput2 = [shotOutput performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:inputDict2];
    
    XCTAssert([transOutput2[@"SSE-COS"] isEqualToString:@"SSE-COS-Value"]);
    XCTAssert([shotOutput performSelector:@selector(modelCustomTransformToDictionary:) withObject:inputDict2]);
}

-(void)testQCloudOutputSerialization{
    XCTAssert([QCloudOutputSerialization performSelector:@selector(modelCustomPropertyMapper)]);
    QCloudOutputSerialization * shotOutput = [QCloudOutputSerialization new];
    NSDictionary *inputDict2 = @{
        @"CSV" : [QCloudSerializationCSV new],
        @"JSON" : [QCloudSerializationJSON new]
    };
    id output2 = [shotOutput performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    XCTAssertNil(output2);
    NSDictionary *transOutput2 = [shotOutput performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:inputDict2];
    
    XCTAssertNotNil(transOutput2[@"CSV"]);
    XCTAssertNotNil(transOutput2[@"JSON"]);
    XCTAssert([shotOutput performSelector:@selector(modelCustomTransformToDictionary:) withObject:inputDict2]);
}

-(void)testQCloudInputSerialization{
    XCTAssert([QCloudOutputSerialization performSelector:@selector(modelCustomPropertyMapper)]);
    QCloudInputSerialization * shotOutput = [QCloudInputSerialization new];
    NSDictionary *inputDict2 = @{
        @"CompressionType" : @0,
        @"CSV" : [QCloudSerializationCSV new],
        @"JSON" : [QCloudSerializationJSON new],
    };
    id output2 = [shotOutput performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    XCTAssertNil(output2);
    NSDictionary *transOutput2 = [shotOutput performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:inputDict2];
    
    XCTAssertNotNil(transOutput2[@"CSV"]);
    XCTAssertNotNil(transOutput2[@"JSON"]);
    XCTAssert([transOutput2[@"CompressionType"] integerValue] == 0);
    XCTAssert([shotOutput performSelector:@selector(modelCustomTransformToDictionary:) withObject:inputDict2.mutableCopy]);
}

-(void)testQCloudSerializationCSV{
    XCTAssert([QCloudSerializationCSV performSelector:@selector(modelCustomPropertyMapper)]);
    QCloudSerializationCSV * shotOutput = [QCloudSerializationCSV new];
    NSDictionary *inputDict2 = @{
        @"RecordDelimiter" : @"RecordDelimiterValue",
        @"FieldDelimiter" : @"FieldDelimiterValue",
        @"QuoteCharacter" : @"QuoteCharacterValue",
        @"QuoteEscapeCharacter" : @"QuoteEscapeCharacterValue",
        @"AllowQuotedRecordDelimiter" : @"AllowQuotedRecordDelimiterValue",
        @"FileHeaderInfo" : @0,
        @"Comments" : @"CommentsValue",
        @"QuoteFields" : @0,
    };
    id output2 = [shotOutput performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    XCTAssertNil(output2);
    NSDictionary *transOutput2 = [shotOutput performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:inputDict2];
    
    XCTAssert([transOutput2[@"RecordDelimiter"] isEqualToString:@"RecordDelimiterValue"]);
    XCTAssert([transOutput2[@"FieldDelimiter"] isEqualToString:@"FieldDelimiterValue"]);
    XCTAssert([transOutput2[@"QuoteCharacter"] isEqualToString:@"QuoteCharacterValue"]);
    XCTAssert([transOutput2[@"QuoteEscapeCharacter"] isEqualToString:@"QuoteEscapeCharacterValue"]);
    XCTAssert([transOutput2[@"AllowQuotedRecordDelimiter"] isEqualToString:@"AllowQuotedRecordDelimiterValue"]);
    XCTAssert([transOutput2[@"FileHeaderInfo"] integerValue] == 0);
    XCTAssert([transOutput2[@"Comments"] isEqualToString:@"CommentsValue"]);
    XCTAssert([transOutput2[@"QuoteFields"] integerValue] == 0);
    
    
    XCTAssert([shotOutput performSelector:@selector(modelCustomTransformToDictionary:) withObject:inputDict2.mutableCopy]);
}

-(void)testQCloudPutObjectRequest{
    QCloudPutObjectRequest * request = [QCloudPutObjectRequest new];
    [request setCOSServerSideEncyptionWithCustomerKey:@"test"];
    [request setCOSServerSideEncyptionWithKMSCustomKey:@"test" jsonStr:@"json"];
    
}

-(void)testQCloudRestoreRequest{
    XCTAssert([QCloudRestoreRequest performSelector:@selector(modelCustomPropertyMapper)]);
    QCloudRestoreRequest * shotOutput = [QCloudRestoreRequest new];
    NSDictionary *inputDict2 = @{
        @"days" : @"days",
        @"CASJobParameters" : CASJobParameters.new,
    };
    id output2 = [shotOutput performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    XCTAssertNil(output2);
    NSDictionary *transOutput2 = [shotOutput performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:inputDict2];
    
    XCTAssert([transOutput2[@"days"] isEqualToString:@"days"]);
    XCTAssertNotNil(transOutput2[@"CASJobParameters"]);
    XCTAssert([shotOutput performSelector:@selector(modelCustomTransformToDictionary:) withObject:inputDict2.mutableCopy]);
}


#pragma --mark coverageEnum

-(void)testQCloudGenerateSnapshotRotateTypeEnum{
    QCloudGenerateSnapshotRotateType type = QCloudGenerateSnapshotRotateTypeAuto;
    NSString * strType = QCloudGenerateSnapshotRotateTypeTransferToString(type);
    XCTAssertTrue([strType isEqualToString:@"auto"]);
    
    type = QCloudGenerateSnapshotRotateTypeOff;
    strType = QCloudGenerateSnapshotRotateTypeTransferToString(type);
    XCTAssertTrue([strType isEqualToString:@"off"]);
    
    type = -1;
    strType = QCloudGenerateSnapshotRotateTypeTransferToString(type);
    XCTAssertTrue(strType == nil);
    
    strType = @"auto";
    type = QCloudGenerateSnapshotRotateTypeDumpFromString(strType);
    XCTAssertTrue(type == QCloudGenerateSnapshotRotateTypeAuto);
    
    strType = @"off";
    type = QCloudGenerateSnapshotRotateTypeDumpFromString(strType);
    XCTAssertTrue(type == QCloudGenerateSnapshotRotateTypeOff);
    
    strType = @"test";
    type = QCloudGenerateSnapshotRotateTypeDumpFromString(strType);
    XCTAssertTrue(type == 0);
}

-(void)testQCloudInputJSONFileTypeEnum{
    QCloudInputJSONFileType type = QCloudInputJSONFileTypeDocument;
    NSString * strType = QCloudInputJSONFileTypeTransferToString(type);
    XCTAssertTrue([strType isEqualToString:@"DOCUMENT"]);
    
    type = QCloudInputJSONFileTypeLines;
    strType = QCloudInputJSONFileTypeTransferToString(type);
    XCTAssertTrue([strType isEqualToString:@"LINES"]);
    
    type = -1;
    strType = QCloudInputJSONFileTypeTransferToString(type);
    XCTAssertTrue(strType == nil);
    
    strType = @"DOCUMENT";
    type = QCloudInputJSONFileTypeDumpFromString(strType);
    XCTAssertTrue(type == QCloudInputJSONFileTypeDocument);
    
    strType = @"LINES";
    type = QCloudInputJSONFileTypeDumpFromString(strType);
    XCTAssertTrue(type == QCloudInputJSONFileTypeLines);
    
    strType = @"test";
    type = QCloudInputJSONFileTypeDumpFromString(strType);
    XCTAssertTrue(type == 0);
}

-(void)testQCloudCOSIncludedObjectVersionsEnum{
    
    QCloudCOSIncludedObjectVersions type = QCloudCOSIncludedObjectVersionsAll;
    NSString * strType = QCloudCOSIncludedObjectVersionsTransferToString(type);
    XCTAssertTrue([strType isEqualToString:@"All"]);
    
    type = QCloudCOSIncludedObjectVersionsCurrent;
    strType = QCloudCOSIncludedObjectVersionsTransferToString(type);
    XCTAssertTrue([strType isEqualToString:@"Current"]);
    
    type = -1;
    strType = QCloudCOSIncludedObjectVersionsTransferToString(type);
    XCTAssertTrue(strType == nil);
    
    strType = @"All";
    type = QCloudCOSIncludedObjectVersionsDumpFromString(strType);
    XCTAssertTrue(type == QCloudCOSIncludedObjectVersionsAll);
    
    strType = @"Current";
    type = QCloudCOSIncludedObjectVersionsDumpFromString(strType);
    XCTAssertTrue(type == QCloudCOSIncludedObjectVersionsCurrent);
    
    strType = @"test";
    type = QCloudCOSIncludedObjectVersionsDumpFromString(strType);
    XCTAssertTrue(type == 0);
}

-(void)testQCloudCASTierEnum{
    QCloudCASTier type = QCloudCASTierExpedited;
    NSString * strType = QCloudCASTierTransferToString(type);
    XCTAssertTrue([strType isEqualToString:@"Expedited"]);
    
    type = QCloudCASTierStandard;
    strType = QCloudCASTierTransferToString(type);
    XCTAssertTrue([strType isEqualToString:@"Standard"]);
    
    type = QCloudCASTierBulk;
    strType = QCloudCASTierTransferToString(type);
    XCTAssertTrue([strType isEqualToString:@"Bulk"]);

    type = -1;
    strType = QCloudCASTierTransferToString(type);
    XCTAssertTrue(strType == nil);
    
    strType = @"Expedited";
    type = QCloudCASTierDumpFromString(strType);
    XCTAssertTrue(type == QCloudCASTierExpedited);
    
    strType = @"Standard";
    type = QCloudCASTierDumpFromString(strType);
    XCTAssertTrue(type == QCloudCASTierStandard);
    
    strType = @"Bulk";
    type = QCloudCASTierDumpFromString(strType);
    XCTAssertTrue(type == QCloudCASTierBulk);
    
    strType = @"test";
    type = QCloudCASTierDumpFromString(strType);
    XCTAssertTrue(type == 0);
}

-(void)testQCloudGenerateSnapshotMode{
    QCloudGenerateSnapshotMode mode = QCloudGenerateSnapshotModeExactframe;
    NSString * strType = QCloudGenerateSnapshotModeTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"exactframe"]);
    
    mode = QCloudGenerateSnapshotModeKeyframe;
    strType = QCloudGenerateSnapshotModeTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"keyframe"]);
    
    mode = -1;
    strType = QCloudGenerateSnapshotModeTransferToString(mode);
    XCTAssertTrue(strType == nil);
    
    
    strType = @"exactframe";
    mode = QCloudGenerateSnapshotModeDumpFromString(strType);
    XCTAssertTrue(mode == QCloudGenerateSnapshotModeExactframe);
    
    strType = @"keyframe";
    mode = QCloudGenerateSnapshotModeDumpFromString(strType);
    XCTAssertTrue(mode == QCloudGenerateSnapshotModeKeyframe);
    
    strType = @"test";
    mode = QCloudGenerateSnapshotModeDumpFromString(strType);
    XCTAssertTrue(mode == 0);
    
}

-(void)testQCloudGenerateSnapshotRotateType{
    QCloudGenerateSnapshotRotateType mode = QCloudGenerateSnapshotRotateTypeAuto;
    NSString * strType = QCloudGenerateSnapshotRotateTypeTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"auto"]);
    
    mode = QCloudGenerateSnapshotRotateTypeOff;
    strType = QCloudGenerateSnapshotRotateTypeTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"off"]);
    
    mode = -1;
    strType = QCloudGenerateSnapshotRotateTypeTransferToString(mode);
    XCTAssertTrue(strType == nil);
    
    strType = @"auto";
    mode = QCloudGenerateSnapshotRotateTypeDumpFromString(strType);
    XCTAssertTrue(mode == QCloudGenerateSnapshotRotateTypeAuto);
    
    strType = @"off";
    mode = QCloudGenerateSnapshotRotateTypeDumpFromString(strType);
    XCTAssertTrue(mode == QCloudGenerateSnapshotRotateTypeOff);
    
    strType = @"test";
    mode = QCloudGenerateSnapshotRotateTypeDumpFromString(strType);
    XCTAssertTrue(mode == 0);
    
}

-(void)testQCloudGenerateSnapshotFormat{
    QCloudGenerateSnapshotFormat mode = QCloudGenerateSnapshotFormatJPG;
    NSString * strType = QCloudGenerateSnapshotFormatTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"jpg"]);
    
    mode = QCloudGenerateSnapshotFormatPNG;
    strType = QCloudGenerateSnapshotFormatTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"png"]);
    
    mode = -1;
    strType = QCloudGenerateSnapshotFormatTransferToString(mode);
    XCTAssertTrue(strType == nil);
    
    strType = @"jpg";
    mode = QCloudGenerateSnapshotFormatDumpFromString(strType);
    XCTAssertTrue(mode == QCloudGenerateSnapshotFormatJPG);
    
    strType = @"png";
    mode = QCloudGenerateSnapshotFormatDumpFromString(strType);
    XCTAssertTrue(mode == QCloudGenerateSnapshotFormatPNG);
    
    strType = @"test";
    mode = QCloudGenerateSnapshotFormatDumpFromString(strType);
    XCTAssertTrue(mode == 0);
}

-(void)testQCloudCOSXMLCompressionType{
    QCloudCOSXMLCompressionType mode = QCloudCOSXMLCompressionTypeNONE;
    NSString * strType = QCloudCOSXMLCompressionTypeTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"NONE"]);
    
    mode = QCloudCOSXMLCompressionTypeGZIP;
    strType = QCloudCOSXMLCompressionTypeTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"GZIP"]);
    
    mode = QCloudCOSXMLCompressionTypeBZIP2;
    strType = QCloudCOSXMLCompressionTypeTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"BZIP2"]);
    
    mode = -1;
    strType = QCloudCOSXMLCompressionTypeTransferToString(mode);
    XCTAssertTrue(strType == nil);
    
    strType = @"NONE";
    mode = QCloudCOSXMLCompressionTypeDumpFromString(strType);
    XCTAssertTrue(mode == QCloudCOSXMLCompressionTypeNONE);
    
    strType = @"GZIP";
    mode = QCloudCOSXMLCompressionTypeDumpFromString(strType);
    XCTAssertTrue(mode == QCloudCOSXMLCompressionTypeGZIP);
    
    strType = @"BZIP2";
    mode = QCloudCOSXMLCompressionTypeDumpFromString(strType);
    XCTAssertTrue(mode == QCloudCOSXMLCompressionTypeBZIP2);
    
    strType = @"test";
    mode = QCloudCOSXMLCompressionTypeDumpFromString(strType);
    XCTAssertTrue(mode == 0);
}

-(void)testQCloudInputFileHeaderInfo{
    QCloudInputFileHeaderInfo mode = QCloudInputFileHeaderInfoNone;
    NSString * strType = QCloudInputFileHeaderInfoTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"NONE"]);
    
    mode = QCloudInputFileHeaderInfoUse;
    strType = QCloudInputFileHeaderInfoTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"USE"]);
    
    mode = QCloudInputFileHeaderInfoIgnore;
    strType = QCloudInputFileHeaderInfoTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"IGNORE"]);
    
    mode = -1;
    strType = QCloudInputFileHeaderInfoTransferToString(mode);
    XCTAssertTrue(strType == nil);
    
    strType = @"NONE";
    mode = QCloudInputFileHeaderInfoDumpFromString(strType);
    XCTAssertTrue(mode == QCloudInputFileHeaderInfoNone);
    
    strType = @"USE";
    mode = QCloudInputFileHeaderInfoDumpFromString(strType);
    XCTAssertTrue(mode == QCloudInputFileHeaderInfoUse);
    
    strType = @"IGNORE";
    mode = QCloudInputFileHeaderInfoDumpFromString(strType);
    XCTAssertTrue(mode == QCloudInputFileHeaderInfoIgnore);
    
    strType = @"test";
    mode = QCloudInputFileHeaderInfoDumpFromString(strType);
    XCTAssertTrue(mode == 0);
}

-(void)testQCloudDomainStatue{
    QCloudDomainStatue mode = QCloudDomainStatueEnabled;
    NSString * strType = QCloudDomainStatueTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"ENABLED"]);
    
    mode = QCloudDomainStatueDisabled;
    strType = QCloudDomainStatueTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"DISABLED"]);
    
    mode = -1;
    strType = QCloudDomainStatueTransferToString(mode);
    XCTAssertTrue(strType == nil);
    
    strType = @"ENABLED";
    mode = QCloudDomainStatueDumpFromString(strType);
    XCTAssertTrue(mode == QCloudDomainStatueEnabled);
    
    strType = @"DISABLED";
    mode = QCloudDomainStatueDumpFromString(strType);
    XCTAssertTrue(mode == QCloudDomainStatueDisabled);
    
    strType = @"test";
    mode = QCloudDomainStatueDumpFromString(strType);
    XCTAssertTrue(mode == 0);
}

-(void)testQCloudCOSDomainType{
    QCloudCOSDomainType mode = QCloudCOSDomainTypeRest;
    NSString * strType = QCloudCOSDomainTypeTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"REST"]);
    
    mode = QCloudCOSDomainTypeWebsite;
    strType = QCloudCOSDomainTypeTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"WEBSITE"]);
    
    mode = -1;
    strType = QCloudCOSDomainTypeTransferToString(mode);
    XCTAssertTrue(strType == nil);
    
    strType = @"REST";
    mode = QCloudCOSDomainTypeDumpFromString(strType);
    XCTAssertTrue(mode == QCloudCOSDomainTypeRest);
    
    strType = @"WEBSITE";
    mode = QCloudCOSDomainTypeDumpFromString(strType);
    XCTAssertTrue(mode == QCloudCOSDomainTypeWebsite);
    
    
    strType = @"test";
    mode = QCloudCOSDomainTypeDumpFromString(strType);
    XCTAssertTrue(mode == 0);
}

-(void)testQCloudCOSDomainReplaceType{
    QCloudCOSDomainReplaceType mode = QCloudCOSDomainReplaceTypeCname;
    NSString * strType = QCloudCOSDomainReplaceTypeTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"CNAME"]);
    
    mode = QCloudCOSDomainReplaceTypeTxt;
    strType = QCloudCOSDomainReplaceTypeTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"TXT"]);
    
    mode = -1;
    strType = QCloudCOSDomainReplaceTypeTransferToString(mode);
    XCTAssertTrue(strType == nil);
    
    strType = @"CNAME";
    mode = QCloudCOSDomainReplaceTypeDumpFromString(strType);
    XCTAssertTrue(mode == QCloudCOSDomainReplaceTypeCname);
    
    strType = @"TXT";
    mode = QCloudCOSDomainReplaceTypeDumpFromString(strType);
    XCTAssertTrue(mode == QCloudCOSDomainReplaceTypeTxt);
    
    
    strType = @"test";
    mode = QCloudCOSDomainReplaceTypeDumpFromString(strType);
    XCTAssertTrue(mode == 0);
    
   
    
}

-(void)testQCloudExpressionTypeEnum{
    QCloudExpressionType mode = QCloudExpressionTypeSQL;
    NSString * strType = QCloudExpressionTypeTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"SQL"]);
    
    mode = -1;
    strType = QCloudExpressionTypeTransferToString(mode);
    XCTAssertTrue(strType == nil);
    
    strType = @"SQL";
    mode = QCloudExpressionTypeDumpFromString(strType);
    XCTAssertTrue(mode == QCloudExpressionTypeSQL);
    
    strType = @"test";
    mode = QCloudExpressionTypeDumpFromString(strType);
    XCTAssertTrue(mode == 0);
    
}

-(void)testQCloudCOSBucketVersioningStatus{
    QCloudCOSBucketVersioningStatus mode = QCloudCOSBucketVersioningStatusEnabled;
    NSString * strType = QCloudCOSBucketVersioningStatusTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"Enabled"]);
    
    mode = QCloudCOSBucketVersioningStatusSuspended;
    strType = QCloudCOSBucketVersioningStatusTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"Suspended"]);
    
    mode = -1;
    strType = QCloudCOSBucketVersioningStatusTransferToString(mode);
    XCTAssertTrue(strType == nil);
    
    strType = @"Enabled";
    mode = QCloudCOSBucketVersioningStatusDumpFromString(strType);
    XCTAssertTrue(mode == QCloudCOSBucketVersioningStatusEnabled);
    
    strType = @"Suspended";
    mode = QCloudCOSBucketVersioningStatusDumpFromString(strType);
    XCTAssertTrue(mode == QCloudCOSBucketVersioningStatusSuspended);
    
    strType = @"test";
    mode = QCloudCOSBucketVersioningStatusDumpFromString(strType);
    XCTAssertTrue(mode == 0);
    
    
    
}

-(void)testQCloudOutputQuoteFields{
    QCloudOutputQuoteFields mode = QCloudOutputQuoteFieldsAsneeded;
    NSString * strType = QCloudOutputQuoteFieldsTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"ASNEEDED"]);
    
    mode = QCloudOutputQuoteFieldsAlways;
    strType = QCloudOutputQuoteFieldsTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"ALWAYS"]);
    
    mode = -1;
    strType = QCloudOutputQuoteFieldsTransferToString(mode);
    XCTAssertTrue(strType == nil);
    
    strType = @"ASNEEDED";
    mode = QCloudOutputQuoteFieldsDumpFromString(strType);
    XCTAssertTrue(mode == QCloudOutputQuoteFieldsAsneeded);
    
    strType = @"ALWAYS";
    mode = QCloudOutputQuoteFieldsDumpFromString(strType);
    XCTAssertTrue(mode == QCloudOutputQuoteFieldsAlways);
    
    strType = @"test";
    mode = QCloudOutputQuoteFieldsDumpFromString(strType);
    XCTAssertTrue(mode == 0);
    
}


-(void)testQCloudCOSPermissionEnum{
    QCloudCOSPermission mode = QCloudCOSPermissionRead;
    NSString * strType = QCloudCOSPermissionTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"READ"]);
    
    mode = QCloudCOSPermissionWrite;
    strType = QCloudCOSPermissionTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"WRITE"]);
    
    mode = QCloudCOSPermissionFullControl;
    strType = QCloudCOSPermissionTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"FULL_CONTROL"]);
    
    mode = QCloudCOSPermissionRead_ACP;
    strType = QCloudCOSPermissionTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"READ_ACP"]);
    
    mode = QCloudCOSPermissionWrite_ACP;
    strType = QCloudCOSPermissionTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"WRITE_ACP"]);
    
    mode = -1;
    strType = QCloudCOSPermissionTransferToString(mode);
    XCTAssertTrue(strType == nil);
    
    strType = @"READ";
    mode = QCloudCOSPermissionDumpFromString(strType);
    XCTAssertTrue(mode == QCloudCOSPermissionRead);
    
    strType = @"WRITE";
    mode = QCloudCOSPermissionDumpFromString(strType);
    XCTAssertTrue(mode == QCloudCOSPermissionWrite);
    
    strType = @"FULL_CONTROL";
    mode = QCloudCOSPermissionDumpFromString(strType);
    XCTAssertTrue(mode == QCloudCOSPermissionFullControl);
    
    strType = @"READ_ACP";
    mode = QCloudCOSPermissionDumpFromString(strType);
    XCTAssertTrue(mode == QCloudCOSPermissionRead_ACP);
    strType = @"WRITE_ACP";
    mode = QCloudCOSPermissionDumpFromString(strType);
    XCTAssertTrue(mode == QCloudCOSPermissionWrite_ACP);

    strType = @"test";
    mode = QCloudCOSPermissionDumpFromString(strType);
    XCTAssertTrue(mode == 0);
    
}

-(void)testQCloudCOSBucketAccelerateStatus{
    QCloudCOSBucketAccelerateStatus mode = QCloudCOSBucketAccelerateStatusEnabled;
    NSString * strType = QCloudCOSBucketAccelerateStatusTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"Enabled"]);
    
    mode = QCloudCOSBucketAccelerateStatusSuspended;
    strType = QCloudCOSBucketAccelerateStatusTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"Suspended"]);
    
    mode = -1;
    strType = QCloudCOSBucketAccelerateStatusTransferToString(mode);
    XCTAssertTrue(strType == nil);
    
    strType = @"Enabled";
    mode = QCloudCOSBucketAccelerateStatusDumpFromString(strType);
    XCTAssertTrue(mode == QCloudCOSBucketAccelerateStatusEnabled);
    
    strType = @"Suspended";
    mode = QCloudCOSBucketAccelerateStatusDumpFromString(strType);
    XCTAssertTrue(mode == QCloudCOSBucketAccelerateStatusSuspended);
    
    strType = @"test";
    mode = QCloudCOSBucketAccelerateStatusDumpFromString(strType);
    XCTAssertTrue(mode == 0);
}

-(void)testQCloudCOSStorageClassEnum{
    QCloudCOSStorageClass mode = QCloudCOSStorageStandard;
    NSString * strType = QCloudCOSStorageClassTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"STANDARD"]);
    
    mode = QCloudCOSStorageStandardIA;
    strType = QCloudCOSStorageClassTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"STANDARD_IA"]);
    
    mode = QCloudCOSStorageARCHIVE;
    strType = QCloudCOSStorageClassTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"ARCHIVE"]);
    
    mode = QCloudCOSStorageMAZ_Standard;
    strType = QCloudCOSStorageClassTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"MAZ_STANDARD"]);
    
    mode = QCloudCOSStorageMAZ_StandardIA;
    strType = QCloudCOSStorageClassTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"MAZ_STANDARD_IA"]);
    
    mode = QCloudCOSStorageINTELLIGENT_TIERING;
    strType = QCloudCOSStorageClassTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"INTELLIGENT_TIERING"]);
    
    mode = QCloudCOSStorageMAZ_INTELLIGENT_TIERING;
    strType = QCloudCOSStorageClassTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"MAZ_INTELLIGENT_TIERING"]);
    
    mode = QCloudCOSStorageDEEP_ARCHIVE;
    strType = QCloudCOSStorageClassTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"DEEP_ARCHIVE"]);
    
    mode = -1;
    strType = QCloudCOSStorageClassTransferToString(mode);
    XCTAssertTrue(strType == nil);
    
    strType = @"STANDARD";
    mode = QCloudCOSStorageClassDumpFromString(strType);
    XCTAssertTrue(mode == QCloudCOSStorageStandard);
    
    strType = @"STANDARD_IA";
    mode = QCloudCOSStorageClassDumpFromString(strType);
    XCTAssertTrue(mode == QCloudCOSStorageStandardIA);
    
    strType = @"ARCHIVE";
    mode = QCloudCOSStorageClassDumpFromString(strType);
    XCTAssertTrue(mode == QCloudCOSStorageARCHIVE);
    
    strType = @"MAZ_STANDARD";
    mode = QCloudCOSStorageClassDumpFromString(strType);
    XCTAssertTrue(mode == QCloudCOSStorageMAZ_Standard);
    
    strType = @"MAZ_STANDARD_IA";
    mode = QCloudCOSStorageClassDumpFromString(strType);
    XCTAssertTrue(mode == QCloudCOSStorageMAZ_StandardIA);
    
    strType = @"INTELLIGENT_TIERING";
    mode = QCloudCOSStorageClassDumpFromString(strType);
    XCTAssertTrue(mode == QCloudCOSStorageINTELLIGENT_TIERING);
    
    strType = @"MAZ_INTELLIGENT_TIERING";
    mode = QCloudCOSStorageClassDumpFromString(strType);
    XCTAssertTrue(mode == QCloudCOSStorageMAZ_INTELLIGENT_TIERING);
    
    strType = @"DEEP_ARCHIVE";
    mode = QCloudCOSStorageClassDumpFromString(strType);
    XCTAssertTrue(mode == QCloudCOSStorageDEEP_ARCHIVE);
    
    strType = @"test";
    mode = QCloudCOSStorageClassDumpFromString(strType);
    XCTAssertTrue(mode == 0);
}

-(void)testQCloudIntelligentTieringStatus{
    QCloudIntelligentTieringStatus mode = QCloudintelligentTieringStatusEnabled;
    NSString * strType = QCloudIntelligentTieringStatusTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"Enabled"]);
    
    mode = QCloudintelligentTieringStatusSuspended;
    strType = QCloudIntelligentTieringStatusTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"Suspended"]);
    
    mode = -1;
    strType = QCloudIntelligentTieringStatusTransferToString(mode);
    XCTAssertTrue(strType == nil);
    
    strType = @"Enabled";
    mode = QCloudIntelligentTieringStatusDumpFromString(strType);
    XCTAssertTrue(mode == QCloudintelligentTieringStatusEnabled);
    
    strType = @"Suspended";
    mode = QCloudIntelligentTieringStatusDumpFromString(strType);
    XCTAssertTrue(mode == QCloudintelligentTieringStatusSuspended);
    
    strType = @"test";
    mode = QCloudIntelligentTieringStatusDumpFromString(strType);
    XCTAssertTrue(mode == 0);
}

-(void)testQCloudLifecycleStatue{
    QCloudLifecycleStatue mode = QCloudLifecycleStatueEnabled;
    NSString * strType = QCloudLifecycleStatueTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"Enabled"]);
    
    mode = QCloudLifecycleStatueDisabled;
    strType = QCloudLifecycleStatueTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"Disabled"]);
    
    mode = -1;
    strType = QCloudLifecycleStatueTransferToString(mode);
    XCTAssertTrue(strType == nil);
    
    strType = @"Enabled";
    mode = QCloudLifecycleStatueDumpFromString(strType);
    XCTAssertTrue(mode == QCloudLifecycleStatueEnabled);
    
    strType = @"Disabled";
    mode = QCloudLifecycleStatueDumpFromString(strType);
    XCTAssertTrue(mode == QCloudLifecycleStatueDisabled);
    
    strType = @"test";
    mode = QCloudLifecycleStatueDumpFromString(strType);
    XCTAssertTrue(mode == 0);
}

-(void)testQCloudCOSAccountType{
    QCloudCOSAccountType mode = QCloudCOSAccountTypeRoot;
    NSString * strType = QCloudCOSAccountTypeTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"RootAccount"]);
    
    mode = QCloudCOSAccountTypeSub;
    strType = QCloudCOSAccountTypeTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"SubAccount"]);
    
    mode = -1;
    strType = QCloudCOSAccountTypeTransferToString(mode);
    XCTAssertTrue(strType == nil);
    
    strType = @"RootAccount";
    mode = QCloudCOSAccountTypeDumpFromString(strType);
    XCTAssertTrue(mode == QCloudCOSAccountTypeRoot);
    
    strType = @"SubAccount";
    mode = QCloudCOSAccountTypeDumpFromString(strType);
    XCTAssertTrue(mode == QCloudCOSAccountTypeSub);
    
    strType = @"test";
    mode = QCloudCOSAccountTypeDumpFromString(strType);
    XCTAssertTrue(mode == 0);
}


-(void)testQCloudCOSXMLStatus{
    QCloudCOSXMLStatus mode = QCloudCOSXMLStatusEnabled;
    NSString * strType = QCloudCOSXMLStatusTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"Enabled"]);
    
    mode = QCloudCOSXMLStatusDisabled;
    strType = QCloudCOSXMLStatusTransferToString(mode);
    XCTAssertTrue([strType isEqualToString:@"Disabled"]);
    
    mode = -1;
    strType = QCloudCOSXMLStatusTransferToString(mode);
    XCTAssertTrue(strType == nil);
    
    strType = @"Enabled";
    mode = QCloudCOSXMLStatusDumpFromString(strType);
    XCTAssertTrue(mode == QCloudCOSXMLStatusEnabled);
    
    strType = @"Disabled";
    mode = QCloudCOSXMLStatusDumpFromString(strType);
    XCTAssertTrue(mode == QCloudCOSXMLStatusDisabled);
    
    strType = @"test";
    mode = QCloudCOSXMLStatusDumpFromString(strType);
    XCTAssertTrue(mode == 0);
}

- (void)testQCloudRecognitionEnum {
    NSString * string = QCloudRecognitionEnumTransferToString(QCloudRecognitionPorn | QCloudRecognitionTerrorist | QCloudRecognitionPolitics | QCloudRecognitionAds | QCloudRecognitionIllegal | QCloudRecognitionAbuse);
    NSArray * nums = [string componentsSeparatedByString:@","];
    XCTAssertTrue(nums.count == 6);
    
    QCloudTaskStatesEnum Submitted = QCloudTaskStatesEnumFromString(@"Submitted");
    XCTAssertTrue(Submitted == QCloudTaskStatesSubmitted);
    QCloudTaskStatesEnum Running = QCloudTaskStatesEnumFromString(@"Running");
    XCTAssertTrue(Running == QCloudTaskStatesRunning);
    QCloudTaskStatesEnum Success = QCloudTaskStatesEnumFromString(@"Success");
    XCTAssertTrue(Success == QCloudTaskStatesSuccess);
    QCloudTaskStatesEnum Failed = QCloudTaskStatesEnumFromString(@"Failed");
    XCTAssertTrue(Failed == QCloudTaskStatesFailed);
    QCloudTaskStatesEnum Pause = QCloudTaskStatesEnumFromString(@"Pause");
    XCTAssertTrue(Pause == QCloudTaskStatesPause);
    QCloudTaskStatesEnum Cancel = QCloudTaskStatesEnumFromString(@"Cancel");
    XCTAssertTrue(Cancel == QCloudTaskStatesCancel);
    
    NSString * type = QCloudBucketRefererTypeTransferToString(QCloudBucketRefererTypeBlackList );
    NSString * type1 = QCloudBucketRefererTypeTransferToString(QCloudBucketRefererTypeWhiteList);
    NSString * type2 = QCloudBucketRefererTypeTransferToString(-1);
    XCTAssertTrue([type isEqualToString:@"Black-List"]);
    XCTAssertTrue([type1 isEqualToString:@"White-List"]);
    
    NSString * status =  QCloudBucketRefererStatusTransferToString(QCloudBucketRefererStatusEnabled);
    NSString * status1 = QCloudBucketRefererStatusTransferToString(QCloudBucketRefererStatusDisabled);
    NSString * status2 = QCloudBucketRefererStatusTransferToString(-1);
    XCTAssertTrue([status isEqualToString:@"Enabled"]);
    XCTAssertTrue([status1 isEqualToString:@"Disabled"]);
    
    NSString * configuration = QCloudBucketRefererConfigurationTransferToString(QCloudBucketRefererConfigurationDeny);
    NSString * configuration1 = QCloudBucketRefererConfigurationTransferToString(QCloudBucketRefererConfigurationAllow);
    NSString * configuration2 = QCloudBucketRefererConfigurationTransferToString(-1);
    XCTAssertTrue([configuration isEqualToString:@"Deny" ]);
    XCTAssertTrue([configuration1 isEqualToString:@"Allow" ]);
    
    NSString * videoRecon = QCloudVideoRecognitionModeTransferToString(QCloudVideoRecognitionModeInterval);
    XCTAssertTrue([videoRecon isEqualToString:@"Interval" ]);
    videoRecon = QCloudVideoRecognitionModeTransferToString(QCloudVideoRecognitionModeAverage);
    XCTAssertTrue([videoRecon isEqualToString:@"Average" ]);
    videoRecon = QCloudVideoRecognitionModeTransferToString(QCloudVideoRecognitionModeFps);
    XCTAssertTrue([videoRecon isEqualToString:@"Fps" ]);
    videoRecon = QCloudVideoRecognitionModeTransferToString(-1);
    XCTAssertTrue([videoRecon isEqualToString:@"" ]);
}

- (void)testQCloudFaceEffectEnum {
    
    NSString *  QCloudFaceEffectNoneStr = QCloudFaceEffectEnumTransferToString(QCloudFaceEffectNone);
    NSString *  QCloudFaceEffectBeautifyStr = QCloudFaceEffectEnumTransferToString(QCloudFaceEffectBeautify);
    NSString *  QCloudFaceEffectGenderTransformationStr = QCloudFaceEffectEnumTransferToString(QCloudFaceEffectGenderTransformation);
    NSString *  QCloudFaceEffectAgeTransformationStr = QCloudFaceEffectEnumTransferToString(QCloudFaceEffectAgeTransformation);
    NSString *  QCloudFaceEffectSegmentationStr = QCloudFaceEffectEnumTransferToString(QCloudFaceEffectSegmentation);
    
    QCloudFaceEffectEnum QCloudFaceEffectNoneEnum = QCloudFaceEffectEnumFromString(QCloudFaceEffectNoneStr);
    QCloudFaceEffectEnum QCloudFaceEffectBeautifyEnum = QCloudFaceEffectEnumFromString(QCloudFaceEffectBeautifyStr);
    QCloudFaceEffectEnum QCloudFaceEffectGenderTransformationEnum = QCloudFaceEffectEnumFromString(QCloudFaceEffectGenderTransformationStr);
    QCloudFaceEffectEnum QCloudFaceEffectAgeTransformationEnum = QCloudFaceEffectEnumFromString(QCloudFaceEffectAgeTransformationStr);
    QCloudFaceEffectEnum QCloudFaceEffectSegmentationEnum = QCloudFaceEffectEnumFromString(QCloudFaceEffectSegmentationStr);

}

-(void)testScopesArrayFunction{
    NSArray * requsets = @[
        QCloudDeleteBucketCORSRequest.class,
        QCloudDeleteBucketLifeCycleRequest.class,
        QCloudDeleteBucketReplicationRequest.class,
        QCloudDeleteBucketRequest.class,
        QCloudDeleteObjectRequest.class,
        QCloudGetBucketAccelerateRequest.class,
        QCloudGetBucketACLRequest.class,
        QCloudGetBucketCORSRequest.class,
        QCloudGetBucketLifecycleRequest.class,
        QCloudGetBucketLocationRequest.class,
        QCloudGetBucketReplicationRequest.class,
        QCloudGetBucketRequest.class,
        QCloudGetBucketVersioningRequest.class,
        QCloudGetObjectACLRequest.class,
        QCloudGetServiceRequest.class,
        QCloudHeadBucketRequest.class,
        QCloudOptionsObjectRequest.class,
        QCloudPostObjectRestoreRequest.class,
        QCloudPutBucketAccelerateRequest.class,
        QCloudPutBucketACLRequest.class,
        QCloudPutBucketCORSRequest.class,
        QCloudPutBucketLifecycleRequest.class,
        QCloudPutBucketReplicationRequest.class,
        QCloudPutBucketRequest.class,
        QCloudPutBucketVersioningRequest.class,
        QCloudPutObjectACLRequest.class,
        QCloudGetObjectRequest.class,
        QCloudHeadObjectRequest.class,
        QCloudPutObjectRequest.class,
    
    ];
    
    for (Class clazz in requsets) {
        QCloudBizHTTPRequest * request = [clazz new];
        NSArray * scopes = request.scopesArray;
        NSDictionary * dic = [scopes firstObject];
        NSString * action = dic[@"action"];
        NSString * className = NSStringFromClass(clazz);
        
        action = [[action componentsSeparatedByString:@":"] lastObject];
        
        className = [className stringByReplacingOccurrencesOfString:@"QCloud" withString:@""];
        className = [className stringByReplacingOccurrencesOfString:@"Request" withString:@""];
        if (![action isEqualToString:className]) {
            NSLog(@"%@",action);
        }
        XCTAssertTrue([action isEqualToString:className]);
    }
    
    
}

- (void)testModelCoverage {
  NSArray * models =  @[
      
      QCloudRecognitionOcrResults.class,
      QCloudRecognitionLabels.class,
      QCloudRecognitionSectionItemInfo.class,
      QCloudRecognitionSectionItemLibResults.class,
      QCloudImageRecognitionResult.class,
      QCloudImageRecognitionResultInfo.class,
      QCloudCIQRcodeInfo.class,
      QCloudCIQRCodePoint.class,
      QCloudBucketPolicyResult.class,
      QCloudBucketPolicyResultItem.class,
      QCloudAudioAsrqueueResult.class,
      QCloudAudioAsrqueueResultNonExistPIDs.class,
      QCloudCIQRCodeLocation.class,
      QCloudWebRecognitionResult.class,
      QCloudWebRecognitionImageResults.class,
      QCloudWebRecognitionImageResultsItem.class,
      QCloudWebRecognitionImageResultsItemInfo.class,
      QCloudWebRecognitionTextResults.class,
      QCloudWebRecognitionTextResultsItem.class,
      QCloudPostWebRecognitionResult.class,
      QCloudVideoRecognitionResult.class,
      QCloudVideoRecognitionSnapshot.class,
      QCloudVideoRecognitionAudioSection.class,
      QCloudPostVideoRecognitionResult.class,
      QCloudDocRecognitionResult.class,
      QCloudDocRecognitionPageSegment.class,
      QCloudDocRecognitionPageSegmentItem.class,
      QCloudDocRecognitionPageSegmentResultsInfo.class,
      QCloudPostDocRecognitionResult.class,
      QCloudPostAudioDiscernTaskInfo.class,
      QCloudPostAudioDiscernTaskResult.class,
      QCloudPostAudioDiscernTaskJobsDetail.class,
      QCloudPostAudioDiscernTaskJobsOperation.class,
      QCloudPostVideoTagResult.class,
      QCloudPostVideoTagResultJobsDetail.class,
      QCloudPostVideoTagResultInput.class,
      QCloudPostVideoTagResultOperation.class,
      QCloudPostVideoTagResultVideoTagResult.class,
      QCloudPostVideoTagResultStreamData.class,
      QCloudPostVideoTagResultData.class,
      QCloudPostVideoTagResultTags.class,
      QCloudPostVideoTagResultPlaceTags.class,
      QCloudPostVideoTagResultPersonTags.class,
      QCloudPostVideoTagResultActionTags.class,
      QCloudPostVideoTagResultObjectTags.class,
      QCloudPostVideoTagResultObjects.class,
      QCloudPostVideoTagResultDetailPerSecond.class,
      QCloudPostVideoTagResultBBox.class,
      QCloudPostVideoTag.class,
      QCloudPostVideoTagInput.class,
      QCloudPostVideoTagOperation.class,
      QCloudPostVideoTagVideoTag.class,
      QCloudAudioRecognitionResult.class,
      QCloudAudioRecognitionSection.class,
      QCloudPostAudioRecognitionResult.class,
      QCloudGetAudioDiscernTaskResult.class,
      QCloudDescribeMediaInfo.class,
    
      QCloudInventoryOptionalFields.class,
      QCloudDomainConfiguration.class,
      QCloudWebsiteRoutingRules.class,
      QCloudCIOCRWordPolygon.class,
      QCloudCIOCRWordCoordPoint.class,
      QCloudCIOCRWords.class,
      QCloudCIOCRTextDetections.class,
      QCloudCIOCRResult.class,
      QCloudInventorySchedule.class,
      QCloudWebisteErrorDocument.class,
      QCloudWebsiteIndexDocument.class,
      QCloudInventoryDestination.class,
      QCloudWebsiteRedirectAllRequestsTo.class,
      QCloudInventoryFilter.class,
      QCloudWebsiteRoutingRule.class,
      QCloudWebsiteCondition.class,
      QCloudWebsiteRedirect.class,
      QCloudDomainRule.class,
      QCloudWebsiteConfiguration.class,
      QCloudSelectObjectContentConfig.class,
      QCloudInventoryConfiguration.class,
      QCloudInventoryBucketDestination.class,
      QCloudWordsGeneralizeResultGeneralize.class,
      QCloudCILogoRecognitionResult.class,
      QCloudRecognitionObjectResults.class,
      QCloudCILogoRecognitionLogoInfo.class,
      QCloudAIJobQueueResultUpdateResult.class,
      QCloudAudioAsrqueueQueueListItem.class,
      QCloudBatchImageRecognitionResult.class,
      QCloudUploadObjectResult.class,
      QCloudMultipartUploadPart.class,
      QCloudInitiateMultipartUploadResult.class,
      QCloudLifecycleExpiration.class,
      QCloudBucketOwner.class,
      QCloudACLPolicy.class,
      QCloudACLOwner.class,
      QCloudMultipartUploadOwner.class,
      QCloudLoggingEnabled.class,
      QCloudMultipartInfo.class,
      QCloudMultipartUploadInitiator.class,
      QCloudCIPicLabelsInfo.class,
      QCloudPostWebRecognitionResult.class,
      QCloudLifecycleRuleFilter.class,
      QCloudTagging.class,
      QCloudVersionOwner.class,
      QCloudGetAudioOpenBucketListResult.class,
      QCloudBucketLoggingStatus.class,
      QCloudBucketLocationConstraint.class,
      QCloudUploadPartResult.class,
      QCloudCopyObjectResult.class,
      QCloudBucket.class,
      QCloudGetWordsGeneralizeResult.class,
      QCloudGetWordsGeneralizeOperation.class,
      QCloudCreateMediaJobResponse.class,
      QCloudWorkflowexecutionResult.class,
      QCloudWorkflowexecutionResultWE.class,
      QCloudWorkflowexecutionResultTasks.class,
      QCloudGetAsrBucketResponse.class,
      QCloudGetFilePreviewResult.class,
      QCloudPutObjectWatermarkResult.class,
      QCloudPutObjectOriginalInfo.class,
      QCloudPutObjectProcessResults.class,
      QCloudPutObjectObj.class,
      QCloudPostTranscodeJobsDetail.class,
      QCloudPostTranscodeInput.class,
      QCloudPostTranscodeOperation.class,
      QCloudInputPostTranscode.class,
      QCloudInputPostTranscodeInput.class,
      QCloudInputPostTranscodeOperation.class,
      QCloudInputPostTranscodeOutput.class,
      QCloudInputPostTranscodeSubtitles.class,
      QCloudInputPostTranscodeTranscode.class,
      QCloudInputPostTranscodeWatermark.class,
      QCloudInputPostTranscodeRWatermark.class,
      QCloudInputPostTranscodeSubtitle.class,
      QCloudMediaResult.class,
      QCloudMediaResultOutputFile.class,
      QCloudMediaResultOutputFileMd5Info.class,
      QCloudJobsDetailMix.class,
      QCloudJobsDetailMixEffectConfig.class,
      QCloudContainerSnapshotConfig.class,
      QCloudTemplateContainerClipConfig.class,
      QCloudAudioConfig.class,
      QCloudAudioMix.class,
      QCloudCallBackMqConfig.class,
      QCloudCreateWorkflowMediaWorkflow.class,
      QCloudCreateWorkflowResponseMediaWorkflow.class,
      QCloudCreateWorkflowTopology.class,
      QCloudEffectConfig.class,
      QCloudMediaInfo.class,
      QCloudMediaInfoFormat.class,
      QCloudMediaInfoStream.class,
      QCloudMediaInfoStreamAudio.class,
      QCloudMediaInfoStreamSubtitle.class,
      QCloudMediaInfoStreamVideo.class,
      QCloudMediaResult.class,
      QCloudMediaResultOutputFile.class,
      QCloudNoiseReduction.class,
      QCloudNoiseReductionTempleteResponseTemplate.class,
      QCloudNotifyConfig.class,
      QCloudSpeechRecognition.class,
      QCloudSpeechRecognitionTempleteResponseTemplate.class,
      QCloudVideoTargetRec.class,
      QCloudVideoTargetTempleteResponseTemplate.class,
      QCloudVoiceSeparateTempleteResponseTemplate.class,
      QCloudVoiceSeparateTempleteResponseVoiceSeparate.class,
      QCloudVoiceSynthesisTempleteResponseTemplate.class,
      QCloudVoiceSynthesisTempleteResponseTtsTpl.class,
      QCloudPutObjectImageInfo.class,
      QCloudVideoMontageJobsDetail.class,
      QCloudVideoMontageJobsDetailInput.class,
      QCloudVideoMontageJobsDetailOperation.class,
      QCloudInputVideoMontage.class,
      QCloudInputVideoMontageInput.class,
      QCloudInputVideoMontageOperation.class,
      QCloudInputVideoMontageOutput.class,
      QCloudInputVideoMontageVideoMontage.class,
      QCloudBucketOwner.class,
      QCloudACLPolicy.class,
      QCloudPostConcatJobsDetail.class,
      QCloudPostConcatJobsDetailInput.class,
      QCloudPostConcatJobsDetailOperation.class,
      QCloudInputPostConcat.class,
      QCloudInputPostConcatInput.class,
      QCloudInputPostConcatOperation.class,
      QCloudInputPostConcatOutput.class,
      QCloudInputPostConcatTemplate.class,
      QCloudInputPostConcatFragment.class,
      QCloudPostVideoTargetRecResponseJobsDetail.class,
      QCloudPostVideoTargetRecResponseOperation.class,
      QCloudPostVideoTargetRecResponseVideoTargetRecResult.class,
      QCloudPostVideoTargetRecResponseBodyRecognition.class,
      QCloudPostVideoTargetRecResponseBodyInfo.class,
      QCloudPostVideoTargetRecResponseLocation.class,
      QCloudPostVideoTargetRecResponseCarRecognition.class,
      QCloudPostVideoTargetRecResponseCarInfo.class,
      QCloudPostVideoTargetRecResponsePetRecognition.class,
      QCloudPostVideoTargetRecResponsePetInfo.class,
      QCloudPostVideoTargetRecInput.class,
      QCloudPostVideoTargetRecOperation.class,
      QCloudAILicenseRecResponseIdInfo.class,
      QCloudAILicenseRecResponseLocation.class,
      QCloudWorkflowexecutionResult.class,
      QCloudVideoMontage.class,
      QCloudPostConcat.class,
      QCloudPostVideoTargetRecResponse.class,
      QCloudAILicenseRecResponse.class,
      QCloudPostAnimation.class,
      QCloudPostAnimationJobsDetail.class,
      QCloudPostAnimationJobsDetailInput.class,
      QCloudPostAnimationJobsDetailOperation.class,
      QCloudInputPostAnimation.class,
      QCloudInputPostAnimationInput.class,
      QCloudInputPostAnimationOperation.class,
      QCloudInputPostAnimationOperationOutput.class,
      QCloudInputPostAnimationOperationAnimation.class,
      QCloudUpdateAIQueueResponseQueue.class,
      QCloudUpdateAIQueueResponse.class,
      QCloudVoiceSeparateJobsDetail.class,
      QCloudVoiceSeparateInput.class,
      QCloudVoiceSeparateOperation.class,
      QCloudInputVoiceSeparate.class,
      QCloudInputVoiceSeparateInput.class,
      QCloudInputVoiceSeparateOperation.class,
      QCloudInputVoiceSeparateOutput.class,
      QCloudVoiceSeparate.class,
      QCloudAudioVoiceSeparateAudioConfig.class,
      QCloudVoiceSeparateResult.class,
      QCloudPostAudioDiscernTaskInfoInput.class,
      QCloudPostAudioDiscernOperation.class,
      QCloudPostAudioDiscernRecognition.class,
      QCloudPostAudioDiscernTaskInfoOutput.class,
      QCloudPostAudioDiscernTaskJobsDetail.class,
      QCloudPostAudioDiscernTaskJobsOperation.class,
      QCloudPostAudioDiscernTaskResultInput.class,
      QCloudPostAudioDiscernRecognitionResult.class,
      QCloudPostAudioDiscernSpeechWords.class,
      QCloudPostAudioDiscernResultDetail.class,
      QCloudPostAudioDiscernFlashResult.class,
      QCloudPostAudioDiscernSentenceList.class,
      QCloudPostAudioDiscernResultWordList.class,
      QCloudPostAudioDiscernTaskInfo.class,
      QCloudPostSpeechRecognitionResponseJobsDetail.class,
      QCloudPostSpeechRecognitionInput.class,
      QCloudPostSpeechRecognitionResponseOperation.class,
      QCloudPostSpeechRecognitionOutput.class,
      QCloudPostSpeechRecognitionResponseSpeechRecognitionResult.class,
      QCloudPostSpeechRecognitionResponseFlashResult.class,
      QCloudPostSpeechRecognitionResponsesentence_list.class,
      QCloudPostSpeechRecognitionResponseword_list.class,
      QCloudPostSpeechRecognitionResponseResultDetail.class,
      QCloudPostSpeechRecognitionResponseWords.class,
      QCloudPostSpeechRecognitionOperation.class,
      QCloudVideoSnapshotJobsDetail.class,
      QCloudVideoSnapshotJobsDetailInput.class,
      QCloudVideoSnapshotJobsDetailOperation.class,
      QCloudInputVideoSnapshot.class,
      QCloudInputVideoSnapshotInput.class,
      QCloudInputVideoSnapshotOperation.class,
      QCloudInputVideoSnapshotOperationOutput.class,
      QCloudVideoSnapshot.class,
      QCloudPostImageProcessJobsDetail.class,
      QCloudPostImageProcessInput.class,
      QCloudPostImageProcessOperation.class,
      QCloudInputPostImageProcess.class,
      QCloudInputPostImageProcessInput.class,
      QCloudInputPostImageProcessOperation.class,
      QCloudInputPostImageProcessOutput.class,
      QCloudPostSmartCoverJobsDetail.class,
      QCloudPostSmartCoverJobsDetailInput.class,
      QCloudPostSmartCoverJobsDetailOperation.class,
      QCloudInputPostSmartCover.class,
      QCloudInputPostSmartCoverInput.class,
      QCloudInputPostSmartCoverOperation.class,
      QCloudInputPostSmartOutput.class,
      QCloudInputPostSmartOperationCover.class,
      QCloudVocalScoreResponseJobsDetail.class,
      QCloudVocalScoreInput.class,
      QCloudVocalScoreResponseOperation.class,
      QCloudVocalScoreResponseVocalScoreResult.class,
      QCloudVocalScoreResponsePitchScore.class,
      QCloudVocalScoreResponseSentenceScores.class,
      QCloudVocalScoreResponseRhythemScore.class,
      QCloudVocalScoreResponseRhythemScoreSentenceScores.class,
      QCloudVocalScoreVocalScore.class,
      QCloudVocalScoreOperation.class,
      QCloudVideoRecognitionItemInfo.class,
      QCloudVideoRecognitionSnapshot.class,
      QCloudVideoRecognitionAudioSection.class,
      QCloudRecognitionObjectLibResult.class,
      QCloudVideoRecognitionResult.class,
      QCloudRecognitionObjectResults.class,
      QCloudRecognitionLocationInfo.class,
      QCloudRecognitionLabelsItem.class,
      QCloudRecognitionSectionItemLibResults.class,
      QCloudRecognitionResultsItem.class,
      QCloudRecognitionOcrResults.class,
      QCloudBatchImageRecognitionResultInfo.class,
      QCloudBatchImageRecognitionResultItem.class,
      QCloudBatchRecognitionListInfo.class,
      QCloudBatchRecognitionListInfoListResults.class,
      QCloudBatchImageRecognitionResult.class,
      QCloudBatchGetAudioDiscernTaskResult.class,
      QCloudWorkflowexecutionResultWE.class,
      QCloudWorkflowexecutionResultTasks.class,
      QCloudWorkflowFileInfo.class,
      QCloudWorkflowResultInfo.class,
      QCloudWorkflowJudgementInfo.class,
      QCloudWorkflowBasicInfo.class,
      QCloudWorkflowMediaInfo.class,
      QCloudWorkflowImageInfo.class,
      QCloudWorkflowObjectInfo.class,
      QCloudWorkflowexecutionResultVideo.class,
      QCloudWorkflowexecutionResultAudio.class,
      QCloudWorkflowexecutionResultFormat.class,
      QCloudWorkflowSpriteObjectInfo.class,
      QCloudWorkflowJudgementResult.class,
      QCloudWorkflowInputObjectInfo.class,
      QCloudWorkflowExecutionTopology.class,
      QCloudGetFilePreviewHtmlResult.class,
      QCloudRecognitionResultsItemInfo.class,
      QCloudTextRecognitionSection.class,
      QCloudPostWordsGeneralizeResponseJobsDetail.class,
      QCloudPostWordsGeneralizeInput.class,
      QCloudPostWordsGeneralizeResponseOperation.class,
      QCloudPostWordsGeneralizeResponseWordsGeneralizeResult.class,
      QCloudPostWordsGeneralizeResponseWordsGeneralizeLable.class,
      QCloudPostWordsGeneralizeResponseWordsGeneralizeToken.class,
      QCloudPostWordsGeneralizeWordsGeneralize.class,
      QCloudPostWordsGeneralizeOperation.class,
      QCloudPostWordsGeneralizeResponse.class,
      QCloudPostSoundHoundResponseSoundHoundResult.class,
      QCloudPostSoundHoundResponse.class,
      QCloudPostSoundHoundResponseJobsDetail.class,
      QCloudPostSoundHoundInput.class,
      QCloudPostSoundHoundResponseOperation.class,
      QCloudPostSoundHoundResponseSoundHoundResult.class,
      QCloudPostSoundHoundResponseSongList.class,
      QCloudPostSoundHoundOperation.class,
      // Manager/model 补充覆盖
      QCloudAccessControlList.class,
      QCloudACLGrant.class,
      QCloudACLGrantee.class,
      QCloudCORSConfiguration.class,
      QCloudCORSRule.class,
      QCloudBucketReplicationConfiguation.class,
      QCloudBucketReplicationRule.class,
      QCloudBucketReplicationDestination.class,
      QCloudLifecycleConfiguration.class,
      QCloudLifecycleRule.class,
      QCloudIntelligentTieringConfiguration.class,
      QCloudIntelligentTieringTransition.class,
      QCloudDeleteResult.class,
      QCloudDeleteObjectInfo.class,
      QCloudOwner.class,
      QCloudBucketContents.class,
      QCloudListMultipartUploadsResult.class,
      QCloudListMultipartUploadContent.class,
      QCloudBucketVersioningConfiguration.class,
      QCloudBucketAccelerateConfiguration.class,
      QCloudNoncurrentVersionExpiration.class,
      QCloudNoncurrentVersionTransition.class,
      QCloudLifecycleAbortIncompleteMultipartUpload.class,
      QCloudLifecycleRuleFilterAnd.class,
      QCloudLifecycleTag.class,
      QCloudLifecycleTransition.class,
      // MateData/model 补充覆盖
      QCloudCreateDatasetResponse.class,
      QCloudCreateFileMetaIndexResponse.class,
      QCloudDeleteDatasetBindingResponse.class,
      QCloudDeleteDatasetResponse.class,
      QCloudDeleteFileMetaIndexResponse.class,
      QCloudUpdateFileMetaIndexResponse.class,
      QCloudUpdateFileProcessQueueResponse.class,
      QCloudPostSpeechRecognitionTempleteResponse.class,
      QCloudPostVoiceSeparateTempleteResponse.class,
      QCloudUpdateVoiceSeparateTempleteResponse.class,
      QCloudUpdateNoiseReductionTempleteResponse.class,
      QCloudPostNoiseReductionTempleteResponse.class,
      QCloudPostVideoTargetTempleteResponse.class,
      QCloudUpdateVideoTargetTempleteResponse.class,
      QCloudUpdateSpeechRecognitionTempleteResponse.class,
      QCloudGetAIBucketResponse.class,
      // CI/model Response 补充覆盖
      QCloudAIDetectPetResponse.class,
      QCloudAIGameRecResponse.class,
      QCloudAIIDCardOCRResponse.class,
      QCloudAssessQualityResponse.class,
      QCloudCloseAIBucketResponse.class,
      QCloudCloseAsrBucketResponse.class,
      QCloudCreateFileZipProcessJobsResponse.class,
      QCloudCreateHashProcessJobsResponse.class,
      QCloudCreateQRcodeResponse.class,
      QCloudDescribeFileProcessQueuesResponse.class,
      QCloudDescribeFileUnzipJobsResponse.class,
      QCloudDescribeFileZipProcessJobsResponse.class,
      QCloudDescribeHashProcessJobsResponse.class,
      QCloudGetActionSequenceResponse.class,
      QCloudGetLiveCodeResponse.class,
      QCloudLivenessRecognitionResponse.class,
      QCloudOpenAsrBucketResponse.class,
      QCloudPostFileUnzipProcessJobResponse.class,
      QCloudPostHashProcessJobsResponse.class,
      QCloudPostNoiseReductionResponse.class,
      QCloudPostSegmentVideoBodyResponse.class,
      QCloudPostTranslationResponse.class,
      QCloudPostVoiceSynthesisResponse.class,
      QCloudRecognitionQRcodeResponse.class,
      
  ];
    for (Class clazz in models) {
        if([clazz respondsToSelector:@selector(modelContainerPropertyGenericClass)]){
            [clazz performSelector:@selector(modelContainerPropertyGenericClass)];
        }
        if([clazz respondsToSelector:@selector(modelCustomPropertyMapper)]){
            [clazz performSelector:@selector(modelCustomPropertyMapper)];
        }
        NSObject * obj = [clazz new];
        if([obj respondsToSelector:@selector(modelCustomTransformToDictionary:)]){
            [obj performSelector:@selector(modelCustomTransformToDictionary:) withObject:nil];
            [obj performSelector:@selector(modelCustomTransformToDictionary:) withObject:@{}];
        }
        
        if([obj respondsToSelector:@selector(modelCustomWillTransformFromDictionary:)]){
            [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
            [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{}];
            [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"JobsDetail":@{}}];
        }
    }
    
    
    NSArray * requests = @[
        QCloudPutObjectWatermarkRequest.class,
        QCloudGetFilePreviewRequest.class,
        QCloudGetGenerateSnapshotRequest.class,
        QCloudCICloudDataOperationsRequest.class,
        QCloudQRCodeRecognitionRequest.class,
        QCloudCIPicRecognitionRequest.class,
        QCloudGetDescribeMediaBucketsRequest.class,
        QCloudGetMediaInfoRequest.class,
        QCloudGetVideoRecognitionRequest.class,
        QCloudPostVideoRecognitionRequest.class,
        QCloudGetAudioRecognitionRequest.class,
        QCloudPostAudioRecognitionRequest.class,
        QCloudGetTextRecognitionRequest.class,
        QCloudPostTextRecognitionRequest.class,
        QCloudGetDocRecognitionRequest.class,
        QCloudPostDocRecognitionRequest.class,
        QCloudGetWebRecognitionRequest.class,
        QCloudPostWebRecognitionRequest.class,
        QCloudBatchimageRecognitionRequest.class,
        QCloudSyncImageRecognitionRequest.class,
        QCloudGetImageRecognitionRequest.class,
        QCloudUpdateAudioDiscernTaskQueueRequest.class,
        QCloudGetAudioDiscernTaskQueueRequest.class,
        QCloudBatchGetAudioDiscernTaskRequest.class,
        QCloudGetAudioDiscernTaskRequest.class,
        QCloudPostAudioDiscernTaskRequest.class,
        QCloudGetAudioDiscernOpenBucketListRequest.class,
        QCloudOpenAIBucketRequest.class,
        QCloudGetAIJobQueueRequest.class,
        QCloudPostWordsGeneralizeTaskRequest.class,
        QCloudGetWordsGeneralizeTaskRequest.class,
        QCloudCIDetectCarRequest.class,
        QCloudCIOCRRequest.class,
        QCloudCIBodyRecognitionRequest.class,
        QCloudCIAutoTranslationRequest.class,
        QCloudCIFaceEffectRequest.class,
        QCloudCIDetectFaceRequest.class,
        QCloudCIRecognizeLogoRequest.class,
        QCloudCIGetGoodsMattingRequest.class,
        QCloudCIImageRepairRequest.class,
        QCloudPostLiveVideoRecognitionRequest.class,
        QCloudCancelLiveVideoRecognitionRequest.class,
        QCloudGetLiveVideoRecognitionRequest.class,
        QCloudGetDescribeMediaBucketsRequest.class,
        QCloudAppendObjectRequest.class,
        QCloudGetObjectACLRequest.class,
        QCloudPutObjectACLRequest.class,
        QCloudDeleteObjectRequest.class,
        QCloudDeleteMultipleObjectRequest.class,
        QCloudHeadObjectRequest.class,
        QCloudOptionsObjectRequest.class,
        QCloudAbortMultipfartUploadRequest.class,
        QCloudGetBucketRequest.class,
        QCloudGetBucketACLRequest.class,
        QCloudGetBucketCORSRequest.class,
        QCloudGetBucketLocationRequest.class,
        QCloudGetBucketLifecycleRequest.class,
        QCloudPutBucketRequest.class,
        QCloudPutBucketACLRequest.class,
        QCloudPutBucketCORSRequest.class,
        QCloudPutBucketLifecycleRequest.class,
        QCloudDeleteBucketRequest.class,
        QCloudDeleteObjectTaggingRequest.class,
        QCloudDeleteBucketCORSRequest.class,
        QCloudDeleteBucketLifeCycleRequest.class,
        QCloudHeadBucketRequest.class,
        QCloudListBucketMultipartUploadsRequest.class,
        QCloudPutObjectCopyRequest.class,
        QCloudDeleteBucketRequest.class,
        QCloudPutBucketVersioningRequest.class,
        QCloudGetBucketVersioningRequest.class,
        QCloudPutBucketReplicationRequest.class,
        QCloudGetBucketReplicationRequest.class,
        QCloudDeleteBucketReplicationRequest.class,
        QCloudGetServiceRequest.class,
        QCloudUploadPartCopyRequest.class,
        QCloudPostObjectRestoreRequest.class,
        QCloudListObjectVersionsRequest.class,
        QCloudGetPresignedURLRequest.class,
        QCloudGetBucketLoggingRequest.class,
        QCloudPutBucketLoggingRequest.class,
        QCloudPutBucketTaggingRequest.class,
        QCloudGetBucketTaggingRequest.class,
        QCloudDeleteBucketTaggingRequest.class,
        QCloudPutBucketInventoryRequest.class,
        QCloudGetBucketInventoryRequest.class,
        QCloudDeleteBucketInventoryRequest.class,
        QCloudListBucketInventoryConfigurationsRequest.class,
        QCloudPutBucketWebsiteRequest.class,
        QCloudGetBucketWebsiteRequest.class,
        QCloudGetBucketDomainRequest.class,
        QCloudPutBucketDomainRequest.class,
        QCloudDeleteBucketWebsiteRequest.class,
        QCloudSelectObjectContentRequest.class,
        QCloudPutBucketAccelerateRequest.class,
        QCloudGetBucketAccelerateRequest.class,
        QCloudGetObjectTaggingRequest.class,
        QCloudPutBucketTaggingRequest.class,
        QCloudPutBucketIntelligentTieringRequest.class,
        QCloudGetBucketIntelligentTieringRequest.class,
        QCloudPutBucketRefererRequest.class,
        QCloudGetBucketRefererRequest.class,
        QCloudPutObjectTaggingRequest.class,
        QCloudGetBucketPolicyRequest.class,
        QCloudPutBucketPolicyRequest.class,
        QCloudDeleteBucketPolicyRequest.class,
        QCloudGetDiscernMediaJobsRequest.class,
        QCloudCIUploadOperationsRequest.class,
        QCloudRecognitionBadCaseRequest.class,
        QCloudGetPrivateM3U8Request.class,
        QCloudUpdateMediaQueueRequest.class,
        QCloudGetWorkflowDetailRequest.class,
        QCloudGetListWorkflowRequest.class,
        QCloudPostTriggerWorkflowRequest.class,
        QCloudPostMediaJobsRequest.class,
        QCloudPostAudioTransferJobsRequest.class,
        QCloudPostVideoTagRequest.class,
        QCloudVideoMontageRequest.class,
        QCloudVideoSnapshotRequest.class,
        QCloudPostTranscodeRequest.class,
        QCloudPostAnimationRequest.class,
        QCloudPostConcatRequest.class,
        QCloudPostSmartCoverRequest.class,
        QCloudPostVoiceSeparateRequest.class,
        QCloudPostNumMarkRequest.class,
        QCloudExtractNumMarkRequest.class,
        QCloudPostImageProcessRequest.class,
        QCloudGetMediaJobRequest.class,
        QCloudCreateMediaJobRequest.class,
        QCloudGetMediaJobListRequest.class,
        QCloudPostTextAuditReportRequest.class,
        QCloudPostImageAuditReportRequest.class,
        QCloudOpenAIBucketRequest.class,
        QCloudGetAIBucketRequest.class,
        QCloudCloseAIBucketRequest.class,
        QCloudUpdateAIQueueRequest.class,
        QCloudAIImageColoringRequest.class,
        QCloudAISuperResolutionRequest.class,
        QCloudAIEnhanceImageRequest.class,
        QCloudAIImageCropRequest.class,
        QCloudCreateQRcodeRequest.class,
        QCloudAIGameRecRequest.class,
        QCloudAssessQualityRequest.class,
        QCloudAIDetectPetRequest.class,
        QCloudAIIDCardOCRRequest.class,
        QCloudLivenessRecognitionRequest.class,
        QCloudGetLiveCodeRequest.class,
        QCloudGetActionSequenceRequest.class,
        QCloudAILicenseRecRequest.class,
        QCloudImageSearchBucketRequest.class,
        QCloudAddImageSearchRequest.class,
        QCloudGetSearchImageRequest.class,
        QCloudDeleteImageSearchRequest.class,
        QCloudPostTranslationRequest.class,
        QCloudPostWordsGeneralizeRequest.class,
        QCloudPostVideoTargetRecRequest.class,
        QCloudPostVideoTargetTempleteRequest.class,
        QCloudUpdateVideoTargetTempleteRequest.class,
        QCloudPostSegmentVideoBodyRequest.class,
        QCloudOpenAsrBucketRequest.class,
        QCloudCloseAsrBucketRequest.class,
        QCloudPostVoiceSeparateTempleteRequest.class,
        QCloudUpdateVoiceSeparateTempleteRequest.class,
        QCloudPostNoiseReductionRequest.class,
        QCloudPostNoiseReductionTempleteRequest.class,
        QCloudUpdateNoiseReductionTempleteRequest.class,
        QCloudPostVoiceSynthesisRequest.class,
        QCloudPostVoiceSynthesisTempleteRequest.class,
        QCloudUpdateVoiceSynthesisTempleteRequest.class,
        QCloudPostSpeechRecognitionRequest.class,
        QCloudPostSpeechRecognitionTempleteRequest.class,
        QCloudUpdateSpeechRecognitionTempleteRequest.class,
        QCloudPostSoundHoundRequest.class,
        QCloudVocalScoreRequest.class,
        QCloudCIUploadOperationsRequest.class,
        QCloudGetFilePreviewHtmlRequest.class,
        QCloudZipFilePreviewResponse.class,
        QCloudDescribeFileZipProcessJobsResponse.class,
        QCloudGetSearchImageResponse.class,
        QCloudZipFilePreviewResponse.class,
        
        
    ];
    
    for (Class clazz in requests) {
        NSObject * obj = [clazz new];
        if([obj respondsToSelector:@selector(signatureFields)]){
            [obj performSelector:@selector(signatureFields)];
        }
        if([obj respondsToSelector:@selector(scopesArray)]){
            [obj performSelector:@selector(scopesArray)];
        }
        
        if([obj respondsToSelector:@selector(buildRequestData:)]){
            QCloudHTTPRequest * request = obj;
            NSError * error;
            
            if([obj respondsToSelector:@selector(setBucket:)]){
                [request buildRequestData:&error];
                [obj setValue:@"test-1253960454" forKey:@"bucket"];
            }
            
            if([obj respondsToSelector:@selector(setObject:)]){
                [obj setValue:@"" forKey:@"bucket"];
                [request buildRequestData:&error];
                [obj setValue:@"object" forKey:@"object"];
            }
        }
    }
}

-(void)testModelCoverage1{
    QCloudSerializationJSON * json = [QCloudSerializationJSON new];
    [json performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"OutoutJSONFileType":@"LINKS"}];
    CASJobParameters * job = [CASJobParameters new];
    [job performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"Tier":@"test"}];

    QCloudGetPresignedURLRequest * getpresignedReq = [QCloudGetPresignedURLRequest new];
    [getpresignedReq contentType];
    [getpresignedReq contentMD5];
    [getpresignedReq setValue:@"test" forRequestHeader:@"test"];
    [getpresignedReq setURICompnent:@"test"];
    [getpresignedReq setValue:@"test" forRequestParameter:@"test"];

    NSError * error;
    QCloudPutBucketRefererRequest * request = [QCloudPutBucketRefererRequest new];
    [request buildRequestData:&error];
    request.refererType = 1;
    [request buildRequestData:&error];
    request.status = QCloudBucketRefererStatusEnabled;
    [request buildRequestData:&error];
    request.domainList = @[@""];
    [request buildRequestData:&error];
    
    QCloudPutObjectRequest * putRequest = [QCloudPutObjectRequest new];
    putRequest.cacheControl = @"";
    putRequest.contentDisposition = @"";
    putRequest.expect = @"";
    putRequest.contentSHA1 = @"";
    putRequest.expires = @"";
    putRequest.storageClass = QCloudCOSStorageStandard;
    putRequest.accessControlList = @"";
    putRequest.grantRead = @"";
    putRequest.grantWrite = @"";
    putRequest.grantFullControl = @"";
    putRequest.versionID = @"";
    putRequest.trafficLimit = 123;
    
    QCloudAppendObjectRequest * objRequest = [QCloudAppendObjectRequest new];
    objRequest.cacheControl = @"";
    objRequest.contentDisposition = @"";
    objRequest.expect = @"";
    objRequest.contentSHA1 = @"";
    objRequest.expires = @"";
    objRequest.storageClass = QCloudCOSStorageStandard;
    objRequest.accessControlList = @"";
    objRequest.grantRead = @"";
    objRequest.grantWrite = @"";
    objRequest.grantFullControl = @"";

    QCloudBucketRefererInfo * info = [QCloudBucketRefererInfo new];
    [info performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"123":@[@"123",@"123"]}];
    
    QCloudCOSXMLService * service = [QCloudCOSXMLService new];
    
    NSError * verror = [NSError new];
    QCloudPostVideoRecognitionRequest * videorequest = [QCloudPostVideoRecognitionRequest new];

    videorequest.count = 1;
    videorequest.mode = QCloudVideoRecognitionModeFps;
    [videorequest buildRequestData:&verror];
    videorequest.count = 0;
    [videorequest buildRequestData:&verror];
    videorequest.dataId = @"dataId";
    [videorequest buildRequestData:&verror];
    videorequest.userInfo = QCloudBatchRecognitionUserInfo.new;
    [videorequest buildRequestData:&verror];
    videorequest.Encryption = QCloudBatchRecognitionEncryption.new;
    [videorequest buildRequestData:&verror];
    videorequest.pornScore = 1;
    [videorequest buildRequestData:&verror];
    videorequest.adsScore = 1;
    [videorequest buildRequestData:&verror];
    videorequest.terrorismScore = 1;
    [videorequest buildRequestData:&verror];
    videorequest.politicsScore = 1;
    [videorequest buildRequestData:&verror];
    
    videorequest.count = 1;
    videorequest.mode = QCloudVideoRecognitionModeAverage;
    [videorequest buildRequestData:&verror];
    videorequest.count = 0;
    [videorequest buildRequestData:&verror];
    
    videorequest.count = 1;
    videorequest.mode = QCloudVideoRecognitionModeFps;
    [videorequest buildRequestData:&verror];
    videorequest.count = 0;
    [videorequest buildRequestData:&verror];
    
    QCloudGetAIJobQueueRequest * aiRequest = [QCloudGetAIJobQueueRequest new];
    aiRequest.queueId = @"test";
    aiRequest.state = 2;
    [aiRequest buildRequestData:&verror];
    
    QCloudCIGetGoodsMattingRequest * mrequest = [QCloudCIGetGoodsMattingRequest new];
    mrequest.detectUrl = @"test";
    [mrequest buildRequestData:&verror];
    
    QCloudPostWebRecognitionRequest * wrequest = [QCloudPostWebRecognitionRequest new];
    wrequest.url = @"test";
    [wrequest buildRequestData:&verror];
    wrequest.bucket = @"bucket";
    [wrequest buildRequestData:&verror];
    
    QCloudGetDescribeMediaBucketsRequest * brequest = [QCloudGetDescribeMediaBucketsRequest new];
    brequest.regions = @[@"test"];
    brequest.bucketNames = @[@"test"];
    brequest.pageNumber = 1;
    [brequest buildRequestData:&verror];
    
    QCloudPutBucketACLRequest * prequest = [QCloudPutBucketACLRequest new];
    prequest.accessControlList = @"test";
    prequest.grantRead = @"test";
    prequest.grantWrite = @"test";
    prequest.grantReadACP = @"test";
    prequest.grantWriteACP = @"test";
    prequest.grantFullControl = @"test";
    [prequest buildRequestData:&verror];
    
    
    QCloudBatchGetAudioDiscernTaskRequest * taskrequest = [[QCloudBatchGetAudioDiscernTaskRequest alloc]init];
    taskrequest.bucket = @"bucket";
    [taskrequest buildRequestData:&verror];
    taskrequest.queueId = @"queueid";
    
    [taskrequest buildRequestData:&verror];
    taskrequest.tag = @"tag";
    [taskrequest buildRequestData:&verror];
}

-(void)testCoverQCloudPutObjectRequest{
    NSError * error;
    QCloudPutObjectRequest * request = [QCloudPutObjectRequest new];
    [request buildRequestData:&error];
    
    request.object = @"test";
    [request buildRequestData:&error];
    
    request.bucket = @"test";
    [request buildRequestData:&error];
    
    request.cacheControl = @"cacheControl";
    request.contentDisposition = @"contentDisposition";
    request.expect = @"expect";
    request.expires = @"expires";
    request.contentSHA1 = @"contentSHA1";
    request.contentDisposition = @"contentDisposition";
    request.storageClass = QCloudCOSStorageStandard;
    request.accessControlList = @"accessControlList";
    request.grantRead = @"grantRead";
    request.grantWrite = @"grantWrite";
    request.grantFullControl = @"grantFullControl";
    request.trafficLimit = 1000;
    [request buildRequestData:&error];
}

-(void)testCoverQCloudAppendObjectRequest{
    NSError * error;
    QCloudAppendObjectRequest * request = [QCloudAppendObjectRequest new];
    [request buildRequestData:&error];
    
    request.bucket = @"test";
    [request buildRequestData:&error];
    
    request.object = @"test";
    [request buildRequestData:&error];
    
    request.cacheControl = @"cacheControl";
    request.contentDisposition = @"contentDisposition";
    request.expect = @"expect";
    request.expires = @"expires";
    request.contentSHA1 = @"contentSHA1";
    request.contentDisposition = @"contentDisposition";
    request.storageClass = QCloudCOSStorageStandard;
    request.accessControlList = @"accessControlList";
    request.grantRead = @"grantRead";
    request.grantWrite = @"grantWrite";
    request.grantFullControl = @"grantFullControl";
    [request buildRequestData:&error];
    
    QCloudDeleteMarker * obj = [QCloudDeleteMarker new];
    [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"isLatest":@"True"}.mutableCopy];
    obj = [QCloudDeleteMarker new];
    [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"isLatest":@"False"}.mutableCopy];
    
    QCloudDeleteMarker * objCar = [QCloudDeleteMarker new];
    [objCar performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"isLatest":@"True"}.mutableCopy];
    objCar = [QCloudDeleteMarker new];
    [objCar performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"isLatest":@"False"}.mutableCopy];
    objCar = [QCloudDeleteMarker new];
    [objCar performSelector:@selector(modelCustomTransformToDictionary:) withObject:nil];
    objCar = [QCloudDeleteMarker new];
    [objCar performSelector:@selector(modelCustomTransformToDictionary:) withObject:@{@"isLatest":@"True"}.mutableCopy];
    objCar = [QCloudDeleteMarker new];
    [objCar performSelector:@selector(modelCustomTransformToDictionary:) withObject:@{@"isLatest":@"False"}.mutableCopy];

    QCloudVersionContent * objContent = [QCloudVersionContent new];
    [objContent performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"isLatest":@"True"}.mutableCopy];
    objContent = [QCloudVersionContent new];
    [objContent performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"isLatest":@"False"}.mutableCopy];
    
    [objContent performSelector:@selector(modelCustomTransformToDictionary:) withObject:nil];
    objContent = [QCloudVersionContent new];
    [objContent performSelector:@selector(modelCustomTransformToDictionary:) withObject:@{@"isLatest":@"True"}.mutableCopy];
    objContent = [QCloudVersionContent new];
    [objContent performSelector:@selector(modelCustomTransformToDictionary:) withObject:@{@"isLatest":@"False"}.mutableCopy];
    
    
    QCloudListBucketResult * listContent = [QCloudListBucketResult new];
    [listContent performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"IsTruncated":@"True"}.mutableCopy];
    listContent = [QCloudListBucketResult new];
    [listContent performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"IsTruncated":@"False"}.mutableCopy];
    
    [listContent performSelector:@selector(modelCustomTransformToDictionary:) withObject:nil];
    listContent = [QCloudListBucketResult new];
    [listContent performSelector:@selector(modelCustomTransformToDictionary:) withObject:@{@"IsTruncated":@"True"}.mutableCopy];
    listContent = [QCloudListBucketResult new];
    [listContent performSelector:@selector(modelCustomTransformToDictionary:) withObject:@{@"IsTruncated":@"False"}.mutableCopy];

    QCloudBucketRefererInfo * objR = [QCloudBucketRefererInfo new];
    [objR performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    [objR performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"DomainList.Domain":NSNull.new}];
    [objR performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"DomainList.Domain":@"test"}];
    
    QCloudCIDetectCarTags * objPlate = [QCloudCIDetectCarTags new];
    [objPlate performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    [objPlate performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"PlateContent":@{}}];
    [objPlate performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"CarLocation":@{}}];
    
    QCloudWebRecognitionTextResults * cloudWebRecognitionTextResults = [QCloudWebRecognitionTextResults new];
    [cloudWebRecognitionTextResults performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    [cloudWebRecognitionTextResults performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"Results":@{}}];
    
    QCloudDomainConfiguration * domainConfig = [QCloudDomainConfiguration new];
    [domainConfig performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    [domainConfig performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"DomainRule":NSNull.new}];
    [domainConfig performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"DomainRule":@"test"}];

    QCloudListAllMyBucketsResult * bucketResult = [QCloudListAllMyBucketsResult new];
    [bucketResult performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    [bucketResult performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"Buckets":NSNull.new}];
    [bucketResult performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"Buckets":@"test"}];
    
    QCloudListPartsResult * result = [QCloudListPartsResult new];
    [result performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    [result performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"Part":NSNull.new}];
    [result performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"Part":@"test"}];
    
    
    QCloudWebsiteRoutingRules * resultRules = [QCloudWebsiteRoutingRules new];
    [resultRules performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    [resultRules performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"RoutingRule":NSNull.new}];
    [resultRules performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"RoutingRule":@"test"}];
    
    QCloudInventoryOptionalFields * optionalFields = [QCloudInventoryOptionalFields new];
    [optionalFields performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    [optionalFields performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"Field":NSNull.new}];
    [optionalFields performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"Field":@"test"}];
    
    
    
    QCloudAILicenseRecResponse * RecResponse = [QCloudAILicenseRecResponse new];
    [RecResponse performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    [RecResponse performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"IdInfo":NSNull.new}];
    [RecResponse performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"IdInfo":@{}}];
    
    
    QCloudGetMediaJobResponse * JobResponse = [QCloudGetMediaJobResponse new];
    [JobResponse performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    [JobResponse performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"JobsDetail":NSNull.new}];
    [JobResponse performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"JobsDetail":@{}}];

    
    QCloudGetFilePreviewResult * PreviewResult = [QCloudGetFilePreviewResult new];
    [PreviewResult performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    [PreviewResult performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"JobsDetail":NSNull.new}];
    [PreviewResult performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"JobsDetail":@{}}];
    [PreviewResult performSelector:@selector(modelCustomTransformToDictionary:) withObject:@{}.mutableCopy];
    

    QCloudDeleteInfo * cloudDeleteInfo = [QCloudDeleteInfo new];
    [cloudDeleteInfo performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    [cloudDeleteInfo performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"Object":NSNull.new}];
    [cloudDeleteInfo performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"Object":@"test"}];
    [cloudDeleteInfo performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"Quiet":@"True"}.mutableCopy];
    [cloudDeleteInfo performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"Quiet":@"False"}.mutableCopy];
    [cloudDeleteInfo performSelector:@selector(modelCustomTransformToDictionary:) withObject:@{@"Quiet":@"True"}.mutableCopy];
    [cloudDeleteInfo performSelector:@selector(modelCustomTransformToDictionary:) withObject:@{@"Quiet":@"False"}.mutableCopy];
    
    QCloudSerializationCSV * cloudSerializationCSV = [QCloudSerializationCSV new];
    [cloudSerializationCSV performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    [cloudSerializationCSV performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"FileHeaderInfo":@{}}];
    [cloudSerializationCSV performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"QuoteFields":@{}}];
    
    QCloudWebRecognitionImageResultsItemInfo * cloudWebRecognitionImageResultsItemInfo = [QCloudWebRecognitionImageResultsItemInfo new];
    [cloudWebRecognitionImageResultsItemInfo performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    [cloudWebRecognitionImageResultsItemInfo performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"OcrResults":@{}}];
    [cloudWebRecognitionImageResultsItemInfo performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"ObjectResults":@{}}];
    
    QCloudCIOCRResult * cloudCIOCRResult = [QCloudCIOCRResult new];
    [cloudCIOCRResult performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    [cloudCIOCRResult performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"TextDetections":@{}}];
    
    QCloudCIOCRTextDetections * textDetections = [QCloudCIOCRTextDetections new];
    [textDetections performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    [textDetections performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"Words":@{}}];
    
    [textDetections performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    [textDetections performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"Polygon":@{}}];
        
    QCloudDocRecognitionPageSegmentResultsInfo * cloudDocRecognitionPageSegmentResultsInfo = [QCloudDocRecognitionPageSegmentResultsInfo new];
    [cloudDocRecognitionPageSegmentResultsInfo performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    [cloudDocRecognitionPageSegmentResultsInfo performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"OcrResults":@{}}];
    [cloudDocRecognitionPageSegmentResultsInfo performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"OcrResults":NSNull.new}];
    [cloudDocRecognitionPageSegmentResultsInfo performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"ObjectResults":@{}}];
    [cloudDocRecognitionPageSegmentResultsInfo performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"ObjectResults":NSNull.new}];
    
    QCloudCILogoRecognitionResult * logoResult = QCloudCILogoRecognitionResult.new;
    [logoResult performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    [logoResult performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"LogoInfo":NSNull.new}];
    [logoResult performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"LogoInfo":@"test"}];
    
    QCloudTagSet * cloudTagSet = QCloudTagSet.new;
    [cloudTagSet performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    [cloudTagSet performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"Tag":NSNull.new}];
    [cloudTagSet performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"Tag":@"test"}];
    
    QCloudCIQRCodeLocation * cloudCIQRCodeLocation = QCloudCIQRCodeLocation.new;
    [cloudCIQRCodeLocation performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    [cloudCIQRCodeLocation performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"point":NSNull.new}];
    [cloudCIQRCodeLocation performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"point":@"test"}];
    
    QCloudAutoTranslationResult * cloudAutoTranslationResult = QCloudAutoTranslationResult.new;
    [cloudAutoTranslationResult performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    [cloudAutoTranslationResult performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"QueueList":NSNull.new}];
    [cloudAutoTranslationResult performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"QueueList":@"test"}];
    
    QCloudCIPicRecognitionResults * cloudCIPicRecognitionResults = QCloudCIPicRecognitionResults.new;
    [cloudCIPicRecognitionResults performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    [cloudCIPicRecognitionResults performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"Labels":NSNull.new}];
    [cloudCIPicRecognitionResults performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"Labels":@"test"}];
    
    QCloudRecognitionLabels * cloudRecognitionLabels = QCloudRecognitionLabels.new;
    [cloudRecognitionLabels performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    [cloudRecognitionLabels performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"LibResults":NSNull.new}];
    [cloudRecognitionLabels performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"LibResults":@"test"}];
    
    QCloudRecognitionSectionItemInfo * cloudRecognitionSectionItemInfo = QCloudRecognitionSectionItemInfo.new;
    [cloudRecognitionSectionItemInfo performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    [cloudRecognitionSectionItemInfo performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"LibResults":NSNull.new}];
    [cloudRecognitionSectionItemInfo performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"LibResults":@"test"}];
    
    
    QCloudListInventoryConfigurationResult * cloudListInventoryConfigurationResult = QCloudListInventoryConfigurationResult.new;
    [cloudListInventoryConfigurationResult performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    [cloudListInventoryConfigurationResult performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"InventoryConfiguration":NSNull.new}];
    [cloudListInventoryConfigurationResult performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"InventoryConfiguration":@"test"}];
    
    
    QCloudPostAudioDiscernTaskJobsDetail * jobDetail = [QCloudPostAudioDiscernTaskJobsDetail new];
    [jobDetail performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"State":@{}}];
    
    QCloudCILogoRecognitionResult * cloudCILogoRecognitionResult = [QCloudCILogoRecognitionResult new];
    [cloudCILogoRecognitionResult performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    [cloudCILogoRecognitionResult performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"LogoInfo":@{}}];
     
    
    
    QCloudListVersionsResult * cloudListVersionsResult = [QCloudListVersionsResult new];
    [cloudListVersionsResult performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"IsTruncated":@"True",@"DeleteMarker":@"DeleteMarker",@"Version":@"Version",@"CommonPrefixes":@"CommonPrefixes"}.mutableCopy];
    cloudListVersionsResult = [QCloudListVersionsResult new];
    [cloudListVersionsResult performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"IsTruncated":@"False",@"DeleteMarker":@"DeleteMarker",@"Version":@"Version",@"CommonPrefixes":@"CommonPrefixes"}.mutableCopy];
    
    [cloudListVersionsResult performSelector:@selector(modelCustomTransformToDictionary:) withObject:nil];
    cloudListVersionsResult = [QCloudListVersionsResult new];
    [cloudListVersionsResult performSelector:@selector(modelCustomTransformToDictionary:) withObject:@{@"IsTruncated":@"True",@"DeleteMarker":@"DeleteMarker",@"Version":@"Version",@"CommonPrefixes":@"CommonPrefixes"}.mutableCopy];
    cloudListVersionsResult = [QCloudListVersionsResult new];
    [cloudListVersionsResult performSelector:@selector(modelCustomTransformToDictionary:) withObject:@{@"IsTruncated":@"False",@"DeleteMarker":@"DeleteMarker",@"Version":@"Version",@"CommonPrefixes":@"CommonPrefixes"}.mutableCopy];
    
    QCloudGenerateSnapshotConfiguration * config = [QCloudGenerateSnapshotConfiguration new];
    [config performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@{@"Mode":@"Mode",@"Rotate":@"Rotate",@"Format":@"Format"}.mutableCopy];
    
    [QCloudCOSXMLService removeCosxmlServiceWithKey:@"test"];
    [QCloudCOSXMLService removeCOSXMLWithKey:@"test"];
    if ([QCloudCOSTransferMangerService hasTransferMangerServiceForKey:@"test"]) {
        [QCloudCOSTransferMangerService removeTransferMangerServiceWithKey:@"test"];
    }
}

-(void)testCoverQCloudPostLiveVideoRecognitionRequest{
    NSError * error;
    QCloudPostLiveVideoRecognitionRequest * request = [QCloudPostLiveVideoRecognitionRequest new];
    [request buildRequestData:&error];
    
    request.url = @"test";
    [request buildRequestData:&error];
    
    request.bucket = @"test";
    [request buildRequestData:&error];
    
    request.bizType = @"test";
    request.userInfo = QCloudBatchRecognitionUserInfo.new;
    request.dataId = @"test";
    request.callback = @"callback";
    [request buildRequestData:&error];
    
    QCloudCIBodyRecognitionRequest * ciRequest = [QCloudCIBodyRecognitionRequest new];
    ciRequest.object = @"test";
    [ciRequest buildRequestData:&error];
    ciRequest.bucket = @"bucket";
    [ciRequest buildRequestData:&error];
    QCloudPutObjectACLRequest * aclRequest = [QCloudPutObjectACLRequest new];
    [aclRequest buildRequestData:&error];
    aclRequest.object = @"object";
    [aclRequest buildRequestData:&error];
    aclRequest.accessControlList = @"accessControlList";
    [aclRequest buildRequestData:&error];
    aclRequest.grantRead = @"grantRead";
    [aclRequest buildRequestData:&error];
    aclRequest.grantReadACP = @"grantReadACP";
    [aclRequest buildRequestData:&error];
    aclRequest.grantWriteACP = @"grantWriteACP";
    [aclRequest buildRequestData:&error];
    aclRequest.grantFullControl = @"grantFullControl";
    [aclRequest buildRequestData:&error];
    aclRequest.grantRead = @"grantRead";
    [aclRequest buildRequestData:&error];
    aclRequest.bucket = @"bucket";
    [aclRequest buildRequestData:&error];
    
    
    QCloudPutObjectWatermarkRequest * putRequest = [QCloudPutObjectWatermarkRequest new];
    putRequest.object = @"object";
    putRequest.bucket = @"bucket";
    putRequest.cacheControl = @"cacheControl";
    putRequest.contentDisposition = @"contentDisposition";
    putRequest.expect = @"expect";
    putRequest.contentSHA1 = @"contentSHA1";
    putRequest.expires = @"expires";
    putRequest.storageClass = QCloudCOSStorageStandard;
    putRequest.accessControlList = @"accessControlList";
    putRequest.grantRead = @"grantRead";
    putRequest.grantWrite = @"grantWrite";
    putRequest.grantFullControl = @"grantFullControl";
    putRequest.versionID = @"versionID";
    [putRequest buildRequestData:&error];
    
    
    QCloudCIImageRepairRequest * repairRequest = QCloudCIImageRepairRequest.new;
    [repairRequest buildRequestData:&error];
    repairRequest.object = @"object";
    [repairRequest buildRequestData:&error];
    repairRequest.maskPic = @"test";
    [repairRequest buildRequestData:&error];
    repairRequest.bucket = @"bucket";
    [repairRequest buildRequestData:&error];
    
    QCloudGetFilePreviewRequest * previewRequest = [QCloudGetFilePreviewRequest new];
    [previewRequest buildRequestData:&error];
    previewRequest.object = @"object";
    [previewRequest buildRequestData:&error];
    previewRequest.password = @"previewRequest";
    [previewRequest buildRequestData:&error];
    
    previewRequest.comment = @"comment";
    [previewRequest buildRequestData:&error];
    
    previewRequest.sheet = @"sheet";
    [previewRequest buildRequestData:&error];
    
    previewRequest.excelPaperDirection = @"excelPaperDirection";
    [previewRequest buildRequestData:&error];
    
    previewRequest.excelPaperSize = @"excelPaperSize";
    [previewRequest buildRequestData:&error];
    
    previewRequest.ImageParams = @"ImageParams";
    [previewRequest buildRequestData:&error];
    
    previewRequest.quality = @"quality";
    [previewRequest buildRequestData:&error];
    
    previewRequest.scale = @"scale";
    [previewRequest buildRequestData:&error];
    
    previewRequest.imageDpi = @"imageDpi";
    [previewRequest buildRequestData:&error];
    
    previewRequest.srcType = @"srcType";
    [previewRequest buildRequestData:&error];
    
    previewRequest.bucket = @"bucket";
    [previewRequest buildRequestData:&error];
    
    
    QCloudCIRecognizeLogoRequest * logoRequest = [QCloudCIRecognizeLogoRequest new];
    [logoRequest buildRequestData:&error];
    logoRequest.object = @"object";
    
    [logoRequest buildRequestData:&error];
    logoRequest.bucket = @"bucket";
    [logoRequest buildRequestData:&error];
    
    QCloudSelectObjectContentRequest * contentRequest = [QCloudSelectObjectContentRequest new];
    [contentRequest buildRequestData:&error];
    contentRequest.object = @"object";
    
    [contentRequest buildRequestData:&error];
    contentRequest.bucket = @"bucket";
    
    [contentRequest buildRequestData:&error];
    contentRequest.bucket = @"bucket";
    [contentRequest buildRequestData:&error];
    contentRequest.selectType = @"test";
    [contentRequest buildRequestData:&error];
    
    QCloudUpdateAudioDiscernTaskQueueRequest * taskRequest = [QCloudUpdateAudioDiscernTaskQueueRequest new];
    [taskRequest buildRequestData:&error];
    
    taskRequest.name = @"name";
    [taskRequest buildRequestData:&error];
    
    taskRequest.queueID = @"queueID";
    [taskRequest buildRequestData:&error];
    
    taskRequest.state = 1;
    [taskRequest buildRequestData:&error];
    
    taskRequest.state = 2;
    [taskRequest buildRequestData:&error];
    
    taskRequest.state = 2;
    [taskRequest buildRequestData:&error];
    
    taskRequest.notifyConfigUrl = @"notifyConfigUrl";
    [taskRequest buildRequestData:&error];
    
    taskRequest.notifyConfigType = @"notifyConfigType";
    [taskRequest buildRequestData:&error];
    
    taskRequest.notifyConfigEvent = @"notifyConfigEvent";
    [taskRequest buildRequestData:&error];
    
    
    QCloudQRCodeRecognitionRequest * reconRequest = QCloudQRCodeRecognitionRequest.new;
    [taskRequest buildRequestData:&error];
    reconRequest.object = @"object";
    [taskRequest buildRequestData:&error];
    reconRequest.bucket = @"bucket";
    [taskRequest buildRequestData:&error];
}

-(void)testCoverQCloudCIDetectFaceRequest{
    NSError * error;
    QCloudCIDetectFaceRequest * request = QCloudCIDetectFaceRequest.new;
    [request buildRequestData:&error];
    
    request.object = @"test";
    [request buildRequestData:&error];
    
    request.bucket = @"test";
    [request buildRequestData:&error];
}

-(void)testCoverQCloudCIOCRRequest{
    NSError * error;
    QCloudCIOCRRequest * request = QCloudCIOCRRequest.new;
    [request buildRequestData:&error];
    
    request.object = @"test";
    [request buildRequestData:&error];
    
    request.bucket = @"test";
    [request buildRequestData:&error];
    
}

-(void)testCoverQCloudCIDetectCarRequest{
    NSError * error;
    QCloudCIDetectCarRequest * request = QCloudCIDetectCarRequest.new;
    [request buildRequestData:&error];
    
    request.object = @"test";
    [request buildRequestData:&error];
    
    request.bucket = @"test";
    [request buildRequestData:&error];
}
-(void)testQCloudCIUploadOperationsRequest{
    NSError * error;
    QCloudCIUploadOperationsRequest * request = QCloudCIUploadOperationsRequest.new;
    [request buildRequestData:&error];
    
    request.object = @"test";
    [request buildRequestData:&error];
    
    request.bucket = @"test";
    [request buildRequestData:&error];
    
    request.body = [NSData new];
    [request buildRequestData:&error];
    
    request.cacheControl = @"cacheControl";
    [request buildRequestData:&error];
    
    request.contentType = @"contentType";
    [request buildRequestData:&error];
    
    request.contentDisposition = @"contentDisposition";
    [request buildRequestData:&error];
    
    request.expect = @"expect";
    [request buildRequestData:&error];
    
    request.contentSHA1 = @"contentSHA1";
    [request buildRequestData:&error];
    
    request.storageClass = QCloudCOSStorageStandard;
    [request buildRequestData:&error];
    
    request.accessControlList = @"public-read-write";
    [request buildRequestData:&error];
    
    request.grantRead = @"grantRead";
    [request buildRequestData:&error];
    
    request.grantWrite = @"grantWrite";
    [request buildRequestData:&error];
    
    request.grantFullControl = @"grantFullControl";
    [request buildRequestData:&error];
    
    request.versionID = @"versionID";
    [request buildRequestData:&error];
    
}
-(void)testQCloudGetMediaJobListRequest{
    NSError * error;
    QCloudGetMediaJobListRequest * request = QCloudGetMediaJobListRequest.new;
    
    request.bucket = @"test";
    request.queueId = @"queueId";
    request.queueType = @"queueType";
    request.queueId = @"queueId";
    request.queueType = @"queueType";
    request.tag = @"tag";
    request.workflowId = @"workflowId";
    request.inventoryTriggerJobId = @"inventoryTriggerJobId";
    request.inputObject = @"inputObject";
    request.orderByTime = @"orderByTime";
    request.nextToken = @"nextToken";
    request.size = @"size";
    request.states = @"states";
    request.startCreationTime = @"startCreationTime";
    request.endCreationTime = @"endCreationTime";
    request.bucket = @"bucket";
    [request buildRequestData:&error];
    
}

- (void)testGenerateSnapshotConfiguration {

    QCloudGetGenerateSnapshotRequest * shotRequest = [QCloudGetGenerateSnapshotRequest new];
    
    shotRequest.generateSnapshotConfiguration = [QCloudGenerateSnapshotConfiguration new];
    shotRequest.generateSnapshotConfiguration.time = 1;
    shotRequest.generateSnapshotConfiguration.mode = QCloudGenerateSnapshotModeExactframe;
    shotRequest.generateSnapshotConfiguration.rotate = QCloudGenerateSnapshotRotateTypeAuto;
    shotRequest.generateSnapshotConfiguration.width = 10;
    shotRequest.generateSnapshotConfiguration.height = 10;
    NSError * error;
    [shotRequest buildRequestData:&error];

}

- (void)testQCloudUpdateMediaQueueRequest {

    QCloudUpdateMediaQueueRequest * shotRequest = [QCloudUpdateMediaQueueRequest new];
    NSError * error;
    shotRequest.name = @"name";
    [shotRequest buildRequestData:&error];
    shotRequest.state = 1;
    [shotRequest buildRequestData:&error];
    shotRequest.queueID = @"queueID";
    [shotRequest buildRequestData:&error];
    shotRequest.notifyConfigUrl = @"notifyConfigUrl";
    [shotRequest buildRequestData:&error];
    shotRequest.notifyConfigType = @"notifyConfigType";
    [shotRequest buildRequestData:&error];
    shotRequest.notifyConfigEvent = @"notifyConfigEvent";
    [shotRequest buildRequestData:&error];
    shotRequest.notifyConfigState = @"notifyConfigState";
    [shotRequest buildRequestData:&error];
    shotRequest.ResultFormat = @"ResultFormat";
    [shotRequest buildRequestData:&error];
    shotRequest.MqMode = @"MqMode";
    [shotRequest buildRequestData:&error];
    shotRequest.MqRegion = @"MqRegion";
    [shotRequest buildRequestData:&error];
    shotRequest.MqName = @"MqName";
    [shotRequest buildRequestData:&error];
    shotRequest.bucket = @"examplebucket-1250000000";
    [shotRequest buildRequestData:&error];

}

- (void)testQCloudPostTextRecognitionRequest {
    QCloudPostTextRecognitionRequest * shotRequest = [QCloudPostTextRecognitionRequest new];
    
    NSError * error;
    [shotRequest buildRequestData:&error];
    
    shotRequest.object = @"object";
    [shotRequest buildRequestData:&error];
    shotRequest.url = @"url";
    [shotRequest buildRequestData:&error];
    shotRequest.content = @"content";
    [shotRequest buildRequestData:&error];
    shotRequest.dataId = @"dataId";
    [shotRequest buildRequestData:&error];
    shotRequest.bucket = @"bucket";
    [shotRequest buildRequestData:&error];
    shotRequest.bizType = @"bizType";
    [shotRequest buildRequestData:&error];
    shotRequest.callback = @"callback";
    [shotRequest buildRequestData:&error];
    shotRequest.callbackType = 1;
    [shotRequest buildRequestData:&error];
    shotRequest.pornScore = 1;
    [shotRequest buildRequestData:&error];
    shotRequest.adsScore = 1;
    [shotRequest buildRequestData:&error];
    shotRequest.illegalScore = 1;
    [shotRequest buildRequestData:&error];
    shotRequest.abuseScore = 1;
    [shotRequest buildRequestData:&error];
    shotRequest.terrorismScore = 1;
    [shotRequest buildRequestData:&error];
    shotRequest.politicsScore = 1;
    [shotRequest buildRequestData:&error];
    
}

- (void)testQCloudPostDocRecognitionRequest {
    QCloudPostDocRecognitionRequest * shotRequest = [QCloudPostDocRecognitionRequest new];
    NSError * error;
    [shotRequest buildRequestData:&error];
    shotRequest.object = @"object";
    [shotRequest buildRequestData:&error];
    shotRequest.url = @"url";
    [shotRequest buildRequestData:&error];
    shotRequest.dataId = @"dataId";
    [shotRequest buildRequestData:&error];
    shotRequest.bucket = @"bucket";
    [shotRequest buildRequestData:&error];
    shotRequest.bizType = @"bizType";
    [shotRequest buildRequestData:&error];
    shotRequest.callback = @"callback";
    [shotRequest buildRequestData:&error];
    shotRequest.callbackType = 1;
    [shotRequest buildRequestData:&error];
    shotRequest.pornScore = 1;
    [shotRequest buildRequestData:&error];
    shotRequest.adsScore = 1;
    [shotRequest buildRequestData:&error];
    shotRequest.terrorismScore = 1;
    [shotRequest buildRequestData:&error];
    shotRequest.politicsScore = 1;
    [shotRequest buildRequestData:&error];

}

-(void)testLog{
    [[QCloudLogManager sharedInstance] showLogs];
    [[QCloudLogManager sharedInstance] currentLogs];
    [[QCloudLogManager sharedInstance] readLog:@""];
    [[QCloudLogManager sharedInstance] shouldShowLog];
    
    QCloudLogTableViewController * logVC = [[QCloudLogTableViewController alloc]initWithLog:@[]];
    [logVC viewDidLoad];
    [logVC viewWillAppear:YES];
    [logVC viewWillAppear:YES];
    
}

#pragma mark - QCloudCommonModel 测试

- (void)testQCloudAggregations {
    QCloudAggregations *obj = [QCloudAggregations new];
    obj.Operation = @"max";
    obj.Field = @"Size";
    
    XCTAssertEqualObjects(obj.Operation, @"max");
    XCTAssertEqualObjects(obj.Field, @"Size");
}

- (void)testQCloudAggregationsResult {
    QCloudAggregationsResult *obj = [QCloudAggregationsResult new];
    obj.Operation = @"sum";
    obj.Value = 100.5;
    obj.Field = @"Size";
    
    XCTAssertEqualObjects(obj.Operation, @"sum");
    XCTAssertEqual(obj.Value, 100.5);
    XCTAssertEqualObjects(obj.Field, @"Size");
    
    // 测试 modelContainerPropertyGenericClass
    NSDictionary *genericClass = [[QCloudAggregationsResult class] performSelector:@selector(modelContainerPropertyGenericClass)];
    XCTAssertEqualObjects(genericClass[@"Groups"], [QCloudGroups class]);
    
    // 测试 modelCustomWillTransformFromDictionary - nil
    NSDictionary *result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    XCTAssertNil(result);
    
    // 测试 modelCustomWillTransformFromDictionary - 非字典
    result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@"not a dict"];
    XCTAssertNil(result);
    
    // 测试 modelCustomWillTransformFromDictionary - Groups 为字典
    NSDictionary *dictWithGroups = @{@"Groups": @{@"Count": @10, @"Value": @"test"}};
    result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:dictWithGroups];
    XCTAssertTrue([result[@"Groups"] isKindOfClass:[NSArray class]]);
    
    // 测试 modelCustomWillTransformFromDictionary - Groups 为数组
    NSDictionary *dictWithGroupsArray = @{@"Groups": @[@{@"Count": @10}]};
    result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:dictWithGroupsArray];
    XCTAssertTrue([result[@"Groups"] isKindOfClass:[NSArray class]]);
}

- (void)testQCloudBinding {
    QCloudBinding *obj = [QCloudBinding new];
    obj.URI = @"cos://examplebucket-1250000000";
    obj.State = @"Running";
    obj.CreateTime = @"2023-01-01T00:00:00Z";
    obj.UpdateTime = @"2023-01-02T00:00:00Z";
    obj.DatasetName = @"test-dataset";
    
    XCTAssertEqualObjects(obj.URI, @"cos://examplebucket-1250000000");
    XCTAssertEqualObjects(obj.State, @"Running");
    XCTAssertEqualObjects(obj.DatasetName, @"test-dataset");
}

- (void)testQCloudDataset {
    QCloudDataset *obj = [QCloudDataset new];
    obj.TemplateId = @"template-123";
    obj.Description = @"Test dataset";
    obj.CreateTime = @"2023-01-01T00:00:00Z";
    obj.UpdateTime = @"2023-01-02T00:00:00Z";
    obj.BindCount = 5;
    obj.FileCount = 100;
    obj.TotalFileSize = 1024000;
    obj.DatasetName = @"test-dataset";
    
    XCTAssertEqualObjects(obj.TemplateId, @"template-123");
    XCTAssertEqual(obj.BindCount, 5);
    XCTAssertEqual(obj.FileCount, 100);
    XCTAssertEqual(obj.TotalFileSize, 1024000);
}

- (void)testQCloudDatasets {
    QCloudDatasets *obj = [QCloudDatasets new];
    obj.TemplateId = @"template-456";
    obj.Description = @"Test datasets";
    obj.BindCount = 3;
    obj.FileCount = 50;
    obj.TotalFileSize = 512000;
    obj.DatasetName = @"datasets-name";
    
    XCTAssertEqualObjects(obj.TemplateId, @"template-456");
    XCTAssertEqual(obj.BindCount, 3);
}

- (void)testQCloudFile {
    QCloudFile *obj = [QCloudFile new];
    obj.CustomId = @"custom-123";
    obj.CustomLabels = @{@"key1": @"value1"};
    obj.Key = @"label-key";
    obj.Value = @"label-value";
    obj.MediaType = @"image";
    obj.ContentType = @"image/jpeg";
    obj.URI = @"cos://examplebucket-1250000000/test.jpg";
    obj.MaxFaceNum = 10;
    
    XCTAssertEqualObjects(obj.CustomId, @"custom-123");
    XCTAssertEqualObjects(obj.MediaType, @"image");
    XCTAssertEqual(obj.MaxFaceNum, 10);
    
    // 测试 modelContainerPropertyGenericClass
    NSDictionary *genericClass = [[QCloudFile class] performSelector:@selector(modelContainerPropertyGenericClass)];
    XCTAssertEqualObjects(genericClass[@"Persons"], [QCloudPersons class]);
    
    // 测试 modelCustomWillTransformFromDictionary - nil
    NSDictionary *result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    XCTAssertNil(result);
    
    // 测试 modelCustomWillTransformFromDictionary - 非字典
    result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@"not a dict"];
    XCTAssertNil(result);
    
    // 测试 modelCustomWillTransformFromDictionary - Persons 为字典
    NSDictionary *dictWithPersons = @{@"Persons": @{@"PersonId": @"person-1"}};
    result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:dictWithPersons];
    XCTAssertTrue([result[@"Persons"] isKindOfClass:[NSArray class]]);
}

- (void)testQCloudFileResult {
    QCloudFileResult *obj = [QCloudFileResult new];
    obj.ObjectId = @"obj-123";
    obj.CreateTime = @"2023-01-01T00:00:00Z";
    obj.UpdateTime = @"2023-01-02T00:00:00Z";
    obj.URI = @"cos://bucket/file.jpg";
    obj.Filename = @"file.jpg";
    obj.MediaType = @"image";
    obj.ContentType = @"image/jpeg";
    obj.COSStorageClass = @"STANDARD";
    obj.COSCRC64 = @"1234567890";
    obj.Size = 1024;
    obj.CacheControl = @"max-age=3600";
    obj.ContentDisposition = @"inline";
    obj.ContentEncoding = @"gzip";
    obj.ContentLanguage = @"en";
    obj.ServerSideEncryption = @"AES256";
    obj.ETag = @"etag-123";
    obj.FileModifiedTime = @"2023-01-01T00:00:00Z";
    obj.CustomId = @"custom-id";
    obj.CustomLabels = @{@"key": @"value"};
    obj.COSUserMeta = @{@"x-cos-meta-key": @"value"};
    obj.ObjectACL = @"private";
    obj.COSTagging = @{@"tag1": @"value1"};
    obj.COSTaggingCount = 1;
    obj.DatasetName = @"dataset";
    
    XCTAssertEqualObjects(obj.ObjectId, @"obj-123");
    XCTAssertEqual(obj.Size, 1024);
    XCTAssertEqual(obj.COSTaggingCount, 1);
}

- (void)testQCloudFilesDetail {
    QCloudFilesDetail *obj = [QCloudFilesDetail new];
    obj.CreateTime = @"2023-01-01T00:00:00Z";
    obj.UpdateTime = @"2023-01-02T00:00:00Z";
    obj.URI = @"cos://bucket/file.jpg";
    obj.Filename = @"file.jpg";
    obj.MediaType = @"video";
    obj.ContentType = @"video/mp4";
    obj.COSStorageClass = @"STANDARD_IA";
    obj.COSCRC64 = @"9876543210";
    obj.ObjectACL = @"public-read";
    obj.Size = 2048;
    obj.CacheControl = @"no-cache";
    obj.ETag = @"etag-456";
    obj.FileModifiedTime = @"2023-01-01T12:00:00Z";
    obj.CustomId = @"custom-456";
    obj.CustomLabels = @{@"label": @"test"};
    obj.DatasetName = @"dataset-2";
    
    XCTAssertEqualObjects(obj.MediaType, @"video");
    XCTAssertEqual(obj.Size, 2048);
}

- (void)testQCloudGroups {
    QCloudGroups *obj = [QCloudGroups new];
    obj.Count = 100;
    obj.Value = @"group-value";
    
    XCTAssertEqual(obj.Count, 100);
    XCTAssertEqualObjects(obj.Value, @"group-value");
}

- (void)testQCloudImageResult {
    QCloudImageResult *obj = [QCloudImageResult new];
    obj.URI = @"cos://bucket/image.jpg";
    obj.Score = 95;
    
    XCTAssertEqualObjects(obj.URI, @"cos://bucket/image.jpg");
    XCTAssertEqual(obj.Score, 95);
}

- (void)testQCloudObject {
    QCloudObject *obj = [QCloudObject new];
    obj.key = @"test-key";
    obj.value = @"test-value";
    
    XCTAssertEqualObjects(obj.key, @"test-key");
    XCTAssertEqualObjects(obj.value, @"test-value");
}

- (void)testQCloudPersons {
    QCloudPersons *obj = [QCloudPersons new];
    obj.PersonId = @"person-123";
    
    XCTAssertEqualObjects(obj.PersonId, @"person-123");
}

- (void)testQCloudQuery {
    QCloudQuery *obj = [QCloudQuery new];
    obj.Operation = @"and";
    obj.Field = @"Size";
    obj.Value = @"1024";
    
    XCTAssertEqualObjects(obj.Operation, @"and");
    XCTAssertEqualObjects(obj.Field, @"Size");
    XCTAssertEqualObjects(obj.Value, @"1024");
    
    // 测试 modelContainerPropertyGenericClass
    NSDictionary *genericClass = [[QCloudQuery class] performSelector:@selector(modelContainerPropertyGenericClass)];
    XCTAssertEqualObjects(genericClass[@"SubQueries"], [QCloudSubQueries class]);
    
    // 测试 modelCustomWillTransformFromDictionary - nil
    NSDictionary *result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    XCTAssertNil(result);
    
    // 测试 modelCustomWillTransformFromDictionary - 非字典
    result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@"string"];
    XCTAssertNil(result);
    
    // 测试 modelCustomWillTransformFromDictionary - SubQueries 为字典
    NSDictionary *dictWithSubQueries = @{@"SubQueries": @{@"Operation": @"eq", @"Field": @"Name"}};
    result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:dictWithSubQueries];
    XCTAssertTrue([result[@"SubQueries"] isKindOfClass:[NSArray class]]);
    
    // 测试 modelCustomWillTransformFromDictionary - SubQueries 为数组
    NSDictionary *dictWithSubQueriesArray = @{@"SubQueries": @[@{@"Operation": @"eq"}]};
    result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:dictWithSubQueriesArray];
    XCTAssertTrue([result[@"SubQueries"] isKindOfClass:[NSArray class]]);
}

- (void)testQCloudSubQueries {
    QCloudSubQueries *obj = [QCloudSubQueries new];
    obj.Value = @"test-value";
    obj.Operation = @"eq";
    obj.Field = @"Name";
    
    XCTAssertEqualObjects(obj.Value, @"test-value");
    XCTAssertEqualObjects(obj.Operation, @"eq");
    XCTAssertEqualObjects(obj.Field, @"Name");
}

- (void)testQCloudUpdateMetaFile {
    QCloudUpdateMetaFile *obj = [QCloudUpdateMetaFile new];
    obj.CustomId = @"custom-meta-id";
    obj.CustomLabels = @{@"meta-key": @"meta-value"};
    obj.Key = @"label-key";
    obj.Value = @"label-value";
    obj.MediaType = @"document";
    obj.ContentType = @"application/pdf";
    obj.URI = @"cos://bucket/doc.pdf";
    
    XCTAssertEqualObjects(obj.CustomId, @"custom-meta-id");
    XCTAssertEqualObjects(obj.MediaType, @"document");
    XCTAssertEqualObjects(obj.URI, @"cos://bucket/doc.pdf");
}

#pragma mark - QCloudDatasetFaceSearchResponse Tests

- (void)testQCloudDatasetFaceSearchResponse {
    QCloudDatasetFaceSearchResponse *obj = [QCloudDatasetFaceSearchResponse new];
    obj.RequestId = @"request-123";
    
    XCTAssertEqualObjects(obj.RequestId, @"request-123");
    
    // 测试 modelContainerPropertyGenericClass
    NSDictionary *genericClass = [[QCloudDatasetFaceSearchResponse class] performSelector:@selector(modelContainerPropertyGenericClass)];
    XCTAssertEqualObjects(genericClass[@"FaceResult"], [QCloudFaceResult class]);
    
    // 测试 modelCustomWillTransformFromDictionary - nil
    NSDictionary *result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    XCTAssertNil(result);
    
    // 测试 modelCustomWillTransformFromDictionary - 非字典
    result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@"not a dict"];
    XCTAssertNil(result);
    
    // 测试 modelCustomWillTransformFromDictionary - FaceResult 为字典
    NSDictionary *dictWithFaceResult = @{@"FaceResult": @{@"InputFaceBoundary": @{@"Height": @100}}};
    result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:dictWithFaceResult];
    XCTAssertTrue([result[@"FaceResult"] isKindOfClass:[NSArray class]]);
    
    // 测试 modelCustomWillTransformFromDictionary - FaceResult 为数组
    NSDictionary *dictWithFaceResultArray = @{@"FaceResult": @[@{@"InputFaceBoundary": @{@"Height": @100}}]};
    result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:dictWithFaceResultArray];
    XCTAssertTrue([result[@"FaceResult"] isKindOfClass:[NSArray class]]);
}

- (void)testQCloudFaceResult {
    QCloudFaceResult *obj = [QCloudFaceResult new];
    
    QCloudFaceBoundary *boundary = [QCloudFaceBoundary new];
    boundary.Height = 100;
    boundary.Width = 80;
    obj.InputFaceBoundary = boundary;
    
    XCTAssertEqual(obj.InputFaceBoundary.Height, 100);
    XCTAssertEqual(obj.InputFaceBoundary.Width, 80);
    
    // 测试 modelContainerPropertyGenericClass
    NSDictionary *genericClass = [[QCloudFaceResult class] performSelector:@selector(modelContainerPropertyGenericClass)];
    XCTAssertEqualObjects(genericClass[@"FaceInfos"], [QCloudFaceInfos class]);
    XCTAssertEqualObjects(genericClass[@"InputFaceBoundary"], [QCloudFaceBoundary class]);
    
    // 测试 modelCustomWillTransformFromDictionary - nil
    NSDictionary *result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    XCTAssertNil(result);
    
    // 测试 modelCustomWillTransformFromDictionary - 非字典
    result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@"string"];
    XCTAssertNil(result);
    
    // 测试 modelCustomWillTransformFromDictionary - FaceInfos 为字典
    NSDictionary *dictWithFaceInfos = @{@"FaceInfos": @{@"FaceId": @"face-1", @"Score": @95}};
    result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:dictWithFaceInfos];
    XCTAssertTrue([result[@"FaceInfos"] isKindOfClass:[NSArray class]]);
    
    // 测试 modelCustomWillTransformFromDictionary - FaceInfos 为数组
    NSDictionary *dictWithFaceInfosArray = @{@"FaceInfos": @[@{@"FaceId": @"face-1"}]};
    result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:dictWithFaceInfosArray];
    XCTAssertTrue([result[@"FaceInfos"] isKindOfClass:[NSArray class]]);
}

- (void)testQCloudFaceBoundary {
    QCloudFaceBoundary *obj = [QCloudFaceBoundary new];
    obj.Height = 200;
    obj.Width = 150;
    obj.Left = 50;
    obj.Top = 30;
    
    XCTAssertEqual(obj.Height, 200);
    XCTAssertEqual(obj.Width, 150);
    XCTAssertEqual(obj.Left, 50);
    XCTAssertEqual(obj.Top, 30);
}

- (void)testQCloudFaceInfos {
    QCloudFaceInfos *obj = [QCloudFaceInfos new];
    obj.PersonId = @"person-456";
    obj.FaceId = @"face-789";
    obj.Score = 98;
    obj.URI = @"cos://bucket/face.jpg";
    
    QCloudFaceBoundary *boundary = [QCloudFaceBoundary new];
    boundary.Height = 120;
    boundary.Width = 100;
    obj.FaceBoundary = boundary;
    
    XCTAssertEqualObjects(obj.PersonId, @"person-456");
    XCTAssertEqualObjects(obj.FaceId, @"face-789");
    XCTAssertEqual(obj.Score, 98);
    XCTAssertEqualObjects(obj.URI, @"cos://bucket/face.jpg");
    XCTAssertEqual(obj.FaceBoundary.Height, 120);
    
    // 测试 modelContainerPropertyGenericClass
    NSDictionary *genericClass = [[QCloudFaceInfos class] performSelector:@selector(modelContainerPropertyGenericClass)];
    XCTAssertEqualObjects(genericClass[@"FaceBoundary"], [QCloudFaceBoundary class]);
}

- (void)testQCloudDatasetFaceSearch {
    QCloudDatasetFaceSearch *obj = [QCloudDatasetFaceSearch new];
    obj.DatasetName = @"face-dataset";
    obj.URI = @"cos://bucket/search.jpg";
    obj.MaxFaceNum = 5;
    obj.Limit = 20;
    obj.MatchThreshold = 80;
    
    XCTAssertEqualObjects(obj.DatasetName, @"face-dataset");
    XCTAssertEqualObjects(obj.URI, @"cos://bucket/search.jpg");
    XCTAssertEqual(obj.MaxFaceNum, 5);
    XCTAssertEqual(obj.Limit, 20);
    XCTAssertEqual(obj.MatchThreshold, 80);
}

#pragma mark - QCloudDatasetSimpleQueryResponse Tests

- (void)testQCloudDatasetSimpleQueryResponse {
    QCloudDatasetSimpleQueryResponse *obj = [QCloudDatasetSimpleQueryResponse new];
    obj.RequestId = @"request-simple-query";
    obj.NextToken = @"next-token-123";
    
    XCTAssertEqualObjects(obj.RequestId, @"request-simple-query");
    XCTAssertEqualObjects(obj.NextToken, @"next-token-123");
    
    // 测试 modelContainerPropertyGenericClass
    NSDictionary *genericClass = [[QCloudDatasetSimpleQueryResponse class] performSelector:@selector(modelContainerPropertyGenericClass)];
    XCTAssertEqualObjects(genericClass[@"Files"], [QCloudFileResult class]);
    XCTAssertEqualObjects(genericClass[@"Aggregations"], [QCloudAggregationsResult class]);
    
    // 测试 modelCustomWillTransformFromDictionary - nil
    NSDictionary *result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    XCTAssertNil(result);
    
    // 测试 modelCustomWillTransformFromDictionary - 非字典
    result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@"not a dict"];
    XCTAssertNil(result);
    
    // 测试 modelCustomWillTransformFromDictionary - Files 为字典
    NSDictionary *dictWithFiles = @{@"Files": @{@"ObjectId": @"obj-1", @"URI": @"cos://bucket/file.jpg"}};
    result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:dictWithFiles];
    XCTAssertTrue([result[@"Files"] isKindOfClass:[NSArray class]]);
    
    // 测试 modelCustomWillTransformFromDictionary - Files 为数组
    NSDictionary *dictWithFilesArray = @{@"Files": @[@{@"ObjectId": @"obj-1"}]};
    result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:dictWithFilesArray];
    XCTAssertTrue([result[@"Files"] isKindOfClass:[NSArray class]]);
    
    // 测试 modelCustomWillTransformFromDictionary - Aggregations 为字典
    NSDictionary *dictWithAggregations = @{@"Aggregations": @{@"Operation": @"sum", @"Value": @100}};
    result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:dictWithAggregations];
    XCTAssertTrue([result[@"Aggregations"] isKindOfClass:[NSArray class]]);
    
    // 测试 modelCustomWillTransformFromDictionary - Aggregations 为数组
    NSDictionary *dictWithAggregationsArray = @{@"Aggregations": @[@{@"Operation": @"sum"}]};
    result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:dictWithAggregationsArray];
    XCTAssertTrue([result[@"Aggregations"] isKindOfClass:[NSArray class]]);
    
    // 测试 modelCustomWillTransformFromDictionary - Files 和 Aggregations 同时为字典
    NSDictionary *dictWithBoth = @{
        @"Files": @{@"ObjectId": @"obj-1"},
        @"Aggregations": @{@"Operation": @"count"}
    };
    result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:dictWithBoth];
    XCTAssertTrue([result[@"Files"] isKindOfClass:[NSArray class]]);
    XCTAssertTrue([result[@"Aggregations"] isKindOfClass:[NSArray class]]);
}

- (void)testQCloudDatasetSimpleQuery {
    QCloudDatasetSimpleQuery *obj = [QCloudDatasetSimpleQuery new];
    obj.DatasetName = @"simple-query-dataset";
    obj.MaxResults = 50;
    obj.NextToken = @"token-abc";
    obj.Sort = @"Size,Filename";
    obj.Order = @"asc,desc";
    obj.WithFields = @"URI,Size,Filename";
    
    QCloudQuery *query = [QCloudQuery new];
    query.Operation = @"eq";
    query.Field = @"ContentType";
    query.Value = @"image/jpeg";
    obj.Query = query;
    
    XCTAssertEqualObjects(obj.DatasetName, @"simple-query-dataset");
    XCTAssertEqual(obj.MaxResults, 50);
    XCTAssertEqualObjects(obj.NextToken, @"token-abc");
    XCTAssertEqualObjects(obj.Sort, @"Size,Filename");
    XCTAssertEqualObjects(obj.Order, @"asc,desc");
    XCTAssertEqualObjects(obj.WithFields, @"URI,Size,Filename");
    XCTAssertEqualObjects(obj.Query.Operation, @"eq");
    
    // 测试 modelContainerPropertyGenericClass
    NSDictionary *genericClass = [[QCloudDatasetSimpleQuery class] performSelector:@selector(modelContainerPropertyGenericClass)];
    XCTAssertEqualObjects(genericClass[@"Query"], [QCloudQuery class]);
    XCTAssertEqualObjects(genericClass[@"Aggregations"], [QCloudAggregations class]);
}

#pragma mark - QCloudSearchImageResponse Tests

- (void)testQCloudSearchImageResponse {
    QCloudSearchImageResponse *obj = [QCloudSearchImageResponse new];
    obj.RequestId = @"request-search-image";
    
    XCTAssertEqualObjects(obj.RequestId, @"request-search-image");
    
    // 测试 modelContainerPropertyGenericClass
    NSDictionary *genericClass = [[QCloudSearchImageResponse class] performSelector:@selector(modelContainerPropertyGenericClass)];
    XCTAssertEqualObjects(genericClass[@"ImageResult"], [QCloudImageResult class]);
    
    // 测试 modelCustomWillTransformFromDictionary - nil
    NSDictionary *result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    XCTAssertNil(result);
    
    // 测试 modelCustomWillTransformFromDictionary - 非字典
    result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@"not a dict"];
    XCTAssertNil(result);
    
    // 测试 modelCustomWillTransformFromDictionary - ImageResult 为字典
    NSDictionary *dictWithImageResult = @{@"ImageResult": @{@"URI": @"cos://bucket/image.jpg", @"Score": @95}};
    result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:dictWithImageResult];
    XCTAssertTrue([result[@"ImageResult"] isKindOfClass:[NSArray class]]);
    
    // 测试 modelCustomWillTransformFromDictionary - ImageResult 为数组
    NSDictionary *dictWithImageResultArray = @{@"ImageResult": @[@{@"URI": @"cos://bucket/image.jpg"}]};
    result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:dictWithImageResultArray];
    XCTAssertTrue([result[@"ImageResult"] isKindOfClass:[NSArray class]]);
}

- (void)testQCloudSearchImage {
    QCloudSearchImage *obj = [QCloudSearchImage new];
    obj.DatasetName = @"search-image-dataset";
    obj.Mode = @"pic";
    obj.URI = @"cos://bucket/search.jpg";
    obj.Limit = 50;
    obj.Text = @"搜索文本";
    obj.MatchThreshold = 80;
    
    XCTAssertEqualObjects(obj.DatasetName, @"search-image-dataset");
    XCTAssertEqualObjects(obj.Mode, @"pic");
    XCTAssertEqualObjects(obj.URI, @"cos://bucket/search.jpg");
    XCTAssertEqual(obj.Limit, 50);
    XCTAssertEqualObjects(obj.Text, @"搜索文本");
    XCTAssertEqual(obj.MatchThreshold, 80);
}

#pragma mark - QCloudCIImageInfo Tests

- (void)testQCloudCIImageInfo {
    // 测试属性设置和获取
    QCloudCIImageInfo *obj = [QCloudCIImageInfo new];
    obj.format = @"jpeg";
    obj.width = @"1920";
    obj.height = @"1080";
    obj.quality = @"85";
    obj.ave = @"0x46564a";
    obj.orientation = @"1";
    
    XCTAssertEqualObjects(obj.format, @"jpeg");
    XCTAssertEqualObjects(obj.width, @"1920");
    XCTAssertEqualObjects(obj.height, @"1080");
    XCTAssertEqualObjects(obj.quality, @"85");
    XCTAssertEqualObjects(obj.ave, @"0x46564a");
    XCTAssertEqualObjects(obj.orientation, @"1");
    
    // 测试 modelCustomPropertyMapper
    XCTAssert([QCloudCIImageInfo performSelector:@selector(modelCustomPropertyMapper)]);
    NSDictionary *mapper = [QCloudCIImageInfo performSelector:@selector(modelCustomPropertyMapper)];
    XCTAssertEqualObjects(mapper[@"format"], @"Format");
    XCTAssertEqualObjects(mapper[@"width"], @"Width");
    XCTAssertEqualObjects(mapper[@"height"], @"Height");
    XCTAssertEqualObjects(mapper[@"quality"], @"Quality");
    XCTAssertEqualObjects(mapper[@"ave"], @"Ave");
    XCTAssertEqualObjects(mapper[@"orientation"], @"Orientation");
    
    // 测试 modelCustomWillTransformFromDictionary - nil
    NSDictionary *result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    XCTAssertNil(result);
    
    // 测试 modelCustomWillTransformFromDictionary - 有效字典
    NSDictionary *inputDict = @{
        @"Format": @"png",
        @"Width": @"800",
        @"Height": @"600",
        @"Quality": @"90",
        @"Ave": @"0xffffff",
        @"Orientation": @"0"
    };
    result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:inputDict];
    XCTAssertNotNil(result);
    XCTAssertEqualObjects(result[@"Format"], @"png");
    XCTAssertEqualObjects(result[@"Width"], @"800");
    XCTAssertEqualObjects(result[@"Height"], @"600");
    XCTAssertEqualObjects(result[@"Quality"], @"90");
    XCTAssertEqualObjects(result[@"Ave"], @"0xffffff");
    XCTAssertEqualObjects(result[@"Orientation"], @"0");
    
    // 测试 modelCustomTransformToDictionary
    NSMutableDictionary *mutableDict = [inputDict mutableCopy];
    XCTAssert([obj performSelector:@selector(modelCustomTransformToDictionary:) withObject:mutableDict]);
}

- (void)testQCloudCIImageInfoWithEmptyValues {
    // 测试空值情况
    QCloudCIImageInfo *obj = [QCloudCIImageInfo new];
    
    XCTAssertNil(obj.format);
    XCTAssertNil(obj.width);
    XCTAssertNil(obj.height);
    XCTAssertNil(obj.quality);
    XCTAssertNil(obj.ave);
    XCTAssertNil(obj.orientation);
    
    // 测试空字典转换
    NSDictionary *emptyDict = @{};
    NSDictionary *result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:emptyDict];
    XCTAssertNotNil(result);
}

#pragma mark - QCloudCIOriginalInfo Tests

- (void)testQCloudCIOriginalInfo {
    // 测试属性设置和获取
    QCloudCIOriginalInfo *obj = [QCloudCIOriginalInfo new];
    obj.key = @"test-image.jpg";
    obj.location = @"bucket-1250000000.cos.ap-guangzhou.myqcloud.com/test-image.jpg";
    
    QCloudCIImageInfo *imageInfo = [QCloudCIImageInfo new];
    imageInfo.format = @"jpeg";
    imageInfo.width = @"1920";
    imageInfo.height = @"1080";
    obj.imageInfo = imageInfo;
    
    XCTAssertEqualObjects(obj.key, @"test-image.jpg");
    XCTAssertEqualObjects(obj.location, @"bucket-1250000000.cos.ap-guangzhou.myqcloud.com/test-image.jpg");
    XCTAssertEqualObjects(obj.imageInfo.format, @"jpeg");
    XCTAssertEqualObjects(obj.imageInfo.width, @"1920");
    XCTAssertEqualObjects(obj.imageInfo.height, @"1080");
    
    // 测试 modelCustomPropertyMapper
    NSDictionary *mapper = [QCloudCIOriginalInfo performSelector:@selector(modelCustomPropertyMapper)];
    XCTAssertEqualObjects(mapper[@"key"], @"Key");
    XCTAssertEqualObjects(mapper[@"location"], @"Location");
    XCTAssertEqualObjects(mapper[@"imageInfo"], @"ImageInfo");
    
    // 测试 modelCustomWillTransformFromDictionary - nil
    NSDictionary *result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    XCTAssertNil(result);
    
    // 测试 modelCustomWillTransformFromDictionary - 有效字典
    NSDictionary *inputDict = @{
        @"Key": @"original.png",
        @"Location": @"bucket.cos.ap-beijing.myqcloud.com/original.png",
        @"ImageInfo": @{@"Format": @"png", @"Width": @"800", @"Height": @"600"}
    };
    result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:inputDict];
    XCTAssertNotNil(result);
    
    // 测试 modelCustomTransformToDictionary
    NSMutableDictionary *mutableDict = [inputDict mutableCopy];
    XCTAssert([obj performSelector:@selector(modelCustomTransformToDictionary:) withObject:mutableDict]);
}

- (void)testQCloudCIOriginalInfoWithEmptyValues {
    QCloudCIOriginalInfo *obj = [QCloudCIOriginalInfo new];
    
    XCTAssertNil(obj.key);
    XCTAssertNil(obj.location);
    XCTAssertNil(obj.imageInfo);
    
    // 测试空字典转换
    NSDictionary *emptyDict = @{};
    NSDictionary *result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:emptyDict];
    XCTAssertNotNil(result);
}

#pragma mark - QCloudDescribeDatasetResponse Tests

- (void)testQCloudDescribeDatasetResponse {
    // 测试属性设置和获取
    QCloudDescribeDatasetResponse *obj = [QCloudDescribeDatasetResponse new];
    obj.RequestId = @"request-describe-dataset-123";
    
    QCloudDataset *dataset = [QCloudDataset new];
    dataset.DatasetName = @"test-dataset";
    dataset.Description = @"测试数据集";
    obj.Dataset = dataset;
    
    XCTAssertEqualObjects(obj.RequestId, @"request-describe-dataset-123");
    XCTAssertEqualObjects(obj.Dataset.DatasetName, @"test-dataset");
    XCTAssertEqualObjects(obj.Dataset.Description, @"测试数据集");
    
    // 测试 modelContainerPropertyGenericClass
    NSDictionary *genericClass = [[QCloudDescribeDatasetResponse class] performSelector:@selector(modelContainerPropertyGenericClass)];
    XCTAssertEqualObjects(genericClass[@"Dataset"], [QCloudDataset class]);
}

- (void)testQCloudDescribeDatasetResponseWithEmptyValues {
    QCloudDescribeDatasetResponse *obj = [QCloudDescribeDatasetResponse new];
    
    XCTAssertNil(obj.RequestId);
    XCTAssertNil(obj.Dataset);
}

#pragma mark - QCloudUpdateVoiceSynthesisTempleteResponse Tests

- (void)testQCloudUpdateVoiceSynthesisTempleteResponse {
    // 测试属性设置和获取
    QCloudUpdateVoiceSynthesisTempleteResponse *obj = [QCloudUpdateVoiceSynthesisTempleteResponse new];
    obj.RequestId = @"request-voice-synthesis-456";
    
    QCloudVoiceSynthesisTempleteResponseTemplate *template = [QCloudVoiceSynthesisTempleteResponseTemplate new];
    obj.Template = template;
    
    XCTAssertEqualObjects(obj.RequestId, @"request-voice-synthesis-456");
    XCTAssertNotNil(obj.Template);
    
    // 测试 modelContainerPropertyGenericClass
    NSDictionary *genericClass = [[QCloudUpdateVoiceSynthesisTempleteResponse class] performSelector:@selector(modelContainerPropertyGenericClass)];
    XCTAssertEqualObjects(genericClass[@"Template"], [QCloudVoiceSynthesisTempleteResponseTemplate class]);
}

- (void)testQCloudUpdateVoiceSynthesisTempleteResponseWithEmptyValues {
    QCloudUpdateVoiceSynthesisTempleteResponse *obj = [QCloudUpdateVoiceSynthesisTempleteResponse new];
    
    XCTAssertNil(obj.RequestId);
    XCTAssertNil(obj.Template);
}

- (void)testQCloudUpdateVoiceSynthesisTemplete {
    // 测试属性设置和获取
    QCloudUpdateVoiceSynthesisTemplete *obj = [QCloudUpdateVoiceSynthesisTemplete new];
    obj.Tag = @"Tts";
    obj.Name = @"语音合成模板-测试";
    obj.Mode = @"Async";
    obj.Codec = @"mp3";
    obj.VoiceType = @"ruxue";
    obj.Volume = @"5";
    obj.Speed = @"120";
    obj.Emotion = @"neutral";
    
    XCTAssertEqualObjects(obj.Tag, @"Tts");
    XCTAssertEqualObjects(obj.Name, @"语音合成模板-测试");
    XCTAssertEqualObjects(obj.Mode, @"Async");
    XCTAssertEqualObjects(obj.Codec, @"mp3");
    XCTAssertEqualObjects(obj.VoiceType, @"ruxue");
    XCTAssertEqualObjects(obj.Volume, @"5");
    XCTAssertEqualObjects(obj.Speed, @"120");
    XCTAssertEqualObjects(obj.Emotion, @"neutral");
}

#pragma mark - QCloudDescribeFileMetaIndexResponse Tests

- (void)testQCloudDescribeFileMetaIndexResponse {
    // 测试属性设置和获取
    QCloudDescribeFileMetaIndexResponse *obj = [QCloudDescribeFileMetaIndexResponse new];
    obj.RequestId = @"request-file-meta-index-789";
    
    QCloudFilesDetail *fileDetail = [QCloudFilesDetail new];
    obj.Files = @[fileDetail];
    
    XCTAssertEqualObjects(obj.RequestId, @"request-file-meta-index-789");
    XCTAssertEqual(obj.Files.count, 1);
    
    // 测试 modelContainerPropertyGenericClass
    NSDictionary *genericClass = [[QCloudDescribeFileMetaIndexResponse class] performSelector:@selector(modelContainerPropertyGenericClass)];
    XCTAssertEqualObjects(genericClass[@"Files"], [QCloudFilesDetail class]);
    
    // 测试 modelCustomWillTransformFromDictionary - nil
    NSDictionary *result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    XCTAssertNil(result);
    
    // 测试 modelCustomWillTransformFromDictionary - 非字典
    result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@"not a dict"];
    XCTAssertNil(result);
    
    // 测试 modelCustomWillTransformFromDictionary - Files 为字典（单个文件）
    NSDictionary *dictWithFile = @{@"Files": @{@"URI": @"cos://bucket/file.jpg", @"Size": @1024}};
    result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:dictWithFile];
    XCTAssertTrue([result[@"Files"] isKindOfClass:[NSArray class]]);
    XCTAssertEqual([result[@"Files"] count], 1);
    
    // 测试 modelCustomWillTransformFromDictionary - Files 为数组
    NSDictionary *dictWithFilesArray = @{@"Files": @[@{@"URI": @"cos://bucket/file1.jpg"}, @{@"URI": @"cos://bucket/file2.jpg"}]};
    result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:dictWithFilesArray];
    XCTAssertTrue([result[@"Files"] isKindOfClass:[NSArray class]]);
    XCTAssertEqual([result[@"Files"] count], 2);
}

- (void)testQCloudDescribeFileMetaIndexResponseWithEmptyValues {
    QCloudDescribeFileMetaIndexResponse *obj = [QCloudDescribeFileMetaIndexResponse new];
    
    XCTAssertNil(obj.RequestId);
    XCTAssertNil(obj.Files);
    
    // 测试空字典转换
    NSDictionary *emptyDict = @{};
    NSDictionary *result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:emptyDict];
    XCTAssertNotNil(result);
}

#pragma mark - QCloudCreateDatasetBindingResponse Tests

- (void)testQCloudCreateDatasetBindingResponse {
    // 测试属性设置和获取
    QCloudCreateDatasetBindingResponse *obj = [QCloudCreateDatasetBindingResponse new];
    obj.RequestId = @"request-create-binding-123";
    
    QCloudBinding *binding = [QCloudBinding new];
    obj.Binding = binding;
    
    XCTAssertEqualObjects(obj.RequestId, @"request-create-binding-123");
    XCTAssertNotNil(obj.Binding);
    
    // 测试 modelContainerPropertyGenericClass
    NSDictionary *genericClass = [[QCloudCreateDatasetBindingResponse class] performSelector:@selector(modelContainerPropertyGenericClass)];
    XCTAssertEqualObjects(genericClass[@"Binding"], [QCloudBinding class]);
}

- (void)testQCloudCreateDatasetBindingResponseWithEmptyValues {
    QCloudCreateDatasetBindingResponse *obj = [QCloudCreateDatasetBindingResponse new];
    
    XCTAssertNil(obj.RequestId);
    XCTAssertNil(obj.Binding);
}

- (void)testQCloudCreateDatasetBinding {
    // 测试属性设置和获取
    QCloudCreateDatasetBinding *obj = [QCloudCreateDatasetBinding new];
    obj.DatasetName = @"test-dataset-binding";
    obj.URI = @"cos://examplebucket-1250000000";
    
    XCTAssertEqualObjects(obj.DatasetName, @"test-dataset-binding");
    XCTAssertEqualObjects(obj.URI, @"cos://examplebucket-1250000000");
}

#pragma mark - QCloudDescribeDatasetBindingResponse Tests

- (void)testQCloudDescribeDatasetBindingResponse {
    // 测试属性设置和获取
    QCloudDescribeDatasetBindingResponse *obj = [QCloudDescribeDatasetBindingResponse new];
    obj.RequestId = @"request-describe-binding-456";
    
    QCloudBinding *binding = [QCloudBinding new];
    obj.Binding = binding;
    
    XCTAssertEqualObjects(obj.RequestId, @"request-describe-binding-456");
    XCTAssertNotNil(obj.Binding);
    
    // 测试 modelContainerPropertyGenericClass
    NSDictionary *genericClass = [[QCloudDescribeDatasetBindingResponse class] performSelector:@selector(modelContainerPropertyGenericClass)];
    XCTAssertEqualObjects(genericClass[@"Binding"], [QCloudBinding class]);
}

- (void)testQCloudDescribeDatasetBindingResponseWithEmptyValues {
    QCloudDescribeDatasetBindingResponse *obj = [QCloudDescribeDatasetBindingResponse new];
    
    XCTAssertNil(obj.RequestId);
    XCTAssertNil(obj.Binding);
}

#pragma mark - QCloudPostVoiceSynthesisTempleteResponse Tests

- (void)testQCloudPostVoiceSynthesisTempleteResponse {
    // 测试属性设置和获取
    QCloudPostVoiceSynthesisTempleteResponse *obj = [QCloudPostVoiceSynthesisTempleteResponse new];
    obj.RequestId = @"request-post-voice-synthesis-789";
    
    QCloudVoiceSynthesisTempleteResponseTemplate *template = [QCloudVoiceSynthesisTempleteResponseTemplate new];
    obj.Template = template;
    
    XCTAssertEqualObjects(obj.RequestId, @"request-post-voice-synthesis-789");
    XCTAssertNotNil(obj.Template);
    
    // 测试 modelContainerPropertyGenericClass
    NSDictionary *genericClass = [[QCloudPostVoiceSynthesisTempleteResponse class] performSelector:@selector(modelContainerPropertyGenericClass)];
    XCTAssertEqualObjects(genericClass[@"Template"], [QCloudVoiceSynthesisTempleteResponseTemplate class]);
}

- (void)testQCloudPostVoiceSynthesisTempleteResponseWithEmptyValues {
    QCloudPostVoiceSynthesisTempleteResponse *obj = [QCloudPostVoiceSynthesisTempleteResponse new];
    
    XCTAssertNil(obj.RequestId);
    XCTAssertNil(obj.Template);
}

- (void)testQCloudPostVoiceSynthesisTemplete {
    // 测试属性设置和获取
    QCloudPostVoiceSynthesisTemplete *obj = [QCloudPostVoiceSynthesisTemplete new];
    obj.Tag = @"Tts";
    obj.Name = @"语音合成模板-Post";
    obj.Mode = @"Sync";
    obj.Codec = @"wav";
    obj.VoiceType = @"aixia";
    obj.Volume = @"0";
    obj.Speed = @"100";
    obj.Emotion = @"happy";
    
    XCTAssertEqualObjects(obj.Tag, @"Tts");
    XCTAssertEqualObjects(obj.Name, @"语音合成模板-Post");
    XCTAssertEqualObjects(obj.Mode, @"Sync");
    XCTAssertEqualObjects(obj.Codec, @"wav");
    XCTAssertEqualObjects(obj.VoiceType, @"aixia");
    XCTAssertEqualObjects(obj.Volume, @"0");
    XCTAssertEqualObjects(obj.Speed, @"100");
    XCTAssertEqualObjects(obj.Emotion, @"happy");
}

#pragma mark - QCloudDescribeDatasetBindingsResponse Tests

- (void)testQCloudDescribeDatasetBindingsResponse {
    // 测试属性设置和获取
    QCloudDescribeDatasetBindingsResponse *obj = [QCloudDescribeDatasetBindingsResponse new];
    obj.RequestId = @"request-describe-bindings-abc";
    obj.NextToken = @"next-token-xyz";
    
    QCloudBinding *binding1 = [QCloudBinding new];
    QCloudBinding *binding2 = [QCloudBinding new];
    obj.Bindings = @[binding1, binding2];
    
    XCTAssertEqualObjects(obj.RequestId, @"request-describe-bindings-abc");
    XCTAssertEqualObjects(obj.NextToken, @"next-token-xyz");
    XCTAssertEqual(obj.Bindings.count, 2);
    
    // 测试 modelContainerPropertyGenericClass
    NSDictionary *genericClass = [[QCloudDescribeDatasetBindingsResponse class] performSelector:@selector(modelContainerPropertyGenericClass)];
    XCTAssertEqualObjects(genericClass[@"Bindings"], [QCloudBinding class]);
    
    // 测试 modelCustomWillTransformFromDictionary - nil
    NSDictionary *result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    XCTAssertNil(result);
    
    // 测试 modelCustomWillTransformFromDictionary - 非字典
    result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@"not a dict"];
    XCTAssertNil(result);
    
    // 测试 modelCustomWillTransformFromDictionary - Bindings 为字典（单个绑定）
    NSDictionary *dictWithBinding = @{@"Bindings": @{@"DatasetName": @"dataset1", @"URI": @"cos://bucket1"}};
    result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:dictWithBinding];
    XCTAssertTrue([result[@"Bindings"] isKindOfClass:[NSArray class]]);
    XCTAssertEqual([result[@"Bindings"] count], 1);
    
    // 测试 modelCustomWillTransformFromDictionary - Bindings 为数组
    NSDictionary *dictWithBindingsArray = @{@"Bindings": @[@{@"DatasetName": @"dataset1"}, @{@"DatasetName": @"dataset2"}]};
    result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:dictWithBindingsArray];
    XCTAssertTrue([result[@"Bindings"] isKindOfClass:[NSArray class]]);
    XCTAssertEqual([result[@"Bindings"] count], 2);
}

- (void)testQCloudDescribeDatasetBindingsResponseWithEmptyValues {
    QCloudDescribeDatasetBindingsResponse *obj = [QCloudDescribeDatasetBindingsResponse new];
    
    XCTAssertNil(obj.RequestId);
    XCTAssertNil(obj.NextToken);
    XCTAssertNil(obj.Bindings);
    
    // 测试空字典转换
    NSDictionary *emptyDict = @{};
    NSDictionary *result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:emptyDict];
    XCTAssertNotNil(result);
}

#pragma mark - QCloudUpdateDatasetResponse Tests

- (void)testQCloudUpdateDatasetResponse {
    // 测试属性设置和获取
    QCloudUpdateDatasetResponse *obj = [QCloudUpdateDatasetResponse new];
    obj.RequestId = @"request-update-dataset-def";
    
    QCloudDataset *dataset = [QCloudDataset new];
    dataset.DatasetName = @"updated-dataset";
    dataset.Description = @"更新后的数据集";
    obj.Dataset = dataset;
    
    XCTAssertEqualObjects(obj.RequestId, @"request-update-dataset-def");
    XCTAssertEqualObjects(obj.Dataset.DatasetName, @"updated-dataset");
    XCTAssertEqualObjects(obj.Dataset.Description, @"更新后的数据集");
    
    // 测试 modelContainerPropertyGenericClass
    NSDictionary *genericClass = [[QCloudUpdateDatasetResponse class] performSelector:@selector(modelContainerPropertyGenericClass)];
    XCTAssertEqualObjects(genericClass[@"Dataset"], [QCloudDataset class]);
}

- (void)testQCloudUpdateDatasetResponseWithEmptyValues {
    QCloudUpdateDatasetResponse *obj = [QCloudUpdateDatasetResponse new];
    
    XCTAssertNil(obj.RequestId);
    XCTAssertNil(obj.Dataset);
}

- (void)testQCloudUpdateDataset {
    // 测试属性设置和获取
    QCloudUpdateDataset *obj = [QCloudUpdateDataset new];
    obj.DatasetName = @"dataset-to-update";
    obj.Description = @"数据集描述信息";
    obj.TemplateId = @"template-12345";
    
    XCTAssertEqualObjects(obj.DatasetName, @"dataset-to-update");
    XCTAssertEqualObjects(obj.Description, @"数据集描述信息");
    XCTAssertEqualObjects(obj.TemplateId, @"template-12345");
}

#pragma mark - QCloudDescribeDatasetsResponse Tests

- (void)testQCloudDescribeDatasetsResponse {
    // 测试属性设置和获取
    QCloudDescribeDatasetsResponse *obj = [QCloudDescribeDatasetsResponse new];
    obj.RequestId = @"request-describe-datasets-123";
    obj.NextToken = @"next-token-datasets";
    
    QCloudDatasets *dataset1 = [QCloudDatasets new];
    QCloudDatasets *dataset2 = [QCloudDatasets new];
    obj.Datasets = @[dataset1, dataset2];
    
    XCTAssertEqualObjects(obj.RequestId, @"request-describe-datasets-123");
    XCTAssertEqualObjects(obj.NextToken, @"next-token-datasets");
    XCTAssertEqual(obj.Datasets.count, 2);
    
    // 测试 modelContainerPropertyGenericClass
    NSDictionary *genericClass = [[QCloudDescribeDatasetsResponse class] performSelector:@selector(modelContainerPropertyGenericClass)];
    XCTAssertEqualObjects(genericClass[@"Datasets"], [QCloudDatasets class]);
    
    // 测试 modelCustomWillTransformFromDictionary - nil
    NSDictionary *result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    XCTAssertNil(result);
    
    // 测试 modelCustomWillTransformFromDictionary - 非字典
    result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:@"not a dict"];
    XCTAssertNil(result);
    
    // 测试 modelCustomWillTransformFromDictionary - Datasets 为字典（单个数据集）
    NSDictionary *dictWithDataset = @{@"Datasets": @{@"DatasetName": @"dataset1", @"Description": @"desc1"}};
    result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:dictWithDataset];
    XCTAssertTrue([result[@"Datasets"] isKindOfClass:[NSArray class]]);
    XCTAssertEqual([result[@"Datasets"] count], 1);
    
    // 测试 modelCustomWillTransformFromDictionary - Datasets 为数组
    NSDictionary *dictWithDatasetsArray = @{@"Datasets": @[@{@"DatasetName": @"dataset1"}, @{@"DatasetName": @"dataset2"}]};
    result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:dictWithDatasetsArray];
    XCTAssertTrue([result[@"Datasets"] isKindOfClass:[NSArray class]]);
    XCTAssertEqual([result[@"Datasets"] count], 2);
}

- (void)testQCloudDescribeDatasetsResponseWithEmptyValues {
    QCloudDescribeDatasetsResponse *obj = [QCloudDescribeDatasetsResponse new];
    
    XCTAssertNil(obj.RequestId);
    XCTAssertNil(obj.NextToken);
    XCTAssertNil(obj.Datasets);
    
    // 测试空字典转换
    NSDictionary *emptyDict = @{};
    NSDictionary *result = [obj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:emptyDict];
    XCTAssertNotNil(result);
}

@end
