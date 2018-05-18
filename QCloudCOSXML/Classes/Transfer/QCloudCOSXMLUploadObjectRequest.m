//
//  QCloudCOSXMLUploadObjectRequest.m
//  Pods
//
//  Created by Dong Zhao on 2017/5/23.
//
//

#import "QCloudCOSXMLUploadObjectRequest.h"
#import "QCloudPutObjectRequest.h"
#import "QCloudCOSXMLService+Transfer.h"
#import "QCloudInitiateMultipartUploadRequest.h"
#import "QCloudUploadPartRequest.h"
#import "QCloudCompleteMultipartUploadRequest.h"
#import "QCloudMultipartInfo.h"
#import "QCloudCompleteMultipartUploadInfo.h"
#import "QCloudCOSXMLUploadObjectRequest_Private.h"
#import "QCloudListMultipartRequest.h"
#import "QCloudCOSXMLServiceUtilities.h"
#import "QCloudCOSTransferMangerService.h"
#import "QCloudAbortMultipfartUploadRequest.h"
#import <QCloudCore/QCloudNetworkingAPI.h>
//#import <QCloudCore/QCloudEncrypt.h>
static NSUInteger kQCloudCOSXMLUploadLengthLimit = 1*1024*1024;
static NSUInteger kQCloudCOSXMLUploadSliceLength = 1*1024*1024;

@interface QCloudCOSXMlResumeUploadInfo : NSObject
@property (nonatomic, strong) NSString* uploadid;
@property (nonatomic, strong) NSString* localPath;
@property (strong, nonatomic) NSString *object;
@property (strong, nonatomic) NSString *bucket;
@end


@implementation QCloudCOSXMlResumeUploadInfo
@end


NSString* const QCloudUploadResumeDataKey = @"__QCloudUploadResumeDataKey__";

@interface QCloudCOSXMLUploadObjectRequest ()
{
    NSRecursiveLock* _recursiveLock;
    NSRecursiveLock* _progressLock;
}
@property (nonatomic, assign) int64_t totalBytesSent;
@property (nonatomic, assign) NSUInteger dataContentLength;
@property (nonatomic, strong) dispatch_source_t queueSource;
@property (nonatomic, strong) NSMutableArray<QCloudMultipartInfo*>* uploadParts;
@property (nonatomic, strong) NSString* uploadId;
@property (nonatomic, strong) NSPointerArray* requestCacheArray;
@end

@implementation QCloudCOSXMLUploadObjectRequest

- (void) dealloc
{
    if (NULL != _queueSource) {
        dispatch_source_cancel(_queueSource);
    }
}
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @ {
        @"uploadParts":[QCloudMultipartInfo class],
    };
}

- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _requestCacheArray = [NSPointerArray weakObjectsPointerArray];
    _aborted = NO;
    _recursiveLock = [NSRecursiveLock new];
    _progressLock = [NSRecursiveLock new];
    return self;
}

- (void) continueMultiUpload:(QCloudListPartsResult*)existParts
{
    _uploadParts = [NSMutableArray new];
    NSArray* allParts = [self getFileLocalUploadParts];
    NSMutableDictionary* existMap = [NSMutableDictionary new];
    for (QCloudMultipartUploadPart* part in existParts.parts) {
        [existMap setObject:part forKey:part.partNumber];
    }
    QCloudLogDebug(@"SERVER EXIST PARTS %@", [existParts qcloud_modelToJSONString]);
    
    NSMutableArray* restParts = [NSMutableArray new];
    for (QCloudFileOffsetBody* offsetBody in allParts) {
        NSString* key = [@(offsetBody.index+1) stringValue];
        QCloudMultipartUploadPart* part = [existMap objectForKey:key];
        if (!part) {
            [restParts addObject:offsetBody];
        } else {
            QCloudMultipartInfo* info = [QCloudMultipartInfo new];
            info.eTag = part.eTag;
            info.partNumber = part.partNumber;
            [_uploadParts addObject:info];
        }
    }
    if (restParts.count == 0) {
        [self finishUpload:self.uploadId];
    } else {
        [self uploadOffsetBodys:restParts];
    }
}

