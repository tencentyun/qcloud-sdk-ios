//
//  QCloudCOSXML+Quality.m
//  QCloudCOSXML
//
//  Created by erichmzhang(张恒铭) on 2018/8/23.
//
#define kQAUploadStrategy @(2)
#import "QCloudCOSXMLService+Quality.h"
#import <objc/runtime.h>

#import <QCloudCore/QCloudCore.h>
#import <QCloudCore/QCloudLogger.h>
#import "QCloudCOSXMLVersion.h"
#import <QCloudCore/QualityDataUploader.h>
#import <QCloudCore/QCloudServiceConfiguration+Quality.h>
#import <QCloudCore/QCloudConfiguration_Private.h>

NSString *const kQCloudDataAppReleaseKey = @"0IOS05O9HW7A9XPI";

@implementation QCloudCOSXMLService (Quality)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self changeImplementation];
    });
}

+ (void)changeImplementation {
    Class class = object_getClass((id)self);
    Method originMethod = class_getClassMethod(class, @selector(registerDefaultCOSXMLWithConfiguration:));
    Method replacedMethod = class_getClassMethod(class, @selector(Quality_registerDefaultCOSXMLWithConfiguration:));
    method_exchangeImplementations(originMethod, replacedMethod);
}

+ (QCloudCOSXMLService *)Quality_registerDefaultCOSXMLWithConfiguration:(QCloudServiceConfiguration *)configuration {
    id result = [self Quality_registerDefaultCOSXMLWithConfiguration:configuration];
    if(!configuration.disableSetupBeacon){
        [self initMTA:configuration];
    }
    return result;
}

+ (void)initMTA:(QCloudServiceConfiguration *)configuration {
        
#if defined(DEBUG) && DEBUG
#else
    NSMutableDictionary * commonParams = [self commonParams:nil];
    commonParams[@"sdk_bridge"] = configuration.bridge?:@"";
    [QualityDataUploader initCommonParams:commonParams];
    [QualityDataUploader trackBaseInfoToTrachCommonParams:commonParams];
    [QualityDataUploader startWithAppkey:kQCloudDataAppReleaseKey];
#endif
}

+(NSMutableDictionary *)commonParams:(NSString *)appKey{
    NSMutableDictionary * params = [NSMutableDictionary new];
    if (appKey) {
        params[kQCloudRequestAppkeyKey] = appKey;
    }
    params[@"pName"] = @"cos";
    params[@"sdkVersion"] = QCloudCOSXMLModuleVersion;
    params[@"sdkVersionName"] = @(QCloudCOSXMLModuleVersionNumber);
    return params;
}
@end
