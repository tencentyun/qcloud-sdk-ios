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
#import "QCloudPostObjectRestoreRequest.h"

#import "QCloudDeleteObjectRequest.h"
#import "QCloudListObjectVersionsRequest.h"
#import "QCloudGetPresignedURLRequest.h"

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
- (void) PostObjectRestore:(QCloudPostObjectRestoreRequest*)request {
    [super performRequest:request];
}
- (void) ListObjectVersions:(QCloudListObjectVersionsRequest *)request {
    [super performRequest:request];
}
- (void) getPresignedURL:(QCloudGetPresignedURLRequest*)request {
    
    request.runOnService = self;
    NSError* error;
    NSURLRequest* urlRequest = [request buildURLRequest:&error];
    if (nil != error) {
        [request onError:error];
        return ;
    }
    __block NSString* requestURLString = urlRequest.URL.absoluteString;
    [self loadCOSXMLAuthorizationForBiz:request urlRequest:urlRequest compelete:^(QCloudSignature *signature, NSError *error) {
        NSString* authorizatioinString = signature.signature;
        if ([requestURLString hasSuffix:@"&"] || [requestURLString hasSuffix:@"?"]) {
            requestURLString = [requestURLString stringByAppendingString:authorizatioinString];
        } else {
            requestURLString = [requestURLString stringByAppendingFormat:@"?%@",authorizatioinString];
        }
        QCloudGetPresignedURLResult* result = [[QCloudGetPresignedURLResult alloc] init];
        result.presienedURL = requestURLString;
        if (request.finishBlock) {
            request.finishBlock(result, nil);
        }
    }];
    
}


- (BOOL)doesBucketExist:(NSString *)bucketName {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block BOOL result = NO;
    QCloudHeadBucketRequest* headBucketRequest = [[QCloudHeadBucketRequest alloc] init];
    headBucketRequest.bucket = bucketName;
    [headBucketRequest setFinishBlock:^(id outputObject, NSError *error) {
        if (nil == error) {
            result = YES;
        } else {
            QCloudLogDebug(@" Head Object Fail!\n%@",error);
        }
        dispatch_semaphore_signal(semaphore);
    }];
    [self HeadBucket:headBucketRequest];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return result;
}


- (BOOL)doesObjectExistWithBucket:(NSString *)bucket object:(NSString *)objectName {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block BOOL result = NO;
    QCloudHeadObjectRequest* headObjectRequest = [[QCloudHeadObjectRequest alloc] init];
    headObjectRequest.bucket = bucket;
    headObjectRequest.object = objectName;
    [headObjectRequest setFinishBlock:^(id outputObject, NSError *error) {
        if (nil == error) {
            result = YES;
        } else {
            QCloudLogDebug(@" Head Object Fail!\n%@",error);
        }
        dispatch_semaphore_signal(semaphore);
    }];
    [self HeadObject:headObjectRequest];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return result;
}


- (void)deleteObjectWithBucket:(NSString *)bucket object:(NSString *)objectName {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    QCloudDeleteObjectRequest* deleteObjectRequest = [QCloudDeleteObjectRequest new];
    deleteObjectRequest.bucket = bucket;
    deleteObjectRequest.object = objectName;
    [deleteObjectRequest setFinishBlock:^(id outputObject, NSError *error) {
        if (nil == error) {
            //
        } else {
            QCloudLogDebug(@"%@",error.description);
        }
        dispatch_semaphore_signal(semaphore);
    }];
    
    [self DeleteObject:deleteObjectRequest];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

- (void)deleteVersionWithBucket:(NSString *)bucket object:(NSString *)object version:(NSString *)versionID {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    QCloudDeleteObjectRequest* deleteObjectRequest = [QCloudDeleteObjectRequest new];
    deleteObjectRequest.bucket = bucket;
    deleteObjectRequest.object = object;
    deleteObjectRequest.versionID = versionID;
    [deleteObjectRequest setFinishBlock:^(id outputObject, NSError *error) {
        if (nil == error) {
            //
        } else {
            QCloudLogDebug(error.description);
        }
        dispatch_semaphore_signal(semaphore);
    }];
    
    [self DeleteObject:deleteObjectRequest];
}

- (void)changeObjectStorageClassWithBucket:(NSString *)bucket object:(NSString *)object storageClass:(QCloudCOSStorageClass)storageClass {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    QCloudCOSXMLCopyObjectRequest* copyObjectRequest =  [[QCloudCOSXMLCopyObjectRequest alloc] init];
    copyObjectRequest.sourceRegion = self.configuration.endpoint.regionName;
    copyObjectRequest.sourceBucket = bucket;
    copyObjectRequest.sourceObject = object;
    copyObjectRequest.bucket = bucket;
    copyObjectRequest.object = object;
    copyObjectRequest.storageClass = storageClass;
    [copyObjectRequest setFinishBlock:^(QCloudCopyObjectResult *result, NSError *error) {
        if (nil == error) {
            //
        } else {
            QCloudLogDebug(error.description);
        }
        dispatch_semaphore_signal(semaphore);
    }];
    [self PutObjectCopy:copyObjectRequest];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

- (void)updateObjectMedaWithBucket:(NSString *)bucket object:(NSString *)object meta:(NSDictionary *)meta {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    QCloudCOSXMLCopyObjectRequest* copyObjectRequest =  [[QCloudCOSXMLCopyObjectRequest alloc] init];
    copyObjectRequest.sourceRegion = self.configuration.endpoint.regionName;
    copyObjectRequest.sourceBucket = bucket;
    copyObjectRequest.sourceObject = object;
    copyObjectRequest.bucket = bucket;
    copyObjectRequest.object = object;
    copyObjectRequest.customHeaders = meta;
    [copyObjectRequest setFinishBlock:^(QCloudCopyObjectResult *result, NSError *error) {
        if (nil == error) {
            //
        } else {
            QCloudLogDebug(error.description);
        }
        dispatch_semaphore_signal(semaphore);
    }];
    [self PutObjectCopy:copyObjectRequest];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}
@end
