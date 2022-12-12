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

NSString *const kQCloudUploadAppDebugKey = @"LOGDEBUGKEY00247";

NSString *const kQCloudUploadAppReleaseKey = @"0AND0VEVB24UBGDU";


#pragma mark -commen key
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
static NSNumber * sdkVersionName;
static NSString * appKey = @"";

@implementation NSError (QualityDataUploader)

- (NSDictionary *)toUploadEventParamters {
    NSDictionary *userinfoDic = self.userInfo;
    NSString *errorCode = [NSError qcloud_networkErrorCodeTransferToString:(QCloudNetworkErrorCode)self.code];
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
        
        if (userinfoDic[@"code"]) {
            errorCode = userinfoDic[@"code"];
            requestID = @"";
            errorMsg = userinfoDic[@"message"];
        }
    }
    if([self.domain isEqualToString:kQCloudNetworkDomain] && self.code == QCloudNetworkErrorCodeResponseDataTypeInvalid){
        error_name = kQCloudQualityErrorCodeServerName;
    }
    
    return
    @{ kQCloudQualityErrorStatusCodeKey : [NSString stringWithFormat:@"%ld", (long)self.code],
       kQCloudQualityErrorCodeKey       : errorCode ? errorCode : @"" ,
       kQCloudQualityErrorTypeKey       : error_name?error_name : @"",
       kQCloudQualityErrorIDKey         : requestID?requestID : @"",
       kQCloudQualityErrorMessageKey    : errorMsg?errorMsg:@""};
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
//        Class clsz = NSClassFromString(@"BeaconBaseInterface");
//        [clsz performSelector:NSSelectorFromString(@"setAppKey:") withObject:appkey];
//        [clsz performSelector:NSSelectorFromString(@"setLogLevel:") withObject:@10];
//        id report = [cls performSelector:NSSelectorFromString(@"sharedInstance")];
//        id qimei = [report performSelector:@selector(getQimei)];
//        NSLog(@"%@", [NSString stringWithFormat:@" qiemiOld:%@,\n qimeiNew:%@,\n qimeiJson:%@", [qimei valueForKey:@"qimeiOld"], [qimei valueForKey:@"qimeiNew"], [qimei valueForKey:@"qimeiJson"]]);
    } else {
        QCloudLogDebug(@"please pod Beacon");
    }
}
+ (void)trackNormalEventWithKey:(NSString *)key props:(NSDictionary *)props {
    
    NSString * appKey = props[kQCloudRequestAppkeyKey];
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:props];
    [params removeObjectForKey:kQCloudRequestAppkeyKey];
    
    [self startReportWithEventKey:key appkey:appKey paramters:params];
}

//上报成功的事件：需要排除掉uploadPart、uploadPartCopy等请求，在其对应的高级接口成功的回调中上报
+ (void)trackSDKRequestSuccessWithRequest:(QCloudAbstractRequest *)request params:(NSMutableDictionary * )commonParams{
    
    if(![NSStringFromClass(request.class) hasPrefix:@"QCloud"])
        return;
   
    [self initCommonParams:commonParams];
    NSMutableDictionary *paramas = commonParams?:[NSMutableDictionary dictionary];
    paramas[kQCloudQualityResultKey] = kQCloudRequestSuccessKey;
    [self internalUploadRequest:request event:[self qcloud_traceEventTypeFromClass:request.class] withParamter:paramas];
}

+(void)initCommonParams:(NSMutableDictionary * )commonParams{
    productName = commonParams[@"pName"];
    if (productName) {
        [commonParams removeObjectForKey:@"pName"];
    }
    sdkVersion = commonParams[@"sdkVersion"];
    if (sdkVersion) {
        [commonParams removeObjectForKey:@"sdkVersion"];
    }
    sdkVersionName = commonParams[@"sdkVersionName"];
    if (sdkVersionName != nil) {
        [commonParams removeObjectForKey:@"sdkVersionName"];
    }
    appKey = commonParams[kQCloudRequestAppkeyKey];
    if (appKey) {
        [commonParams removeObjectForKey:kQCloudRequestAppkeyKey];
    }
    
}

//上报失败的事件，需要上报网络性能,错误码
+ (void)trackSDKRequestFailWithRequest:(QCloudAbstractRequest *)request error:(NSError *)error params:(NSMutableDictionary * )commonParams{
    
    if(![NSStringFromClass(request.class) hasPrefix:@"QCloud"])
        return;
    
    [self initCommonParams:commonParams];
    Class cls = [request class];
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
            
            mutableDicParams[@"user_agent"] =  httpReq.runOnService.configuration.endpoint.serverURLLiteral? [httpReq.urlRequest.allHTTPHeaderFields valueForKey:@"User-Agent"]:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
                
            if(httpReq.runOnService.configuration.bridge != nil){
                mutableDicParams[@"bridge"] = httpReq.runOnService.configuration.bridge;
            }
        } @catch (NSException *exception) {
            return;
        } @finally {
            
        }
        
     
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
        @try {
            QCloudHTTPRequest *httpReq = (QCloudHTTPRequest*)request;
            paramter[kQCloudQualityRegionKey] =  httpReq.runOnService.configuration.endpoint.regionName;
            paramter[kQCloudQualityRequestPathKey] = httpReq.urlRequest.URL.path;
            
            paramter[kQCloudQualityAuthSourceKey] =  httpReq.runOnService.configuration.endpoint.serverURLLiteral? [httpReq.urlRequest.allHTTPHeaderFields valueForKey:@"User-Agent"]:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
            
            paramter[@"user_agent"] =  httpReq.runOnService.configuration.endpoint.serverURLLiteral? [httpReq.urlRequest.allHTTPHeaderFields valueForKey:@"User-Agent"]:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
                
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
    [self startReportWithEventKey:eventKey appkey:appKey?:kQCloudUploadAppReleaseKey paramters:[paramter copy]];
#endif
}

+ (void)startReportWithEventKey:(NSString *)eventKey appkey:(NSString *)appkey paramters:(NSDictionary *)paramter {

  QCloudLogInfo(@"beacon paramter = %@",paramter);
  Class cls = NSClassFromString(@"BeaconReport");
    if (cls) {
      Class eventCls = NSClassFromString(@"BeaconEvent" );
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        id eventObj = [eventCls performSelector:NSSelectorFromString(@"new")];
        if(appkey){
             [eventObj performSelector:NSSelectorFromString(@"setAppKey:") withObject:appkey];

         }
        [eventObj performSelector:NSSelectorFromString(@"setCode:") withObject:eventKey];
        [eventObj performSelector:NSSelectorFromString(@"setParams:") withObject:paramter ? paramter : @{}];
        id beaconInstance = [cls performSelector:NSSelectorFromString(@"sharedInstance")];

        [beaconInstance performSelector:NSSelectorFromString(@"reportEvent:") withObject:eventObj];
#pragma clang diagnostic pop
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
    if ([kUploadEvents containsObject:classString] || [classString isEqualToString:[NSString stringWithFormat:@"QCloudCOS%@UploadObjectRequest",[productName uppercaseString]]]) {
        return [productName?:@"" stringByAppendingString:kQCloudUploadEventCode];
    } else if ([kCopyEvents containsObject:classString] || [classString isEqualToString:@"QCloudCOSXMLCopyObjectRequest"]) {
        return kQCloudCopyEventCode;
    } else if ([kDownloadEvents containsObject:classString]) {
        return [productName?:@"" stringByAppendingString:kQCloudDownloadEventCode];
    }
    return kQCloudBaseEventCode;
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
