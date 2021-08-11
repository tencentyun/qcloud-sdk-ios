//
//  QualityDataUploader.m
//  QCloudCOSXML
//
//  Created by erichmzhang(张恒铭) on 2018/8/23.
//

#import "QualityDataUploader.h"
#import <QCloudCore/QCloudCore.h>
#import <QCloudCore/QCloudAbstractRequest.h>
#import <QCloudCore/QCloudHttpMetrics.h>
#import <QCloudCore/QCloudFileUtils.h>
#import "QCloudCoreVersion.h"
#import "NSError+QCloudNetworking.h"
#define SuppressPerformSelectorLeakWarning(Stuff)                                                                   \
    do {                                                                                                            \
        _Pragma("clang diagnostic push") _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") Stuff; \
        _Pragma("clang diagnostic pop")                                                                             \
    } while (0)

#define kUploadEvents \
    @[@"QCloudCOSXMLUploadObjectRequest", @"QCloudPutObjectRequest", @"QCloudInitiateMultipartUploadRequest", @"QCloudUploadPartRequest", @"QCloudCompleteMultipartUploadRequest" ]
#define kDownloadEvents @[ @"QCloudGetObjectRequest" ]
#define kCopyEvents                                                                                             \
    @[                                                                                                          \
        @"QCloudCOSXMLCopyObjectRequest",@"QCloudInitiateMultipartUploadRequest", @"QCloudPutObjectCopyRequest", @"QCloudUploadPartCopyRequest", \
        @"QCloudCompleteMultipartUploadRequest"                                                                 \
    ]

#define kAdvancedEvents @[ @"QCloudCOSXMLUploadObjectRequest", @"QCloudCOSXMLCopyObjectRequest" ]

NSString *const kQCloudUploadAppDebugKey = @"LOGDEBUGKEY00247";

NSString *const kQCloudUploadAppReleaseKey = @"0AND0VEVB24UBGDU";


#pragma mark -commen key
NSString *const kQCloudQualitySDKVersionKey = @"cossdk_version";
NSString *const kQCloudQualitySDKVersionCodeKey = @"cossdk_version_code";
NSString *const kQCloudQualityBundleIDKey = @"boundle_id";
NSString *const kQCloudQualityAppNameKey = @"app_name";
NSString *const kQCloudQualityNetworkTypeKey = @"network_type";
NSString *const kQCloudQualityResultKey = @"result";
NSString *const kQCloudQualityTookTimeKey = @"took_time";
NSString *const kQCloudQualityRegionKey = @"region";
NSString *const kQCloudQualityAuthSourceKey = @"auth_source";
NSString *const kQCloudQualityRequestNameKey = @"name";
NSString *const kQCloudSizeKey = @"size";

#pragma mark -error key
 NSString *const kQCloudQualityErrorCodeKey = @"error_code";
 NSString *const kQCloudQualityErrorMessageKey = @"error_message";
 NSString *const kQCloudQualityErrorNameKey = @"error_name";
 NSString *const kQCloudQualityErrorServiceNameKey = @"error_service_name";
 NSString *const kQCloudQualityErrorStatusCodeKey = @"error_status_code";
 NSString *const kQCloudQualityErrorTypeKey = @"error_type";
 NSString *const kQCloudQualityErrorIDKey = @"error_request_id";
NSString *const kQCloudQualityErrorCodeServerName = @"Server";
NSString *const kQCloudQualityErrorCodeClientName = @"Client";
#pragma mark -error base
 NSString *const kQCloudQualityAccelerateKey = @"accelerate"; // Y || N
 NSString *const kQCloudQualityRequestHostKey = @"host";
NSString *const kQCloudQualityRequestPathKey = @"request_path";
 NSString *const kQCloudQualityRequestHttpConnectKey = @"http_connect";
 NSString *const kQCloudQualityHTTPDNSKey = @"http_dns";
 NSString *const kQCloudQualityHTTPFullKey = @"http_full";
 NSString *const kQCloudQualityHTTPMD5Key = @"http_md5";
 NSString *const kQCloudQualityHTTPReadResponseBodyTookTimeKey = @"http_read_body";
 NSString *const kQCloudQualityHTTPReadResponseHeaderTookTimeKey = @"http_read_header";
 NSString *const kQCloudQualitySecureConnectTookTimeKey = @"http_secure_connect";
 NSString *const kQCloudQualityHTTPIpKey = @"ips";
 NSString *const kQCloudQualitySignRequestTookTimeKey = @"http_sign";

#pragma mark -event key
 NSString *const kQCloudBaseEventCode = @"base_service";
 NSString *const kQCloudUploadEventCode = @"cos_upload";
 NSString *const kQCloudDownloadEventCode = @"cos_download";
 NSString *const kQCloudCopyEventCode = @"cos_copy";
 NSString *const kQCloudOtherEventCode = @"cos_error";
#pragma mark - download

 NSString *const kQCloudRequestSuccessKey = @"Success";
 NSString *const kQCloudRequestFailureKey = @"Failure";

@implementation NSError (QualityDataUploader)

- (NSDictionary *)toUploadEventParamters {
    NSDictionary *userinfoDic = self.userInfo;
    NSString *errorCode = [NSError qcloud_networkErrorCodeTransferToString:self.code];
    NSString *requestID = @"";
    NSString *error_name = kQCloudQualityErrorCodeClientName;
    NSString *errorMsg = userinfoDic[NSLocalizedDescriptionKey];
    if (userinfoDic) {
        if (userinfoDic[@"Code"]) {
            errorCode = userinfoDic[@"Code"];
            requestID = userinfoDic[@"RequestId"];
            error_name = kQCloudQualityErrorCodeServerName;
            errorMsg = userinfoDic[@"Message"];
        }
    }
    if([self.domain isEqualToString:kQCloudNetworkDomain] && self.code == QCloudNetworkErrorCodeResponseDataTypeInvalid){
        error_name = kQCloudQualityErrorCodeServerName;
    }
    
    return
    @{ kQCloudQualityErrorStatusCodeKey : [NSString stringWithFormat:@"%ld", (long)self.code], kQCloudQualityErrorCodeKey :errorCode ? errorCode : @"" ,kQCloudQualityErrorTypeKey:error_name?error_name : @"",kQCloudQualityErrorIDKey:requestID?requestID : @"",kQCloudQualityErrorMessageKey:errorMsg?errorMsg:@""};
}

@end


@implementation QCloudHttpMetrics (QualityDataUploader)

- (NSDictionary *)toUploadEventParamters {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    params[kQCloudQualityRequestHostKey] = [self objectForKey:kHost];
    params[kQCloudQualityRequestHttpConnectKey] = @([self costTimeForKey:kConnectTookTime]);
    params[kQCloudQualityHTTPDNSKey] = @([self costTimeForKey:kDnsLookupTookTime]);
    params[kQCloudQualityHTTPFullKey] = @([self costTimeForKey:kTaskTookTime]);
    params[kQCloudQualityHTTPMD5Key] = @([self costTimeForKey:kCalculateMD5STookTime]);
    params[kQCloudQualityHTTPReadResponseBodyTookTimeKey] = @([self costTimeForKey:kReadResponseBodyTookTime]);
    params[kQCloudQualityTookTimeKey] = @([self costTimeForKey:kTaskTookTime]);
    params[kQCloudQualitySecureConnectTookTimeKey] = @([self costTimeForKey:kSecureConnectTookTime]);
    params[kQCloudQualityHTTPIpKey] = [self objectForKey:kRemoteAddress];
    params[kQCloudQualitySignRequestTookTimeKey] = @([self costTimeForKey:kSignRequestTookTime]);
    ;
    params[kQCloudSizeKey] =[self objectForKey:kTotalSize];

    return params;
}

@end
@implementation NSString (Quality)
+ (NSString *)stringWithClass:(Class)cls {
    return [NSString stringWithFormat:@"%@", cls];
}
@end

@implementation QualityDataUploader

+ (void)startWithAppkey:(NSString *)appkey {
    Class cls = NSClassFromString(@"BeaconReport");
    if (cls) {
        QCloudLogDebug(@"COS SDK Quality assurence service start");
        SuppressPerformSelectorLeakWarning(id report = [cls performSelector:NSSelectorFromString(@"sharedInstance")];
                                           [report performSelector:NSSelectorFromString(@"startWithAppkey:config:") withObject:appkey withObject:nil];

        );

    } else {
        QCloudLogDebug(@"please pod Beacon");
    }
}
+ (void)trackNormalEventWithKey:(NSString *)key props:(NSDictionary *)props {
    [self startReportWithEventKey:key appkey:nil paramters:props];
}

//上报成功的事件：需要排除掉uploadPart、uploadPartCopy等请求，在其对应的高级接口成功的回调中上报
+ (void)trackSDKRequestSuccessWithRequest:(QCloudAbstractRequest *)request {
    if(![NSStringFromClass(request.class) hasPrefix:@"QCloud"])
        return;
    
    NSMutableDictionary *paramas = [NSMutableDictionary dictionary];
    paramas[kQCloudQualityResultKey] = kQCloudRequestSuccessKey;
    [self internalUploadRequest:request event:[self qcloud_traceEventTypeFromClass:request.class] withParamter:paramas];
}

//上报失败的事件，需要上报网络性能,错误码
+ (void)trackSDKRequestFailWithRequest:(QCloudAbstractRequest *)request error:(NSError *)error {
    if(![NSStringFromClass(request.class) hasPrefix:@"QCloud"])
        return;
    
//    if (![self isErrorInsterested:error]) {
//        return;
//    }

    Class cls = [request class];
    NSMutableDictionary *mutableDicParams = [[error toUploadEventParamters] mutableCopy];
    //上报错误信息
    for (NSString *key in [error toUploadEventParamters].allKeys) {
        [mutableDicParams setObject:[[error toUploadEventParamters] objectForKey:key] forKey:key];
    }
    if([request isKindOfClass:[QCloudHTTPRequest class]]){
        QCloudHTTPRequest *httpReq = (QCloudHTTPRequest*)request;
        mutableDicParams[kQCloudQualityAuthSourceKey] =  httpReq.runOnService.configuration.endpoint.serverURLLiteral? [httpReq.urlRequest.allHTTPHeaderFields valueForKey:@"User-Agent"]:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
     
    }
    mutableDicParams[kQCloudQualityErrorServiceNameKey] = [self getServiceNameFromClass:request.class];
    mutableDicParams[kQCloudQualityResultKey] = kQCloudRequestFailureKey;
    [self internalUploadRequest:request event:[self qcloud_traceEventTypeFromClass:cls] withParamter:mutableDicParams];
}


+ (void)internalUploadRequest:(QCloudAbstractRequest *)request event:(NSString *)eventKey withParamter:(NSMutableDictionary *)paramter {
    //服务名称
    paramter[kQCloudQualityRequestNameKey] = [self getServiceNameFromClass:[request class]];
    //传输性能
    for (NSString *key in [request.benchMarkMan toUploadEventParamters].allKeys) {
        [paramter setObject:[[request.benchMarkMan toUploadEventParamters] objectForKey:key] forKey:key];
    }
    //地域
    if([request isKindOfClass:[QCloudHTTPRequest class]]){
        QCloudHTTPRequest *httpReq = (QCloudHTTPRequest*)request;
        paramter[kQCloudQualityRegionKey] =  httpReq.runOnService.configuration.endpoint.regionName;
        paramter[kQCloudQualityRequestPathKey] = httpReq.urlRequest.URL.path;
     
    }
    [self startReportSDKWithEventKey:eventKey paramters:paramter];
}


+ (void)startReportSDKWithEventKey:(NSString *)eventKey paramters:(NSMutableDictionary *)paramter {
    // sdk版本
    paramter[kQCloudQualitySDKVersionKey] = QCloudCoreModuleVersion;
    paramter[kQCloudQualitySDKVersionCodeKey] = @(QCloudCoreModuleVersionNumber);
    //包名
    paramter[kQCloudQualityBundleIDKey] =   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    //app名
    paramter[kQCloudQualityAppNameKey] =   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    //当前网络状况
    paramter[kQCloudQualityNetworkTypeKey] = QCloudNetworkSituationToString([QCloudNetEnv shareEnv].currentNetStatus);
#if defined(DEBUG) && DEBUG
    NSLog(@"test karis debug");
#else
    NSLog(@"test karis release");
    [self startReportWithEventKey:eventKey appkey:kQCloudUploadAppReleaseKey paramters:[paramter copy]];
#endif
}

+ (void)startReportWithEventKey:(NSString *)eventKey appkey:(NSString *)appkey paramters:(NSDictionary *)paramter {

  QCloudLogInfo(@"beacon paramter = %@",paramter);
  Class cls = NSClassFromString(@"BeaconReport");
    if (cls) {
      Class eventCls = NSClassFromString(@"BeaconEvent" );
       id eventObj = [eventCls performSelector:NSSelectorFromString(@"new")];
                                           if(appkey){
                                                [eventObj performSelector:NSSelectorFromString(@"setAppKey:") withObject:appkey];
            
                                            }
                                           [eventObj performSelector:NSSelectorFromString(@"setCode:") withObject:eventKey];
                                           [eventObj performSelector:NSSelectorFromString(@"setParams:") withObject:paramter ? paramter : @{}];
                                           id beaconInstance = [cls performSelector:NSSelectorFromString(@"sharedInstance")];
                                           [beaconInstance performSelector:NSSelectorFromString(@"reportEvent:") withObject:eventObj];
    }
}

//可以传多个参数的方法
+ (id)invokeClassMethod:(id)obj sel:(SEL)selector withObjects:(NSArray *)objects {
    id returnValue;

    // 方法签名
    NSMethodSignature *signature = [obj methodSignatureForSelector:selector];
    if (signature == nil) {
        return returnValue;
    }

    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    if (signature.numberOfArguments < 1) {
        return returnValue;
    }

    invocation.target = obj;
    invocation.selector = selector;

    // 设置参数
    NSInteger paramsCount = signature.numberOfArguments - 2; // 除self、_cmd以外的参数个数
    paramsCount = MIN(paramsCount, objects.count);
    for (NSInteger i = 0; i < paramsCount; i++) {
        id object = objects[i];
        if ([object isKindOfClass:[NSNull class]])
            continue;
        [invocation setArgument:&object atIndex:i + 2];
    }

    // 调用方法
    [invocation invoke];

    // 获取返回值
    if (signature.methodReturnLength) {
        [invocation getReturnValue:&returnValue];
    }

    return returnValue;
}

#pragma mark - utils


//获取上报的EventKey
+ (NSString *)qcloud_traceEventTypeFromClass:(Class)cls {
    NSString *classString = NSStringFromClass(cls);
    if ([kUploadEvents containsObject:classString] || [classString isEqualToString:@"QCloudCOSXMLUploadObjectRequest"]) {
        return kQCloudUploadEventCode;
    } else if ([kCopyEvents containsObject:classString] || [classString isEqualToString:@"QCloudCOSXMLCopyObjectRequest"]) {
        return kQCloudCopyEventCode;
    } else if ([kDownloadEvents containsObject:classString]) {
        return kQCloudDownloadEventCode;
    }
    return kQCloudBaseEventCode;
}

+ (BOOL)isErrorInsterested:(NSError *)error {
    return [NSError isNetworkErrorAndRecoverable:error];
}
+ (NSString *)getServiceNameFromClass:(Class )request{
    NSString *serviceName = NSStringFromClass([request class]) ;
    if([serviceName isEqualToString:@"QCloudCOSXMLUploadObjectRequest"]){
        return  @"UploadTask";
    }
    if([serviceName isEqualToString:@"QCloudCOSXMLCopyObjectRequest"]){
        return  @"CopyTask";
    }
    if([serviceName isEqualToString:@"QCloudGetObjectRequest"]){
        return  @"DownloadTask";
    }
    if ([serviceName hasPrefix:@"QCloud"]) {
        return [serviceName stringByReplacingOccurrencesOfString:@"QCloud" withString:@""];
    }
    return  @"";
}

@end
