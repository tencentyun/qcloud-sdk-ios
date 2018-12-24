//
//  QCloudCOSXMLService+Transfer.m
//  QCloudCOSXML
//
//  Created by erichmzhang(张恒铭) on 07/12/2017.
//

#import "QCloudCOSXMLService+Transfer.h"
#import "QCloudPutObjectRequest.h"
#import "QCloudGetObjectRequest.h"
#import "QCloudInitiateMultipartUploadRequest.h"
#import "QCloudUploadPartRequest.h"
#import "QCloudCompleteMultipartUploadRequest.h"
#import "QCloudAbortMultipfartUploadRequest.h"
#import "QCloudListMultipartRequest.h"
#import "QCloudHeadObjectRequest.h"
#import "QCloudUploadPartCopyRequest.h"
#import "QCloudPutObjectCopyRequest.h"

@implementation QCloudCOSXMLService (Transfer)

- (void) PutObject:(QCloudPutObjectRequest*)request
{
    [super performRequest:request isHaveBody:YES];
}

- (void) GetObject:(QCloudGetObjectRequest*)request
{
    [super performRequest:request isHaveBody:NO];
}

- (void) InitiateMultipartUpload:(QCloudInitiateMultipartUploadRequest*)request
{
    [super performRequest:request isHaveBody:NO];
}

- (void) UploadPart:(QCloudUploadPartRequest*)request
{
    [super performRequest:request isHaveBody:YES];
}

- (void) CompleteMultipartUpload:(QCloudCompleteMultipartUploadRequest*)request
{
    [super performRequest:request isHaveBody:NO];
}

- (void) AbortMultipfartUpload:(QCloudAbortMultipfartUploadRequest*)request
{
    [super performRequest:request isHaveBody:NO];
}

- (void) ListMultipart:(QCloudListMultipartRequest*)request
{
    [super performRequest:request isHaveBody:NO];
}
- (void) HeadObject:(QCloudHeadObjectRequest*)request
{
    [super performRequest:request isHaveBody:NO];
}
- (void) PutObjectCopy:(QCloudPutObjectCopyRequest*)request
{
    [super performRequest:request isHaveBody:NO];
}
- (void) UploadPartCopy:(QCloudUploadPartCopyRequest*)request {
    [super performRequest:request isHaveBody:NO];
}
@end
