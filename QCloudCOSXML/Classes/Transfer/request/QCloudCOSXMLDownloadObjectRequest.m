//
//  QCloudCOSXMLDownloadObjectRequest.m
//  Pods-QCloudCOSXMLDemo
//
//  Created by karisli(李雪) on 2018/8/23.
//

#import "QCloudCOSXMLDownloadObjectRequest.h"
#import "QCloudGetObjectRequest.h"
#import "QCloudGetObjectRequest+Custom.h"
#import "QCloudCOSTransferMangerService.h"
#import "QCloudCOSXMLService+Transfer.h"
#import "QCloudHeadObjectRequest.h"
#import <QCloudCore/NSMutableData+QCloud_CRC.h>
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

#define CRC64PartLength 10 * 1024 * 1024

@interface  QCloudCOSXMLDownloadObjectRequest()
@property (nonatomic,assign)NSInteger retryCount;
//存储所有的下载请求
@property (nonatomic, strong) NSPointerArray *requestCacheArray;
@property (nonatomic, strong) dispatch_source_t queueSource;
@property (nonatomic, strong) NSURL *_Nonnull downloadingTempURL;
@property (nonatomic,strong)NSMutableDictionary * partCrc64Map;
@property (nonatomic,strong)dispatch_queue_t crcQueue;
@property (nonatomic,assign)NSInteger crc64Start;
@property (nonatomic,assign)NSInteger crc64Complete;
@property (nonatomic,strong)NSString * partCrc64Filepath;
@end
  
@implementation QCloudCOSXMLDownloadObjectRequest
#pragma clang diagnostic pop
- (void)dealloc {
    QCloudLogInfoP(@"Download",@"QCloudCOSXMLDownloadObjectRequest = %@ dealloc", self);
    if (NULL != _queueSource) {
        dispatch_source_cancel(_queueSource);
    }
}
- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.enablePartCrc64 = YES;
    self.objectKeySimplifyCheck = YES;
    _customHeaders = [NSMutableDictionary dictionary];
    _partCrc64Map = [NSMutableDictionary new];
    _requestCacheArray = [NSPointerArray weakObjectsPointerArray];
    _crcQueue = dispatch_queue_create("com.qcloud.crc64.queue", DISPATCH_QUEUE_SERIAL);
    return self;
}
- (void)fakeStart {
    if(!self.resumableDownload){
        [self startGetObject];
        return;
    }else{
        if(!self.resumableTaskFile){
            if(!self.downloadingURL){
                NSError *error =  [NSError qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                                                                                    message:@"InvalidArgument:您输入的downloadingURL不合法，请检查后使用！！"];
                if(self.finishBlock){
                    self.finishBlock(nil, error);
                    return;
                }
            }
            self.resumableTaskFile = [NSString stringWithFormat:@"%@.cosresumabletask",self.downloadingURL.relativePath];
          
        }
        QCloudHeadObjectRequest *headReq = [QCloudHeadObjectRequest new];
        headReq.bucket = self.bucket;
        headReq.payload = self.payload;
        headReq.regionName = self.regionName;
        headReq.object = self.object;
        headReq.enableQuic = self.enableQuic;
        headReq.endpoint = self.endpoint;
        headReq.networkType = self.networkType;
        [headReq setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
            if(error){
                self.finishBlock(outputObject, error);
                return;
                
            }
            BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:self.resumableTaskFile];
            NSMutableDictionary  *lowercaseStringDic = [NSMutableDictionary dictionary];
            [(NSDictionary*)outputObject enumerateKeysAndObjectsUsingBlock:^(NSString *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                [lowercaseStringDic setValue:obj forKey:key.lowercaseString];
            }];
            if (!exist) {
               [[NSFileManager defaultManager] createFileAtPath:self.resumableTaskFile contents:[NSData data] attributes:nil];
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setValue:lowercaseStringDic[@"last-modified"] forKey:@"lastModified"];
                [dic setValue:lowercaseStringDic[@"content-length"] forKey:@"contentLength"];
                [dic setValue:lowercaseStringDic[@"etag"] forKey:@"etag"];
                [dic setValue:lowercaseStringDic[@"x-cos-hash-crc64ecma"] forKey:@"crc64ecma"];
                NSError *parseError;
                if(dic){
                    NSData *info =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&parseError];
                    NSError *writeDataError;
                    [info writeToFile:self.resumableTaskFile options:0 error:&writeDataError];
                }
            }else{
                NSData *jsonData = [[NSData alloc] initWithContentsOfFile:self.resumableTaskFile];
                if(jsonData){
                    NSDictionary *dic =  [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
                    
                    //如果文件发生改变
                    if(![dic[@"contentLength"] isEqualToString:lowercaseStringDic[@"content-length"]] ||
                         ![dic[@"lastModified"] isEqualToString:lowercaseStringDic[@"last-modified"]] ||
                           ![dic[@"etag"] isEqualToString:lowercaseStringDic[@"etag"]] ||
                             ![dic[@"crc64ecma"] isEqualToString:lowercaseStringDic[@"x-cos-hash-crc64ecma"]]){
                        QCloudRemoveFileByPath(self.resumableTaskFile);
                        if (self.enablePartCrc64) {
                            self.partCrc64Map = [NSMutableDictionary new];
                            self.crc64Start = 0;
                            self.crc64Complete = 0;
                        }
                        [[NSFileManager defaultManager] createFileAtPath:self.resumableTaskFile contents:[NSData data] attributes:nil];
                        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                        [dic setValue:lowercaseStringDic[@"last-modified"] forKey:@"lastModified"];
                        [dic setValue:lowercaseStringDic[@"content-length"] forKey:@"contentLength"];
                        [dic setValue:lowercaseStringDic[@"etag"] forKey:@"etag"];
                        [dic setValue:lowercaseStringDic[@"x-cos-hash-crc64ecma"] forKey:@"crc64ecma"];
                        
                         NSError *parseError;
                         NSData *info =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&parseError];
                         NSError *writeDataError;
                         [info writeToFile:self.resumableTaskFile options:0 error:&writeDataError];
                    } else{
                        NSArray *tasks = dic[@"downloadedBlocks"];
                        self.localCacheDownloadOffset = [(NSString *)tasks.lastObject[@"to"] integerValue];
                    }
                }
            }
           
            [self startGetObject];
            
        }];
        [self.transferManager.cosService HeadObject:headReq];
      
    }
}

