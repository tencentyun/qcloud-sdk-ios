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
#import <QCloudCore/QCloudUniversalPath.h>
#import <QCloudCore/QCloudSandboxPath.h>
#import <QCloudCore/QCloudMediaPath.h>
#import <QCloudCore/QCloudBundlePath.h>
#import <QCloudCore/QCloudNetworkingAPI.h>
#import <QCloudCore/QCloudUniversalPathFactory.h>
#import "QCloudCOSTransferMangerService.h"
#import "QCloudPutObjectRequest+Custom.h"
#import <QCloudCore/QCloudSupervisoryRecord.h>
#import <QCloudCore/QCloudHTTPRetryHanlder.h>
static NSUInteger kQCloudCOSXMLUploadLengthLimit = 1*1024*1024;
static NSUInteger kQCloudCOSXMLUploadSliceLength = 1*1024*1024;

@interface QCloudCOSXMlResumeUploadInfo : NSObject
@property (nonatomic, strong) NSString* localPath;
@property (strong, nonatomic) NSString *object;
@property (strong, nonatomic) NSString *bucket;

@end


@implementation QCloudCOSXMlResumeUploadInfo
@end


NSString* const QCloudUploadResumeDataKey = @"__QCloudUploadResumeDataKey__";

@interface QCloudCOSXMLUploadObjectRequest ()<QCloudHttpRetryHandlerProtocol>
{
    NSRecursiveLock* _recursiveLock;
    NSRecursiveLock* _progressLock;
    NSUInteger uploadedSize;
    //标记下标，从0开始
    NSUInteger startPartNumber;
    BOOL isChange;
}
@property (nonatomic, assign) int64_t totalBytesSent;
@property (nonatomic, assign) NSUInteger dataContentLength;
@property (nonatomic, strong) dispatch_source_t queueSource;
//存储所有的分片
@property (nonatomic, strong) NSMutableArray<QCloudMultipartInfo*>* uploadParts;
@property (nonatomic, strong) NSString* uploadId;
@property (nonatomic, strong) NSPointerArray* requestCacheArray;
@property (strong,nonatomic) NSMutableArray *requstMetricArray;
@end

@implementation QCloudCOSXMLUploadObjectRequest

- (void) dealloc
{
    QCloudLogDebug(@"dealloc ------- ");
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
    _customHeaders = [NSMutableDictionary dictionary];
    _aborted = NO;
    _recursiveLock = [NSRecursiveLock new];
    _progressLock = [NSRecursiveLock new];
    _requstMetricArray = [NSMutableArray array];;
    _enableMD5Verification = YES;
    _retryHandler = [QCloudHTTPRetryHanlder defaultRetryHandler];
    startPartNumber = -1;
    return self;
}
- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dictionary {
    NSMutableDictionary *dict = [dictionary mutableCopy];
    if ([dictionary valueForKey:@"body"]) {
        NSDictionary *universalPathDict = [dictionary valueForKey:@"body"];
        QCloudUniversalPathType type = [[universalPathDict valueForKey:@"type"] integerValue];
        NSString *originURL = [universalPathDict valueForKey:@"originURL"];
        QCloudUniversalPath *path ;
        switch (type) {
            case QCLOUD_UNIVERSAL_PATH_TYPE_FIXED:
                path = [[QCloudUniversalFixedPath alloc] initWithStrippedURL:originURL];
                break;
            case QCLOUD_UNIVERSAL_PATH_TYPE_ADJUSTABLE:
                path = [[QCloudUniversalAdjustablePath alloc] initWithStrippedURL:originURL];
                break;
            case QCLOUD_UNIVERSAL_PATH_TYPE_SANDBOX:
                path = [[QCloudSandboxPath alloc] initWithStrippedURL:originURL];
                break;
            case QCLOUD_UNIVERSAL_PATH_TYPE_BUNDLE:
                path = [[QCloudBundlePath alloc] initWithStrippedURL:originURL];
                break;
            case QCLOUD_UNIVERSAL_PATH_TYPE_MEDIA:
                path = [[QCloudMediaPath alloc] initWithStrippedURL:originURL];
                break;
            default:
                break;
        }
        [dict setValue:path forKey:@"body"];
    }
    
    return [dict copy];
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
            if (part.size != offsetBody.sliceLength) {
                isChange = YES;
                break;
            }
            QCloudMultipartInfo* info = [QCloudMultipartInfo new];
            info.eTag = part.eTag;
            info.partNumber = part.partNumber;
            [_uploadParts addObject:info];
        }
    }
    
    if (!isChange) {
        if (restParts.count == 0) {
            [self finishUpload:self.uploadId];
        }else{
            [self uploadOffsetBodys:restParts];
        }
    }else{
        //重新分片
        [self getContinueInfo:existParts.parts];
        if (uploadedSize == self.dataContentLength) {
            [self finishUpload:self.uploadId];
        } else {
            //开始分片
            [self uploadOffsetBodys:[self getFileLocalUploadParts]];
        }
    }
}

