//
//  QCloudCOSXMLMateDataTests.m
//  QCloudCOSXMLDemoTests
//
//  Created by garenwang on 2020/6/8.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "QCloudCOSXML.h"
#import "TestCommonDefine.h"
#import "QCloudTestTempVariables.h"
#import "QCloudCOSXMLTestUtility.h"
#import "QCloudCOSXMLService+MateData.h"
#import "SecretStorage.h"
#import "QCloudCOSXMLEndPoint.h"
#define kCOSImageBucketKey @"imgBucket"
#import "QCloudBucket.h"

#import "QCloudCreateDatasetRequest.h"
#import "QCloudCreateDatasetBindingRequest.h"
#import "QCloudCreateFileMetaIndexRequest.h"
#import "QCloudDatasetSimpleQueryRequest.h"
#import "QCloudDeleteDatasetRequest.h"
#import "QCloudDeleteDatasetBindingRequest.h"
#import "QCloudDeleteFileMetaIndexRequest.h"
#import "QCloudDescribeDatasetRequest.h"
#import "QCloudDescribeDatasetBindingRequest.h"
#import "QCloudDescribeDatasetBindingsRequest.h"
#import "QCloudDescribeDatasetsRequest.h"
#import "QCloudDescribeFileMetaIndexRequest.h"
#import "QCloudUpdateDatasetRequest.h"
#import "QCloudUpdateFileMetaIndexRequest.h"
#import "QCloudDatasetFaceSearchRequest.h"

