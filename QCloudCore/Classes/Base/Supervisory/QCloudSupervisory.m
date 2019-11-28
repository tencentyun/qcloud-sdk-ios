//
//  QCloudSupervisory.m
//  Pods
//
//  Created by Dong Zhao on 2017/4/7.
//
//

#import "QCloudSupervisory.h"
#import "QCloudSupervisorySession.h"
#import "QcloudObjectModel.h"
#import "QCloudSupervisoryRecord.h"
#import "QCloudHTTPRequest.h"
#import "QCloudFileUtils.h"
#import "QCloudBizHTTPRequest.h"

#import <CFNetwork/CFNetwork.h>
#import <arpa/inet.h>
#if TARGET_OS_IOS
#import <UIKit/UIKit.h>
#endif

@interface QCloudSupervisory ()
{
    QCloudSupervisorySession* _activeSession;
    dispatch_queue_t _readWriteQueue;
    NSMutableDictionary* _hostIps;
}
@property (nonatomic, strong, readonly) NSString* supervisoryLogFilePath;
@property (atomic, assign) BOOL uploading;
@end

@implementation QCloudSupervisory
+ (QCloudSupervisory*)supervisory
{
    static QCloudSupervisory* share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [QCloudSupervisory new];
    });
    return share;
}

- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _hostIps = [NSMutableDictionary new];
    _readWriteQueue = dispatch_queue_create("com.tencent.supervisory.log", DISPATCH_QUEUE_CONCURRENT);
#if TARGET_OS_IOS
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEnterForground) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTerminal) name:UIApplicationWillTerminateNotification object:nil];
#endif
    [self alternateActiveSession];
    [self handleEnterForground];
    _uploading = NO;
    return self;
}

- (NSString*) supervisoryLogFilePath
{
    NSString* path = QCloudApplicationLibaryPath();
    path = QCloudPathJoin(path, @"Caches");
    path = QCloudPathJoin(path, @"com.tencent.qcloud.supervisory");
    QCloudEnsurePathExist(path);
    NSString* filePath =  QCloudPathJoin(path, @"supervisory.log");
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:[NSData data] attributes:nil];
    }
    return filePath;
}

- (void) handleTerminal
{
    [self alternateActiveSession];
}

- (void) handleEnterForground
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self tryUpload];
    });
}

- (void) handleEnterBackground
{
    [self alternateActiveSession];
}

- (void) alternateActiveSession
{
    if (!_activeSession) {
        _activeSession = [[QCloudSupervisorySession alloc] init];
    } else {
        __block QCloudSupervisorySession* oldSession;
        dispatch_barrier_async(_readWriteQueue, ^{
            oldSession = self->_activeSession;
            [self->_activeSession markFinish];
            self->_activeSession = [[QCloudSupervisorySession alloc] init];
            self->_activeSession.ips = [self->_hostIps copy];
            [self flushSession:oldSession];
        });

    }
}

- (void) record:(QCloudSupervisoryRecord*)record
{
    // deal lock warning by ericcheung
    dispatch_barrier_sync(_readWriteQueue, ^{
        if (!_activeSession) {
            [self alternateActiveSession];
        }
        [_activeSession appendRecord:record];
    });
}

- (void) recordRequest:(QCloudHTTPRequest *)request error:(NSError*)error
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        QCloudSupervisoryNetworkRecord* record = [QCloudSupervisoryNetworkRecord new];
        record.taskTookTime = [request.benchMarkMan costTimeForKey:kTaskTookTime];
        record.calculateMD5STookTime = [request.benchMarkMan costTimeForKey:kCalculateMD5STookTime];
         record.signRequestTookTime = [request.benchMarkMan costTimeForKey:kSignRequestTookTime];
        record.dnsLookupTookTime = [request.benchMarkMan costTimeForKey:kDnsLookupTookTime];
        record.connectTookTime = [request.benchMarkMan costTimeForKey:kConnectTookTime];
        record.secureConnectTookTime = [request.benchMarkMan costTimeForKey:kSecureConnectTookTime];
        record.writeRequestBodyTookTime = [request.benchMarkMan costTimeForKey:kWriteRequestBodyTookTime];
        record.readResponseHeaderTookTime = [request.benchMarkMan costTimeForKey:kReadResponseHeaderTookTime];
        record.readResponseBodyTookTime = [request.benchMarkMan costTimeForKey:kReadResponseBodyTookTime];
        NSString* host = nil;
        for (NSString* key  in request.requestData.httpHeaders.allKeys) {
            if ([key.lowercaseString isEqualToString:@"host"]) {
                host = request.requestData.httpHeaders[key];
            }
        }
        [self tryMonitorIPForHost:host];
        if (!host) {
            host = request.requestData.serverURL;
        }
        record.service = host;
        
        NSString* method = request.requestData.URIMethod;
        if (method.length == 0) {
            method = request.requestData.allParamters[@"op"];
        }
        record.method = method;
        record.networkStatus = [QCloudNetEnv shareEnv].currentNetStatus;
        if (error) {
            record.errorCode = (int)error.code;
            record.errorMessage = error.localizedDescription;
        }
        record.userAgent = [request.requestData.httpHeaders objectForKey:HTTPHeaderUserAgent];
        
        [self record:record];
    });
}

- (void) flushSession:(QCloudSupervisorySession*)session
{
    if (session.records.count == 0) {
        return;
    }
    NSMutableData* data = [[session qcloud_modelToJSONData] mutableCopy];
    if (data) {
        NSFileHandle* fileHandler = [NSFileHandle fileHandleForWritingAtPath:self.supervisoryLogFilePath];
        [data appendData:[@"\n#sss884hjksdhfjasdf\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandler seekToEndOfFile];
        [fileHandler writeData:data];
        [fileHandler closeFile];
    }
}

- (void) tryUpload
{
    if (self.uploading) {
        return;
    }
    if (QCloudFileSize(self.supervisoryLogFilePath) > 500*1024) {
        [self forceUploadLogs];
    }
}
- (void) forceUploadLogs
{
    self.uploading = YES;
    
}
- (void) deleteOldLog
{
    dispatch_barrier_sync(_readWriteQueue, ^{
        QCloudRemoveFileByPath(self.supervisoryLogFilePath);
    });
}


- (void) tryMonitorIPForHost:(NSString*)host
{
    if (!host) {
        return;
    }
    
    dispatch_async(_readWriteQueue, ^{
        NSString* existIPs = self->_hostIps[host];
        if (!existIPs) {
            dispatch_barrier_async(self->_readWriteQueue, ^{
                [self lookupDnsIp:host];
            });
        }
    });
}
- (void) lookupDnsIp:(NSString*)host
{
    Boolean result;
    CFHostRef hostRef;
    NSArray *addresses;
    NSString *hostname = @"apple.com";
    hostRef = CFHostCreateWithName(kCFAllocatorDefault, (__bridge CFStringRef)hostname);
    result = CFHostStartInfoResolution(hostRef, kCFHostAddresses, NULL); // pass an error instead of NULL here to find out why it failed
    if (result == TRUE) {
        addresses = (__bridge NSArray*)CFHostGetAddressing(hostRef, &result);
        NSMutableArray* ips = [NSMutableArray new];
        [addresses enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *strDNS = [NSString stringWithUTF8String:inet_ntoa(*((__bridge struct in_addr *)obj))];
            [ips addObject:strDNS];
        }];
        NSArray* dnsips = [[NSSet setWithArray:ips] allObjects];
        _hostIps[host] = dnsips;
        _activeSession.ips = [_hostIps copy];
    } else {
        NSLog(@"Not resolved");
    }
    CFRelease(hostRef);
}
@end
