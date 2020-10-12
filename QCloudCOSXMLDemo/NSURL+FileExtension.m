//
//  NSURL+FileExtension.m
//  QCloudCOSXMLDemo
//
//  Created by erichmzhang(张恒铭) on 26/04/2018.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import "NSURL+FileExtension.h"
#import <QCloudCore/QCloudCore.h>
@implementation NSURL (FileExtension)
- (unsigned long long)fileSizeInContent {
    NSString* path = self.path;
    NSError* error;
    NSDictionary* fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
    if (error) {
        QCloudLogDebug(@"Get file attributes fail! error information %@",error);
    }
    return [fileAttributes fileSize];
}


- (NSString*)fileSizeWithUnit {
    unsigned long long fileSize = [self fileSizeInContent];
    double resultFileSize = fileSize;
    NSInteger count = 0;
    while (resultFileSize > 1024) {
        resultFileSize = resultFileSize/1024;
        count++;
    }
    NSString* UnitName;
    switch (count) {
        case 0:
            UnitName = @"Bytes";
            break;
        case 1:
            UnitName = @"KB";
            break;
        case 2:
            UnitName = @"MB";
            break;
        case 3:
            UnitName = @"GB";
            break;
        case 4:
            UnitName = @"TB";
            break;
        default:
            break;
            
    }
    NSString* result = [NSString stringWithFormat:@"%.2f %@",resultFileSize,UnitName];
    return result;
}

- (double)fileSizeSmallerThan1024 {
    unsigned long long fileSize = [self fileSizeInContent];
    double resultFileSize = fileSize;
    NSInteger count = 0;
    while (resultFileSize > 1024) {
        resultFileSize = resultFileSize/1024;
        count++;
    }
     return resultFileSize;
}

- (NSString*)fileSizeCount {
    unsigned long long fileSize = [self fileSizeInContent];
    double resultFileSize = fileSize;
    NSInteger count = 0;
    while (resultFileSize > 1024) {
        resultFileSize = resultFileSize/1024;
        count++;
    }
    NSString* UnitName;
    switch (count) {
        case 0:
            UnitName = @"Bytes";
            break;
        case 1:
            UnitName = @"KB";
            break;
        case 2:
            UnitName = @"MB";
            break;
        case 3:
            UnitName = @"GB";
            break;
        case 4:
            UnitName = @"TB";
            break;
        default:
            break;
            
    }
    
    return UnitName;
}

@end
