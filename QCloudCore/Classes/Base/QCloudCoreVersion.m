#import "QCloudCoreVersion.h"
NSString *const QCloudCoreModuleVersion = @"6.5.3";
NSString *const QCloudCoreModuleName = @"QCloudCore";
@interface QCloudQCloudCoreLoad : NSObject
@end

@implementation QCloudQCloudCoreLoad
+ (NSString *)moduleName {
    return QCloudCoreModuleName;
}
+ (NSString *)moduleVersion {
    return QCloudCoreModuleVersion;
}
@end
