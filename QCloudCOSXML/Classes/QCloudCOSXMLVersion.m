#import "QCloudCOSXMLVersion.h"
NSString * const QCloudCOSXMLModuleVersion = @"5.5.3";
NSString * const QCloudCOSXMLModuleName = @"QCloudCOSXML";
@interface QCloudQCloudCOSXMLLoad : NSObject
@end

@implementation QCloudQCloudCOSXMLLoad
+ (void) load
{
    Class cla = NSClassFromString(@"QCloudSDKModuleManager");
    if (cla) {
        NSMutableDictionary* module = [@{
                                 @"name" : QCloudCOSXMLModuleName,
                                 @"version" : QCloudCOSXMLModuleVersion
                                 } mutableCopy];

          NSString* buglyID = @"";
          if (buglyID.length > 0) {
              module[@"crashID"] = buglyID;
          }

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        id share = [cla performSelector:@selector(shareInstance)];
        [share performSelector:@selector(registerModuleByJSON:) withObject:module];
#pragma clang diagnostic pop
    }
}
@end