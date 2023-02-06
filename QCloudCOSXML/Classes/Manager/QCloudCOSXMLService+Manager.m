//
//  QCloudCOSXMLService+Manager.m
//  QCloudCOSXML
//
//  Created by erichmzhang(张恒铭) on 07/12/2017.
//

#import "QCloudCOSXMLService+Manager.h"
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
#import "QCloudPutBucketAccelerateRequest.h"
#import "QCloudGetBucketAccelerateRequest.h"
#import "QCloudGetObjectTaggingRequest.h"
#import "QCloudPutObjectTaggingRequest.h"
#import "QCloudPutBucketIntelligentTieringRequest.h"
#import "QCloudGetBucketIntelligentTieringRequest.h"
#import "QCloudPutBucketRefererRequest.h"
#import "QCloudGetBucketRefererRequest.h"
#import "QCloudGetVideoRecognitionRequest.h"
#import "QCloudPostVideoRecognitionRequest.h"
#import "QCloudAppendObjectRequest.h"
#import "QCloudDeleteObjectTaggingRequest.h"
#import "QCloudGetBucketPolicyRequest.h"
#import "QCloudPutBucketPolicyRequest.h"
#import "QCloudDeleteBucketPolicyRequest.h"

@implementation QCloudCOSXMLService (Manager)

- (void)PutBucketIntelligentTiering:(QCloudPutBucketIntelligentTieringRequest *)request {
    [super performRequest:request];
}

- (void)GetBucketIntelligentTiering:(QCloudGetBucketIntelligentTieringRequest *)request {
    [super performRequest:request];
}
- (void)GetObjectTagging:(QCloudGetObjectTaggingRequest *)request {
    [super performRequest:request];
}

- (void)DeleteObjectTagging:(QCloudDeleteObjectTaggingRequest *)request {
    [super performRequest:request];
}

- (void)PuObjectTagging:(QCloudPutObjectTaggingRequest *)request{
    [super performRequest:request];
}

- (void)GetObjectACL:(QCloudGetObjectACLRequest *)request {
    [super performRequest:request];
}

- (void)PutObjectACL:(QCloudPutObjectACLRequest *)request {
    [super performRequest:request];
}

- (void)DeleteObject:(QCloudDeleteObjectRequest *)request {
    [super performRequest:request];
}

- (void)DeleteMultipleObject:(QCloudDeleteMultipleObjectRequest *)request {
    [super performRequest:request];
}

- (void)OptionsObject:(QCloudOptionsObjectRequest *)request {
    [super performRequest:request];
}

- (void)GetService:(QCloudGetServiceRequest *)request {
    [super performRequest:request];
}

- (void)PutBucket:(QCloudPutBucketRequest *)request {
    [super performRequest:request];
}
- (void)GetBucket:(QCloudGetBucketRequest *)request {
    [super performRequest:request];
}

- (void)HeadBucket:(QCloudHeadBucketRequest *)request {
    [super performRequest:request];
}

- (void)DeleteBucket:(QCloudDeleteBucketRequest *)request {
    [super performRequest:request];
}

- (void)GetBucketLocation:(QCloudGetBucketLocationRequest *)request {
    [super performRequest:request];
}

- (void)ListBucketMultipartUploads:(QCloudListBucketMultipartUploadsRequest *)request {
    [super performRequest:request];
}

- (void)PutBucketACL:(QCloudPutBucketACLRequest *)request {
    [super performRequest:request];
}

- (void)GetBucketACL:(QCloudGetBucketACLRequest *)request {
    [super performRequest:request];
}

- (void)GetBucketCORS:(QCloudGetBucketCORSRequest *)request {
    [super performRequest:request];
}

- (void)PutBucketLifecycle:(QCloudPutBucketLifecycleRequest *)request {
    [super performRequest:request];
}

- (void)GetBucketLifecycle:(QCloudGetBucketLifecycleRequest *)request {
    [super performRequest:request];
}

- (void)DeleteBucketLifeCycle:(QCloudDeleteBucketLifeCycleRequest *)request {
    [super performRequest:request];
}

- (void)PutBucketCORS:(QCloudPutBucketCORSRequest *)request {
    [super performRequest:request];
}

- (void)DeleteBucketCORS:(QCloudDeleteBucketCORSRequest *)request {
    [super performRequest:request];
}