- (void) resumeUpload
{
    QCloudListMultipartRequest* request = [QCloudListMultipartRequest new];
    request.object = self.object;
    request.bucket = self.bucket;
    request.uploadId = self.uploadId;
    
    __weak typeof(self) weakSelf = self;
    [request setFinishBlock:^(QCloudListPartsResult * _Nonnull result,
                              NSError * _Nonnull error) {
        [weakSelf continueMultiUpload:result];
    }];
    
    [self.transferManager.cosService ListMultipart:request];
}
- (void) fackStart {
    [self.benchMarkMan benginWithKey:kRNBenchmarkRTT];
    
    if (self.uploadId) {
        [self resumeUpload];
        return;
    }
    self.totalBytesSent = 0;
    
    if ([self.body isKindOfClass:[NSData class]]) {
        [self startSimpleUpload];
    } else if ([self.body isKindOfClass:[NSURL class]]) {
        NSURL* url = (NSURL*)self.body;
        self.dataContentLength = QCloudFileSize(url.path);
        if (self.dataContentLength > kQCloudCOSXMLUploadLengthLimit) {
            [self startMultiUpload];
        } else {
            [self startSimpleUpload];
        }
    } else {
        @throw [NSException exceptionWithName:kQCloudNetworkDomain
                                       reason:@"不支持设置该类型的body，支持的类型为NSData、QCloudFileOffsetBody"
                                     userInfo:@{}];
    }
}
- (void) startSimpleUpload
{
    QCloudPutObjectRequest* request = [QCloudPutObjectRequest new];
    __weak typeof(self) weakSelf = self;
    request.finishBlock = ^(id outputObject, NSError *error) {
        if (error) {
            [weakSelf onError:error];
            [self cancel];
        } else {
            QCloudUploadObjectResult* result = [QCloudUploadObjectResult new];
            result.eTag = [outputObject valueForKey:@"Etag"];
            if (outputObject[@"x-cos-version-id"]) {
                result.versionID = outputObject[@"x-cos-version-id"];
            }
            
            NSString* localMD5 ;
            if ([weakSelf.body isKindOfClass:[NSData class]]) {
                localMD5 = QCloudEncrytNSDataMD5(weakSelf.body);
            } else if ([weakSelf.body isKindOfClass:[NSURL class]]) {
                localMD5 = QCloudEncrytFileMD5(((NSURL*)weakSelf.body).path);
            }
            NSString* MD5FromCOS = [result.eTag substringWithRange:NSMakeRange(1, result.eTag.length - 2)];
            if (![localMD5.lowercaseString isEqualToString:MD5FromCOS]) {
                NSMutableString* errorMessageString = [[NSMutableString alloc] init];
                [errorMessageString appendFormat:@"简单上传过程中MD5校验与本地不一致，请检查本地文件在上传过程中是否发生了变化,建议调用删除接口将COS上的文件删除并重新上传"];
                if ( outputObject[@"x-cos-request-id"]!= nil) {
                    NSString* requestID = outputObject[@"x-cos-request-id"];
                    [errorMessageString appendFormat:@", Request id:%@",requestID];
                }
                NSError* error = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeMD5NotMatch message:errorMessageString];
                [weakSelf onError:error];
                return ;
            }
            
            result.key = weakSelf.object;
            result.bucket = weakSelf.bucket;
            result.location = QCloudCOSXMLObjectLocation(weakSelf.transferManager.configuration.endpoint,
                                                         weakSelf.transferManager.configuration.appID,
                                                         weakSelf.bucket,
                                                         weakSelf.object);
            result.__originHTTPURLResponse__ = [outputObject __originHTTPURLResponse__];
            [weakSelf onSuccess:result];
        }
    };
    request.bucket = self.bucket;
    request.object = self.object;
    request.body = self.body;
    request.cacheControl = self.cacheControl;
    request.contentDisposition = self.contentDisposition;
    request.expect = self.expect;
    request.expires = self.expires;
    request.contentSHA1 = self.contentSHA1;
    request.storageClass = self.storageClass;
    request.accessControlList = self.accessControlList;
    request.grantRead = self.grantRead;
    request.grantWrite = self.grantWrite;
    request.grantFullControl = self.grantFullControl;
    request.sendProcessBlock = self.sendProcessBlock;
    request.delegate = self.delegate;
    request.customHeaders = self.customHeaders;
    [self.requestCacheArray addPointer:(__bridge void * _Nullable)(request)];
    [self.transferManager.cosService PutObject:request];
}

