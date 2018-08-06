//
//  QCloudSandboxPath.m
//  QCloudCore
//
//  Created by erichmzhang(张恒铭) on 2018/7/20.
//

#import "QCloudSandboxPath.h"
#import "QCloudFileUtils.h"
@implementation QCloudSandboxPath
- (NSURL *)fileURL {
    NSString *restoredPath  = QCloudGenerateLocalPath(self.originURL);
    return [NSURL fileURLWithPath:restoredPath];
}
@end
