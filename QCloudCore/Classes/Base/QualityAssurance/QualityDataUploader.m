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
#import "QCloudConfiguration_Private.h"

#define SuppressPerformSelectorLeakWarning(Stuff)                                                                   \
    do {                                                                                                            \
        _Pragma("clang diagnostic push") _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") Stuff; \
        _Pragma("clang diagnostic pop")                                                                             \
    } while (0)

#define kUploadEvents \
@[ @"QCloudPutObjectRequest", @"QCloudInitiateMultipartUploadRequest", @"QCloudUploadPartRequest", @"QCloudCompleteMultipartUploadRequest" ,@"QCloudSMHUploadPartRequest" ,@"QCloudSMHPutObjectRequest",@"QCloudSMHCompleteUploadRequest"]
#define kDownloadEvents @[ @"QCloudGetObjectRequest" , @"QCloudSMHDownloadFileRequest" ]
#define kCopyEvents                                                                                             \
    @[                                                                                                          \
        @"QCloudCOSXMLCopyObjectRequest",@"QCloudInitiateMultipartUploadRequest", @"QCloudPutObjectCopyRequest", @"QCloudUploadPartCopyRequest", \
        @"QCloudCompleteMultipartUploadRequest"                                                                 \
    ]

#define kAdvancedEvents @[ @"QCloudCOSSMHUploadObjectRequest",@"QCloudCOSXMLUploadObjectRequest", @"QCloudCOSXMLCopyObjectRequest" ]

//NSString *const kQCloudUploadAppDebugKey = @"LOGDEBUGKEY00247"; // 废弃
//
//NSString *const kQCloudUploadAppReleaseKey = @"0AND0VEVB24UBGDU"; // 废弃


NSString *const KQCloudServiceBaseInfoKey = @"qcloud_track_sd_sdk_start";
#pragma mark -commen key
NSString *const kQCloudQualityBundleIDKey = @"boundle_id";
NSString *const kQCloudQualityAppNameKey = @"app_name";
NSString *const kQCloudQualityNetworkTypeKey = @"network_type";
NSString *const kQCloudQualityResultKey = @"request_result";
NSString *const kQCloudQualityTookTimeKey = @"http_took_time";
NSString *const kQCloudQualityRegionKey = @"region";
NSString *const kQCloudQualityAuthSourceKey = @"auth_source";
NSString *const kQCloudQualityRequestNameKey = @"name";
NSString *const kQCloudSizeKey = @"size";

#pragma mark -error key
 NSString *const kQCloudQualityErrorCodeKey = @"error_code";
NSString *const kQCloudQualityHTTPErrorCodeKey = @"error_http_code";
 NSString *const kQCloudQualityErrorMessageKey = @"error_message";
 NSString *const kQCloudQualityErrorNameKey = @"error_name";
 NSString *const kQCloudQualityErrorRequestNameKey = @"request_name";
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
 NSString *const kQCloudQualityHTTPIpKey = @"http_connect_ip";
 NSString *const kQCloudQualityHTTPSPeedKey = @"http_speed";
 NSString *const kQCloudQualitySignRequestTookTimeKey = @"http_sign";

#pragma mark -event key
 NSString *const kQCloudBaseEventCode = @"base_service";
 NSString *const kQCloudUploadEventCode = @"_upload";
 NSString *const kQCloudDownloadEventCode = @"_download";
 NSString *const kQCloudCopyEventCode = @"cos_copy";
 NSString *const kQCloudOtherEventCode = @"cos_error";
#pragma mark - download

 NSString *const kQCloudRequestSuccessKey = @"Success";
 NSString *const kQCloudRequestFailureKey = @"Failure";
NSString *const kQCloudRequestAppkeyKey = @"appKey";

static NSString * productName = @"";
static NSString * sdkVersion = @"";
static NSNumber * sdkVersionName = @"";
static NSString * appKey = @"";
static NSString * sdkBridge = @"";

@implementation NSError (QualityDataUploader)

- (NSDictionary *)toUploadEventParamters {
    NSDictionary *userinfoDic = self.userInfo;
    NSString *errorCode = [NSError qcloud_networkErrorCodeTransferToString:(QCloudNetworkErrorCode)self.code];
    NSString *requestID = @"";
    NSString *error_name = kQCloudQualityErrorCodeClientName;
    NSString *errorMsg = userinfoDic[NSLocalizedDescriptionKey];
    NSInteger httpCode = 0;
    if (userinfoDic) {
        if (userinfoDic[@"Code"]) {
            errorCode = userinfoDic[@"Code"];
            requestID = userinfoDic[@"RequestId"];
            error_name = kQCloudQualityErrorCodeServerName;
            errorMsg = userinfoDic[@"Message"];
        }
        
        if (userinfoDic[@"code"]) {
            errorCode = userinfoDic[@"code"];
            requestID = @"";
            errorMsg = userinfoDic[@"message"];
        }
    }
    
    NSHTTPURLResponse * response = [self __originHTTPURLResponse__];
    if (response) {
        httpCode = response.statusCode;
    }
    
    if([self.domain isEqualToString:kQCloudNetworkDomain] && self.code == QCloudNetworkErrorCodeResponseDataTypeInvalid){
        error_name = kQCloudQualityErrorCodeServerName;
    }
    
    return
    @{ kQCloudQualityErrorStatusCodeKey : [NSString stringWithFormat:@"%ld", (long)self.code],
       kQCloudQualityErrorCodeKey       : errorCode ? errorCode : @"" ,
       kQCloudQualityErrorTypeKey       : error_name?error_name : @"",
       kQCloudQualityErrorIDKey         : requestID?requestID : @"",
       kQCloudQualityErrorMessageKey    : errorMsg?errorMsg:@"",
       kQCloudQualityHTTPErrorCodeKey:@(httpCode).stringValue
    };
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
    params[kQCloudQualityHTTPReadResponseHeaderTookTimeKey] = @([self costTimeForKey:kReadResponseHeaderTookTime]);
    params[kQCloudSizeKey] =[self objectForKey:kTotalSize];
    if ([self costTimeForKey:kTaskTookTime] > 0) {
        params[kQCloudQualityHTTPSPeedKey] = @(([self objectForKey:kTotalSize].integerValue / 1024) / [self costTimeForKey:kTaskTookTime]);
    }
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
    Class cls = NSClassFromString(@"QCloudTrackService");
    Class beaconCls = NSClassFromString(@"QCloudBeaconTrackService");
    if (cls && beaconCls) {
        SuppressPerformSelectorLeakWarning(
                                           // 注册数据上报service
                                           id report = [cls performSelector:NSSelectorFromString(@"singleService")];
                                           id beaconService = [beaconCls performSelector:NSSelectorFromString(@"new")];
                                           [beaconService performSelector:NSSelectorFromString(@"updateBeaconKey:") withObject:appkey];
                                           [report performSelector:NSSelectorFromString(@"addTrackService:serviceKey:") withObject:beaconService withObject:[self qcloud_trackSDKEventKey]];
                                           
        );
    
    } else {
        QCloudLogDebug(@"please pod QCloudTrack");
    }
}

+ (void)trackBaseInfoToTrachCommonParams:(NSMutableDictionary * )commonParams{
    [self initCommonParams:commonParams];
    NSString * productName = commonParams[@"pName"];
    NSString * sdkVersion = commonParams[@"sdkVersion"];
    NSString * sdkVersionName = commonParams[@"sdkVersionName"];
    NSString * sdk_bridge = commonParams[@"sdk_bridge"];
    sdkBridge = sdk_bridge;
    Class cls = NSClassFromString(@"QCloudTrackService");
    if (cls) {
        
        Class clsClass = NSClassFromString(@"QCloudCLSTrackService");
        NSDictionary * paramter = @{
            @"sdk_name":productName.lowercaseString?:@"cos", //  sdk名称,
            @"sdk_version_code":sdkVersion?:@"", //  sdk版本号,
            @"sdk_version_name":sdkVersionName?:@"", //  sdk版本名称,
            @"sdk_bridge":sdk_bridge?:@"", //  桥接名称,
            @"cls_report":clsClass != nil?@"true":@"false"
        };
        id instance = [cls performSelector:NSSelectorFromString(@"singleService")];
        SEL selector = NSSelectorFromString(@"reportSimpleDataWithEventParams:");

    
        if ([instance respondsToSelector:selector]) {
            NSMethodSignature *methodSignature = [instance methodSignatureForSelector:selector];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
            [invocation setSelector:selector];
            [invocation setArgument:&paramter atIndex:2];
            [invocation invokeWithTarget:instance];
        }
    }
}

+ (void)trackNormalEventWithKey:(NSString *)key props:(NSDictionary *)props {
    [self trackNormalEventWithKey:key serviceKey:nil props:props];
}

+ (void)trackNormalEventWithKey:(NSString *)key serviceKey:(NSString *)serviceKey props:(NSDictionary *)props {
    
    NSString * appKey = props[kQCloudRequestAppkeyKey];
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:props];
    [params removeObjectForKey:kQCloudRequestAppkeyKey];
    
    [self startReportWithEventKey:key serviceKey:serviceKey paramters:params];
}

