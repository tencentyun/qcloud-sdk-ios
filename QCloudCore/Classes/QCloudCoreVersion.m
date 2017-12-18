#import "QCloudCoreVersion.h"
#import "QCloudCore.h"
NSString * const QCloudCoreModuleVersion = @"0.1.1";
NSString * const QCloudCoreModuleName = @"QCloudCore";
@interface QCloudQCloudCoreLoad : NSObject
@end

@implementation QCloudQCloudCoreLoad
+ (void) load
{
    QCloudSDKModule* module = [[QCloudSDKModule alloc] init];
    module.name = QCloudCoreModuleName;
    module.version = QCloudCoreModuleVersion;
    [[QCloudSDKModuleManager shareInstance] registerModule:module];
}
@end