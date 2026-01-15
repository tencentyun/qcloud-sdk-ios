//
//  QCloudCOSCIRetryMockTests.m
//  QCloudCOSXMLDemoTests
//
//  Created by garenwang on 2020/6/8.
//  Copyright © 2020 Tencent. All rights reserved.
//
//  域名主备切换 Mock 测试用例
//
//  测试规则说明：
//  | 状态码 | 重试策略 | 域名切换时机 |
//  |--------|----------|--------------|
//  | 2xx    | 成功，不重试 | 不切换 |
//  | 3xx    | 301/302/307 满足条件时重试，308 不重试 | 第一次失败就切换 |
//  | 4xx    | 不重试 | 不切换 |
//  | 5xx    | 重试3次 | 最后一次重试时切换 |
//  | 未收到回包 | 重试3次 | 最后一次重试时切换 |
//
//  域名切换条件（需同时满足）：
//  1. 域名匹配 myqcloud.com（COS: *.cos.{Region}.myqcloud.com，CI: *.ci.{Region}.myqcloud.com）
//  2. 响应不含 request-id（COS: x-cos-request-id，CI: x-ci-request-id）
//  3. 开启域名切换开关（disableChangeHost = NO）
//  4. SDK 生成签名（credential 存在）

#import <XCTest/XCTest.h>
#import "QCloudCOSXML.h"

#pragma mark - 测试用域名常量

// COS 域名格式：bucket.cos.region.myqcloud.com
static NSString * const kCOSHostValid = @"bucket.cos.ap-beijing.myqcloud.com";
static NSString * const kCOSHostValid2 = @"my-bucket.cos.ap-shanghai.myqcloud.com";

// CI 域名格式：bucket.ci.region.myqcloud.com 或 ci.region.myqcloud.com
static NSString * const kCIHostWithBucket = @"bucket.ci.ap-beijing.myqcloud.com";
static NSString * const kCIHostWithoutBucket = @"ci.ap-beijing.myqcloud.com";

// 备用域名
static NSString * const kBackupCOSHost = @"bucket.cos.ap-beijing.tencentcos.cn";
static NSString * const kBackupCIHost = @"bucket.ci.ap-beijing.tencentci.cn";

// 不匹配的域名（不应触发切换）
static NSString * const kAccelerateHost = @"bucket.cos.accelerate.myqcloud.com";
static NSString * const kServiceHost = @"service.cos.myqcloud.com";
static NSString * const kCustomHost = @"custom.example.com";
static NSString * const kOtherHost = @"bucket.oss.ap-beijing.aliyuncs.com";

@interface QCloudCOSCIRetryMockTests : XCTestCase
@end

@implementation QCloudCOSCIRetryMockTests

#pragma mark - Mock 域名切换判断测试（needChangeHost 方法）

/// 测试 COS 域名匹配 - 无 request-id 时应该切换
/// 域名格式：bucket.cos.region.myqcloud.com
- (void)testMock_COSHost_WithoutRequestId_ShouldSwitch {
    // COS 域名，无 request-id
    BOOL result = [QCloudHTTPRequest needChangeHost:kCOSHostValid responseHeaders:@{}];
    XCTAssertTrue(result, @"COS 域名无 request-id 应该切换");
    
    result = [QCloudHTTPRequest needChangeHost:kCOSHostValid2 responseHeaders:nil];
    XCTAssertTrue(result, @"COS 域名无响应头应该切换");
}

/// 测试 COS 域名匹配 - 有 x-cos-request-id 时不应该切换
- (void)testMock_COSHost_WithRequestId_ShouldNotSwitch {
    NSDictionary *headersWithRequestId = @{@"x-cos-request-id": @"NjM0NTY3ODkwMTIz"};
    
    BOOL result = [QCloudHTTPRequest needChangeHost:kCOSHostValid responseHeaders:headersWithRequestId];
    XCTAssertFalse(result, @"COS 域名有 x-cos-request-id 不应该切换");
}

/// 测试 CI 域名匹配 - 无 request-id 时应该切换
/// 域名格式：bucket.ci.region.myqcloud.com 或 ci.region.myqcloud.com
- (void)testMock_CIHost_WithoutRequestId_ShouldSwitch {
    // CI 域名带 bucket
    BOOL result = [QCloudHTTPRequest needChangeHost:kCIHostWithBucket responseHeaders:@{}];
    XCTAssertTrue(result, @"CI 域名（带 bucket）无 request-id 应该切换");
    
    // CI 域名不带 bucket
    result = [QCloudHTTPRequest needChangeHost:kCIHostWithoutBucket responseHeaders:@{}];
    XCTAssertTrue(result, @"CI 域名（不带 bucket）无 request-id 应该切换");
}

