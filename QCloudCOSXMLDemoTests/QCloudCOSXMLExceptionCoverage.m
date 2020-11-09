//
//  QCloudCOSXMLExceptionCoverage.m
//  QCloudCOSXMLDemo
//
//  Created by erichmzhang(张恒铭) on 21/08/2017.
//  Copyright © 2017 Tencent. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TestCommonDefine.h"
#import <XCTest/XCTest.h>
#import <QCloudCOSXML/QCloudCOSXML.h>
#import <QCloudCOSXML/QCloudCompleteMultipartUploadInfo.h>
@interface QCloudCOSXMLExceptionCoverage : XCTestCase

@end

@implementation QCloudCOSXMLExceptionCoverage

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//- (void)testCommonPrefix {
//    QCloudCommonPrefixes* prefix = [QCloudCommonPrefixes new];
//    NSDictionary* inputDict = @{@"Prefix":@"afsd"};
//    id output = [prefix performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
//    XCTAssertNil(output);
//    NSDictionary* transOutput = [prefix performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:inputDict];
//    XCTAssert([transOutput[@"Prefix"][0] isEqualToString:@"afsd"]);
//
//    NSDictionary* transArrayiutput = @{@"Prefix":@[@"aaa",@"bbb"]};
//    NSDictionary* transArrayOutput = [prefix performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:transArrayiutput];
//    XCTAssertEqual([transArrayOutput[@"Prefix"] count],2);
//
//   NSDictionary* dictInput = @{@"Prefix":@{@"jiangzhuxi":@[@"123",@"456"]}};
//   NSDictionary* dicOutput = [prefix performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:dictInput];
//    XCTAssert([dicOutput[@"Prefix"] isKindOfClass:[NSArray class]]);
//
//    NSDictionary* dictInput2 = @{@"Prefix":@{@"jiangzhuxi":@{@"aa":@"bb"}}};
//    NSDictionary* dictOutput2 = [prefix performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:dictInput2];
//     XCTAssert([dictOutput2[@"Prefix"] isKindOfClass:[NSArray class]]);
//
//
//    NSDictionary* nilInput =@{@"Prefix":[NSNull null]};
//    NSDictionary* nilOutput = [prefix performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nilInput];
//    XCTAssertNil(nilOutput[@"prefix"]);
//
//
//    NSDictionary* wrapper = [[prefix class] modelCustomPropertyMapper];
//    XCTAssert([wrapper[@"prefix"] isEqualToString:@"Prefix"]);
//
//    XCTAssert([prefix performSelector:@selector(modelCustomTransformToDictionary:) withObject:nilInput]);
//
//    NSDictionary* genericClass = [[prefix class] modelContainerPropertyGenericClass];
//    XCTAssertNotNil(genericClass);
//}

- (void)testTypeNum {
    QCloudLogInfo(@"QCloudCOSXMLExceptionCoverage:testTypeNum");
    XCTAssertEqual(QCloudCOSAccountTypeDumpFromString(@"RootAccount"), 0);
    XCTAssertEqual(QCloudCOSAccountTypeDumpFromString(@"SubAccount"), 1);

    XCTAssert([QCloudCOSAccountTypeTransferToString(QCloudCOSAccountTypeRoot) isEqualToString:@"RootAccount"]);
    XCTAssert([QCloudCOSAccountTypeTransferToString(QCloudCOSAccountTypeSub) isEqualToString:@"SubAccount"]);
}

- (void)testStorateEnum {
    QCloudLogInfo(@"QCloudCOSXMLExceptionCoverage:testStorateEnum");
    XCTAssertEqual(QCloudCOSStorageClassDumpFromString(@"Standard"), 0);
    XCTAssertEqual(QCloudCOSStorageClassDumpFromString(@"Standard_IA"), 0);

    XCTAssert([QCloudCOSStorageClassTransferToString(QCloudCOSStorageStandard) isEqualToString:@"Standard"]);
    XCTAssert([QCloudCOSStorageClassTransferToString(QCloudCOSStorageStandardIA) isEqualToString:@"Standard_IA"]);
}