-(void)calculateCrc64:(NSURL *)filePath fileSize:(long long)fileSize{
    if (!filePath) {
        return;
    }
    if (!QCloudFileExist(filePath.path)) {
        return;
    }
    NSFileHandle *handler = [NSFileHandle fileHandleForReadingAtPath:filePath.path];
    [handler seekToFileOffset:self.crc64Complete];
    if (fileSize == 0) {
        fileSize = QCloudFileSize(filePath.path);
    }
    NSInteger readLength = fileSize - self.crc64Complete > CRC64PartLength ?CRC64PartLength:fileSize - self.crc64Complete;
    if (readLength == 0) {
        return;
    }
    NSData *data = [handler readDataOfLength:readLength];
    NSString * range = [NSString stringWithFormat:@"%ld-%ld",self.crc64Complete,self.crc64Complete + readLength];
    uint64_t crc64 = [[data mutableCopy] qcloud_crc64];
    [self.partCrc64Map setObject:@(crc64) forKey:range];
    QCloudLogDebugN(@"CRC64", @"calculateCrc64,partRang:%@,crc64:%ld",range,crc64);
    NSData *info =[NSJSONSerialization dataWithJSONObject:[self.partCrc64Map copy] options:NSJSONWritingPrettyPrinted error:nil];
    [info writeToFile:self.partCrc64Filepath options:0 error:nil];
}

-(uint64_t)mergePartCrc64{
    NSArray<NSString *> *sortedKeys = [self.partCrc64Map.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *key1, NSString *key2) {
        NSInteger start1 = [[[key1 componentsSeparatedByString:@"-"] firstObject] integerValue];
        NSInteger start2 = [[[key2 componentsSeparatedByString:@"-"] firstObject] integerValue];
        return [@(start1) compare:@(start2)];
    }];

    __block uint64_t mergedCRC = 0;

    [sortedKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        NSArray<NSString *> *components = [key componentsSeparatedByString:@"-"];
        if (components.count != 2) return;
        
        NSInteger start = [components[0] integerValue];
        NSInteger end = [components[1] integerValue];
        NSNumber *crcValue = self.partCrc64Map[key];
        
        uint64_t chunkLength = (uint64_t)(end - start);
        
        mergedCRC = [[NSMutableData new] qcloud_crc64ForCombineCRC1:mergedCRC CRC2:[crcValue unsignedLongLongValue] length:chunkLength];
    }];

    return mergedCRC;
}

