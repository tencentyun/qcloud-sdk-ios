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

-(void)testQCloudPutObjectWatermarkResult{
    
    
    XCTAssert([QCloudPutObjectImageInfo performSelector:@selector(modelCustomPropertyMapper)]);
    QCloudPutObjectImageInfo * imageInfo = [QCloudPutObjectImageInfo new];
    NSDictionary *inputDict0 = @{
        @"Format" : @"FormatValue",
        @"Width" : @"WidthValue",
        @"Height" : @"HeightValue",
        @"Quality" : @"QualityValue",
        @"Ave" : @"AveValue",
        @"Orientation" : @"OrientationValue",
    };
    id output0 = [imageInfo performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    XCTAssertNil(output0);
    NSDictionary *transOutput0 = [imageInfo performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:inputDict0];
    
    XCTAssert([transOutput0[@"Format"] isEqualToString:@"FormatValue"]);
    XCTAssert([transOutput0[@"Width"] isEqualToString:@"WidthValue"]);
    XCTAssert([transOutput0[@"Height"] isEqualToString:@"HeightValue"]);
    XCTAssert([transOutput0[@"Quality"] isEqualToString:@"QualityValue"]);
    XCTAssert([transOutput0[@"Ave"] isEqualToString:@"AveValue"]);
    XCTAssert([transOutput0[@"Orientation"] isEqualToString:@"OrientationValue"]);
    
    XCTAssert([imageInfo performSelector:@selector(modelCustomTransformToDictionary:) withObject:inputDict0]);
    
    XCTAssert([QCloudPutObjectOriginalInfo performSelector:@selector(modelCustomPropertyMapper)]);
    QCloudPutObjectOriginalInfo * originalInfo = [QCloudPutObjectOriginalInfo new];
    NSDictionary *inputDict = @{
        @"Key" : @"KeyValue",
        @"Location" : @"LocationValue",
        @"ImageInfo" : imageInfo
    };;
    id output = [originalInfo performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    XCTAssertNil(output);
    NSDictionary *transOutput = [originalInfo performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:inputDict];
    XCTAssert([transOutput[@"Key"] isEqualToString:@"KeyValue"]);
    XCTAssert([transOutput[@"Location"] isEqualToString:@"LocationValue"]);
    XCTAssertNotNil(transOutput[@"ImageInfo"]);
    
    XCTAssert([originalInfo performSelector:@selector(modelCustomTransformToDictionary:) withObject:inputDict]);
    
    XCTAssert([QCloudPutObjectObj performSelector:@selector(modelCustomPropertyMapper)]);
    QCloudPutObjectObj * objectObj = [QCloudPutObjectObj new];
    NSDictionary *inputDict1 = @{
        @"Key" : @"KeyValue",
        @"Location" : @"LocationValue",
        @"Format" : @"FormatValue",
        @"Width" : @"WidthValue",
        @"Height" : @"HeightValue",
        @"Size" : @"SizeValue",
        @"Orientation" : @"OrientationValue",
    };;
    id output1 = [objectObj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    XCTAssertNil(output1);
    NSDictionary *transOutput1 = [objectObj performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:inputDict1];
    XCTAssert([transOutput1[@"Key"] isEqualToString:@"KeyValue"]);
    XCTAssert([transOutput1[@"Location"] isEqualToString:@"LocationValue"]);
    XCTAssert([transOutput1[@"Format"] isEqualToString:@"FormatValue"]);
    XCTAssert([transOutput1[@"Width"] isEqualToString:@"WidthValue"]);
    XCTAssert([transOutput1[@"Height"] isEqualToString:@"HeightValue"]);
    XCTAssert([transOutput1[@"Size"] isEqualToString:@"SizeValue"]);
    XCTAssert([transOutput1[@"Orientation"] isEqualToString:@"OrientationValue"]);
    
    XCTAssert([objectObj performSelector:@selector(modelCustomTransformToDictionary:) withObject:inputDict1]);
    
    XCTAssert([QCloudPutObjectProcessResults performSelector:@selector(modelCustomPropertyMapper)]);
    QCloudPutObjectProcessResults * processResults = [QCloudPutObjectProcessResults new];
    NSDictionary *inputDict2 = @{
        @"Object" : @"ObjectValue",
    };;
    id output2 = [processResults performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    XCTAssertNil(output2);
    NSDictionary *transOutput2 = [processResults performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:inputDict2];
    XCTAssert([transOutput2[@"Object"] isEqualToString:@"ObjectValue"]);
    
    XCTAssert([processResults performSelector:@selector(modelCustomTransformToDictionary:) withObject:inputDict2]);
    
    XCTAssert([QCloudPutObjectWatermarkResult performSelector:@selector(modelCustomPropertyMapper)]);
    QCloudPutObjectWatermarkResult * watermarkResult = [QCloudPutObjectWatermarkResult new];
    NSDictionary *inputDict3 = @{
        @"OriginalInfo" : originalInfo,
        @"ProcessResults" : processResults
    };
    id output3 = [watermarkResult performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    XCTAssertNil(output3);
    NSDictionary *transOutput3 = [watermarkResult performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:inputDict3];
    
    XCTAssertNotNil(transOutput3[@"OriginalInfo"]);
    XCTAssertNotNil(transOutput3[@"ProcessResults"]);
    
    XCTAssert([watermarkResult performSelector:@selector(modelCustomTransformToDictionary:) withObject:inputDict3]);
    
    NSDictionary* genericClass = [[QCloudPutObjectWatermarkResult class] modelContainerPropertyGenericClass];
    XCTAssertNotNil(genericClass);
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
        
//        QCloudAbortMultipfartUploadRequest.class,


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

@end
