//
//  QCloudCOSXMLService.h
//  QCloudCOSXMLService
//
//  Created by tencent
//
//
//   ██████╗  ██████╗██╗      ██████╗ ██╗   ██╗██████╗     ████████╗███████╗██████╗ ███╗   ███╗██╗███╗   ██╗ █████╗ ██╗         ██╗      █████╗ ██████╗
//  ██╔═══██╗██╔════╝██║     ██╔═══██╗██║   ██║██╔══██╗    ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║████╗  ██║██╔══██╗██║         ██║     ██╔══██╗██╔══██╗
//  ██║   ██║██║     ██║     ██║   ██║██║   ██║██║  ██║       ██║   █████╗  ██████╔╝██╔████╔██║██║██╔██╗ ██║███████║██║         ██║     ███████║██████╔╝
//  ██║▄▄ ██║██║     ██║     ██║   ██║██║   ██║██║  ██║       ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║██║╚██╗██║██╔══██║██║         ██║     ██╔══██║██╔══██╗
//  ╚██████╔╝╚██████╗███████╗╚██████╔╝╚██████╔╝██████╔╝       ██║   ███████╗██║  ██║██║ ╚═╝ ██║██║██║ ╚████║██║  ██║███████╗    ███████╗██║  ██║██████╔╝
//   ╚══▀▀═╝  ╚═════╝╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝        ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝    ╚══════╝╚═╝  ╚═╝╚═════╝
//
//
//                                                                              _             __                 _                _
//                                                                             (_)           / _|               | |              | |
//                                                          ___  ___ _ ____   ___  ___ ___  | |_ ___  _ __    __| | _____   _____| | ___  _ __   ___ _ __ ___
//                                                         / __|/ _ \ '__\ \ / / |/ __/ _ \ |  _/ _ \| '__|  / _` |/ _ \ \ / / _ \ |/ _ \| '_ \ / _ \ '__/ __|
//                                                         \__ \  __/ |   \ V /| | (_|  __/ | || (_) | |    | (_| |  __/\ V /  __/ | (_) | |_) |  __/ |  \__
//                                                         |___/\___|_|    \_/ |_|\___\___| |_| \___/|_|     \__,_|\___| \_/ \___|_|\___/| .__/ \___|_|  |___/
//    ______ ______ ______ ______ ______ ______ ______ ______                                                                            | |
//   |______|______|______|______|______|______|______|______|                                                                           |_|
//




#import <Foundation/Foundation.h>
#import <QCloudCore/QCloudService.h>

@class QCloudAppendObjectRequest;
@class QCloudGetObjectACLRequest;
@class QCloudPutObjectRequest;
@class QCloudPutObjectACLRequest;
@class QCloudDeleteObjectRequest;
@class QCloudDeleteMultipleObjectRequest;
@class QCloudHeadObjectRequest;
@class QCloudOptionsObjectRequest;
@class QCloudInitiateMultipartUploadRequest;
@class QCloudUploadPartRequest;
@class QCloudListMultipartRequest;
@class QCloudCompleteMultipartUploadRequest;
@class QCloudAbortMultipfartUploadRequest;
@class QCloudGetObjectRequest;
@class QCloudGetBucketRequest;
@class QCloudGetBucketACLRequest;
@class QCloudGetBucketCORSRequest;
@class QCloudGetBucketLocationRequest;
@class QCloudGetBucketLifecycleRequest;
@class QCloudGetBucketTaggingRequest;
@class QCloudPutBucketRequest;
@class QCloudPutBucketACLRequest;
@class QCloudPutBucketCORSRequest;
@class QCloudPutBucketLifecycleRequest;
@class QCloudPutBucketTaggingRequest;
@class QCloudDeleteBucketRequest;
@class QCloudDeleteBucketCORSRequest;
@class QCloudDeleteBucketLifeCycleRequest;
@class QCloudDeleteBucketTaggingRequest;
@class QCloudHeadBucketRequest;
@class QCloudListBucketMultipartUploadsRequest;

@interface QCloudCOSXMLService : QCloudService

#pragma hidden super selectors
- (int) performRequest:(QCloudBizHTTPRequest *)httpRequst NS_UNAVAILABLE;
- (int) performRequest:(QCloudBizHTTPRequest *)httpRequst withFinishBlock:(QCloudRequestFinishBlock)block NS_UNAVAILABLE;

#pragma Factory
+ (QCloudCOSXMLService*) defaultCOSXML;
+ (QCloudCOSXMLService*) cosxmlServiceForKey:(NSString*)key;
+ (QCloudCOSXMLService*) registerDefaultCOSXMLWithConfiguration:(QCloudServiceConfiguration*)configuration;
+ (QCloudCOSXMLService*) registerCOSXMLWithConfiguration:(QCloudServiceConfiguration*)configuration withKey:(NSString*)key;

- (void) AppendObject:(QCloudAppendObjectRequest*)request;
- (void) GetObjectACL:(QCloudGetObjectACLRequest*)request;
- (void) PutObject:(QCloudPutObjectRequest*)request;
- (void) PutObjectACL:(QCloudPutObjectACLRequest*)request;
- (void) DeleteObject:(QCloudDeleteObjectRequest*)request;
- (void) DeleteMultipleObject:(QCloudDeleteMultipleObjectRequest*)request;
- (void) HeadObject:(QCloudHeadObjectRequest*)request;
- (void) OptionsObject:(QCloudOptionsObjectRequest*)request;
- (void) InitiateMultipartUpload:(QCloudInitiateMultipartUploadRequest*)request;
- (void) UploadPart:(QCloudUploadPartRequest*)request;
- (void) ListMultipart:(QCloudListMultipartRequest*)request;
- (void) CompleteMultipartUpload:(QCloudCompleteMultipartUploadRequest*)request;
- (void) AbortMultipfartUpload:(QCloudAbortMultipfartUploadRequest*)request;
- (void) GetObject:(QCloudGetObjectRequest*)request;
- (void) GetBucket:(QCloudGetBucketRequest*)request;
- (void) GetBucketACL:(QCloudGetBucketACLRequest*)request;
- (void) GetBucketCORS:(QCloudGetBucketCORSRequest*)request;
- (void) GetBucketLocation:(QCloudGetBucketLocationRequest*)request;
- (void) GetBucketLifecycle:(QCloudGetBucketLifecycleRequest*)request;
- (void) GetBucketTagging:(QCloudGetBucketTaggingRequest*)request;
- (void) PutBucketACL:(QCloudPutBucketACLRequest*)request;
- (void) PutBucketCORS:(QCloudPutBucketCORSRequest*)request;
- (void) PutBucketLifecycle:(QCloudPutBucketLifecycleRequest*)request;
- (void) PutBucketTagging:(QCloudPutBucketTaggingRequest*)request;
- (void) DeleteBucketCORS:(QCloudDeleteBucketCORSRequest*)request;
- (void) DeleteBucketLifeCycle:(QCloudDeleteBucketLifeCycleRequest*)request;
- (void) DeleteBucketTagging:(QCloudDeleteBucketTaggingRequest*)request;
- (void) HeadBucket:(QCloudHeadBucketRequest*)request;
- (void) ListBucketMultipartUploads:(QCloudListBucketMultipartUploadsRequest*)request;
@end
