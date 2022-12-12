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
@interface  QCloudCOSXMLDownloadObjectRequest()
//存储所有的下载请求
@property (nonatomic, strong) NSPointerArray *requestCacheArray;
@property (nonatomic, strong) dispatch_source_t queueSource;
@end
  
@implementation QCloudCOSXMLDownloadObjectRequest
#pragma clang diagnostic pop
- (void)dealloc {
    QCloudLogInfo(@"QCloudCOSXMLUploadObjectRequest = %@ dealloc", self);
    if (NULL != _queueSource) {
        dispatch_source_cancel(_queueSource);
    }
}
- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    _customHeaders = [NSMutableDictionary dictionary];
    _requestCacheArray = [NSPointerArray weakObjectsPointerArray];
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

    
- (void)startGetObject {
    
    QCloudGetObjectRequest *request = [QCloudGetObjectRequest new];
    request.trafficLimit = self.trafficLimit;
    request.payload = self.payload;
    request.customHeaders = [self.customHeaders copy];
    request.downloadingURL = self.downloadingURL;
    request.localCacheDownloadOffset = self.localCacheDownloadOffset;
    request.regionName = self.regionName;
    request.enableMD5Verification = self.enableMD5Verification;
    request.versionID = self.versionID;
    __block int64_t currentTotalBytesDownload = 0;
    __weak typeof(self) weakSelf = self;
    [request setDownProcessBlock:^(int64_t bytesDownload, int64_t totalBytesDownload, int64_t totalBytesExpectedToDownload) {
        __strong typeof(weakSelf) strongSelf = self;
        currentTotalBytesDownload = totalBytesDownload;
        QCloudLogInfo(@"🔽🔽🔽🔽🔽downProcess %lld %lld %ld",bytesDownload,totalBytesDownload,totalBytesExpectedToDownload);
        if(strongSelf.downProcessBlock){
            strongSelf.downProcessBlock(bytesDownload, totalBytesDownload, totalBytesExpectedToDownload);
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
            }
          
            if(error){
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
                    if(self.finishBlock){
                        strongSelf.finishBlock(outputObject, error);
                    }
                    return;
                }
                //计算文件的CRC64
                uint64_t localCrc64 = [[[NSMutableData alloc] initWithContentsOfFile:strongSelf.downloadingURL.relativePath] qcloud_crc64];
                NSString *localCrc64Str = [NSString stringWithFormat:@"%llu",localCrc64];
                QCloudRemoveFileByPath(strongSelf.resumableTaskFile);
                if(![localCrc64Str isEqualToString:dic[@"crc64ecma"]]){
                    //下载完成之后如果crc64不一致，删除记录文件和已经下载的文件，重新开始下载
                    QCloudRemoveFileByPath(strongSelf.downloadingURL.relativePath);
                    [self fakeStart];
                    return;
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
    
    [self.transferManager.cosService GetObject:request];
    [self.requestCacheArray addPointer:(__bridge void *_Nullable)(request)];
}

-(void)cancel{
    [super cancel];
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
