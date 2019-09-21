//
//  COSV4.m
//  COSV4
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


#import "QCloudCOSV4Service.h"
#import "QCloudCOSV4Service+Configuration.h"
#import "QCloudCOSV4Service+Private.h"
#import "QCloudThreadSafeMutableDictionary.h"
#import "QCloudError.h"

#import "QCloudCreateDirectoryRequest.h"
#import "QCloudListDirectoryRequest.h"
#import "QCloudUpdateDirectoryAttributesRequest.h"
#import "QCloudDirectoryAttributesRequest.h"
#import "QCloudDeleteDirectoryRequest.h"
#import "QCloudUploadObjectSimpleRequest.h"
#import "QCloudUploadSliceInitRequest.h"
#import "QCloudUploadSliceDataRequest.h"
#import "QCloudUploadSliceFinishRequest.h"
#import "QCloudUploadSliceListRequest.h"
#import "QCloudMoveFileRequest.h"
#import "QCloudFileAttributesRequest.h"
#import "QCloudUpdateFileAttributesRequest.h"
#import "QCloudDeleteFileRequest.h"
#import "QCloudCopyFileRequest.h"
#import "QCloudListUploadSliceRequest.h"
#import "QCloudDownloadFileRequest.h"
QCloudThreadSafeMutableDictionary* QCloudCOSV4ServiceCache()
{
    static QCloudThreadSafeMutableDictionary* Cloudcosv4Service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Cloudcosv4Service = [QCloudThreadSafeMutableDictionary new];
    });
    return Cloudcosv4Service;
}

@implementation QCloudCOSV4Service
static QCloudCOSV4Service* COSV4Service = nil;


+ (QCloudCOSV4Service*) defaultCOSV4
{
    @synchronized (self) {
        if (!COSV4Service) {
            @throw [NSException exceptionWithName:QCloudErrorDomain reason:@"您没有配置默认的OCR服务配置，请配置之后再调用该方法" userInfo:nil];
        }
        return COSV4Service;
    }
}

+ (QCloudCOSV4Service*) registerDefaultCOSV4WithConfiguration:(QCloudServiceConfiguration*)configuration
{
    @synchronized (self) {
        COSV4Service = [[QCloudCOSV4Service alloc] initWithConfiguration:configuration];
    }
    return COSV4Service;
}

+ (QCloudCOSV4Service*) cosv4ServiceForKey:(NSString*)key
{
    QCloudCOSV4Service* cosv4Service = [QCloudCOSV4ServiceCache() objectForKey:key];
    if (!cosv4Service) {
        @throw [NSException exceptionWithName:QCloudErrorDomain reason:[NSString stringWithFormat:@"您没有配置Key为%@的OCR服务配置，请配置之后再调用该方法", key] userInfo:nil];
    }
    return cosv4Service;
}

+ (QCloudCOSV4Service*) registerCOSV4WithConfiguration:(QCloudServiceConfiguration*)configuration withKey:(NSString*)key;
{
    QCloudCOSV4Service* cosv4Service =[[QCloudCOSV4Service alloc] initWithConfiguration:configuration];
    [QCloudCOSV4ServiceCache() setObject:cosv4Service  forKey:key];
    return cosv4Service;
}

- (void) CreateDirectory:(QCloudCreateDirectoryRequest*)request
{
    [super performRequest:request];
}
- (void) ListDirectory:(QCloudListDirectoryRequest*)request
{
    [super performRequest:request];
}
- (void) UpdateDirectoryAttributes:(QCloudUpdateDirectoryAttributesRequest*)request
{
    [super performRequest:request];
}
- (void) DirectoryAttributes:(QCloudDirectoryAttributesRequest*)request
{
    [super performRequest:request];
}
- (void) DeleteDirectory:(QCloudDeleteDirectoryRequest*)request
{
    [super performRequest:request];
}
- (void) UploadObjectSimple:(QCloudUploadObjectSimpleRequest*)request
{
    [super performRequest:request];
}
- (void) MoveFile:(QCloudMoveFileRequest*)request
{
    [super performRequest:request];
}
- (void) FileAttributes:(QCloudFileAttributesRequest*)request
{
    [super performRequest:request];
}
- (void) UpdateFileAttributes:(QCloudUpdateFileAttributesRequest*)request
{
    [super performRequest:request];
}
- (void) DeleteFile:(QCloudDeleteFileRequest*)request
{
    [super performRequest:request];
}
- (void) CopyFile:(QCloudCopyFileRequest*)request
{
    [super performRequest:request];
}
- (void) ListUploadSlice:(QCloudListUploadSliceRequest*)request
{
    [super performRequest:request];
}
- (void) DownloadFile:(QCloudDownloadFileRequest*)request
{
    [super performRequest:request];
}


@end