-(void)getContinueInfo:(NSArray *)existParts{
    _uploadParts = [NSMutableArray new];
    int i=1;
    QCloudMultipartUploadPart  *part = existParts[0];
    QCloudMultipartInfo* info = [QCloudMultipartInfo new];
    info.eTag = part.eTag;
    info.partNumber = part.partNumber;
    if ([info.partNumber integerValue]!=1){
        return;
    }
    
    for (i = 0; i<existParts.count; i++) {
        QCloudMultipartUploadPart  *part1 = existParts[i];
        QCloudMultipartInfo* info1 = [QCloudMultipartInfo new];
        info1.eTag = part1.eTag;
        info1.partNumber = part1.partNumber;
        uploadedSize+=part1.size;
        [_uploadParts addObject:info1];
        if (i == existParts.count-1) {
            break;
        }
        QCloudMultipartUploadPart  *part2 = existParts[i+1];
        if (([part1.partNumber integerValue]+1)!= [part2.partNumber integerValue]) {
            break;
        }
        
    }
    startPartNumber = _uploadParts.count;
    
    QCloudLogDebug(@"resume startPartNumber =   offset =  %ld %ld",startPartNumber,uploadedSize);
}


- (void) resumeUpload
{
    QCloudListMultipartRequest* request = [QCloudListMultipartRequest new];
    request.priority = self.priority;
    request.timeoutInterval = self.timeoutInterval;
    request.object = self.object;
    request.regionName = self.regionName;
    request.bucket = self.bucket;
    request.uploadId = self.uploadId;
    request.retryPolicy .delegate = self;
    __weak typeof(request)weakRequest = request;
    __weak typeof(self) weakSelf = self;
    [request setFinishBlock:^(QCloudListPartsResult * _Nonnull result,
                              NSError * _Nonnull error) {
        
        __strong typeof(weakSelf)strongSelf = weakSelf;
        __strong typeof(weakRequest)strongRequst = weakRequest;
        [strongSelf.requstMetricArray addObject: @{[NSString stringWithFormat:@"%@",strongRequst]:weakRequest.benchMarkMan.tastMetrics}];
        
        [weakSelf continueMultiUpload:result];
    }];
    
    [self.transferManager.cosService ListMultipart:request];
}
- (void) fakeStart {
    [self.benchMarkMan benginWithKey:kTaskTookTime];
    if (self.uploadId) {
        startPartNumber = 0;
        uploadedSize = 0;
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
            //开始分片上传的时候，上传的起始位置是0
            uploadedSize = 0;
            startPartNumber = 0;
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
    request.regionName = self.regionName;
    __weak typeof(self) weakSelf = self;
    __weak typeof(request)weakRequest  = request;
    request.retryPolicy.delegate = self;
    request.timeoutInterval = self.timeoutInterval;
    request.finishBlock = ^(id outputObject, NSError *error) {
        
        __strong typeof(weakSelf)strongSelf = weakSelf;
        __strong typeof(weakRequest)strongRequst = weakRequest;
        [strongSelf.requstMetricArray addObject: @{[NSString stringWithFormat:@"%@",strongRequst]:weakRequest.benchMarkMan.tastMetrics}];
        
        if (error) {
            [weakSelf onError:error];
            [self cancel];
        } else{
            QCloudUploadObjectResult* result = [QCloudUploadObjectResult new];
            if (outputObject[@"x-cos-version-id"]) {
                result.versionID = outputObject[@"x-cos-version-id"];
            }
            
            
            result.key = weakSelf.object;
            result.bucket = weakSelf.bucket;
            result.location = QCloudCOSXMLObjectLocation(weakSelf.transferManager.configuration.endpoint,
                                                         weakSelf.transferManager.configuration.appID,
                                                         weakSelf.bucket,
                                                         weakSelf.object,self.regionName);
            result.__originHTTPURLResponse__ = [outputObject __originHTTPURLResponse__];
            [weakSelf onSuccess:result];
        }
    };
    request.bucket = self.bucket;
    request.object = self.object;
    request.priority = self.priority;
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
    request.retryPolicy.delegate = self;
    request.customHeaders = [self.customHeaders mutableCopy];
    [self.requestCacheArray addPointer:(__bridge void * _Nullable)(request)];
    [self.transferManager.cosService PutObject:request];
}

- (void) startMultiUpload {
    _uploadParts = [NSMutableArray new];
    QCloudInitiateMultipartUploadRequest* uploadRequet = [QCloudInitiateMultipartUploadRequest new];
    uploadRequet.timeoutInterval = self.timeoutInterval;
    uploadRequet.bucket = self.bucket;
    uploadRequet.regionName = self.regionName;
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
    uploadRequet.customHeaders = [self.customHeaders mutableCopy];
    uploadRequet.retryPolicy.delegate = self;
    uploadRequet.priority = self.priority;
    __weak typeof(uploadRequet)weakRequest  = uploadRequet;
    __weak typeof(self) weakSelf = self;
    
    [uploadRequet setFinishBlock:^(QCloudInitiateMultipartUploadResult * _Nonnull result,
                                   NSError * _Nonnull error) {
        
        __strong typeof(weakSelf)strongSelf = weakSelf;
        __strong typeof(weakRequest)strongRequst = weakRequest;
        [strongSelf.requstMetricArray addObject: @{[NSString stringWithFormat:@"%@",strongRequst]:weakRequest.benchMarkMan.tastMetrics}];
        
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
    
    QCloudLogDebug(@"initPart self.transferManager :%@  self.transferManager.cosService :%@",self.transferManager,self.transferManager.cosService);
}


- (NSArray<QCloudFileOffsetBody*>*) getFileLocalUploadParts
{
    NSMutableArray* allParts = [NSMutableArray new];
    NSURL* url = (NSURL*)self.body;
    int64_t restContentLength = self.dataContentLength-uploadedSize;
    //便宜的起始位置
    int64_t offset = uploadedSize;
    for (int i = startPartNumber; ;i++ ) {
        int64_t slice = 0;
        NSUInteger uploadSliceLength = self.sliceSize>10?self.sliceSize:kQCloudCOSXMLUploadSliceLength;
        if (restContentLength >= uploadSliceLength) {
            slice = uploadSliceLength;
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
        request.timeoutInterval = self.timeoutInterval;
        request.regionName = self.regionName;
        request.object = self.object;
        request.priority = QCloudAbstractRequestPriorityLow;
        request.partNumber = (int)body.index + 1;
        request.uploadId = self.uploadId;
        request.customHeaders = [self.customHeaders mutableCopy];
        request.body = body;
        request.retryPolicy.delegate = self;
        __weak typeof(request)weakRequest  = request;
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
            QCloudLogInfo(@"收到一个part  %d的响应 %@",(i+1),outputObject.eTag);
            if (!weakSelf) {
                return ;
            }
            
            __strong typeof(weakSelf)strongSelf = weakSelf;
            __strong typeof(weakRequest)strongRequst = weakRequest;
            [strongSelf.requstMetricArray addObject: @{[NSString stringWithFormat:@"%@",strongRequst]:weakRequest.benchMarkMan.tastMetrics}];
            
            if (error && error.code != QCloudNetworkErrorCodeCanceled) {
                NSError* transferError = [weakSelf tranformErrorToResume:error];
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [weakSelf onError:transferError];
                if (!self.canceled) {
                    [strongSelf cancel];
                }
            } else{
                
                if(self.enableMD5Verification) {
                    
                    NSString* MD5FromeETag = [outputObject.eTag substringWithRange:NSMakeRange(1, outputObject.eTag.length-2)];
                    NSString* localMD5String = [QCloudEncrytFileOffsetMD5(body.fileURL.path, body.offset, body.sliceLength) lowercaseString];
                    if (![MD5FromeETag isEqualToString:localMD5String]) {
                        NSMutableString* errorMessageString = [[NSMutableString alloc] init];
                        [errorMessageString appendFormat:@"DataIntegrityError分片:上传过程中MD5校验与本地不一致，请检查本地文件在上传过程中是否发生了变化,建议调用删除接口将COS上的文件删除并重新上传,本地计算的 MD5 值:%@, 返回的 ETag值:%@",localMD5String,MD5FromeETag];
                        if ( [outputObject __originHTTPURLResponse__]&& [[outputObject __originHTTPURLResponse__].allHeaderFields valueForKey:@"x-cos-request-id"]!= nil) {
                            NSString* requestID = [[outputObject __originHTTPURLResponse__].allHeaderFields valueForKey:@"x-cos-request-id"];
                            [errorMessageString appendFormat:@", Request id:%@",requestID];
                        }
                        NSError* error = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeMD5NotMatch message:errorMessageString];
                        [weakSelf onError:error];
                        [weakSelf cancel];
                        return ;
                    }
                }
                
                QCloudMultipartInfo* info = [QCloudMultipartInfo new];
                info.eTag = outputObject.eTag;
                info.partNumber = [@(body.index+1) stringValue];
                [weakSelf markPartFinish:info];
                dispatch_source_merge_data(weakSelf.queueSource, 1);
            }
        }];
        
        [self.requestCacheArray addPointer:(__bridge void * _Nullable)(request)];
        QCloudLogDebug(@"分片上传 所在的uploadRequest %@: 运行的transferManager：%@ 运行的cosxmlservice：%@",self,self.transferManager,self.transferManager.cosService);
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
    complete.regionName = self.regionName;
    complete.customHeaders = [self.customHeaders mutableCopy];
    complete.retryPolicy.delegate = self;
    complete.timeoutInterval = self.timeoutInterval;
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
    __weak typeof(complete)weakRequest  = complete;
    [complete setFinishBlock:^(QCloudUploadObjectResult* outputObject, NSError *error) {
        
        __strong typeof(weakSelf)strongSelf = weakSelf;
        __strong typeof(weakRequest)strongRequst = weakRequest;
        [strongSelf.requstMetricArray addObject: @{[NSString stringWithFormat:@"%@",strongRequst]:weakRequest.benchMarkMan.tastMetrics}];
        
        if (self.requstsMetricArrayBlock) {
            self.requstsMetricArrayBlock(weakSelf.requstMetricArray);
        }
        if (error) {
            [weakSelf onError:error];
        } else {
            if ( nil != outputObject.location) {
                outputObject.location = QCloudFormattHTTPURL(outputObject.location,
                                                             weakSelf.transferManager.cosService.configuration.endpoint.useHTTPS);
            }
            [weakSelf onSuccess:outputObject];
        }
    }];
    
    [self.requestCacheArray addPointer:(__bridge void * _Nullable)(complete)];
    [self.transferManager.cosService CompleteMultipartUpload:complete];
    
}




//
+ (instancetype) requestWithRequestData:(QCloudCOSXMLUploadObjectResumeData _Nullable)resumeData
{
    QCloudCOSXMLUploadObjectRequest* request = [QCloudCOSXMLUploadObjectRequest qcloud_modelWithJSON:resumeData];
    QCloudLogDebug(@"Generating request from resume data, body is %@",request.body);
    QCloudUniversalPath* path = request.body;
    //fileURLWithPath会再次编码，所以需要一次解码
    NSString *bodyUrl =  QCloudURLDecodeUTF8([path fileURL].absoluteString);
    request.body = [NSURL URLWithString:bodyUrl];
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
    NSPointerArray *tmpRequestCacheArray = [self.requestCacheArray copy];
    for (QCloudHTTPRequest* request  in tmpRequestCacheArray) {
        if (request != nil) {
            [cancelledRequestIDs addObject:[NSNumber numberWithLongLong:request.requestID]];
        }
    }
    QCloudLogDebug(@"cancelledRequestIDs :%@",cancelledRequestIDs);
    
   [[QCloudHTTPSessionManager shareClient] cancelRequestsWithID:cancelledRequestIDs];
}
- (QCloudCOSXMLUploadObjectResumeData) cancelByProductingResumeData:(NSError *__autoreleasing *)error
{
    QCloudLogDebug(@"cancelByProductingResumeData begin");
    //延迟取消 让函数先返回
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        QCloudLogDebug(@"⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️ ：cancel");
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
                                           message:@"UnsupportOperation:无法暂停当前的上传请求，因为使用的是单次上传"];
        }
        return nil;
    }
    if (![self.body isKindOfClass:[NSURL class]]) {
        if (NULL != error) {
            *error = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeContentError
                                           message:@"UnsupportOperation:无法暂停当前的上传请求，因为使用的是非持久化存储上传"];
        }
        return nil;
    }
    if ([self finished]) {
        if (NULL != error) {
            *error = [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeAlreadyFinish
                                           message:@"AlreadyFinished:无法暂停当前的上传请求，因为该请求已经结束"];
        }
        return nil;
    }
    [_recursiveLock lock];
    NSURL* url = (NSURL*)self.body;
    QCloudUniversalPath *universalPath = [QCloudUniversalPathFactory universalPathWithURL:url];
    self.body = universalPath;
    NSData* info = [self qcloud_modelToJSONData];
    QCloudLogDebug(@"RESUME data %@",info);
    self.body = url;
    [_recursiveLock unlock];
    return info;
}