- (void)PutBucketVersioning:(QCloudPutBucketVersioningRequest *)request {
    [super performRequest:request];
}

- (void)GetBucketVersioning:(QCloudGetBucketVersioningRequest *)request {
    [super performRequest:request];
}

- (void)PutBucketAccelerate:(QCloudPutBucketAccelerateRequest *)request {
    [super performRequest:request];
}
- (void)GetBucketAccelerate:(QCloudGetBucketAccelerateRequest *)request {
    [super performRequest:request];
}

- (void)PutBucketRelication:(QCloudPutBucketReplicationRequest *)request {
    [super performRequest:request];
}

- (void)GetBucketReplication:(QCloudGetBucketReplicationRequest *)request {
    [super performRequest:request];
}

- (void)DeleteBucketReplication:(QCloudDeleteBucketReplicationRequest *)request {
    [super performRequest:request];
}

- (void)PostObjectRestore:(QCloudPostObjectRestoreRequest *)request {
    [super performRequest:request];
}
- (void)ListObjectVersions:(QCloudListObjectVersionsRequest *)request {
    [super performRequest:request];
}

- (void)PutBucketDomain:(QCloudPutBucketDomainRequest *)request {
    [super performRequest:request];
}

- (void)GetBucketDomain:(QCloudGetBucketDomainRequest *)request {
    [super performRequest:request];
}

- (void)PutBucketWebsite:(QCloudPutBucketWebsiteRequest *)request {
    [super performRequest:request];
}

- (void)GetBucketWebsite:(QCloudGetBucketWebsiteRequest *)request {
    [super performRequest:request];
}

- (void)DeleteBucketWebsite:(QCloudDeleteBucketWebsiteRequest *)request {
    [super performRequest:request];
}

- (void)GetBucketTagging:(QCloudGetBucketTaggingRequest *)request {
    [super performRequest:request];
}

- (void)PutBucketTagging:(QCloudPutBucketTaggingRequest *)request {
    [super performRequest:request];
}

- (void)DeleteBucketTagging:(QCloudDeleteBucketTaggingRequest *)request {
    [super performRequest:request];
}

- (void)SelectObjectContent:(QCloudSelectObjectContentRequest *)request {
    [super performRequest:request];
}

- (void)PutBucketLogging:(QCloudPutBucketLoggingRequest *)request {
    [super performRequest:request];
}

- (void)GetBucketLogging:(QCloudGetBucketLoggingRequest *)request {
    [super performRequest:request];
}

- (void)PutBucketInventory:(QCloudPutBucketInventoryRequest *)request {
    [super performRequest:request];
}

- (void)GetBucketInventory:(QCloudGetBucketInventoryRequest *)request {
    [super performRequest:request];
}

- (void)DeleteBucketInventory:(QCloudDeleteBucketInventoryRequest *)request {
    [super performRequest:request];
}

- (void)ListBucketInventory:(QCloudListBucketInventoryConfigurationsRequest *)request {
    [super performRequest:request];
}

- (void)GetBucketReferer:(QCloudGetBucketRefererRequest *)request {
    [super performRequest:request];
}

- (void)PutBucketReferer:(QCloudPutBucketRefererRequest *)request {
    [super performRequest:request];
}

- (void)AppendObject:(QCloudAppendObjectRequest*)request{
    [super performRequest:request];
}

-(void)GetBucketPolicy:(QCloudGetBucketPolicyRequest *)request{
    [super performRequest:request];
}

-(void)PutBucketPolicy:(QCloudPutBucketPolicyRequest *)request{
    [super performRequest:request];
}

-(void)DeleteBucketPolicy:(QCloudDeleteBucketPolicyRequest *)request{
    [super performRequest:request];
}