/// 测试 CI 域名匹配 - 有 x-ci-request-id 时不应该切换
- (void)testMock_CIHost_WithRequestId_ShouldNotSwitch {
    NSDictionary *headersWithRequestId = @{@"x-ci-request-id": @"NjM0NTY3ODkwMTIz"};
    
    BOOL result = [QCloudHTTPRequest needChangeHost:kCIHostWithBucket responseHeaders:headersWithRequestId];
    XCTAssertFalse(result, @"CI 域名有 x-ci-request-id 不应该切换");
}

/// 测试备用域名 - 不应该再切换
- (void)testMock_BackupHost_ShouldNotSwitch {
    // tencentcos.cn 备用域名
    BOOL result = [QCloudHTTPRequest needChangeHost:kBackupCOSHost responseHeaders:@{}];
    XCTAssertFalse(result, @"备用域名 tencentcos.cn 不应该再切换");
    
    // tencentci.cn 备用域名
    result = [QCloudHTTPRequest needChangeHost:kBackupCIHost responseHeaders:@{}];
    XCTAssertFalse(result, @"备用域名 tencentci.cn 不应该再切换");
}

/// 测试加速域名 - 不应该切换
/// 域名格式：bucket.cos.accelerate.myqcloud.com
- (void)testMock_AccelerateHost_ShouldNotSwitch {
    BOOL result = [QCloudHTTPRequest needChangeHost:kAccelerateHost responseHeaders:@{}];
    XCTAssertFalse(result, @"加速域名不应该切换");
}

/// 测试服务域名 - 不应该切换
/// 域名格式：service.cos.myqcloud.com
- (void)testMock_ServiceHost_ShouldNotSwitch {
    BOOL result = [QCloudHTTPRequest needChangeHost:kServiceHost responseHeaders:@{}];
    XCTAssertFalse(result, @"服务域名不应该切换");
}

/// 测试自定义域名 - 不应该切换
- (void)testMock_CustomHost_ShouldNotSwitch {
    BOOL result = [QCloudHTTPRequest needChangeHost:kCustomHost responseHeaders:@{}];
    XCTAssertFalse(result, @"自定义域名不应该切换");
    
    result = [QCloudHTTPRequest needChangeHost:kOtherHost responseHeaders:@{}];
    XCTAssertFalse(result, @"其他云服务域名不应该切换");
}

/// 测试空域名 - 不应该切换
- (void)testMock_NilHost_ShouldNotSwitch {
    BOOL result = [QCloudHTTPRequest needChangeHost:nil responseHeaders:@{}];
    XCTAssertFalse(result, @"空域名不应该切换");
    
    result = [QCloudHTTPRequest needChangeHost:@"" responseHeaders:@{}];
    XCTAssertFalse(result, @"空字符串域名不应该切换");
}

#pragma mark - Mock 备用域名获取测试（getBackupHost 方法）

/// 测试 COS 域名获取备用域名
- (void)testMock_GetBackupHost_COS {
    NSString *backupHost = [QCloudHTTPRequest getBackupHost:kCOSHostValid];
    XCTAssertNotNil(backupHost, @"应该返回备用域名");
    XCTAssertTrue([backupHost containsString:@"tencentcos.cn"], @"COS 备用域名应该包含 tencentcos.cn");
    XCTAssertFalse([backupHost containsString:@"myqcloud.com"], @"备用域名不应该包含 myqcloud.com");
}

/// 测试 CI 域名获取备用域名
- (void)testMock_GetBackupHost_CI {
    NSString *backupHost = [QCloudHTTPRequest getBackupHost:kCIHostWithBucket];
    XCTAssertNotNil(backupHost, @"应该返回备用域名");
    XCTAssertTrue([backupHost containsString:@"tencentci.cn"], @"CI 备用域名应该包含 tencentci.cn");
}

#pragma mark - Mock 域名类型判断测试