- (void) abort:(QCloudRequestFinishBlock _Nullable)finishBlock
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
            abortRequest.customHeaders = [self.customHeaders mutableCopy];
            abortRequest.object = self.object;
            abortRequest.regionName = self.regionName;
            abortRequest.bucket = self.bucket;
            abortRequest.uploadId = self.uploadId;
            abortRequest.finishBlock = finishBlock;
            abortRequest.priority = self.priority;
            abortRequest.timeoutInterval = self.timeoutInterval;
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
-(void)setCOSServerSideEncyption{
    self.enableMD5Verification = NO;
    self.customHeaders[@"x-cos-server-side-encryption"] = @"AES256";
}
-(void)setCOSServerSideEncyptionWithCustomerKey:(NSString *)customerKey{
    self.enableMD5Verification = NO;
    NSData *data = [customerKey dataUsingEncoding:NSUTF8StringEncoding];
    NSString* excryptAES256Key = [data base64EncodedStringWithOptions:0]; // base64格式的字符串
    NSString *base64md5key = QCloudEncrytNSDataMD5Base64(data);
    self.customHeaders[@"x-cos-server-side-encryption-customer-algorithm"] = @"AES256";
    self.customHeaders[@"x-cos-server-side-encryption-customer-key"] = excryptAES256Key;
    self.customHeaders[@"x-cos-server-side-encryption-customer-key-MD5"] = base64md5key;
    
}

-(void)setCOSServerSideEncyptionWithKMSCustomKey:(NSString *)customerKey jsonStr:(NSString *)jsonStr{
    self.enableMD5Verification = NO;
    self.customHeaders[@"x-cos-server-side-encryption"] = @"cos/kms";
    if(customerKey){
        self.customHeaders[@"x-cos-server-side-encryption-cos-kms-key-id"] = customerKey;
    }
    if(jsonStr){
        //先将string转换成data
        NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        self.customHeaders[@"x-cos-server-side-encryption-context"] = [data base64EncodedStringWithOptions:0];
    }
}
-(BOOL)shouldRetry:(QCloudURLSessionTaskData *)task error:(NSError *)error{
    if ([self.retryHandler.delegate respondsToSelector:@selector(shouldRetry:error:)]) {
        return [self.retryHandler.delegate shouldRetry:task error:error];
    }
    return YES;
}
-(void)setFinishBlock:(void (^_Nullable)(QCloudUploadObjectResult * _Nullable, NSError * _Nullable))QCloudRequestFinishBlock{
    [super setFinishBlock:QCloudRequestFinishBlock];
}
@end