@interface QCloudCOSXMLMateDataTestsV2 : XCTestCase <QCloudSignatureProvider>
@property (nonatomic, strong) NSString *appID;
@property (nonatomic, strong) NSString *ownerID;
@property (nonatomic, strong) NSString *authorizedUIN;
@property (nonatomic, strong) NSString *ownerUIN;
@property (nonatomic, strong) NSMutableArray *tempFilePathArray;
@end
static QCloudBucket *imageTestBucket;
@implementation QCloudCOSXMLMateDataTestsV2

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
    imageTestBucket = [QCloudBucket new];
    imageTestBucket.name = @"cos-sdk-citest-1253960454";
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
// 测试创建数据集
-(void)testCreateDataset0{
    // 创建数据集
    XCTestExpectation* expectationCreateDataset = [self expectationWithDescription:@"testCreateDataset"];
    __block QCloudCreateDatasetResponse * requestResult = nil;
    QCloudCreateDatasetRequest * requestCreateDataset = [QCloudCreateDatasetRequest new];
    requestCreateDataset.regionName = @"ap-beijing";
    requestCreateDataset.input = [QCloudCreateDataset new];
    // 数据集名称，同一个账户下唯一。命名规则如下： - 长度为1~128字符 - 只能包含英文字母，数字，短划线（-）和下划线（） - 必须以英文字母和下划线（）开头;是否必传：是
    NSString *datasetName = [NSString stringWithFormat:@"datasetname%@", @(arc4random()%100)];
    requestCreateDataset.input.DatasetName = datasetName;

    [requestCreateDataset setFinishBlock:^(QCloudCreateDatasetResponse * outputObject, NSError *error) {
        XCTAssertNil(error);
        requestResult = outputObject;
        [expectationCreateDataset fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] CreateDataset:requestCreateDataset];
    [self waitForExpectationsWithTimeout:100 handler:nil];

    // 删除数据集
    XCTestExpectation* expectationDeleteDataset = [self expectationWithDescription:@"testDeleteDataset"];
    __block QCloudDeleteDatasetResponse * afterResult = nil;
    QCloudDeleteDatasetRequest * requestDeleteDataset = [QCloudDeleteDatasetRequest new];
    requestDeleteDataset.regionName = @"ap-beijing";
    requestDeleteDataset.input = [QCloudDeleteDataset new];
    // 数据集名称，同一个账户下唯一。;是否必传：是
    requestDeleteDataset.input.DatasetName = datasetName;

    [requestDeleteDataset setFinishBlock:^(QCloudDeleteDatasetResponse * outputObject, NSError *error) {
        XCTAssertNil(error);
        afterResult = outputObject;
        [expectationDeleteDataset fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] DeleteDataset:requestDeleteDataset];
    [self waitForExpectationsWithTimeout:100 handler:nil];

}

// 测试绑定存储桶与数据集
-(void)testCreateDatasetBinding0{
    // 绑定存储桶与数据集
    XCTestExpectation* expectationCreateDatasetBinding = [self expectationWithDescription:@"testCreateDatasetBinding"];
    __block QCloudCreateDatasetBindingResponse * requestResult = nil;
    QCloudCreateDatasetBindingRequest * requestCreateDatasetBinding = [QCloudCreateDatasetBindingRequest new];
    requestCreateDatasetBinding.regionName = @"ap-beijing";
    requestCreateDatasetBinding.input = [QCloudCreateDatasetBinding new];
    // 数据集名称，同一个账户下唯一。;是否必传：是
    requestCreateDatasetBinding.input.DatasetName = @"notdelete";
    // 资源标识字段，表示需要与数据集绑定的资源，当前仅支持COS存储桶，字段规则：cos://，其中BucketName表示COS存储桶名称，例如：cos://examplebucket-1250000000;是否必传：是
    requestCreateDatasetBinding.input.URI = @"cos://0-c-1253960454";

    [requestCreateDatasetBinding setFinishBlock:^(QCloudCreateDatasetBindingResponse * outputObject, NSError *error) {
        XCTAssertNil(error);
        requestResult = outputObject;
        [expectationCreateDatasetBinding fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] CreateDatasetBinding:requestCreateDatasetBinding];
    [self waitForExpectationsWithTimeout:100 handler:nil];

    // 解绑存储桶与数据集
    XCTestExpectation* expectationDeleteDatasetBinding = [self expectationWithDescription:@"testDeleteDatasetBinding"];
    QCloudDeleteDatasetBindingRequest * requestDeleteDatasetBinding = [QCloudDeleteDatasetBindingRequest new];
    requestDeleteDatasetBinding.regionName = @"ap-beijing";
    requestDeleteDatasetBinding.input = [QCloudDeleteDatasetBinding new];
    // 数据集名称，同一个账户下唯一。;是否必传：是
    requestDeleteDatasetBinding.input.DatasetName = @"notdelete";
    // 资源标识字段，表示需要与数据集绑定的资源，当前仅支持COS存储桶，字段规则：cos://，其中BucketName表示COS存储桶名称，例如：cos://examplebucket-1250000000;是否必传：是
    requestDeleteDatasetBinding.input.URI = @"cos://0-c-1253960454";

    [requestDeleteDatasetBinding setFinishBlock:^(QCloudDeleteDatasetBindingResponse * outputObject, NSError *error) {
        XCTAssertNil(error);
        [expectationDeleteDatasetBinding fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] DeleteDatasetBinding:requestDeleteDatasetBinding];
    [self waitForExpectationsWithTimeout:100 handler:nil];

}

// 测试创建元数据索引
-(void)testCreateFileMetaIndex0{
    // 创建数据集
    XCTestExpectation* expectationCreateDataset = [self expectationWithDescription:@"testCreateDataset"];
    __block QCloudCreateDatasetResponse * beforeResult = nil;
    QCloudCreateDatasetRequest * requestCreateDataset = [QCloudCreateDatasetRequest new];
    requestCreateDataset.regionName = @"ap-beijing";
    requestCreateDataset.input = [QCloudCreateDataset new];
    // 数据集名称，同一个账户下唯一。命名规则如下： - 长度为1~128字符 - 只能包含英文字母，数字，短划线（-）和下划线（） - 必须以英文字母和下划线（）开头;是否必传：是
    NSString *datasetName = [NSString stringWithFormat:@"datasetcxx%@", @(arc4random()%100)];
    requestCreateDataset.input.DatasetName = datasetName;
    // 数据集描述信息。长度为1~256个英文或中文字符，默认值为空。;是否必传：否
    requestCreateDataset.input.Description = @"数据集描述";

    [requestCreateDataset setFinishBlock:^(QCloudCreateDatasetResponse * outputObject, NSError *error) {
        XCTAssertNil(error);
        beforeResult = outputObject;
        [expectationCreateDataset fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] CreateDataset:requestCreateDataset];
    [self waitForExpectationsWithTimeout:100 handler:nil];

    // 创建元数据索引
    XCTestExpectation* expectationCreateFileMetaIndex = [self expectationWithDescription:@"testCreateFileMetaIndex"];
    __block QCloudCreateFileMetaIndexResponse * requestResult = nil;
    QCloudCreateFileMetaIndexRequest * requestCreateFileMetaIndex = [QCloudCreateFileMetaIndexRequest new];
    requestCreateFileMetaIndex.regionName = @"ap-beijing";
    requestCreateFileMetaIndex.input = [QCloudCreateFileMetaIndex new];
    // 数据集名称，同一个账户下唯一。;是否必传：是
    requestCreateFileMetaIndex.input.DatasetName = datasetName;
    // 用于建立索引的文件信息。;是否必传：是
    requestCreateFileMetaIndex.input.File = [QCloudFile new];
    // 资源标识字段，表示需要建立索引的文件地址，当前仅支持COS上的文件，字段规则：cos:///，其中BucketName表示COS存储桶名称，ObjectKey表示文件完整路径，例如：cos://examplebucket-1250000000/test1/img.jpg。 注意： 1、仅支持本账号内的COS文件 2、不支持HTTP开头的地址;是否必传：是
    requestCreateFileMetaIndex.input.File.URI = @"cos://0-c-1253960454/2022/";

    [requestCreateFileMetaIndex setFinishBlock:^(QCloudCreateFileMetaIndexResponse * outputObject, NSError *error) {
        XCTAssertNil(error);
        requestResult = outputObject;
        [expectationCreateFileMetaIndex fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] CreateFileMetaIndex:requestCreateFileMetaIndex];
    [self waitForExpectationsWithTimeout:100 handler:nil];

    // 删除数据集
    XCTestExpectation* expectationDeleteDataset = [self expectationWithDescription:@"testDeleteDataset"];
    __block QCloudDeleteDatasetResponse * afterResult = nil;
    QCloudDeleteDatasetRequest * requestDeleteDataset = [QCloudDeleteDatasetRequest new];
    requestDeleteDataset.regionName = @"ap-beijing";
    requestDeleteDataset.input = [QCloudDeleteDataset new];
    // 数据集名称，同一个账户下唯一。;是否必传：是
    requestDeleteDataset.input.DatasetName = datasetName;

    [requestDeleteDataset setFinishBlock:^(QCloudDeleteDatasetResponse * outputObject, NSError *error) {
        XCTAssertNil(error);
        afterResult = outputObject;
        [expectationDeleteDataset fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] DeleteDataset:requestDeleteDataset];
    [self waitForExpectationsWithTimeout:100 handler:nil];

}

// 测试简单查询
-(void)testDatasetSimpleQuery0{
    // 创建数据集
    XCTestExpectation* expectationCreateDataset = [self expectationWithDescription:@"testCreateDataset"];
    __block QCloudCreateDatasetResponse * beforeResult = nil;
    QCloudCreateDatasetRequest * requestCreateDataset = [QCloudCreateDatasetRequest new];
    requestCreateDataset.regionName = @"ap-beijing";
    requestCreateDataset.input = [QCloudCreateDataset new];
    // 数据集名称，同一个账户下唯一。命名规则如下： - 长度为1~128字符 - 只能包含英文字母，数字，短划线（-）和下划线（） - 必须以英文字母和下划线（）开头;是否必传：是
    requestCreateDataset.input.DatasetName = @"datasetnametest1001";

    [requestCreateDataset setFinishBlock:^(QCloudCreateDatasetResponse * outputObject, NSError *error) {
        XCTAssertNil(error);
        beforeResult = outputObject;
        [expectationCreateDataset fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] CreateDataset:requestCreateDataset];
    [self waitForExpectationsWithTimeout:100 handler:nil];

    // 简单查询
    XCTestExpectation* expectationDatasetSimpleQuery = [self expectationWithDescription:@"testDatasetSimpleQuery"];
    __block QCloudDatasetSimpleQueryResponse * requestResult = nil;
    QCloudDatasetSimpleQueryRequest * requestDatasetSimpleQuery = [QCloudDatasetSimpleQueryRequest new];
    requestDatasetSimpleQuery.regionName = @"ap-beijing";
    requestDatasetSimpleQuery.input = [QCloudDatasetSimpleQuery new];
    // 数据集名称，同一个账户下唯一。;是否必传：是
    requestDatasetSimpleQuery.input.DatasetName = @"datasetnametest1001";
    // 简单查询参数条件，可自嵌套。;是否必传：是
    requestDatasetSimpleQuery.input.Query = [QCloudQuery new];
    // 操作运算符。枚举值： not：逻辑非。 or：逻辑或。 and：逻辑与。 lt：小于。 lte：小于等于。 gt：大于。 gte：大于等于。 eq：等于。 exist：存在性查询。 prefix：前缀查询。 match-phrase：字符串匹配查询。 nested：字段为数组时，其中同一对象内逻辑条件查询。;是否必传：是
    requestDatasetSimpleQuery.input.Query.Operation = @"or";
    // 子查询的结构体。 只有当Operations为逻辑运算符（and、or、not或nested）时，才能设置子查询条件。 在逻辑运算符为and/or/not时，其SubQueries内描述的所有条件需符合父级设置的and/or/not逻辑关系。 在逻辑运算符为nested时，其父级的Field必须为一个数组类的字段（如：Labels）。 子查询条件SubQueries组的Operation必须为and/or/not中的一个或多个，其Field必须为父级Field的子属性。;是否必传：否
    QCloudSubQueries *SubQueries = [QCloudSubQueries new];
    SubQueries.Value = @"1";
    SubQueries.Operation = @"gt";
    SubQueries.Field = @"Size";
    requestDatasetSimpleQuery.input.Query.SubQueries = @[SubQueries];
    // 排序字段列表。请参考字段和操作符的支持列表。 多个排序字段可使用半角逗号（,）分隔，例如：Size,Filename。 最多可设置5个排序字段。 排序字段顺序即为排序优先级顺序。;是否必传：是
    requestDatasetSimpleQuery.input.Sort = @"Filename";
    // 排序字段的排序方式。取值如下： asc：升序； desc（默认）：降序。 多个排序方式可使用半角逗号（,）分隔，例如：asc,desc。 排序方式不可多于排序字段，即参数Order的元素数量需小于等于参数Sort的元素数量。例如Sort取值为Size,Filename时，Order可取值为asc,desc或asc。 排序方式少于排序字段时，未排序的字段默认取值asc。例如Sort取值为Size,Filename，Order取值为asc时，Filename默认排序方式为asc，即升序排列;是否必传：是
    requestDatasetSimpleQuery.input.Order = @"asc";

    [requestDatasetSimpleQuery setFinishBlock:^(QCloudDatasetSimpleQueryResponse * outputObject, NSError *error) {
        XCTAssertNil(error);
        requestResult = outputObject;
        [expectationDatasetSimpleQuery fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] DatasetSimpleQuery:requestDatasetSimpleQuery];
    [self waitForExpectationsWithTimeout:100 handler:nil];

    // 删除数据集
    XCTestExpectation* expectationDeleteDataset = [self expectationWithDescription:@"testDeleteDataset"];
    __block QCloudDeleteDatasetResponse * afterResult = nil;
    QCloudDeleteDatasetRequest * requestDeleteDataset = [QCloudDeleteDatasetRequest new];
    requestDeleteDataset.regionName = @"ap-beijing";
    requestDeleteDataset.input = [QCloudDeleteDataset new];
    // 数据集名称，同一个账户下唯一。;是否必传：是
    requestDeleteDataset.input.DatasetName = @"datasetnametest1001";

    [requestDeleteDataset setFinishBlock:^(QCloudDeleteDatasetResponse * outputObject, NSError *error) {
        XCTAssertNil(error);
        afterResult = outputObject;
        [expectationDeleteDataset fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] DeleteDataset:requestDeleteDataset];
    [self waitForExpectationsWithTimeout:100 handler:nil];

}

// 测试删除数据集
-(void)testDeleteDataset0{
    // 创建数据集
    XCTestExpectation* expectationCreateDataset = [self expectationWithDescription:@"testCreateDataset"];
    __block QCloudCreateDatasetResponse * beforeResult = nil;
    QCloudCreateDatasetRequest * requestCreateDataset = [QCloudCreateDatasetRequest new];
    requestCreateDataset.regionName = @"ap-beijing";
    requestCreateDataset.input = [QCloudCreateDataset new];
    // 数据集名称，同一个账户下唯一。命名规则如下： - 长度为1~128字符 - 只能包含英文字母，数字，短划线（-）和下划线（） - 必须以英文字母和下划线（）开头;是否必传：是
    requestCreateDataset.input.DatasetName = @"datasetnametest4";
    // 数据集描述信息。长度为1~256个英文或中文字符，默认值为空。;是否必传：否
    requestCreateDataset.input.Description = @"数据集描述";

    [requestCreateDataset setFinishBlock:^(QCloudCreateDatasetResponse * outputObject, NSError *error) {
        XCTAssertNil(error);
        beforeResult = outputObject;
        [expectationCreateDataset fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] CreateDataset:requestCreateDataset];
    [self waitForExpectationsWithTimeout:100 handler:nil];

    // 删除数据集
    XCTestExpectation* expectationDeleteDataset = [self expectationWithDescription:@"testDeleteDataset"];
    __block QCloudDeleteDatasetResponse * requestResult = nil;
    QCloudDeleteDatasetRequest * requestDeleteDataset = [QCloudDeleteDatasetRequest new];
    requestDeleteDataset.regionName = @"ap-beijing";
    requestDeleteDataset.input = [QCloudDeleteDataset new];
    // 数据集名称，同一个账户下唯一。;是否必传：是
    requestDeleteDataset.input.DatasetName = @"datasetnametest4";

    [requestDeleteDataset setFinishBlock:^(QCloudDeleteDatasetResponse * outputObject, NSError *error) {
        XCTAssertNil(error);
        requestResult = outputObject;
        [expectationDeleteDataset fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] DeleteDataset:requestDeleteDataset];
    [self waitForExpectationsWithTimeout:100 handler:nil];

}

// 测试解绑存储桶与数据集
-(void)testDeleteDatasetBinding0{
    // 绑定存储桶与数据集
    XCTestExpectation* expectationCreateDatasetBinding = [self expectationWithDescription:@"testCreateDatasetBinding"];
    __block QCloudCreateDatasetBindingResponse * beforeResult = nil;
    QCloudCreateDatasetBindingRequest * requestCreateDatasetBinding = [QCloudCreateDatasetBindingRequest new];
    requestCreateDatasetBinding.regionName = @"ap-beijing";
    requestCreateDatasetBinding.input = [QCloudCreateDatasetBinding new];
    // 数据集名称，同一个账户下唯一。;是否必传：是
    requestCreateDatasetBinding.input.DatasetName = @"notdelete";
    // 资源标识字段，表示需要与数据集绑定的资源，当前仅支持COS存储桶，字段规则：cos://，其中BucketName表示COS存储桶名称，例如：cos://examplebucket-1250000000;是否必传：是
    requestCreateDatasetBinding.input.URI = @"cos://0-c-1253960454";

    [requestCreateDatasetBinding setFinishBlock:^(QCloudCreateDatasetBindingResponse * outputObject, NSError *error) {
        XCTAssertNil(error);
        beforeResult = outputObject;
        [expectationCreateDatasetBinding fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] CreateDatasetBinding:requestCreateDatasetBinding];
    [self waitForExpectationsWithTimeout:100 handler:nil];

    // 解绑存储桶与数据集
    XCTestExpectation* expectationDeleteDatasetBinding = [self expectationWithDescription:@"testDeleteDatasetBinding"];
    __block QCloudDeleteDatasetBindingResponse * requestResult = nil;
    QCloudDeleteDatasetBindingRequest * requestDeleteDatasetBinding = [QCloudDeleteDatasetBindingRequest new];
    requestDeleteDatasetBinding.regionName = @"ap-beijing";
    requestDeleteDatasetBinding.input = [QCloudDeleteDatasetBinding new];
    // 数据集名称，同一个账户下唯一。;是否必传：是
    requestDeleteDatasetBinding.input.DatasetName = @"notdelete";
    // 资源标识字段，表示需要与数据集绑定的资源，当前仅支持COS存储桶，字段规则：cos://，其中BucketName表示COS存储桶名称，例如：cos://examplebucket-1250000000;是否必传：是
    requestDeleteDatasetBinding.input.URI = @"cos://0-c-1253960454";

    [requestDeleteDatasetBinding setFinishBlock:^(QCloudDeleteDatasetBindingResponse * outputObject, NSError *error) {
        XCTAssertNil(error);
        requestResult = outputObject;
        [expectationDeleteDatasetBinding fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] DeleteDatasetBinding:requestDeleteDatasetBinding];
    [self waitForExpectationsWithTimeout:100 handler:nil];

}

// 测试删除元数据索引
-(void)testDeleteFileMetaIndex0{
    // 删除元数据索引
    XCTestExpectation* expectationDeleteFileMetaIndex = [self expectationWithDescription:@"testDeleteFileMetaIndex"];
    __block QCloudDeleteFileMetaIndexResponse * requestResult = nil;
    QCloudDeleteFileMetaIndexRequest * requestDeleteFileMetaIndex = [QCloudDeleteFileMetaIndexRequest new];
    requestDeleteFileMetaIndex.regionName = @"ap-beijing";
    requestDeleteFileMetaIndex.input = [QCloudDeleteFileMetaIndex new];
    // 数据集名称，同一个账户下唯一。;是否必传：是
    requestDeleteFileMetaIndex.input.DatasetName = @"notdelete";
    // 资源标识字段，表示需要建立索引的文件地址。;是否必传：是
    requestDeleteFileMetaIndex.input.URI = @"cos://0-c-1253960454/2022/";

    [requestDeleteFileMetaIndex setFinishBlock:^(QCloudDeleteFileMetaIndexResponse * outputObject, NSError *error) {
        XCTAssertNil(error);
        requestResult = outputObject;
        [expectationDeleteFileMetaIndex fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] DeleteFileMetaIndex:requestDeleteFileMetaIndex];
    [self waitForExpectationsWithTimeout:100 handler:nil];

}

// 测试查询数据集
-(void)testDescribeDataset0{
    // 创建数据集
    XCTestExpectation* expectationCreateDataset = [self expectationWithDescription:@"testCreateDataset"];
    __block QCloudCreateDatasetResponse * beforeResult = nil;
    QCloudCreateDatasetRequest * requestCreateDataset = [QCloudCreateDatasetRequest new];
    requestCreateDataset.regionName = @"ap-beijing";
    requestCreateDataset.input = [QCloudCreateDataset new];
    // 数据集名称，同一个账户下唯一。命名规则如下： - 长度为1~128字符 - 只能包含英文字母，数字，短划线（-）和下划线（） - 必须以英文字母和下划线（）开头;是否必传：是
    requestCreateDataset.input.DatasetName = @"datasetnametest10";
    // 数据集描述信息。长度为1~256个英文或中文字符，默认值为空。;是否必传：否
    requestCreateDataset.input.Description = @"数据集描述";

    [requestCreateDataset setFinishBlock:^(QCloudCreateDatasetResponse * outputObject, NSError *error) {
        XCTAssertNil(error);
        beforeResult = outputObject;
        [expectationCreateDataset fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] CreateDataset:requestCreateDataset];
    [self waitForExpectationsWithTimeout:100 handler:nil];

    // 查询数据集
    XCTestExpectation* expectationDescribeDataset = [self expectationWithDescription:@"testDescribeDataset"];
    __block QCloudDescribeDatasetResponse * requestResult = nil;
    QCloudDescribeDatasetRequest * requestDescribeDataset = [QCloudDescribeDatasetRequest new];
    requestDescribeDataset.regionName = @"ap-beijing";
    // 数据集名称，同一个账户下唯一。;是否必传：true；
    requestDescribeDataset.datasetname =  @"datasetnametest10";
    requestDescribeDataset.statistics = false;

    [requestDescribeDataset setFinishBlock:^(QCloudDescribeDatasetResponse * outputObject, NSError *error) {
        XCTAssertNil(error);
        requestResult = outputObject;
        [expectationDescribeDataset fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] DescribeDataset:requestDescribeDataset];
    [self waitForExpectationsWithTimeout:100 handler:nil];

    // 删除数据集
    XCTestExpectation* expectationDeleteDataset = [self expectationWithDescription:@"testDeleteDataset"];
    __block QCloudDeleteDatasetResponse * afterResult = nil;
    QCloudDeleteDatasetRequest * requestDeleteDataset = [QCloudDeleteDatasetRequest new];
    requestDeleteDataset.regionName = @"ap-beijing";
    requestDeleteDataset.input = [QCloudDeleteDataset new];
    // 数据集名称，同一个账户下唯一。;是否必传：是
    requestDeleteDataset.input.DatasetName = @"datasetnametest10";

    [requestDeleteDataset setFinishBlock:^(QCloudDeleteDatasetResponse * outputObject, NSError *error) {
        XCTAssertNil(error);
        afterResult = outputObject;
        [expectationDeleteDataset fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] DeleteDataset:requestDeleteDataset];
    [self waitForExpectationsWithTimeout:100 handler:nil];

}

// 测试查询数据集与存储桶的绑定关系
-(void)testDescribeDatasetBinding0{
    // 绑定存储桶与数据集
    XCTestExpectation* expectationCreateDatasetBinding = [self expectationWithDescription:@"testCreateDatasetBinding"];
    __block QCloudCreateDatasetBindingResponse * beforeResult = nil;
    QCloudCreateDatasetBindingRequest * requestCreateDatasetBinding = [QCloudCreateDatasetBindingRequest new];
    requestCreateDatasetBinding.regionName = @"ap-beijing";
    requestCreateDatasetBinding.input = [QCloudCreateDatasetBinding new];
    // 数据集名称，同一个账户下唯一。;是否必传：是
    requestCreateDatasetBinding.input.DatasetName = @"notdelete";
    // 资源标识字段，表示需要与数据集绑定的资源，当前仅支持COS存储桶，字段规则：cos://，其中BucketName表示COS存储桶名称，例如：cos://examplebucket-1250000000;是否必传：是
    requestCreateDatasetBinding.input.URI = @"cos://0-c-1253960454";

    [requestCreateDatasetBinding setFinishBlock:^(QCloudCreateDatasetBindingResponse * outputObject, NSError *error) {
        XCTAssertNil(error);
        beforeResult = outputObject;
        [expectationCreateDatasetBinding fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] CreateDatasetBinding:requestCreateDatasetBinding];
    [self waitForExpectationsWithTimeout:100 handler:nil];

    // 查询数据集与存储桶的绑定关系
    XCTestExpectation* expectationDescribeDatasetBinding = [self expectationWithDescription:@"testDescribeDatasetBinding"];
    __block QCloudDescribeDatasetBindingResponse * requestResult = nil;
    QCloudDescribeDatasetBindingRequest * requestDescribeDatasetBinding = [QCloudDescribeDatasetBindingRequest new];
    requestDescribeDatasetBinding.regionName = @"ap-beijing";
    requestDescribeDatasetBinding.datasetname = @"notdelete";
    requestDescribeDatasetBinding.uri = @"cos://0-c-1253960454";
    [requestDescribeDatasetBinding setFinishBlock:^(QCloudDescribeDatasetBindingResponse * outputObject, NSError *error) {
        XCTAssertNil(error);
        requestResult = outputObject;
        [expectationDescribeDatasetBinding fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] DescribeDatasetBinding:requestDescribeDatasetBinding];
    [self waitForExpectationsWithTimeout:100 handler:nil];

    // 解绑存储桶与数据集
    XCTestExpectation* expectationDeleteDatasetBinding = [self expectationWithDescription:@"testDeleteDatasetBinding"];
    __block QCloudDeleteDatasetBindingResponse * afterResult = nil;
    QCloudDeleteDatasetBindingRequest * requestDeleteDatasetBinding = [QCloudDeleteDatasetBindingRequest new];
    requestDeleteDatasetBinding.regionName = @"ap-beijing";
    requestDeleteDatasetBinding.input = [QCloudDeleteDatasetBinding new];
    // 数据集名称，同一个账户下唯一。;是否必传：是
    requestDeleteDatasetBinding.input.DatasetName = @"notdelete";
    // 资源标识字段，表示需要与数据集绑定的资源，当前仅支持COS存储桶，字段规则：cos://，其中BucketName表示COS存储桶名称，例如：cos://examplebucket-1250000000;是否必传：是
    requestDeleteDatasetBinding.input.URI = @"cos://0-c-1253960454";

    [requestDeleteDatasetBinding setFinishBlock:^(QCloudDeleteDatasetBindingResponse * outputObject, NSError *error) {
        XCTAssertNil(error);
        afterResult = outputObject;
        [expectationDeleteDatasetBinding fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] DeleteDatasetBinding:requestDeleteDatasetBinding];
    [self waitForExpectationsWithTimeout:100 handler:nil];

}

// 测试查询绑定关系列表
-(void)testDescribeDatasetBindings0{
    // 绑定存储桶与数据集
    XCTestExpectation* expectationCreateDatasetBinding = [self expectationWithDescription:@"testCreateDatasetBinding"];
    __block QCloudCreateDatasetBindingResponse * beforeResult = nil;
    QCloudCreateDatasetBindingRequest * requestCreateDatasetBinding = [QCloudCreateDatasetBindingRequest new];
    requestCreateDatasetBinding.regionName = @"ap-beijing";
    requestCreateDatasetBinding.input = [QCloudCreateDatasetBinding new];
    // 数据集名称，同一个账户下唯一。;是否必传：是
    requestCreateDatasetBinding.input.DatasetName = @"notdelete";
    // 资源标识字段，表示需要与数据集绑定的资源，当前仅支持COS存储桶，字段规则：cos://，其中BucketName表示COS存储桶名称，例如：cos://examplebucket-1250000000;是否必传：是
    requestCreateDatasetBinding.input.URI = @"cos://0-c-1253960454";

    [requestCreateDatasetBinding setFinishBlock:^(QCloudCreateDatasetBindingResponse * outputObject, NSError *error) {
        XCTAssertNil(error);
        beforeResult = outputObject;
        [expectationCreateDatasetBinding fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] CreateDatasetBinding:requestCreateDatasetBinding];
    [self waitForExpectationsWithTimeout:100 handler:nil];

    // 查询绑定关系列表
    XCTestExpectation* expectationDescribeDatasetBindings = [self expectationWithDescription:@"testDescribeDatasetBindings"];
    __block QCloudDescribeDatasetBindingsResponse * requestResult = nil;
    QCloudDescribeDatasetBindingsRequest * requestDescribeDatasetBindings = [QCloudDescribeDatasetBindingsRequest new];
    requestDescribeDatasetBindings.regionName = @"ap-beijing";
    // 数据集名称，同一个账户下唯一。;是否必传：false；
    requestDescribeDatasetBindings.datasetname =  @"notdelete";
    // 返回绑定关系的最大个数，取值范围为0~200。不设置此参数或者设置为0时，则默认值为100。;是否必传：false；
    requestDescribeDatasetBindings.maxresults =  10;

    [requestDescribeDatasetBindings setFinishBlock:^(QCloudDescribeDatasetBindingsResponse * outputObject, NSError *error) {
        XCTAssertNil(error);
        requestResult = outputObject;
        [expectationDescribeDatasetBindings fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] DescribeDatasetBindings:requestDescribeDatasetBindings];
    [self waitForExpectationsWithTimeout:100 handler:nil];

    // 解绑存储桶与数据集
    XCTestExpectation* expectationDeleteDatasetBinding = [self expectationWithDescription:@"testDeleteDatasetBinding"];
    __block QCloudDeleteDatasetBindingResponse * afterResult = nil;
    QCloudDeleteDatasetBindingRequest * requestDeleteDatasetBinding = [QCloudDeleteDatasetBindingRequest new];
    requestDeleteDatasetBinding.regionName = @"ap-beijing";
    requestDeleteDatasetBinding.input = [QCloudDeleteDatasetBinding new];
    // 数据集名称，同一个账户下唯一。;是否必传：是
    requestDeleteDatasetBinding.input.DatasetName = @"notdelete";
    // 资源标识字段，表示需要与数据集绑定的资源，当前仅支持COS存储桶，字段规则：cos://，其中BucketName表示COS存储桶名称，例如：cos://examplebucket-1250000000;是否必传：是
    requestDeleteDatasetBinding.input.URI = @"cos://0-c-1253960454";

    [requestDeleteDatasetBinding setFinishBlock:^(QCloudDeleteDatasetBindingResponse * outputObject, NSError *error) {
        XCTAssertNil(error);
        afterResult = outputObject;
        [expectationDeleteDatasetBinding fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] DeleteDatasetBinding:requestDeleteDatasetBinding];
    [self waitForExpectationsWithTimeout:100 handler:nil];

}

// 测试列出数据集
-(void)testDescribeDatasets0{
    // 列出数据集
    XCTestExpectation* expectationDescribeDatasets = [self expectationWithDescription:@"testDescribeDatasets"];
    __block QCloudDescribeDatasetsResponse * requestResult = nil;
    QCloudDescribeDatasetsRequest * requestDescribeDatasets = [QCloudDescribeDatasetsRequest new];
    requestDescribeDatasets.regionName = @"ap-beijing";
    // 本次返回数据集的最大个数，取值范围为0~200。不设置此参数或者设置为0时，则默认值为100。;是否必传：false；
    requestDescribeDatasets.maxresults =  10;

    [requestDescribeDatasets setFinishBlock:^(QCloudDescribeDatasetsResponse * outputObject, NSError *error) {
        XCTAssertNil(error);
        requestResult = outputObject;
        [expectationDescribeDatasets fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] DescribeDatasets:requestDescribeDatasets];
    [self waitForExpectationsWithTimeout:100 handler:nil];

}

// 测试查询元数据索引
-(void)testDescribeFileMetaIndex0{
    // 创建元数据索引
    XCTestExpectation* expectationCreateFileMetaIndex = [self expectationWithDescription:@"testCreateFileMetaIndex"];
    __block QCloudCreateFileMetaIndexResponse * beforeResult = nil;
    QCloudCreateFileMetaIndexRequest * requestCreateFileMetaIndex = [QCloudCreateFileMetaIndexRequest new];
    requestCreateFileMetaIndex.regionName = @"ap-beijing";
    requestCreateFileMetaIndex.input = [QCloudCreateFileMetaIndex new];
    // 数据集名称，同一个账户下唯一。;是否必传：是
    requestCreateFileMetaIndex.input.DatasetName = @"datasetnametest9";
    // 用于建立索引的文件信息。;是否必传：是
    requestCreateFileMetaIndex.input.File = [QCloudFile new];
    // 资源标识字段，表示需要建立索引的文件地址，当前仅支持COS上的文件，字段规则：cos:///，其中BucketName表示COS存储桶名称，ObjectKey表示文件完整路径，例如：cos://examplebucket-1250000000/test1/img.jpg。 注意： 1、仅支持本账号内的COS文件 2、不支持HTTP开头的地址;是否必传：是
    requestCreateFileMetaIndex.input.File.URI = @"cos://0-c-1253960454/test";

    [requestCreateFileMetaIndex setFinishBlock:^(QCloudCreateFileMetaIndexResponse * outputObject, NSError *error) {
        XCTAssertNil(error);
        beforeResult = outputObject;
        [expectationCreateFileMetaIndex fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] CreateFileMetaIndex:requestCreateFileMetaIndex];
    [self waitForExpectationsWithTimeout:100 handler:nil];

    // 查询元数据索引
    XCTestExpectation* expectationDescribeFileMetaIndex = [self expectationWithDescription:@"testDescribeFileMetaIndex"];
    __block QCloudDescribeFileMetaIndexResponse * requestResult = nil;
    QCloudDescribeFileMetaIndexRequest * requestDescribeFileMetaIndex = [QCloudDescribeFileMetaIndexRequest new];
    requestDescribeFileMetaIndex.regionName = @"ap-beijing";
    // 数据集名称，同一个账户下唯一。;是否必传：true；
    requestDescribeFileMetaIndex.datasetname =  @"datasetnametest9";
    // 资源标识字段，表示需要建立索引的文件地址，当前仅支持COS上的文件，字段规则：cos:///，其中BucketName表示COS存储桶名称，ObjectKey表示文件完整路径，例如：cos://examplebucket-1250000000/test1/img.jpg。 注意： 1、仅支持本账号内的COS文件 2、不支持HTTP开头的地址 3、需UrlEncode;是否必传：true；
    requestDescribeFileMetaIndex.uri =  @"cos://0-c-1253960454/test";

    [requestDescribeFileMetaIndex setFinishBlock:^(QCloudDescribeFileMetaIndexResponse * outputObject, NSError *error) {
        XCTAssertNil(error);
        requestResult = outputObject;
        [expectationDescribeFileMetaIndex fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] DescribeFileMetaIndex:requestDescribeFileMetaIndex];
    [self waitForExpectationsWithTimeout:100 handler:nil];

}

// 测试更新数据集
-(void)testUpdateDataset0{
    // 创建数据集
    XCTestExpectation* expectationCreateDataset = [self expectationWithDescription:@"testCreateDataset"];
    __block QCloudCreateDatasetResponse * beforeResult = nil;
    QCloudCreateDatasetRequest * requestCreateDataset = [QCloudCreateDatasetRequest new];
    requestCreateDataset.regionName = @"ap-beijing";
    requestCreateDataset.input = [QCloudCreateDataset new];
    // 数据集名称，同一个账户下唯一。命名规则如下： - 长度为1~128字符 - 只能包含英文字母，数字，短划线（-）和下划线（） - 必须以英文字母和下划线（）开头;是否必传：是
    requestCreateDataset.input.DatasetName = @"datasetnametest11";
    // 数据集描述信息。长度为1~256个英文或中文字符，默认值为空。;是否必传：否
    requestCreateDataset.input.Description = @"描述";

    [requestCreateDataset setFinishBlock:^(QCloudCreateDatasetResponse * outputObject, NSError *error) {
        XCTAssertNil(error);
        beforeResult = outputObject;
        [expectationCreateDataset fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] CreateDataset:requestCreateDataset];
    [self waitForExpectationsWithTimeout:100 handler:nil];

    // 更新数据集
    XCTestExpectation* expectationUpdateDataset = [self expectationWithDescription:@"testUpdateDataset"];
    __block QCloudUpdateDatasetResponse * requestResult = nil;
    QCloudUpdateDatasetRequest * requestUpdateDataset = [QCloudUpdateDatasetRequest new];
    requestUpdateDataset.regionName = @"ap-beijing";
    requestUpdateDataset.input = [QCloudUpdateDataset new];
    // 数据集名称，同一个账户下唯一。;是否必传：是
    requestUpdateDataset.input.DatasetName = @"datasetnametest11";
    // 数据集描述信息。长度为1~256个英文或中文字符，默认值为空。;是否必传：否
    requestUpdateDataset.input.Description = @"描述修改";

    [requestUpdateDataset setFinishBlock:^(QCloudUpdateDatasetResponse * outputObject, NSError *error) {
        XCTAssertNil(error);
        requestResult = outputObject;
        [expectationUpdateDataset fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] UpdateDataset:requestUpdateDataset];
    [self waitForExpectationsWithTimeout:100 handler:nil];

    // 删除数据集
    XCTestExpectation* expectationDeleteDataset = [self expectationWithDescription:@"testDeleteDataset"];
    __block QCloudDeleteDatasetResponse * afterResult = nil;
    QCloudDeleteDatasetRequest * requestDeleteDataset = [QCloudDeleteDatasetRequest new];
    requestDeleteDataset.regionName = @"ap-beijing";
    requestDeleteDataset.input = [QCloudDeleteDataset new];
    // 数据集名称，同一个账户下唯一。;是否必传：是
    requestDeleteDataset.input.DatasetName = @"datasetnametest11";

    [requestDeleteDataset setFinishBlock:^(QCloudDeleteDatasetResponse * outputObject, NSError *error) {
        XCTAssertNil(error);
        afterResult = outputObject;
        [expectationDeleteDataset fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] DeleteDataset:requestDeleteDataset];
    [self waitForExpectationsWithTimeout:100 handler:nil];

}

// 测试更新元数据索引
-(void)testUpdateFileMetaIndex0{
    // 创建元数据索引
    XCTestExpectation* expectationCreateFileMetaIndex = [self expectationWithDescription:@"testCreateFileMetaIndex"];
    __block QCloudCreateFileMetaIndexResponse * beforeResult = nil;
    QCloudCreateFileMetaIndexRequest * requestCreateFileMetaIndex = [QCloudCreateFileMetaIndexRequest new];
    requestCreateFileMetaIndex.regionName = @"ap-beijing";
    requestCreateFileMetaIndex.input = [QCloudCreateFileMetaIndex new];
    // 数据集名称，同一个账户下唯一。;是否必传：是
    requestCreateFileMetaIndex.input.DatasetName = @"datasetnametest9";
    // 用于建立索引的文件信息。;是否必传：是
    requestCreateFileMetaIndex.input.File = [QCloudFile new];
    // 资源标识字段，表示需要建立索引的文件地址，当前仅支持COS上的文件，字段规则：cos:///，其中BucketName表示COS存储桶名称，ObjectKey表示文件完整路径，例如：cos://examplebucket-1250000000/test1/img.jpg。 注意： 1、仅支持本账号内的COS文件 2、不支持HTTP开头的地址;是否必传：是
    requestCreateFileMetaIndex.input.File.URI = @"cos://0-a-1253960454/0000000/ProxyDroid_3.2.0_APKPure.apk";

    [requestCreateFileMetaIndex setFinishBlock:^(QCloudCreateFileMetaIndexResponse * outputObject, NSError *error) {
        XCTAssertNil(error);
        beforeResult = outputObject;
        [expectationCreateFileMetaIndex fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] CreateFileMetaIndex:requestCreateFileMetaIndex];
    [self waitForExpectationsWithTimeout:100 handler:nil];

    // 延迟2秒
    [NSThread sleepForTimeInterval:2];
    
    // 更新元数据索引
    XCTestExpectation* expectationUpdateFileMetaIndex = [self expectationWithDescription:@"testUpdateFileMetaIndex"];
    __block QCloudUpdateFileMetaIndexResponse * requestResult = nil;
    QCloudUpdateFileMetaIndexRequest * requestUpdateFileMetaIndex = [QCloudUpdateFileMetaIndexRequest new];
    requestUpdateFileMetaIndex.regionName = @"ap-beijing";
    requestUpdateFileMetaIndex.input = [QCloudUpdateFileMetaIndex new];
    // 数据集名称，同一个账户下唯一。;是否必传：是
    requestUpdateFileMetaIndex.input.DatasetName = @"datasetnametest9";
    // 用于建立索引的文件信息。;是否必传：是
    requestUpdateFileMetaIndex.input.File = [QCloudUpdateMetaFile new];
    // 资源标识字段，表示需要建立索引的文件地址，当前仅支持COS上的文件，字段规则：cos:///，其中BucketName表示COS存储桶名称，ObjectKey表示文件完整路径，例如：cos://examplebucket-1250000000/test1/img.jpg。 注意： 1、仅支持本账号内的COS文件 2、不支持HTTP开头的地址;是否必传：是
    requestUpdateFileMetaIndex.input.File.URI = @"cos://0-a-1253960454/0000000/ProxyDroid_3.2.0_APKPure.apk";

    [requestUpdateFileMetaIndex setFinishBlock:^(QCloudUpdateFileMetaIndexResponse * outputObject, NSError *error) {
        XCTAssertNil(error);
        requestResult = outputObject;
        [expectationUpdateFileMetaIndex fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] UpdateFileMetaIndex:requestUpdateFileMetaIndex];
    [self waitForExpectationsWithTimeout:100 handler:nil];

    // 延迟2秒
    [NSThread sleepForTimeInterval:2];
}



@end