//上报成功的事件：需要排除掉uploadPart、uploadPartCopy等请求，在其对应的高级接口成功的回调中上报
+ (void)trackSDKRequestSuccessWithRequest:(QCloudAbstractRequest *)request params:(NSMutableDictionary * )commonParams{
    
    if(![NSStringFromClass(request.class) hasPrefix:@"QCloud"])
        return;
   
    [self initCommonParams:commonParams];
    NSMutableDictionary *paramas = commonParams?:[NSMutableDictionary dictionary];
    paramas[kQCloudQualityResultKey] = kQCloudRequestSuccessKey;
    paramas[kQCloudQualityErrorRequestNameKey] = [self getServiceNameFromClass:request.class];
    [self internalUploadRequest:request event:[self qcloud_trackSDKEventKey] withParamter:paramas];
}

+(void)initCommonParams:(NSMutableDictionary * )commonParams{
    productName = commonParams[@"pName"];
    sdkVersion = commonParams[@"sdkVersion"];
    sdkVersionName = commonParams[@"sdkVersionName"];
    appKey = commonParams[kQCloudRequestAppkeyKey];
}

+(NSDictionary *)getRequestURLInfo:(QCloudAbstractRequest *)request{
    NSMutableDictionary * urlInfo = [NSMutableDictionary new];
    if ([request isKindOfClass:QCloudBizHTTPRequest.class]) {
        QCloudBizHTTPRequest * bizRequest = (QCloudBizHTTPRequest *)request;
        NSString * regionName = bizRequest.regionName?:bizRequest.runOnService.configuration.endpoint.regionName;
        
        NSString * accelerate = [bizRequest.urlRequest.URL.absoluteString containsString:@"accelerate"] ? @"true" : @"false";
        
        NSString * bucket = @"";
        if ([bizRequest respondsToSelector:@selector(bucket)] && [bizRequest valueForKey:@"bucket"]) {
            bucket = [bizRequest valueForKey:@"bucket"];
        }
        
        if ([bizRequest respondsToSelector:@selector(bucketName)] && [bizRequest valueForKey:@"bucketName"]) {
            bucket = [bizRequest valueForKey:@"bucketName"];
        }
        
        urlInfo[@"region"] = regionName?:@"";
        urlInfo[@"bucket"] = bucket;
        urlInfo[@"accelerate"] = accelerate;
        urlInfo[@"http_method"] = bizRequest.urlRequest.HTTPMethod;
        urlInfo[@"url"] = bizRequest.urlRequest.URL.absoluteString;
        urlInfo[@"host"] = bizRequest.urlRequest.URL.host;
        urlInfo[@"request_path"] = bizRequest.urlRequest.URL.absoluteString;
        urlInfo[@"network_protocol"] = bizRequest.enableQuic?@"QUIC":(bizRequest.runOnService.configuration.endpoint.useHTTPS ? @"HTTPS":@"HTTP");
        urlInfo[@"http_retry_times"] = @(bizRequest.retryCount).stringValue;
        urlInfo[@"http_dns_ips"] = [[[QCloudHttpDNS shareDNS] queryIPsForHost:bizRequest.urlRequest.URL.host] componentsJoinedByString:@","];
    }
    if (sdkBridge) {
        urlInfo[@"sdk_bridge"] = sdkBridge;
    }
    
    return urlInfo.copy;
}
//上报失败的事件，需要上报网络性能,错误码
+ (void)trackSDKRequestFailWithRequest:(QCloudAbstractRequest *)request error:(NSError *)error params:(NSMutableDictionary * )commonParams{
    
    if(![NSStringFromClass(request.class) hasPrefix:@"QCloud"])
        return;
    
    [self initCommonParams:commonParams];

    NSMutableDictionary *mutableDicParams = [[error toUploadEventParamters] mutableCopy];
    
    [mutableDicParams addEntriesFromDictionary:commonParams];
    //上报错误信息
    for (NSString *key in [error toUploadEventParamters].allKeys) {
        [mutableDicParams setObject:[[error toUploadEventParamters] objectForKey:key] forKey:key];
    }
    if([request isKindOfClass:[QCloudHTTPRequest class]]){
        @try {
            QCloudHTTPRequest *httpReq = (QCloudHTTPRequest*)request;
            mutableDicParams[kQCloudQualityAuthSourceKey] =  httpReq.runOnService.configuration.endpoint.serverURLLiteral? [httpReq.urlRequest.allHTTPHeaderFields valueForKey:@"User-Agent"]:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
            
            mutableDicParams[@"user_agent"] =  [httpReq.urlRequest.allHTTPHeaderFields valueForKey:@"User-Agent"]? [httpReq.urlRequest.allHTTPHeaderFields valueForKey:@"User-Agent"]:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
                
            if(httpReq.runOnService.configuration.bridge != nil){
                mutableDicParams[@"bridge"] = httpReq.runOnService.configuration.bridge;
            }
        } @catch (NSException *exception) {
            return;
        } @finally {
            
        }
        
     
    }
    mutableDicParams[kQCloudQualityErrorRequestNameKey] = [self getServiceNameFromClass:request.class];
    mutableDicParams[kQCloudQualityResultKey] = kQCloudRequestFailureKey;
    [self internalUploadRequest:request event:[self qcloud_trackSDKEventKey] withParamter:mutableDicParams];
}