- (uint64_t)crc64ForFileAtPath:(NSString *)filePath
                     chunkSize:(size_t)chunkSize
                        length:(size_t)length{
    // 1. 打开文件
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    if (!fileHandle) {
        return 0;
    }
    
    // 2. 获取文件大小
    unsigned long long fileSize = QCloudFileSize(filePath);
    if (length > 0) {
        fileSize = length;
    }
    
    // 3. 初始化CRC和偏移量
    uint64_t combinedCRC = 0;
    unsigned long long offset = 0;
    
    @try {
        while (offset < fileSize) {
            @autoreleasepool {
                // 4. 读取数据块
                NSUInteger remaining = (NSUInteger)(fileSize - offset);
                NSUInteger readLength = MIN(remaining, chunkSize);
                [fileHandle seekToFileOffset:offset];
                NSData *chunk = [fileHandle readDataOfLength:readLength];
                if (chunk.length == 0) break;
                
                // 5. 计算当前块CRC
                NSMutableData *mutableChunk = [chunk mutableCopy];
                uint64_t chunkCRC = [mutableChunk qcloud_crc64];
                
                // 6. 合并CRC
                if (offset == 0) {
                    combinedCRC = chunkCRC;
                } else {
                    combinedCRC = [mutableChunk qcloud_crc64ForCombineCRC1:combinedCRC
                                                                     CRC2:chunkCRC
                                                                  length:chunk.length];
                }
                
                offset += chunk.length;
            }
        }
    } @catch (NSException *exception) {
        return 0;
    } @finally {
        [fileHandle closeFile];
    }
    return combinedCRC;
}

-(void)loadLocalCrc64{
    self.crc64Start = self.localCacheDownloadOffset;
    self.crc64Complete = self.crc64Start;
}