- (void) startMultiUpload {
    _uploadParts = [NSMutableArray new];
    QCloudInitiateMultipartUploadRequest* uploadRequet = [QCloudInitiateMultipartUploadRequest new];
    uploadRequet.bucket = self.bucket;
    uploadRequet.object = self.object;
    uploadRequet.cacheControl = self.cacheControl;
    uploadRequet.contentDisposition = self.contentDisposition;
    uploadRequet.expect = self.expect;
    uploadRequet.expires = self.expires;
    uploadRequet.contentSHA1 = self.contentSHA1;
    uploadRequet.storageClass = self.storageClass;
    uploadRequet.accessControlList = self.accessControlList;
    uploadRequet.grantRead = self.grantRead;
    uploadRequet.grantWrite = self.grantWrite;
    uploadRequet.grantFullControl = self.grantFullControl;
    uploadRequet.customHeaders = self.customHeaders;
    __weak typeof(self) weakSelf = self;

    [uploadRequet setFinishBlock:^(QCloudInitiateMultipartUploadResult * _Nonnull result,
                                   NSError * _Nonnull error) {
        if (error) {
            [weakSelf onError:error];
        } else {
            if (weakSelf.initMultipleUploadFinishBlock) {
                self.uploadId = result.uploadId;
                QCloudCOSXMLUploadObjectResumeData resumeData = [self productingReqsumeData:nil];
                if (self.initMultipleUploadFinishBlock) {
                    self.initMultipleUploadFinishBlock(result, resumeData);
                }
            }
            [weakSelf uploadMultiParts:result];
        }
    }];
    
    [self.requestCacheArray addPointer:(__bridge void * _Nullable)(uploadRequet)];
    [self.transferManager.cosService InitiateMultipartUpload:uploadRequet];
}


- (NSArray<QCloudFileOffsetBody*>*) getFileLocalUploadParts
{
    NSMutableArray* allParts = [NSMutableArray new];
    NSURL* url = (NSURL*)self.body;
    int64_t restContentLength = self.dataContentLength;
    int64_t offset = 0;
    for (int i = 0; ;i++ ) {
        int64_t slice = 0;
        if (restContentLength >= kQCloudCOSXMLUploadSliceLength) {
            slice = kQCloudCOSXMLUploadSliceLength;
        } else {
            slice = restContentLength;
        }
        QCloudFileOffsetBody* body = [[QCloudFileOffsetBody alloc] initWithFile:url
                                                                         offset:offset
                                                                          slice:slice];
        [allParts addObject:body];
        offset += slice;
        body.index = i;
        restContentLength -= slice;
        if (restContentLength <= 0) {
            break;
        }
    }
    return allParts;
}

- (void) appendUploadBytesSent:(int64_t)bytesSent
{
    [_progressLock lock];
    _totalBytesSent += bytesSent;
    [self notifySendProgressBytesSend:bytesSent
                       totalBytesSend:_totalBytesSent
             totalBytesExpectedToSend:_dataContentLength];
    [_progressLock unlock];
}