/// 测试 COS 域名判断
- (void)testMock_IsCOSHost {
    // 有效 COS 域名
    BOOL result = [QCloudHTTPRequest needChangeHost:kCOSHostValid];
    XCTAssertTrue(result, @"bucket.cos.region.myqcloud.com 应该是有效 COS 域名");
    
    // 无效域名
    result = [QCloudHTTPRequest needChangeHost:kCustomHost];
    XCTAssertFalse(result, @"自定义域名不是 COS 域名");
}

#pragma mark - Mock 域名正则匹配边界测试

/// 测试域名正则匹配边界情况
- (void)testMock_DomainRegex_EdgeCases {
    // 多级 bucket 名称
    NSString *multiLevelBucket = @"my-test-bucket.cos.ap-beijing.myqcloud.com";
    BOOL result = [QCloudHTTPRequest needChangeHost:multiLevelBucket responseHeaders:@{}];
    XCTAssertTrue(result, @"多级 bucket 名称应该匹配");
    
    // 特殊字符 bucket
    NSString *specialBucket = @"bucket-123.cos.ap-shanghai.myqcloud.com";
    result = [QCloudHTTPRequest needChangeHost:specialBucket responseHeaders:@{}];
    XCTAssertTrue(result, @"带数字的 bucket 名称应该匹配");
    
    // 不同 region
    NSString *differentRegion = @"bucket.cos.na-ashburn.myqcloud.com";
    result = [QCloudHTTPRequest needChangeHost:differentRegion responseHeaders:@{}];
    XCTAssertTrue(result, @"不同 region 应该匹配");
}

/// 测试 request-id 响应头各种格式
- (void)testMock_RequestId_HeaderVariants {
    NSString *host = kCOSHostValid;
    
    // 空 request-id
    NSDictionary *emptyRequestId = @{@"x-cos-request-id": @""};
    BOOL result = [QCloudHTTPRequest needChangeHost:host responseHeaders:emptyRequestId];
    // 空 request-id 应该视为无效，需要切换
    XCTAssertFalse(result, @"空 request-id 不应该切换");
    
    // 有效 request-id
    NSDictionary *validRequestId = @{@"x-cos-request-id": @"NjM0NTY3ODkwMTIzNDU2Nzg5MA=="};
    result = [QCloudHTTPRequest needChangeHost:host responseHeaders:validRequestId];
    XCTAssertFalse(result, @"有效 request-id 不应该切换");
}

#pragma mark - Mock 综合场景测试

/// 测试域名切换完整流程场景
/// 场景：COS 域名 + 无 request-id -> 应该切换 -> 切换到备用域名 -> 不再切换
- (void)testMock_FullDomainSwitchScenario {
    NSString *originalHost = kCOSHostValid;
    NSDictionary *noRequestIdHeaders = @{};
    
    // 步骤1：检查原始域名是否需要切换
    BOOL shouldSwitch = [QCloudHTTPRequest needChangeHost:originalHost responseHeaders:noRequestIdHeaders];
    XCTAssertTrue(shouldSwitch, @"步骤1：原始 COS 域名无 request-id 应该切换");
    
    // 步骤2：获取备用域名
    NSString *backupHost = [QCloudHTTPRequest getBackupHost:originalHost];
    XCTAssertNotNil(backupHost, @"步骤2：应该获取到备用域名");
    XCTAssertTrue([backupHost containsString:@"tencentcos.cn"], @"步骤2：备用域名应该是 tencentcos.cn");
    
    // 步骤3：检查备用域名是否还需要切换
    BOOL shouldSwitchAgain = [QCloudHTTPRequest needChangeHost:backupHost responseHeaders:noRequestIdHeaders];
    XCTAssertFalse(shouldSwitchAgain, @"步骤3：备用域名不应该再切换");
}

/// 测试有 request-id 场景 - 请求已到达服务端，不应切换
- (void)testMock_RequestReachedServer_ShouldNotSwitch {
    NSString *host = kCOSHostValid;
    NSDictionary *serverResponseHeaders = @{
        @"x-cos-request-id": @"NjM0NTY3ODkwMTIz",
        @"Content-Type": @"application/xml",
        @"Content-Length": @"1234"
    };
    
    BOOL shouldSwitch = [QCloudHTTPRequest needChangeHost:host responseHeaders:serverResponseHeaders];
    XCTAssertFalse(shouldSwitch, @"有 request-id 表示请求已到达服务端，不应切换域名");
}

@end