- (void)startGetObject {
    if (self.enablePartCrc64) {
        self.partCrc64Filepath = [NSString stringWithFormat:@"%@.partcrc64",self.downloadingURL.relativePath];
    }
    QCloudLogInfoP(@"Download",@"begin download object:%@,localCacheDownloadOffset=%ld", self.object, self.localCacheDownloadOffset);
    QCloudGetObjectRequest *request = [QCloudGetObjectRequest new];
    request.objectKeySimplifyCheck = self.objectKeySimplifyCheck;
    request.trafficLimit = self.trafficLimit;
    request.payload = self.payload;
    request.customHeaders = [self.customHeaders mutableCopy];
    request.downloadingURL = self.downloadingURL;
    self.downloadingTempURL = request.downloadingTempURL;
    
    if (self.enablePartCrc64 && self.localCacheDownloadOffset > 0) {
        if (QCloudFileExist(self.partCrc64Filepath)) {
            NSData *jsonData = [[NSData alloc] initWithContentsOfFile:self.partCrc64Filepath];
            if(jsonData){
                self.partCrc64Map =  [[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil] mutableCopy];
                uint64_t saveCrc64 = [self mergePartCrc64];
                
                NSArray<NSString *> *sortedKeys = [self.partCrc64Map.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *key1, NSString *key2) {
                    NSInteger start1 = [[[key1 componentsSeparatedByString:@"-"] firstObject] integerValue];
                    NSInteger start2 = [[[key2 componentsSeparatedByString:@"-"] firstObject] integerValue];
                    return [@(start1) compare:@(start2)];
                }];
                uint64_t length = [sortedKeys.lastObject componentsSeparatedByString:@"-"].lastObject.integerValue;
                uint64_t localCrc64 = [self crc64ForFileAtPath:self.downloadingTempURL.path chunkSize:CRC64PartLength length:length];
                if (localCrc64 != saveCrc64) {
                    QCloudRemoveFileByPath(self.resumableTaskFile);
                    QCloudRemoveFileByPath(self.partCrc64Filepath);
                    self.crc64Start = 0;
                    self.crc64Complete = 0;
                    self.partCrc64Map = [NSMutableDictionary new];
                    self.localCacheDownloadOffset = 0;
                    QCloudRemoveFileByPath(self.downloadingTempURL.relativePath);
                }else{
                    [self loadLocalCrc64];
                }
            }else{
                [self loadLocalCrc64];
            }
        }else{
            [self loadLocalCrc64];
        }
    }
    
    request.localCacheDownloadOffset = self.localCacheDownloadOffset;
    request.regionName = self.regionName;
    request.enableMD5Verification = self.enableMD5Verification;
    request.versionID = self.versionID;
    __block int64_t currentTotalBytesDownload = 0;
    __weak typeof(self) weakSelf = self;
    [request setDownProcessBlock:^(int64_t bytesDownload, int64_t totalBytesDownload, int64_t totalBytesExpectedToDownload) {
        __strong typeof(weakSelf) strongSelf = self;
        if (!strongSelf) return;
        currentTotalBytesDownload = totalBytesDownload;
        int64_t _localCacheDownloadOffset = 0;
        if (strongSelf.resumeLocalProcess) {
            _localCacheDownloadOffset = strongSelf.localCacheDownloadOffset;
        }
        if(strongSelf.downProcessBlock){
            strongSelf.downProcessBlock(bytesDownload, totalBytesDownload + _localCacheDownloadOffset, totalBytesExpectedToDownload + _localCacheDownloadOffset);
        }
        if (self.enablePartCrc64) {
            const int64_t effectiveTotalDownload = totalBytesDownload + strongSelf.localCacheDownloadOffset;
            if (effectiveTotalDownload - strongSelf.crc64Start >= CRC64PartLength) {
                strongSelf.crc64Start += CRC64PartLength;
                dispatch_async(strongSelf.crcQueue, ^{
                    [strongSelf calculateCrc64:strongSelf.downloadingTempURL fileSize:0];
                    @synchronized(strongSelf) {
                        strongSelf.crc64Complete = strongSelf.crc64Start;
                    }
                });
            }
        }
    }];
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = self;
        if(strongSelf.resumableDownload){
            //如果下载失败了：保存当前的下载长度，便于下次续传
            NSData *jsonData = [[NSData alloc] initWithContentsOfFile:self.resumableTaskFile];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            if(jsonData){
                dic = [[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil] mutableCopy];
                if (dic == nil) {
                    dic = [NSMutableDictionary dictionary];
                }
            }
          
            if(error){
                if (self.enablePartCrc64) {
                    [self calculateCrc64:self.downloadingTempURL fileSize:currentTotalBytesDownload + strongSelf.localCacheDownloadOffset];
                }
                NSMutableArray *tasks = [dic[@"downloadedBlocks"] mutableCopy];
                if(!tasks){
                    tasks = [NSMutableArray array];
                }
                NSString *fromStr = [NSString stringWithFormat:@"%lld",strongSelf.localCacheDownloadOffset];
                NSString *toStr = [NSString stringWithFormat:@"%lld",currentTotalBytesDownload + strongSelf.localCacheDownloadOffset];
                [tasks addObject:@{@"from":fromStr,@"to":toStr}];
                [dic setValue: [tasks copy] forKey:@"downloadedBlocks"];
                NSError *parseError;
                NSData *info =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&parseError];
                NSError *writeDataError;
                if(info && !parseError){
                    [info writeToFile:strongSelf.resumableTaskFile options:0 error:&writeDataError];
                }
                
                if(writeDataError){
                    error = writeDataError;
                }
                if(self.finishBlock && error.code != QCloudNetworkErrorCodeCanceled){
                    strongSelf.finishBlock(outputObject, error);
                }
            }else{
                //下载完成之后如果没有crc64，删除记录文件
                if(!dic[@"crc64ecma"]){
                    QCloudRemoveFileByPath(strongSelf.resumableTaskFile);
                    QCloudRemoveFileByPath(strongSelf.partCrc64Filepath);
                    if(self.finishBlock){
                        strongSelf.finishBlock(outputObject, error);
                    }
                    return;
                }
                QCloudRemoveFileByPath(strongSelf.resumableTaskFile);
                uint64_t localCrc64;
                if (self.enablePartCrc64 == YES) {
                    [self calculateCrc64:self.downloadingURL fileSize:0];
                    localCrc64 = [self mergePartCrc64];
                    
                    NSString *localCrc64Str = [NSString stringWithFormat:@"%llu",localCrc64];
                    QCloudRemoveFileByPath(strongSelf.partCrc64Filepath);
                    if(![localCrc64Str isEqualToString:dic[@"crc64ecma"]]){
                        //下载完成之后如果crc64不一致，删除记录文件和已经下载的文件，重新开始下载
                        self.crc64Start = 0;
                        self.crc64Complete = 0;
                        self.partCrc64Map = [NSMutableDictionary new];
                        self.localCacheDownloadOffset = 0;
                        if (self.retryCount >= 3) {
                            NSString * message = [NSString stringWithFormat:@"本地文件与远端文件不一致，请重新下载：远端CRC64 值:%@, 本地文件 CRC64值:%@",
                             dic[@"crc64ecma"], localCrc64Str];
                            strongSelf.finishBlock(nil, [NSError errorWithDomain:kQCloudNetworkDomain code:QCloudNetworkErrorCodeNotMatch userInfo:@{NSLocalizedDescriptionKey:message}]);
                            return;
                        }else{
                            QCloudRemoveFileByPath(strongSelf.downloadingURL.relativePath);
                            self.retryCount ++;
                            [self fakeStart];
                        }
                        return;
                    }
                }
                if(self.finishBlock){
                    strongSelf.finishBlock(outputObject, error);
                }
            }
        }else{
            if(self.finishBlock){
                strongSelf.finishBlock(outputObject, error);
            }
        }
     
    }];
 
    
    request.responseContentType = self.responseContentType;
    request.responseContentLanguage = self.responseContentLanguage;
    request.responseContentExpires = self.responseContentExpires;
    request.responseCacheControl = self.responseCacheControl;
    request.responseContentDisposition = self.responseContentDisposition;
    request.responseContentEncoding = self.responseContentEncoding;
    request.range = self.range;
    request.ifModifiedSince = self.ifModifiedSince;
    request.ifUnmodifiedModifiedSince = self.ifUnmodifiedModifiedSince;
    request.ifMatch = self.ifMatch;
    request.ifNoneMatch = self.ifNoneMatch;
    request.object = self.object;
    request.bucket = self.bucket;
    request.enableQuic = self.enableQuic;
    request.endpoint = self.endpoint;
    request.networkType = self.networkType;
    [self.transferManager.cosService GetObject:request];
    [self.requestCacheArray addPointer:(__bridge void *_Nullable)(request)];
}



