#import "QCloudQuicVersion.h"
NSString * const QCloudQuicModuleVersion = @"6.4.1";
NSString * const QCloudQuicModuleName = @"QCloudQuic";
@interface QCloudQCloudQuicLoad : NSObject
@end

@implementation QCloudQCloudQuicLoad
+ (NSString *)moduleName {
    return QCloudQuicModuleName;
}
+ (NSString *)moduleVersion {
    return QCloudQuicModuleVersion;
}
@end
