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
    [super performRequest:request ];
}

- (void) GetObject:(QCloudGetObjectRequest*)request
{
    [super performRequest:request ];
}

- (void) InitiateMultipartUpload:(QCloudInitiateMultipartUploadRequest*)request
{
    [super performRequest:request ];
}

- (void) UploadPart:(QCloudUploadPartRequest*)request
{
    [super performRequest:request ];
}

- (void) CompleteMultipartUpload:(QCloudCompleteMultipartUploadRequest*)request
{
    [super performRequest:request ];
}

- (void) AbortMultipfartUpload:(QCloudAbortMultipfartUploadRequest*)request
{
    [super performRequest:request ];
}

- (void) ListMultipart:(QCloudListMultipartRequest*)request
{
    [super performRequest:request ];
}
- (void) HeadObject:(QCloudHeadObjectRequest*)request
{
    [super performRequest:request ];
}
- (void) PutObjectCopy:(QCloudPutObjectCopyRequest*)request
{
    [super performRequest:request ];
}
- (void) UploadPartCopy:(QCloudUploadPartCopyRequest*)request {
    [super performRequest:request ];
}
@end
