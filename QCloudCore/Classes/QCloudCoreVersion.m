#import "QCloudCoreVersion.h"
NSString * const QCloudCoreModuleVersion = @"5.5.3";
NSString * const QCloudCoreModuleName = @"QCloudCore";
@interface QCloudQCloudCoreLoad : NSObject
@end

@implementation QCloudQCloudCoreLoad
+ (void) load
{
    Class cla = NSClassFromString(@"QCloudSDKModuleManager");
    if (cla) {
        NSMutableDictionary* module = [@{
                                 @"name" : QCloudCoreModuleName,
                                 @"version" : QCloudCoreModuleVersion
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