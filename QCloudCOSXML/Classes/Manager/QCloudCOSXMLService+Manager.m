//
//  QCloudCOSXMLService+Manager.m
//  QCloudCOSXML
//
//  Created by erichmzhang(张恒铭) on 07/12/2017.
//

#import "QCloudCOSXMLService+Manager.h"
#import "QCloudAppendObjectRequest.h"
#import "QCloudGetObjectACLRequest.h"
#import "QCloudPutObjectRequest.h"
#import "QCloudPutObjectACLRequest.h"
#import "QCloudDeleteObjectRequest.h"
#import "QCloudDeleteMultipleObjectRequest.h"
#import "QCloudOptionsObjectRequest.h"

#import "QCloudPutBucketRequest.h"
#import "QCloudGetBucketRequest.h"
#import "QCloudGetBucketACLRequest.h"
#import "QCloudGetBucketCORSRequest.h"
#import "QCloudGetBucketLocationRequest.h"
#import "QCloudPutBucketACLRequest.h"
#import "QCloudPutBucketCORSRequest.h"
#import "QCloudDeleteBucketCORSRequest.h"
#import "QCloudHeadBucketRequest.h"
#import "QCloudListBucketMultipartUploadsRequest.h"
#import "QCloudPutBucketVersioningRequest.h"
#import "QCloudPutBucketReplicationRequest.h"
#import "QCloudGetBucketReplicationRequest.h"
#import "QCloudDeleteBucketReplicationRequest.h"
#import "QCloudGetServiceRequest.h"
#import "QCloudGetBucketLifecycleRequest.h"
#import "QCloudGetBucketVersioningRequest.h"
#import "QCloudDeleteBucketRequest.h"
#import "QCloudPutBucketLifecycleRequest.h"
#import "QCloudDeleteBucketLifeCycleRequest.h"


#import "QCloudDeleteObjectRequest.h"

@implementation QCloudCOSXMLService (Manager)
- (void) AppendObject:(QCloudAppendObjectRequest*)request
{
    [super performRequest:request];
}
- (void) GetObjectACL:(QCloudGetObjectACLRequest*)request
{
    [super performRequest:request];
}

- (void) PutObjectACL:(QCloudPutObjectACLRequest*)request
{
    [super performRequest:request];
}
- (void) DeleteObject:(QCloudDeleteObjectRequest*)request
{
    [super performRequest:request];
}
- (void) DeleteMultipleObject:(QCloudDeleteMultipleObjectRequest*)request
{
    [super performRequest:request];
}

- (void) OptionsObject:(QCloudOptionsObjectRequest*)request
{
    [super performRequest:request];
}


- (void) PutBucket:(QCloudPutBucketRequest*)request
{
    [super performRequest:request];
}
- (void) GetBucket:(QCloudGetBucketRequest*)request
{
    [super performRequest:request];
}
- (void) GetBucketACL:(QCloudGetBucketACLRequest*)request
{
    [super performRequest:request];
}
- (void) GetBucketCORS:(QCloudGetBucketCORSRequest*)request
{
    [super performRequest:request];
}
- (void) GetBucketLocation:(QCloudGetBucketLocationRequest*)request
{
    [super performRequest:request];
}
- (void) GetBucketLifecycle:(QCloudGetBucketLifecycleRequest*)request
{
    [super performRequest:request];
}

- (void) PutBucketACL:(QCloudPutBucketACLRequest*)request
{
    [super performRequest:request];
}
- (void) PutBucketCORS:(QCloudPutBucketCORSRequest*)request
{
    [super performRequest:request];
}
- (void) PutBucketLifecycle:(QCloudPutBucketLifecycleRequest*)request
{
    [super performRequest:request];
}

- (void) DeleteBucketCORS:(QCloudDeleteBucketCORSRequest*)request
{
    [super performRequest:request];
}
- (void) DeleteBucketLifeCycle:(QCloudDeleteBucketLifeCycleRequest*)request
{
    [super performRequest:request];
}

- (void) DeleteBucket:(QCloudDeleteBucketRequest*)request
{
    [super performRequest:request];
}
- (void) HeadBucket:(QCloudHeadBucketRequest*)request
{
    [super performRequest:request];
}
- (void) ListBucketMultipartUploads:(QCloudListBucketMultipartUploadsRequest*)request
{
    [super performRequest:request];
}
- (void) PutBucketVersioning:(QCloudPutBucketVersioningRequest*)request {
    [super performRequest:request];
}
- (void) GetBucketVersioning:(QCloudGetBucketVersioningRequest*)request {
    [super performRequest:request];
}
- (void) PutBucketRelication:(QCloudPutBucketReplicationRequest*)request {
    [super performRequest:request];
}
- (void) GetBucketReplication:(QCloudGetBucketReplicationRequest*)request {
    [super performRequest:request];
}
- (void) DeleteBucketReplication:(QCloudDeleteBucketReplicationRequest*)request {
    [super performRequest:request];
}
- (void) GetService:(QCloudGetServiceRequest*)request {
    [super performRequest:request];
}

@end
