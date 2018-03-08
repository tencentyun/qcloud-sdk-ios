#import "QCloudNewCOSV4Version.h"
NSString * const QCloudNewCOSV4ModuleVersion = @"5.3.2";
NSString * const QCloudNewCOSV4ModuleName = @"QCloudNewCOSV4";
@interface QCloudQCloudNewCOSV4Load : NSObject
@end

@implementation QCloudQCloudNewCOSV4Load
+ (void) load
{
    Class cla = NSClassFromString(@"QCloudSDKModuleManager");
    if (cla) {
        NSMutableDictionary* module = [@{
                                 @"name" : QCloudNewCOSV4ModuleName,
                                 @"version" : QCloudNewCOSV4ModuleVersion
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