+ (void)internalUploadRequest:(QCloudAbstractRequest *)request event:(NSString *)eventKey withParamter:(NSMutableDictionary *)paramter {
    
    NSDictionary * requestInfo = [self getRequestURLInfo:request];
    [paramter addEntriesFromDictionary:requestInfo];
    //服务名称
    paramter[kQCloudQualityRequestNameKey] = [self getServiceNameFromClass:[request class]];
    //传输性能
    for (NSString *key in [request.benchMarkMan toUploadEventParamters].allKeys) {
        [paramter setObject:[[request.benchMarkMan toUploadEventParamters] objectForKey:key] forKey:key];
    }
    //地域
    if([request isKindOfClass:[QCloudHTTPRequest class]]){
        @try {
            QCloudHTTPRequest *httpReq = (QCloudHTTPRequest*)request;
            paramter[kQCloudQualityRegionKey] =  httpReq.runOnService.configuration.endpoint.regionName;
            paramter[kQCloudQualityRequestPathKey] = httpReq.urlRequest.URL.path;
            
            paramter[kQCloudQualityAuthSourceKey] =  httpReq.runOnService.configuration.endpoint.serverURLLiteral? [httpReq.urlRequest.allHTTPHeaderFields valueForKey:@"User-Agent"]:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
            
            paramter[@"user_agent"] =  [httpReq.urlRequest.allHTTPHeaderFields valueForKey:@"User-Agent"]? [httpReq.urlRequest.allHTTPHeaderFields valueForKey:@"User-Agent"]:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
                
            if(httpReq.runOnService.configuration.bridge != nil){
                paramter[@"bridge"] = httpReq.runOnService.configuration.bridge;
            }
        } @catch (NSException *exception) {
            return;
        } @finally {
            
        }
    }else if ([request respondsToSelector:@selector(transferManager)]){
        NSObject * service = [request performSelector:@selector(transferManager)];
        if([service respondsToSelector:@selector(configuration)]){
            QCloudServiceConfiguration * config = [service performSelector:@selector(configuration)];
            if(config.bridge != nil){
                paramter[@"bridge"] = config.bridge;
            }
        }
    }
    
    Class clsClass = NSClassFromString(@"QCloudCLSTrackService");
    NSDictionary * baseInfo = @{
        @"sdk_name":productName.lowercaseString?:@"cos", //  sdk名称,
        @"sdk_version_code":sdkVersion?:@"", //  sdk版本号,
        @"sdk_version_name":sdkVersionName?:@"", //  sdk版本名称,
        @"cls_report":clsClass != nil?@"true":@"false"
    };
    [paramter addEntriesFromDictionary:baseInfo];
    [self startReportSDKWithEventKey:eventKey paramters:paramter];
}

