//
//  QCloudCOSXMLDownloadObjectRequest.m
//  Pods-QCloudCOSXMLDemo
//
//  Created by karisli(李雪) on 2018/8/23.
//

#import "QCloudCOSXMLDownloadObjectRequest.h"
#import "QCloudGetObjectRequest.h"
#import "QCloudGetObjectRequest+Custom.h"
#import "QCloudCOSTransferMangerService.h"
#import "QCloudCOSXMLService+Transfer.h"
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
@implementation QCloudCOSXMLDownloadObjectRequest
#pragma clang diagnostic pop
- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    _customHeaders = [NSMutableDictionary dictionary];

    return self;
}
-(void)fakeStart{
    [self startGetObject];
}
-(void)startGetObject{
    QCloudGetObjectRequest *request = [QCloudGetObjectRequest new];
    request.customHeaders = [self.customHeaders copy];
    request.downloadingURL = self.downloadingURL;
    request.localCacheDownloadOffset = self.localCacheDownloadOffset;
    request.regionName = self.regionName;
    request.enableMD5Verification = self.enableMD5Verification;
    [request setFinishBlock:self.finishBlock];
    [request setDownProcessBlock:self.downProcessBlock];
    request.responseContentType = self.responseContentType;
    request.responseContentLanguage = self.responseContentLanguage;
    request.responseContentExpires = self.responseContentExpires;
    request.responseCacheControl = self.responseCacheControl;
    request.responseContentDisposition = self.responseContentDisposition;
    request.responseContentEncoding = self.responseContentEncoding;
    request.range = self.range;
    request.ifModifiedSince = self.ifModifiedSince;
    request.ifUnmodifiedModifiedSince = self.ifUnmodifiedModifiedSince;
    request.ifMatch = self.ifMatch;
    request.ifNoneMatch = self.ifNoneMatch;
    request.object = self.object;
    request.bucket = self.bucket;
    [self.transferManager.cosService GetObject:request];
}
-(void)setCOSServerSideEncyption{
    self.customHeaders[@"x-cos-server-side-encryption"] = @"AES256";
}

-(void)setCOSServerSideEncyptionWithCustomerKey:(NSString *)customerKey{
    NSData *data = [customerKey dataUsingEncoding:NSUTF8StringEncoding];
    NSString* excryptAES256Key = [data base64EncodedStringWithOptions:0]; // base64格式的字符串
    NSString *base64md5key = QCloudEncrytNSDataMD5Base64(data);
    self.customHeaders[@"x-cos-server-side-encryption-customer-algorithm"] = @"AES256";
    self.customHeaders[@"x-cos-server-side-encryption-customer-key"] = excryptAES256Key;
    self.customHeaders[@"x-cos-server-side-encryption-customer-key-MD5"] = base64md5key;
}
@end
