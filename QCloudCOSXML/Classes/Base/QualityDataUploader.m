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
#import "QCloudCOSXMLVersion.h"
#import <QCloudCore/QCloudFileUtils.h>
#define AppKey @"0AND0VEVB24UBGDU"

#define SuppressPerformSelectorLeakWarning(Stuff)                                                                   \
    do {                                                                                                            \
        _Pragma("clang diagnostic push") _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") Stuff; \
        _Pragma("clang diagnostic pop")                                                                             \
    } while (0)

#define kUploadEvents \
    @[ @"QCloudPutObjectRequest", @"QCloudInitiateMultipartUploadRequest", @"QCloudUploadPartRequest", @"QCloudCompleteMultipartUploadRequest" ]
#define kDownloadEvents @[ @"QCloudGetObjectRequest" ]
#define kCopyEvents                                                                                             \
    @[                                                                                                          \
        @"QCloudInitiateMultipartUploadRequest", @"QCloudPutObjectCopyRequest", @"QCloudUploadPartCopyRequest", \
        @"QCloudCompleteMultipartUploadRequest"                                                                 \
    ]

#define kAdvancedEvents @[ @"QCloudCOSXMLUploadObjectRequest", @"QCloudCOSXMLCopyObjectRequest" ]

#pragma mark -commen key
static NSString *kQCloudQualitySDKVersionKey = @"cossdk_version";
static NSString *kQCloudQualityBundleIDKey = @"bundleid";
static NSString *kQCloudQualityNetworkTypeKey = @"network_type";
static NSString *kQCloudQualityResultKey = @"result";
static NSString *kQCloudQualityTookTimeKey = @"took_time";

#pragma mark -error key
static NSString *kQCloudQualityErrorCodeKey = @"error_code";
static NSString *kQCloudQualityErrorMessageKey = @"error_message";
static NSString *kQCloudQualityErrorNameKey = @"error_name";
static NSString *kQCloudQualityErrorServiceNameKey = @"error_service_name";
static NSString *kQCloudQualityErrorStatusCodeKey = @"error_status_code";
static NSString *kQCloudQualityErrorTypeKey = @"error_type";

#pragma mark -error base
static NSString *kQCloudQualityAccelerateKey = @"accelerate"; // Y || N
static NSString *kQCloudQualityRequestHostKey = @"host";
static NSString *kQCloudQualityRequestHttpConnectKey = @"http_connect";
static NSString *kQCloudQualityHTTPDNSKey = @"http_dns";
static NSString *kQCloudQualityHTTPFullKey = @"http_full";
static NSString *kQCloudQualityHTTPMD5Key = @"http_md5";
static NSString *kQCloudQualityHTTPReadResponseBodyTookTimeKey = @"http_read_body";
static NSString *kQCloudQualityHTTPReadResponseHeaderTookTimeKey = @"http_read_header";
static NSString *kQCloudQualitySecureConnectTookTimeKey = @"http_secure_connect";
static NSString *kQCloudQualityHTTPIpKey = @"ips";
static NSString *kQCloudQualitySignRequestTookTimeKey = @"http_sign";
static NSString *kQCloudQualityRequestNameKey = @"name";
#pragma mark -event key
static NSString *kQCloudBaseEventCode = @"base_service";
static NSString *kQCloudUploadEventCode = @"cos_upload";
static NSString *kQCloudDownloadEventCode = @"cos_download";
static NSString *kQCloudCopyEventCode = @"cos_copy";
static NSString *kQCloudOtherEventCode = @"cos_error";
#pragma mark - download
static NSString *kQCloudDownloadSizeKey = @"size";

static NSString *kQCloudRequestSuccessKey = @"Success";
static NSString *kQCloudRequestFailureKey = @"Failure";

@implementation NSError (QualityDataUploader)

- (NSDictionary *)toUploadEventParamters {
    NSDictionary *userinfoDic = self.userInfo;
    NSString *detailDescription = @"";
    if (userinfoDic) {
        if (userinfoDic[@"Code"]) {
            detailDescription = userinfoDic[@"Code"];
        }
    }
    return
        @{ kQCloudQualityErrorStatusCodeKey : [NSString stringWithFormat:@"%ld", (long)self.code], kQCloudQualityErrorCodeKey : detailDescription };
}

@end

@implementation NSException (QualityDataUploader)

- (NSDictionary *)toUploadEventParamters {
    return @{ kQCloudQualityErrorStatusCodeKey : self.name, kQCloudQualityErrorMessageKey : self.reason };
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
    params[kQCloudQualitySecureConnectTookTimeKey] = @([self costTimeForKey:kSecureConnectTookTime]);
    params[kQCloudQualityHTTPIpKey] = [self objectForKey:kRemoteAddress];
    params[kQCloudQualitySignRequestTookTimeKey] = @([self costTimeForKey:kSignRequestTookTime]);
    ;

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

//上报成功的事件：需要排除掉uploadPart、uploadPartCopy等请求，在其对应的高级接口成功的回调中上报
+ (void)trackSDKRequestSuccessWithRequest:(QCloudAbstractRequest *)request {
    Class cls = [request class];
    if (![self isNeedQuality:cls error:nil]) {
        return;
    }
    NSMutableDictionary *paramas = [NSMutableDictionary dictionary];
    paramas[kQCloudQualityResultKey] = kQCloudRequestSuccessKey;
    [self internalUploadRequest:request event:[self qcloud_traceEventTypeFromClass:cls] withParamter:paramas];
}

//上报失败的事件，需要上报网络性能,错误码
+ (void)trackSDKRequestFailWithRequest:(QCloudAbstractRequest *)request error:(NSError *)error {
    if (![self isErrorInsterested:error]) {
        return;
    }
    if ([kAdvancedEvents containsObject:NSStringFromClass(request.class)]) {
        return;
    }

    Class cls = [request class];
    NSMutableDictionary *mutableDicParams = [[request.benchMarkMan toUploadEventParamters] mutableCopy];

    for (NSString *key in [error toUploadEventParamters].allKeys) {
        [mutableDicParams setObject:[[error toUploadEventParamters] objectForKey:key] forKey:key];
    }
    mutableDicParams[kQCloudQualityResultKey] = kQCloudRequestFailureKey;
    [self internalUploadRequest:request event:[self qcloud_traceEventTypeFromClass:cls] withParamter:mutableDicParams];
}

+ (void)trackSDKExceptionWithException:(NSException *)exception {
    if (![exception.name isEqualToString:QCloudErrorDomain]) {
        return;
    }
    NSMutableDictionary *dic = [[exception toUploadEventParamters] mutableCopy];
    [self startReportSDKWithEventKey:kQCloudOtherEventCode paramters:dic];
}

+ (void)trackNormalEventWithKey:(NSString *)key props:(NSDictionary *)props {
    [self startReportWithEventKey:key paramters:props];
}

+ (void)internalUploadRequest:(QCloudAbstractRequest *)request event:(NSString *)eventKey withParamter:(NSMutableDictionary *)paramter {
    NSString *serviceName = NSStringFromClass([request class]);
    if ([serviceName hasPrefix:@"QCloudCOSXML"]) {
        serviceName = [serviceName stringByReplacingOccurrencesOfString:@"QCloudCOSXML" withString:@""];
    } else if ([serviceName hasPrefix:@"QCloud"]) {
        serviceName = [serviceName stringByReplacingOccurrencesOfString:@"QCloud" withString:@""];
    }
    paramter[kQCloudQualityRequestNameKey] = serviceName;
    [self startReportSDKWithEventKey:eventKey paramters:paramter];
}

+ (void)startReportSDKWithEventKey:(NSString *)eventKey paramters:(NSMutableDictionary *)paramter {
    paramter[kQCloudQualitySDKVersionKey] = QCloudCOSXMLModuleVersion;
    [self startReportWithEventKey:eventKey paramters:[paramter copy]];
}

+ (void)startReportWithEventKey:(NSString *)eventKey paramters:(NSDictionary *)paramter {
    Class cls = NSClassFromString(@"BeaconReport");
    if (cls) {
        Class eventCls = NSClassFromString(@"BeaconEvent");
        SuppressPerformSelectorLeakWarning(id eventObj = [eventCls performSelector:NSSelectorFromString(@"new")];
                                           [eventObj performSelector:NSSelectorFromString(@"setAppKey:") withObject:AppKey];
                                           [eventObj performSelector:NSSelectorFromString(@"setCode:") withObject:eventKey];
                                           [eventObj performSelector:NSSelectorFromString(@"setParams:") withObject:paramter ? paramter : @{}];
                                           id beaconInstance = [cls performSelector:NSSelectorFromString(@"sharedInstance")];
                                           [beaconInstance performSelector:NSSelectorFromString(@"reportEvent:") withObject:eventObj];);
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
+ (BOOL)isNeedQuality:(Class)cls error:(NSError *)error {
    NSString *classString = NSStringFromClass(cls);
    if (!error) {
        //成功的话分片请求不上报，只上报高级接口
        if ([kUploadEvents containsObject:classString] || [kCopyEvents containsObject:classString]) {
            return NO;
        }
    }
    return YES;
}

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
@end
