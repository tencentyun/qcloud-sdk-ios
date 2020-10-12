//
//  QCloudBucketContents+Addition.m
//  QCloudCOSXMLDemo
//
//  Created by garenwang on 2020/5/18.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "QCloudBucketContents+Addition.h"

@implementation QCloudBucketContents (Addition)

-(NSString *)fileSize{
    int count = 0;
    long size = self.size;
    while (size>=1024 && count <6) {
        size = size / 1024;
        count++;
    }
    NSString *countDescription;
    switch (count) {
        case 0:
            countDescription = @"bytes";
            break;
        case 1:
            countDescription = @"KB";
            break;
        case 2:
            countDescription = @"MB";
            break;
        case 3:
            countDescription = @"GB";
            break;
        case 4:
            countDescription = @"TB";
            break;
        case 5:
            countDescription = @"PB";
        default:
            break;
    }
    
    return [NSString stringWithFormat:@"%ld%@",size,countDescription];
}

@end
