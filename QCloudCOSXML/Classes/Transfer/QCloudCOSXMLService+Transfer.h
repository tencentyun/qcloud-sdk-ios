//
//  QCloudCOSXMLService+Transfer.h
//  QCloudCOSXML
//
//  Created by erichmzhang(张恒铭) on 07/12/2017.
//

#import <Foundation/Foundation.h>
#import "QCLoudCOSXMLService.h"
@class QCloudPutObjectRequest;
@class QCloudGetObjectRequest;
@class QCloudInitiateMultipartUploadRequest;
@class QCloudUploadPartRequest;
@class QCloudListMultipartRequest;
@class QCloudCompleteMultipartUploadRequest;
@class QCloudAbortMultipfartUploadRequest;
@class QCloudHeadObjectRequest;
@class QCloudPutObjectCopyRequest;
@class QCloudUploadPartCopyRequest;
@interface QCloudCOSXMLService (Transfer)
- (void) PutObject:(QCloudPutObjectRequest*)request;
- (void) GetObject:(QCloudGetObjectRequest*)request;
- (void) InitiateMultipartUpload:(QCloudInitiateMultipartUploadRequest*)request;
- (void) UploadPart:(QCloudUploadPartRequest*)request;
- (void) ListMultipart:(QCloudListMultipartRequest*)request;
- (void) CompleteMultipartUpload:(QCloudCompleteMultipartUploadRequest*)request;
- (void) AbortMultipfartUpload:(QCloudAbortMultipfartUploadRequest*)request;
- (void) HeadObject:(QCloudHeadObjectRequest*)request;
- (void) PutObjectCopy:(QCloudPutObjectCopyRequest*)request;
- (void) UploadPartCopy:(QCloudUploadPartCopyRequest*)request;

@end
