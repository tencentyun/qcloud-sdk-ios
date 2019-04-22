//
//  QCloudCOSXML+Quality.m
//  QCloudCOSXML
//
//  Created by erichmzhang(张恒铭) on 2018/8/23.
//

#import "QCloudCOSXMLService+Quality.h"
#import <objc/runtime.h>
#import <QCloudCore/MTA.h>
#import <QCloudCore/MTA+Account.h>
#import <QCloudCore/MTAConfig.h>

#import <QCloudCore/QualityAssuranceDefine.h>
#import <QCloudCore/QCloudCore.h>
#import <QCloudCore/QCloudLogger.h>
#import "QCloudCOSXMLVersion.h"
@implementation QCloudCOSXMLService (Quality)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self changeImplementation];
    });
    
}

+ (void) changeImplementation {
    Class class = object_getClass((id)self);
    Method originMethod = class_getClassMethod(class, @selector(registerDefaultCOSXMLWithConfiguration:));
    Method replacedMethod = class_getClassMethod(class,  @selector(Quality_registerDefaultCOSXMLWithConfiguration:));
    method_exchangeImplementations(originMethod, replacedMethod);
    
}

+ (QCloudCOSXMLService*) Quality_registerDefaultCOSXMLWithConfiguration:(QCloudServiceConfiguration*)configuration {
    id result = [self Quality_registerDefaultCOSXMLWithConfiguration:configuration];
    [self initMTA];
    return result;
}


+ (void) initMTA {
    QCloudLogDebug(@"Quality assurence service start");
    TACMTAConfig* config =  [TACMTAConfig getInstance];
    config.reportStrategy = kQAUploadStrategy;
    config.customerAppVersion = QCloudCOSXMLModuleVersion;
    [TACMTA startWithAppkey:kQAccount];
}
@end
