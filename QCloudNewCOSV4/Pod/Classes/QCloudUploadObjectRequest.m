//
//  QCloudUploadObjectRequest.m
//  Pods
//
//  Created by Dong Zhao on 2017/3/9.
//
//

#import "QCloudUploadObjectRequest.h"
#import "QCloudFileUtils.h"
#import "QCloudLogger.h"
#import "QCloudUploadSliceInitRequest.h"
#import "QCloudUploadSliceDataRequest.h"
#import "QCloudUploadSliceFinishRequest.h"
#import "QCloudUploadSliceInitResult.h"
#import "QCloudUploadSliceDataRequest.h"
#import "QCloudUploadSliceListResult.h"
#import "QCloudUploadSliceListRequest.h"
#import "QCloudUploadSliceFinishRequest.h"
#import "QCloudUploadObjectSimpleRequest.h"
#import "QCloudUploadObjectRequest_Private.h"
#import "QCloudCOSV4Service.h"
#import <QCloudCore/QCloudCore.h>
int64_t const kQCloudUploadSliceDefaultSize = 1024*1024;

@interface QCloudUploadObjectRequest ()
@property (nonatomic, strong) NSArray<QCloudSHAPart*>* fileSHAParts;
@property (nonatomic, strong) QCloudSHAPart* fileSHA;
//
@property (nonatomic, strong) NSString* session;
@property (nonatomic, strong) dispatch_source_t queueSource;
@property (nonatomic, assign) uint64_t fileSize;
@property (nonatomic, assign) int64_t totalBytesSent;
@property (nonatomic, assign, readonly)    int64_t sliceSize;
@property (nonatomic, strong) NSArray* subRequests;
@end

@implementation QCloudUploadObjectRequest

- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _sliceSize = kQCloudUploadSliceDefaultSize;
    return self;
}



- (void) simpleSend
{
    QCloudUploadObjectSimpleRequest* fackRequest = [QCloudUploadObjectSimpleRequest new];
    fackRequest.bucket = self.bucket;
    fackRequest.directory  = self.directory;
    fackRequest.fileName = self.fileName;
    
    fackRequest.filePath = self.filePath;
    fackRequest.bizAttribute = self.bizAttribute;
    fackRequest.insertOnly = self.insertOnly;
    fackRequest.sendProcessBlock = self.sendProcessBlock;
    __weak typeof(self) weakSelf = self;
    [fackRequest setFinishBlock:^(QCloudUploadObjectResult * _Nonnull result, NSError * _Nonnull error) {
        if (error) {
            [weakSelf onError:error];
        } else {
            [weakSelf onSuccess:result];
        }
    }];
    self.subRequests = @[fackRequest];
    [self.runOnService performRequest:fackRequest];
}


- (void) startMultiPartSend
{
    _fileSize = QCloudFileSize(_filePath);
    NSArray* shas = QCloudIncreaseFileSHAData(self.filePath, self.sliceSize);
    NSArray<QCloudSHAPart*>* middleSHAs = [shas subarrayWithRange:NSMakeRange(0, (int)shas.count-1)];
    QCloudSHAPart* fileSHA = shas.lastObject;
    if (middleSHAs.count > 0) {
        [[middleSHAs lastObject] setDatasha:fileSHA.datasha];
    }
    //
    self.fileSHAParts = middleSHAs;
    self.fileSHA = fileSHA;
    [self.benchMarkMan directSetCost:QCloudFileSize(self.filePath) forKey:kRNBenchmarkSizeRequeqstBody];
    //
    QCloudUploadSliceInitRequest* request = [QCloudUploadSliceInitRequest new];
    request.sliceSize = self.sliceSize;
    request.sha = fileSHA.datasha;
    request.fileSize = fileSHA.datalen;
    request.uploadParts = middleSHAs;
    
    request.bucket = self.bucket;
    request.directory = self.directory;
    request.fileName = self.fileName;
    
    //
    __weak typeof(self) weakSelf = self;
    [request setFinishBlock:^(QCloudUploadSliceInitResult * _Nonnull outputObject, NSError * _Nonnull error) {
        if (weakSelf.canceled) {
            return ;
        }
        weakSelf.session = outputObject.session;
        if (error) {
            if (error.code == -4019) {
                [self listContinueUploadRestParts];
            } else {
                [weakSelf onError:error];
            }
        } else {
            if (outputObject.accessURL.length) {
                [weakSelf onSuccess:outputObject];
            } else {
                [weakSelf fireUploadFileData];
            }
        }
    }];
    self.subRequests = @[request];
    [self.runOnService performRequest:request];
}
- (void) start
{
    [self.benchMarkMan benginWithKey:kRNBenchmarkRTT];
    self.totalBytesSent = 0;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        if (QCloudFileSize(self.filePath) <= 1*1024*1024) {
            [self simpleSend];
        } else {
            [self startMultiPartSend];
        }
    });
}