- (void)testDeleteMultipartInfo {
    QCloudLogInfo(@"QCloudCOSXMLExceptionCoverage:testDeleteMultipartInfo");
    QCloudCompleteMultipartUploadInfo *prefix = [QCloudCompleteMultipartUploadInfo new];
    NSDictionary *inputDict = @{ @"Part" : @"afsd" };
    id output = [prefix performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    XCTAssertNil(output);
    NSDictionary *transOutput = [prefix performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:inputDict];
    XCTAssert([transOutput[@"Part"][0] isEqualToString:@"afsd"]);

    NSDictionary *transArrayiutput = @{ @"Part" : @[ @"aaa", @"bbb" ] };
    NSDictionary *transArrayOutput = [prefix performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:transArrayiutput];
    XCTAssertEqual([transArrayOutput[@"Part"] count], 2);

    NSDictionary *dictInput = @{ @"Part" : @ { @"jiangzhuxi" : @[ @"123", @"456" ] } };
    NSDictionary *dicOutput = [prefix performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:dictInput];
    XCTAssert([dicOutput[@"Part"] isKindOfClass:[NSArray class]]);

    NSDictionary *dictInput2 = @{ @"Part" : @ { @"jiangzhuxi" : @ { @"aa" : @"bb" } } };
    NSDictionary *dictOutput2 = [prefix performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:dictInput2];
    XCTAssert([dictOutput2[@"Part"] isKindOfClass:[NSArray class]]);

    NSDictionary *nilInput = @{ @"Part" : [NSNull null] };
    NSDictionary *nilOutput = [prefix performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nilInput];
    XCTAssert([nilOutput[@"Part"] isKindOfClass:[NSNull class]]);

    NSDictionary *wrapper = [[prefix class] modelCustomPropertyMapper];
    XCTAssert([wrapper[@"parts"] isEqualToString:@"Part"]);

    XCTAssert([prefix performSelector:@selector(modelCustomTransformToDictionary:) withObject:nilInput]);

    NSDictionary *genericClass = [[prefix class] modelContainerPropertyGenericClass];
    XCTAssertNotNil(genericClass);
}

- (void)testDeleteInfo {
    QCloudLogInfo(@"QCloudCOSXMLExceptionCoverage:testDeleteInfo");
    QCloudDeleteInfo *prefix = [QCloudDeleteInfo new];
    NSDictionary *inputDict = @{ @"Object" : @"afsd" };
    id output = [prefix performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    XCTAssertNil(output);
    NSDictionary *transOutput = [prefix performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:inputDict];
    XCTAssert([transOutput[@"Object"][0] isEqualToString:@"afsd"]);

    NSDictionary *transArrayiutput = @{ @"Object" : @[ @"aaa", @"bbb" ] };
    NSDictionary *transArrayOutput = [prefix performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:transArrayiutput];
    XCTAssertEqual([transArrayOutput[@"Object"] count], 2);

    NSDictionary *dictInput = @{ @"Object" : @ { @"jiangzhuxi" : @[ @"123", @"456" ] } };
    NSDictionary *dicOutput = [prefix performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:dictInput];
    XCTAssert([dicOutput[@"Object"] isKindOfClass:[NSArray class]]);

    NSDictionary *dictInput2 = @{ @"Object" : @ { @"jiangzhuxi" : @ { @"aa" : @"bb" } } };
    NSDictionary *dictOutput2 = [prefix performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:dictInput2];
    XCTAssert([dictOutput2[@"Object"] isKindOfClass:[NSArray class]]);

    NSDictionary *nilInput = @{ @"Object" : [NSNull null] };
    NSDictionary *nilOutput = [prefix performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nilInput];
    XCTAssert([nilOutput[@"Object"] isKindOfClass:[NSNull class]]);

    NSDictionary *wrapper = [[prefix class] modelCustomPropertyMapper];
    XCTAssert([wrapper[@"objects"] isEqualToString:@"Object"]);

    XCTAssert([prefix performSelector:@selector(modelCustomTransformToDictionary:) withObject:nilInput]);

    NSDictionary *genericClass = [[prefix class] modelContainerPropertyGenericClass];
    XCTAssertNotNil(genericClass);
}

- (void)testDeleteObjectInfo {
    QCloudLogInfo(@"QCloudCOSXMLExceptionCoverage:testDeleteObjectInfo");
    QCloudDeleteObjectInfo *info = [[QCloudDeleteObjectInfo alloc] init];
    XCTAssertNil([info performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil]);
    NSDictionary *dict = @{ @"aaa" : @"vvv" };
    XCTAssert([[info performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:dict][@"aaa"] isEqualToString:@"vvv"]);
}

- (void)testDeleteResult {
    QCloudLogInfo(@"QCloudCOSXMLExceptionCoverage:testDeleteResult");
    QCloudDeleteResult *prefix = [QCloudDeleteResult new];
    NSDictionary *inputDict = @{ @"Deleted" : @"afsd" };
    id output = [prefix performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    XCTAssertNil(output);
    NSDictionary *transOutput = [prefix performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:inputDict];
    XCTAssert([transOutput[@"Deleted"][0] isEqualToString:@"afsd"]);

    NSDictionary *transArrayiutput = @{ @"Deleted" : @[ @"aaa", @"bbb" ] };
    NSDictionary *transArrayOutput = [prefix performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:transArrayiutput];
    XCTAssertEqual([transArrayOutput[@"Deleted"] count], 2);

    NSDictionary *dictInput = @{ @"Deleted" : @ { @"jiangzhuxi" : @[ @"123", @"456" ] } };
    NSDictionary *dicOutput = [prefix performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:dictInput];
    XCTAssert([dicOutput[@"Deleted"] isKindOfClass:[NSArray class]]);

    NSDictionary *dictInput2 = @{ @"Deleted" : @ { @"jiangzhuxi" : @ { @"aa" : @"bb" } } };
    NSDictionary *dictOutput2 = [prefix performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:dictInput2];
    XCTAssert([dictOutput2[@"Deleted"] isKindOfClass:[NSArray class]]);

    NSDictionary *nilInput = @{ @"Deleted" : [NSNull null] };
    NSDictionary *nilOutput = [prefix performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nilInput];
    XCTAssert([nilOutput[@"Deleted"] isKindOfClass:[NSNull class]]);

    NSDictionary *wrapper = [[prefix class] modelCustomPropertyMapper];
    XCTAssert([wrapper[@"deletedObjects"] isEqualToString:@"Deleted"]);

    XCTAssert([prefix performSelector:@selector(modelCustomTransformToDictionary:) withObject:nilInput]);

    NSDictionary *genericClass = [[prefix class] modelContainerPropertyGenericClass];
    XCTAssertNotNil(genericClass);
}

- (void)testCORSRule {
    QCloudLogInfo(@"karQCloudCOSXMLExceptionCoverageis:testCORSRule");
    QCloudCORSRule *rule = [[QCloudCORSRule alloc] init];
    NSDictionary *inputDict = @{ @"AllowedMethod" : @"HEAD" };
    id output = [rule performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil];
    XCTAssertNil(output);
    NSDictionary *transOutput = [rule performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:inputDict];
    XCTAssert([transOutput[@"AllowedMethod"][0] isEqualToString:@"HEAD"]);

    NSDictionary *transArrayiutput = @{ @"AllowedMethod" : @[ @"aaa", @"bbb" ] };
    NSDictionary *transArrayOutput = [rule performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:transArrayiutput];
    XCTAssertEqual([transArrayOutput[@"AllowedMethod"] count], 2);

    NSDictionary *dictInput = @{ @"AllowedMethod" : @ { @"2222" : @[ @"123", @"456" ] } };
    NSDictionary *dicOutput = [rule performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:dictInput];
    XCTAssert([dicOutput[@"AllowedMethod"] isKindOfClass:[NSArray class]]);

    NSDictionary *dictInput2 = @{ @"AllowedMethod" : @ { @"2222" : @ { @"aa" : @"bb" } } };
    NSDictionary *dictOutput2 = [rule performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:dictInput2];
    XCTAssert([dictOutput2[@"AllowedMethod"] isKindOfClass:[NSArray class]]);

    NSDictionary *nilInput = @{ @"AllowedMethod" : [NSNull null] };
    NSDictionary *nilOutput = [rule performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nilInput];
    XCTAssert([nilOutput[@"AllowedMethod"] isKindOfClass:[NSNull class]]);

    NSDictionary *wrapper = [[rule class] modelCustomPropertyMapper];
    XCTAssert([wrapper[@"allowedMethod"] isEqualToString:@"AllowedMethod"]);

    XCTAssert([rule performSelector:@selector(modelCustomTransformToDictionary:) withObject:nilInput]);
    XCTAssertNil([rule performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil]);
    NSDictionary *genericClass = [[rule class] modelContainerPropertyGenericClass];
    XCTAssertNotNil(genericClass);
}

- (void)testInitMultipartRequestBuildRequestData {
    QCloudLogInfo(@"QCloudCOSXMLExceptionCoverage:testInitMultipartRequestBuildRequestData");
    QCloudInitiateMultipartUploadRequest *request = [[QCloudInitiateMultipartUploadRequest alloc] init];
    request.cacheControl = @"cacheControl";
    request.contentDisposition = @"contentDisposition";
    request.expect = @"continue-1000";
    request.expires = @"expires";
    request.contentSHA1 = @"SHA1";
    request.accessControlList = @"public";
    request.grantRead = @"grantRead";
    request.grantWrite = @"grantWrite";
    request.grantFullControl = @"grantFullControl";

    request.object = @"object";
    request.bucket = @"tjtest";
    NSError *error = [NSError errorWithDomain:@"com.test.domain" code:404 userInfo:nil];

    request.object = nil;
    XCTAssert(![request buildURLRequest:&error]);
    request.object = @"aaa";
    request.bucket = nil;
    XCTAssert(![request buildURLRequest:&error]);

    request.bucket = @"test";
    XCTAssert([request buildRequestData:&error]);
}

- (void)testCoverListMultipartRequest {
    QCloudLogInfo(@"QCloudCOSXMLExceptionCoverage:testCoverListMultipartRequest");
    QCloudListMultipartRequest *request = [[QCloudListMultipartRequest alloc] init];
    NSError *error = [NSError errorWithDomain:@"com.test.domain" code:404 userInfo:nil];
    XCTAssert(![request buildURLRequest:&error]);
    request.object = @"test";
    XCTAssert(![request buildURLRequest:&error]);
    request.bucket = @"test";
    request.uploadId = @"1233";
    request.maxPartsCount = @"1000";
    request.encodingType = @"encodingType";
    request.partNumberMarker = @"partNumberMaker";
    XCTAssert(![request buildURLRequest:&error]);
}

- (void)testCoverCompleteMultipartUploadRequest {
    QCloudLogInfo(@"QCloudCOSXMLExceptionCoverage:testCoverCompleteMultipartUploadRequest");
    QCloudCompleteMultipartUploadRequest *request = [[QCloudCompleteMultipartUploadRequest alloc] init];
    NSError *error = [NSError errorWithDomain:@"com.test.domain" code:404 userInfo:nil];
    XCTAssert(![request buildURLRequest:&error]);
    request.object = @"testObject";
    XCTAssert(![request buildURLRequest:&error]);
    request.bucket = @"testBucket";
    XCTAssert(![request buildURLRequest:&error]);
    request.uploadId = @"uploadIDTest";
    XCTAssert(![request buildURLRequest:&error]);
}

- (void)testCoverOptionsObjectRequest {
    QCloudLogInfo(@"QCloudCOSXMLExceptionCoverage:testCoverOptionsObjectRequest");
    QCloudOptionsObjectRequest *request = [[QCloudOptionsObjectRequest alloc] init];
    NSError *error = [NSError errorWithDomain:@"com.test.domain" code:404 userInfo:nil];
    XCTAssert(![request buildURLRequest:&error]);
    request.object = @"testObject";
    XCTAssert(![request buildURLRequest:&error]);
    request.bucket = @"testBucket";
    XCTAssert(![request buildURLRequest:&error]);
    request.origin = @"originTest";
    XCTAssert(![request buildURLRequest:&error]);
    request.accessControlRequestMethod = @"testMethods";
    XCTAssert(![request buildURLRequest:&error]);
}

- (void)testCoverAbortMultipartUploadRequest {
    QCloudLogInfo(@"QCloudCOSXMLExceptionCoverage:testCoverAbortMultipartUploadRequest");
    QCloudAbortMultipfartUploadRequest *request = [[QCloudAbortMultipfartUploadRequest alloc] init];
    NSError *error = [NSError errorWithDomain:@"com.test.domain" code:404 userInfo:nil];
    XCTAssert(![request buildURLRequest:&error]);
    request.object = @"testObject";
    XCTAssert(![request buildURLRequest:&error]);
    request.bucket = @"testBucket";
    XCTAssert(![request buildURLRequest:&error]);
    request.uploadId = @"uploadIDTest";
    XCTAssert(![request buildURLRequest:&error]);
}

- (void)testCoverListMultipartUploadResult {
    QCloudLogInfo(@"QCloudCOSXMLExceptionCoverage:testCoverListMultipartUploadResult");
    QCloudListMultipartUploadsResult *request = [[QCloudListMultipartUploadsResult alloc] init];
    NSDictionary *testInput = @{ @"Upload" : [NSNull null] };
    XCTAssert([[request performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:testInput] isKindOfClass:[NSDictionary class]]);
    testInput = @{ @"Upload" : @ { @"123" : @"456" } };
    XCTAssert([[request performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:testInput] isKindOfClass:[NSDictionary class]]);
    testInput = @{ @"Upload" : @ { @"123" : @[ @"111", @"222" ] } };
    XCTAssert([[request performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:testInput] isKindOfClass:[NSDictionary class]]);
}

- (void)tetCoverUploadPartRequest {
    QCloudLogInfo(@"QCloudCOSXMLExceptionCoverage:tetCoverUploadPartRequest");
    QCloudUploadPartRequest *request = [[QCloudUploadPartRequest alloc] init];
    NSError *error;
    XCTAssert(![request buildURLRequest:&error]);
    error = nil;
    request.object = @"karis:testObject";
    XCTAssert(![request buildURLRequest:&error]);
    error = nil;
    request.bucket = @"karis:testBucket";
    XCTAssert(![request buildURLRequest:&error]);
    error = nil;
    request.uploadId = @"uploadIDTest";
    request.contentSHA1 = @"contentSHA1";
    request.expect = @"expect";
    XCTAssert(![request buildURLRequest:&error]);
}

- (NSString *)formattedBucket:(NSString *)bucket withAPPID:(NSString *)APPID {
    NSInteger subfixLength = APPID.length + 1;
    if (bucket.length <= subfixLength) {
        return bucket;
    }
    NSString *APPIDSubfix = [NSString stringWithFormat:@"-%@", APPID];
    NSString *subfixString = [bucket substringWithRange:NSMakeRange(bucket.length - subfixLength, subfixLength)];
    if ([subfixString isEqualToString:APPIDSubfix]) {
        return [bucket substringWithRange:NSMakeRange(0, bucket.length - subfixLength)];
    }
    // should not reach here
    return bucket;
}

- (void)testFormateBucket {
    QCloudLogInfo(@"QCloudCOSXMLExceptionCoverage:testFormateBucket");
    NSString *appID = @"1253653367";
    NSString *input1 = @"test";
    NSString *input2 = @"test-1253653367";
    NSString *input3 = @"test1253653367";
    NSString *input4 = @"-1253653367";
    NSString *input5 = @"1253653367";
    NSString *input6 = @"test-1253653367-1253653367";
    NSString *input7 = @"1253653367-test";
    NSString *input8 = @"-1253653367-1253653367";
    XCTAssert([[self formattedBucket:input1 withAPPID:appID] isEqualToString:@"test"]);
    XCTAssert([[self formattedBucket:input2 withAPPID:appID] isEqualToString:@"test"]);
    XCTAssert([[self formattedBucket:input3 withAPPID:appID] isEqualToString:@"test1253653367"]);
    XCTAssert([[self formattedBucket:input4 withAPPID:appID] isEqualToString:@"-1253653367"]);
    XCTAssert([[self formattedBucket:input5 withAPPID:appID] isEqualToString:@"1253653367"]);
    XCTAssert([[self formattedBucket:input6 withAPPID:appID] isEqualToString:@"test-1253653367"]);
    XCTAssert([[self formattedBucket:input7 withAPPID:appID] isEqualToString:@"1253653367-test"]);
    XCTAssert([[self formattedBucket:input8 withAPPID:appID] isEqualToString:@"-1253653367"]);
}

- (void)testCoverQCloudOwner {
    QCloudLogInfo(@"QCloudCOSXMLExceptionCoverage:testCoverQCloudOwner");
    QCloudOwner *owner = [[QCloudOwner alloc] init];
    XCTAssert([QCloudOwner performSelector:@selector(modelCustomPropertyMapper)]);
    XCTAssertNil([owner performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil]);
    XCTAssert([owner performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:[NSDictionary dictionary]]);
    XCTAssert([owner performSelector:@selector(modelCustomTransformToDictionary:) withObject:nil]);
}

- (void)testCoverQCloudCOSXMLStatusEnum {
    QCloudLogInfo(@"QCloudCOSXMLExceptionCoverage:testCoverQCloudCOSXMLStatusEnum");
    XCTAssert(QCloudCOSXMLStatusDumpFromString(@"Enabled") == QCloudCOSXMLStatusEnabled);
    XCTAssert(QCloudCOSXMLStatusDumpFromString(@"Disable") == QCloudCOSXMLStatusDisabled);
    XCTAssert([QCloudCOSXMLStatusTransferToString(QCloudCOSXMLStatusEnabled) isEqualToString:@"Enabled"]);
    XCTAssert([QCloudCOSXMLStatusTransferToString(QCloudCOSXMLStatusDisabled) isEqualToString:@"Disabled"]);
}

- (void)testCoverLifeCycleStatusEnum {
    QCloudLogInfo(@"QCloudCOSXMLExceptionCoverage:testCoverLifeCycleStatusEnum");
    XCTAssert(QCloudLifecycleStatueDumpFromString(@"Enabled") == QCloudLifecycleStatueEnabled);
    XCTAssert(QCloudLifecycleStatueDumpFromString(@"Disabled") == QCloudLifecycleStatueDisabled);
    XCTAssert([QCloudLifecycleStatueTransferToString(QCloudLifecycleStatueEnabled) isEqualToString:@"Enabled"]);
    XCTAssert([QCloudLifecycleStatueTransferToString(QCloudLifecycleStatueDisabled) isEqualToString:@"Disabled"]);
}

- (void)testCoverNonCurrentVersionTransition {
    QCloudLogInfo(@"QCloudCOSXMLExceptionCoverage:testCoverNonCurrentVersionTransition");
    XCTAssert([QCloudNoncurrentVersionTransition performSelector:@selector(modelCustomPropertyMapper)]);
    QCloudNoncurrentVersionTransition *transition = [[QCloudNoncurrentVersionTransition alloc] init];
    XCTAssert([transition performSelector:@selector(modelCustomTransformToDictionary:) withObject:nil]);
    XCTAssertNil([transition performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil]);
    XCTAssert([transition performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:[NSDictionary dictionary]]);
}

- (void)testCoverNonCurrentVersionExpiration {
    QCloudLogInfo(@"QCloudCOSXMLExceptionCoverage:testCoverNonCurrentVersionExpiration");
    XCTAssert([QCloudNoncurrentVersionExpiration performSelector:@selector(modelCustomPropertyMapper)]);
    QCloudNoncurrentVersionExpiration *expiration = [[QCloudNoncurrentVersionExpiration alloc] init];
    XCTAssert([expiration performSelector:@selector(modelCustomTransformToDictionary:) withObject:nil]);
    XCTAssertNil([expiration performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil]);
    XCTAssert([expiration performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:[NSDictionary dictionary]]);
}

- (void)testCoverMultipartUploadContent {
    QCloudLogInfo(@"QCloudCOSXMLExceptionCoverage:testCoverMultipartUploadContent");
    XCTAssert([QCloudListMultipartUploadContent performSelector:@selector(modelCustomPropertyMapper)]);
    QCloudListMultipartUploadContent *content = [[QCloudListMultipartUploadContent alloc] init];
    NSDictionary *inputDictionray = @{ @"StorageClass" : @(0) };
    XCTAssert([content performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:inputDictionray]);
    XCTAssert([content performSelector:@selector(modelCustomTransformToDictionary:) withObject:[NSMutableDictionary dictionary]]);
    XCTAssertNil([content performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil]);
}

- (void)testCoverLifecycleExpiration {
    QCloudLogInfo(@"QCloudCOSXMLExceptionCoverage:testCoverLifecycleExpiration");
    QCloudLifecycleExpiration *expiration = [[QCloudLifecycleExpiration alloc] init];
    XCTAssert([QCloudLifecycleExpiration performSelector:@selector(modelCustomPropertyMapper)]);
    XCTAssert([expiration performSelector:@selector(modelCustomTransformToDictionary:) withObject:nil]);
    XCTAssert([expiration performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:[NSDictionary dictionary]]);
}

- (void)testCoverLifeCycleTag {
    QCloudLogInfo(@"QCloudCOSXMLExceptionCoverage:testCoverLifeCycleTag");
    XCTAssert([QCloudLifecycleTag performSelector:@selector(modelCustomPropertyMapper)]);
    QCloudLifecycleTag *tag = [[QCloudLifecycleTag alloc] init];
    XCTAssert([tag performSelector:@selector(modelCustomTransformToDictionary:) withObject:nil]);
    XCTAssertNil([tag performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil]);
    XCTAssert([tag performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:[NSDictionary dictionary]]);
}

- (void)testCoverLifeCycleRuleAnd {
    QCloudLogInfo(@"QCloudCOSXMLExceptionCoverage:testCoverLifeCycleRuleAnd");
    XCTAssert([QCloudLifecycleRuleFilterAnd performSelector:@selector(modelCustomPropertyMapper)]);
    QCloudLifecycleRuleFilterAnd *ruleFilterAnd = [[QCloudLifecycleRuleFilterAnd alloc] init];
    XCTAssert([ruleFilterAnd performSelector:@selector(modelCustomTransformToDictionary:) withObject:nil]);
    XCTAssertNil([ruleFilterAnd performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil]);
    XCTAssert([ruleFilterAnd performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:[NSDictionary dictionary]]);
}

- (void)testCoverLifecycleAbortMultipartUpload {
    QCloudLogInfo(@"QCloudCOSXMLExceptionCoverage:testCoverLifecycleAbortMultipartUpload");
    QCloudLifecycleAbortIncompleteMultipartUpload *abortUpload = [[QCloudLifecycleAbortIncompleteMultipartUpload alloc] init];
    XCTAssert([QCloudLifecycleAbortIncompleteMultipartUpload performSelector:@selector(modelCustomPropertyMapper)]);
    XCTAssert([abortUpload performSelector:@selector(modelCustomTransformToDictionary:) withObject:[NSDictionary dictionary]]);
    XCTAssert([abortUpload performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:[NSDictionary dictionary]]);
    XCTAssert([abortUpload performSelector:@selector(modelCustomWillTransformFromDictionary:) withObject:nil] == nil);
}

- (void)testCoverGetObjectRequest {
    QCloudLogInfo(@"QCloudCOSXMLExceptionCoverage:testCoverGetObjectRequest");
    QCloudGetObjectRequest *request = [[QCloudGetObjectRequest alloc] init];

    request.responseContentType = @"response-contentType";

    request.responseContentLanguage = @"responseLanguage";

    request.responseContentExpires = @"expires";

    request.responseCacheControl = @"cacheControl";

    request.responseContentDisposition = @"Disposotion";

    request.responseContentEncoding = @"content-encoding";
    request.range = @"0-10086";
    NSError *error;
    XCTAssert([request buildRequestData:&error] == NO);
    error = nil;
    request.bucket = @"testBucket";
    XCTAssert([request buildRequestData:&error] == NO);
    error = nil;
    request.object = @"testObject";
    XCTAssert([request buildRequestData:&error]);
    error = nil;
    request.ifModifiedSince = @"testIfModifiedSince";
    XCTAssert([request buildRequestData:&error]);
}

- (void)testCoverPutObjectCopyRequest {
    QCloudLogInfo(@"QCloudCOSXMLExceptionCoverage:testCoverPutObjectCopyRequest");
    QCloudPutObjectCopyRequest *request = [[QCloudPutObjectCopyRequest alloc] init];
    NSError *error;
    XCTAssert(![request buildRequestData:&error]);
    error = nil;
    request.object = @"testObject";
    XCTAssert(![request buildRequestData:&error]);
    request.bucket = kTestBucket;
    error = nil;
    XCTAssert([request buildRequestData:&error]);
    NSString *testValue = @"testValue";
    request.metadataDirective = testValue;
    request.objectCopyIfModifiedSince = testValue;
    request.objectCopyIfMatch = testValue;
    request.objectCopyIfNoneMatch = testValue;
    request.objectCopyIfUnmodifiedSince = testValue;
    request.accessControlList = testValue;
    request.grantRead = testValue;
    request.grantWrite = testValue;
    request.grantFullControl = testValue;
    error = nil;
    XCTAssert([request buildRequestData:&error]);
}

- (void)testCoverCOSPermissionDump {
    QCloudLogInfo(@"QCloudCOSXMLExceptionCoverage:testCoverCOSPermissionDump");
    XCTAssert(QCloudCOSPermissionDumpFromString(@"READ") == QCloudCOSPermissionRead);
    XCTAssert(QCloudCOSPermissionDumpFromString(@"WRITE") == QCloudCOSPermissionWrite);
    XCTAssert(QCloudCOSPermissionDumpFromString(@"FULL_CONTROL") == QCloudCOSPermissionFullControl);

    XCTAssert([QCloudCOSPermissionTransferToString(QCloudCOSPermissionRead) isEqualToString:@"READ"]);
    XCTAssert([QCloudCOSPermissionTransferToString(QCloudCOSPermissionWrite) isEqualToString:@"WRITE"]);
    XCTAssert([QCloudCOSPermissionTransferToString(QCloudCOSPermissionFullControl) isEqualToString:@"FULL_CONTROL"]);
}

@end
