#import "QCloudTrackVersion.h"
NSString * const QCloudTrackModuleVersion = @"6.4.4";
NSString * const QCloudTrackModuleName = @"QCloudTrack";
@interface QCloudQCloudTrackLoad : NSObject
@end

@implementation QCloudQCloudTrackLoad
+ (void) load
{
    Class cla = NSClassFromString(@"QCloudSDKModuleManager");
    if (cla) {
        NSMutableDictionary* module = [@{
                                 @"name" : QCloudTrackModuleName,
                                 @"version" : QCloudTrackModuleVersion
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
