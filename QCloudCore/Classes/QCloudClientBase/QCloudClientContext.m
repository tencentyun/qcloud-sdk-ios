//
//  QCloudClientContext.m
//  Pods
//
//  Created by Dong Zhao on 2017/3/31.
//
//

#import "QCloudClientContext.h"
#import "QCloudUICKeyChainStore.h"
#import <sys/types.h>
#import <sys/sysctl.h>
#import "QCloudLogger.h"
// Public constants
NSString *const QCloudClientContextVersion = @"1.0";
NSString *const QCloudClientContextHeader = @"x-qcloud-Client-Context";
NSString *const QCloudClientContextHeaderEncoding = @"x-qcloud-Client-Context-Encoding";

// Private constants
static NSString *const QCloudClientContextUnknown = @"Unknown";
static NSString *const QCloudClientContextKeychainService = @"com.qcloud.ClientContext";
static NSString *const QCloudClientContextKeychainInstallationIdKey = @"com.qcloud.QCloudClientContextKeychainInstallationIdKey";
@implementation QCloudClientContext
#pragma mark - Public methods
#if TARGET_OS_IPHONE

- (instancetype)init {
    if (self = [super init]) {
        QCloudUICKeyChainStore *keychain = [QCloudUICKeyChainStore keyChainStoreWithService:QCloudClientContextKeychainService];
        _installationId = [keychain stringForKey:QCloudClientContextKeychainInstallationIdKey];
        if (!_installationId) {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                [keychain setString:[[NSUUID UUID] UUIDString]
                             forKey:QCloudClientContextKeychainInstallationIdKey];
            });
            _installationId = [keychain stringForKey:QCloudClientContextKeychainInstallationIdKey];
        }
        if (_installationId == nil) {
            QCloudLogError(@"Failed to generate installation_id");
        }
        
        NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSString *appBuild = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        NSString *appPackageName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
        NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
        
        //App details
        _appVersion = appVersion ? appVersion : QCloudClientContextUnknown;
        _appBuild = appBuild ? appBuild : QCloudClientContextUnknown;
        _appPackageName = appPackageName ? appPackageName : QCloudClientContextUnknown;
        _appName = appName ? appName : QCloudClientContextUnknown;
        
        //Device Details
        UIDevice* currentDevice = [UIDevice currentDevice];
        NSString *autoUpdatingLoaleIdentifier = [[NSLocale autoupdatingCurrentLocale] localeIdentifier];
        _devicePlatform = [currentDevice systemName] ? [currentDevice systemName] : QCloudClientContextUnknown;
        _deviceModel = [currentDevice model] ? [currentDevice model] : QCloudClientContextUnknown;
        _deviceModelVersion = [self deviceModelVersionCode] ? [self deviceModelVersionCode] : QCloudClientContextUnknown;
        _devicePlatformVersion = [currentDevice systemVersion] ? [currentDevice systemVersion] : QCloudClientContextUnknown;
        _deviceManufacturer = @"apple";
        _deviceLocale = autoUpdatingLoaleIdentifier ? autoUpdatingLoaleIdentifier : QCloudClientContextUnknown;
        
        _customAttributes = @{};
        _serviceDetails = [NSMutableDictionary new];
    }
    
    return self;
}
    
- (NSDictionary *)dictionaryRepresentation {
    NSDictionary *clientDetails = @{@"installation_id": self.installationId?self.installationId:@"UNKNOWN_INSTALLATION_ID",
                                    @"app_package_name": self.appPackageName,
                                    @"app_version_name": self.appVersion,
                                    @"app_version_code": self.appBuild,
                                    @"app_title": self.appName};
    
    NSDictionary *deviceDetails = @{@"model": self.deviceModel,
                                    @"model_version": self.deviceModelVersion,
                                    @"make": self.deviceManufacturer,
                                    @"platform": self.devicePlatform,
                                    @"platform_version": self.devicePlatformVersion,
                                    @"locale": self.deviceLocale};
    
    NSDictionary *clientContext = @{@"version": QCloudClientContextVersion,
                                    @"client": clientDetails,
                                    @"env": deviceDetails,
                                    @"custom": self.customAttributes,
                                    @"services": self.serviceDetails};
    
    return clientContext;
}
    
- (NSString *)JSONString {
    NSDictionary *JSONObject = [self dictionaryRepresentation];
    NSError *error = nil;
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:JSONObject
                                                       options:kNilOptions
                                                         error:&error];
    if (!JSONData) {
        QCloudLogError(@"Failed to serialize JSON Data. [%@]", error);
    }
    
    return [[NSString alloc] initWithData:JSONData
                                 encoding:NSUTF8StringEncoding];
}
    
- (NSString *)base64EncodedJSONString {
    return [[[self JSONString] dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:kNilOptions];
}
    
- (void)setDetails:(id)details
        forService:(NSString *)service {
    if (service) {
        [self.serviceDetails setValue:details
                               forKey:service];
    } else {
        QCloudLogError(@"'service' cannot be nil.");
    }
}
    
- (NSString *)description {
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}
    
#pragma mark - Getter and setters
    
- (void)setAppVersion:(NSString *)appVersion {
    _appVersion = appVersion ? appVersion : QCloudClientContextUnknown;
}
    
- (void)setAppBuild:(NSString *)appBuild {
    _appBuild = appBuild ? appBuild : QCloudClientContextUnknown;
}
    
- (void)setAppPackageName:(NSString *)appPackageName {
    _appPackageName = appPackageName ? appPackageName : QCloudClientContextUnknown;
}
    
- (void)setAppName:(NSString *)appName {
    _appName = appName ? appName : QCloudClientContextUnknown;
}
    
- (void)setDevicePlatformVersion:(NSString *)devicePlatformVersion {
    _devicePlatformVersion = devicePlatformVersion ? devicePlatformVersion : QCloudClientContextUnknown;
}
    
- (void)setDevicePlatform:(NSString *)devicePlatform {
    _devicePlatform = devicePlatform ? devicePlatform : QCloudClientContextUnknown;
}
    
- (void)setDeviceManufacturer:(NSString *)deviceManufacturer {
    _deviceManufacturer = deviceManufacturer ? deviceManufacturer : QCloudClientContextUnknown;
}
    
- (void)setDeviceModel:(NSString *)deviceModel {
    _deviceModel = deviceModel ? deviceModel : QCloudClientContextUnknown;
}
    
- (void)setDeviceModelVersion:(NSString *)deviceModelVersion {
    _deviceModelVersion = deviceModelVersion ? deviceModelVersion : QCloudClientContextUnknown;
}
    
- (void)setDeviceLocale:(NSString *)deviceLocale {
    _deviceLocale = deviceLocale ? deviceLocale : QCloudClientContextUnknown;
}
    
#pragma mark - Internal
    
//For model translations see http://theiphonewiki.com/wiki/Models
- (NSString *)deviceModelVersionCode {
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *modelVersionCode = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    return modelVersionCode;
}
#endif
@end
