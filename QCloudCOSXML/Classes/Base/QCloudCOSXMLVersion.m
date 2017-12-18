#import "QCloudCOSXMLVersion.h"
#import "QCloudCore.h"
NSString * const QCloudCOSXMLModuleVersion = @"0.1.1";
NSString * const QCloudCOSXMLModuleName = @"QCloudCOSXML";
@interface QCloudQCloudCOSXMLLoad : NSObject
@end

@implementation QCloudQCloudCOSXMLLoad
+ (void) load
{
    QCloudSDKModule* module = [[QCloudSDKModule alloc] init];
    module.name = QCloudCOSXMLModuleName;
    module.version = QCloudCOSXMLModuleVersion;
    [[QCloudSDKModuleManager shareInstance] registerModule:module];
}
@end