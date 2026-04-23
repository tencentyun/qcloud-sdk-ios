#import "QCloudTrackVersion.h"
NSString * const QCloudTrackModuleVersion = @"6.5.5";
NSString * const QCloudTrackModuleName = @"QCloudTrack";
@interface QCloudQCloudTrackLoad : NSObject
@end

@implementation QCloudQCloudTrackLoad
+ (NSString *)moduleName {
    return QCloudTrackModuleName;
}
+ (NSString *)moduleVersion {
    return QCloudTrackModuleVersion;
}
@end