- (void) uploadOffsetBodys:(NSArray<QCloudFileOffsetBody*>*)allParts
{
    //rest already upload size
    int64_t totalTempBytesSend = 0;
    for (QCloudFileOffsetBody* body in allParts) {
        totalTempBytesSend += body.sliceLength;
    }
    _totalBytesSent = _dataContentLength - totalTempBytesSend;
    //
    __weak typeof(self) weakSelf = self;
    _queueSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD,
                                          0,
                                          0,
                                          dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0));
    __block int totalComplete = 0;
    dispatch_source_set_event_handler(_queueSource, ^{
        NSUInteger value = dispatch_source_get_data(weakSelf.queueSource);
        @synchronized (weakSelf) {
            totalComplete += value;
        }
        if (totalComplete == allParts.count) {
            if (NULL != weakSelf.queueSource) {
                dispatch_source_cancel(weakSelf.queueSource);
            }
            [weakSelf finishUpload:weakSelf.uploadId];
        }
    });
    dispatch_resume(_queueSource);
    for (int i = 0; i < allParts.count; i++) {
        __block QCloudFileOffsetBody* body = allParts[i];

        QCloudUploadPartRequest* request = [QCloudUploadPartRequest new];
        request.bucket = self.bucket;
        request.object = self.object;
        request.priority = QCloudAbstractRequestPriorityLow;
        request.partNumber = (int)body.index + 1;
        request.uploadId = self.uploadId;
        request.customHeaders = self.customHeaders;
        request.body = body;
        
        __block int64_t partBytesSent = 0;
        int64_t partSize = body.sliceLength;
        [request setSendProcessBlock:^(int64_t bytesSent,
                                       int64_t totalBytesSent,
                                       int64_t totalBytesExpectedToSend) {
            int64_t restSize = totalBytesExpectedToSend - partSize;
            if (restSize - partBytesSent <= 0) {
                [weakSelf appendUploadBytesSent:bytesSent];
            } else {
                partBytesSent += bytesSent;
                if (restSize - partBytesSent <= 0) {
                    [weakSelf appendUploadBytesSent:partBytesSent - restSize];
                }
            }
        }];
        [request setFinishBlock:^(QCloudUploadPartResult* outputObject, NSError *error) {
            if (!weakSelf) {
                return ;
            }
            if (error && error.code != QCloudNetworkErrorCodeCanceled) {
                NSError* transferError = [weakSelf tranformErrorToResume:error];
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [weakSelf onError:transferError];
                if (!self.canceled) {
                    [strongSelf cancel];
                }
            } else {
                
                NSString* MD5FromeETag = [outputObject.eTag substringWithRange:NSMakeRange(1, outputObject.eTag.length-2)];
                NSString* localMD5String = [QCloudEncrytFileOffsetMD5(body.fileURL.path, body.offset, body.sliceLength) lowercaseString];
                if (![MD5FromeETag isEqualToString:localMD5String]) {
                    NSMutableString* errorMessageString = [[NSMutableString alloc] init];
                    [errorMessageString appendFormat:@"分片上传过程中MD5校验与本地不一致，请检查本地文件在上传过程中是否发生了变化,建议调用删除接口将COS上的文件删除并重新上传"];
                    if ( [outputObject __originHTTPURLResponse__]&& [[outputObject __originHTTPURLResponse__].allHeaderFields valueForKey:@"x-cos-request-id"]!= nil) {
                        NSString* requestID = [[outputObject __originHTTPURLResponse__].allHeaderFields valueForKey:@"x-cos-request-id"];
                        [errorMessageString appendFormat:@", Request id:%@",requestID];
                    }
                    NSError* error = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeMD5NotMatch message:errorMessageString];
                    [weakSelf onError:error];
                    [weakSelf cancel];
                    return ;
                }
                
                
                QCloudMultipartInfo* info = [QCloudMultipartInfo new];
                info.eTag = outputObject.eTag;
                info.partNumber = [@(body.index+1) stringValue];
                [weakSelf markPartFinish:info];
                dispatch_source_merge_data(weakSelf.queueSource, 1);
            }
        }];
        
        [self.requestCacheArray addPointer:(__bridge void * _Nullable)(request)];
        [self.transferManager.cosService UploadPart:request];
    }
}

- (NSError*) tranformErrorToResume:(NSError*)error
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic addEntriesFromDictionary:error.userInfo];
    QCloudCOSXMLUploadObjectResumeData resumeData = [self productingReqsumeData:NULL];
    if (resumeData) {
        dic[QCloudUploadResumeDataKey] = resumeData;
    }
    NSError* transferError = [NSError errorWithDomain:error.domain code:error.code userInfo:dic];
    return transferError;
}
- (void) uploadMultiParts:(QCloudInitiateMultipartUploadResult*)result{
    self.uploadId = result.uploadId;
    NSArray* allParts = [self getFileLocalUploadParts];
    [self uploadOffsetBodys:allParts];
}

- (void) markPartFinish:(QCloudMultipartInfo*)info
{
    if (!info) {
        return;
    }
    [_recursiveLock lock];
    [_uploadParts addObject:info];
    [_recursiveLock unlock];
}

- (void) onError:(NSError *)error
{
    if (!self.aborted) {
        NSError* transferError = [self tranformErrorToResume:error];
        [super onError:transferError];
    } else {
        [super onError:error];
    }
}

