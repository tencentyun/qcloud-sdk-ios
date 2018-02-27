//
//  QCloudTestUtility.m
//  Pods-QCloudNewCOSV4Demo
//
//  Created by erichmzhang(张恒铭) on 02/11/2017.
//

#import "QCloudTestUtility.h"
#import "QCloudFileUtils.h"
@implementation QCloudTestUtility

+ (NSString* )tempFileWithSize:(NSInteger)size unit:(QCloudTestFileUnit)unit {
    NSString* file4MBPath = QCloudPathJoin(QCloudTempDir(), [NSUUID UUID].UUIDString);

    if (!QCloudFileExist(file4MBPath)) {
        [[NSFileManager defaultManager] createFileAtPath:file4MBPath contents:[NSData data] attributes:nil];
    }
    NSFileHandle* handler = [NSFileHandle fileHandleForWritingAtPath:file4MBPath];
    [handler truncateFileAtOffset:size*unit];
    [handler closeFile];
    return file4MBPath;
}


+ (void)removeFileAtPath:(NSString*)path {
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}


@end

