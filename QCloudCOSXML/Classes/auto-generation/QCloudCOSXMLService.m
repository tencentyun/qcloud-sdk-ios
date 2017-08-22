//
//  COSXML.m
//  COSXML
//
//  Created by tencent
//  Copyright (c) 2015年 tencent. All rights reserved.
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


#import "QCloudCOSXMLService.h"
#import "QCloudCOSXMLService+Configuration.h"
#import "QCloudCOSXMLService+Private.h"
#import "QCloudThreadSafeMutableDictionary.h"
#import "QCLoudError.h"

#import "QCloudAppendObjectRequest.h"
#import "QCloudGetObjectACLRequest.h"
#import "QCloudPutObjectRequest.h"
#import "QCloudPutObjectACLRequest.h"
#import "QCloudDeleteObjectRequest.h"
#import "QCloudDeleteMultipleObjectRequest.h"
#import "QCloudHeadObjectRequest.h"
#import "QCloudOptionsObjectRequest.h"
#import "QCloudInitiateMultipartUploadRequest.h"
#import "QCloudUploadPartRequest.h"
#import "QCloudListMultipartRequest.h"
#import "QCloudCompleteMultipartUploadRequest.h"
#import "QCloudAbortMultipfartUploadRequest.h"
#import "QCloudGetObjectRequest.h"
#import "QCloudGetBucketRequest.h"
#import "QCloudGetBucketACLRequest.h"
#import "QCloudGetBucketCORSRequest.h"
#import "QCloudGetBucketLocationRequest.h"
#import "QCloudGetBucketTaggingRequest.h"
#import "QCloudPutBucketACLRequest.h"
#import "QCloudPutBucketCORSRequest.h"
#import "QCloudPutBucketTaggingRequest.h"
#import "QCloudDeleteBucketCORSRequest.h"
#import "QCloudDeleteBucketTaggingRequest.h"
#import "QCloudHeadBucketRequest.h"
#import "QCloudListBucketMultipartUploadsRequest.h"
QCloudThreadSafeMutableDictionary* QCloudCOSXMLServiceCache()
{
    static QCloudThreadSafeMutableDictionary* CloudcosxmlService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CloudcosxmlService = [QCloudThreadSafeMutableDictionary new];
    });
    return CloudcosxmlService;
}

@implementation QCloudCOSXMLService
static QCloudCOSXMLService* COSXMLService = nil;


+ (QCloudCOSXMLService*) defaultCOSXML
{
    @synchronized (self) {
        if (!COSXMLService) {
            @throw [NSException exceptionWithName:QCloudErrorDomain reason:@"您没有配置默认的OCR服务配置，请配置之后再调用该方法" userInfo:nil];
        }
        return COSXMLService;
    }
}

+ (QCloudCOSXMLService*) registerDefaultCOSXMLWithConfiguration:(QCloudServiceConfiguration*)configuration
{
    @synchronized (self) {
        COSXMLService = [[QCloudCOSXMLService alloc] initWithConfiguration:configuration];
    }
    return COSXMLService;
}

+ (QCloudCOSXMLService*) cosxmlServiceForKey:(NSString*)key
{
    QCloudCOSXMLService* cosxmlService = [QCloudCOSXMLServiceCache() objectForKey:key];
    if (!cosxmlService) {
        @throw [NSException exceptionWithName:QCloudErrorDomain reason:[NSString stringWithFormat:@"您没有配置Key为%@的OCR服务配置，请配置之后再调用该方法", key] userInfo:nil];
    }
    return cosxmlService;
}

+ (QCloudCOSXMLService*) registerCOSXMLWithConfiguration:(QCloudServiceConfiguration*)configuration withKey:(NSString*)key;
{
    QCloudCOSXMLService* cosxmlService =[[QCloudCOSXMLService alloc] initWithConfiguration:configuration];
    [QCloudCOSXMLServiceCache() setObject:cosxmlService  forKey:key];
    return cosxmlService;
}

- (void) AppendObject:(QCloudAppendObjectRequest*)request
{
    [super performRequest:request];
}
- (void) GetObjectACL:(QCloudGetObjectACLRequest*)request
{
    [super performRequest:request];
}
- (void) PutObject:(QCloudPutObjectRequest*)request
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
- (void) HeadObject:(QCloudHeadObjectRequest*)request
{
    [super performRequest:request];
}
- (void) OptionsObject:(QCloudOptionsObjectRequest*)request
{
    [super performRequest:request];
}
- (void) InitiateMultipartUpload:(QCloudInitiateMultipartUploadRequest*)request
{
    [super performRequest:request];
}
- (void) UploadPart:(QCloudUploadPartRequest*)request
{
    [super performRequest:request];
}
- (void) ListMultipart:(QCloudListMultipartRequest*)request
{
    [super performRequest:request];
}
- (void) CompleteMultipartUpload:(QCloudCompleteMultipartUploadRequest*)request
{
    [super performRequest:request];
}
- (void) AbortMultipfartUpload:(QCloudAbortMultipfartUploadRequest*)request
{
    [super performRequest:request];
}
- (void) GetObject:(QCloudGetObjectRequest*)request
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
- (void) GetBucketTagging:(QCloudGetBucketTaggingRequest*)request
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
- (void) PutBucketTagging:(QCloudPutBucketTaggingRequest*)request
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
- (void) DeleteBucketTagging:(QCloudDeleteBucketTaggingRequest*)request
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


@end
