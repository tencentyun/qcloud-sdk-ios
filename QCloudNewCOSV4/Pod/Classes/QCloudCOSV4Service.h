//
//  QCloudCOSV4Service.h
//  QCloudCOSV4Service
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

@class QCloudCreateDirectoryRequest;
@class QCloudListDirectoryRequest;
@class QCloudUpdateDirectoryAttributesRequest;
@class QCloudDirectoryAttributesRequest;
@class QCloudDeleteDirectoryRequest;
@class QCloudUploadObjectSimpleRequest;
@class QCloudMoveFileRequest;
@class QCloudFileAttributesRequest;
@class QCloudUpdateFileAttributesRequest;
@class QCloudDeleteFileRequest;
@class QCloudCopyFileRequest;
@class QCloudListUploadSliceRequest;
@class QCloudDownloadFileRequest;

@interface QCloudCOSV4Service : QCloudService

#pragma hidden super selectors
- (int) performRequest:(QCloudBizHTTPRequest *)httpRequst withFinishBlock:(QCloudRequestFinishBlock)block NS_UNAVAILABLE;

#pragma Factory
+ (QCloudCOSV4Service*) defaultCOSV4;
+ (QCloudCOSV4Service*) cosv4ServiceForKey:(NSString*)key;
+ (QCloudCOSV4Service*) registerDefaultCOSV4WithConfiguration:(QCloudServiceConfiguration*)configuration;
+ (QCloudCOSV4Service*) registerCOSV4WithConfiguration:(QCloudServiceConfiguration*)configuration withKey:(NSString*)key;

- (void) CreateDirectory:(QCloudCreateDirectoryRequest*)request;
- (void) ListDirectory:(QCloudListDirectoryRequest*)request;
- (void) UpdateDirectoryAttributes:(QCloudUpdateDirectoryAttributesRequest*)request;
- (void) DirectoryAttributes:(QCloudDirectoryAttributesRequest*)request;
- (void) DeleteDirectory:(QCloudDeleteDirectoryRequest*)request;
- (void) UploadObjectSimple:(QCloudUploadObjectSimpleRequest*)request;
- (void) MoveFile:(QCloudMoveFileRequest*)request;
- (void) FileAttributes:(QCloudFileAttributesRequest*)request;
- (void) UpdateFileAttributes:(QCloudUpdateFileAttributesRequest*)request;
- (void) DeleteFile:(QCloudDeleteFileRequest*)request;
- (void) CopyFile:(QCloudCopyFileRequest*)request;
- (void) ListUploadSlice:(QCloudListUploadSliceRequest*)request;
- (void) DownloadFile:(QCloudDownloadFileRequest*)request;
@end
