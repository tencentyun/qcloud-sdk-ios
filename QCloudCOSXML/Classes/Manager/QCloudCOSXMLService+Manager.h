//
//  QCloudCOSXMLService+Manager.h
//  QCloudCOSXML
//
//  Created by erichmzhang(张恒铭) on 07/12/2017.
//

#import <QCloudCOSXML/QCloudCOSXML.h>
@class QCloudAppendObjectRequest;
@class QCloudGetObjectACLRequest;
@class QCloudPutObjectACLRequest;
@class QCloudDeleteObjectRequest;
@class QCloudDeleteMultipleObjectRequest;
@class QCloudHeadObjectRequest;
@class QCloudOptionsObjectRequest;

@class QCloudAbortMultipfartUploadRequest;
@class QCloudGetBucketRequest;
@class QCloudGetBucketACLRequest;
@class QCloudGetBucketCORSRequest;
@class QCloudGetBucketLocationRequest;
@class QCloudGetBucketLifecycleRequest;
@class QCloudPutBucketRequest;
@class QCloudPutBucketACLRequest;
@class QCloudPutBucketCORSRequest;
@class QCloudPutBucketLifecycleRequest;
@class QCloudDeleteBucketRequest;
@class QCloudDeleteBucketCORSRequest;
@class QCloudDeleteBucketLifeCycleRequest;
@class QCloudHeadBucketRequest;
@class QCloudListBucketMultipartUploadsRequest;
@class QCloudPutObjectCopyRequest;
@class QCloudDeleteBucketRequest;
@class QCloudPutBucketVersioningRequest;
@class QCloudGetBucketVersioningRequest;
@class QCloudPutBucketReplicationRequest;
@class QCloudGetBucketReplicationRequest;
@class QCloudDeleteBucketReplicationRequest;
@class QCloudGetServiceRequest;
@class QCloudUploadPartCopyRequest;
@class QCloudPostObjectRestoreRequest;
@class QCloudListObjectVersionsRequest;
@class QCloudGetPresignedURLRequest;

@interface QCloudCOSXMLService (Manager)

- (void) AppendObject:(QCloudAppendObjectRequest*)request;
- (void) GetObjectACL:(QCloudGetObjectACLRequest*)request;
- (void) PutObjectACL:(QCloudPutObjectACLRequest*)request;
- (void) DeleteObject:(QCloudDeleteObjectRequest*)request;
- (void) DeleteMultipleObject:(QCloudDeleteMultipleObjectRequest*)request;
- (void) OptionsObject:(QCloudOptionsObjectRequest*)request;

- (void) CompleteMultipartUpload:(QCloudCompleteMultipartUploadRequest*)request;
- (void) AbortMultipfartUpload:(QCloudAbortMultipfartUploadRequest*)request;
- (void) PutBucket:(QCloudPutBucketRequest*)request;
- (void) GetBucket:(QCloudGetBucketRequest*)request;
- (void) GetBucketACL:(QCloudGetBucketACLRequest*)request;
- (void) GetBucketCORS:(QCloudGetBucketCORSRequest*)request;
- (void) GetBucketLocation:(QCloudGetBucketLocationRequest*)request;
- (void) GetBucketLifecycle:(QCloudGetBucketLifecycleRequest*)request;
- (void) PutBucketACL:(QCloudPutBucketACLRequest*)request;
- (void) PutBucketCORS:(QCloudPutBucketCORSRequest*)request;
- (void) PutBucketLifecycle:(QCloudPutBucketLifecycleRequest*)request;
- (void) DeleteBucketCORS:(QCloudDeleteBucketCORSRequest*)request;
- (void) DeleteBucketLifeCycle:(QCloudDeleteBucketLifeCycleRequest*)request;
- (void) DeleteBucket:(QCloudDeleteBucketRequest*)request;
- (void) HeadBucket:(QCloudHeadBucketRequest*)request;
- (void) ListBucketMultipartUploads:(QCloudListBucketMultipartUploadsRequest*)request;
- (void) PutBucketVersioning:(QCloudPutBucketVersioningRequest*)request;
- (void) GetBucketVersioning:(QCloudGetBucketVersioningRequest*)request;
- (void) PutBucketRelication:(QCloudPutBucketReplicationRequest*)request;
- (void) GetBucketReplication:(QCloudGetBucketReplicationRequest*)request;
- (void) DeleteBucketReplication:(QCloudDeleteBucketReplicationRequest*)request;
- (void) GetService:(QCloudGetServiceRequest*)request;
- (void) PostObjectRestore:(QCloudPostObjectRestoreRequest*)request;
- (void) ListObjectVersions:(QCloudListObjectVersionsRequest*)request;
- (void) getPresignedURL:(QCloudGetPresignedURLRequest*)request;
@end