- (void) finishUpload:(NSString*)uploadId
{
    QCloudCompleteMultipartUploadRequest* complete = [QCloudCompleteMultipartUploadRequest new];
    complete.object = self.object;
    complete.bucket = self.bucket;
    complete.uploadId = self.uploadId;
    
    QCloudCompleteMultipartUploadInfo* info = [QCloudCompleteMultipartUploadInfo new];
    [self.uploadParts sortUsingComparator:^NSComparisonResult(QCloudMultipartInfo*  _Nonnull obj1,
                                                              QCloudMultipartInfo*  _Nonnull obj2) {
        int a = obj1.partNumber.intValue;
        int b = obj2.partNumber.intValue;
        
        if (a < b) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    
    info.parts = self.uploadParts;
    complete.parts = info;
    
    __weak typeof(self) weakSelf = self;
    [complete setFinishBlock:^(QCloudUploadObjectResult* outputObject, NSError *error) {
        outputObject.location = QCloudFormattHTTPURL(outputObject.location,
                                                     weakSelf.transferManager.cosService.configuration.endpoint.useHTTPS);
        if (error) {
            [weakSelf onError:error];
        } else {
            [weakSelf onSuccess:outputObject];
        }
    }];
    
    [self.requestCacheArray addPointer:(__bridge void * _Nullable)(complete)];
    [self.transferManager.cosService CompleteMultipartUpload:complete];

}




//
+ (instancetype) requestWithRequestData:(QCloudCOSXMLUploadObjectResumeData)resumeData
{
    QCloudCOSXMLUploadObjectRequest* request = [QCloudCOSXMLUploadObjectRequest qcloud_modelWithJSON:resumeData];
    QCloudLogDebug(@"Generating request from resume data, body is %@",request.body);
    if ([request.body isKindOfClass:[NSString class]]) {
        NSString* path;
        if ([request.body hasPrefix:@"/var/mobile/Media/DCIM"]) {
                path = request.body;
         } else {
                path = QCloudGenerateLocalPath(request.body);
        }

        if ([path hasPrefix:@"file"]) {
            request.body = [NSURL URLWithString:path];
        } else {
            request.body  = [NSURL fileURLWithPath:path];
        }
    }
    QCloudLogDebug(@"Path after transfering is %@",request.body);
    return request;
    
}


- (void) cancel
{
    [super cancel];
    [self.requestCacheArray compact];
    if (NULL != _queueSource) {
        dispatch_source_cancel(_queueSource);
    }

    NSMutableArray* cancelledRequestIDs = [NSMutableArray array];
    for (QCloudHTTPRequest* request  in self.requestCacheArray) {
        if (request != nil) {
            [cancelledRequestIDs addObject:[NSNumber numberWithLongLong:request.requestID]];
        }
    }
    [[QCloudHTTPSessionManager shareClient] cancelRequestsWithID:cancelledRequestIDs];
}
- (QCloudCOSXMLUploadObjectResumeData) cancelByProductingResumeData:(NSError *__autoreleasing *)error
{
    //延迟取消 让函数先返回
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self cancel];
    });
    return [self productingReqsumeData:error];
}
+ (nullable NSArray<NSString *> *)modelPropertyBlacklist
{
    return @[@"delegate"];
}

- (QCloudCOSXMLUploadObjectResumeData) productingReqsumeData:(NSError* __autoreleasing*)error
{
    if (_dataContentLength <= kQCloudCOSXMLUploadLengthLimit) {
        if (NULL != error) {
            *error = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeContentError
                                           message:@"无法暂停当前的上传请求，因为使用的是单次上传"];
        }
        return nil;
    }
    if (![self.body isKindOfClass:[NSURL class]]) {
        if (NULL != error) {
            *error = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeContentError
                                           message:@"无法暂停当前的上传请求，因为使用的是非持久化存储上传"];
        }
        return nil;
    }
    if ([self finished]) {
        if (NULL != error) {
            *error = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeAlreadyFinish
                                           message:@"无法暂停当前的上传请求，因为该请求已经结束"];
        }
        return nil;
    }
    [_recursiveLock lock];
        NSURL* url = (NSURL*)self.body;
        NSString* path = url.path;
        path = QCloudFilteLocalPath(path);
        self.body = path;
        NSData* info = [self qcloud_modelToJSONData];
        QCloudLogDebug(@"RESUME data %@",info);
        self.body = url;
    [_recursiveLock unlock];
    return info;
}

- (void) abort:(QCloudRequestFinishBlock)finishBlock
{
    if (self.finished) {
        NSError* error = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeContentError
                                               message:@"取消失败，任务已经完成"];
        if (finishBlock) {
            finishBlock(nil, error);
        }
    } else {
        if (self.uploadId) {
            QCloudAbortMultipfartUploadRequest* abortRequest = [QCloudAbortMultipfartUploadRequest new];
            abortRequest.object = self.object;
            abortRequest.bucket = self.bucket;
            abortRequest.uploadId = self.uploadId;
            abortRequest.finishBlock = finishBlock;
            self.uploadId = nil;
            [self.transferManager.cosService AbortMultipfartUpload:abortRequest];
        } else {
            if (finishBlock) {
                finishBlock(@{}, nil);
            }
        }
    }
    _aborted = YES;
    [self cancel];
}


@end
