#import "QCloudQuicVersion.h"
NSString * const QCloudQuicModuleVersion = @"6.3.9";
NSString * const QCloudQuicModuleName = @"QCloudQuic";
@interface QCloudQCloudQuicLoad : NSObject
@end

@implementation QCloudQCloudQuicLoad
+ (void) load
{
    Class cla = NSClassFromString(@"QCloudSDKModuleManager");
    if (cla) {
        NSMutableDictionary* module = [@{
                                 @"name" : QCloudQuicModuleName,
                                 @"version" : QCloudQuicModuleVersion
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