+ (void)startReportSDKWithEventKey:(NSString *)eventKey paramters:(NSMutableDictionary *)paramter {
    // sdk版本
    paramter[[NSString stringWithFormat:@"%@sdk_version",[productName lowercaseString]]] = sdkVersion;
    paramter[[NSString stringWithFormat:@"%@sdk_version_code",[productName lowercaseString]]] = sdkVersionName;
    //包名
    paramter[kQCloudQualityBundleIDKey] =   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    //app名
    paramter[kQCloudQualityAppNameKey] =   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    //当前网络状况
    paramter[kQCloudQualityNetworkTypeKey] = QCloudNetworkSituationToString([QCloudNetEnv shareEnv].currentNetStatus);
#if defined(DEBUG) && DEBUG
  
#else
    [self startReportWithEventKey:eventKey serviceKey:nil paramters:[paramter copy]];
#endif
}

+ (void)startReportWithEventKey:(NSString *)eventKey serviceKey:(NSString *)serviceKey paramters:(NSDictionary *)paramter {

    
    Class cls = NSClassFromString(@"QCloudTrackService");
    if (cls) {
        id instance = [cls performSelector:NSSelectorFromString(@"singleService")];
        SEL selector = NSSelectorFromString(@"reportWithEventCode:params:serviceKey:");

        if ([instance respondsToSelector:selector]) {
            if (!serviceKey) {
                serviceKey = [self qcloud_trackSDKEventKey];
            }
            NSMethodSignature *methodSignature = [instance methodSignatureForSelector:selector];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
            [invocation setSelector:selector];
            [invocation setArgument:&eventKey atIndex:2];
            [invocation setArgument:&paramter atIndex:3];
            [invocation setArgument:&serviceKey atIndex:4];
            [invocation invokeWithTarget:instance];
        }
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
+ (NSString *)qcloud_trackSDKEventKey{
    return [NSString stringWithFormat:@"qcloud_track_%@_sdk",productName.lowercaseString];
}

+ (BOOL)isErrorInsterested:(NSError *)error {
    return [NSError isNetworkErrorAndRecoverable:error];
}
+ (NSString *)getServiceNameFromClass:(Class )request{
    NSString *serviceName = NSStringFromClass([request class]) ;
    if([serviceName isEqualToString:[NSString stringWithFormat:@"QCloudCOS%@UploadObjectRequest",[productName uppercaseString]]]){
        return  @"UploadTask";
    }
    if([serviceName isEqualToString:@"QCloudCOSXMLCopyObjectRequest"]){
        return  @"CopyTask";
    }
    if([serviceName isEqualToString:@"QCloudGetObjectRequest"] || [serviceName isEqualToString:@"QCloudSMHDownloadFileRequest"]){
        return  @"DownloadTask";
    }
    if ([serviceName hasPrefix:@"QCloud"]) {
        return [serviceName stringByReplacingOccurrencesOfString:@"QCloud" withString:@""];
    }
    return  @"";
}

@end