-(void)cancel{
    [self.requestCacheArray addPointer:(__bridge void *_Nullable)([NSObject new])];
    [self.requestCacheArray compact];
    if (NULL != _queueSource) {
        dispatch_source_cancel(_queueSource);
    }

    NSMutableArray *cancelledRequestIDs = [NSMutableArray array];
    NSPointerArray *tmpRequestCacheArray = [self.requestCacheArray copy];
    for (QCloudHTTPRequest *request in tmpRequestCacheArray) {
        if (request != nil) {
            [cancelledRequestIDs addObject:[NSNumber numberWithLongLong:request.requestID]];
            [request cancel];
        }
    }

    [[QCloudHTTPSessionManager shareClient] cancelRequestsWithID:cancelledRequestIDs];
    [super cancel];
}
- (void)setCOSServerSideEncyption {
    self.customHeaders[@"x-cos-server-side-encryption"] = @"AES256";
}

- (void)setCOSServerSideEncyptionWithCustomerKey:(NSString *)customerKey {
    NSData *data = [customerKey dataUsingEncoding:NSUTF8StringEncoding];
    NSString *excryptAES256Key = [data base64EncodedStringWithOptions:0]; // base64格式的字符串
    NSString *base64md5key = QCloudEncrytNSDataMD5Base64(data);
    self.customHeaders[@"x-cos-server-side-encryption-customer-algorithm"] = @"AES256";
    self.customHeaders[@"x-cos-server-side-encryption-customer-key"] = excryptAES256Key;
    self.customHeaders[@"x-cos-server-side-encryption-customer-key-MD5"] = base64md5key;
}
@end