- (void)getPresignedURL:(QCloudGetPresignedURLRequest *)request {
    request.runOnService = self;
    request.signatureProvider = self.configuration.signatureProvider;
    NSError *error;
    NSURLRequest *urlRequest = [request buildURLRequest:&error];
    if (nil != error) {
        [request onError:error];
        return;
    }
    __block NSString *requestURLString = urlRequest.URL.absoluteString;
    if(!request.isUseSignature){
        QCloudGetPresignedURLResult *result = [[QCloudGetPresignedURLResult alloc] init];
        result.presienedURL = requestURLString;
        request.finishBlock(result, nil);
        return;
    }
    [request.signatureProvider signatureWithFields:request.signatureFields
                                           request:request
                                        urlRequest:(NSMutableURLRequest *)urlRequest
                                         compelete:^(QCloudSignature *signature, NSError *error) {
                                             NSString *authorizatioinString = signature.signature;
                                             if ([requestURLString hasSuffix:@"&"] || [requestURLString hasSuffix:@"?"]) {
                                                 requestURLString = [requestURLString stringByAppendingString:authorizatioinString];
                                             } else if([requestURLString containsString:@"?"] && ![requestURLString hasSuffix:@"&"]){
                                                 requestURLString = [requestURLString stringByAppendingFormat:@"&%@", authorizatioinString];
                                             }else {
                                                 requestURLString = [requestURLString stringByAppendingFormat:@"?%@", authorizatioinString];
                                             }
                                             if (signature.token) {
                                                 requestURLString =
                                                     [requestURLString stringByAppendingFormat:@"&x-cos-security-token=%@", signature.token];
                                             }
        
                                             QCloudGetPresignedURLResult *result = [[QCloudGetPresignedURLResult alloc] init];
                                             result.presienedURL = requestURLString;
                                             if (request.finishBlock) {
                                                 request.finishBlock(result, nil);
                                             }
                                         }];
}

- (BOOL)doesBucketExist:(NSString *)bucketName {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block BOOL result = NO;
    QCloudHeadBucketRequest *headBucketRequest = [[QCloudHeadBucketRequest alloc] init];
    headBucketRequest.bucket = bucketName;
    [headBucketRequest setFinishBlock:^(id outputObject, NSError *error) {
        if (nil == error) {
            result = YES;
        } else {
            QCloudLogDebug(@" Head Object Fail!\n%@", error);
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
    QCloudHeadObjectRequest *headObjectRequest = [[QCloudHeadObjectRequest alloc] init];
    headObjectRequest.bucket = bucket;
    headObjectRequest.object = objectName;
    [headObjectRequest setFinishBlock:^(id outputObject, NSError *error) {
        if (nil == error) {
            result = YES;
        } else {
            QCloudLogDebug(@" Head Object Fail!\n%@", error);
        }
        dispatch_semaphore_signal(semaphore);
    }];
    [self HeadObject:headObjectRequest];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return result;
}

- (void)deleteObjectWithBucket:(NSString *)bucket object:(NSString *)objectName {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    QCloudDeleteObjectRequest *deleteObjectRequest = [QCloudDeleteObjectRequest new];
    deleteObjectRequest.bucket = bucket;
    deleteObjectRequest.object = objectName;
    [deleteObjectRequest setFinishBlock:^(id outputObject, NSError *error) {
        if (nil == error) {
            //
        } else {
            QCloudLogDebug(@"%@", error.description);
        }
        dispatch_semaphore_signal(semaphore);
    }];

    [self DeleteObject:deleteObjectRequest];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

- (void)deleteVersionWithBucket:(NSString *)bucket object:(NSString *)object version:(NSString *)versionID {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    QCloudDeleteObjectRequest *deleteObjectRequest = [QCloudDeleteObjectRequest new];
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
    QCloudCOSXMLCopyObjectRequest *copyObjectRequest = [[QCloudCOSXMLCopyObjectRequest alloc] init];
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
    [[QCloudCOSTransferMangerService defaultCOSTransferManager] CopyObject:copyObjectRequest];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

- (void)updateObjectMedaWithBucket:(NSString *)bucket object:(NSString *)object meta:(NSDictionary *)meta {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    QCloudCOSXMLCopyObjectRequest *copyObjectRequest = [[QCloudCOSXMLCopyObjectRequest alloc] init];
    copyObjectRequest.sourceRegion = self.configuration.endpoint.regionName;
    copyObjectRequest.sourceBucket = bucket;
    copyObjectRequest.sourceObject = object;
    copyObjectRequest.bucket = bucket;
    copyObjectRequest.object = object;
    [copyObjectRequest.customHeaders addEntriesFromDictionary:meta];
    [copyObjectRequest setFinishBlock:^(QCloudCopyObjectResult *result, NSError *error) {
        if (nil == error) {
            //
        } else {
            QCloudLogDebug(error.description);
        }
        dispatch_semaphore_signal(semaphore);
    }];
    [[QCloudCOSTransferMangerService defaultCOSTransferManager] CopyObject:copyObjectRequest];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}
@end