- (void) listContinueUploadRestParts
{
    __weak typeof(self) weakSelf = self;
    QCloudUploadSliceListRequest* list =[QCloudUploadSliceListRequest new];
    list.bucket = self.bucket;
    list.directory = self.directory;
    list.fileName = self.fileName;
    
    [list setFinishBlock:^(QCloudUploadSliceListResult * _Nonnull result, NSError * _Nonnull error) {
        if (weakSelf.canceled) {
            return ;
        }
        if (error) {
            [weakSelf onError:error];
        } else {
            [weakSelf continueUploadRestParts:result];
        }
    }];
    self.subRequests = @[list];
    [self.runOnService performRequest:list];
}

- (void) continueUploadRestParts:(QCloudUploadSliceListResult*)listResult
{
    NSMutableIndexSet* set = [NSMutableIndexSet indexSet];
    for (QCloudUploadSliceInfo* slice in listResult.existSlices) {
        [set addIndex:slice.offset];
    }
    NSArray* restParts = [[self.fileSHAParts copy] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(QCloudSHAPart*  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return ![set containsIndex:evaluatedObject.offset];
    }]];
    self.session = listResult.session;
    [self uploadPart:restParts];
}

- (void) finishUpload
{
    __weak typeof(self) weakSelf = self;
    QCloudUploadSliceFinishRequest* finish = [QCloudUploadSliceFinishRequest new];
    finish.bucket = self.bucket;
    finish.directory = self.directory;
    finish.fileName = self.fileName;
    
    finish.session = self.session;
    finish.filesize = (int64_t)self.fileSize;
    finish.sha = self.fileSHA.datasha;
    [finish setFinishBlock:^(QCloudUploadSliceFinishResult * _Nonnull result, NSError * _Nonnull error) {
        if (weakSelf.canceled) {
            return ;
        }
        if (error) {
            [weakSelf onError:error];
        } else {
            [weakSelf onSuccess:result];
        }
    }];
    self.subRequests = @[finish];
    [self.runOnService performRequest:finish];

}
- (void) fireUploadFileData
{
    [self uploadPart:self.fileSHAParts];
}

- (void) part:(QCloudSHAPart*)part  didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
        self.totalBytesSent += bytesSent;
        if (self.sendProcessBlock) {
            self.sendProcessBlock(bytesSent, self.totalBytesSent, self.fileSize);
        }
}

- (void) uploadPart:(NSArray*)fileParts
{
    __weak typeof(self) weakSelf = self;
    _queueSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0));
    __block int totalComplete = 0;
    dispatch_source_set_event_handler(_queueSource, ^{
        NSUInteger value = dispatch_source_get_data(weakSelf.queueSource);
        @synchronized (weakSelf) {
            totalComplete += value;
        }
        if (totalComplete == fileParts.count) {
            [weakSelf finishUpload];
        }
    });
    dispatch_resume(_queueSource);
    NSMutableArray* requests = [NSMutableArray new];
    for (QCloudSHAPart* part in fileParts) {
        @autoreleasepool {
        QCloudUploadSliceDataRequest* dataRequest = [QCloudUploadSliceDataRequest new];
        dataRequest.sha = self.fileSHA.datasha;
        dataRequest.offset = part.offset;
        dataRequest.sliceLength = part.datalen;
        dataRequest.localPath = self.filePath;
        
        dataRequest.fileName = self.fileName;
        dataRequest.directory = self.directory;
        dataRequest.bucket = self.bucket;
        dataRequest.session = self.session;
        dataRequest.fileLength = self.fileSize;
        
        [dataRequest setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            int64_t realBytesSent = 0;
            int64_t redundantPartSize = totalBytesExpectedToSend - part.datalen;
            if (totalBytesSent - bytesSent< redundantPartSize && totalBytesSent>=redundantPartSize ) {
                realBytesSent = bytesSent - redundantPartSize;
                [weakSelf part:part didSendBodyData:realBytesSent totalBytesSent:totalBytesSent totalBytesExpectedToSend:totalBytesExpectedToSend];
            } else {
                [weakSelf part:part didSendBodyData:bytesSent totalBytesSent:totalBytesSent totalBytesExpectedToSend:totalBytesExpectedToSend];
            }
        }];
        
        [dataRequest setFinishBlock:^(QCloudUploadSliceResult* outputObject, NSError *error) {
            if (weakSelf.canceled) {
                return ;
            }
            if (error) {
                [weakSelf onError:error];
                if (_queueSource) {
                dispatch_source_cancel(weakSelf.queueSource);
                }
                QCloudLogError(@"上传分片失败%@",error);
                return ;
            }
            dispatch_source_merge_data(weakSelf.queueSource, 1);
        }];
        [requests addObject:dataRequest];
        
        [self.runOnService performRequest:dataRequest];
        }
    }
    self.subRequests = requests;
}

- (void) cancel
{
    [super cancel];
    QCloudCOSV4Service* service = (QCloudCOSV4Service*)self.runOnService;
//    [service.uploadFileQueue cancelByRequestID:self.requestID];
    for (QCloudBizHTTPRequest* request  in self.subRequests) {
        [request cancel];
    }
    if (_queueSource) {
        dispatch_source_cancel(_queueSource);
    }
}


@end
