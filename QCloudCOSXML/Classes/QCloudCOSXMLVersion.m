#import "QCloudCOSXMLVersion.h"

NSString * const QCloudCOSXMLModuleVersion = @"6.5.3";
NSString * const QCloudCOSXMLModuleName = @"QCloudCOSXML";

@interface QCloudQCloudCOSXMLLoad : NSObject
@end

@implementation QCloudQCloudCOSXMLLoad
+ (NSString *)moduleName {
    return QCloudCOSXMLModuleName;
}
+ (NSString *)moduleVersion {
    return QCloudCOSXMLModuleVersion;
}
@end
